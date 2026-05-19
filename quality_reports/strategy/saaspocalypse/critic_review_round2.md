# Strategist-Critic Review — Round 2
**Project:** saaspocalypse
**Date:** 2026-05-19
**Score: 90/100 — ADVANCES (gate: 80)**

---

## Round 1 Issue Resolution

| Issue | Required Fix | Status |
|-------|-------------|--------|
| M1 (−7): Replace IGV-XLK with in-sample SaaS-control correlation | Remove IGV-XLK; add [CONTINGENT ON DATA] in-sample group correlation in A3.1 and Threat 2 | **RESOLVED** |
| M2 (−6): Add decision rule to A11 and Decision 3 for break-date disagreement | Explicit >±3 trading days rule in both locations | **RESOLVED in strategy_memo.md; NOT REPRODUCED in robustness_plan.md A11** |
| M3 (−5): Designate Phase 1 [+1,+10] as single primary Pillar 1 window | Label hierarchy: PRIMARY / SECONDARY / ROBUSTNESS / SUMMARY | **RESOLVED** |
| Minor (−6): Unify bond notation to ABR/ASR | Consistent ABR_{i,t}/ASR_{i,t} throughout | **RESOLVED in strategy_memo.md** |

All three MAJOR issues are substantively resolved. The identification design is sound.

---

## New Issues in Round 2

**N1 (−2, implementation risk):** Robustness_plan.md A11 does not reproduce the decision rule from Decision 3. The coder will read robustness_plan.md and will not find the >±3 trading days decision rule without cross-referencing the strategy memo.

**N2 (−2, terminology):** Section 2.3.6 says "two-way cluster-robust standard errors at firm level." This should read "cluster-robust standard errors, clustered at firm level." Two-way clustering refers to two cluster dimensions (firm and time). The current wording will cause implementation confusion.

**N3 (−3, inference):** KP-BMP is listed as a co-primary parametric test in the bond pillar (N=12–20). At this sample size, the KP-BMP variance inflation formula (based on N pairwise correlations) does not have reliable asymptotic properties. Wilcoxon and permutation inference should be primary; KP-BMP should be robustness-only with explicit small-N caveat.

**N4 (−2, pre-analysis plan completeness):** No decision rule is specified for missing data in Pillar 2 predictors (ARRGrowth, NDR, GM) with uncertain coverage across the ~65-firm SaaS sample. A pre-specified maximum missingness threshold and listwise deletion vs. imputation decision must be stated before data collection.

---

## Scoring

| Deduction | Amount |
|-----------|--------|
| N1: A11 decision rule not in robustness_plan.md | −2 |
| N2: "Two-way" clustering terminology | −2 |
| N3: KP-BMP co-primary in bond pillar at N=12–20 | −3 |
| N4: Missing-data rule absent for Pillar 2 predictors | −2 |
| Opus 4.7 nested effect interpretation not spelled out | −1 |
| **Total deductions** | **−10** |

**Final Score: 90/100 — ADVANCES**

---

## Carry-Forward Actions (pre-coder dispatch)

1. Add the break-date decision rule to robustness_plan.md A11 (or explicit cross-reference to Decision 3).
2. Change "two-way cluster-robust standard errors at firm level" → "cluster-robust standard errors, clustered at firm level" in Section 2.3.6.
3. Demote KP-BMP in bond pillar Section 2.4.4 from co-primary to robustness-only with small-N caveat.
4. Add missing-data decision rule for ARRGrowth, NDR, GM in Section 2.2.4: pre-specify maximum missingness threshold and handling approach.
5. (Advisory) Clarify total Phase 3 combined effect formula: Total = β₃ × (Phase3 days excl. Opus47) + (β₃ + β₄) × (Opus47 days).
