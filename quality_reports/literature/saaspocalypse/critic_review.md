# Librarian-Critic Review — "Another Model, Another SaaSpocalypse"
# Score: 68 / 100 — FAIL (gate: 80)
# Reviewed: 2026-05-19

---

## Score Breakdown

| Section | Available | Earned | Notes |
|---------|-----------|--------|-------|
| Coverage | 25 | 17 | Kolari-Pynnönen and Brown-Warner not annotated; P&V forward chain absent |
| Journal quality | 20 | 15 | Bertomeu BibTeX in SSRN form; Future Business Journal tier not flagged |
| Scope calibration | 20 | 14 | Cluster 6 empty (declared gap, actually search failure) |
| Recency | 20 | 15 | Brynjolfsson et al. (NBER 31161) missing; Acemoglu-Autor missing |
| Categorization | 15 | 7 | Three UNVERIFIED at proximity 2 with no resolution; Corrado-Truong overcategorized |
| **Total** | **100** | **68** | |

---

## Issues

### CRITICAL (fix before advancing)

**C1 — Kolari & Pynnönen (2010) not annotated (−6)**
Named in positioning statement, frontier map, and used as the primary test-statistic correction in Pillar 1 — yet has no annotation in the bibliography. Must be annotated at proximity 2 under Cluster 2.

**C2 — Cluster 6 empty, declared as "no papers found" when papers exist (−6)**
The Farrell-Shapiro (1988) switching-cost literature, Brynjolfsson-Li-Raymond (2023, NBER 31161), Dell'Acqua et al. (2023) "jagged frontier," and platform-economics papers on SaaS moats all inform the cross-sectional heterogeneity hypothesis. This is a search failure, not a genuine gap in the literature.

### MAJOR

**M1 — Three UNVERIFIED citations at proximity 2 with no resolution plan (−5)**
Wu et al. (2025, Finance Research Letters) should be confirmable via Trinity's Elsevier subscription. ResearchGate paper (authors unverified) should be demoted to "do not cite until verified." The OpenAI Taiwan paper needs journal confirmation.

**M2 — Brown & Warner (1985) not annotated despite seminal status (−4)**
`Brown1985_daily` is in `Bibliography_base.bib`; domain profile lists it as seminal. MacKinlay (1997), BMP (1991), Patell (1976), Corrado (1989) all annotated — Brown & Warner (1985) sits in this chain and must be included.

**M3 — Bertomeu et al. BibTeX still in SSRN form, not published JAE (−3)**
The annotated bibliography correctly notes the published JAE form (vol. 80(1), 2025). The `Bibliography_base.bib` entry still uses `journal = {SSRN Working Paper}`. Must be corrected — LaTeX will render it as a working paper.

**M4 — Corrado & Truong (2008) overcategorized at proximity 3 (−3)**
Paper tests rank test in Asia-Pacific markets; dissertation uses US equities. Contribution is redundant given Corrado (1989) at proximity 2. Should be proximity 4 or dropped.

**M5 — Brynjolfsson, Li & Raymond (2023, NBER 31161) missing (−3)**
First quasi-experimental evidence on LLM productivity effects on knowledge workers; 400+ citations in two years; standard reference in GenAI economics. Directly relevant to the AI substitution mechanism motivating SaaS disruption.

### MINOR

**m1 — P&V (2009) forward citation chain not followed (−2)**
Papers testing the three-phase architecture since 2009 are absent. Greenwood & Hanson (2015, JFE) and Pástor, Sinha & Swaminathan (2008, JF) are referee touchstones.

**m2 — Confounding-event methodology literature absent (−2)**
Domain profile flags this as a referee concern; no paper cited on handling simultaneous announcements / contaminated event windows.

**m3 — Future Business Journal tier not flagged (−2)**
Pietrzak (2025) is from a Springer OA journal below JFQA/JBF tier. Annotation should note: cite for precedent only.

---

## Top 3 Required Fixes

1. Annotate Kolari & Pynnönen (2010) at proximity 2 under Cluster 2.
2. Search and populate Cluster 6 with SaaS disruption / switching-cost / GenAI productivity papers.
3. Resolve the three UNVERIFIED citations: confirm Wu et al. via Elsevier access; demote the ResearchGate paper.

---

**Verdict:** FAIL. Librarian must address issues C1, C2, M1, M2, M3 before bibliography advances.
