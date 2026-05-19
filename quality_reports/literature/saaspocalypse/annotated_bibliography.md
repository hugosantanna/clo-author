# Annotated Bibliography — "Another Model, Another SaaSpocalypse"
# MSc Finance Dissertation — Trinity College Dublin
# Student: Rio Giuliana Fitzgerald | Supervisor: Prof. Constantin Gurdgiev
# Last updated: 2026-05-19 (Round 2 revision — addresses librarian-critic issues C1, C2, M1, M2, M3, M4, M5, m1)

---

## Organization

Papers are grouped by the six search clusters and sorted within each cluster by proximity score (1 = directly competes; 5 = tangential background). Papers already in the project bibliography are **not re-annotated** here but are cross-referenced where needed.

---

## CLUSTER 1 — AI/LLM Release Events and Equity Markets

### Proximity 1 — Directly Competes

**Andrews, I. & Farboodi, M. (2025). "Do Markets Believe in Transformative AI?" NBER Working Paper No. 34243. Also SSRN 5487069.**

Already in bibliography. Examined as the primary empirical comparator: this paper runs an event study on US Treasury and TIPS yields around 15 major AI model releases in 2023–24, finding a 21-basis-point average *decline* in long-maturity nominal yields — interpreted through a representative-agent consumption model as investors revising down expected growth or reducing perceived tail-risk probability. Directly relevant as the **corporate bond benchmark** for Pillar 4. The dissertation's bond pillar extends this by focusing on SaaS-issuer credit spreads rather than aggregate Treasury yields. Note: the Andrews-Farboodi bond result suggests a dual equity/bond dynamic that frames the three-phase reversal hypothesis.

---

**Conlon, T., Corbet, S. & Muñiz, J.A. (2025). "Echoes of Innovation: Abnormal Market Returns Surrounding GenAI Releases." SSRN 5284184.**

Already in bibliography. Examines US publicly traded firm CARs around multiple GenAI release events. Finds GenAI announcements generate risk factors outside traditional factor benchmarks; uses a three-factor model and reports abnormal returns that are statistically significant but heterogeneous across sectors. **Proximity score: 1.** The dissertation extends this by (a) isolating SaaS vs. non-SaaS software within the sample, (b) applying FF5 rather than FF3 for expected returns, (c) applying the Goldsmith-Pinkham & Lyu (2025) DiD correction, and (d) adding a bond-market pillar entirely absent from Conlon et al.

---

**Bertomeu, J., Lin, Y., Liu, Y. & Ni, Z. (2023/2025). "Capital Market Consequences of Generative AI: Early Evidence from the Ban of ChatGPT in Italy." Working paper, SSRN 4452670. Published as: "The Impact of Generative AI on Information Processing: Evidence from the Ban of ChatGPT in Italy." Journal of Accounting and Economics, vol. 80(1), 2025.**

Already in bibliography (key `Bertomeu2023_chatgpt` — see Fix 4 note: use `Bertomeu2025_chatgpt_jae` in final LaTeX). Uses Italy's March 31, 2023, ChatGPT ban as a quasi-natural experiment. Firms with higher AI exposure show a 6% market-value decline during the ban relative to less-exposed firms; bid-ask spreads widen; hiring in AI-complementary occupations falls; patent filings slow. The identification strategy — a regulatory event creating exogenous cross-country variation in AI access — is the methodological template for Pillar 3's DiD design. **Proximity score: 1.** The dissertation differs by using an AI *release* (positive shock to AI availability) rather than a ban (negative shock), by focusing on a single-country equity event study rather than bilateral cross-country comparison, and by extending to bond markets.

---

**Eisfeldt, A.L., Schubert, G. & Zhang, M.B. (2023). "Generative AI and Firm Values." NBER Working Paper No. 31222. Also SSRN 4436627 and 4440717. Forthcoming, Journal of Finance.**

Already in bibliography. Constructs the "Artificial-Minus-Human" (AMH) portfolio using Burning Glass job-posting data to measure workforce exposure to GenAI. AMH earns 5% in the two weeks following ChatGPT's release. Firms with greater data assets show stronger effects; the channel is labor-technology substitution rather than direct product exposure. **Proximity score: 1.** The AMH measure is used in the dissertation as a within-SaaS heterogeneity regressor (Pillar 2). However, Eisfeldt et al. do not study phase dynamics, SaaS specifically, or bond markets.

---

### Proximity 2 — Closely Related, Different Angle

**Pietrzak, M. (2025). "A Trillion Dollars Race: How ChatGPT Affects Stock Prices." Future Business Journal, vol. 11(1), article 50. Springer Nature.**

Studies the short-term stock market impact of ChatGPT-related corporate announcements using SEC filing mentions (January–May 2023). Identifies statistically significant abnormal returns; finds the information technology sector consistently benefits, while financials and energy face heightened risk. Market capitalization, beta, and firm age moderate the magnitude of reactions. **Proximity score: 2.** Relevant to Pillar 2 cross-sectional heterogeneity regression but limited to one AI announcement cycle and uses only SEC disclosure mentions rather than a structural AI-exposure measure. **Note: Future Business Journal is a Springer Open Access journal below the JFQA/JBF tier — cite for methodological precedent only, not as a primary empirical reference.**

**Identification:** Event study (market model); cross-sectional regression on CARs.
**Data:** CRSP returns matched to SEC EDGAR 8-K and 10-Q filings.
**Main result:** IT sector firms with ChatGPT disclosures earn positive abnormal returns; magnitude scales with firm size.

---

**Qian, Z., Peng, J. & Li, J. (2025). "The Impact of Generative AI Announcements on Suppliers: Evidence from the Stock Market." Production and Operations Management (SAGE). DOI: 10.1177/10591478251398333. Also SSRN 4957042.**

