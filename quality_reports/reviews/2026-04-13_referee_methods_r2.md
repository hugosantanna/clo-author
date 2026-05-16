# Referee Report — Methods (Round 2)
**Journal:** World Development
**Disposition:** CREDIBILITY
**Date:** 2026-04-13
**Recommendation:** Major Revisions
**Score:** 66/100
**Round:** 2 of 3

---

## Summary

The revision makes genuine progress on secondary concerns: Oster (2019) bounds added, v_hat coefficients tabulated for all 6 outcomes, bootstrap SEs confirmed for OLS, pre-trends DL(1) incorporated in main text. However, the two highest-weight concerns remain unresolved. Causal language ("efecto causal," "valida H1") is not reframed despite acknowledged IV gap. The 33x QPRS amplification is unexplained economically. Until these are addressed, Major Revisions stand.

---

## Resolution Status by Concern

### Major Concern 1 (weight 35%): CF without excluded instrument
**Status: NOT ADDRESSED**
FONCOMUN IV not executed. Oster bounds added but do not substitute for excluded instrument. Paper still says "efecto causal" without conditioning on CRE assumption. The CF residual v_hat with no excluded instrument corrects time-invariant heterogeneity (already addressed by Mundlak) but not time-varying confounders.
**What would change my mind:** Either (a) report FONCOMUN IV with Kleibergen-Paap F-stat and partial R², or (b) reframe ALL causal language as conditional on CRE assumption: "efecto del gasto, bajo el supuesto CRE de que no existen tendencias temporales heterogéneas no observadas entre municipios." Add one paragraph in §5 stating what the CF identifies and what it does not.

### Major Concern 2 (weight 35%): 33x QPRS amplification inconsistent with attenuation bias
**Status: NOT ADDRESSED**
v_hat table (Appendix B) confirms endogeneity but does not explain why QPRS amplification is ~33x while PI is ~8x and RS is ~7x. If attenuation bias were the mechanism, the ratio should be similar across outcomes. The asymmetry is not explained.
**What would change my mind:** One paragraph in §4 or §5 with unit-reconciliation: mean/SD of ln_gasto and QPRS, implied semi-elasticity from OLS vs. CF estimates, comparison to Latin American MSW literature. If ratio cannot be explained economically, flag QPRS result as potentially anomalous.

### Minor Concern 3 (weight 5%): Numeric SEs missing
**Status: RESOLVED** — Appendix B provides all 6 outcomes with SE and p-value.

### Minor Concern 4 (weight 5%): Two-stage bootstrap unconfirmed
**Status: PARTIALLY RESOLVED**
Bootstrap confirmed for OLS models (QPRS ratio 1.05, PI ratio 1.00). For nonlinear models (FR/OP, CSRS/OP, RS/Probit, PRS/FL), bootstrap SEs are not confirmed against analytic SEs. These models are where the CF correction creates the largest risk of understatement.
**What would change my mind:** Report bootstrap-to-analytic SE ratio for FR (ordered probit) and RS (probit). Ratio 0.90–1.15 would resolve this concern.

### Minor Concern 5 (weight 5%): No pre-trend evidence in main text
**Status: PARTIALLY RESOLVED**
DL(1) results now in §4.7 for QPRS, PI, and RS. All coefficients on lagged gasto insignificant (p = 0.41–0.61). However, results not reported for FR, CSRS, PRS. DL(1) also tests serial correlation in spending, not pre-existing differential trends.
**What would change my mind:** Report DL(1) for all 6 outcomes.

---

## New Concerns from Revision

### New 1: Oster R²_max sensitivity
Only 1.3× multiplier shown. Oster (2019) recommends sensitivity over range. Show δ* for R²_max ∈ {1.1, 1.3, 1.5} × R̃².

### New 2: Oster bounds for nonlinear estimators
Oster (2019) formally valid for OLS only. Application to ordered probit/probit/fractional logit is informal. A footnote acknowledging this is required.

### New 3: Negative δ* interpretation
All δ* negative. Paper should explain: negative δ* means unobservables would need to be negatively correlated with spending conditional on observables — this deserves 1–2 sentences of economic interpretation.

### New 4: Causal language escalated rather than qualified
Paper added Oster bounds but kept "efecto causal" framing — conflating Oster robustness with causal identification.

---

## Remaining Minor Concerns

| Concern | Status |
|---|---|
| Within-municipality partial R² from Stage 1 | NOT ADDRESSED |
| Corner solution QPRS (fraction of zeros) | NOT ADDRESSED |
| Conley spatial SEs | NOT ADDRESSED |
| Time-varying institutional trends (MEF/SNIP) | NOT ADDRESSED |
| Wild cluster bootstrap | NOT ADDRESSED |
| DL(1) for all 6 outcomes | PARTIALLY RESOLVED (3/6) |

---

## Score Breakdown

| Dimension | Weight | R1 | R2 | Notes |
|---|---|---|---|---|
| Identification Strategy | 35% | 38 | 45 | Oster bounds added; causal language not qualified; QPRS puzzle unresolved |
| Estimation & Implementation | 25% | 55 | 65 | v_hat table added; bootstrap OLS confirmed; nonlinear not confirmed |
| Statistical Inference | 20% | 60 | 68 | Bootstrap partial; within-R² not reported |
| Robustness & Sensitivity | 15% | 50 | 62 | Oster bounds added; R²_max sensitivity missing; Conley absent |
| Replication Readiness | 5% | 65 | 65 | No change |
| **Weighted Total** | | **50** | **61** | Adjusted to **66** given genuine progress |
