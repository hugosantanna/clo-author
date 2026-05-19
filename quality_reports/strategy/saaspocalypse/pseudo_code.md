# Pseudo-Code — "Another Model, Another SaaSpocalypse"
# Specification-level pseudo-code for main estimation (all four pillars)
# Language: R (target implementation)
# This is a specification, not executable code. The Coder translates this into working R scripts.

---

## Global Setup

```
SET seed = 20260205          # Feb 5, 2026 (focal event date)
LOAD packages: tidyverse, fixest, sandwich, lmtest, MatchIt, Synth,
               HonestDiD, eventStudy (or custom), lubridate, zoo, xts

DEFINE event_date = as.Date("2026-02-05")
DEFINE estimation_start = as.Date("2024-05-18")   # ~[-261] trading days
DEFINE estimation_end   = as.Date("2026-01-31")   # [-11] trading day
DEFINE phase1_start = as.Date("2026-02-05")
DEFINE phase1_end   = as.Date("2026-02-18")
DEFINE phase2_start = as.Date("2026-02-19")
DEFINE phase2_end   = as.Date("2026-04-10")       # trough: IGV Apr 10
DEFINE phase3_start = as.Date("2026-04-13")
DEFINE phase3_end   = as.Date("2026-05-12")
DEFINE opus47_start = as.Date("2026-04-16")
DEFINE opus47_end   = as.Date("2026-04-25")

DEFINE event_window_start = -60   # trading days before event_date (dynamic DiD)
DEFINE event_window_end   = +70   # trading days after event_date (dynamic DiD)
```

---

## Module 0: Data Assembly

```
# 0.1 Load Bloomberg equity returns
equity_raw <- LOAD("data/raw/bloomberg_equity_returns.csv")
# Variables: firm_id, cusip, date, total_return, market_cap, gics_code
# Expected rows: (65 SaaS + 35 non-SaaS) × ~500 trading days ≈ 50,000

# 0.2 Load Syntax SaaS Index constituent list (point-in-time Jan 31, 2026)
saas_universe <- LOAD("data/raw/syntax_saas_index_20260131.csv")
# Variables: firm_id, ticker, company_name, syntax_classification

# 0.3 Load Ken French Data Library (FF5 daily factors)
ff5_factors <- LOAD("data/raw/ff5_daily_factors.csv")
# Variables: date, MKT_RF, SMB, HML, RMW, CMA, RF
# Source: https://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html

# 0.4 Load Compustat firm fundamentals
fundamentals <- LOAD("data/raw/compustat_fundamentals.csv")
# Variables: firm_id, gvkey, datadate, at, ceq, dltt, dlc, ni, revt, gp

# 0.5 Load Bloomberg bond BGN prices
bond_raw <- LOAD("data/raw/bloomberg_bond_bgn.csv")
# Variables: cusip, firm_id, date, bgn_price, coupon, maturity_date,
#            credit_rating, modified_duration, accrued_interest

# 0.6 Load ICE BofA corporate bond index returns
bond_benchmarks <- LOAD("data/raw/ice_bofa_indices.csv")
# Variables: date, C0A3_return, C0A4_return, H0A0_return

# 0.7 Load US Treasury yield curve (interpolated)
treasury_yields <- LOAD("data/raw/us_treasury_yields.csv")
# Variables: date, y1, y2, y3, y5, y7, y10, y20, y30
```

---

## Module 1: Sample Construction

