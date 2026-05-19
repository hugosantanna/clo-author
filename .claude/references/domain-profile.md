# Domain Profile — Empirical Asset Pricing / Financial Event Studies

## Field

**Primary:** Empirical Asset Pricing — Financial Event Studies
**Adjacent subfields:** Corporate Finance, Technology Economics, AI Economics, Credit Markets

---

## Target Journals (ranked by tier)

| Tier | Journals |
|------|----------|
| Top-3 Finance | Journal of Finance (JF), Review of Financial Studies (RFS), Journal of Financial Economics (JFE) |
| Strong field | Journal of Financial and Quantitative Analysis (JFQA), Journal of Banking and Finance (JBF), Journal of Money, Credit and Banking (JMCB) |
| Adjacent top-5 | AER, QJE (for AI-economics angle) |
| Working paper outlets | NBER, SSRN, CEPR |

---

## Common Data Sources

| Dataset | Type | Access | Notes |
|---------|------|--------|-------|
| Bloomberg Terminal | Equity returns, bond BGN prices, corporate fundamentals | Institutional subscription | Primary source for this project |
| CRSP | Daily/monthly equity returns | WRDS subscription | More standard than Bloomberg for US equities; can cross-validate |
| Compustat | Firm fundamentals (quarterly, annual) | WRDS subscription | Balance sheet, income statement controls |
| Ken French Data Library | FF3/FF5/momentum factors (daily) | Public download | Standard factor data; URL: mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html |
| TRACE (WRDS) | Corporate bond transaction prices | WRDS subscription | Cleaner than BGN but requires access; see Dickerson-Robotti-Rossetti (2026) |
| ICE BofA Corporate Bond Indices | Bond index returns by rating/maturity | Bloomberg | C0A3 (A-rated), C0A4 (BBB-rated), H0A0 (HY Master) |
| SPXXAI (S&P 500 ex-AI) | Non-AI benchmark returns | Goldman Sachs institutional | Not publicly disclosed; constituent list unavailable |
| Syntax SaaS Index (SYSAAS) | SaaS universe | Syntax Data | FIS-classified ~100 constituents; ~65 post-screening |

---

## Common Identification Strategies

| Strategy | Typical Application | Key Assumption to Defend |
|----------|-------------------|------------------------|
| FF5 event study | Abnormal returns around event date; estimation window [-261,-11] | Factor model correctly specifies expected returns; no misspecification (Goldsmith-Pinkham & Lyu 2025 concern) |
| Matched-sample DiD | Causal identification treating SaaS as treated vs. non-SaaS software as control | Parallel trends in returns pre-event; parallel threats tested via dynamic event-time coefficients (Roth 2022) |
| Synthetic control | Replicating portfolio from control securities; avoids factor model | Convex combination of controls can replicate treated pre-event; no interference |
| Propensity score matching | Alternative to DiD with controls; 1:1 logit, Mahalanobis, 1:3 logit | Unconfoundedness given observed pre-event firm characteristics |
| Bond event study | BKMX (2009) matched-portfolio framework; standardised abnormal returns (EGY 2015) | Bond price benchmark correctly captures expected returns; no thin trading |

---

## Field Conventions

- Always report both parametric (t-test, Brown-Warner) and non-parametric (Wilcoxon signed-rank) test statistics
- Economic significance alongside statistical: report basis-point or percentage-point magnitudes
- Cluster standard errors at firm level for cross-sectional regressions
- In event studies: report both equal-weighted and value-weighted CARs
- Multiple event windows: short ([−1,+1], [−3,+3]) and phase-specific windows
- Factor models: FF5 as primary; FF3 and Carhart 4-factor as robustness
- Bond studies: duration-adjust returns to isolate credit-spread component from interest-rate component
- Always address the joint hypothesis problem (market efficiency + correct pricing model)
- For DiD: include dynamic event-time plot as primary visual; static phase coefficients as summary

---

## Notation Conventions