Examines how GenAI announcements by technology firms spill over to their supply-chain partners. Finds a positive 0.27% average abnormal return for suppliers on the announcement day. Effect is larger for suppliers with higher R&D intensity, greater sales growth, geographic proximity to the customer, and lower competition. **Proximity score: 2.** Complements the dissertation by providing a supply-chain view of GenAI event returns, but does not study SaaS or bond markets, and focuses on positive spillovers rather than disruption.

**Identification:** Event study (market model); cross-sectional OLS on supplier CARs.
**Data:** News data on GenAI announcements; supply-chain relationship data; daily stock prices.
**Main result:** Supplier abnormal return of +0.27% on announcement day; stronger for high-R&D, high-growth, proximate suppliers.

---

**Wu, Y. et al. (2025). "AI Competition and Firm Value: Evidence from DeepSeek's Disruption." Finance Research Letters. ScienceDirect, pii/S154461232500707X. Published April 2025.** % UNVERIFIED — full author list confirmed as paywalled; volume, issue, and pages not retrievable via open access. Existence confirmed via ScienceDirect index. DO NOT CITE until author list verified via institutional access.

Uses an event study approach on 5,439 actively traded US firms as of January 2025 around DeepSeek R1's January 20, 2025, release. Uses Yahoo Finance real-time data (CRSP January 2025 data not yet available at time of writing). Tests the competitive-threat view (DeepSeek reduces AI-sector profitability) vs. innovation-catalyst view (stimulates efficiency). Finds US AI firms react positively to DeepSeek; GPU providers face negative reactions. Firms with fewer resources show stronger short-term reaction. **Proximity score: 2.** Directly relevant as the closest event-study comparator to this dissertation's Pillar 1, but focuses on DeepSeek (competitor model) not an AI-lab release, and does not isolate SaaS vs. non-SaaS.

**Identification:** Event study; cross-sectional regression on CARs.
**Data:** Yahoo Finance real-time returns; AI-exposure measures.

---

**[STUDY ON MAJOR AI MODEL RELEASES — AUTHORS UNVERIFIED]. "An Event Study on the Market Impacts of the Release of Major AI Models." ResearchGate, 2024/2025.** % DO NOT CITE — authors, journal, and year unverified. Demoted to awareness only. Do not include in final bibliography.

Examines CARs for Microsoft and Google around ChatGPT (Nov 30, 2022), GPT-4 (Aug 14, 2023), and Gemini 2.0 (Dec 11, 2024). Estimation window three years before event, event window [−5, +30] days. Finds ChatGPT influence on both firms not significant; GPT-4 generated positive returns for both; Gemini 2.0 positive for Google, minor for Microsoft. Relevant as precedent for studying a single AI release with a long event window, but limited to just two large-cap firms and does not examine software incumbents.

---

**[PAPER ON OPENAI ANNOUNCEMENTS IN TAIWAN]. "OpenAI's Technological Announcements: Market Reactions and Implications." Research in International Business and Finance (Elsevier, ISSN 0275-5319). ScienceDirect pii/S0275531925005082. Published December 2025.** % UNVERIFIED — author names not confirmable via open access. Journal confirmed as Research in International Business and Finance (Elsevier) from ISSN lookup. DO NOT CITE until author list verified via institutional access.

Examines 11 OpenAI announcements (GPT-1 through GPT-4o Mini) and their impact on AI concept stocks in Taiwan's market. Distinguishes innovative events (groundbreaking) from update events (incremental). AI concept stocks consistently outperform matched firms; gap widens over longer event windows. **Proximity score: 3.** Relevant methodological precedent (innovative vs. update event taxonomy) but context is Taiwan equities, not US software. Journal confirmed; author list requires institutional access to verify.

---

**Babina, T., Fedyk, A., He, A.X. & Hodson, J. (2024). "Artificial Intelligence, Firm Growth, and Product Innovation." Journal of Financial Economics, vol. 151, article 103745.**

Already in bibliography. AI-investing firms (measured via résumé and job-posting data) experience higher sales, employment, and market valuation growth, primarily through product innovation rather than cost reduction. AI growth concentrates among larger firms and is associated with higher industry concentration. **Proximity score: 3.** Provides the cross-sectional heterogeneity framework (AI investment intensity as a moderator of equity returns) used in Pillar 2.

---

### Proximity 3 — Same Context, Different Method or Angle

**Eisfeldt, A.L. & Schubert, G. (2025). "Generative AI and Finance." Annual Review of Financial Economics, vol. 17. DOI: 10.1146/annurev-financial-112923-020503. Also SSRN 4988553.**

Survey article covering the literature on GenAI's impact on finance and financial economics. Reviews evidence on ChatGPT's impact on firm value, discusses AI exposure measures, and provides directions for future research. Financial occupations are found to be highly exposed to GenAI productivity effects. **Proximity score: 3.** Essential survey for literature positioning and for identifying papers citing Eisfeldt et al. (2023).

---

**Felten, E.W., Raj, M. & Seamans, R. (2023). "Occupational Heterogeneity in Exposure to Generative AI." SSRN 4414065.**

Constructs occupation-level generative AI exposure measures (GenAI-OE), covering language modeling and image generation. Documents that highly educated, white-collar occupations are most exposed. **Proximity score: 3.** The GenAI-OE measure or its firm-level variant is a candidate for the within-SaaS heterogeneity regressor in Pillar 2, complementing the Eisfeldt et al. (2023) AMH measure.

**Identification:** Crosswalk from O*NET task ratings to AI capability benchmarks.
**Main result:** High-education, high-wage occupations most exposed to GenAI; demographic heterogeneity in exposure documented.

---