```
# 1.1 Define treatment indicator
equity_panel <- equity_raw %>%
  LEFT JOIN saas_universe ON firm_id ->
  MUTATE(
    SaaS = IF firm_id IN saas_universe THEN 1 ELSE 0,
    control_eligible = IF gics_code == "451030" AND NOT SaaS THEN 1 ELSE 0
  ) %>%
  FILTER(SaaS == 1 OR control_eligible == 1)

# 1.2 Apply data sufficiency filter
# Require >= 420 trading days in the estimation window
firm_counts <- equity_panel %>%
  FILTER(date BETWEEN estimation_start AND estimation_end) %>%
  GROUP_BY(firm_id) %>%
  SUMMARIZE(n_obs = n()) %>%
  FILTER(n_obs >= 420)

equity_panel <- equity_panel %>% FILTER(firm_id IN firm_counts$firm_id)

# LOG: n_saas, n_control, date_range

# 1.3 Merge FF5 factors
equity_panel <- equity_panel %>% LEFT JOIN ff5_factors ON date

# 1.4 Compute excess returns
equity_panel <- equity_panel %>%
  MUTATE(
    excess_return = total_return - RF,
    trading_day_rel = BUSINESS_DAY_DIFFERENCE(date, event_date)  # signed offset
  )

# 1.5 Compute pre-event market cap weights
market_cap_weights <- equity_panel %>%
  FILTER(date == as.Date("2026-01-31")) %>%
  SELECT(firm_id, market_cap) %>%
  MUTATE(weight = market_cap / sum(market_cap, na.rm = TRUE))
```

---

## Module 2: Pillar 1 — FF5 Event Study

```
# 2.1 Estimate FF5 model for each firm over estimation window
estimation_data <- equity_panel %>%
  FILTER(date BETWEEN estimation_start AND estimation_end)

ff5_params <- FOR EACH firm_id IN unique(estimation_data$firm_id):
  firm_data <- estimation_data %>% FILTER(firm_id == current_firm)
  model <- OLS(excess_return ~ MKT_RF + SMB + HML + RMW + CMA, data = firm_data)
  STORE: alpha_hat, beta_hat[1:5], sigma_hat, estimation_n

# LOG: median R-squared, median sigma_hat across firms

# 2.2 Compute abnormal returns over event windows
ar_data <- equity_panel %>%
  FILTER(date BETWEEN phase1_start AND phase3_end) %>%
  LEFT JOIN ff5_params ON firm_id %>%
  MUTATE(
    expected_return = alpha_hat + beta_MKT * MKT_RF + beta_SMB * SMB +
                      beta_HML * HML + beta_RMW * RMW + beta_CMA * CMA,
    AR = excess_return - expected_return,
    SAR = AR / sigma_hat  # standardized abnormal return
  )

# 2.3 Compute CARs by phase
car_by_firm <- ar_data %>%
  MUTATE(
    phase = CASE_WHEN(
      date BETWEEN phase1_start AND phase1_end ~ "Phase1",
      date BETWEEN phase2_start AND phase2_end ~ "Phase2",
      date BETWEEN phase3_start AND phase3_end ~ "Phase3",
      TRUE ~ "Other"
    )
  ) %>%
  FILTER(phase != "Other") %>%
  GROUP_BY(firm_id, SaaS, phase) %>%
  SUMMARIZE(
    CAR = sum(AR),
    CSAR = sum(SAR),
    n_days = n()
  )

# Also compute short windows: [-1,+1], [-3,+3], [0,+5], [0,+10]
# ... analogous code with trading_day_rel filter

# 2.4 Aggregate CARs (EW and VW)
ew_vw_cars <- car_by_firm %>%
  LEFT JOIN market_cap_weights ON firm_id %>%
  GROUP_BY(SaaS, phase) %>%
  SUMMARIZE(
    mean_CAR_EW = mean(CAR),
    mean_CAR_VW = weighted.mean(CAR, weight),
    n_firms = n()
  )

# 2.5 Test statistics

# KP-BMP test (PRIMARY)
# Step 1: Compute average pairwise SAR correlation in estimation window
sar_estimation <- estimation_data %>%
  LEFT JOIN ff5_params ON firm_id %>%
  MUTATE(SAR_est = (excess_return - expected_return) / sigma_hat)

rho_bar <- MEAN(PAIRWISE_CORRELATION(sar_estimation$SAR_est, by = firm_id))

# Step 2: BMP statistic
bmp_stat <- MEAN(car_by_firm$CSAR) / (SD(car_by_firm$CSAR) / SQRT(N))

# Step 3: KP correction
kp_stat <- bmp_stat / SQRT(1 + (N - 1) * rho_bar)
kp_pvalue <- 2 * pt(abs(kp_stat), df = N - 1, lower.tail = FALSE)

# Corrado (1989) rank test
# Rank each firm's daily AR within its full estimation+event period
rank_ar <- equity_panel %>%
  GROUP_BY(firm_id) %>%
  MUTATE(K_it = rank(AR))
# Compute rank test statistic (see Corrado 1989, eq. 3)
corrado_stat <- COMPUTE_CORRADO_STATISTIC(rank_ar, event_window)

# Wilcoxon signed-rank test
wilcox_result <- wilcox.test(car_by_firm$CAR[car_by_firm$phase == "Phase1"],
                              mu = 0, alternative = "less")

# Permutation inference (Andrews-Farboodi adaptation)
permutation_pvalue <- function(true_CAR, n_perms = 5000) {
  perm_CARs <- vector(length = n_perms)
  FOR i IN 1:n_perms:
    pseudo_date <- SAMPLE(estimation_window_dates, size = 1,
                          exclude = [event_date - 10 : event_date])
    perm_CARs[i] <- COMPUTE_CAR(pseudo_date, same_phase_length, ff5_params)
  p_val <- mean(abs(perm_CARs) >= abs(true_CAR))
  RETURN p_val
}

# 2.6 Robustness: FF3 and Carhart 4-factor
# Repeat steps 2.1-2.5 using:
#   FF3: excess_return ~ MKT_RF + SMB + HML
#   Carhart: excess_return ~ MKT_RF + SMB + HML + MOM
# (MOM from Ken French momentum factors file)
```

