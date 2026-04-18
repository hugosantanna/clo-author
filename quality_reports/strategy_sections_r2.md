
---

## § Exclusion Restriction Defense and Plausibly Exogenous Bounds
*(Resolves Issue 1 — Round 2 revision)*

### Formal Statement

The exclusion restriction requires $\gamma = 0$ in:
$$Y_{it} = \beta G_{it} + \gamma \hat{F}_{it} + \mathbf{X}_{it}'\boldsymbol{\delta} + \alpha_i + \lambda_t + \varepsilon_{it}$$

The instrument $\hat{F}_{it}$ affects waste outcomes **only** through $G_{it}$.

### Three-Part Defense of $\gamma \approx 0$

1. **Within-municipality temporal variation is orthogonal to governance quality.** Formula weights change because INEI updates population projections and MEF adjusts poverty/rurality indices — not because a municipality improved its waste outcomes. Fixed effects $\alpha_i$ absorb all time-invariant governance quality.

2. **For small FONCOMUN-dependent municipalities, the dominant channel is the limpieza budget line.** Marginal FONCOMUN increments are small in absolute terms. MINAM compliance reporting incentivizes registering expenditure in limpieza. Personnel and infrastructure costs are pre-committed; limpieza is the principal discretionary operational line.

3. **First-stage relevance survives conditioning on total budget.** Test:
$$G_{it} = \pi_1 \hat{F}_{it} + \pi_2 \ln(B_{it}) + \mathbf{X}_{it}'\boldsymbol{\pi}_3 + \alpha_i + \lambda_t + u_{it}$$
Significant $\hat{\pi}_1$ after $\ln(B_{it})$ confirms the instrument predicts the **composition** of spending, not just total level.

### Conley, Hansen & Rossi (2012) UCI Bounds

Let $\gamma \in [-\bar{\gamma}, \bar{\gamma}]$. The Union of Confidence Intervals:
$$\text{CI}_{UCI} = \bigcup_{\gamma \in [-\bar{\gamma}, \bar{\gamma}]} \text{CI}_{0.95}\!\left(\hat{\beta}_{IV}(\gamma)\right), \quad \tilde{Y}_{it} = Y_{it} - \gamma \hat{F}_{it}$$

**Calibration of $\bar{\gamma}$:**

| $\bar{\gamma}$ | Interpretation |
|----------------|---------------|
| $0.05 \cdot |\hat{\beta}_{OLS}|$ | Direct channel = 5% of total effect |
| $0.10 \cdot |\hat{\beta}_{OLS}|$ | Direct channel = 10% |
| $0.25 \cdot |\hat{\beta}_{OLS}|$ | Direct channel = 25% — demanding check |
| $0.50 \cdot |\hat{\beta}_{OLS}|$ | Near-violation scenario |

Estimate is **robust** if UCI excludes zero at $\bar{\gamma} = 0.25 \cdot |\hat{\beta}_{OLS}|$. Applied to three Tier-1 outcomes: $\ln(QPRS_{it})$, $PI_{it}$, $PRS_{it}$.

**R pseudo-code:**
```r
library(fixest); library(dplyr); library(here)
m_ols <- feols(ln_QPRS ~ G_pc + log_pop + urban_rate + poverty_rate +
               log_own_rev | ubigeo + year, data=panel, cluster=~province_code)
beta_ols <- coef(m_ols)["G_pc"]
gamma_fracs <- c(0.05, 0.10, 0.25, 0.50)
uci_results <- lapply(gamma_fracs, function(frac) {
  gbar <- frac * abs(beta_ols)
  gamma_seq <- seq(-gbar, gbar, length.out = 201)
  ci_bounds <- lapply(gamma_seq, function(g) {
    pd <- mutate(panel, Y_adj = ln_QPRS - g * Z_foncomun)
    m  <- feols(Y_adj ~ log_pop + urban_rate + poverty_rate +
                log_own_rev | ubigeo + year | G_pc ~ Z_foncomun,
                data=pd, cluster=~province_code)
    confint(m, level=0.95)["fit_G_pc",]
  })
  ci_mat <- do.call(rbind, ci_bounds)
  list(gamma_frac=frac, uci_lo=min(ci_mat[,1]), uci_hi=max(ci_mat[,2]),
       robust=(min(ci_mat[,1])>0 | max(ci_mat[,2])<0))
})
```