**Felten, E.W., Raj, M. & Seamans, R. (2021). "Occupational, Industry, and Geographic Exposure to Artificial Intelligence: A Novel Dataset and Its Potential Uses." Strategic Management Journal, vol. 42(12), pp. 2195–2217.**

Constructs the AI Occupational Exposure (AIOE) measure linking AI progress in 10 application areas to 52 human abilities from O*NET. Aggregates to industry-level (AIIE) and county-level (AIGE) measures. **Proximity score: 4.** The AIOE measure is a predecessor to the Eisfeldt et al. (2023) workforce exposure, relevant for constructing or validating Pillar 2 regressors.

---

**Kogan, L., Papanikolaou, D., Seru, A. & Stoffman, N. (2017). "Technological Innovation, Resource Allocation, and Growth." Quarterly Journal of Economics, vol. 132(2), pp. 665–712.**

Proposes a patent-based measure of technological innovation that combines patent grant dates with the stock market response to patent news (KPSS measure). Documents that innovation drives substantial growth and creative destruction, consistent with Schumpeterian models. Extended data publicly available on GitHub. **Proximity score: 4.** The KPSS patent-value measure is referenced in several AI-exposure papers; the KPSS data infrastructure underpins the Hsu, Wang & Yang (2022) GPT-as-systematic-risk paper already in the bibliography.

---

**Acemoglu, D. (2024). "The Simple Macroeconomics of AI." Economic Policy, vol. 40(121), pp. 13–56. NBER Working Paper No. 32487 (2024).**

Uses a task-based framework and Hulten's theorem to evaluate AI's GDP and TFP implications. Finds macro effects are modest: no more than 0.66% TFP gain over 10 years given current AI penetration. Argues optimistic projections rest on implausible assumptions about the breadth and depth of AI task automation. **Proximity score: 4.** Relevant as background for the dissertation's claim that markets may be overreacting (consistent with Pástor-Veronesi Phase 1 discount-rate dominance) given modest expected productivity gains.

---

**Kogan, L. & Papanikolaou, D. (2014). "Growth Opportunities, Technology Shocks, and Asset Prices." Journal of Finance, vol. 69(2), pp. 675–718.**

Shows that investment-specific technology (IST) shocks have heterogeneous effects on assets-in-place vs. growth opportunities. Firms with high growth-option exposure (proxied by low book-to-market) are more sensitive to IST shocks. **Proximity score: 4.** Provides a real-options theory of why high-growth SaaS firms (low book-to-market, mostly growth options) should react more to AI model releases than mature software incumbents — relevant to the within-SaaS heterogeneity hypothesis.

---

## CLUSTER 2 — Event Study Methodology

### Proximity 2

**Brown, S.J. & Warner, J.B. (1985). "Using Daily Stock Returns: The Case of Event Studies." Journal of Financial Economics, vol. 14(1), pp. 3–31.**

Already in `Bibliography_base.bib` as key `Brown1985_daily`. The foundational paper establishing the use of daily returns in event studies. Shows that market-model residuals using daily data are well-specified for detecting abnormal performance in short windows; addresses the properties of OLS-estimated market models with daily data (thin trading, non-synchronous trading, non-normal return distributions). Demonstrates that simple parametric tests based on standardized daily abnormal returns perform well in practice. Documents that misspecification from thin trading does not substantially bias daily event study results for actively traded US equities. **Proximity score: 2** (seminal methodological foundation). Brown & Warner (1985) sits between FFJR (1969) and MacKinlay (1997) in the methodological lineage: FFJR established the event study framework with monthly data; B&W (1985) validated it with daily data; MacKinlay (1997) codified the full protocol. All three must be cited in the methodology section.

**Identification:** Monte Carlo simulations of daily return distributions; OLS market model.
**Key data source:** CRSP daily returns.
**Main result:** Market model with daily returns is well-specified; standard parametric tests have good size and power for short-window event studies with actively traded US equities.

---

**Kolari, J.W. & Pynnönen, S. (2010). "Event Study Testing with Cross-sectional Correlation of Abnormal Returns." Review of Financial Studies, vol. 23(11), pp. 3996–4025. DOI: 10.1093/rfs/hhq072.**

The key cross-sectional dependence correction paper for event studies with a common event date (event-date clustering). When all firms in a sample react to the same event simultaneously — as is precisely the case in this dissertation, where all SaaS and non-SaaS software firms are exposed to the Claude Opus 4.6 release on February 5, 2026 — standard parametric tests (including BMP) systematically over-reject the null because they assume independence of abnormal returns across firms. The cross-sectional correlation of abnormal returns inflates the variance of the mean abnormal return, making the denominator of the standard t-statistic too small even after standardizing for event-induced variance via BMP. Kolari & Pynnönen show analytically and via simulation that even relatively low cross-correlations (e.g., 0.05–0.10) generate severe over-rejection in samples of 50–500 firms. The KP correction adjusts the BMP t-statistic by multiplying its variance by a factor that accounts for the estimated average cross-sectional correlation of standardized abnormal returns during the estimation window; this factor is a consistent estimator of the cross-sectional dependence inflator. The resulting KP test statistic is then compared against the standard t-distribution. **Proximity score: 2** (directly used in Pillar 1 as the primary parametric test statistic alongside BMP). The dissertation uses the KP-adjusted BMP test as the headline statistic in Pillar 1 specifically because the event is a single common date affecting all firms in the sample simultaneously — making BMP without KP correction invalid as the primary statistic.

**Identification:** Analytical derivation + Monte Carlo simulation comparing test size under cross-sectional dependence.
**Key data source:** CRSP daily returns; simulated portfolios with controlled cross-correlation.
**Main result:** Standard event study tests including BMP over-reject when cross-sectional correlation is nonzero; the KP correction restores correct size; the correction is of the form BMP statistic divided by sqrt(1 + (N-1) * mean pairwise correlation of standardized ARs in estimation window).

