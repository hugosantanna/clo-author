# Decision Record — Strategy: Matched-Sample DiD as Primary Causal Identification

**Date:** 2026-05-19
**Stage:** Strategy
**Decided by:** Strategist agent + strategist-critic (Round 2, 90/100 approved)

---

## Decision

The matched-sample Difference-in-Differences (DiD) comparing Syntax SaaS Index firms (treated) to non-SaaS GICS 451030 S&P 500 firms (control) is the primary causal identification strategy; the Fama-French Five-Factor (FF5) event study is labeled descriptive only.

## Context

The paper tests whether the Claude Opus 4.6 release (Feb 5, 2026) caused heterogeneous capital market reactions for SaaS vs. non-SaaS software firms, structured around Pástor-Veronesi's (2009) three-phase technology revolution model. The design must credibly identify the ATT τ_ATT(s,t) = E[R_{i,t}(1) − R_{i,t}(0) | T_i = 1] while being defensible against the joint hypothesis problem, factor misspecification critique (Goldsmith-Pinkham & Lyu 2025), and cross-sectional correlation of abnormal returns (Kolari & Pynnönen 2010).

## Alternatives Considered

| Alternative | Why rejected |
|-------------|-------------|
| FF5 event study as primary identification | Goldsmith-Pinkham & Lyu (2025) demonstrate factor model misspecification is material in volatile periods — the Feb–May 2026 period is precisely such a period. The joint hypothesis problem means rejection tests market efficiency AND correct model specification jointly; the causal claim cannot be isolated. Retained as descriptive Pillar 1. |
| Instrumental Variables | No valid instrument available. Candidate instruments (Anthropic's model release cadence, competitor release dates) do not satisfy the exclusion restriction — they affect SaaS and non-SaaS firms through common technology awareness channels, not exclusively via the SaaS-specific AI substitution channel. |
| Regression Discontinuity | Not applicable. The event is a binary date (Feb 5, 2026), not a continuous forcing variable with a threshold. There is no running variable on which firms are placed above or below a cutoff. |
| Synthetic Control (standalone primary) | SCM is included as Robustness #3 but cannot serve as the primary estimand: it produces a cohort-level gap estimate for the equal-weighted SaaS return series, not a firm-level panel ATT. The DiD provides individual firm fixed effects, day fixed effects, and a richer heterogeneity analysis. SCM is used to validate the DiD without factor model assumptions. |
| Selection-on-observables (DiD without parallel trends) | The treatment-control gap in observable characteristics (high-growth, high-margin SaaS vs. legacy software incumbents) is likely to generate differential expected returns even absent the event. Selection-on-observables requires a much stronger assumption (conditional independence given observables) than parallel trends. PSM pre-processing is used to strengthen covariate balance, but the identifying assumption remains parallel trends, not conditional independence. |

## Key Assumptions

1. **Parallel trends:** In the absence of Claude Opus 4.6, SaaS and non-SaaS GICS 451030 S&P 500 firm returns would have followed parallel paths after Feb 5, 2026. The in-sample pre-event SaaS-minus-non-SaaS EW return correlation [CONTINGENT ON DATA — to be confirmed from Bloomberg pull] and the dynamic event-time pre-trend F-test provide the primary evidence; Rambachan-Roth (2023) sensitivity analysis quantifies robustness to violations.

2. **No-anticipation:** SaaS firm returns are unaffected by Claude Opus 4.6 before Feb 5, 2026. The non-public release date and the 10-day estimation gap support this assumption, though inference from Anthropic's prior release cadence cannot be fully ruled out.

3. **SUTVA:** Control firm potential outcomes are unaffected by whether SaaS firms are treated. Partial violation is expected (competitive spillovers), and the bias direction is conservative (attenuates the estimated ATT toward zero).

4. **Oracle RPO Phase 2/3 boundary:** The Oracle RPO +325% YoY disclosure (Apr 10–13, 2026) anchors the Phase 2/3 structural break. The Quandt-Andrews and Bai-Perron tests validate this boundary; the pre-specified decision rule (retain Oracle RPO if break date disagrees by >±3 trading days) prevents post-hoc optimization.

5. **Treatment universe validity:** Syntax SaaS Index (SYSAAS) constituent status as of Jan 31, 2026 correctly identifies firms exposed to the AI substitution mechanism. FIS functional classification is sharper than GICS 451030 alone for this purpose.

## What Would Invalidate This

- **Pre-trends fail (formal F-test p < 0.10):** If the pre-trend joint F-test rejects at the 10% level, the DiD causal claim must be dropped; results relabeled as descriptive.
- **Rambachan-Roth breakdown M close to zero:** If the Phase 1 DiD estimate is only significant under M=0 (no pre-trend violation at all), the identification is not robust to any deviation from parallel trends.
- **In-sample SaaS-control correlation < 0.50 [CONTINGENT ON DATA]:** A low pre-event correlation between the actual treatment and control cohorts would severely undermine parallel trends credibility; Rambachan-Roth becomes the sole credibility argument.
- **SUTVA violation in control-benefiting direction:** If non-SaaS software firms show positive excess returns in Phase 1 and Phase 2 (gaining market share from SaaS displacement), the control group is contaminated; the DiD estimate is not a credible ATT.
- **Syntax constituent list unavailable:** If SYSAAS historical membership cannot be obtained from Syntax Data, the treatment group must be reconstructed from GICS + Bloomberg SaaS classification, which is a coarser proxy. This weakens the design but does not invalidate it.
- **Quandt-Andrews and Bai-Perron break dates both fall > 3 trading days from Oracle RPO, AND a competing confounding event is identified at the statistical break date:** The phase boundary narrative would need to be revised to acknowledge the alternative catalyst.

## Approved By

Strategist-critic Round 2, 2026-05-19 (score: 90/100 ADVANCES)
