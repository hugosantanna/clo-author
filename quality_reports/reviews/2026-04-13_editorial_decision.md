# Editorial Decision — World Development (Round 1)
**Paper:** Impacto del gasto ejecutado en limpieza pública sobre la gestión de residuos sólidos municipales en el Perú (2015–2019)
**Author:** Dante Barreto Gamarra — Maestría en Ciencias Económicas, UNAS
**Date:** 2026-04-13
**Decision:** MAJOR REVISIONS
**Average referee score:** 62.5/100 (Domain: 67/100 | Methods: 58/100)
**Round:** 1 of 3 maximum

---

## Classification of Referee Concerns

### Fatal (paper rejected if not addressed)
*None.* No concern rises to "wrong question" or "contribution doesn't exist." The methodological core is sound at the CRE level; the identification gap is real and acknowledged, but closable within a revision cycle.

### Addressable — Major Revision Required

1. **[Both referees]** Causal language unsupported by identification as implemented. CF without excluded instrument does not purge time-varying confounders.
2. **[Both referees]** 32× QPRS amplification (TWFE=0.027, CRE+CF=0.879) is unexplained and economically implausible if attributed purely to attenuation bias.
3. **[Methods referee]** Numeric SEs missing for four of six outcome columns in Table 1.
4. **[Methods referee]** Two-stage bootstrap for nonlinear CF specifications not confirmed.
5. **[Methods referee]** Pre-trend evidence deferred to non-submitted appendix.
6. **[Domain referee]** External validity limited to one paragraph on COVID-19 timing.
7. **[Domain referee]** FONCOMUN recommendation uncosted.
8. **[Domain referee]** PI-to-RS mediation asserted but untested.

### Taste (may push back)

1. Wild cluster bootstrap — with 196 clusters, asymptotic inference is defensible.
2. Conley (1999) spatial SEs — legal SUTVA defense + province clustering address most spatial correlation.
3. Typographic demarcation of secondary outcomes — pre-specified BH correction already signals this.
4. Abstract word count — 245 words is within WD's 250-word limit.

---

## When Referees Disagree

**Disagreement 1: Severity of the missing-IV problem.**
Methods referee: "the central methodological problem that invalidates the causal claims." Domain referee: secondary concern requiring Oster bounds, not undermining contribution.

**Editor's position:** Methods referee is correct on the logic; Domain referee is correct on the remedy. The CF without IV is a limitation, not a fatal flaw, when (a) the paper is transparent, (b) the CRE Mundlak device already handles time-invariant heterogeneity, and (c) the FONCOMUN IV is feasible within a revision. World Development regularly accepts papers with bounded identification when the policy question is important and institutional analysis is rigorous. Causal language must, however, be qualified or defended with the IV.

**Disagreement 2: Economic plausibility of the 32× amplification.**
Methods referee raises a pointed concern: if OVB is attenuation-downward on a positive coefficient, high-institutional-quality municipalities must collect *fewer* kg/day conditional on spending — implausible. Domain referee accepts the attenuation narrative without scrutiny.

**Editor's position:** The Methods referee's argument deserves a direct response. If the CF residual is partly capturing time-varying institutional improvements rather than correcting pure attenuation bias, this should be stated explicitly. The v_hat coefficient in Stage 2 is the diagnostic — reporting it is not optional.

**Disagreement 3: Stage 1 R² = 0.74.**
Methods referee: mechanically inflated by Mundlak means, potentially misleading. Domain referee: does not raise this.

**Editor's position:** Methods referee is descriptively correct. The within-municipality partial R² is the relevant figure. This is a SHOULD-level correction, not a MUST.

---

## Decision Letter

Dear Mr. Barreto Gamarra,

Thank you for submitting your paper to World Development. The paper has been reviewed by two referees and I have read both reports independently.

The paper addresses a question directly relevant to World Development's audience: whether increased municipal expenditure on solid waste collection translates into measurable improvements in outcomes, and through which institutional channels. The empirical setting — Peru's 1,874 district municipalities operating under FONCOMUN-financed fiscal decentralization — is well-suited to this question, and the application of the CRE+CF estimator (Wooldridge 2015, JHR) to correct for spending endogeneity in a nonlinear panel framework is genuinely scarce in the developing-country MSW literature. The three primary results are internally coherent and mechanistically plausible. The paper's transparency about its own limitations is a credibility signal. For these reasons, I am inviting a major revision.