---

**Fama, E.F., Fisher, L., Jensen, M.C. & Roll, R. (1969). "The Adjustment of Stock Prices to New Information." International Economic Review, vol. 10(1), pp. 1–21.**

The original event study paper. Introduces the market model with monthly CRSP returns to study stock splits. Documents that prices adjust fully to new information, providing the first direct test of market efficiency in an event-study framework. **Proximity score: 2** (methodological ancestor). Essential citation in any event study's methodology section.

---

**MacKinlay, A.C. (1997). "Event Studies in Economics and Finance." Journal of Economic Literature, vol. 35(1), pp. 13–39.**

Comprehensive survey defining the canonical event study protocol: estimation window, event window, factor model selection, test statistics, cross-sectional aggregation. Sets the field conventions still used today. **Proximity score: 2** (methodological foundation). The methodology section of the dissertation follows MacKinlay's framework explicitly.

---

**Boehmer, E., Musumeci, J. & Poulsen, A.B. (1991). "Event-Study Methodology Under Conditions of Event-Induced Variance." Journal of Financial Economics, vol. 30(2), pp. 253–272.**

Develops the standardized cross-sectional t-statistic (BMP test) robust to event-induced variance increases. Shows that ignoring event-induced variance causes over-rejection of the null under standard parametric tests. **Proximity score: 2** (directly used in Pillar 1). The dissertation uses BMP as its primary parametric test statistic; when used alongside the KP correction for cross-sectional correlation, the combined KP-BMP test is the primary statistic in Pillar 1.

---

**Kothari, S.P. & Warner, J.B. (2007). "Econometrics of Event Studies." In B.E. Eckbo (Ed.), Handbook of Empirical Corporate Finance, vol. 1, pp. 3–36. Elsevier/North-Holland.**

Modern treatment of event study methodology. Notes that short-horizon methods are reliable; long-horizon methods remain problematic. Discusses factor model misspecification and cross-sectional dependence. Documents that event study properties vary by calendar time and firm characteristics such as volatility. **Proximity score: 2** (directly consulted for Pillar 1 robustness discussion). Critical for addressing the joint hypothesis problem and misspecification concerns.

---

**Patell, J.A. (1976). "Corporate Forecasts of Earnings Per Share and Stock Price Behavior: Empirical Tests." Journal of Accounting Research, vol. 14(2), pp. 246–276.**

Introduces the standardized abnormal return (SAR) — dividing each firm's AR by its estimation-window standard deviation — to address cross-sectional heteroskedasticity. The Patell z-test is a precursor to BMP. **Proximity score: 2** (methodological). Used to motivate the BMP test as an improvement; the Patell test is a standard robustness benchmark.

---

**Corrado, C.J. (1989). "A Nonparametric Test for Abnormal Security-Price Performance in Event Studies." Journal of Financial Economics, vol. 23(2), pp. 385–395.**

Develops the rank test for abnormal returns based on the rank of each day's abnormal return within the estimation-window distribution. Simulation evidence shows the rank test is better specified and more powerful than the parametric t-test when return distributions are skewed. Does not require symmetry in cross-sectional distributions. **Proximity score: 2** (directly used in Pillar 1). The dissertation uses the Corrado rank test as its nonparametric robustness check, following Kolari & Pynnönen (2010).

---

**Harrington, S.E. & Shrider, D.G. (2007). "All Events Induce Variance: Analyzing Abnormal Returns When Effects Vary across Firms." Journal of Financial and Quantitative Analysis, vol. 42(1), pp. 229–256.**

Demonstrates analytically that cross-sectional variation in event effects necessarily produces event-induced variance increases, biasing standard parametric tests. Shows unexplained cross-sectional variation produces non-proportional heteroskedasticity in cross-sectional regressions, biasing coefficient standard errors under both OLS and WLS. **Proximity score: 2** (directly addresses a key identification threat in Pillar 1). Motivates the BMP test and cluster-robust standard errors in Pillar 2 cross-sectional regression.

---

**Corrado, C.J. & Truong, C. (2008). "Conducting Event Studies with Asia-Pacific Security Market Data." Pacific-Basin Finance Journal, vol. 16(5), pp. 493–521.**

Investigates parametric and nonparametric event study tests with Asia-Pacific data. Monte Carlo simulations confirm that sign and rank tests provide better specification and power than parametric tests. Demonstrates the advantage of nonparametric approaches when return distributions deviate from normality. **Proximity score: 4.** Proximity downgraded to 4 (from prior Round 1 score of 3): confirms rank test in Asia-Pacific markets; contribution is redundant given Corrado (1989) at proximity 2 for a US equity sample. Retain as awareness citation only; do not feature in the methodology section.

---

### Proximity 3 — Same Method, Different Context

**Roth, J., Sant'Anna, P.H.C., Bilinski, A. & Poe, J. (2023). "What's Trending in Difference-in-Differences? A Synthesis of the Recent Econometrics Literature." Journal of Econometrics, vol. 235(2), pp. 2218–2244. Also arXiv 2201.01194.**

Survey of the DiD methods revolution: staggered timing, parallel trends violations, functional form sensitivity, alternative inference frameworks. Concrete practitioner recommendations. **Proximity score: 3** (methodological foundation for Pillar 3). The dissertation's DiD design follows the recommendations in this survey.

---

**Callaway, B. & Sant'Anna, P.H.C. (2021). "Difference-in-Differences with Multiple Time Periods." Journal of Econometrics, vol. 225(2), pp. 200–230.**