---

## Module 3: Pillar 2 — Cross-Sectional Regression

```
# 3.1 Assemble firm characteristics
firm_chars <- fundamentals %>%
  FILTER(datadate <= as.Date("2026-01-31")) %>%
  GROUP_BY(firm_id) %>%
  ARRANGE(DESC(datadate)) %>%
  SLICE(1) %>%  # most recent quarter
  MUTATE(
    log_size   = LOG(market_cap),
    ROA        = ni / at,
    Lev        = (dltt + dlc) / at,
    BTM        = ceq / market_cap,
    GM         = gp / revt
  )

# ARR growth and NDR: loaded from supplementary file (Bloomberg + manual filings)
saas_metrics <- LOAD("data/raw/saas_metrics_manual.csv")
# Variables: firm_id, ARR_growth, NDR, data_source, missing_flag

firm_chars <- firm_chars %>%
  LEFT JOIN saas_metrics ON firm_id %>%
  LEFT JOIN car_by_firm ON (firm_id, phase) %>%
  FILTER(SaaS == 1)  # within-SaaS only

# LOG: missingness rates for ARR_growth, NDR

# 3.2 Phase-specific OLS regressions
FOR phase_k IN c("Phase1", "Phase2", "Phase3"):
  phase_data <- firm_chars %>% FILTER(phase == phase_k)

  model_k <- OLS(
    CAR ~ log_size + ROA + Lev + BTM + ARR_growth + GM + NDR,
    data = phase_data
  )

  # HC3 robust standard errors
  se_robust <- COEFTEST(model_k, vcov = HC3)

  # Report: coefficients, HC3 SE, t-stats, p-values (unadjusted and Bonferroni)
  bonferroni_alpha <- 0.05 / (7 * 3)  # 7 coefficients × 3 phases
  sig_bonferroni <- p_values < bonferroni_alpha

  STORE: model_k, se_robust, sig_bonferroni

# 3.3 Quartile heterogeneity plots
# For NDR, ARR_growth, log_size: compute quartile breakpoints
# For each quartile, report mean Phase1/Phase2/Phase3 CAR
# Plot as bar chart with 95% CI
```

---

## Module 4: Pillar 3 — Matched-Sample DiD

