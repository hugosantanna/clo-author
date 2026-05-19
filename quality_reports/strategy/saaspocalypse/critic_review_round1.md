# Strategist-Critic Review — Round 1
**Project:** saaspocalypse
**Date:** 2026-05-19
**Score: 76/100 — DOES NOT ADVANCE**
**Gate:** 80/100 required to advance

---

## Phase 1: Claim Identification

**Design:** Matched-sample Difference-in-Differences (DiD) as primary causal identification — ✓ clearly stated.  
**Estimand:** ATT τ_ATT(s,t) = E[R_{i,t}(1) − R_{i,t}(0) | T_i = 1] — ✓ well-specified with correct potential outcomes notation.  
**Treatment:** SaaS firms (Syntax SYSAAS universe, ~65 firms post-screening) — ✓ defined.  
**Control:** Non-SaaS GICS 451030 S&P 500 firms (~25–40) — ✓ defined with rationale.  
**Primary window:** Claimed, but see M3 below — not fully designated.  
**Theoretical anchor:** Pástor-Veronesi (2009) three-phase framework — ✓ clearly linked.  

**Phase 1 deductions:** 0

---

## Phase 2: Core Design Validity

### Issue M1 — IGV–XLK Parallel Trends Evidence (MAJOR, −7 pts)

**Finding:** Section 3.2 (Assumption A3.1: Parallel Trends) cites a pre-event return correlation of 0.848 between iShares Expanded Tech-Software ETF (IGV) and Technology Select Sector SPDR (XLK) as empirical support for the parallel trends assumption.

**Problem:** This is the wrong empirical object. IGV is a broad tech-software ETF whose constituents include many non-SaaS enterprise software firms, hardware-adjacent software companies, and large-cap platform firms. XLK includes hardware, semiconductors, and other technology sectors that are not in the control group. Neither IGV nor XLK maps to the actual treatment cohort (Syntax SYSAAS ~65 firms) nor the actual control cohort (non-SaaS GICS 451030 S&P 500 ~25–40 firms).

**Required correction:** Replace with the in-sample pre-event equal-weighted return correlation between SaaS treatment cohort and non-SaaS control cohort, computed over the estimation window [-261, -11]. If this cannot be computed before data collection, the statement must be flagged as [CONTINGENT ON DATA] and removed as a supporting argument — the IGV-XLK figure must not be cited as evidence of parallel trends for this specific design.

**Deduction: −7**

---

### Issue M2 — Missing Decision Rule for A11 Break-Date Disagreement (MAJOR, −6 pts)

**Finding:** Robustness check A11 (Quandt-Andrews supremum-Wald + Bai-Perron structural break tests) is designed to validate the Oracle RPO Phase 2/3 boundary (April 10–13, 2026). The robustness plan correctly notes the break-date validation exercise. However, neither the strategy memo nor the robustness plan specifies a decision rule for the scenario in which the data-driven break date differs from the Oracle RPO anchor date by more than ±3 trading days.

**Problem:** Without a pre-specified decision rule, a disagreement between the statistical break date and the narrative anchor date cannot be interpreted. If the data break lands on April 3 (7 days before Oracle), it is unclear whether this (a) validates the Oracle anchor (close enough), (b) indicates a different driver of Phase 3 onset, (c) triggers the fallback boundary or (d) invalidates the phase architecture entirely. This decision point must be pre-specified.

**Required correction:** Add an explicit decision rule to Robustness A11 and to the Phase Boundary Endogeneity discussion (Decision 3 in the strategy memo): if QA/BP break date ≠ Oracle RPO date by more than ±3 trading days, the author must (i) report both dates transparently, (ii) assess whether a plausible confounding event occurred at the statistical break date, and (iii) decide whether to anchor the Phase boundary to the Oracle RPO date (theory-driven, stated a priori) or the statistical break date (data-driven). The default should be stated: recommend anchoring to Oracle RPO (theory-driven, pre-specified) and treating the break test as a validation check, with a footnote if break dates disagree.

**Deduction: −6**

---

### Issue M3 — No Designated Primary Pillar 1 Event Window (MAJOR, −5 pts)

**Finding:** Section 2.1.2 (Pillar 1 FF5 Event Study) lists eight event windows: Phase 1 [+1,+10], Phase 2 [+11,+47], Phase 3 [+50,+70], Full Arc [+1,+70], and four shorter windows ([0,+1], [0,+2], [0,+3], [0,+5]). No window is designated as the primary pre-specified test. All eight are reported as co-equal.