Identifies cohort-period average treatment effects in staggered DiD setups, accommodating heterogeneous effects across timing groups. Allows for covariate-conditional parallel trends. **Proximity score: 3.** The stacked DiD design in Wing et al. (2024) already in the bibliography implements the Callaway-Sant'Anna decomposition; this parent paper should be cited directly.

---

**Goodman-Bacon, A. (2021). "Difference-in-Differences with Variation in Treatment Timing." Journal of Econometrics, vol. 225(2), pp. 254–277. NBER Working Paper 25018.**

Shows that two-way fixed effects (TWFE) equals a weighted average of all pairwise 2×2 DiD comparisons; identifies conditions under which TWFE estimates are biased when treatment effects vary over time. **Proximity score: 3.** Motivates the departure from TWFE in Pillar 3 toward cohort-specific estimators (Callaway-Sant'Anna).

---

**Sun, L. & Abraham, S. (2021). "Estimating Dynamic Treatment Effects in Event Studies with Heterogeneous Treatment Effects." Journal of Econometrics, vol. 225(2), pp. 175–199.**

Demonstrates that TWFE event-study coefficients are biased estimators of dynamic ATTs when treatment effects are heterogeneous across cohorts. Proposes an interaction-weighted estimator. **Proximity score: 3.** Motivates the dynamic event-time plot and the Sun-Abraham estimator as a robustness check for Pillar 3.

---

## CLUSTER 3 — Pástor-Veronesi Technology Revolution Framework

### Proximity 2

**Pástor, L. & Veronesi, P. (2003). "Stock Valuation and Learning about Profitability." Journal of Finance, vol. 58(5), pp. 1749–1789. NBER Working Paper 8991.**

Develops a stock valuation model with learning about average future profitability. Key findings: M/B ratio increases with uncertainty about profitability, especially for non-dividend-paying firms; M/B declines over a firm's lifetime as uncertainty resolves; younger, non-dividend-paying stocks have more volatile returns. **Proximity score: 2.** The theoretical precursor to Pástor & Veronesi (2009) in the bibliography. Provides the learning-about-profitability mechanism that generates Phase 3 reversal as uncertainty resolves.

---

**Pástor, L. & Veronesi, P. (2006). "Was There a Nasdaq Bubble in the Late 1990s?" Journal of Financial Economics, vol. 81(1), pp. 61–100. NBER Working Paper 10581.**

Calibrates the Pástor-Veronesi (2003) valuation model to the Nasdaq bubble. Finds that the observed Nasdaq valuations in the late 1990s were consistent with plausible levels of uncertainty about technology firm profitability — the "bubble" was rationally priced given the uncertainty. **Proximity score: 2.** The empirical validation of the Pástor-Veronesi learning framework that the dissertation's Phase 3 reversal hypothesis depends on. Won the Fama/DFA Prize (second prize) for the best JFE paper in capital markets and asset pricing.

---

### Proximity 3

**Kogan, L. & Papanikolaou, D. (2014). "Growth Opportunities, Technology Shocks, and Asset Prices." Journal of Finance, vol. 69(2), pp. 675–718.**

(Cross-listed from Cluster 1.) Shows that IST shocks have differential effects on growth options vs. assets in place, providing a real-options theory of the discount-rate vs. cash-flow decomposition relevant to the Pástor-Veronesi three-phase architecture. **Proximity score: 3.**

---

**Berk, J.B., Green, R.C. & Naik, V. (1999). "Optimal Investment, Growth Options, and Security Returns." Journal of Finance, vol. 54(5), pp. 1553–1607. NBER Working Paper 6627.**

Shows that as a consequence of optimal investment, systematic risk and expected returns change predictably over a firm's lifecycle. Growth-option firms have higher betas than assets-in-place firms; beta declines as uncertainty resolves. **Proximity score: 3.** The real-options foundation for why SaaS firms (high growth-option share) should exhibit the beta increase during Phase 1 predicted by Pástor & Veronesi (2009).

---

### Proximity 4 — Forward Citation Chain of P&V (2009)

**Greenwood, R. & Hanson, S.G. (2015). "Waves in Ship Prices and Investment." Quarterly Journal of Economics, vol. 130(1), pp. 55–109. NBER Working Paper 19246. DOI: 10.1093/qje/qju035.**

Tests learning dynamics in a capital-intensive industry (dry bulk shipping) where investment cycles are directly observable. Documents that high current ship earnings forecast high ship prices and high investment in new vessels, but low future returns. Proposes a behavioral model in which firms over-extrapolate exogenous demand shocks and partially neglect the endogenous investment response of competitors — generating boom-bust cycles in asset prices and capacity. This is the most direct empirical test of the learning-about-productivity dynamics from the Pástor-Veronesi framework in a non-equity setting: the dissertation's Phase 3 reversal (rational learning about AI's productivity impact on SaaS) maps onto the same mechanism by which shipping investors initially over-price the technology shock (Phase 1: discount-rate dominance) before cash-flow fundamentals reassert (Phase 3: reversal). The paper provides empirical evidence that rational learning generates predictable price reversals even in efficient markets — not just in theory. **Proximity score: 4.** Not directly about equities or AI, but provides the strongest empirical test of the PV learning framework outside of tech stocks and directly supports the reversal hypothesis.

**Identification:** OLS predictive regressions with industry-level panel data; instrument for exogenous demand shocks (Baltic Dry Index components).
**Key data source:** Clarkson ship price database; Baltic Dry Index; newbuilding order data.
**Main result:** High earnings today forecast low future returns; investment boom predicts price bust; consistent with extrapolative learning in the face of mean-reverting fundamentals.

---

## CLUSTER 4 — AI and Equity Markets (Broader)

### Proximity 3

