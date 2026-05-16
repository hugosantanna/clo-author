# Referee Report — Methods (Round 1)
**Journal:** World Development
**Disposition:** CREDIBILITY
**Date:** 2026-04-13
**Recommendation:** Major Revisions
**Score:** 58/100

---

## Summary Assessment

The paper addresses a policy-relevant question using a five-year panel of 1,874 municipalities. The CRE+CF estimator of Wooldridge (2015, JHR) is a defensible choice for correcting time-invariant heterogeneity in nonlinear panel models. The authors are admirably transparent about a critical limitation: the external instrument (FONCOMUN) has not been merged, meaning Stage 1 is a within-Mundlak projection of spending on its own time-mean — not a true IV first stage.

The central methodological problem is that the CF correction as implemented does not eliminate endogeneity from time-varying confounders. Without an external instrument, `v_hat` from Stage 1 is not a valid control function: it is the within-municipality residual from regressing spending on its own time-mean and year dummies, which cannot purge bias from time-varying confounders (new administrations, targeted central government grants, local shocks that move both spending and outcomes). Wooldridge (2015, JHR) explicitly requires an excluded instrument in Stage 1. The paper's causal language ("efecto causal", "valida la Hipótesis H1") is not supported by the identification strategy as implemented.

Secondary concerns: (1) the 30-fold TWFE-to-CRE+CF amplification may signal residual confounding rather than corrected attenuation bias; (2) SEs are missing for most CRE+CF estimates in the main table; (3) the two-stage bootstrap for nonlinear CF is not confirmed; (4) pre-trend evidence is deferred to a non-submitted appendix; (5) planned robustness checks do not appear to have been executed.

---

## Sanity Checks

- **Signs:** FR coefficient (-0.522) consistent with ordinal coding. QPRS (+0.879), PI (+0.300), RS (+0.022), PRS (+0.026) plausible. TWFE sign reversal on RS (-0.003) — the primary motivation for CF correction — is plausible as causal-reversal bias.
- **Magnitude concern:** QPRS: TWFE=0.027 vs. CRE+CF=0.879 (33× amplification). If OVB is attenuation-downward on a positive coefficient, the unobserved factor must have a large negative effect on QPRS conditional on spending — meaning high-institutional-quality municipalities collect *fewer* kilograms per day. This is economically implausible.
- **Uniformity concern:** All six outcomes significant at p<0.001 after CRE+CF, across distinct functional forms and scales. This is more consistent with a common confound than a causal effect operating through different mechanisms simultaneously.

---

## Major Concerns

**1. The CF correction without excluded instrument does not identify the causal effect.**

Stage 1 (Eq. 2) has no excluded external instrument. Wooldridge (2015, JHR) explicitly requires a valid excluded variable in Stage 1 for the CF step to provide identification beyond the CRE model. Without it, including `v_hat` in Stage 2 is a nonlinear re-parameterization of the CRE estimator — it corrects for time-invariant endogeneity (already handled by Mundlak means) but not for time-varying confounders.

**What would change my mind:** Merge the FONCOMUN formula instrument and report: (a) Kleibergen-Paap and Cragg-Donald F-statistics for each specification; (b) partial R² of the instrument; (c) Conley-Hansen-Rossi plausible exogeneity bounds. Alternatively, if the IV is infeasible, reframe the paper explicitly as "CRE estimator with endogeneity diagnostic" rather than "causal identification," and provide Oster (2019) delta bounds for each outcome.

**2. The 33× QPRS amplification is inconsistent with attenuation bias as the mechanism.**

If the bias were attenuation-downward on a positive TWFE coefficient (+0.027), the OVB would have to be approximately -0.852. This means high-institutional-quality municipalities collect fewer kilograms per day conditional on spending — economically implausible. The amplification pattern (6–33× uniformly positive across all six outcomes) is more consistent with the CF residual picking up time-varying institutional improvements than with a pure attenuation bias correction.

**What would change my mind:** Report the coefficient on `v_hat` for each Stage 2 model in a supplementary table. If `v_hat`'s coefficient is large and positive across outcomes, this indicates the CF is capturing time-varying quality improvements — not correcting attenuation bias. An Oster delta bound showing delta > 1 for the QPRS elasticity under the observed R² movements would substantially reassure.

**3. Standard errors for most CRE+CF estimates are missing from the main table.**

Table 1 reports SEs only for QPRS (0.021) and PI (0.015). For FR, CSRS, RS, and PRS the SE column reads "(clust.)" without numeric values. Without numeric SEs it is impossible to verify Bonferroni-Holm calculations, assess precision of AMEs, or audit the province-level clustering.

