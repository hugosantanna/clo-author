# Editorial Decision — World Development (Round 2)
**Paper:** Impacto del gasto ejecutado en limpieza pública sobre la gestión de residuos sólidos municipales en el Perú (2015–2019)
**Author:** Dante Barreto Gamarra — Maestría en Ciencias Económicas, UNAS
**Date:** 2026-04-13
**Decision:** MINOR REVISIONS
**Average referee score:** 73/100 (Domain: 80/100 | Methods: 66/100)
**Round:** 2 of 3 maximum

---

## Summary

The revision has made substantial and credible progress. All four major concerns flagged by the Domain Referee are resolved. The paper now has an external validity section with Faguet (2004) and Guerrero (2013), Oster (2019) bounds with δ* well above threshold, a formal mediation test, and a costed FONCOMUN back-of-envelope. The Domain Referee moved from 67 to 80 and recommends Minor Revisions.

The Methods Referee remains at 66 and recommends Major Revisions, anchoring primarily on causal language not being reframed given the absent excluded instrument, and on the unexplained 33x QPRS amplification.

**The editor sides with the Domain Referee on the appropriate bar for this journal, with modifications.** World Development accepts papers with bounded identification when limitations are transparently disclosed. The paper does not need an IV to be published here — it needs to say clearly that causal interpretation is conditional on the CRE assumption, that no excluded instrument was available, and that estimates should be treated as conditional effects rather than IV-equivalent causal estimates. This is a text revision, not a re-estimation. The QPRS amplification similarly requires one paragraph of economic account in the main text, not new data.

I am therefore overriding the Methods Referee's recommendation and issuing **Minor Revisions**.

---

## Where Referees Disagree — Editor's Resolution

**Disagreement: Appropriate identification standard**

Methods Referee applies a standard closer to applied-micro journals: causal claims require excluded instrument or full retraction of causal language. Domain Referee accepts CRE approach with disclosure.

**Editor's position:** The Domain Referee is correct about the journal's bar. The Methods Referee is correct that "efecto causal" without qualification is not acceptable. The fix is honest language, not a new estimation strategy. The authors need to qualify, not retract.

**Disagreement: Severity of QPRS amplification**

Methods Referee: 33x ratio is anomalous and economically implausible without explanation. Domain Referee: accepted without scrutiny after Oster bounds added.

**Editor's position:** Methods Referee is correct that an explanation is needed. The Oster bounds address whether the *true* effect could be zero, not whether the *estimate* is mechanically correct. One paragraph in the main text.

---

## Decision Letter

Dear Mr. Barreto Gamarra,

Thank you for the carefully revised manuscript. The revision is substantive and the paper is materially stronger than Round 1. The four major concerns from Round 1 have been addressed: external validity is now properly situated in the comparative decentralization literature, Oster (2019) bounds are reported with values well above the threshold of concern, the PI mediation hypothesis is empirically tested, and the FONCOMUN recommendation is grounded in a back-of-envelope fiscal estimate. The Domain Referee has moved to Minor Revisions.

I am issuing a decision of **Minor Revisions**. The remaining issues are text-level and require no re-estimation.

**The two issues that must be resolved in this final round are:**

**First, causal language.** The paper continues to state "efecto causal del gasto" and "valida la Hipótesis H1" without conditioning on the CRE assumption. The Oster bounds show that results are robust to static omitted variable bias — this is a robustness result, not a causal identification claim in the Wooldridge (2015) sense. The authors must add 2–3 sentences in §3 and the conclusion stating: (a) causal interpretation is conditional on the CRE assumption that no time-varying unobserved heterogeneity remains after controlling for time-invariant individual effects; (b) no excluded instrument was available for this revision; (c) estimates should be interpreted as upper-bound conditional effects under this assumption. This is not a retreat from the paper's contribution — the CRE+CF approach with transparent disclosure is a credible and publishable design at this journal. It is a reframing that matches language to design.

