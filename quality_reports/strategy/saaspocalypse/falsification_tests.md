# Falsification and Placebo Tests — "Another Model, Another SaaSpocalypse"
# Specifies what SHOULD NOT show effects if the causal story is correct.
# All tests must be implemented by the coder and results reported in the appendix.

---

## Logic of Falsification in This Setting

A falsification test asks: "If Claude Opus 4.6 is truly the cause of the SaaS return differential, which groups or time periods should NOT show the same pattern?" Three classes of falsification are appropriate here:

1. **Placebo time:** Same treatment (SaaS vs. non-SaaS) but wrong event date — should produce null result
2. **Placebo group:** Same event date (Feb 5, 2026) but a different sector that should not be affected — should produce null result
3. **Counterfactual mechanism:** Within SaaS, firms whose products are outside the Claude Opus 4.6 capability domain — should show smaller or zero negative CAR in Phase 1

The standard for a convincing falsification is: the placebo produces a coefficient indistinguishable from zero at conventional significance levels, while the true DiD estimate is significantly different from zero.

---

## Test F1: Pre-Event Placebo DiD (Placebo Time)

**What it tests:** If the SaaS DiD result is spurious — driven by persistent SaaS underperformance or systematic SaaS-vs-non-SaaS trends — a placebo event at a different date should show similar "effects." If the result is causal, the placebo should show null.

**Design:**
- Estimation panel: May 18, 2024 – January 31, 2026 (entirely pre-event)
- Placebo event date: April 1, 2025 (arbitrary mid-estimation date; no known AI event)
- Define placebo phase dummies: PseudoPhase1 = $[+1, +10]$ days relative to April 1, 2025; PseudoPhase2 = $[+11, +47]$ days relative to April 1, 2025
- Estimate: $R_{i,t} = \alpha_i + \gamma_t + \beta_1^{pl}(SaaS_i \times PseudoPhase1_t) + \beta_2^{pl}(SaaS_i \times PseudoPhase2_t) + \varepsilon_{i,t}$
- Standard errors clustered at firm level

**Expected result if causal:** $\hat{\beta}_1^{pl}$ and $\hat{\beta}_2^{pl}$ are statistically indistinguishable from zero. The SaaS differential return dynamic should not replicate at a random pre-event date.

**Failure interpretation:** If placebo returns are also significant, it suggests SaaS firms were already diverging from non-SaaS software firms before the event — a parallel trends violation. Escalate immediately.

**Output:** Placebo DiD coefficient table; comparison to true-event DiD magnitudes.

---

## Test F2: Unrelated Sector Placebo DiD (Placebo Group)

**What it tests:** If the Feb 5, 2026 period is associated with broad market dynamics that happen to produce Phase 1/Phase 2 patterns across all industries, a randomly chosen sector should also show "effects." If the Claude Opus 4.6 result is SaaS-specific, an unrelated sector should show null.

**Design:**
- Define "placebo treated group": Health IT and Digital Health firms (GICS 351020 — Health Care Technology)
- Define "placebo control group": S&P 500 Healthcare firms excluding Health IT (GICS 351010, 352020)
- Estimate: $R_{i,t} = \alpha_i + \gamma_t + \beta_1^{pl}(HealthIT_i \times Phase1_t) + \beta_2^{pl}(HealthIT_i \times Phase2_t) + \beta_3^{pl}(HealthIT_i \times Phase3_t) + \varepsilon_{i,t}$
- Same event date (Feb 5, 2026) and same phase windows as the main analysis
- Standard errors clustered at firm level

**Rationale:** Health IT firms do not primarily deliver subscription software for LLM-addressable tasks; they are subject to different regulatory and patient-data constraints that limit direct AI substitution. Claude Opus 4.6 is not advertised as a substitute for electronic health records or clinical workflow software.

**Expected result if causal:** $\hat{\beta}_1^{pl}$, $\hat{\beta}_2^{pl}$, $\hat{\beta}_3^{pl}$ are statistically indistinguishable from zero. The Phase 1 negative differential and Phase 3 reversal should not appear in an unaffected sector.