### Education Spending Placebo Test

$$\ln(G_{it}^{Edu}) = \pi_1^{Edu} \hat{F}_{it} + \pi_2^{Edu} \ln(B_{it}) + \mathbf{X}_{it}'\boldsymbol{\pi}_3 + \alpha_i + \lambda_t + u_{it}$$

Expected: $\hat{\pi}_1^{Edu} \approx 0$ (insignificant). Significant result = red flag for exclusion restriction.

---

## § CRE + Control Function Implementation (Wooldridge 2015)
*(Resolves Issue 2 — Round 2 revision)*

### Why Round 1 Was Incorrect

Stage 1 used FE within-demeaning; Stage 2 used Mundlak projection. These approximate $\alpha_i$ differently — residuals are incompatible. Per **Wooldridge (2015, JHR Section 4)**: both stages must use the same $\alpha_i$ approximation.

### Stage 1: CRE Linear Reduced Form (pooled OLS — NOT FE-within)

$$G_{it} = \pi_0 + \pi_1 \hat{F}_{it} + \mathbf{X}_{it}'\boldsymbol{\pi}_2 + \bar{\mathbf{X}}_i'\boldsymbol{\pi}_3 + \lambda_t + v_{it} \tag{S1}$$

Save residuals: $\hat{v}_{it}$. Report Montiel Olea-Pflueger effective $F > 10$ (conventional) and $> 23.11$ (5% size distortion).

### Stage 2: CRE Nonlinear + Control Function

**Binary:** $P(Y_{it}=1|\cdot) = \Phi(\beta_1 G_{it} + \rho\hat{v}_{it} + \mathbf{X}_{it}'\boldsymbol{\beta}_2 + \bar{\mathbf{X}}_i'\boldsymbol{\psi} + \lambda_t)$

**Ordinal:** $FR_{it}^* = \beta_1 G_{it} + \rho\hat{v}_{it} + \mathbf{X}_{it}'\boldsymbol{\beta}_2 + \bar{\mathbf{X}}_i'\boldsymbol{\psi} + \lambda_t + \varepsilon_{it}$; $FR_{it}=j \iff \kappa_{j-1} < FR_{it}^* \leq \kappa_j$

**Fractional:** $E(PRS_{it}|\cdot) = \Lambda(\beta_1 G_{it} + \rho\hat{v}_{it} + \mathbf{X}_{it}'\boldsymbol{\beta}_2 + \bar{\mathbf{X}}_i'\boldsymbol{\psi} + \lambda_t)$

Rules: (1) $\hat{F}_{it}$ excluded from Stage 2; (2) $\bar{\mathbf{X}}_i$ identical in both stages; (3) $\hat{\rho}=0$ test of exogeneity.

**AME:** Report $\partial P(FR=1)/\partial G$ (daily collection) and $\partial P(CSRS=4)/\partial G$ (coverage >75%).

### Bootstrap: Province-Level Cluster, B=500

Each draw: resample provinces, recompute $\bar{\mathbf{X}}_i$, re-estimate S1, compute $\hat{v}^{(b)}$, re-estimate S2. Report bootstrap SE and 95% percentile CI.

