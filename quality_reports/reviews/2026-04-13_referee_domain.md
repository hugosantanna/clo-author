# Referee Report — Domain (Round 1)
**Journal:** World Development
**Disposition:** POLICY
**Date:** 2026-04-13
**Recommendation:** Major Revisions
**Score:** 67/100

---

## Summary Assessment

This paper addresses a genuinely important question for development policy: does municipal spending on solid waste collection services improve solid waste management outcomes, and through which channels? The empirical setting — Peru's highly fragmented system of 1,874 district-level municipalities operating under fiscal decentralization — is well-suited to this question, and the CRE+CF estimator is a defensible methodological choice for correcting the endogeneity of public expenditure in a nonlinear panel framework. The three results — a near-unit elasticity of daily waste collection with respect to spending, a significant planning index response, and a modest but significant increase in sanitary landfill use — are internally coherent and mechanistically plausible.

The central weakness is that the paper remains almost entirely a Peru paper. The external validity discussion is limited to one paragraph in Section 4.4 that addresses only the COVID-19 time boundary, without engaging the comparative development literature on why findings from Peru's specific institutional context should travel to other decentralizing middle-income countries. For a journal whose readership spans Latin America, Sub-Saharan Africa, South Asia, and Southeast Asia, the absence of explicit comparators is a material gap.

A secondary concern is that the CRE+CF estimator's sensitivity to its untested assumptions is not bounded. Given that policy recommendations rest on the headline elasticity of +0.879, the robustness of this number to alternative identification is the critical open question.

---

## Major Concerns

**1. External validity: Peru's results are not connected to the comparative development literature.**

The paper contains zero external validity claim in the abstract. Section 4.4 devotes one paragraph to the COVID-19 boundary but makes no comparison with Faguet (2004) on Bolivia, Sub-Saharan African municipal service delivery studies, or South Asian urban waste management evidence. The reference to Bel (2010) on Catalan municipalities is the only international comparator.

**What would change my opinion:** Add at minimum two full paragraphs — in Section 4.3 or a dedicated subsection on external validity — explicitly comparing Peru's elasticity estimate with two or three comparator countries: (a) whether the near-unit elasticity is high or low relative to comparable developing-country settings and why; (b) whether the institutional channel (gasto to PI to RS) is specific to Peru's regulatory structure or generalizable where PIGARS-type requirements exist; (c) what characteristics of a country's fiscal decentralization architecture are necessary for the mechanism to operate. Faguet (2004) on Bolivia and at least one Sub-Saharan African or South Asian study should anchor this discussion.

**2. The 30-fold CRE+CF-to-TWFE amplification is not explained or bounded.**

The QPRS elasticity goes from 0.027 (TWFE) to 0.879 (CRE+CF) — a factor of 32.5. For PI, the ratio is 7.7. The paper attributes all amplification to attenuation bias but provides no Oster (2019) bounds, no sensitivity analysis, and no cross-validation against lagged-spending specifications.

**What would change my opinion:** Report Oster (2019) delta bounds for the QPRS elasticity. If delta substantially exceeds 1, the result is robust. Alternatively, implement a lagged-gasto specification as a robustness column. If the FONCOMUN IV is feasible within a revision cycle, preliminary IV estimates would substantially strengthen the paper.

**3. The PIGARS channel is asserted but not empirically tested as a mediator.**

Section 4.2 proposes a gasto to PI to RS chain as the primary institutional mechanism. This is the paper's most policy-relevant finding. But the paper estimates gasto-to-PI and gasto-to-RS as separate reduced-form equations without testing whether PI mediates the RS effect.

**What would change my opinion:** Add one supplementary table reporting the RS Probit CRE+CF with PI added as a covariate. If the AME on gasto falls substantially when PI is controlled, this validates the institutional mediation hypothesis. Either result adds information.

**4. The FONCOMUN formula recommendation is uncosted and not operationalized.**

The paper recommends modifying FONCOMUN's distribution coefficients to weight solid waste management deficits. FONCOMUN formula changes require Congressional action. The paper does not estimate how much additional FONCOMUN revenue the target municipalities would receive, what share of the gasto-to-RS gap this would close, or whether the reform is feasible under existing institutions.

**What would change my opinion:** A back-of-envelope calculation using the AME on RS (0.022 per 10% spending increase) and the distribution of current gasto levels across quintiles of municipal fiscal capacity. A rough estimate of municipalities transitioning to formal disposal under the proposed reform would give the recommendation quantitative grounding.

---

## Minor Concerns

- Abstract is 245 words. World Development allows 250 so this passes, but it should be pruned for clarity.
- JEL codes should include O18 (Housing; Infrastructure) and H77 (Intergovernmental Relations; Federalism) for better indexing.
- Table 1 reports SEs only for QPRS (0.021) and PI (0.015); other SEs listed as "(clust.)" without numerical values — nonstandard.
- The SUTVA assertion that "los contratos de concesión de residuos no cruzaban límites distritales" needs supporting evidence (citation or RENAMU descriptive statistic).
- The event-study pre-trend test is referenced to a non-submitted appendix; key directional result should appear in the main text.
- Kinnaman (2006) benchmark is imprecise: Kinnaman (2006) concerns curbside recycling and unit pricing in US municipalities, not developing-country landfill subsidy programs as the text implies.
- Section 4.3 cites "Ley N° 29419" for mancomunidades. Ley 29419 is the Ley de Actividades de los Artesanos Peruanos. The correct reference is Ley N° 29029 (Ley de la Mancomunidad Municipal, 2007).
- The Conley-Hansen-Rossi bounds referenced in Section 3.2 imply results are available; they should be presented or clearly labeled as a future extension.

---

## Missing Literature

1. **Faguet (2004)** — "Does decentralization increase government responsiveness?" *Journal of Public Economics*. Bolivia is Peru's closest LAC comparator for decentralized service delivery. Absence is notable.
2. **Guerrero, Maas & Hogland (2013)** — "Solid waste management challenges for cities in developing countries." *Waste Management*. Standard reference for the developing-country MSW literature.
3. **Oates (1972)** — *Fiscal Federalism.* Canonical theoretical framework; listed as seminal reference in domain profile. Absent from submitted sections.
4. **Besley & Case (1995)** — AER. Municipal governments' response to fiscal incentives underpins the paper's argument.
5. **Oster (2019)** — *Journal of Business and Economic Statistics.* Essential for bounding sensitivity of headline elasticity. With a TWFE-to-CRE+CF ratio of 32.5, Oster bounds are not optional.

---

## Scores by Dimension

| Dimensión | Score | Razón |
|-----------|-------|-------|
| 1. Contribution & Positioning | 17/25 | Important question, genuine CRE+CF contribution, but positioned almost entirely within Peru's policy literature. Faguet (2004), Besley & Case (1995), Oates (1972) absent. |
| 2. Data & Measurement | 14/20 | RENAMU appropriate; five-year panel adequate. Deductions: no RS validation; numeric SEs missing; unexplained 97-obs gap in RS sample. |
| 3. Results & Interpretation | 18/25 | Coherent, consistently signed. Deductions: factor-of-32 ratio unexplained; PI-to-RS mediation untested; Kinnaman (2006) benchmark imprecise. |
| 4. Policy Implications | 12/20 | FONCOMUN recommendation specific. Deductions: zero external validity for non-Peru policymakers; uncosted; incorrect legal citation (Ley 29419 vs. 29029). |
| 5. Writing & Presentation | 6/10 | Clear prose. Deductions: SEs missing in table; event-study result not reported in main text. |
| **Total** | **67/100** | Major Revisions |
