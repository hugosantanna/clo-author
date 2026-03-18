---
name: strategize
description: Design identification strategy or pre-analysis plan. Dispatches Strategist (proposer) and strategist-critic (validator). Replaces /identify and /pre-analysis-plan.
argument-hint: "[mode: strategy | pap] [research question or spec path]"
allowed-tools: Read,Grep,Glob,Write,Task
---

# Strategize

Design an identification strategy or pre-analysis plan by dispatching the **Strategist** (proposer) and **strategist-critic** (validator).

**Input:** `$ARGUMENTS` — mode keyword followed by research question or path to research spec.

---

## Modes

### `/strategize [question]` or `/strategize strategy [question]` — Identification Strategy
Design the causal identification strategy.

**Agents:** Strategist → strategist-critic
**Output:** Strategy memo + robustness plan + falsification tests

Workflow:
1. Read research spec, literature review, and data assessment if they exist
2. Read domain-profile.md for common identification strategies in the field
3. Dispatch Strategist to produce:
   - Strategy memo: design choice, estimand, assumptions, comparison group
   - Pseudo-code: implementation sketch
   - Robustness plan: ordered list of checks with rationale
   - Falsification tests: what SHOULD NOT show effects
   - Referee objection anticipation: top 5 objections with responses
4. Dispatch strategist-critic to review through 4 phases:
   - Phase 1: Claim identification (design, estimand, treatment, control)
   - Phase 2: Core design validity (assumption checks, sanity checks)
   - Phase 3: Inference soundness (clustering, multiple testing)
   - Phase 4: Polish and completeness (robustness, citations)
5. If CRITICAL issues found, iterate (max 3 rounds per three-strikes)
6. Save memo to `quality_reports/strategy_memo_[topic].md`
7. Save review to `quality_reports/strategy_memo_[topic]_review.md`

### `/strategize pap [spec]` — Pre-Analysis Plan
Draft a pre-analysis plan following AEA/OSF/EGAP standards.

**Agents:** Strategist (in PAP mode)
**Output:** Pre-analysis plan document

The PAP includes:
- Research question and hypotheses
- Primary and secondary outcomes
- Sample definition and power calculations
- Estimation strategy with equations
- Subgroup analyses (pre-specified)
- Multiple testing corrections
- Robustness checks
- Timeline and data collection plan

Save to `quality_reports/pre_analysis_plan_[topic].md`

---

## Principles

- **Strategist proposes, strategist-critic critiques.** Adversarial pairing catches design flaws early.
- **Strategy memo is the contract.** Once approved, the Coder implements it faithfully.
- **Catch problems before coding.** A flawed strategy caught now saves weeks of wasted analysis.
- **Multiple strategies are OK.** Present trade-offs and let the user choose.
- **The user decides.** If Strategist and strategist-critic disagree after 3 rounds, the user resolves it.