| Symbol | Meaning | Anti-pattern |
|--------|---------|-------------|
| $AR_{i,t}$ | Abnormal return for firm $i$ at time $t$ | Don't use $\alpha$ for abnormal return (conflicts with Jensen's alpha) |
| $CAR_{i}[t_1, t_2]$ | Cumulative abnormal return for firm $i$ over window $[t_1,t_2]$ | Don't abbreviate as CR or cumret |
| $\tau_{ATT}(s,t)$ | Cohort-period ATT in potential outcomes DiD framework | Consistent with Goldsmith-Pinkham & Lyu (2025) notation |
| $R_{f,t}$ | Risk-free rate at time $t$ (1-month T-bill) | Don't use $r_f$ without time subscript |
| $ABR_{i,t}$ | Abnormal bond return; $ASR_{i,t}$ for standardised version | Consistent with Bessembinder et al. (2009), Ederington et al. (2015) |
| $D_t^{SaaS}$ | SaaS treatment indicator; $D_t^{Phase_k}$ for phase indicators | Keep treatment and phase dummies separate |

---

## Seminal References

| Paper | Why It Matters |
|-------|---------------|
| Fama et al. (1969) | Original event study methodology — CRSP monthly data, market model |
| Brown & Warner (1985) | Extends to daily data; establishes cross-sectional t-test; standard reference |
| MacKinlay (1997) | Comprehensive event study survey; sets field conventions |
| Kothari & Warner (2007) | Modern treatment of long-run event study pitfalls |
| Pástor & Veronesi (2009) | Theoretical anchor: technology revolutions → discount-rate effect dominates then reverses |
| Fama & French (2015) | FF5 model — primary expected return specification |
| Bessembinder et al. (2009) | Bond event study methodology; dealer-quote applicability confirmed |
| Goldsmith-Pinkham & Lyu (2025) | Causal inference critique of standard event study estimators; motivates DiD as primary |

---

## Theoretical Foundational References

| Topic | Anchor references |
|-------|------------------|
| Technology revolutions and equity prices | Pástor & Veronesi (2009, 2006, 2003) |
| General purpose technology risk | Hsu, Wang & Yang (2022) |
| Factor model asset pricing | Fama & French (1992, 1997, 2015); Carhart (1997) |
| Causal inference in event studies | Goldsmith-Pinkham & Lyu (2025); Bertomeu et al. (2023) |
| Corporate bond pricing | Merton (1974); Bessembinder et al. (2009); Van Binsbergen et al. (2025) |
| DiD inference | Roth (2022); Wing, Freedman & Hollingsworth (2024) |

---

## Paper Author Team

| Author | Foundational on |
|--------|----------------|
| Fitzgerald | None declared (dissertation student) |

---

## Field-Specific Referee Concerns

- **Joint hypothesis problem:** Any rejection of the null jointly tests market efficiency AND the pricing model — must acknowledge
- **Factor model misspecification:** Goldsmith-Pinkham & Lyu (2025) — during volatile periods, FF5 misspecification biases abnormal return estimates; must address via DiD and model-free benchmarks
- **Confounding events:** Other AI releases (OpenAI, Google, Meta, DeepSeek, xAI) and macro shocks (tariff announcements, Fed decisions) during the event window — must control or address
- **Single-event identification:** Cannot generalize to other AI releases from FF5 pillar alone; DiD partially resolves via parallel comparison
- **Data mining / multiple testing:** Three phases × multiple windows × multiple factor specs → Bonferroni or pre-registration narrative required
- **Bond sample power:** N=12–20 SaaS issuer bonds is small; EGY (2015) standardisation + permutation inference required; synthetic control contingency at N<8
- **Phase boundary endogeneity:** Phase 2/3 boundary anchored to Oracle RPO disclosure (post-event observable) — referees will question; must demonstrate via structural break tests
- **SPXXAI access:** Goldman Sachs institutional access required; not publicly available — robustness specs contingent on this

---

## Quality Tolerance Thresholds

| Quantity | Tolerance | Rationale |
|----------|-----------|-----------|
| CAR point estimates | 1e-4 (1 basis point) | Daily return data precision |
| Standard errors | 1e-4 | Cluster-robust estimation |
| Beta estimates (FF5) | 1e-4 | Regression precision |
| Bond ABR | 1e-4 | BGN composite quote precision |
