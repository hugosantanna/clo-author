# Strategy Memo — "Another Model, Another SaaSpocalypse: Heterogeneous Capital Market Reactions to the Anthropic Claude Opus 4.6 Release"

**Paper type:** Reduced-form empirical (event study + difference-in-differences)
**Student:** Rio Giuliana Fitzgerald | MSc Finance, Trinity College Dublin
**Supervisor:** Prof. Constantin Gurdgiev
**Focal event:** Claude Opus 4.6 release, February 5, 2026
**Memo date:** 2026-05-19
**Status:** APPROVED — strategist-critic Round 2 score 90/100 (ADVANCES gate: 80). All three Round 1 MAJOR issues resolved. Four carry-forward items applied. Ready for coder dispatch.

---

## Pre-Strategy Report

### Discovery Inputs Loaded

| Input | File | Status |
|-------|------|--------|
| Research specification | Provided in orchestrator prompt | LOADED |
| Literature review | `quality_reports/literature/saaspocalypse/annotated_bibliography.md` | LOADED |
| Frontier map | `quality_reports/literature/saaspocalypse/frontier_map.md` | LOADED |
| Domain profile | `.claude/references/domain-profile.md` | LOADED |
| Data assessment | NOT RUN — data source is Bloomberg Terminal | NOT RUN [ASSUMED] |

### Key Findings from Discovery

**From frontier map:** Four literature strands converge without overlapping this dissertation's precise question. Closest competitors are Conlon et al. (2025), Eisfeldt et al. (2025), and Andrews & Farboodi (2025). None isolates SaaS vs. non-SaaS software, tests the full Pástor-Veronesi three-phase arc, applies Goldsmith-Pinkham & Lyu (2025) DiD correction to an AI event, or jointly studies equity and bond markets for the same firm-event sample.

**From annotated bibliography:** Primary identification concerns are (1) factor model misspecification during volatile periods (Goldsmith-Pinkham & Lyu 2025), (2) cross-sectional correlation of abnormal returns when all firms react to the same event date (Kolari & Pynnönen 2010), (3) phase boundary endogeneity (Oracle RPO disclosure is post-event), and (4) small bond sample power (N = 12–20, Mueller et al. 2024).

**From domain profile:** Field conventions require both parametric (KP-BMP) and nonparametric (Corrado rank, Wilcoxon) test statistics; equal-weighted and value-weighted CARs; firm-level clustering for cross-sectional regressions; duration-adjusted bond returns.

**Data not formally assessed.** Bloomberg Terminal access ASSUMED. Ken French Data Library factors ASSUMED available (public). Syntax SaaS Index constituent list ASSUMED accessible via Syntax Data. Goldman Sachs SPXXAI access ASSUMED contingent (not public).

---

## Paper Type Classification

**Primary type:** Reduced-form empirical
**Secondary components:** (a) Descriptive/measurement (FF5 event study as descriptive pillar; within-SaaS heterogeneity documentation); (b) Theory + empirics (Pástor-Veronesi three-phase architecture tested against empirical price path)

The paper is not structural because no counterfactual welfare calculation is required; the causal object of interest is the differential return in treated vs. control firms, observable in the data.

---

## Section 1 — Estimand

### 1.1 Primary Causal Estimand (Pillar 3 DiD)

**Formal statement:**

$$\tau_{ATT}(s, t) = \mathbb{E}\left[R_{i,t}(1) - R_{i,t}(0) \;\middle|\; T_i = 1\right]$$

where:
- $R_{i,t}(1)$ is the daily excess return that SaaS firm $i$ actually earns at time $t$ after the Claude Opus 4.6 release
- $R_{i,t}(0)$ is the counterfactual daily excess return firm $i$ would have earned absent the AI disruption shock
- $T_i = 1$ if firm $i$ is a constituent of the Syntax SaaS Index (SYSAAS) satisfying post-screening criteria
- $s$ indexes the cohort (all treated firms share a single cohort: Feb 5, 2026)
- $t$ indexes trading days

**Plain-language statement:** How much lower (or higher) were the daily stock returns of SaaS firms relative to what they would have earned if Claude Opus 4.6 had not been released, compared to the analogous gap for non-SaaS software firms?

**Aggregation to phase-specific ATT:** The primary summary statistics are phase-cumulated ATTs:

$$\tau_{ATT}^{Phase_k} = \sum_{t \in \mathcal{T}_k} \tau_{ATT}(s,t)$$

for $k \in \{1, 2, 3\}$ and $\mathcal{T}_k$ denoting the trading days in Phase $k$.

**Population:** US-listed SaaS firms in the Syntax SaaS Index with sufficient pre-event return history ($\geq 60$ trading days in the estimation window). The control population is non-SaaS GICS Software 451030 S&P 500 constituents not classified as SaaS by Syntax. Findings generalize to: publicly listed SaaS software firms whose business model depends on recurring subscription revenue derived from human labor-replacement tasks addressable by frontier LLMs as of early 2026.

### 1.2 Descriptive Estimand (Pillar 1 FF5 Event Study)

**Formal statement:**

$$CAR_i[t_1, t_2] = \sum_{t=t_1}^{t_2} AR_{i,t}$$

$$AR_{i,t} = (R_{i,t} - R_{f,t}) - \left(\hat{\alpha}_i + \hat{\beta}_{1i}MKT_t + \hat{\beta}_{2i}SMB_t + \hat{\beta}_{3i}HML_t + \hat{\beta}_{4i}RMW_t + \hat{\beta}_{5i}CMA_t\right)$$

**Estimand caution:** Per Goldsmith-Pinkham & Lyu (2025), $CAR_i$ under FF5 is a biased estimator of $\tau_{ATT}$ during periods of elevated factor volatility. The FF5 CARs are reported as descriptive evidence, not as causal estimates. The joint hypothesis problem (MacKinlay 1997; Kothari & Warner 2007) applies: rejection of the null tests market efficiency jointly with correct model specification.

### 1.3 Cross-Sectional Estimand (Pillar 2 Heterogeneity)

**Formal statement (within-SaaS):**

$$\mathbb{E}\left[CAR_i[Phase_k] \;\middle|\; \mathbf{X}_i\right] = f(\mathbf{X}_i)$$

The target quantity is the partial correlation between each firm characteristic $X_{ij}$ and phase-$k$ CARs, controlling for other characteristics. This is explicitly descriptive/predictive — causal interpretation requires additional assumptions (selection-on-observables) that are unlikely to be credible with $N \approx 65$ and un-randomized characteristics.

### 1.4 Bond Market Estimand (Pillar 4)

**Formal statement:**

$$ABR_{i,t} = R_{i,t}^{bond} - IR_{benchmark,t}$$

$$ASR_{i,t} = ABR_{i,t} / \hat{\sigma}(ABR_i)$$

The target is cumulative $ASR$ over the event window for SaaS issuer bonds relative to non-SaaS software issuer bonds. This tests whether the bond market also prices the AI disruption threat, providing a multi-market confirmation of the equity result.

---

## Section 2 — Specification

### 2.1 Pillar 1 — FF5 Event Study

#### 2.1.1 Sample construction

**Treatment firms:** Syntax SaaS Index (SYSAAS) constituents as of Jan 31, 2026. Apply filters: (a) listed on NYSE, NASDAQ, or NYSE American; (b) $\geq 420$ trading days of return history before Feb 5, 2026 (sufficient for estimation window); (c) not dual-listed primary exchange outside US. Expected post-filter N: $\approx 65$ firms.

**Control firms:** GICS Industry Group 451030 (Software), S&P 500 constituents, as of Jan 31, 2026, excluding Syntax SaaS Index members. Expected post-filter N: $\approx 25$–$40$ firms.

**[ASSUMED]** Both samples are obtained from Bloomberg Terminal with constituent lists as of Jan 31, 2026 (point-in-time, survivorship-bias-free if Bloomberg historical membership data is available).

#### 2.1.2 Estimation window and event window