**Hsu, P.-H., Wang, H. & Yang, W. (2022). "General Purpose Technologies as Systematic Risk in Global Stock Markets." Journal of Money, Credit and Banking, vol. 54(5), pp. 1141–1173. SSRN 2803390.**

Already in bibliography. GPTs are nondiversifiable systematic risk factors in international equity markets. Firms more exposed to GPTs earn higher risk premia because GPT-driven uncertainty cannot be diversified away. Directly motivates the Pástor-Veronesi (2009) discount-rate-dominance hypothesis. **Proximity score: 3.**

---

**Acemoglu, D. (2024). "The Simple Macroeconomics of AI." Economic Policy, vol. 40(121), pp. 13–56. NBER Working Paper 32487.**

(Cross-listed from Cluster 1.) Background theory on AI's modest expected TFP effect; relevant for setting up the learning-about-AI-impact narrative in the dissertation's introduction. **Proximity score: 4.**

---

### Proximity 4

**Felten, E.W., Raj, M. & Seamans, R. (2021). "Occupational, Industry, and Geographic Exposure to Artificial Intelligence: A Novel Dataset and Its Potential Uses." Strategic Management Journal, vol. 42(12), pp. 2195–2217.**

(Cross-listed from Cluster 1.) AIOE measure; background on AI exposure measurement. **Proximity score: 4.**

---

## CLUSTER 5 — Corporate Bond Event Study and Credit Markets

### Proximity 2

**Jorion, P. & Zhang, G. (2007). "Good and Bad Credit Contagion: Evidence from Credit Default Swaps." Journal of Financial Economics, vol. 84(3), pp. 860–883. SSRN 1497529.**

Examines intra-industry credit contagion using CDS and stock markets around Chapter 11 (contagion) and Chapter 7 (competition effect) bankruptcies. Positive CDS spread correlations imply contagion; negative correlations imply competitive displacement. Uses the unanticipated jump in a firm's CDS spread as the event. **Proximity score: 2.** Directly relevant to the dissertation's Pillar 4: provides the credit-contagion framework for interpreting bond market reactions to the AI release — does the bond market price SaaS credit deterioration (contagion from AI threat) or resilience (SaaS becomes more competitive)?

**Identification:** Event study on CDS and equity markets; intra-industry spillover regressions.
**Main result:** Chapter 11 filings generate positive CDS spillovers (contagion); Chapter 7 generates negative (competition). CDS jump events produce strongest contagion.

---

**Jorion, P. & Zhang, G. (2009). "Credit Contagion from Counterparty Risk." Journal of Finance, vol. 64(5), pp. 2053–2087. SSRN 1321670.**

First empirical analysis of credit contagion via direct counterparty effects. Bankruptcy announcements cause negative equity abnormal returns and CDS spread increases for creditors. Creditors with large exposures are more likely to suffer financial distress later. **Proximity score: 2.** Complements Jorion & Zhang (2007) by focusing on direct (counterparty) rather than competitive (intra-industry) contagion. Relevant background for Pillar 4's bond market section.

---

**Campbell, J.Y. & Taksler, G.B. (2003). "Equity Volatility and Corporate Bond Yields." Journal of Finance, vol. 58(6), pp. 2321–2350. NBER Working Paper 8961.**

Documents that idiosyncratic equity volatility explains as much cross-sectional variation in corporate bond yields as credit ratings. The upward trend in idiosyncratic equity volatility in the late 1990s explains rising corporate bond yields. **Proximity score: 2.** Directly relevant to Pillar 4: equity volatility increases during the Claude release event window should mechanically compress SaaS bond prices via the Campbell-Taksler channel — provides a testable alternative mechanism to the fundamental credit-risk channel.

**Identification:** Panel regressions of corporate bond yields on idiosyncratic equity volatility.
**Main result:** Idiosyncratic equity vol explains cross-sectional bond yields as well as credit ratings; coefficient on vol is economically large.

---

**Elton, E.J., Gruber, M.J., Agrawal, D. & Mann, C. (2001). "Explaining the Rate Spread on Corporate Bonds." Journal of Finance, vol. 56(1), pp. 247–277.**

Decomposes the corporate-Treasury spread into three components: (1) expected default, (2) state tax premium, (3) compensation for systematic risk in bond returns. Finds expected default accounts for a surprisingly small fraction — most of the spread is taxes and risk premia. **Proximity score: 2.** Directly relevant to Pillar 4's interpretation of abnormal bond returns: the ABR methodology must adjust for the systematic risk component, which EGY (2015) methodology addresses via matched-portfolio netting.

---

**Longstaff, F.A. & Schwartz, E.S. (1995). "A Simple Approach to Valuing Risky Fixed and Floating Rate Debt." Journal of Finance, vol. 50(3), pp. 789–819. SSRN 5843.**

Develops a structural credit model incorporating both default risk and interest rate risk. Key predictions: credit spreads are negatively related to interest rates; duration of risky bonds depends on the correlation with interest rates. **Proximity score: 3.** Theoretical background for Pillar 4: provides the structural model linking equity returns (via firm value dynamics) to credit spread movements, motivating the two-pillar design.

---

**Mueller, L., Riehl, K., Buschulte, S. & Weiss, P. (2024). "Corporate Bond Market Event Studies: Event-Induced Variance and Liquidity." SSRN 4859838.**

Addresses the power of bond event studies in the presence of event-induced variance and illiquidity. Finds test power decreases rapidly with event-induced variance; illiquidity is a material concern for bonds with above-average maturities and credit risks. Provides refinements to the EGY (2015) methodology and open-source tools. **Proximity score: 2.** Directly relevant to Pillar 4's power analysis: the N=12–20 SaaS issuer bond sample flagged in the domain profile as a concern is exactly the setting addressed by Mueller et al.'s refinements.

