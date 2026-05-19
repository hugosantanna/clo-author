# Robustness Plan — "Another Model, Another SaaSpocalypse"
# Complete specification for coder implementation
# All checks to be run; do not truncate or deprioritize without explicit user approval

---

## Overview

This document is the contract between the strategist and the coder. Every robustness check listed here must be implemented in R. Results must be stored in `quality_reports/results_summary.md` and output tables exported to `paper/tables/`. The coder must not drop any check from this list without written rationale in the session log.

Robustness checks are organized by pillar and priority. Priority 1 checks are blocking for causal claims; Priorities 2–4 are strengthening. Contingent checks are labeled [CONTINGENT] and require specific data conditions to be met before implementation.

---

## Part A: Pillar 3 DiD — Core Identification Robustness

### A1. Parallel Trends Formal Test [Priority 1 — BLOCKING]

**What it tests:** The validity of the parallel trends assumption — the core identifying assumption of the DiD design.

**Method:**
- Estimate the dynamic event-time DiD:
  $R_{i,t} = \alpha_i + \gamma_t + \sum_{s \neq -1} \beta_s (SaaS_i \times \mathbf{1}[t-t_0 = s]) + \varepsilon_{i,t}$
- Conduct a joint F-test: $H_0: \beta_s = 0$ for all $s \in \{-60, -59, \ldots, -2\}$
- Use cluster-robust variance-covariance matrix at firm level

**Implementation:** `car::linearHypothesis()` or `fixest::wald()` applied to the dynamic DiD object.

**Decision rule:**
- If $p > 0.10$: pre-trends test does not reject parallel trends; label main DiD result as causal
- If $p \leq 0.10$: pre-trends exist; relabel main result as descriptive DiD; escalate to strategist-critic
- Per Roth (2022): failure to reject does NOT prove parallel trends; report this nuance explicitly

**Output:** F-statistic, degrees of freedom, p-value; pre-trend coefficient plot.

---

### A2. Rambachan-Roth (2023) Honest Confidence Intervals [Priority 1 — REQUIRED]

**What it tests:** Sensitivity of DiD estimates to violations of parallel trends of magnitude $M$.

**Method:**
- Use `HonestDiD` R package (Rambachan & Roth 2023)
- Input: pre- and post-event coefficients $\{\hat{\beta}_s\}$ and variance-covariance matrix from the dynamic DiD
- Compute sensitivity CIs for Phase 1 and Phase 2 post-event estimates under a range of $M$ values:
  $M \in \{0, 0.001, 0.002, \ldots, 0.010\}$ (daily pre-trend slope in percentage point terms)
- Report the breakdown value $M^*$ — the maximum $M$ for which the Phase 1/Phase 2 result remains significant at 5%

**Output:** Sensitivity plot of CI width vs. $M$; reported $M^*$ in text; table of honest CIs at $M = \{0, M^*/2, M^*\}$.

---

### A3. Propensity Score Matching (1:1 Logit) [Priority 2]

**What it tests:** Whether the main DiD result holds after controlling for covariate imbalance between SaaS and non-SaaS firms via matching.

**Method:**
- Estimate logit propensity score: $P(SaaS_i = 1 | \mathbf{X}_i)$ where $\mathbf{X}_i = [\log(Size_i), BTM_i, Lev_i, ARRGrowth_i, GM_i]$
- Nearest-neighbor 1:1 matching without replacement, caliper = 0.2 × SD(logit propensity score)
- Check SMD before and after matching: require SMD $< 0.1$ for all covariates post-match
- Re-estimate static phase-DiD on matched sample

**Implementation:** `MatchIt::matchit()` with `method = "nearest"`, `distance = "logit"`, `ratio = 1`.

**Output:** SMD table (pre/post match); matched DiD coefficients $\hat{\beta}_1, \hat{\beta}_2, \hat{\beta}_3$; comparison to unmatched DiD.

---

### A4. Propensity Score Matching (Mahalanobis Distance) [Priority 2]

**Method:** Same as A3 but use Mahalanobis distance matching on $[\log(Size_i), BTM_i, Lev_i]$. Matching without replacement.

**Implementation:** `MatchIt::matchit()` with `method = "nearest"`, `distance = "mahalanobis"`.

**Output:** SMD table; matched DiD coefficients; comparison to A3.

---

### A5. Propensity Score Matching (1:3 Logit) [Priority 2]

**Method:** Same propensity score as A3 but match each treated firm to up to 3 control firms with replacement.

**Implementation:** `MatchIt::matchit()` with `ratio = 3`, `replace = TRUE`.

**Output:** SMD table; matched DiD coefficients.

---

### A6. Synthetic Control Method [Priority 2]