**R pseudo-code:**
```r
library(MASS); library(dplyr); set.seed(20240101)
panel <- panel |> group_by(ubigeo) |>
  mutate(across(c(G_pc,log_pop,poverty_rate,urban_rate,log_own_rev),
                mean, .names="mean_{.col}")) |> ungroup()
s1 <- lm(G_pc ~ Z_foncomun + log_pop + poverty_rate + urban_rate +
         log_own_rev + provincial_dummy + year_f + mean_G_pc +
         mean_log_pop + mean_poverty_rate + mean_urban_rate +
         mean_log_own_rev, data=panel)
panel$vhat <- residuals(s1)
s2 <- MASS::polr(FR_f ~ G_pc + vhat + log_pop + poverty_rate +
                 urban_rate + log_own_rev + provincial_dummy + year_f +
                 mean_G_pc + mean_log_pop + mean_poverty_rate +
                 mean_urban_rate + mean_log_own_rev,
                 data=panel, method="probit", Hess=TRUE)
provinces <- unique(panel$province_code); B <- 500
boot_mat  <- matrix(NA, B, length(coef(s2)))
for (b in seq_len(B)) {
  bd <- dplyr::bind_rows(lapply(sample(provinces,replace=TRUE),
                                function(p) panel[panel$province_code==p,]))
  bd <- bd |> group_by(ubigeo) |>
    mutate(across(c(G_pc,log_pop,poverty_rate,urban_rate,log_own_rev),
                  mean, .names="mean_{.col}")) |> ungroup()
  s1b <- lm(G_pc ~ Z_foncomun + log_pop + poverty_rate + urban_rate +
            log_own_rev + provincial_dummy + year_f + mean_G_pc +
            mean_log_pop + mean_poverty_rate + mean_urban_rate +
            mean_log_own_rev, data=bd)
  bd$vhat <- residuals(s1b)
  s2b <- tryCatch(MASS::polr(FR_f ~ G_pc + vhat + log_pop + poverty_rate +
    urban_rate + log_own_rev + provincial_dummy + year_f + mean_G_pc +
    mean_log_pop + mean_poverty_rate + mean_urban_rate + mean_log_own_rev,
    data=bd, method="probit", Hess=FALSE), error=function(e) NULL)
  if (!is.null(s2b)) boot_mat[b,] <- coef(s2b)
}
boot_se <- apply(boot_mat[complete.cases(boot_mat),], 2, sd)
```

---

## § Estimand Clarification: ATT (TWFE) vs. LATE (IV)
*(Resolves Issue 3 — Round 2 revision)*

### Two Distinct Estimands

| | TWFE | IV (CRE+CF) |
|--|------|-------------|
| **Estimand** | ATT | LATE |
| **Population** | All municipalities with spending variation | Complier municipalities |
| **Assumption** | Parallel trends | Relevance + exclusion restriction |

### Complier Population

Define FONCOMUN Dependency Ratio:
$$\text{FDR}_{it} = \frac{\text{FONCOMUN received}_{it}}{\text{Total municipal revenue}_{it}}$$

Core compliers: $\text{FDR}_{it} > 0.70$ — small ($<5{,}000$ inhabitants), rural, sierra/selva municipalities with limited own-source revenue.

**Empirical verification:** Estimate first stage by FDR quartile. Prediction: $\hat{\pi}_1^{Q4} \gg \hat{\pi}_1^{Q1}$.

### Why LATE is Policy-Relevant

Policy question: *Should MEF increase FONCOMUN to small municipalities to improve waste management?*

The LATE answers this exactly for municipalities where FONCOMUN is the binding fiscal constraint and waste management outcomes are worst — precisely the population needing policy intervention. The ATT conflates heterogeneous effects across large urban and small rural municipalities.

### Table Labeling Rule (binding on Writer agent)

- **Col (1) TWFE:** "Estimates ATT under parallel trends: average effect of 1% spending increase among all municipalities with spending variation."
- **Col (2) IV:** "Estimates LATE for FONCOMUN-dependent municipalities: average effect of 1% spending increase induced by MEF formula variation."

Main text must state: "Columns (1) and (2) estimate different estimands and answer related but distinct questions."

---

## § Multiple Testing Strategy (Restructured)
*(Resolves Issue 4 — Round 2 revision)*

### Three-Tier Hierarchy

**Tier 1 — Primary (3 outcomes): Bonferroni-Holm applied here**

| Dimension | Primary | Variable | Rationale |
|-----------|---------|----------|-----------|
| D1 Collection | Collection quantity | $QPRS_{it}$ | Continuous, direct, low reporting bias |
| D2 Planning | Planning Index | $PI_{it}$ (0–5) | Aggregate; single degree of freedom |
| D3 Disposal | Proportion to landfill | $PRS_{it}$ | Most direct adequate-disposal measure |

**Tier 2 — Secondary (pre-specified, unadjusted p-values):** FR, CSRS (D1); PIGARS, PMRS, SRRS, PTRS, PSFRSRS (D2); RS binary, PBotadero, PReciclados (D3).