**Identification:** Monte Carlo simulation of bond event study power under alternative variance and liquidity conditions.
**Main result:** Bond event study power degrades sharply with event-induced variance; standardization (EGY) mitigates but does not eliminate the problem; permutation inference recommended.

---

### Proximity 3

**Merton, R.C. (1974). "On the Pricing of Corporate Debt: The Risk Structure of Interest Rates." Journal of Finance, vol. 29(2), pp. 449–470.**

Already in bibliography. Foundational structural model of credit risk. **Proximity score: 3.** Background theory for Pillar 4.

---

## CLUSTER 6 — SaaS Business Model, Switching Costs, and AI Disruption Economics

*Round 1 declared this cluster empty. Round 2 correction: the following papers inform the cross-sectional heterogeneity hypothesis, the NDR-as-switching-cost mechanism in Pillar 2, and the productivity-substitution channel motivating the SaaS disruption story.*

### Proximity 3

**Brynjolfsson, E., Li, D. & Raymond, L.R. (2025 [NBER WP 2023]). "Generative AI at Work." Quarterly Journal of Economics, vol. 140(2), pp. 889–942. DOI: 10.1093/qje/qjae044. NBER Working Paper No. 31161 (April 2023). Also SSRN 4426942.**

The first quasi-experimental field study of LLM effects on knowledge worker productivity. Studies the staggered rollout of a generative AI-based customer service assistant to 5,179 customer support agents at a single large technology company. Finds the AI tool increases average productivity by 14%, with the largest effects concentrated among novice and low-skill workers (34% improvement) and minimal effects on experienced high-skill workers. Provides suggestive evidence that AI disseminates best practices by allowing new workers to draw on the implicit knowledge of more experienced agents, accelerating human capital accumulation. Workers also show customer sentiment improvements and higher retention under AI assistance. **Proximity score: 3.** This is one of the most-cited GenAI economics papers (400+ citations as of 2025) and directly establishes the productivity-substitution mechanism that motivates SaaS disruption risk in the dissertation: if AI tools can replicate the productivity of experienced SaaS users, software incumbents face substitution pressure on their core value proposition. The SaaS disruption hypothesis in Pillar 2 is grounded in this mechanism — firms with SaaS products operating in AI-addressable task categories (those where Brynjolfsson et al. find large productivity effects) face higher disruption risk, motivating the cross-sectional heterogeneity regression.

**Identification:** Staggered difference-in-differences (access to AI tool rolled out across teams at different times); within-worker comparison controlling for tenure, experience, and task type.
**Key data source:** Internal HR and call-center performance data from a large technology firm; call resolution rates, customer satisfaction scores, handle time.
**Main result:** 14% average productivity gain; 34% gain for novice workers; near-zero for experienced workers; evidence consistent with knowledge diffusion rather than pure automation.

---

**Dell'Acqua, F., McFowland, E., Mollick, E.R., Lifshitz-Assaf, H., Kellogg, K.C., Rajendran, S., Krayer, L., Candelon, F. & Lakhani, K.R. (2026 [HBS WP 2023]). "Navigating the Jagged Technological Frontier: Field Experimental Evidence of the Effects of Artificial Intelligence on Knowledge Worker Productivity and Quality." Organization Science. DOI: 10.1287/orsc.2025.21838. Earlier version: Harvard Business School Working Paper 24-013 (September 2023). Also SSRN 4573321.**

Introduces the "jagged technological frontier" concept: AI substitutes for human effort in tasks inside the frontier (where AI capabilities match or exceed human performance) while complementing human effort in tasks outside the frontier (where human judgment is still superior). In a preregistered field experiment with 758 Boston Consulting Group knowledge workers, AI assistance improves performance by 40% on frontier tasks while worsening performance by 19% on non-frontier tasks — because workers over-rely on AI in areas where it hallucinates or lacks domain knowledge. SaaS products whose core functionality addresses tasks *inside* the jagged frontier face direct substitution risk; SaaS products addressing tasks *outside* the frontier (complex customization, multi-step workflows, domain judgment) are more defensible. **Proximity score: 3.** The jagged frontier framework is the theoretical basis for Pillar 2's within-SaaS heterogeneity hypothesis: SaaS firms whose products address more AI-substitutable tasks should exhibit larger negative differential abnormal returns, while SaaS firms in non-frontier domains should exhibit weaker (or positive) reactions. Directly informs the construction of the SaaS-task-substitutability cross-sectional regressor.

**Identification:** Preregistered randomized controlled experiment; 758 BCG knowledge workers randomly assigned to AI-assisted vs. unassisted condition across a battery of realistic consulting tasks rated for AI addressability.
**Key data source:** BCG internal performance evaluation; task ratings from AI capability benchmarks.
**Main result:** AI improves frontier-task performance by 40%; worsens non-frontier-task performance by 19%; skill-complementarity heterogeneity documented.

---

**Farrell, J. & Shapiro, C. (1988). "Dynamic Competition with Switching Costs." RAND Journal of Economics, vol. 19(1), pp. 123–137.**

The canonical theoretical model of dynamic duopolistic competition in the presence of consumer switching costs. Models an overlapping-generations framework where firms compete for new (uncommitted) and established (locked-in) buyers simultaneously. Key prediction: the firm with attached customers (high switching costs) tends to specialize in serving those customers and concede new buyers to rivals; switching costs generate lock-in that slows the diffusion of superior competing products. **Proximity score: 3.** This paper is the theoretical foundation for Pillar 2's NDR-as-switching-cost mechanism: SaaS firms with high Net Dollar Retention (NDR) have customers with high implicit switching costs (integration depth, data lock-in, workflow embedding). Even when a superior AI substitute emerges (Claude Opus 4.6), Farrell-Shapiro predict that incumbents with locked-in customers will retain revenue for longer than firms facing uncommitted buyers — generating the cross-sectional moderation hypothesis that high-NDR SaaS firms exhibit smaller negative CARs. The model also predicts that entry (AI substitution) is more likely to target new customers than to displace existing ones, consistent with the observation that AI tools first compete for greenfield use cases rather than displacing embedded enterprise contracts.