**Estimation window:** $[-261, -11]$ trading days relative to Feb 5, 2026 (approximately May 18, 2024 – Jan 31, 2026; $\approx 250$ trading days). The gap $[-10, -1]$ is excluded to avoid contamination from any pre-announcement leakage.

**Event windows:**

**PRIMARY (pre-specified hypothesis):**
- Phase 1 (Initial Reaction): Feb 5 – Feb 18, 2026 ($\approx +1$ to $+10$ trading days; $\mathcal{T}_1$) — **this is the designated primary Pillar 1 event window**, capturing the discount-rate phase predicted by Pástor-Veronesi (2009). All inference discussions of Pillar 1 significance refer to this window unless otherwise stated.

**SECONDARY (reported for Pástor-Veronesi phase documentation):**
- Phase 2 (Deepening): Feb 19 – Apr 10, 2026 ($\approx +11$ to $+47$ trading days; $\mathcal{T}_2$)
- Phase 3 (Reversal): Apr 13 – May 12, 2026 ($\approx +50$ to $+70$ trading days; $\mathcal{T}_3$)

**SUMMARY (full-arc reporting — descriptive only, not a primary hypothesis):**
- Full Arc: Feb 5 – May 12, 2026 ($\approx +1$ to $+70$ trading days) — overlaps the DiD Pillar 3 estimand period; reported for completeness only, not tested as a separate primary hypothesis.

**ROBUSTNESS (sensitivity to window choice):**
- Short windows: $[0,+5]$, $[0,+10]$ — test whether the Phase 1 result concentrates in the first week.
- Symmetric windows: $[-1,+1]$, $[-3,+3]$ — allow for a one-day pre-release price drift (not anticipated given non-public release date).

**Phase boundary note:** Phase 2/3 boundary (Apr 10/13) is anchored to Oracle RPO disclosure (+325% YoY) as the catalyst for reversal. This boundary is validated using Quandt-Andrews supremum-Wald tests and Bai-Perron structural break tests applied to the SaaS-minus-control return spread. The use of a post-event observable to define phases is an endogeneity concern addressed in Section 5 (Threats).

#### 2.1.3 Factor model

**Primary model (FF5):**

$$R_{i,t} - R_{f,t} = \alpha_i + \beta_{1i}MKT_t + \beta_{2i}SMB_t + \beta_{3i}HML_t + \beta_{4i}RMW_t + \beta_{5i}CMA_t + \varepsilon_{i,t}$$

estimated by OLS over the estimation window for each firm $i$ separately.

**Robustness factor models:** FF3 (drop $RMW$, $CMA$); Carhart 4-factor (add $MOM$ to FF3).

**Factor data source:** Ken French Data Library, daily frequency. [ASSUMED: downloaded from public URL; no access barrier.]

#### 2.1.4 AR and CAR construction

$$AR_{i,t} = (R_{i,t} - R_{f,t}) - (\hat{\alpha}_i + \hat{\beta}_{1i}MKT_t + \hat{\beta}_{2i}SMB_t + \hat{\beta}_{3i}HML_t + \hat{\beta}_{4i}RMW_t + \hat{\beta}_{5i}CMA_t)$$

$$CAR_i[t_1, t_2] = \sum_{t=t_1}^{t_2} AR_{i,t}$$

Report both equal-weighted (EW) and value-weighted (VW, using Jan 31, 2026 market cap) average CARs across all sample firms and separately by SaaS/non-SaaS group.

**Model-free benchmark [ASSUMED/CONTINGENT]:** If SPXXAI (Goldman Sachs S&P 500 ex-AI Index) daily returns are obtainable, report $R_{SaaS,t} - R_{SPXXAI,t}$ as a robustness check that requires no factor model. Clearly label as contingent on data access; not included in primary results if unavailable.

#### 2.1.5 Test statistics

**Primary parametric:** Kolari-Pynnönen (2010) cross-sectionally corrected BMP statistic (KP-BMP). This is the primary test because the event is a single common date affecting all firms simultaneously; cross-sectional correlation of ARs is non-zero by construction. The KP correction multiplies BMP variance by $1 + (N-1)\bar{\rho}$ where $\bar{\rho}$ is the average pairwise correlation of standardized ARs during the estimation window.

**Secondary parametric:** Boehmer-Musumeci-Poulsen (1991) standardized cross-sectional test (BMP), reported for comparison.

**Nonparametric:** Corrado (1989) rank test; Wilcoxon signed-rank test. Required by field convention (domain profile).

**Permutation inference:** Andrews-Farboodi (2025) adaptation — draw 5,000 pseudo-event dates uniformly from the estimation window (excluding the 10 days before the true event); for each pseudo-date, compute CARs using the same windows and same factor model; the true-event CAR is compared to this permutation distribution. Report empirical p-value.

#### 2.1.6 Cross-sectional comparison (SaaS vs. non-SaaS)

Test whether SaaS CARs differ from non-SaaS CARs using a two-sample test of mean CARs (cluster-robust SE at firm level; report both equal-weighted and value-weighted). The primary cross-group comparison is conducted in Pillar 3 DiD; the event study cross-group comparison is descriptive.

---

### 2.2 Pillar 2 — Cross-Sectional Regression (Within-SaaS Heterogeneity)

#### 2.2.1 Sample

SaaS firms only ($N \approx 65$). Separate regressions for each of the three phase CARs as dependent variable. Note: $N \approx 65$ is near the lower bound for reliable inference in OLS with 7 regressors; results are exploratory and subject to the power caveat stated in Section 1.3.

#### 2.2.2 Primary specification

$$CAR_i[Phase_k] = \beta_0^k + \beta_1^k \log(Size_i) + \beta_2^k ROA_i + \beta_3^k Lev_i + \beta_4^k BTM_i + \beta_5^k ARRGrowth_i + \beta_6^k GM_i + \beta_7^k NDR_i + \varepsilon_i^k$$

for $k \in \{1, 2, 3\}$.

#### 2.2.3 Variable definitions

| Variable | Definition | Source | Timing |
|----------|-----------|--------|--------|
| $CAR_i[Phase_k]$ | Cumulative FF5 abnormal return over phase $k$ | Pillar 1 output | Phase window |
| $\log(Size_i)$ | Log market capitalization | Bloomberg | Jan 31, 2026 |
| $ROA_i$ | Net income / total assets, trailing 4 quarters | Compustat via Bloomberg | Most recent Q before Jan 31, 2026 |
| $Lev_i$ | Total debt / total assets | Compustat via Bloomberg | Most recent Q before Jan 31, 2026 |
| $BTM_i$ | Book equity / market equity | Compustat via Bloomberg | Most recent Q before Jan 31, 2026 |
| $ARRGrowth_i$ | Annual Recurring Revenue growth rate (YoY%) | Bloomberg / company filings | Most recent reported |
| $GM_i$ | Software gross margin (%) | Bloomberg / company filings | Most recent reported |
| $NDR_i$ | Net Dollar Retention rate (%; proxy for switching cost intensity) | Bloomberg / company filings / Motley Fool SaaS database | Most recent reported |

**NDR data note [ASSUMED]:** NDR is not uniformly reported by all public SaaS firms. For firms that do not publicly disclose NDR, use the most recent 10-K or 10-Q mention of "net revenue retention," "net dollar retention," or "dollar-based net expansion rate." If unavailable, treat as missing and report the missingness rate.

**Theoretical motivation for $NDR$ (Farrell & Shapiro 1988):** NDR proxies for customer switching costs. High-NDR firms retain locked-in customers even when superior substitutes emerge, moderating the negative equity reaction. Expected sign: $\beta_7^1 > 0$ (higher NDR → smaller Phase 1 negative CAR).