```
# 4.1 Construct DiD panel
# Use full equity_panel, not just estimation window
did_panel <- equity_panel %>%
  MUTATE(
    Phase1   = IF date BETWEEN phase1_start AND phase1_end THEN 1 ELSE 0,
    Phase2   = IF date BETWEEN phase2_start AND phase2_end THEN 1 ELSE 0,
    Phase3   = IF date BETWEEN phase3_start AND phase3_end THEN 1 ELSE 0,
    Opus47   = IF date BETWEEN opus47_start AND opus47_end THEN 1 ELSE 0,
    post_any = IF date >= phase1_start THEN 1 ELSE 0
  )

did_panel <- did_panel %>%
  LEFT JOIN market_cap_weights ON firm_id %>%
  LEFT JOIN firm_chars[c("firm_id", "log_size", "BTM", "Lev")] ON firm_id

# 4.2 Static phase-DiD (primary summary regression)
# Use fixest::feols for firm + day FE with cluster-robust SE

static_did <- feols(
  excess_return ~ (SaaS:Phase1) + (SaaS:Phase2) + (SaaS:Phase3) + (SaaS:Opus47) |
                  firm_id + date,
  data    = did_panel,
  weights = did_panel$weight,
  cluster = ~firm_id
)

REPORT: coeftable(static_did)   # beta_1, beta_2, beta_3, beta_4 + cluster-robust SE

# 4.3 Dynamic event-time DiD (primary visual result)
# Create event-time relative variable
did_panel <- did_panel %>%
  MUTATE(event_time = trading_day_rel) %>%
  MUTATE(event_time = CLAMP(event_time, -60, +70)) %>%
  MUTATE(event_time = IF event_time == -1 THEN NA ELSE event_time)  # omit s=-1

# Create saturated interaction (for s in [-60, +70], s != -1)
dynamic_did <- feols(
  excess_return ~ i(event_time, SaaS, ref = -1) | firm_id + date,
  data    = did_panel,
  weights = did_panel$weight,
  cluster = ~firm_id
)

# Plot: iplot(dynamic_did) or manual ggplot of beta_s with 95% CI
# Expected pattern: flat pre-event, negative Phase1/Phase2, partial reversal Phase3

# 4.4 Pre-trend formal test
pre_trend_F <- JOINT_TEST(
  dynamic_did,
  hypotheses = [beta_{s} == 0 for s in -60:-2]
)
REPORT: F-statistic, df, p-value

# 4.5 Rambachan-Roth honest confidence intervals
# Using HonestDiD R package
betahat  <- coef(dynamic_did)[event_time_indices]
sigma_hat <- vcov(dynamic_did)[event_time_indices, event_time_indices]

honest_ci <- HonestDiD::createSensitivityResults(
  betahat  = betahat,
  sigma    = sigma_hat,
  numPrePeriods  = 60,
  numPostPeriods = 70,
  alpha = 0.05,
  Mvec = seq(0, 0.01, by = 0.001)  # range of allowed pre-trend slope
)
REPORT: sensitivity plot of confidence intervals vs. M

# 4.6 Propensity score matching
match_vars <- c("log_size", "BTM", "Lev", "ARR_growth", "GM")

# 1:1 logit PSM
psm_1to1 <- matchit(
  SaaS ~ log_size + BTM + Lev + ARR_growth + GM,
  data   = firm_chars,
  method = "nearest",
  distance = "logit",
  ratio  = 1,
  caliper = 0.2
)

# Mahalanobis matching
psm_mah <- matchit(
  SaaS ~ log_size + BTM + Lev,
  data   = firm_chars,
  method = "nearest",
  distance = "mahalanobis"
)

# 1:3 logit PSM
psm_1to3 <- matchit(
  SaaS ~ log_size + BTM + Lev + ARR_growth + GM,
  data   = firm_chars,
  method = "nearest",
  distance = "logit",
  ratio  = 3,
  replace = TRUE
)

# Check balance (SMD table)
FOR each match_spec IN [psm_1to1, psm_mah, psm_1to3]:
  summary_match <- summary(match_spec)
  ASSERT all(abs(summary_match$sum.matched$Std.Mean.Diff) < 0.1)
  LOG: SMD table pre/post matching

# Re-run static DiD on each matched sample
FOR each match_spec IN [psm_1to1, psm_mah, psm_1to3]:
  matched_ids <- get.matched.ids(match_spec)
  matched_panel <- did_panel %>% FILTER(firm_id IN matched_ids)
  matched_did <- feols(
    excess_return ~ (SaaS:Phase1) + (SaaS:Phase2) + (SaaS:Phase3) | firm_id + date,
    data = matched_panel, cluster = ~firm_id
  )
  STORE: coeftable(matched_did)

# 4.7 Synthetic control method
# Aggregate SaaS cohort return (EW)
saas_agg <- equity_panel %>%
  FILTER(SaaS == 1) %>%
  GROUP_BY(date) %>%
  SUMMARIZE(R_SaaS = mean(excess_return))

# Control firm returns as donor pool
control_wide <- equity_panel %>%
  FILTER(SaaS == 0) %>%
  PIVOT_WIDER(id_cols = date, names_from = firm_id, values_from = excess_return)

# Pre-event data for optimization
pre_event <- FILTER(date < event_date)

# Synthetic control optimization (Synth package or custom)
synth_out <- synth(
  Y1plot = saas_agg$R_SaaS[pre_event],
  Y0plot = as.matrix(control_wide[pre_event, -date]),
  Z1 = saas_agg$R_SaaS[pre_event],    # predictors = pre-event returns
  Z0 = as.matrix(control_wide[pre_event, -date])
)

# Compute gap
sc_gap <- saas_agg$R_SaaS - (control_wide %*% synth_out$solution.w)
PLOT: sc_gap over time (zero pre-event, gap post-event)

# Permutation inference for SCM
sc_gaps_perm <- FOR EACH control_firm j:
  synth_j <- synth(Y1 = control_firm_j_returns, Y0 = remaining_controls)
  gap_j   <- control_firm_j_returns - (remaining_controls %*% synth_j$solution.w)
  STORE: gap_j

sc_pvalue <- mean(POST_PERIOD_MSPE(sc_gaps_perm) >= POST_PERIOD_MSPE(sc_gap))
REPORT: sc_gap plot with perm distribution; sc_pvalue

# 4.8 Wild cluster bootstrap
wcb_result <- boottest(
  object   = static_did,
  clustid  = ~firm_id,
  param    = "SaaS:Phase1",
  B        = 9999,
  bootcluster = "firm_id",
  type     = "rademacher"
)
REPORT: wcb_result$p_val, wcb_result$conf_int
```