**Identification:** Theoretical: overlapping-generations dynamic game model of duopoly with switching costs.
**Key data source:** N/A (theoretical).
**Main result:** Switching costs generate lock-in; incumbents with established customers specialize in retention and cede new buyers to rivals; entry is more likely to target uncommitted buyers; welfare ambiguous.

---

**No peer-reviewed paper found after targeted search on the following queries:** (1) "SaaS business model valuation equity markets event study"; (2) "subscription software disruption risk stock returns"; (3) "recurring revenue business model resilience equity markets"; (4) "SaaS churn disruption AI market reaction." No peer-reviewed academic paper studying SaaS-specific equity or bond market dynamics with causal identification was found. This confirms that the dissertation fills a genuine gap, though the absence is a search result rather than an a priori assumption.

---

## Additional Foundational Methods Papers

**Fama, E.F. & French, K.R. (1992, 1997, 2015) — already in bibliography.**

---

**Harrington, S.E. & Shrider, D.G. (2007). "All Events Induce Variance."** (Listed under Cluster 2 above.) **Proximity score: 2.**

---

## Summary Table: New Papers Added in Round 2

| Paper | Cluster | Proximity | Status | Fix Addressed |
|-------|---------|-----------|--------|---------------|
| Brown & Warner (1985), JFE | Methods | 2 | Verified (in base bib as `Brown1985_daily`) | Fix 2 |
| Kolari & Pynnönen (2010), RFS | Methods | 2 | Verified | Fix 1 |
| Brynjolfsson, Li & Raymond (2025), QJE | Cluster 6 | 3 | Verified | Fix 3a, Fix 6 |
| Dell'Acqua et al. (2026), Org Science | Cluster 6 | 3 | Verified | Fix 3b |
| Farrell & Shapiro (1988), RAND JE | Cluster 6 | 3 | Verified | Fix 3c |
| Greenwood & Hanson (2015), QJE | Cluster 3 (P&V forward chain) | 4 | Verified | Fix 6 |
| Bertomeu et al. — JAE correction | Cluster 1 | 1 | Correction noted (see Fix 4, new_references.bib) | Fix 4 |

## Summary Table: All Papers from Round 1 (Retained)

| Paper | Cluster | Proximity | Status |
|-------|---------|-----------|--------|
| MacKinlay (1997), JEL | Methods | 2 | Verified |
| Boehmer, Musumeci & Poulsen (1991), JFE | Methods | 2 | Verified |
| Kothari & Warner (2007), Handbook | Methods | 2 | Verified |
| Patell (1976), JAR | Methods | 2 | Verified |
| Corrado (1989), JFE | Methods | 2 | Verified |
| Fama, Fisher, Jensen & Roll (1969), IER | Methods | 2 | Verified |
| Harrington & Shrider (2007), JFQA | Methods | 2 | Verified |
| Corrado & Truong (2008), Pacific-Basin FJ | Methods | 4 | Verified (proximity downgraded from 3 to 4 per Fix 7) |
| Pástor & Veronesi (2003), JF | PV Framework | 2 | Verified |
| Pástor & Veronesi (2006), JFE | PV Framework | 2 | Verified |
| Berk, Green & Naik (1999), JF | PV Framework | 3 | Verified |
| Jorion & Zhang (2007), JFE | Bond event | 2 | Verified |
| Jorion & Zhang (2009), JF | Bond event | 2 | Verified |
| Campbell & Taksler (2003), JF | Bond/credit | 2 | Verified |
| Elton, Gruber, Agrawal & Mann (2001), JF | Bond/credit | 2 | Verified |
| Longstaff & Schwartz (1995), JF | Bond theory | 3 | Verified |
| Mueller, Riehl, Buschulte & Weiss (2024), SSRN | Bond methods | 2 | Verified |
| Pietrzak (2025), Future Business J | AI events | 2 | Verified (tier note added) |
| Qian, Peng & Li (2025), Production & Ops Mgmt | AI events | 2 | Verified |
| AI model release event study (authors unverified) | AI events | — | DO NOT CITE (demoted per Fix 5b) |
| Wu et al. (2025), Finance Research Letters (DeepSeek) | AI events | 2 | % UNVERIFIED — existence confirmed, author list paywalled (Fix 5a) |
| OpenAI Taiwan announcements paper | AI events | 3 | % UNVERIFIED — journal confirmed (RIBAF), authors paywalled (Fix 5c) |
| Eisfeldt & Schubert (2025), ARFE | AI/finance | 3 | Verified |
| Felten, Raj & Seamans (2023), SSRN | AI exposure | 3 | Verified |
| Felten, Raj & Seamans (2021), SMJ | AI exposure | 4 | Verified |
| Kogan, Papanikolaou, Seru & Stoffman (2017), QJE | Tech innovation | 4 | Verified |
| Kogan & Papanikolaou (2014), JF | Tech shocks | 4 | Verified |
| Acemoglu (2024), Econ Policy/NBER | AI macro | 4 | Verified |
| Callaway & Sant'Anna (2021), JEconometrics | DiD methods | 3 | Verified |
| Goodman-Bacon (2021), JEconometrics | DiD methods | 3 | Verified |
| Sun & Abraham (2021), JEconometrics | DiD methods | 3 | Verified |
| Roth, Sant'Anna, Bilinski & Poe (2023), JEconometrics | DiD methods | 3 | Verified |