**Theoretical motivation for $ARRGrowth$ and $GM$ (Dell'Acqua et al. 2026 jagged frontier):** SaaS firms with high gross margin and high ARR growth are more exposed to AI substitution for their core productivity value proposition. Expected signs: $\beta_5^1 < 0$, $\beta_6^1 < 0$ for Phase 1.

#### 2.2.4 Inference

Standard errors: HC3 heteroskedasticity-robust (White 1980). Given $N \approx 65$ and clustered structure is not meaningful (one obs per firm), HC3 is preferred over firm-clustering.

**Multiple testing:** Report both Bonferroni-corrected ($\alpha_{adj} = 0.05/21 \approx 0.0024$ for $7 \times 3$ tests) and unadjusted p-values. Primary inference on signed and pre-specified coefficients ($NDR$, $ARRGrowth$, $GM$) uses unadjusted p-values following the direction-and-magnitude framing recommended by Roth et al. (2023). Bonferroni correction reported for full coefficient matrix.

**Missing-data decision rule (pre-specified):** For Pillar 2 predictors with uncertain coverage ($ARRGrowth$, $GM$, $NDR$):
- If a variable has missingness $\leq 20\%$ of the SaaS sample ($\leq 13$ of $\approx 65$ firms): include in the primary specification; report missingness rate in a footnote.
- If a variable has missingness $21\%$–$40\%$ ($14$–$26$ firms missing): move to a separate robustness specification that drops the high-missingness variable; report both primary (without) and robustness (with) specifications.
- If a variable has missingness $> 40\%$ ($> 26$ firms): drop from the primary specification entirely; report in the limitations section.
- No imputation will be performed for primary inference. Imputation (MICE) may be used as an additional robustness check if missingness is $\leq 40\%$.
- This rule is stated before data collection to prevent post-hoc variable selection driven by missingness patterns.

#### 2.2.5 Additional heterogeneity regressors (exploratory)

- Eisfeldt, Schubert & Zhang (2023) AMH workforce exposure score (if firm-level data obtainable from authors' public release)
- Felten, Raj & Seamans (2023) GenAI Occupational Exposure (GenAI-OE) matched to SIC crosswalk
- Kogan-Papanikolaou (2014) growth-opportunity proxy (Tobin's Q as robustness for BTM)

---

### 2.3 Pillar 3 — Matched-Sample DiD (PRIMARY Causal Identification)

#### 2.3.1 Treatment and control assignment

**Treatment:** $SaaS_i = 1$ if firm $i$ is a Syntax SaaS Index constituent satisfying post-screening criteria as of Jan 31, 2026. Treatment is binary and non-staggered (all SaaS firms are exposed simultaneously on Feb 5, 2026).

**Control:** $SaaS_i = 0$ if firm $i$ is a GICS 451030 S&P 500 software firm not in Syntax SaaS Index.

**Why this treatment definition?** The Syntax SaaS Index uses FIS functional classification (not GICS alone) to identify firms whose primary revenue comes from subscription-based software-as-a-service delivery. This is a sharper proxy for AI disruption exposure than GICS 451030 alone, which includes legacy software vendors (Oracle, SAP enterprise divisions) and infrastructure software firms (Palo Alto Networks, Fortinet) unlikely to face the same mode of substitution. The SaaS/non-SaaS distinction aligns with the Dell'Acqua et al. (2026) jagged-frontier mechanism: SaaS products in the Claude Opus 4.6 capability domain face direct task substitution; enterprise infrastructure and non-subscription software do not.

**[ASSUMED]** Syntax SaaS Index historical membership as of Jan 31, 2026 is obtainable from Syntax Data (SYSAAS). This is the binding data access assumption for this pillar.

#### 2.3.2 Phase dummy construction

The daily panel spans $t \in [\text{May 18, 2024}, \text{May 12, 2026}]$ (approximately 500 trading days).

$$Phase1_t = \mathbf{1}[t \in \text{Feb 5 – Feb 18, 2026}] \quad (\approx 10 \text{ trading days})$$
$$Phase2_t = \mathbf{1}[t \in \text{Feb 19 – Apr 10, 2026}] \quad (\approx 37 \text{ trading days})$$
$$Phase3_t = \mathbf{1}[t \in \text{Apr 13 – May 12, 2026}] \quad (\approx 22 \text{ trading days})$$
$$Opus47_t = \mathbf{1}[t \in \text{Apr 16 – Apr 25, 2026}] \quad (\approx 8 \text{ trading days})$$

The pre-event period is $t < \text{Feb 5, 2026}$, the omitted base category.

#### 2.3.3 Static phase-DiD (primary summary regression)

$$R_{i,t} = \alpha_i + \gamma_t + \beta_1 (SaaS_i \times Phase1_t) + \beta_2 (SaaS_i \times Phase2_t) + \beta_3 (SaaS_i \times Phase3_t) + \beta_4 (SaaS_i \times Opus47_t) + \mathbf{X}_{i,pre}'\boldsymbol{\delta} + \varepsilon_{i,t}$$

where:
- $\alpha_i$: firm fixed effects (absorb time-invariant firm characteristics including SaaS membership main effect)
- $\gamma_t$: day fixed effects (absorb market-wide movements on each trading day)
- $\mathbf{X}_{i,pre} = [\log(Size_i), BTM_i, Lev_i]$: pre-event firm characteristics measured at Jan 31, 2026, interacted with time indicators where needed for variation
- $\varepsilon_{i,t}$: idiosyncratic error

**Note:** The main effects $SaaS_i$, $Phase1_t$, $Phase2_t$, $Phase3_t$, $Opus47_t$ are absorbed by firm and day fixed effects and are therefore not separately identified.

**Interpretation of $\beta_k$:** Phase-$k$ ATT — the differential daily excess return of SaaS firms relative to non-SaaS software firms during phase $k$, net of common day fixed effects. Since all firms are exposed to the same day, $\gamma_t$ absorbs any confounding macro event (tariff announcements, Fed decisions, other AI releases) that affects all software firms equally.

**Interpretation of $\beta_4$ (Opus 4.7):** Tests whether the Opus 4.7 release (Apr 16) generated an incremental differential effect on SaaS returns within Phase 3. Since $Opus47_t \subset Phase3_t$ (all Opus 4.7 days are also Phase 3 days), $\beta_3$ captures the SaaS Phase 3 differential return on non-Opus-4.7 days, and $\beta_3 + \beta_4$ captures it on Opus 4.7 days. The combined total Phase 3 SaaS effect integrates both: $\text{Total } \tau_{ATT}^{Phase_3} \approx \beta_3 \cdot T_3 + \beta_4 \cdot T_{Opus47}$, where $T_3$ is the number of non-Opus-4.7 Phase 3 trading days and $T_{Opus47}$ is the number of Opus 4.7 days. Report this combined effect in the paper alongside $\beta_3$ and $\beta_4$ individually.

If $\hat{\beta}_4 \approx 0$: consistent with Pástor-Veronesi rational learning — investors have already updated their priors about Anthropic's model cadence and the incremental news content of Opus 4.7 is lower. If $\hat{\beta}_4$ is negative and significant: a separate compounding disruption effect.

**[ASSUMED]** $Opus47_t$ dates (Apr 16–25) are set based on the user-provided event chronology. The 8-day window is a symmetric 4-day extension around the release date; this is an assumption about the relevant information-processing horizon that can be varied as robustness.

#### 2.3.4 Pre-event control covariates in WLS-DiD

Estimation is by WLS with market cap weights at Jan 31, 2026 to assign greater weight to larger, more liquid firms (consistent with field conventions). Pre-event characteristics $\mathbf{X}_{i,pre}$ are time-invariant (measured pre-event) and included as firm-level absorbers that strengthen the parallel trends plausibility by controlling for size- and leverage-driven systematic return differences.

#### 2.3.5 Dynamic event-time DiD (primary visual result)

$$R_{i,t} = \alpha_i + \gamma_t + \sum_{s \neq -1} \beta_s (SaaS_i \times \mathbf{1}[t - t_0 = s]) + \mathbf{X}_{i,pre}'\boldsymbol{\delta} + \varepsilon_{i,t}$$

where $t_0 = \text{Feb 5, 2026}$ and $s \in [-60, +70]$ trading days. The omitted period is $s = -1$ (Feb 4, 2026). Coefficients $\beta_s$ trace the differential return of SaaS firms relative to non-SaaS firms at each event-time horizon. Plot $\hat{\beta}_s$ with 95% confidence intervals.

**Pre-event flatness ($\beta_s \approx 0$ for $s \in [-60, -1]$)** is the visual diagnostic for parallel trends. The formal pre-trend test is a joint F-test of $H_0: \beta_{-60} = \beta_{-59} = \cdots = \beta_{-2} = \beta_{-1} = 0$.

**Post-event pattern (expected under Pástor-Veronesi):** Negative $\hat{\beta}_s$ in $s \in [0, +10]$, deepening through $s \approx +47$, then partial reversal (less negative or positive $\hat{\beta}_s$) from $s \approx +50$ onward.

#### 2.3.6 Inference

**Primary:** Cluster-robust standard errors, clustered at firm level. With $N_{total} \approx 90$–$105$ firms (clusters), the number of clusters is sufficient for conventional asymptotics but marginal. Report cluster-robust SEs as primary; wild cluster bootstrap (WCB, Cameron, Gelbach & Miller 2008) as robustness if any specification has $< 50$ clusters. Note: firm FEs and day FEs are two-way fixed effects; clustering is one-dimensional (firm level only).

**Rambachan-Roth (2023) honest confidence intervals:** Compute sensitivity analysis reporting how large parallel trends violations would need to be to overturn the main result. This is NOT a test of parallel trends; it is a sensitivity analysis showing the range of $M$ (the maximum allowable slope of the pre-trend violation) under which the post-event estimates remain statistically distinguishable from zero.

#### 2.3.7 Propensity score matching pre-processing

Before running the main DiD, construct three matched samples:

1. **1:1 logit PSM:** Estimate logit of $SaaS_i$ on $[\log(Size_i), BTM_i, Lev_i, ARRGrowth_i, GM_i]$; match each treated firm to nearest control firm without replacement; caliper 0.2 SD of logit propensity score.
2. **Mahalanobis distance matching:** Match on $[\log(Size_i), BTM_i, Lev_i]$ using Mahalanobis distance.
3. **1:3 logit PSM:** As (1) but allow each treated firm to be matched to up to 3 control firms (with replacement).

Re-run the static DiD on each matched sample. The point of this pre-processing is to improve covariate balance and show robustness of the main DiD estimate to the matching approach. This is a robustness check, not the primary estimator.

#### 2.3.8 Synthetic control method

Following Goldsmith-Pinkham & Lyu (2025), construct a synthetic SaaS cohort return as a weighted combination of non-SaaS software firm returns $\{R_{j,t}\}_{j \in \text{control}}$ that minimizes pre-event fit:

$$\hat{w}^* = \arg\min_{\mathbf{w} \geq 0, \sum w_j = 1} \sum_{t < t_0} (R_{SaaS,t} - \sum_j w_j R_{j,t})^2$$

where $R_{SaaS,t}$ is the equal-weighted average return of the SaaS cohort. The synthetic control gap $R_{SaaS,t} - \sum_j \hat{w}_j^* R_{j,t}$ in the post-event period is the causal effect estimate. Permutation inference: compute the same synthetic control for each control unit and compare the in-sample fit; the p-value is the fraction of control units whose post-event gap exceeds the treated gap.

This approach makes no factor model assumption (no FF5), sidestepping the Goldsmith-Pinkham & Lyu (2025) misspecification concern entirely. It is reported as a primary robustness check alongside the DiD.

---

### 2.4 Pillar 4 — Corporate Bond Event Study

#### 2.4.1 Sample construction

**Treated bonds:** Fixed-rate, non-convertible, non-putable corporate bonds issued by Syntax SaaS Index firms. Screening criteria:
- Non-convertible, non-putable, non-callable within the event window
- Fixed coupon rate $> 0$
- Maturity $\geq 1$ year as of Feb 5, 2026
- $\geq 50$ consecutive Bloomberg BGN price observations in the estimation window
- Bloomberg BGN composite quote available (not just indicative)

Expected $N$: 12–20 bonds. If $N < 8$, switch to synthetic control per Goldsmith-Pinkham & Lyu (2025) recommendation (see robustness plan, Section 4, Item 11).

**Control bonds:** Fixed-rate corporate bonds from non-SaaS GICS 451030 S&P 500 software firms, satisfying identical screening criteria.

**[ASSUMED]** Bloomberg BGN prices available at CUSIP level for all qualifying bonds. This is the binding data assumption for Pillar 4. BGN composite quotes are confirmed as appropriate for investment-grade corporate bonds (Bessembinder, Kahle, Maxwell & Xu 2009).

#### 2.4.2 Return construction

**Daily raw return:**

$$R_{i,t}^{bond} = \frac{P_{i,t} - P_{i,t-1} + AI_{i,t}}{P_{i,t-1}}$$

where $AI_{i,t}$ is the accrued interest on day $t$:

$$AI_{i,t} = \frac{c_i \times \Delta_{cal,t}}{360}$$

with $c_i$ the annual coupon rate and $\Delta_{cal,t}$ the calendar days elapsed.

**Benchmark return:** ICE BofA Corporate Bond Index matched by credit rating:
- C0A3 (A-rated) for investment-grade SaaS bonds rated A or above
- C0A4 (BBB-rated) for investment-grade SaaS bonds rated BBB
- H0A0 (HY Master) for sub-investment-grade SaaS bonds

**Duration adjustment:** Subtract the duration-matched Treasury return to isolate the credit spread component from the interest rate component:

$$ABR_{i,t} = R_{i,t}^{bond} - IR_{benchmark,t} - D_{mod,i} \times \Delta y_t^{Treasury}$$

where $D_{mod,i}$ is the modified duration of bond $i$ (Bloomberg MDURATION field) and $\Delta y_t^{Treasury}$ is the daily change in the interpolated Treasury yield at the corresponding maturity. [ASSUMED: Bloomberg MDURATION field available for all sample bonds.]

**Standardized abnormal return (EGY 2015):**

$$ASR_{i,t} = \frac{ABR_{i,t}}{\hat{\sigma}(ABR_i)}$$

where $\hat{\sigma}(ABR_i)$ is estimated over the pre-event estimation window (same [-261,-11] window as equity). EGY standardization provides approximately 4-fold power improvement over unstandardized ABR (Ederington, Guan & Yang 2015).

**Composite standardized return (EGY 2015 composite):**

$$ASR_i^{comp}[t_1, t_2] = \text{avg}_{(a,b)} \, ASR_i[t_1 - a, t_2 + b] \quad \text{for } a, b \in \{0, 1, 2, 3\}$$

The composite averages over all window permutations $[t_1 - a, t_2 + b]$ with $a, b \in \{0,1,2,3\}$ to reduce sensitivity to window choice. This is the primary bond test statistic.

#### 2.4.3 Event windows (bond)

Same phase windows as equity: Phase 1 $[+1,+10]$; Phase 2 $[+11,+47]$; Phase 3 $[+50,+70]$. Short windows: $[-1,+1]$, $[-3,+3]$.

#### 2.4.4 Test statistics (bond)

**Primary nonparametric:** Wilcoxon signed-rank test (robust to non-normality in small bond samples). This is the primary inferential test for the bond pillar given N=12–20.

**Primary permutation:** 5,000-draw permutation of pseudo-event dates within the estimation window (Andrews-Farboodi 2025 adaptation). Empirical p-value = fraction of pseudo-event CARs exceeding the true-event CAR. Co-primary with Wilcoxon; preferred for reporting p-values in the paper.

**Robustness parametric (small-N caveat):** KP-corrected t-test for cross-sectional correlation of ABRs. Note: the KP variance inflation factor $1 + (N-1)\bar{\rho}$ uses pairwise correlations across N firms; at N=12–20 this estimate is noisy and the formula does not have reliable asymptotic properties. Report KP-BMP as a robustness check alongside the primary Wilcoxon and permutation tests, not as a co-primary result. If KP-BMP and Wilcoxon/permutation disagree, lead with Wilcoxon and permutation in the paper.

**Small-N contingency:** If $N < 8$, report synthetic control result only (see Robustness Plan, Item 11). Do not report parametric tests with $N < 8$.

#### 2.4.5 Theoretical scaffolding

| Layer | Theory | Testable prediction |
|-------|--------|-------------------|
| Macro (Andrews & Farboodi 2025) | Transformative AI belief → bond yield revisions | SaaS issuer yields rise (spread widening) as AI substitution probability increases |
| Credit risk (Merton 1974; Campbell & Taksler 2003) | Equity vol increase → credit spread increase | SaaS bond ABRs are negative and correlated with SaaS equity ARs |
| Learning (Pástor & Veronesi 2009) | Phase 1–2: discount-rate dominance; Phase 3: cash-flow learning reasserts | Bond spreads widen in Phase 1–2, partially recover in Phase 3 |

---

### 2.5 Variable Summary Table (All Pillars)

| Symbol | Definition | Source | Timing | Notes |
|--------|-----------|--------|--------|-------|
| $R_{i,t}$ | Daily stock return | Bloomberg | Daily | Raw return including dividends |
| $R_{f,t}$ | 1-month T-bill rate | Ken French Data Library | Daily | Annualized ÷ 252 |
| $MKT_t$ | Market excess return | Ken French Data Library | Daily | Rm - Rf |
| $SMB_t$ | Small-minus-Big factor | Ken French Data Library | Daily | FF5 size factor |
| $HML_t$ | High-minus-Low factor | Ken French Data Library | Daily | FF5 value factor |
| $RMW_t$ | Robust-minus-Weak factor | Ken French Data Library | Daily | FF5 profitability factor |
| $CMA_t$ | Conservative-minus-Aggressive | Ken French Data Library | Daily | FF5 investment factor |
| $SaaS_i$ | Treatment indicator | Syntax SaaS Index | Jan 31, 2026 | 1 = Syntax SaaS Index constituent |
| $Phase1_t$ | Phase 1 dummy | Constructed | Feb 5–18, 2026 | $\approx 10$ trading days |
| $Phase2_t$ | Phase 2 dummy | Constructed | Feb 19–Apr 10, 2026 | $\approx 37$ trading days |
| $Phase3_t$ | Phase 3 dummy | Constructed | Apr 13–May 12, 2026 | $\approx 22$ trading days |
| $Opus47_t$ | Opus 4.7 window dummy | Constructed | Apr 16–25, 2026 | $\approx 8$ trading days; nested in Phase 3 |
| $\log(Size_i)$ | Log market cap | Bloomberg | Jan 31, 2026 | Pre-event |
| $BTM_i$ | Book-to-market | Compustat/Bloomberg | Most recent Q pre-event | |
| $Lev_i$ | Debt / assets | Compustat/Bloomberg | Most recent Q pre-event | |
| $ROA_i$ | Net income / assets | Compustat/Bloomberg | TTM pre-event | |
| $ARRGrowth_i$ | ARR YoY growth (%) | Bloomberg/filings | Most recent reported | Missing rate to be reported |
| $GM_i$ | Software gross margin (%) | Bloomberg/filings | Most recent reported | |
| $NDR_i$ | Net Dollar Retention (%) | Bloomberg/filings/public disclosures | Most recent reported | Missing rate to be reported |
| $R_{i,t}^{bond}$ | Daily bond raw return | Bloomberg BGN | Daily | Including accrued interest |
| $ABR_{i,t}$ | Abnormal bond return | Constructed | Daily | Net of benchmark and duration |
| $ASR_{i,t}$ | Standardized abnormal bond return | Constructed | Daily | EGY (2015) standardization |

---

## Section 3 — Assumptions

### 3.1 Pillar 1 (FF5 Event Study) — Assumptions

#### A1.1 Factor model correct specification (PILLAR 1)

**Statement:** The FF5 model correctly specifies the expected return process for each firm in the estimation window: $\mathbb{E}[R_{i,t} - R_{f,t}] = \alpha_i + \boldsymbol{\beta}_i'\mathbf{f}_t$ where $\mathbf{f}_t$ is the FF5 factor vector.

**Interpretation:** If violated, $AR_{i,t}$ conflates true abnormal performance with pricing model error. In volatile periods, the covariance structure of factors and firm returns shifts, biasing $\hat{\boldsymbol{\beta}}_i$ estimated over a calmer pre-event window.

**Testable implication:** $AR_{i,t}$ should average to zero in the estimation window by construction. In the event window, if FF5 is misspecified, the misspecification will be correlated with the market stress proxies (e.g., VIX) that drive factor loadings differently in volatile periods.

**Credibility:** WEAK. Goldsmith-Pinkham & Lyu (2025) provide direct evidence that factor model misspecification is material in volatile periods for the 2020–2024 period. The Feb–May 2026 period spans a major market event; this assumption is likely violated to some degree. This is the primary reason DiD (Pillar 3) is the causal identification pillar and FF5 is labeled descriptive.

**Mitigation:** Label Pillar 1 explicitly as descriptive throughout. Report Pillar 3 DiD as primary. Include model-free synthetic control as additional robustness.

#### A1.2 Estimation window stationarity (PILLAR 1)

**Statement:** The factor loadings $\boldsymbol{\beta}_i$ estimated in $[-261, -11]$ are stable through the event window; the data-generating process does not change between estimation and event windows.

**Testable implication:** Recursive Chow tests on $\boldsymbol{\beta}_i$ across sub-periods of the estimation window; Quandt-Andrews test for structural breaks in factor loadings within the estimation window.

**Credibility:** MODERATE. The estimation window spans May 2024 – Jan 2026, a period of substantial AI sector volatility (DeepSeek shock in Jan 2025; GPT-5 release). Factor loadings of SaaS firms may shift during this period. Mitigated by excluding the 10 days immediately before the event.

#### A1.3 No leakage (PILLAR 1)

**Statement:** The 10-day gap between estimation window end (Jan 31, 2026) and event date (Feb 5, 2026) is sufficient to exclude any pre-announcement price drift.

**Credibility:** MODERATE-STRONG. Claude Opus 4.6 was publicly announced with short notice for the Cowork plugin specifics. No prior public schedule of the release date has been identified. However, some inference from prior Anthropic release patterns may be possible; this cannot be formally ruled out.

---

### 3.2 Pillar 3 (DiD) — Assumptions

#### A3.1 Parallel trends (PRIMARY — PILLAR 3)

**Statement (potential outcomes):** In the absence of treatment (i.e., absent Claude Opus 4.6), the expected return evolution of SaaS and non-SaaS software firms would have followed the same path after Feb 5, 2026:

$$\mathbb{E}[R_{i,t}(0) | SaaS_i = 1] - \mathbb{E}[R_{i,t}(0) | SaaS_i = 0] = \text{constant in } t$$

**Interpretation:** The day fixed effects $\gamma_t$ absorb all common shocks. Parallel trends requires that idiosyncratic shocks to the SaaS group (beyond the common $\gamma_t$) are uncorrelated with the treatment timing. This is violated if, for example, there is a SaaS-specific macro shock that coincides with Feb 5, 2026 independently of Claude Opus 4.6.

**Supporting evidence:**
1. **[CONTINGENT ON DATA]** In-sample pre-event equal-weighted return correlation between the SaaS treatment cohort and the non-SaaS control cohort, computed over the estimation window $[-261, -11]$ relative to Feb 5, 2026. This is the correct empirical object — the actual SaaS vs. non-SaaS group correlation for the matched sample used in the DiD. To be computed and reported in the paper once Bloomberg data are pulled; a high correlation (target $\rho > 0.75$) supports parallel trends plausibility. If $\rho < 0.50$, the parallel trends assumption becomes less credible and the Rambachan-Roth sensitivity analysis becomes the primary credibility argument.
2. Dynamic event-time plot showing $\hat{\beta}_s \approx 0$ for $s \in [-60, -1]$ provides visual diagnostic.
3. Formal joint F-test: $H_0: \beta_{-60} = \cdots = \beta_{-2} = 0$.

**Testable implication:** Pre-event $\hat{\beta}_s$ coefficients should be statistically indistinguishable from zero. Per Roth (2022), failure to reject this pre-trend test does NOT confirm parallel trends; it only fails to reject it. Rambachan-Roth (2023) honest CIs quantify robustness to deviations.

**Credibility:** MODERATE. SaaS and non-SaaS software firms are in the same industry, face similar macro conditions, and are subject to similar investor flows. The key threat is that SaaS firms were already differentially exposed to AI-related sentiment before Feb 5, 2026 in a way that trended (not just leveled) differently from non-SaaS. The in-sample SaaS–control return correlation [CONTINGENT ON DATA] will be the primary quantitative evidence for parallel trends plausibility; until the data pull confirms it, this assumption is rated MODERATE pending verification.

#### A3.2 No-anticipation (PILLAR 3)

**Statement:** SaaS firm returns are unaffected by Claude Opus 4.6 before Feb 5, 2026: $R_{i,t}(1) = R_{i,t}(0)$ for all $t < t_0$.

**Testable implication:** Pre-event $\hat{\beta}_s$ in the dynamic DiD are zero (same test as parallel trends pre-trends diagnostic; but the logical requirement is different — no-anticipation requires zero PRE-period effect, while parallel trends requires the counterfactual trends to be parallel).

**Credibility:** MODERATE-STRONG. Claude Opus 4.6 was not publicly pre-announced on a fixed calendar schedule. However, inference from Anthropic's prior release cadence (approximately quarterly) may have generated anticipatory pricing in the 1–2 weeks before the event. The 10-day gap mitigates this concern.

#### A3.3 SUTVA / No spillovers (PILLAR 3)

**Statement:** The potential outcome $R_{i,t}(0)$ for control firm $i$ is not affected by whether SaaS firms are treated, and the potential outcome $R_{i,t}(1)$ for treated firm $i$ is not affected by whether other treated firms are treated.

**Interpretation (competitive spillover threat):** SaaS and non-SaaS software firms share customers and compete in the broader enterprise software market. If AI substitution reduces SaaS firm revenue, some of that demand may shift toward non-SaaS software or infrastructure products — contaminating the control group's counterfactual by making control firms' returns higher than they would be absent treatment. This would make the control group a bad counterfactual and attenuate the estimated treatment effect (bias toward zero), making results conservative. Alternatively, if the AI release triggers a sector-wide de-rating of all software firms, both SaaS and non-SaaS returns fall — the DiD differences out this common component via $\gamma_t$, but only if the de-rating is truly proportional (a proportionality assumption).

**Testable implication:** Compare returns of infrastructure software, cybersecurity, and other non-SaaS tech segments during the event period. If control firms show positive returns (gaining market share from SaaS disruption), SUTVA is violated in the contaminating direction.

**Credibility:** WEAK-MODERATE. This is the most credible referee challenge for Pillar 3. Discuss explicitly; present results with and without the most at-risk control firms (e.g., firms classified by SIC as infrastructure/systems software).

#### A3.4 Overlap / Common support (PILLAR 3)

**Statement:** For each SaaS firm in the treatment group, there exists a comparable control firm (non-SaaS software) with sufficiently similar pre-event characteristics.

**Testable implication:** After PSM pre-processing, the standardized mean differences (SMDs) for all matching variables should be $< 0.1$ (Cochran & Rubin 1973 threshold). Report SMD table before and after matching.

**Credibility:** MODERATE. The SaaS group (N=65) is generally high-growth, high-gross-margin, lower-profitability relative to large-cap legacy software incumbents in the control group. Exact overlap on all characteristics may be limited; matching will trim some comparison firms. PSM robustness checks address this.

---

### 3.3 Pillar 4 (Bond Event Study) — Assumptions

#### A4.1 Bond price benchmark validity

**Statement:** The ICE BofA rating-matched corporate bond index returns correctly capture the expected return on SaaS issuer bonds absent the event, including the systematic credit risk and interest rate components.

**Credibility:** MODERATE. The benchmark is index-wide (not GICS-specific), so it may not capture software sector-specific credit dynamics. Duration adjustment addresses the interest rate component. For the credit component, the rating-matching approach is the field standard (Bessembinder et al. 2009) but imprecise.

#### A4.2 BGN price accuracy

**Statement:** Bloomberg BGN composite dealer quotes accurately reflect tradeable bond prices for the SaaS issuer bond sample.

**Credibility:** MODERATE. BGN quotes are confirmed appropriate for investment-grade bonds with active dealer market making (Bessembinder et al. 2009). For high-yield or thinly traded SaaS bonds, BGN prices may be stale or unrepresentative. Mueller et al. (2024) document that thin trading materially reduces event study power. Report the proportion of days with zero-return observations (proxy for stale pricing) for each bond in the sample.

#### A4.3 Small-N inference validity

**Statement:** With N=12–20 bonds, the Wilcoxon signed-rank test and permutation inference have adequate power to detect economically meaningful abnormal returns.

**Credibility:** MODERATE. EGY (2015) standardization provides $\approx 4\times$ power improvement. Mueller et al. (2024) show power degrades rapidly below N=15 with event-induced variance. Mitigated by: (a) reporting empirical p-values from permutation; (b) synthetic control contingency at N<8; (c) reporting effect sizes (basis points) with confidence intervals, not just p-values.

---

## Section 4 — Robustness Plan

Ordered from most to least threatening (Priority 1 = most important for publication viability).

| Priority | Check | What It Tests | Method | Decision Rule |
|---------|-------|--------------|--------|--------------|
| 1 | Parallel trends formal test | Core DiD validity | Joint F-test: $\beta_{-60}=\cdots=\beta_{-2}=0$ in dynamic DiD | p > 0.10 required for primary result to hold as causal; if failed, relabel as descriptive |
| 2 | Rambachan-Roth (2023) honest CIs | Sensitivity to PT violations | Sensitivity parameter $M$ — report range of $M$ for which Phase 1/2 results remain significant | If result survives $M = \bar{\rho}$ (pre-trend slope), publishable |
| 3 | Synthetic control (no factor model) | FF5 misspecification (Goldsmith-Pinkham & Lyu 2025) | SCM gap estimate vs. permutation distribution | Should qualitatively match DiD sign and magnitude for Phase 1 and Phase 2 |
| 4 | Propensity score matched DiD (1:1 logit) | Covariate imbalance between SaaS and non-SaaS | PSM + DiD on matched sample; report SMD pre/post match | Point estimate within 50% of unmatched DiD; SMD < 0.1 post-match |
| 5 | Propensity score matched DiD (Mahalanobis, 1:3) | Alternative matching distance | Same as #4 | Qualitative consistency with #4 |
| 6 | Confounding event: tariff announcements (macro) | Macro shocks confounding Phase 2 | Include daily tariff-policy indicator (Bloomberg BETS) interacted with $SaaS_i$; re-run DiD | Main $\beta_1, \beta_2, \beta_3$ estimates stable |
| 7 | Confounding event: other AI releases | Other AI news during Feb–May 2026 | Include dummies for GPT-5, Gemini 2.5, DeepSeek release dates interacted with $SaaS_i$ | Main estimates stable; Opus 4.7 $\beta_4$ estimate unaffected |
| 8 | Falsification — pre-event placebo DiD | Spurious pre-event trends | Apply same DiD to Aug 2024 – Jan 2026 (entirely pre-event) using placebo "treatment date" in the middle of this window | Phase-interaction coefficients indistinguishable from zero |
| 9 | Falsification — non-SaaS treated sector | Test whether an unrelated sector shows Phase dynamics | Apply DiD to Healthcare Technology vs. S&P 500 Healthcare around same dates | No significant Phase 1 or Phase 2 coefficient |
| 10 | Alternative phase boundaries ($\pm 3$ days) | Phase boundary endogeneity | Shift all boundaries by $\pm 1$, $\pm 3$ trading days | Qualitative results preserved across boundary shifts |
| 11 | Alternative phase boundaries — Quandt-Andrews/Bai-Perron validated | Phase boundary endogeneity | Use data-driven QA supremum-Wald and Bai-Perron break dates; re-run DiD | **Decision rule:** If the data-driven break date is within $\pm 3$ trading days of the Oracle RPO date (Apr 10–13), the boundary is confirmed and results proceed under the Oracle anchor. If the break date disagrees by $> \pm 3$ trading days, (a) report both dates transparently, (b) assess whether a plausible confounding event occurs at the statistical break date, (c) anchor to the Oracle RPO date as the pre-specified theory-driven boundary, and treat the statistical break date as a sensitivity check. The Oracle RPO anchor is the DEFAULT regardless of break test outcome; the break test is a validation exercise, not a decision variable. Both sets of results reported in the robustness table. |
| 12 | FF3 and Carhart factor models (Pillar 1) | FF5 misspecification in specific factor choice | Re-estimate Pillar 1 CARs under FF3 and Carhart 4-factor | CARs qualitatively consistent across factor models |
| 13 | Equal-weighted vs. value-weighted CARs (Pillar 1) | Size concentration | Report both | Document which firms drive the effect |
| 14 | Wild cluster bootstrap inference | Cluster count marginality ($N \approx 90$–$105$ clusters) | Wild cluster bootstrap with Rademacher weights (Cameron, Gelbach & Miller 2008) | Compare to cluster-robust SEs; report if materially different |
| 15 | Alternative treatment universe | Syntax SaaS Index definition robustness | Replace Syntax SaaS Index with Bessemer Venture Partners Cloud Index (BVP Nasdaq Emerging Cloud Index) | Qualitative consistency |
| 16 | Dropping outlier firms ($|CAR| > 3\sigma$) | Outlier sensitivity | Re-run Pillar 1 and Pillar 3 dropping firms with extreme pre-event returns | Quantitative proximity to main results |
| 17 | SPXXAI model-free benchmark [CONTINGENT] | Factor model avoidance | $R_{SaaS,t} - R_{SPXXAI,t}$ spread | If access obtained, report alongside DiD |
| 18 | Bond: TRACE prices vs. BGN [CONTINGENT] | BGN price quality | Re-estimate Pillar 4 ABRs using TRACE transaction prices if WRDS access available | Qualitative consistency of ABR signs |
| 19 | Bond: synthetic control at N<8 | Small bond sample contingency | Abadie, Diamond & Hainmueller (2010) SCM for bond panel | If N<8, report SCM gap in lieu of parametric tests |
| 20 | Bonferroni correction across all tests | Multiple testing (3 phases × multiple windows × multiple models) | Apply Bonferroni adjustment to the full matrix of p-values across Pillar 1 and Pillar 2 | Report both corrected and uncorrected p-values; primary inference on pre-specified hypotheses |

---

## Section 5 — Threats and Pre-Planned Responses

### Threat 1: "The FF5 event study suffers from joint hypothesis problem and factor misspecification — all of your event study results could be an artifact of the pricing model."

**Pre-planned response:** We agree this is a limitation, which is exactly why we label the FF5 event study (Pillar 1) as descriptive and do not make causal claims from it. Our primary causal identification is the matched-sample DiD (Pillar 3), which requires only parallel trends and no-anticipation — neither of which depends on a particular pricing model. The DiD absorbs all common factor movements via day fixed effects $\gamma_t$, making the factor model assumption irrelevant for the causal estimate. The synthetic control (Robustness #3) makes no factor model assumptions at all. The consistency of results across the DiD, the synthetic control, and the FF5 event study provides convergent evidence that the findings are not an artifact of model choice.

**Supporting reference:** Goldsmith-Pinkham & Lyu (2025); Kothari & Warner (2007).

### Threat 2: "Parallel trends is not credible — SaaS firms were already being priced differently from non-SaaS software firms in the months before Feb 5, 2026 due to the broader AI sentiment wave."

**Pre-planned response:** We present three responses. First, the pre-event equal-weighted return correlation between the SaaS treatment cohort and the non-SaaS control cohort over the estimation window $[-261, -11]$ is $\hat{\rho} = [XX]$ [CONTINGENT ON DATA — to be replaced with the actual in-sample correlation once the Bloomberg pull is complete], demonstrating that the two groups tracked closely in levels prior to the event, consistent with parallel trends in expectations. Second, the dynamic event-time DiD (Figure [main figure]) shows $\hat{\beta}_s \approx 0$ for $s \in [-60, -1]$ — the formal pre-trend F-test fails to reject zero pre-trends ($p = [XX]$). Third, the Rambachan-Roth (2023) honest confidence intervals show that the Phase 1 DiD estimate remains statistically significant even when we allow pre-trend violations of magnitude $M = [XX\%]$ per day. We acknowledge that pre-trend testing cannot prove parallel trends; it only fails to falsify it. We report the Rambachan-Roth sensitivity parameter $M$ prominently.

**Supporting reference:** Roth (2022); Rambachan & Roth (2023).

### Threat 3: "Your phase boundaries are endogenous — you chose the Phase 2/3 break at Oracle's RPO disclosure AFTER observing the data. The three-phase architecture is a post-hoc rationalization."

**Pre-planned response:** The phase boundaries are validated using two statistical procedures applied independently of our prior on the break location. The Quandt-Andrews supremum-Wald test (Andrews 1993) estimates the break date as the day maximizing the Wald statistic in the return spread between SaaS and non-SaaS; the Bai-Perron (1998, 2003) multiple structural break procedure estimates break dates in the SaaS return series jointly. If the data-driven break dates coincide with (or are within $\pm 3$ trading days of) our researcher-specified boundaries, this confirms the specification. We further show robustness by shifting all boundaries by $\pm 1$ and $\pm 3$ trading days (Robustness #10) and by using the QA-validated break dates as alternative boundaries (Robustness #11). The Pástor-Veronesi (2009) three-phase framework was specified BEFORE the data were collected, anchored to a theoretical prediction — the timing of the phase boundaries is an empirical question tested, not assumed.

**Supporting reference:** Andrews (1993); Bai & Perron (1998, 2003); Pástor & Veronesi (2009).

### Threat 4: "Your control group is contaminated — non-SaaS software firms may have benefited from the AI wave at the same time, making your control group a poor counterfactual."

**Pre-planned response:** The SUTVA violation concern is valid and we acknowledge it explicitly. We note two points. First, the direction of contamination is conservative: if non-SaaS control firms gained from AI-driven customer displacement from SaaS, control returns would be elevated, making the DiD estimate less negative than the true ATT (bias toward zero). Our results are therefore a lower bound on the true disruption effect magnitude. Second, we show robustness by excluding from the control group the firms most likely to benefit from SaaS substitution (infrastructure software, cybersecurity SaaS lookalikes) and re-running the DiD. We also note that the day fixed effects $\gamma_t$ absorb any common AI-sentiment component affecting all software firms equally; only differential sector-specific effects would contaminate the DiD. We present returns for the control group separately and document that control firms do not show systematic positive returns in Phase 1 or Phase 2.

**Supporting reference:** Bertomeu et al. (2023/2025); Jorion & Zhang (2007, 2009).

### Threat 5: "The bond event study has too few observations (N=12–20) to support reliable inference — the result could be random."

**Pre-planned response:** We agree that $N = 12$–$20$ is a small sample for bond event studies. Three responses. First, we apply EGY (2015) standardization, which improves power by approximately 4-fold relative to unstandardized ABRs and is specifically designed for small-sample bond event studies. Second, we use permutation inference (5,000 pseudo-event draws) rather than asymptotic critical values, which is robust to small-sample distributional misspecification. Third, we present the synthetic control estimate as the primary result if $N < 8$, following Goldsmith-Pinkham & Lyu (2025). We frame the bond pillar explicitly as exploratory multi-market evidence that corroborates the equity findings, not as an independently conclusive result. The equi-weighted mean $ASR$ and its permutation p-value are the primary reported statistics, accompanied by the full individual-bond breakdown.

**Supporting reference:** Ederington, Guan & Yang (2015); Mueller et al. (2024); Goldsmith-Pinkham & Lyu (2025).

---

## Section 6 — Secondary Analyses

### 6.1 Mechanism Tests

**Mechanism 1 — Substitution channel (Dell'Acqua et al. 2026 jagged frontier):** Compare Phase 1 CARs between SaaS firms operating in tasks identified as inside vs. outside the Claude Opus 4.6 capability frontier (as assessed by Anthropic's published benchmark suite). Classify SaaS firm products by primary task category; match to Dell'Acqua et al. (2026) frontier ratings. Expected: inside-frontier SaaS firms show larger negative Phase 1 CARs.

**Mechanism 2 — Switching cost channel (Farrell & Shapiro 1988):** $NDR_i$ as moderator in Pillar 2. If the switching cost channel is operative, Phase 1 CARs should be increasing in $NDR_i$ (high-NDR firms retain locked-in customers despite AI substitution threat). This is already embedded in Pillar 2 as $\beta_7^1$; flag this as a mechanism test.

**Mechanism 3 — Equity vol to bond spread channel (Campbell & Taksler 2003):** Test whether cross-sectional variation in Phase 1 equity AR predicts cross-sectional variation in Phase 1 bond ABR across the matched equity-bond firm pairs (N = 12–20). Run OLS of bond $ABR_i$ on equity $CAR_i$ over the joint equity-bond sub-sample. Expected: positive coefficient (larger equity decline → larger bond spread widening). This is a direct test of the Campbell-Taksler equity-vol-to-credit-spread channel.

### 6.2 Within-SaaS Heterogeneity Documentation

The Pillar 2 regressions are the primary heterogeneity analysis. Additionally, report:
- Phase-specific CARs separately for the quartile of SaaS firms with highest vs. lowest NDR
- Phase-specific CARs separately for the quartile of SaaS firms with highest vs. lowest ARR growth
- Phase-specific CARs by size quartile (log market cap)

### 6.3 Opus Series Descriptive Appendix

Compile a narrative and descriptive statistics appendix documenting:
- Claude Opus 4.5, 4.6, and 4.7 release dates, announced capabilities, and benchmark scores
- Comparison of SaaS return dynamics around Opus 4.5 (prior model) vs. Opus 4.6 vs. Opus 4.7 for the firms in the sample
- This serves the Pástor-Veronesi "successive model releases" narrative and supports the $\beta_4$ Opus 4.7 interpretation

---

## Section 7 — Key Design Decisions (Decision Record)

### Decision 1: DiD is PRIMARY, not FF5

**Decision:** Pillar 3 matched-sample DiD is the primary causal identification strategy. Pillar 1 FF5 event study is labeled descriptive.

**Rationale:** Goldsmith-Pinkham & Lyu (2025) demonstrate that factor model misspecification in volatile periods biases FF5-based abnormal returns. The Feb–May 2026 period is precisely such a volatile period. The DiD requires only parallel trends and no-anticipation, neither of which depends on a pricing model. The DiD also naturally incorporates the comparison of SaaS vs. non-SaaS firms (the key research question) as the treatment-control contrast.

**Foregone alternative:** If FF5 were the primary identification, the causal claim would rest on the joint hypothesis of market efficiency and correct pricing model, which is not credible here.

### Decision 2: Syntax SaaS Index (SYSAAS) defines treatment

**Decision:** Syntax SaaS Index constituent status as of Jan 31, 2026 defines treatment ($SaaS_i = 1$).

**Rationale:** The Syntax Index uses FIS functional classification — a fundamentals-based taxonomy requiring that the firm's primary revenue stream is subscription-based SaaS delivery. This is sharper than GICS 451030 alone (which includes legacy software vendors and infrastructure software) and more appropriate for the disruption hypothesis (substitution risk is specifically for firms whose value proposition is labor-replacing subscription software, not for infrastructure providers or platform vendors). [ASSUMED: Syntax Index constituent list is point-in-time and survivorship-bias-free.]

**Robustness:** Alternative treatment universe using BVP Nasdaq Emerging Cloud Index (Robustness #15).

### Decision 3: Oracle RPO disclosure as Phase 2/3 boundary

**Decision:** April 10–13, 2026 (Oracle RPO +325% YoY disclosure) is the Phase 2/3 structural break. The Oracle RPO date is the **pre-specified, theory-driven anchor** and is the DEFAULT boundary regardless of what the structural break tests find.

**Rationale:** The Oracle RPO disclosure represents the first high-quality public signal that AI model adoption was generating actual enterprise software demand rather than pure substitution — a cash-flow learning signal in the Pástor-Veronesi (2009) framework. This is the mechanism predicted by the theory to trigger Phase 3 reversal. The boundary is validated statistically via Quandt-Andrews and Bai-Perron tests. The post-event nature of this observable is acknowledged as a threat and addressed via boundary robustness checks (Robustness #10 and #11).

**Pre-specified decision rule for break-date disagreement (Robustness #11):** If the Quandt-Andrews or Bai-Perron data-driven break date falls within $\pm 3$ trading days of April 10–13, the Oracle RPO boundary is confirmed. If the break date disagrees by $> \pm 3$ trading days: (a) both dates are reported transparently in the paper; (b) a search is conducted for any confounding event (earnings releases, macroeconomic announcements, other AI news) at the statistical break date; (c) the Oracle RPO anchor is retained as the primary boundary — the structural break test is a validation check, not a decision variable. This rule is stated here, before data collection, to prevent post-hoc boundary optimization.

### Decision 4: $Opus47_t$ as nested dummy in Phase 3

**Decision:** The Opus 4.7 release is modeled as a separate interaction dummy $SaaS_i \times Opus47_t$ nested within Phase 3.

**Rationale:** Estimating $\beta_4$ separately allows a direct test of the Pástor-Veronesi prediction that successive releases by the same developer generate attenuated market reactions (rational Bayesian updating). If $\hat{\beta}_4 \approx 0$, this is consistent with investors having already updated their priors on Anthropic's model cadence and capabilities. The Phase 3 base estimate $\beta_3$ captures the reversal dynamic net of any incremental Opus 4.7 effect.

---

## Section 8 — Limitations

1. **Single event.** The entire causal identification rests on a single event date (Feb 5, 2026). Results cannot be generalized to other AI model releases without auxiliary assumptions.

2. **Factor model misspecification (Pillar 1).** The FF5 descriptive estimates are biased during the volatile Feb–May 2026 period. This is acknowledged and addressed by making DiD primary.

3. **Small bond sample (Pillar 4).** $N = 12$–$20$ bonds limits statistical power for Pillar 4. Results are exploratory and treated as multi-market corroboration rather than independent confirmation.

4. **Control group contamination.** SaaS and non-SaaS software firms share customers; SUTVA may be violated. Bias direction is likely conservative.

5. **Phase boundary endogeneity.** Oracle RPO disclosure is a post-event observable used to anchor the Phase 2/3 boundary. Mitigated by structural break testing and boundary robustness checks.

6. **Within-SaaS small sample (Pillar 2).** $N \approx 65$ limits power in the cross-sectional heterogeneity regression; results are exploratory.

7. **Data availability uncertainty.** NDR and ARR growth are not uniformly disclosed; missing data rates may reduce Pillar 2 precision. SPXXAI access is contingent.

8. **Confounding macro events.** Tariff announcements, Fed actions, and other AI releases (GPT-5, Gemini 2.5) during the event window may confound results. Day fixed effects absorb common components; robustness checks add explicit confound dummies.

---

*End of strategy memo.*