Both referees converge on the same two central problems. First, the causal language used throughout — "efecto causal," "valida la Hipótesis H1" — is not supported by the identification strategy as currently implemented. Wooldridge (2015, JHR) requires an excluded external instrument in Stage 1 for the CF step to provide identification beyond the CRE model; without it, v_hat corrects for time-invariant heterogeneity (already addressed by Mundlak) but not for time-varying confounders such as new administrations, targeted central transfers, or local fiscal shocks that move both spending and outcomes simultaneously. The authors must take one of two paths: (a) merge the FONCOMUN formula instrument and report Kleibergen-Paap F-statistics, partial R², and Conley-Hansen-Rossi plausible exogeneity bounds; or (b) explicitly reframe as "CRE estimator with endogeneity diagnostic" and provide Oster (2019) delta bounds for each primary outcome. Causal language must align with the chosen path.

Second, the 32-fold TWFE-to-CRE+CF amplification for QPRS (0.027 to 0.879) requires direct explanation. If the bias is attenuation-downward on a positive coefficient, the implied OVB direction requires that high-institutional-quality municipalities collect fewer kilograms per day conditional on spending — which is economically difficult to rationalize. The authors should report the coefficient on v_hat in each Stage 2 model in a supplementary table and interpret its sign. If the CF residual is partly capturing time-varying institutional improvements, that interpretation should be stated transparently.

Beyond these issues, the Domain referee identifies three additional required revisions I concur with: developing the external validity discussion substantially (two paragraphs comparing Peru's elasticity with developing-country comparators, beginning with Faguet (2004) on Bolivia); providing a back-of-envelope estimate of the fiscal magnitude of the FONCOMUN formula reform recommendation; and testing the PI mediation hypothesis empirically with a supplementary Probit specification that includes PI as a covariate in the RS equation.

This is Round 1 of a maximum of three rounds at this journal.

Sincerely,
The Editor, World Development

---

## MUST Address (blocking)

1. **IV or explicit reframing:** Merge FONCOMUN instrument and report Kleibergen-Paap F-statistic, partial R², and Conley-Hansen-Rossi bounds; OR reframe identification as CRE-conditional and provide Oster (2019) delta bounds for QPRS, PI, and RS. Causal language must align with the chosen path.

2. **Explain the 32× QPRS amplification:** Report coefficient on v_hat in Stage 2 for all six models in a supplementary table. Interpret sign and magnitude. If CF partly captures time-varying institutional improvements, state this explicitly.

3. **Numeric SEs for all six columns:** Report clustered or block-bootstrap SEs for FR, CSRS, RS, and PRS. Confirm two-stage bootstrap or analytic correction for nonlinear models.

4. **Pre-trend results in main text:** Report distributed-lag pre-trend coefficient, SE, and p-value for QPRS, PI, and RS. Remove reference to non-submitted appendix.

5. **External validity section (≥2 paragraphs):** Compare Peru's elasticity against Faguet (2004, Bolivia) and at least one Sub-Saharan African or South Asian comparator. Identify institutional preconditions for mechanism generalizability.

6. **Costed FONCOMUN recommendation:** Back-of-envelope estimate of municipalities transitioning to formal disposal under proposed formula reform, using RS AME and gasto distribution across fiscal capacity quintiles.

7. **PI mediation test:** Supplementary Probit CRE+CF table with PI as covariate in RS equation. Report and interpret change in gasto AME.

---

## SHOULD Address (strongly encouraged)

1. Report within-municipality partial R² for Stage 1 (alongside total R² = 0.74, which is inflated by Mundlak means).
2. Add Faguet (2004), Guerrero et al. (2013), Oates (1972), and Besley & Case (1995) to literature review.
3. Correct Kinnaman (2006) benchmark — the paper concerns US curbside recycling, not developing-country landfill programs.
4. **Correct legal citation:** Section 4.3 cites Ley 29419 for mancomunidades. Correct reference is Ley 29029 (Ley de la Mancomunidad Municipal, 2007).
5. Supporting evidence for SUTVA inter-district claim (RENAMU descriptive statistic or citation).
6. Clarify corner-solution treatment for QPRS: fraction of zero-collection obs; sensitivity of elasticity to zeros.
7. Add JEL codes O18 and H77.

---

## MAY Push Back

1. Wild cluster bootstrap (with 196 clusters, asymptotic inference is defensible).
2. Conley (1999) spatial SEs (legal SUTVA defense + province clustering address most spatial correlation).
3. Typographic demarcation of secondary outcomes (pre-specified BH correction already signals the distinction).
4. Abstract word count (245 words is within the 250-word WD limit).

---

## Referee Assignments (for author's information)

| Referee | Disposition | Critical peeve | Constructive peeve |
|---------|------------|---------------|-------------------|
| R1 (Domain) | POLICY | External validity (≥2 paragraphs for non-Peru policymakers) | Policy relevance even with imperfect identification |
| R2 (Methods) | CREDIBILITY | First-stage F-statistics and IV diagnostics for every specification | Testing own assumptions and reporting failures honestly |