**What it tests:** Whether a model-free counterfactual (no factor model required) supports the same conclusion as the DiD.

**Method:**
- Construct synthetic SaaS cohort return as convex combination of non-SaaS control firm returns minimizing pre-event RMSPE
- Compute gap: actual SaaS return minus synthetic SaaS return
- Permutation inference: compute synthetic control for each control firm; compare post-event MSPE ratios
- Use `Synth` R package or `tidysynth`

**Data requirement:** At least 5 control firms required for synthetic control (standard minimum).

**Output:** Synthetic control gap time-series figure (Fig. 2); pre-event RMSPE; post-event gap magnitude (percentage points per day cumulated over each phase); permutation p-value.

---

### A7. Wild Cluster Bootstrap [Priority 2]

**What it tests:** Whether cluster-robust SEs from fixest are reliable given $N \approx 90$–$105$ clusters (marginal for conventional asymptotics).

**Method:**
- Wild cluster bootstrap with Rademacher weights
- $B = 9,999$ bootstrap replications
- Applied to main static DiD for Phase 1, Phase 2, Phase 3 interactions
- Use `fwildclusterboot` R package (`boottest()` function)

**Decision rule:** If WCB p-values are within 0.02 of cluster-robust p-values → report both, note similarity. If WCB materially inflates p-values → lead with WCB; note inference is less sharp.

**Output:** WCB p-values alongside cluster-robust p-values for $\hat{\beta}_1$, $\hat{\beta}_2$, $\hat{\beta}_3$; 95% WCB confidence intervals.

---

### A8. Confounding Events — Tariff Announcements [Priority 3]

**What it tests:** Whether macro policy shocks confound the Phase 2 deepening (tariff announcements coincide with the Feb–Apr 2026 period).

**Method:**
- Collect tariff announcement dates from Bloomberg BETS or manual collection from USTR / WH press releases
- Create dummy $Tariff_t = 1$ for each tariff announcement date and the 2-day window around it
- Add $SaaS_i \times Tariff_t$ interaction to static DiD
- Compare $\hat{\beta}_1$, $\hat{\beta}_2$, $\hat{\beta}_3$ to baseline

**Output:** Coefficient table with and without tariff controls; magnitude of change from baseline.

---

### A9. Confounding Events — Other AI Releases [Priority 3]

**What it tests:** Whether GPT-5, Gemini 2.5, or other frontier model releases during Feb–May 2026 confound the SaaS-specific Phase dynamics.

**Method:**
- Create dummies for each major AI release date in the event window (collect from public announcements)
- Add $SaaS_i \times OtherAI_t$ interactions to static DiD
- Compare $\hat{\beta}_1$, $\hat{\beta}_2$, $\hat{\beta}_3$ to baseline
- Note: day fixed effects $\gamma_t$ already absorb any AI release effect common to all software firms; this interaction tests for a SaaS-specific differential

**Output:** Coefficient table with and without other-AI-release controls; note whether Opus47 estimate $\hat{\beta}_4$ changes.

---

### A10. Alternative Phase Boundaries (±1 and ±3 Days) [Priority 3]

**What it tests:** Sensitivity of results to researcher-specified phase boundaries.

**Method:**
- Shift all three phase boundaries simultaneously by $\Delta \in \{-3, -1, +1, +3\}$ trading days
- Re-estimate static DiD for each shift
- Report $\hat{\beta}_1$, $\hat{\beta}_2$, $\hat{\beta}_3$ for each shift

**Output:** Table of beta estimates across 4 boundary shifts + baseline (5 columns); assess monotonicity and sign consistency.

---

### A11. Data-Driven Phase Boundaries (Quandt-Andrews and Bai-Perron) [Priority 3]

**What it tests:** Whether researcher-specified boundaries coincide with statistically detected break dates.

**Method:**
- Compute daily SaaS minus non-SaaS return spread
- Apply Quandt-Andrews supremum-Wald test for single break in the spread; extract break date
- Apply Bai-Perron (1998) test for multiple structural breaks; allow 2–4 breaks; extract break dates
- Re-estimate static DiD using data-driven break dates as alternative phase boundaries
- Use `strucchange::breakpoints()` and `strucchange::Fstats()` in R

**Output:** QA break date; BP break dates; F-statistics and p-values; DiD estimates using data-driven boundaries; narrative comparison to researcher-specified boundaries.