**Problem:** Reporting eight simultaneous windows without a primary designation exposes the paper to a data-mining critique. A referee will ask: which window was the hypothesis? The answer cannot be "all of them." The three-phase architecture motivates Phase 1 [+1,+10] as the natural primary window (immediate reaction to the announcement), but this is not stated.

**Required correction:** Designate one window as PRIMARY — recommended: Phase 1 [+1,+10] for the immediate SaaS reaction, consistent with the Pástor-Veronesi discount-rate phase. All other windows should be labeled SECONDARY or ROBUSTNESS, with a footnote explaining the rationale for each. The full arc [+1,+70] may be reported as a summary window but must not be tested as a primary hypothesis given its overlap with the DiD Pillar 3 estimand.

**Deduction: −5**

---

## Phase 3: Inference Soundness

**Clustering:** Firm-level two-way clustering (firm × day) — ✓ appropriate for DiD.  
**KP correction:** Explicitly required for Pillar 1 simultaneous-event setting — ✓ present.  
**Wild cluster bootstrap:** Included in Robustness A7 — ✓ appropriate for small N.  
**Multiple testing:** Bonferroni for Pillar 2 — ✓ conservative, appropriate. Romano-Wolf step-down in Robustness D1 — ✓ good.  
**HonestDiD:** Rambachan-Roth sensitivity for parallel trends violations — ✓ present.  

**Phase 3 deductions:** 0 (all inference issues captured under MAJOR issues above)

---

## Phase 4: Polish and Completeness

**Robustness plan:** Comprehensive — 20 checks, ordered by priority. ✓  
**Falsification tests:** 6 tests, all well-motivated. F4 permutation test excellent. ✓  
**Referee objection anticipation:** Present — joint hypothesis, confounding, single-event, phase boundary — ✓.  
**Theory linkage:** Pástor-Veronesi three phases explicitly mapped to β₁, β₂, β₃ pattern predictions — ✓.  
**Bond pillar:** BKMX framework, EGY standardization, synthetic control contingency — ✓.  
**SPXXAI access note:** Model-free benchmark contingency if constituent list unavailable — ✓.  

**Phase 4 deductions:** −6 (minor issues — notation inconsistency in bond section: uses both ABR_{i,t} and AR^b_{i,t} without cross-referencing)  

**Notation inconsistency (minor, −6):** The bond pillar uses `ABR_{i,t}` (abnormal bond return) and `ASR_{i,t}` (abnormal standardized return) in some sections but `AR^b_{i,t}` in others. The domain-profile.md notation convention specifies `ABR_{i,t}/ASR_{i,t}`. All bond return notation should be unified. This is flagged as a minor deduction at Execution phase severity; it is not a blocking issue for this review round.

---

## Summary Score

| Phase | Issue | Severity | Deduction |
|-------|-------|----------|-----------|
| 2 | M1: IGV-XLK wrong parallel trends proxy | MAJOR | −7 |
| 2 | M2: No break-date decision rule for A11 | MAJOR | −6 |
| 2 | M3: No designated primary Pillar 1 window | MAJOR | −5 |
| 4 | Minor: Bond notation inconsistency ABR/AR^b | MINOR | −6 |
| — | All other sections | PASS | 0 |
| **Total** | | | **−24** |

**Final Score: 76/100**

---

## Required Corrections Before Re-Submission

1. **M1:** Replace the IGV-XLK correlation with the in-sample pre-event SaaS vs. non-SaaS return correlation. If unavailable pre-data, flag as [CONTINGENT ON DATA] and remove IGV-XLK as a supporting argument for parallel trends.

2. **M2:** Add a decision rule to Robustness A11 and Decision 3: if QA/BP break date disagrees with Oracle RPO by >±3 trading days, anchor to Oracle RPO (theory-driven, pre-specified) and report the statistical break as a validation footnote. Both dates reported transparently regardless.

3. **M3:** Designate Phase 1 [+1,+10] as the single primary Pillar 1 event window. Label all other windows SECONDARY or ROBUSTNESS. Full arc [+1,+70] is a summary window, not a primary hypothesis.

4. **Minor:** Unify all bond abnormal return notation to `ABR_{i,t}` / `ASR_{i,t}` throughout strategy_memo.md and pseudo_code.md.

---

**Escalation status:** Round 1 of 3. Strategist must address all three MAJOR issues in Round 2.