**Failure interpretation:** If Health IT shows the same Phase 1 negative / Phase 3 reversal pattern, it suggests market-wide dynamics unrelated to Claude Opus 4.6 are driving the result.

**Output:** Placebo sector DiD coefficient table; comparison to main SaaS results.

---

## Test F3: Within-SaaS Placebo — Non-Frontier Products

**What it tests:** Within the SaaS treatment group, firms whose core products address tasks outside the Claude Opus 4.6 capability frontier (the Dell'Acqua et al. 2026 "jagged frontier" — tasks where AI hallucinates, lacks domain knowledge, or requires physical-world integration) should show weaker or zero negative Phase 1 CARs. If the disruption mechanism is frontier-specific, non-frontier SaaS firms are a within-sample placebo.

**Design:**
- Classify each SaaS firm in the sample according to whether its primary product operates in tasks identified as inside vs. outside the Claude Opus 4.6 capability frontier (based on Anthropic's public benchmark suite and Dell'Acqua et al. 2026 frontier taxonomy):
  - Inside frontier (AI-addressable): task automation, customer service bots, CRM, marketing automation, HR workflow, basic legal discovery
  - Outside frontier (non-addressable): complex clinical decision support, construction management, specialized regulatory compliance, physical-world field service management
- Compare Phase 1 CARs: inside-frontier SaaS vs. outside-frontier SaaS
  - Expected: inside-frontier firms show significantly more negative Phase 1 CARs
  - Outside-frontier firms act as a within-sample placebo: they should show near-zero Phase 1 CARs

**Estimation:** Two-sample t-test and Wilcoxon test comparing Phase 1 CAR distributions; Pillar 2 regression with a binary frontier indicator as an additional regressor.

**Expected result if causal:** Outside-frontier SaaS firms show Phase 1 CARs statistically indistinguishable from zero; inside-frontier SaaS firms show significantly negative Phase 1 CARs.

**Caveats:** Classification of SaaS products as inside vs. outside the frontier requires a judgment call and is subject to researcher discretion. All classifications should be made before inspecting phase CARs (pre-registered classification) and documented in the data codebook.

**Output:** Classification table (firm, product category, frontier status); CAR comparison table by frontier status; regression of Phase 1 CAR on frontier indicator (within-SaaS, HC3 SE).

---

## Test F4: Permutation Distribution of DiD Estimates (5,000 Pseudo-Event Dates)

**What it tests:** If the true-event DiD estimates are exceptional relative to the distribution of DiD estimates at random event dates within the estimation window, this provides nonparametric evidence that the event is causally responsible (rather than the estimate reflecting typical SaaS vs. non-SaaS variation at any arbitrary date).

**Design:**
- This is identical to the Andrews-Farboodi (2025) permutation inference in Pillars 1 and 4 but applied to the DiD estimates
- Draw 5,000 pseudo-event dates uniformly from the estimation window (May 18, 2024 – January 31, 2026), excluding the 10-day window before the true event
- For each pseudo-event date, compute the static phase-DiD using the same Phase 1 / Phase 2 / Phase 3 window lengths but anchored to the pseudo-date
- Compute the empirical p-value: fraction of pseudo-event DiD estimates more extreme (more negative for Phase 1/2 and more positive for Phase 3) than the true-event estimate

**Expected result if causal:** The true-event DiD estimates should be in the tail of the permutation distribution. An empirical p-value $< 0.05$ provides nonparametric confirmation.

**Failure interpretation:** If the true-event DiD estimate is not in the tail of the permutation distribution, the DiD result is not exceptional relative to arbitrary dates — suggesting the SaaS-non-SaaS differential was not caused by the Claude Opus 4.6 release specifically.

**Output:** Permutation distribution histogram for Phase 1 DiD estimate; true-event value marked as vertical line; empirical p-value.

---

## Test F5: Phase 3 Reversal Not Present in Random Sub-Period

**What it tests:** The Phase 3 reversal (positive $\hat{\beta}_3$ in the DiD) is a specific prediction of Pástor-Veronesi (2009) rational learning. If positive Phase 3 coefficients arise at random post-event periods, they are uninformative. This test checks whether the Phase 3 reversal is specific to the post-Oracle-RPO-disclosure period.

**Design:**
- Define 5 alternative "Phase 3" windows: the same 22-trading-day window shifted by $\{+5, +10, +15, +20, +25\}$ trading days (extending further into May–June 2026)
- For each alternative Phase 3 window, estimate the static DiD and report $\hat{\beta}_3$ for that window
- Compare: the reversal should be strongest in the true Phase 3 window (anchored to Oracle RPO disclosure) and attenuate or disappear in later windows as the market stabilizes

**Expected result if Phase 3 is causally anchored to Oracle RPO:** The true Phase 3 coefficient $\hat{\beta}_3$ should be most positive in the true window and decay or turn zero in later windows. If $\hat{\beta}_3$ is equally positive in all shifted windows, the reversal is generic market rebound, not AI-learning-specific.

**Output:** Table of $\hat{\beta}_3$ estimates across 6 Phase 3 windows (true + 5 shifts); plot of $\hat{\beta}_3$ vs. Phase 3 start date.

---

## Test F6: Bond-Equity Co-movement in Direction Consistent with AI Disruption (Not Generic Credit Tightening)

**What it tests:** If the bond ABRs are driven by generic credit market tightening (e.g., macro credit risk-off episodes) rather than SaaS-specific AI disruption, they should be equally large for non-SaaS software bonds. If the result is disruption-specific, SaaS bonds should show larger spread widening than non-SaaS software bonds.

**Design:**
- Compare Phase 1 and Phase 2 bond ABRs between SaaS issuer bonds and non-SaaS software issuer bonds (control bonds in Pillar 4)
- If both groups show equal spread widening, the result is generic macro credit risk — not a SaaS-specific AI disruption signal
- Two-sample Wilcoxon test of SaaS vs. non-SaaS bond ABRs in Phase 1 and Phase 2

**Expected result if disruption-specific:** SaaS bonds show larger (more negative) Phase 1 and Phase 2 ABRs than non-SaaS software bonds ($p < 0.10$).

**Failure interpretation:** If both groups show equal spread widening, Pillar 4 results cannot be attributed to AI disruption specifically. Relabel as descriptive.

**Output:** Mean ABR table by group (SaaS bonds vs. non-SaaS software bonds) for each phase; Wilcoxon test p-values.

---

## Implementation Instructions for Coder

1. All falsification tests must be run as part of the same R analysis pipeline as the main results.
2. Results must be reported in a dedicated "Falsification Tests" section of the appendix, not in the main tables.
3. Each test must produce a separate LaTeX table exported to `paper/tables/falsification/` subdirectory.
4. If any falsification test FAILS the expected null result (i.e., shows a significant effect where there should be none), flag immediately in the session log and escalate to the strategist-critic.
5. The coder does NOT decide what to do with a failed falsification test — only the strategist-critic and user make that determination.

---

## Summary Table

| Test | Type | Expected Result | Failure Risk | Priority |
|------|------|----------------|-------------|---------|
| F1: Pre-event placebo DiD | Placebo time | Null | Reveals pre-trends → DiD invalid | 1 |
| F2: Health IT sector placebo | Placebo group | Null | Reveals non-SaaS-specific market dynamics | 1 |
| F3: Non-frontier within-SaaS | Mechanism placebo | Null (outside frontier) | Frontier classification subjective | 2 |
| F4: 5,000 pseudo-event DiD | Permutation | True event in tail | Moderate — if SaaS trends diverged before Feb 5 | 1 |
| F5: Phase 3 shifted windows | Reversal specificity | Decay after true window | Low — reversal may persist if rebound is broad | 2 |
| F6: Bond SaaS vs. non-SaaS | Cross-market specificity | SaaS bonds worse | Low — if macro credit tightening dominates | 2 |

---

*End of falsification tests.*