**Pre-specified decision rule for break-date disagreement** (cross-reference: strategy_memo.md Section 7, Decision 3):
- If the data-driven break date falls within **±3 trading days** of the Oracle RPO anchor (Apr 10–13, 2026): boundary is confirmed; proceed with Oracle RPO anchor as primary.
- If the data-driven break date disagrees by **> ±3 trading days**: (a) report both dates transparently in the paper; (b) search for any confounding event (earnings, macro announcements, other AI news) at the statistical break date and document findings; (c) **retain the Oracle RPO anchor as the primary boundary** — the structural break test is a validation check, not a decision variable; (d) report DiD estimates under both boundary sets in the robustness table.
- The Oracle RPO anchor is the DEFAULT regardless of what the break tests find. Do not re-specify the phase boundaries based on the break test outcome.

---

### A12. Alternative Treatment Universe (BVP Cloud Index) [Priority 4]

**What it tests:** Whether results are sensitive to the specific index used to define the SaaS treatment universe.

**Method:**
- Obtain BVP Nasdaq Emerging Cloud Index (EMCLOUD) constituent list as of Jan 31, 2026
- Redefine $SaaS_i = 1$ for EMCLOUD firms
- Re-run static DiD and dynamic DiD

**Data requirement [ASSUMED]:** EMCLOUD constituent list publicly available or obtainable from BVP.

**Output:** DiD coefficients using EMCLOUD treatment universe vs. Syntax SYSAAS.

---

### A13. Dropping Outlier Firms [Priority 4]

**What it tests:** Sensitivity to extreme observations.

**Method:**
- Compute pre-event daily return standard deviation for each firm
- Drop firms with $|CAR_{Phase1}| > 3\hat{\sigma}_{pre}$
- Re-run Pillar 1 CARs and static DiD on trimmed sample

**Output:** Trimmed sample size; point estimates before and after trimming; economic magnitude comparison.

---

### A14. SUTVA Sensitivity — Exclude Most-At-Risk Control Firms [Priority 3]

**What it tests:** Whether control group contamination (competitive displacement benefit to non-SaaS firms) biases the DiD.

**Method:**
- Identify non-SaaS software firms whose products most directly compete with SaaS (e.g., infrastructure software, IT services, cybersecurity — most likely to benefit from SaaS substitution)
- Exclude these from the control group; re-run static DiD

**Output:** DiD estimates on reduced control group; sign and magnitude comparison to baseline.

---

## Part B: Pillar 1 FF5 Event Study — Robustness

### B1. FF3 Factor Model [Priority 3]

Re-estimate all Pillar 1 CARs and test statistics using the Fama-French 3-factor model (exclude $RMW$ and $CMA$).

**Output:** CAR table parallel to main Pillar 1 table, labeled "FF3 robustness."

---

### B2. Carhart 4-Factor Model [Priority 3]

Re-estimate all Pillar 1 CARs using Carhart (1997) 4-factor model (FF3 + momentum $MOM$ from Ken French daily momentum file).

**Output:** CAR table parallel to main Pillar 1 table, labeled "Carhart 4-factor robustness."

---

### B3. Equal-Weighted vs. Value-Weighted CARs [Priority 3]

Report both EW and VW average CARs for every event window in Pillar 1. Document which individual firms drive the largest contributions to the VW result.

**Output:** CAR tables with both EW and VW columns throughout.

---

### B4. SPXXAI Model-Free Benchmark [CONTINGENT — Priority 2 if available]

**Data dependency:** Goldman Sachs institutional access to SPXXAI daily returns required.

If SPXXAI data is accessible:
- Compute $R_{SaaS,t} - R_{SPXXAI,t}$ as the model-free measure of SaaS abnormal return
- Aggregate over Phase 1, Phase 2, Phase 3 windows
- Compare to FF5 CARs and DiD estimates

**If not accessible:** Report as "not implemented due to data access limitation"; flag in limitations section.

---

## Part C: Pillar 4 Bond Event Study — Robustness

### C1. TRACE Transaction Prices vs. BGN Quotes [CONTINGENT — Priority 2 if available]

**Data dependency:** WRDS TRACE access required.

If TRACE data is accessible:
- Re-estimate all Pillar 4 ABRs using TRACE transaction prices (cleaned per Dick-Nielsen 2009 procedure)
- Compare to BGN-based ABRs for overlapping sample

**If not accessible:** Document limitation; note that BGN quotes are confirmed appropriate by Bessembinder et al. (2009).

---

### C2. Bond Synthetic Control (Contingency at N < 8) [Priority 1 if triggered]

**When activated:** If the SaaS bond sample has fewer than 8 bonds after screening.

- Apply Abadie, Diamond & Hainmueller (2010) synthetic control to the bond panel
- Construct synthetic SaaS bond cohort from non-SaaS software bond donors
- Report gap in ABR basis points with permutation inference

**Output:** SCM gap figure for bond panel; pre-event RMSPE; post-event gap magnitude.

---