---

## Module 5: Pillar 4 — Corporate Bond Event Study

```
# 5.1 Bond sample construction
bond_panel <- bond_raw %>%
  FILTER(
    NOT convertible AND NOT putable AND NOT callable_within_event,
    coupon > 0,
    maturity_date > as.Date("2026-02-05") + 365,
    credit_rating IN c("AAA","AA","A","BBB","BB","B")
  )

# Count pre-event observations
bond_obs_count <- bond_panel %>%
  FILTER(date BETWEEN estimation_start AND estimation_end) %>%
  GROUP_BY(cusip) %>%
  SUMMARIZE(n_bgn = sum(!is.na(bgn_price))) %>%
  FILTER(n_bgn >= 50)

bond_panel <- bond_panel %>% FILTER(cusip IN bond_obs_count$cusip)

n_saas_bonds   <- COUNT(bond_panel WHERE firm SaaS == 1)
n_control_bonds <- COUNT(bond_panel WHERE firm SaaS == 0)
LOG: n_saas_bonds, n_control_bonds, proportion_days_zero_return

IF n_saas_bonds < 8:
  ROUTE: apply SCM bond procedure (see below)
  FLAG: "Small bond sample — SCM results primary"

# 5.2 Compute bond returns
treasury_interp <- INTERPOLATE(treasury_yields, maturity = bond_panel$remaining_maturity)

bond_panel <- bond_panel %>%
  GROUP_BY(cusip) %>%
  ARRANGE(date) %>%
  MUTATE(
    raw_return = (bgn_price - LAG(bgn_price) + accrued_interest_daily) / LAG(bgn_price),
    duration_adj = modified_duration * DELTA(treasury_interp),
    # Select benchmark by credit rating
    benchmark_return = CASE_WHEN(
      credit_rating IN c("AAA","AA","A") ~ C0A3_return,
      credit_rating == "BBB"            ~ C0A4_return,
      credit_rating IN c("BB","B","<B") ~ H0A0_return
    ),
    ABR = raw_return - benchmark_return - duration_adj
  )

# 5.3 Estimate pre-event sigma for each bond
bond_sigma <- bond_panel %>%
  FILTER(date BETWEEN estimation_start AND estimation_end) %>%
  GROUP_BY(cusip) %>%
  SUMMARIZE(sigma_ABR = sd(ABR, na.rm = TRUE))

bond_panel <- bond_panel %>% LEFT JOIN bond_sigma ON cusip %>%
  MUTATE(ASR = ABR / sigma_ABR)

# 5.4 Compute composite ASR (EGY 2015)
# For each bond, for each event window [t1, t2] with extensions a, b in {0,1,2,3}
composite_ASR <- function(bond_asrs, t1, t2) {
  windows <- EXPAND_GRID(a = 0:3, b = 0:3)
  window_means <- FOR EACH (a, b) IN windows:
    MEAN(bond_asrs[date BETWEEN (t1 - a) AND (t2 + b)])
  RETURN MEAN(window_means)
}

car_bonds_by_firm <- bond_panel %>%
  GROUP_BY(cusip, firm_id, SaaS) %>%
  SUMMARIZE(
    comp_ASR_Phase1 = composite_ASR(ASR, phase1_start, phase1_end),
    comp_ASR_Phase2 = composite_ASR(ASR, phase2_start, phase2_end),
    comp_ASR_Phase3 = composite_ASR(ASR, phase3_start, phase3_end),
    comp_ASR_short1 = composite_ASR(ASR, event_date - 1, event_date + 1),
    comp_ASR_short3 = composite_ASR(ASR, event_date - 3, event_date + 3)
  )

# 5.5 Test statistics (bonds)
FOR phase_k IN c("Phase1", "Phase2", "Phase3"):
  saas_bond_ASRs <- car_bonds_by_firm$comp_ASR_{phase_k}[SaaS == 1]

  # Wilcoxon signed-rank (primary)
  wilcox_bond <- wilcox.test(saas_bond_ASRs, mu = 0, alternative = "less")

  # KP-corrected t-test
  rho_bar_bond <- MEAN_PAIRWISE_CORRELATION(saas_bond_ASRs)
  bmp_bond <- mean(saas_bond_ASRs) / (sd(saas_bond_ASRs) / sqrt(n_saas_bonds))
  kp_bond  <- bmp_bond / sqrt(1 + (n_saas_bonds - 1) * rho_bar_bond)
  kp_bond_pvalue <- 2 * pt(abs(kp_bond), df = n_saas_bonds - 1, lower.tail = FALSE)

  # Permutation inference
  perm_pvalue_bond <- permutation_pvalue(true_CAR = mean(saas_bond_ASRs), n_perms = 5000)

  REPORT: wilcox_bond$p.value, kp_bond_pvalue, perm_pvalue_bond,
          mean_ASR_basis_points, 95_CI

# 5.6 SCM contingency (if n_saas_bonds < 8)
IF n_saas_bonds < 8:
  # Aggregate SaaS bond returns
  saas_bond_agg <- bond_panel %>% FILTER(SaaS == 1) %>%
    GROUP_BY(date) %>% SUMMARIZE(R_bond_SaaS = mean(ABR))

  synth_bond <- synth(
    Y1 = saas_bond_agg[pre_event],
    Y0 = CONTROL_BOND_MATRIX[pre_event]
  )
  bond_gap <- saas_bond_agg$R_bond_SaaS - (CONTROL_BOND_MATRIX %*% synth_bond$solution.w)
  PLOT: bond_gap over time
  REPORT: pre-event RMSPE, post-event gap magnitude (basis points)
```

