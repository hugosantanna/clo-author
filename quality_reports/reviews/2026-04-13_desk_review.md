# Desk Review — World Development
**Paper:** Impacto del gasto ejecutado en limpieza pública sobre la gestión de residuos sólidos municipales en el Perú (2015–2019)
**Author:** Dante Barreto Gamarra — Maestría en Ciencias Económicas, UNAS
**Date:** 2026-04-13
**Decision:** SEND TO REFEREES

---

## Rationale

**1. Strong thematic fit for World Development.** The paper addresses three core World Development themes simultaneously: fiscal decentralization and intergovernmental transfers (FONCOMUN), environmental management in a middle-income developing country (SDG 11/12), and the institutional preconditions for government service delivery. The policy recommendation — reforming FONCOMUN's allocation formula to weight solid waste management deficits — is operational and directly relevant to the journal's policy-practitioner audience.

**2. The core methodological contribution is defensible and genuinely scarce in this literature.** The development literature on municipal solid waste is dominated by descriptive cross-sections, DEA studies, and OLS correlations. This paper's use of CRE+CF (Wooldridge 2015, JHR) on a five-year panel is the first application of this estimator to solid waste management outcomes in Latin America at the municipal level. The CF test rejects exogeneity uniformly across all six outcome models. Corrected estimates are 6–33× larger than naive TWFE — changing the substantive interpretation entirely.

**3. The quantified policy implications are at the right level for World Development.** The paper translates estimates into projected impacts: 41 additional municipalities transitioning to formal landfill disposal per year; 110 tonnes/year redirected from open dumping at the median municipality. It connects the mechanism (PIGARS as eligibility condition under DL 1278) to the result, and draws the distributional implication from the sub-unit elasticity.

**4. Serious but addressable identification gap.** The paper's implementation does not yet include an external instrument. The FONCOMUN IV merge and the ENAHO/CPV external controls are noted as pending in the project files. Causal language is used throughout, but the estimator as implemented identifies only under the assumption that CRE+CF residuals are uncorrelated with time-varying unobservables beyond year FEs. Referees must push on whether the causal claims are warranted without IV validation.

**5. Discussion section's intellectual honesty is a credibility signal.** The limitations section acknowledges the IV gap, RENAMU self-reporting risk, interpolated controls, and COVID-19 external validity caveat. This transparency suggests the authors have a clear-eyed view of what their design does and does not establish.

---

## Referee Assignments

**Referee 1 (Domain — POLICY):**
- Disposition: POLICY — evaluates primarily through lens of policy relevance, implementability, and external validity for developing-country policymakers
- Critical pet peeve: External validity — will scrutinize whether Peruvian results generalize; insists on 2+ paragraphs of serious external validity discussion
- Constructive pet peeve: Champions policy relevance even with imperfect identification; will credit clear mechanism and actionable recommendations

**Referee 2 (Methods — CREDIBILITY):**
- Disposition: CREDIBILITY — focuses on whether identification supports causal claims; skeptical of identification strategies without external validation
- Critical pet peeve: First-stage diagnostics — insists on F-statistics, Cragg-Donald statistics, and IV relevance tests reported for every specification
- Constructive pet peeve: Appreciates when authors test their own assumptions and report failures honestly; rewards endogeneity testing and sensitivity analysis

---

## Notes for Referees

The central editorial question for this round: Does the current CRE+CF specification — without the FONCOMUN IV — sufficiently support the causal language used throughout?

Authors must either: (a) complete the FONCOMUN IV merge and present it as the primary robustness check; or (b) reframe the contribution as "controlling for institutional heterogeneity via Mundlak+CF" and soften causal language to conditional-on-assumptions identification.

**Areas for referee attention:**
1. FONCOMUN IV pending — Referee 2 should flag as must-complete; assess whether identification claim is credible in interim
2. External controls (ENAHO poverty, CPV urbanization) marked pending — assess sensitivity
3. RENAMU self-reporting risk: aspirational over-reporting in D2 (planning) and D3 (disposal) where budget-executing municipalities have incentive to report favorably
4. No heterogeneity analysis by municipality size/urban-rural/natural region — Referee 1 should request this for WD audience
5. CRE+CF implementation per Wooldridge (2015, JHR) is technically correct — not in dispute
6. Bonferroni-Holm applied correctly to 3 primary hypotheses — referees should not re-raise multiplicity

---

## Literature Verification

A search of the published literature finds no paper that estimates the causal effect of municipal spending on solid waste outcomes using an endogeneity-corrected panel estimator for Peru or a comparable country at the district level. Prior Peru work uses region-level aggregates, DEA efficiency methods, or cross-sectional Tobits, none addressing spending endogeneity. The novelty claim survives desk review scrutiny.