**Second, QPRS amplification.** A 33x ratio between OLS and CF estimates for QPRS, compared to 7–8x for PI and RS, requires explanation in the main text. The Oster bounds confirm the direction is robust but do not explain why the magnitude is so asymmetric across outcomes. The authors should provide one paragraph — in §4 or §5 — addressing whether this reflects the scale of the outcome variable, a floor or threshold effect, differential attenuation bias in the collection quantity measure, or another mechanism. If no economic explanation is convincing, the authors should acknowledge the anomaly explicitly and temper the policy conclusions drawn specifically from the QPRS elasticity.

This is Round 2 of a maximum of three rounds. If a Round 3 submission is needed, the available decisions will be Accept or Reject — Major Revisions will not be available. The two issues above must therefore be fully resolved in this round.

Sincerely,
The Editor, World Development

---

## MUST Address (blocking — Round 3 is Accept/Reject only)

1. **Qualify causal language throughout:** Replace unconditional "efecto causal" with language conditional on CRE assumption. Add 2–3 sentences in §3 and conclusion stating what the CF identifies, what it does not, and that estimates are conditional upper bounds under the CRE assumption. No re-estimation required.

2. **QPRS amplification — one paragraph in main text:** Explain economically why the 33x QPRS amplification differs from 7–8x in other outcomes. Unit-reconciliation, threshold effects, floor dynamics, or differential attenuation. If unexplainable, flag the result as anomalous and moderate the QPRS-specific policy conclusions.

3. **Bootstrap SEs for nonlinear CF models:** Confirm bootstrap-to-analytic SE ratio for FR (ordered probit) and RS (probit). Report in Appendix C alongside existing OLS ratios. If ratio is 0.90–1.15, concern is resolved.

4. **Negative δ* interpretation:** Add 1–2 sentences in Appendix G explaining what negative δ* means — unobservables would need to oppose observables in direction and exceed them in magnitude to nullify results. Economic interpretation of negative sign required.

---

## SHOULD Address

5. **Kinnaman (2006) benchmark:** Replace or supplement with Hoornweg and Bhada-Tata (2012) "What a Waste" (World Bank) for developing-country comparability.

6. **Oster R²_max sensitivity:** Show δ* for at least one additional R²_max multiplier (1.1 or 1.5) to confirm robustness to the 1.3× convention.

7. **Oster bounds for nonlinear estimators:** Add footnote in Appendix G acknowledging that Oster (2019) is formally valid for OLS; application to OP/Probit/FL is heuristic.

8. **DL(1) pre-trends for remaining 3 outcomes:** Report or explain why FR, CSRS, PRS are excluded from §4.7.

9. **JEL codes O18/H77:** Confirm addition or explain omission.

10. **Table 1 SE format:** Clarify in table notes whether parenthetical figures are SEs or SDs, and confirm clustering level.

---

## MAY Push Back

11. **Conley-Hansen-Rossi bounds:** Authors may respond that Oster bounds are the appropriate sensitivity tool for this design given the panel structure and absence of a spatial IV strategy.

12. **Within-municipality partial R²:** Authors may note that the full R² = 0.74 context is provided by the Mundlak mean coefficient = 0.921 in Appendix A, which implicitly discloses how much variance is cross-sectional vs. within.

13. **Corner solution QPRS:** Authors may note that the log-log specification with indicator for zero collection already handles this, citing their existing footnote or §3.3.

---

## Referee Assignments (Round 1 — same referees retained)

| Referee | Disposition | Critical peeve | Constructive peeve |
|---------|------------|---------------|-------------------|
| R1 (Domain) | POLICY | External validity (≥2 paragraphs for non-Peru policymakers) | Policy relevance even with imperfect identification |
| R2 (Methods) | CREDIBILITY | First-stage F-statistics and IV diagnostics for every specification | Testing own assumptions and reporting failures honestly |