### C3. Stale Pricing Diagnostic [Priority 3]

- For each bond in the Pillar 4 sample, compute the proportion of days with zero raw return (proxy for stale BGN prices)
- Report distribution of staleness proportions
- If any bond has >30% zero-return days in the event window, flag as potentially stale and report results with and without that bond

---

### C4. Equity-Bond Mechanism Test (Campbell-Taksler Channel) [Priority 3]

- For the subsample of firms that appear in both the equity and bond samples (N = 12–20 firms)
- Regress bond $ABR_i$ (Phase 1) on equity $CAR_i$ (Phase 1) via OLS (HC3 SE)
- Test whether larger equity declines predict larger bond spread widening
- This is a mechanism test, not a primary result

---

## Part D: Pillar 2 Cross-Sectional Regression — Robustness

### D1. Bonferroni Correction [Priority 3]

- Apply Bonferroni-adjusted significance threshold $\alpha_{adj} = 0.05 / (7 \times 3) \approx 0.0024$ to all 21 coefficient tests in Pillar 2
- Report both adjusted and unadjusted p-values in all Pillar 2 tables
- Primary narrative inference on pre-specified directional hypotheses (NDR, ARRGrowth, GM) uses unadjusted p-values; full-table inference uses Bonferroni

---

### D2. Alternative Growth-Opportunity Proxy [Priority 4]

- Replace $BTM_i$ with Tobin's Q (market value of equity + book value of debt) / total assets
- Re-run all three Pillar 2 phase regressions
- Report coefficient stability on other regressors

---

### D3. Eisfeldt-Schubert-Zhang AMH Score [CONTINGENT — Priority 2 if available]

**Data dependency:** AMH (Artificial-Minus-Human) firm-level exposure score from Eisfeldt, Schubert & Zhang (2023/2025). Check for public release in their JF forthcoming replication package.

If AMH scores available:
- Add as additional regressor in Pillar 2
- Report incremental $R^2$ contribution
- Compare AMH to NDR as predictors of Phase 1 CAR

---

## Output Files for Coder

| Check | Primary output table | Figure |
|-------|---------------------|--------|
| A1 Pre-trend F-test | TABLE: pre_trend_test.tex | FIGURE: dynamic_did_plot.pdf |
| A2 Rambachan-Roth | TABLE: honest_ci_table.tex | FIGURE: sensitivity_plot.pdf |
| A3–A5 PSM DiD | TABLE: psm_did_comparison.tex | — |
| A6 Synthetic control | TABLE: sc_gap_stats.tex | FIGURE: sc_gap_figure.pdf |
| A7 Wild bootstrap | TABLE: wcb_pvalues.tex | — |
| A8–A9 Confound controls | TABLE: confound_robustness.tex | — |
| A10–A11 Boundaries | TABLE: boundary_robustness.tex | — |
| A12 Alt treatment universe | TABLE: bvp_comparison.tex | — |
| A13 Outlier drop | TABLE: outlier_robustness.tex | — |
| A14 SUTVA sensitivity | TABLE: sutva_sensitivity.tex | — |
| B1–B2 Alt factor models | TABLE: ff_robustness.tex | — |
| B3 EW vs VW | TABLE: ew_vw_cars.tex | — |
| B4 SPXXAI [CONTINGENT] | TABLE: spxxai_comparison.tex | — |
| C1 TRACE [CONTINGENT] | TABLE: trace_comparison.tex | — |
| C2 Bond SCM [CONTINGENT] | TABLE: bond_scm_gap.tex | FIGURE: bond_sc_figure.pdf |
| C3 Staleness | TABLE: staleness_diagnostic.tex | — |
| C4 Equity-bond mechanism | TABLE: equity_bond_mechanism.tex | — |
| D1 Bonferroni | TABLE: pillar2_bonferroni.tex | — |
| D2 Tobin Q | TABLE: pillar2_tobinq.tex | — |
| D3 AMH [CONTINGENT] | TABLE: amh_robustness.tex | — |

---

## Coder Checklist Before Submitting Results

- [ ] All Priority 1 checks implemented and output verified
- [ ] All Priority 2 checks implemented or marked [CONTINGENT] with data status
- [ ] All Priority 3 checks implemented (or escalated if N insufficient)
- [ ] Contingent checks: data access status documented in session log
- [ ] Results summary appended to `quality_reports/results_summary.md`
- [ ] All LaTeX tables are bare `tabular` environments (no `\begin{table}` wrapper)
- [ ] set.seed(20260205) called once at top of master script
- [ ] All paths use `here::here()` — no absolute paths
- [ ] Numerical results cross-checked: text claims match table values exactly (INV-11)

---

*End of robustness plan.*