---

## Module 6: Robustness — Phase Boundary Validation

```
# 6.1 Quandt-Andrews supremum-Wald test
# On the SaaS minus non-SaaS return spread
spread_data <- equity_panel %>%
  GROUP_BY(date, SaaS) %>%
  SUMMARIZE(mean_return = mean(excess_return)) %>%
  PIVOT_WIDER(names_from = SaaS, values_from = mean_return) %>%
  MUTATE(spread = `1` - `0`) %>%
  FILTER(date BETWEEN phase1_start AND phase3_end)

# Test for single structural break (null: no break)
qa_test <- supLM(spread ~ 1, data = spread_data, from = 0.15, to = 0.85)
REPORT: qa_stat, break_date_qa, p_value_qa

# Compare break_date_qa to researcher-specified phase2_end = Apr 10

# 6.2 Bai-Perron multiple structural break test
bp_test <- breakpoints(spread ~ 1, data = spread_data, breaks = 2:4)
REPORT: bp_test$breakpoints (dates), bp_test$RSS, optimal_n_breaks

# Compare to researcher-specified Phase1/Phase2/Phase3 boundaries

# 6.3 Boundary robustness: shift by ±1 and ±3 trading days
FOR delta IN c(-3, -1, +1, +3):
  shifted_boundaries <- SHIFT_BOUNDARIES(delta)
  rerun static_did with shifted_boundaries
  STORE: beta_1, beta_2, beta_3 for each delta

REPORT: table of beta estimates across boundary shifts
```