**Tier 3 — Exploratory (supplementary only, no inference):** Quemados, PRSRO, RSRO.

### Bonferroni-Holm for 3 Primary Hypotheses

Sort p-values $p_{(1)} \leq p_{(2)} \leq p_{(3)}$. Reject $H_{(k)}$ if:
$$p_{(k)} \leq \frac{0.05}{4-k}, \quad k=1,2,3$$

Thresholds: $p_{(1)} \leq 0.0167$; $p_{(2)} \leq 0.025$; $p_{(3)} \leq 0.05$. Stop at first non-rejection.

### Anderson (2008) Index for Planning Components

Avoid within-dimension Bonferroni-Holm on correlated binaries. Use standardized index:
$$\text{SPI}_{it} = \frac{\sum_{k=1}^{5} w_k \tilde{Y}_{kit}}{\sum_{k=1}^5 w_k}, \quad \tilde{Y}_{kit} = \frac{Y_{kit}-\mu_k}{\sigma_k}, \quad w_k = \sigma_k^{-2}$$

where $\mu_k$, $\sigma_k$ from lowest-spending quartile. SPI reported as secondary robustness check alongside primary $PI_{it}$.

### Pre-Registration Declaration

"This study pre-specifies 3 primary hypotheses (H1: $QPRS_{it}$; H2: $PI_{it}$; H3: $PRS_{it}$). Bonferroni-Holm controls FWER at $\alpha=0.05$ across these 3 tests. All other outcomes are secondary or exploratory."

---

## § Distributed Lag Adjustment: DL(2) → DL(1)
*(User decision 2026-04-12 — maximizes degrees of freedom with T=5)*

### Rationale

DL(2) with $T=5$ leaves only 3 effective estimation years (2017–2019). DL(1) leaves 4 years (2016–2019) with 2 instruments available.

| Spec | Outcome years | Eff. T | IV instruments |
|------|--------------|--------|----------------|
| DL(0) | 2015–2019 | 5 | $\hat{F}_{it}$ |
| **DL(1) primary** | **2016–2019** | **4** | $\hat{F}_{it}$, $\hat{F}_{it-1}$ |
| DL(2) DROPPED | 2017–2019 | 3 | — |

### Equations

**DL(1) primary:**
$$RS_{it} = \beta_1 G_{it} + \beta_2 G_{it-1} + \mathbf{X}_{it}'\boldsymbol{\gamma} + \alpha_i + \lambda_t + \varepsilon_{it}$$

Cumulative: $\hat{\theta}=\hat{\beta}_1+\hat{\beta}_2$. $\text{Var}(\hat{\theta}) = \text{Var}(\hat{\beta}_1)+\text{Var}(\hat{\beta}_2)+2\,\text{Cov}(\hat{\beta}_1,\hat{\beta}_2)$.

**DL(0) robustness:** $Y_{it} = \beta_1 G_{it} + \mathbf{X}_{it}'\boldsymbol{\gamma} + \alpha_i + \lambda_t + \varepsilon_{it}$

**Application by dimension:**
- D3 (disposal): DL(1) primary — infrastructure has 1-year payoff horizon
- D2 (planning): DL(1) tested — plan preparation takes time
- D1 (collection): DL(0) primary; DL(1) robustness

**IV DL(1):** exactly identified (2 instruments: $\hat{F}_{it}$, $\hat{F}_{it-1}$; 2 endogenous regressors: $G_{it}$, $G_{it-1}$). Report Montiel Olea-Pflueger F for each regressor separately.

---

## Status Update (Round 2)

**Date:** 2026-04-12
**Blocking issues resolved:**
- ✅ Issue 1: Conley (2012) UCI bounds specified with $\bar{\gamma}$ calibration + education placebo
- ✅ Issue 2: CRE+CF follows Wooldridge (2015) — Stage 1 pooled OLS with Mundlak; bootstrap province-clustered
- ✅ Issue 3: ATT vs. LATE distinguished; complier population characterized by FDR>0.70
- ✅ Issue 4: Bonferroni-Holm applied across 3 primary outcomes (not within D2 components); Anderson (2008) SPI for planning
- ✅ DL(2) replaced by DL(1) throughout

**Pending strategist-critic re-review (Round 2 target: >= 80/100)**