**What would change my mind:** Report numeric clustered SEs (or block-bootstrap SEs for nonlinear AMEs) for all six columns. Specify whether SEs are delta-method or bootstrap, and confirm province-level block bootstrap was used for nonlinear models.

**4. Two-stage bootstrap for nonlinear CF specifications is not confirmed.**

For Ordered Probit, Probit, and Fractional Logit models where `v_hat` enters as a regressor, standard SEs from Stage 2 alone understate sampling variability because they ignore estimation error in `v_hat`. The Murphy-Topel correction applies for linear models; province-level block bootstrap re-estimating both stages applies for nonlinear models. The strategy memo specifies this but the empirical sections do not confirm implementation.

**What would change my mind:** A footnote confirming (a) province-clustered block bootstrap with B ≥ 500 iterations re-estimating both stages; or (b) the analytic two-stage correction used and its source. Report bootstrap SEs alongside analytic SEs in a robustness table.

**5. No pre-trend evidence in submitted sections.**

Section 3.3 references "Apéndice §sec:appendix_pretendencias" but this is not submitted. For a journal submission, pre-trend evidence must appear in the main paper or be summarized in the text with directional findings.

**What would change my mind:** Include the coefficient on `ln G_{it-1}` and its SE and p-value for each of the three primary outcomes in a distributed lag specification. State whether pre-trends are present and how this affects the TWFE baseline comparison.

---

## Minor Concerns

- Stage 1 R² = 0.74 is mechanically inflated by `G_bar_i` absorbing cross-sectional variance. The relevant figure is the partial R² of within-municipality variation explained by any excluded instrument — which does not exist. This figure is potentially misleading as presented.
- The corner-solution treatment for QPRS (zeros) is mentioned but not specified. What fraction of obs have zero collection? Does the elasticity change materially with zeros excluded?
- SUTVA defense relies on a legal argument (Ley 27972). If municipalities share landfill infrastructure, spatial Conley SEs should augment province clustering.
- The Mundlak means do not control for time-varying institutional quality trends within municipalities. This residual identification threat should be discussed explicitly.
- BH correction applied to primary hypotheses only is correct practice, but secondary outcomes (CSRS, QPRS, RS, plan components) should be clearly typographically demarcated as exploratory.
- The sign reversal on RS from TWFE (-0.003) to CRE+CF (+0.022) may amplify a near-zero coefficient; this alternative interpretation should be acknowledged.

---

## Technical Suggestions

1. **Implement the FONCOMUN IV.** Report first-stage F-stats, partial R², Anderson-Rubin CIs for each specification.
2. **If IV unavailable, report Oster (2019) delta bounds** for each primary outcome.
3. **Implement and report two-stage clustered block bootstrap** (B=999, both stages) for all nonlinear specifications.
4. **Report numeric AME SEs** using delta method or bootstrap; specify method.
5. **Add event-study figure** for each primary outcome showing pre-trend and post-trend dynamics.
6. **Report the coefficient on `v_hat`** in all Stage 2 models as a supplementary table; interpret sign and magnitude.
7. **Add Conley (1999) spatial SEs** with 50 km and 100 km bandwidths as robustness.
8. **Conduct heterogeneity analysis by FONCOMUN-dependence quintile** — this is the complier population for the eventual IV.

---

## Scores by Dimension

| Dimensión | Score | Razón |
|-----------|-------|-------|
| 1. Identification (30 pts) | 12/30 | CRE+CF without excluded instrument does not identify causal effects beyond the CRE model. Mundlak device correctly handles time-invariant heterogeneity; the CF step requires an excluded variable not yet available. |
| 2. Implementation (25 pts) | 16/25 | Stage 1 well-described. Model-outcome pairings appropriate. Mundlak correctly specified. Deductions: two-stage SEs unconfirmed; numeric SEs missing for 4/6 outcomes; AME method for FR unspecified. |
| 3. Inference (20 pts) | 14/20 | Province clustering (196 clusters) defensible. BH on primary hypotheses good practice. Deductions: numeric SEs absent; bootstrap vs. analytic unspecified; no wild cluster bootstrap. |
| 4. Robustness (15 pts) | 8/15 | Ambitious robustness plan in strategy memo. Submitted sections show only primary CRE+CF results; none of the 15 planned checks reported. Pre-trend deferred to non-submitted appendix. |
| 5. Transparency (10 pts) | 8/10 | Notably transparent: IV gap acknowledged; endogeneity test reported; BH pre-specified. Deduction: empirical strategy section and abstract describe CRE+CF as "correcting endogeneity" without adequately qualifying the excluded-instrument requirement. |
| **Total** | **58/100** | Major Revisions |