---

## Module 7: Robustness — Confounding Events

```
# 7.1 Tariff announcement controls
tariff_dates <- LOAD("data/raw/tariff_announcement_dates.csv")
# Source: Bloomberg BETS (Bloomberg Economic Tariff Surprise index) or manual collection

did_panel_confound <- did_panel %>%
  LEFT JOIN tariff_dates ON date %>%
  MUTATE(tariff_event = IF date IN tariff_dates THEN 1 ELSE 0)

static_did_tariff <- feols(
  excess_return ~ (SaaS:Phase1) + (SaaS:Phase2) + (SaaS:Phase3) +
                  (SaaS:Opus47) + (SaaS:tariff_event) | firm_id + date,
  data = did_panel_confound, cluster = ~firm_id
)
REPORT: compare beta_1, beta_2, beta_3 to baseline static_did

# 7.2 Other AI release controls
ai_release_dates <- LIST(
  GPT5_date = as.Date("2026-XX-XX"),      # to be confirmed from public announcements
  Gemini25_date = as.Date("2026-XX-XX"),  # to be confirmed
  DeepSeek_R2_date = as.Date("2026-XX-XX")  # if applicable
)

did_panel_ai <- did_panel %>%
  MUTATE(other_ai_event = IF date IN ai_release_dates THEN 1 ELSE 0)

static_did_ai <- feols(
  excess_return ~ (SaaS:Phase1) + (SaaS:Phase2) + (SaaS:Phase3) +
                  (SaaS:Opus47) + (SaaS:other_ai_event) | firm_id + date,
  data = did_panel_ai, cluster = ~firm_id
)
REPORT: compare beta_1, beta_2, beta_3 to baseline
```

---

## Module 8: Falsification Tests

```
# 8.1 Pre-event placebo DiD
# Use Aug 2024 – Jan 2026 window; set placebo event date in the middle
placebo_event_date <- as.Date("2025-04-01")  # arbitrary mid-estimation date
placebo_panel <- equity_panel %>%
  FILTER(date BETWEEN as.Date("2024-08-01") AND as.Date("2026-01-31")) %>%
  MUTATE(
    PlaceboPhase1 = IF date BETWEEN placebo_event_date AND (placebo_event_date + 10) THEN 1 ELSE 0,
    PlaceboPhase2 = IF date BETWEEN (placebo_event_date + 11) AND (placebo_event_date + 47) THEN 1 ELSE 0
  )

placebo_did <- feols(
  excess_return ~ (SaaS:PlaceboPhase1) + (SaaS:PlaceboPhase2) | firm_id + date,
  data = placebo_panel, cluster = ~firm_id
)
REPORT: coefficients should be zero (null placebo check)

# 8.2 Unrelated sector placebo
# Apply same DiD to Healthcare Technology vs. S&P 500 Healthcare
healthcare_data <- LOAD("data/raw/bloomberg_equity_healthcare.csv")
healthcare_panel <- healthcare_data %>%
  MUTATE(
    HealthIT = IF gics_code == "351020" THEN 1 ELSE 0,
    SaaS = HealthIT  # rename for DiD compatibility
  ) %>%
  MUTATE(Phase1 = ..., Phase2 = ..., Phase3 = ...)  # same phase dummies

placebo_sector_did <- feols(
  excess_return ~ (SaaS:Phase1) + (SaaS:Phase2) + (SaaS:Phase3) | firm_id + date,
  data = healthcare_panel, cluster = ~firm_id
)
REPORT: coefficients should be zero

# 8.3 Within-SaaS: Non-AI-addressable product categories
# Classify SaaS firms by whether their core product is in Claude Opus 4.6 capability frontier
# Those outside the frontier should show near-zero Phase 1 CARs
frontier_saas <- saas_firms WHERE product_in_frontier == 1
nonfrontier_saas <- saas_firms WHERE product_in_frontier == 0

compare_CARs(frontier_saas, nonfrontier_saas, phase = "Phase1")
# Expected: frontier_saas Phase1 CAR < nonfrontier_saas Phase1 CAR (less negative)
```

---

## Module 9: Output Tables and Figures

```
# TABLE 1: Sample characteristics
# Columns: N, Mean CAR (EW/VW) by Phase, Median CAR, SD
# Rows: SaaS firms, Non-SaaS software firms

# TABLE 2: FF5 event study results (Pillar 1)
# Rows: Short windows [-1,+1], [-3,+3], [0,+5], [0,+10]; Phase 1, Phase 2, Phase 3; Full Arc
# Columns: Mean CAR (EW), Mean CAR (VW), KP-BMP stat, p-value, Corrado stat, Permutation p

# TABLE 3: Phase-DiD estimates (Pillar 3) — main table
# Rows: SaaS×Phase1, SaaS×Phase2, SaaS×Phase3, SaaS×Opus47
# Columns: Baseline DiD, PSM 1:1, PSM Mahalanobis, PSM 1:3

# TABLE 4: Cross-sectional regression (Pillar 2)
# 3 columns = 3 phases; rows = 7 regressors; HC3 SE; Bonferroni flags

# TABLE 5: Bond event study (Pillar 4)
# Rows: Phase 1, Phase 2, Phase 3, short windows
# Columns: Mean ASR, Wilcoxon p, KP-t p, Permutation p

# TABLE 6: Robustness summary
# Rows: each robustness check; Columns: Phase1 beta, Phase2 beta, Phase3 beta

# FIGURE 1: Dynamic event-time DiD plot (PRIMARY VISUAL RESULT)
# beta_s vs. trading day s in [-60, +70]; shaded phase bands; 95% CI; reference line at 0
# Annotate: event_date, phase boundaries, Oracle RPO date, Opus 4.7 date

# FIGURE 2: Synthetic control gap
# SaaS cohort return vs. synthetic control; vertical line at event_date

# FIGURE 3: Within-SaaS heterogeneity (Phase 1 CAR by NDR quartile and ARR growth quartile)
```

---

*End of pseudo-code specification.*
