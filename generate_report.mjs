import {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
  Header, Footer, AlignmentType, HeadingLevel, BorderStyle, WidthType,
  ShadingType, VerticalAlign, PageNumber, PageBreak, LevelFormat,
  TableOfContents
} from "docx";
import fs from "fs";

const border = { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" };
const borders = { top: border, bottom: border, left: border, right: border };
const headerBorder = { style: BorderStyle.SINGLE, size: 1, color: "2E75B6" };

function h1(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_1,
    children: [new TextRun({ text, font: "Arial", size: 32, bold: true, color: "1F3864" })],
    spacing: { before: 400, after: 200 },
    border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: "2E75B6", space: 4 } },
  });
}

function h2(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_2,
    children: [new TextRun({ text, font: "Arial", size: 26, bold: true, color: "2E75B6" })],
    spacing: { before: 280, after: 120 },
  });
}

function h3(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_3,
    children: [new TextRun({ text, font: "Arial", size: 24, bold: true, color: "2E4B6B" })],
    spacing: { before: 200, after: 80 },
  });
}

function para(text, opts = {}) {
  return new Paragraph({
    children: [new TextRun({ text, font: "Arial", size: 22, ...opts })],
    spacing: { before: 80, after: 80 },
  });
}

function bold(text) {
  return new TextRun({ text, font: "Arial", size: 22, bold: true });
}

function italic(text) {
  return new TextRun({ text, font: "Arial", size: 22, italics: true });
}

function bullet(text) {
  return new Paragraph({
    numbering: { reference: "bullets", level: 0 },
    children: [new TextRun({ text, font: "Arial", size: 22 })],
    spacing: { before: 40, after: 40 },
  });
}

function pageBreak() {
  return new Paragraph({ children: [new PageBreak()] });
}

function infoRow(label, value) {
  return new TableRow({
    children: [
      new TableCell({
        borders, width: { size: 2500, type: WidthType.DXA },
        shading: { fill: "EBF3FB", type: ShadingType.CLEAR },
        margins: { top: 80, bottom: 80, left: 120, right: 120 },
        children: [new Paragraph({ children: [bold(label)] })],
      }),
      new TableCell({
        borders, width: { size: 6860, type: WidthType.DXA },
        margins: { top: 80, bottom: 80, left: 120, right: 120 },
        children: [new Paragraph({ children: [new TextRun({ text: value, font: "Arial", size: 22 })] })],
      }),
    ],
  });
}

const doc = new Document({
  numbering: {
    config: [
      {
        reference: "bullets",
        levels: [{
          level: 0, format: LevelFormat.BULLET, text: "•", alignment: AlignmentType.LEFT,
          style: { paragraph: { indent: { left: 720, hanging: 360 } } },
        }],
      },
    ],
  },
  styles: {
    default: { document: { run: { font: "Arial", size: 22 } } },
    paragraphStyles: [
      {
        id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 32, bold: true, font: "Arial", color: "1F3864" },
        paragraph: { spacing: { before: 400, after: 200 }, outlineLevel: 0 },
      },
      {
        id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 26, bold: true, font: "Arial", color: "2E75B6" },
        paragraph: { spacing: { before: 280, after: 120 }, outlineLevel: 1 },
      },
      {
        id: "Heading3", name: "Heading 3", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 24, bold: true, font: "Arial", color: "2E4B6B" },
        paragraph: { spacing: { before: 200, after: 80 }, outlineLevel: 2 },
      },
    ],
  },
  sections: [{
    properties: {
      page: {
        size: { width: 12240, height: 15840 },
        margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 },
      },
    },
    headers: {
      default: new Header({
        children: [new Paragraph({
          children: [new TextRun({ text: "Another Model, Another SaaSpocalypse — Research Report", font: "Arial", size: 18, color: "555555" })],
          border: { bottom: { style: BorderStyle.SINGLE, size: 4, color: "2E75B6", space: 4 } },
        })],
      }),
    },
    footers: {
      default: new Footer({
        children: [new Paragraph({
          children: [
            new TextRun({ text: "MSc Finance, Trinity College Dublin | Rio Giuliana Fitzgerald | Supervisor: Prof. Constantin Gurdgiev    ", font: "Arial", size: 16, color: "888888" }),
            new TextRun({ children: [PageNumber.CURRENT], font: "Arial", size: 16, color: "888888" }),
          ],
          alignment: AlignmentType.RIGHT,
        })],
      }),
    },
    children: [
      // ─── TITLE PAGE ────────────────────────────────────────────────────────
      new Paragraph({
        children: [new TextRun({ text: "RESEARCH REPORT", font: "Arial", size: 20, bold: true, color: "2E75B6", allCaps: true })],
        alignment: AlignmentType.CENTER,
        spacing: { before: 1440, after: 120 },
      }),
      new Paragraph({
        children: [new TextRun({ text: "Another Model, Another SaaSpocalypse:", font: "Arial", size: 48, bold: true, color: "1F3864" })],
        alignment: AlignmentType.CENTER,
        spacing: { before: 80, after: 40 },
      }),
      new Paragraph({
        children: [new TextRun({ text: "Heterogeneous Capital Market Reactions to the Anthropic Claude Opus 4.6 Release", font: "Arial", size: 36, bold: false, color: "2E75B6" })],
        alignment: AlignmentType.CENTER,
        spacing: { before: 40, after: 480 },
      }),
      new Table({
        width: { size: 6000, type: WidthType.DXA },
        columnWidths: [2500, 3500],
        rows: [
          infoRow("Student", "Rio Giuliana Fitzgerald"),
          infoRow("Student ID", "25341807"),
          infoRow("Programme", "MSc Finance — BU7530-202526"),
          infoRow("Institution", "Trinity College Dublin"),
          infoRow("Supervisor", "Prof. Constantin Gurdgiev"),
          infoRow("Report Date", "19 May 2026"),
          infoRow("Status", "Strategy Phase Approved (90/100)"),
        ],
      }),
      new Paragraph({ children: [], spacing: { before: 480 } }),
      new Paragraph({
        children: [new TextRun({ text: "This document consolidates all outputs generated by the clo-author research scaffold, including the approved strategy memo, robustness plan, falsification tests, annotated bibliography, and literature positioning statement.", font: "Arial", size: 20, italics: true, color: "555555" })],
        alignment: AlignmentType.CENTER,
        spacing: { before: 0, after: 0 },
      }),
      pageBreak(),

      // ─── TABLE OF CONTENTS ─────────────────────────────────────────────────
      new TableOfContents("Table of Contents", { hyperlink: true, headingStyleRange: "1-3" }),
      pageBreak(),

      // ─── SECTION 1: RESEARCH JOURNAL ────────────────────────────────────────
      h1("1. Research Journal"),
      para("This section records all phases completed to date in chronological order."),

      h2("Project Metadata"),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [2800, 6560],
        rows: [
          infoRow("Project", "Another Model, Another SaaSpocalypse"),
          infoRow("Focal Event", "Claude Opus 4.6 release — 5 February 2026"),
          infoRow("Field", "Finance / Event Study"),
          infoRow("Primary Method", "FF5 Event Study + DiD + Bond Event Study"),
          infoRow("Data Status", "Blocked on Bloomberg Terminal pull"),
        ],
      }),

      h2("Phase Log"),
      h3("2026-05-19 — Project Initialisation"),
      bullet("CLAUDE.md filled with project title, institution, supervisor, student ID, field, and project notes."),
      bullet("Bibliography_base.bib populated with 29 BibTeX methodology references."),
      bullet("Directory structure created: quality_reports/literature/saaspocalypse/, quality_reports/strategy/saaspocalypse/, scripts/R/saaspocalypse/, and supporting subdirectories."),
      bullet("Tracking files initialised: research_journal.md and pipeline_state.json."),

      h3("2026-05-19 — Literature Review (Round 2 — Approved)"),
      bullet("Score: 68/100 (Round 1) — revised and approved after Round 2 fixes."),
      bullet("Bibliography covers 35+ papers across 6 clusters."),
      bullet("Critic identified 2 critical gaps (Kolari-Pynnonen unannotated; Cluster 6 empty) and 3 major issues; all fixed in Round 2."),
      bullet("Three UNVERIFIED citations demoted to DO NOT CITE pending Trinity institutional access."),
      bullet("HTML literature report generated: quality_reports/lit_review_saaspocalypse.html"),

      h3("2026-05-19 — Strategy Phase (Round 2 — Approved 90/100)"),
      bullet("Round 1 score: 76/100 — three MAJOR issues identified."),
      bullet("Round 2 score: 90/100 — all issues resolved; four carry-forward items also applied."),
      bullet("Outputs: strategy_memo.md, pseudo_code.md, robustness_plan.md, falsification_tests.md."),
      bullet("Pipeline now blocked on Bloomberg Terminal data pull."),

      h2("Pipeline Status"),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [3000, 2000, 4360],
        rows: [
          new TableRow({
            children: [
              new TableCell({ borders, width: { size: 3000, type: WidthType.DXA }, shading: { fill: "1F3864", type: ShadingType.CLEAR }, margins: { top: 80, bottom: 80, left: 120, right: 120 }, children: [new Paragraph({ children: [new TextRun({ text: "Phase", font: "Arial", size: 22, bold: true, color: "FFFFFF" })] })] }),
              new TableCell({ borders, width: { size: 2000, type: WidthType.DXA }, shading: { fill: "1F3864", type: ShadingType.CLEAR }, margins: { top: 80, bottom: 80, left: 120, right: 120 }, children: [new Paragraph({ children: [new TextRun({ text: "Status", font: "Arial", size: 22, bold: true, color: "FFFFFF" })] })] }),
              new TableCell({ borders, width: { size: 4360, type: WidthType.DXA }, shading: { fill: "1F3864", type: ShadingType.CLEAR }, margins: { top: 80, bottom: 80, left: 120, right: 120 }, children: [new Paragraph({ children: [new TextRun({ text: "Notes", font: "Arial", size: 22, bold: true, color: "FFFFFF" })] })] }),
            ],
          }),
          ...[
            ["Setup", "Complete", "CLAUDE.md, bib, directories"],
            ["Literature Review", "Complete (90+)", "35+ papers, 6 clusters"],
            ["Strategy", "Approved 90/100", "Four-pillar architecture"],
            ["Data Collection", "BLOCKED", "Bloomberg Terminal pull required"],
            ["Analysis (R)", "Pending", "Awaiting data"],
            ["Writing", "Pending", "Awaiting analysis"],
          ].map(([phase, status, notes], i) =>
            new TableRow({
              children: [
                new TableCell({ borders, width: { size: 3000, type: WidthType.DXA }, shading: { fill: i % 2 === 0 ? "EBF3FB" : "FFFFFF", type: ShadingType.CLEAR }, margins: { top: 80, bottom: 80, left: 120, right: 120 }, children: [new Paragraph({ children: [new TextRun({ text: phase, font: "Arial", size: 22 })] })] }),
                new TableCell({ borders, width: { size: 2000, type: WidthType.DXA }, shading: { fill: i % 2 === 0 ? "EBF3FB" : "FFFFFF", type: ShadingType.CLEAR }, margins: { top: 80, bottom: 80, left: 120, right: 120 }, children: [new Paragraph({ children: [new TextRun({ text: status, font: "Arial", size: 22, bold: status === "BLOCKED" })] })] }),
                new TableCell({ borders, width: { size: 4360, type: WidthType.DXA }, shading: { fill: i % 2 === 0 ? "EBF3FB" : "FFFFFF", type: ShadingType.CLEAR }, margins: { top: 80, bottom: 80, left: 120, right: 120 }, children: [new Paragraph({ children: [new TextRun({ text: notes, font: "Arial", size: 22 })] })] }),
              ],
            })
          ),
        ],
      }),
      pageBreak(),

      // ─── SECTION 2: POSITIONING ─────────────────────────────────────────────
      h1("2. Literature Positioning"),
      h2("Contribution Statement"),
      new Paragraph({
        children: [
          new TextRun({ text: "This dissertation makes four contributions to the literature on AI model releases and financial markets. ", font: "Arial", size: 22 }),
          new TextRun({ text: "First, ", font: "Arial", size: 22, bold: true }),
          new TextRun({ text: "it provides the first equity event study that explicitly contrasts SaaS firms against matched non-SaaS software firms around a single, precisely dated large-language-model release — the Anthropic Claude Opus 4.6 launch of February 5, 2026. ", font: "Arial", size: 22 }),
          new TextRun({ text: "Second, ", font: "Arial", size: 22, bold: true }),
          new TextRun({ text: "it tests the three-phase price dynamics predicted by Pástor and Veronesi (2009) against the actual event-time return history of SaaS firms, providing the first direct application of the technological-revolutions framework to the generative AI shock and its corporate software incumbents. ", font: "Arial", size: 22 }),
          new TextRun({ text: "Third, ", font: "Arial", size: 22, bold: true }),
          new TextRun({ text: "it implements a matched-sample difference-in-differences design using the Goldsmith-Pinkham and Lyu (2025) synthetic control framework. ", font: "Arial", size: 22 }),
          new TextRun({ text: "Fourth, ", font: "Arial", size: 22, bold: true }),
          new TextRun({ text: "it extends the analysis to the corporate bond market using the Bessembinder-Kahle-Maxwell-Xu (2009) matched-portfolio framework with Ederington-Guan-Yang (2015) standardization.", font: "Arial", size: 22 }),
        ],
        spacing: { before: 80, after: 160 },
      }),
      h2("Differentiation from Closest Papers"),
      bullet("vs. Conlon, Corbet & Muñiz (2025): SaaS-specific treatment definition, causal DiD design, and bond pillar."),
      bullet("vs. Eisfeldt, Schubert & Zhang (2023/2025): disruption channel (AI hurts incumbents) vs. adoption channel (AI-exposed firms gain)."),
      bullet("vs. Andrews & Farboodi (2025): individual SaaS issuer credit spreads vs. aggregate Treasury yields; combined equity+bond event study."),
      bullet("vs. Bertomeu et al. (2023/2025): AI release (positive shock) vs. regulatory ban (negative shock); Pástor-Veronesi phase decomposition added."),
      new Paragraph({
        children: [new TextRun({ text: "No existing paper combines all four elements: SaaS-specific treatment contrast, three-phase Pástor-Veronesi architecture, Goldsmith-Pinkham-Lyu causal DiD design, and BKMX/EGY bond event study.", font: "Arial", size: 22, bold: true })],
        spacing: { before: 120, after: 80 },
      }),
      pageBreak(),

      // ─── SECTION 3: STRATEGY MEMO ───────────────────────────────────────────
      h1("3. Approved Strategy Memo"),
      new Paragraph({
        children: [
          bold("Status: "),
          new TextRun({ text: "APPROVED — Strategist-Critic Round 2 score 90/100 (gate: 80). All Round 1 MAJOR issues resolved.", font: "Arial", size: 22, color: "1B6B00" }),
        ],
        spacing: { before: 80, after: 160 },
      }),
      h2("3.1 Paper Type & Primary Estimand"),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [2800, 6560],
        rows: [
          infoRow("Paper type", "Reduced-form empirical (event study + DiD)"),
          infoRow("Primary estimand", "ATT τ_ATT(s,t) — differential daily excess return of SaaS vs. non-SaaS software firms"),
          infoRow("Causal ID", "Pillar 3: Matched-sample DiD (primary)"),
          infoRow("Descriptive", "Pillar 1: FF5 event study (labeled descriptive per Goldsmith-Pinkham & Lyu 2025)"),
        ],
      }),
      new Paragraph({ children: [], spacing: { before: 120 } }),
      para("The primary causal estimand (Pillar 3 DiD) in formal notation:"),
      new Paragraph({
        children: [new TextRun({ text: "τ_ATT(s,t) = E[R_i,t(1) − R_i,t(0) | T_i = 1]", font: "Courier New", size: 22, bold: true })],
        alignment: AlignmentType.CENTER,
        spacing: { before: 120, after: 120 },
      }),
      para("Where R_i,t(1) is the daily excess return SaaS firm i earns after the release; R_i,t(0) is the counterfactual absent the AI disruption shock; T_i = 1 if firm i is a Syntax SaaS Index constituent."),

      h2("3.2 Four-Pillar Architecture"),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [800, 2000, 3560, 3000],
        rows: [
          new TableRow({
            children: ["Pillar", "Name", "Method", "Role"].map((t, i) =>
              new TableCell({ borders, width: { size: [800,2000,3560,3000][i], type: WidthType.DXA }, shading: { fill: "1F3864", type: ShadingType.CLEAR }, margins: { top: 80, bottom: 80, left: 120, right: 120 }, children: [new Paragraph({ children: [new TextRun({ text: t, font: "Arial", size: 20, bold: true, color: "FFFFFF" })] })] })
            ),
          }),
          ...[
            ["1", "FF5 Event Study", "Fama-French 5-factor model, KP-BMP test", "Descriptive (labeled per GP&L 2025)"],
            ["2", "Cross-Sectional Regression", "OLS of CARs on firm characteristics", "Exploratory heterogeneity"],
            ["3", "Matched-Sample DiD", "Two-way FE + PSM + synthetic control", "PRIMARY causal identification"],
            ["4", "Bond Event Study", "ABR/ASR, Wilcoxon, permutation", "Exploratory multi-market evidence"],
          ].map(([p, n, m, r], i) =>
            new TableRow({
              children: [p, n, m, r].map((t, j) =>
                new TableCell({ borders, width: { size: [800,2000,3560,3000][j], type: WidthType.DXA }, shading: { fill: i % 2 === 0 ? "EBF3FB" : "FFFFFF", type: ShadingType.CLEAR }, margins: { top: 80, bottom: 80, left: 120, right: 120 }, children: [new Paragraph({ children: [new TextRun({ text: t, font: "Arial", size: 20 })] })] })
              ),
            })
          ),
        ],
      }),

      h2("3.3 Pástor-Veronesi Three-Phase Architecture"),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [1600, 2500, 2000, 3260],
        rows: [
          new TableRow({
            children: ["Phase", "Name", "Date Range", "Predicted Return"].map((t, i) =>
              new TableCell({ borders, width: { size: [1600,2500,2000,3260][i], type: WidthType.DXA }, shading: { fill: "1F3864", type: ShadingType.CLEAR }, margins: { top: 80, bottom: 80, left: 120, right: 120 }, children: [new Paragraph({ children: [new TextRun({ text: t, font: "Arial", size: 20, bold: true, color: "FFFFFF" })] })] })
            ),
          }),
          ...[
            ["Phase 1", "Initial Reaction", "Feb 5–18, 2026 (+1 to +10)", "Negative (discount-rate dominance) — PRIMARY"],
            ["Phase 2", "Deepening", "Feb 19–Apr 10, 2026 (+11 to +47)", "Continuing negative"],
            ["Phase 3", "Reversal", "Apr 13–May 12, 2026 (+50 to +70)", "Partial recovery (cash-flow learning)"],
            ["Opus 4.7", "Nested in Phase 3", "Apr 16–25, 2026", "Tests Bayesian updating attenuation"],
          ].map(([p, n, d, r], i) =>
            new TableRow({
              children: [p, n, d, r].map((t, j) =>
                new TableCell({ borders, width: { size: [1600,2500,2000,3260][j], type: WidthType.DXA }, shading: { fill: i % 2 === 0 ? "EBF3FB" : "FFFFFF", type: ShadingType.CLEAR }, margins: { top: 80, bottom: 80, left: 120, right: 120 }, children: [new Paragraph({ children: [new TextRun({ text: t, font: "Arial", size: 20 })] })] })
              ),
            })
          ),
        ],
      }),

      h2("3.4 Sample Construction"),
      bullet("Treatment (SaaS): Syntax SaaS Index (SYSAAS) constituents as of Jan 31, 2026. Post-filter N ≈ 65 firms."),
      bullet("Control (non-SaaS): GICS 451030 S&P 500 software firms excluding SYSAAS. Post-filter N ≈ 25–40 firms."),
      bullet("Estimation window: [−261, −11] trading days relative to Feb 5, 2026 (~250 trading days)."),
      bullet("Event window primary (Pillar 1): Phase 1 [+1, +10] trading days — the designated primary Pillar 1 window."),

      h2("3.5 Key Identification Assumptions"),
      h3("Pillar 3 DiD — Parallel Trends (PRIMARY)"),
      para("In the absence of treatment, the expected return evolution of SaaS and non-SaaS software firms would have followed the same path after Feb 5, 2026. Supporting evidence: [CONTINGENT ON DATA] in-sample pre-event EW return correlation between SaaS and non-SaaS cohorts computed over estimation window [−261, −11]. Target: ρ > 0.75."),
      h3("No-Anticipation"),
      para("SaaS firm returns are unaffected by Claude Opus 4.6 before Feb 5, 2026. Credibility: MODERATE-STRONG. Claude Opus 4.6 was not publicly pre-announced on a fixed schedule."),
      h3("SUTVA / No Spillovers"),
      para("Credibility: WEAK-MODERATE. The most credible referee challenge: if non-SaaS control firms gained from SaaS substitution, control returns are elevated and the DiD is biased toward zero (conservative direction). Mitigated by excluding most-at-risk control firms in robustness check A14."),

      h2("3.6 Pre-Specified Threat Responses"),
      h3("Threat 1: Joint Hypothesis / FF5 Misspecification"),
      para("Pre-planned response: FF5 is explicitly labeled descriptive. Primary causal identification is DiD (Pillar 3), which requires only parallel trends — not a pricing model. Day fixed effects absorb all common factor movements. Synthetic control (Robustness #3) makes no factor model assumption at all."),
      h3("Threat 2: Parallel Trends Not Credible"),
      para("Pre-planned response: (1) In-sample SaaS-control return correlation [CONTINGENT ON DATA]; (2) dynamic event-time plot showing β̂_s ≈ 0 for s ∈ [−60, −1]; (3) Rambachan-Roth (2023) honest CIs showing result survives violations of magnitude M."),
      h3("Threat 3: Phase Boundaries Endogenous"),
      para("Pre-planned response: Quandt-Andrews supremum-Wald and Bai-Perron structural break tests validate boundaries independently. Pre-specified decision rule: Oracle RPO anchor is DEFAULT regardless of break test outcome. If data-driven break date disagrees by > ±3 trading days from Apr 10–13, both dates reported transparently with confound search."),
      h3("Threat 4: Control Group Contaminated"),
      para("Pre-planned response: Contamination direction is conservative (biases toward zero). Day FEs absorb common AI-sentiment component. Robustness check A14 excludes most-at-risk control firms."),
      h3("Threat 5: Bond Sample Too Small"),
      para("Pre-planned response: EGY (2015) standardization (~4x power improvement). Permutation inference over asymptotic tests. Synthetic control contingency if N < 8. Bond pillar framed as exploratory multi-market corroboration, not independent confirmation."),

      h2("3.7 Key Design Decisions"),
      h3("Decision 1: DiD is PRIMARY, not FF5"),
      para("Goldsmith-Pinkham & Lyu (2025) demonstrate factor model misspecification is material in volatile periods. The Feb–May 2026 period is precisely such a period. DiD requires only parallel trends and no-anticipation, neither of which depends on a pricing model."),
      h3("Decision 2: Syntax SaaS Index Defines Treatment"),
      para("Syntax uses FIS functional classification requiring primary revenue from subscription-based SaaS delivery — sharper than GICS 451030 alone. Robustness: alternative BVP Nasdaq Emerging Cloud Index treatment universe."),
      h3("Decision 3: Oracle RPO Anchor for Phase 2/3 Boundary"),
      para("Oracle RPO disclosure (+325% YoY, Apr 10–13, 2026) is the pre-specified theory-driven boundary representing the first high-quality public signal that AI adoption was generating enterprise software demand rather than pure substitution — the cash-flow learning signal in Pástor-Veronesi (2009). The Oracle RPO anchor is the DEFAULT regardless of break test outcome."),
      h3("Decision 4: Opus 4.7 as Nested Dummy in Phase 3"),
      para("Estimating β_4 separately allows direct test of Pástor-Veronesi prediction that successive releases by same developer generate attenuated market reactions (rational Bayesian updating). If β̂_4 ≈ 0, consistent with investors having already updated priors on Anthropic's model cadence."),
      pageBreak(),

      // ─── SECTION 4: ROBUSTNESS PLAN ────────────────────────────────────────
      h1("4. Robustness Plan"),
      para("20 robustness checks ordered by priority (1 = most important for publication viability). All checks are pre-specified before data collection."),
      h2("4.1 Priority 1 — Blocking Checks"),
      h3("A1. Parallel Trends Formal Test [BLOCKING]"),
      bullet("Joint F-test: H_0: β_s = 0 for all s ∈ {−60, …, −2} in dynamic DiD."),
      bullet("Decision: If p > 0.10 → causal label; if p ≤ 0.10 → relabel as descriptive DiD; escalate to critic."),
      bullet("Implementation: car::linearHypothesis() or fixest::wald()."),
      h3("A2. Rambachan-Roth (2023) Honest CIs [REQUIRED]"),
      bullet("Use HonestDiD R package. Input pre- and post-event coefficients from dynamic DiD."),
      bullet("Report breakdown value M* — maximum M for which Phase 1/2 result remains significant."),
      bullet("Report honest CIs at M ∈ {0, M*/2, M*}."),
      h2("4.2 Priority 2 — Strengthening Checks"),
      bullet("A3. PSM 1:1 logit (MatchIt; caliper 0.2 SD of logit PS)"),
      bullet("A4. PSM Mahalanobis distance matching"),
      bullet("A5. PSM 1:3 logit with replacement"),
      bullet("A6. Synthetic control method (Synth or tidysynth; permutation p-value)"),
      bullet("A7. Wild cluster bootstrap (fwildclusterboot; B=9,999 Rademacher replications)"),
      h2("4.3 Priority 3 — Sensitivity Checks"),
      bullet("A8. Confounding events — tariff announcements (Bloomberg BETS)"),
      bullet("A9. Confounding events — other AI releases (GPT-5, Gemini 2.5)"),
      bullet("A10. Alternative phase boundaries ±1 and ±3 trading days"),
      bullet("A11. Data-driven phase boundaries (Quandt-Andrews, Bai-Perron; Oracle RPO anchor is DEFAULT)"),
      bullet("A14. SUTVA sensitivity — exclude most-at-risk control firms"),
      bullet("B1–B2. FF3 and Carhart 4-factor robustness for Pillar 1"),
      bullet("B3. Equal-weighted vs. value-weighted CARs"),
      h2("4.4 Priority 4 — Alternative Specifications"),
      bullet("A12. Alternative treatment universe (BVP Nasdaq Emerging Cloud Index)"),
      bullet("A13. Dropping outlier firms (|CAR| > 3σ_pre)"),
      bullet("D2. Tobin Q replacing BTM in Pillar 2"),
      h2("4.5 Contingent Checks"),
      bullet("B4. SPXXAI model-free benchmark [requires Goldman Sachs institutional access]"),
      bullet("C1. TRACE transaction prices vs. BGN quotes [requires WRDS access]"),
      bullet("C2. Bond synthetic control [activated only if N < 8 bonds]"),
      bullet("D3. Eisfeldt-Schubert-Zhang AMH score [requires authors' public replication package]"),
      pageBreak(),

      // ─── SECTION 5: FALSIFICATION TESTS ────────────────────────────────────
      h1("5. Falsification Tests"),
      para("Six falsification tests across three classes: placebo time, placebo group, and counterfactual mechanism. All tests must be implemented in the same R pipeline as main results and reported in a dedicated appendix section."),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [600, 2200, 2400, 2360, 1800],
        rows: [
          new TableRow({
            children: ["Test", "Type", "Expected Result", "Failure Risk", "Priority"].map((t, i) =>
              new TableCell({ borders, width: { size: [600,2200,2400,2360,1800][i], type: WidthType.DXA }, shading: { fill: "1F3864", type: ShadingType.CLEAR }, margins: { top: 80, bottom: 80, left: 120, right: 120 }, children: [new Paragraph({ children: [new TextRun({ text: t, font: "Arial", size: 18, bold: true, color: "FFFFFF" })] })] })
            ),
          }),
          ...[
            ["F1", "Pre-event placebo DiD", "Null (no SaaS differential at Apr 1, 2025)", "Reveals pre-trends — DiD invalid", "1"],
            ["F2", "Health IT sector placebo", "Null (no Phase 1/2/3 pattern in healthcare)", "Non-SaaS-specific market dynamics", "1"],
            ["F3", "Non-frontier within-SaaS", "Null for outside-frontier SaaS firms", "Frontier classification subjective", "2"],
            ["F4", "5,000 pseudo-event DiD", "True event in tail of permutation distribution", "Moderate — if SaaS trends diverged pre-event", "1"],
            ["F5", "Phase 3 shifted windows", "Reversal decays after true Oracle RPO window", "Low — if rebound is broad", "2"],
            ["F6", "Bond SaaS vs. non-SaaS", "SaaS bonds show larger spread widening", "Low — if macro credit tightening dominates", "2"],
          ].map(([f, t, e, r, p], i) =>
            new TableRow({
              children: [f, t, e, r, p].map((text, j) =>
                new TableCell({ borders, width: { size: [600,2200,2400,2360,1800][j], type: WidthType.DXA }, shading: { fill: i % 2 === 0 ? "EBF3FB" : "FFFFFF", type: ShadingType.CLEAR }, margins: { top: 80, bottom: 80, left: 120, right: 120 }, children: [new Paragraph({ children: [new TextRun({ text, font: "Arial", size: 18 })] })] })
              ),
            })
          ),
        ],
      }),
      new Paragraph({ children: [], spacing: { before: 160 } }),
      h2("F1: Pre-Event Placebo DiD"),
      bullet("Panel: May 18, 2024 – January 31, 2026 (entirely pre-event)."),
      bullet("Placebo event date: April 1, 2025 (no known AI event)."),
      bullet("Expected: β̂_1^pl and β̂_2^pl indistinguishable from zero."),
      bullet("Failure: reveals pre-trends → parallel trends violation → escalate immediately."),
      h2("F2: Unrelated Sector Placebo"),
      bullet("Placebo treated: Health IT (GICS 351020); placebo control: S&P 500 Healthcare ex-Health IT."),
      bullet("Same event date and phase windows as main analysis."),
      bullet("Expected: no Phase 1/2/3 differential pattern in healthcare."),
      h2("F3: Within-SaaS Non-Frontier Placebo"),
      bullet("Classify SaaS firms: inside-frontier (AI-addressable tasks) vs. outside-frontier (complex domain tasks)."),
      bullet("Expected: outside-frontier SaaS shows near-zero Phase 1 CARs; inside-frontier shows significantly negative CARs."),
      bullet("Caveat: classification must be made before inspecting phase CARs (pre-registered)."),
      h2("F4: 5,000 Pseudo-Event DiD"),
      bullet("Draw 5,000 pseudo-event dates from estimation window (Andrews-Farboodi 2025 adaptation applied to DiD)."),
      bullet("Empirical p-value: fraction of pseudo-event DiD estimates more extreme than true-event estimate."),
      bullet("Output: permutation distribution histogram; true-event value marked."),
      h2("F5: Phase 3 Reversal Specificity"),
      bullet("Define 5 alternative Phase 3 windows shifted by +5, +10, +15, +20, +25 trading days."),
      bullet("Expected: reversal (β̂_3) strongest in true Oracle RPO-anchored window; attenuates in later windows."),
      h2("F6: Bond SaaS vs. Non-SaaS Specificity"),
      bullet("Compare Phase 1/2 bond ABRs: SaaS issuer bonds vs. non-SaaS software issuer bonds."),
      bullet("If both groups show equal spread widening, result is generic macro credit risk — not SaaS-specific AI disruption."),
      bullet("Two-sample Wilcoxon test of ABRs by group for each phase."),
      pageBreak(),

      // ─── SECTION 6: DATA REQUIREMENTS ──────────────────────────────────────
      h1("6. Data Requirements"),
      para("The pipeline is currently blocked pending the following Bloomberg Terminal data pull. All data must be collected as of January 31, 2026 (point-in-time, survivorship-bias-free)."),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [3000, 2200, 2360, 1800],
        rows: [
          new TableRow({
            children: ["Data Item", "Source", "Pillar", "Status"].map((t, i) =>
              new TableCell({ borders, width: { size: [3000,2200,2360,1800][i], type: WidthType.DXA }, shading: { fill: "1F3864", type: ShadingType.CLEAR }, margins: { top: 80, bottom: 80, left: 120, right: 120 }, children: [new Paragraph({ children: [new TextRun({ text: t, font: "Arial", size: 20, bold: true, color: "FFFFFF" })] })] })
            ),
          }),
          ...[
            ["Daily equity returns (~65 SaaS firms)", "Bloomberg Terminal", "Pillars 1, 2, 3", "NEEDED"],
            ["Daily equity returns (~25-40 non-SaaS)", "Bloomberg Terminal", "Pillars 1, 3", "NEEDED"],
            ["Syntax SaaS Index constituent list (SYSAAS)", "Syntax Data", "Pillar 3 treatment", "NEEDED"],
            ["Fama-French 5-factor daily returns", "Ken French Data Library", "Pillar 1", "PUBLIC"],
            ["Firm fundamentals (Size, BTM, Lev, ROA)", "Compustat via Bloomberg", "Pillar 2", "NEEDED"],
            ["ARR Growth, Gross Margin, NDR", "Bloomberg/company filings", "Pillar 2", "NEEDED"],
            ["Bond BGN prices (CUSIP level)", "Bloomberg Terminal", "Pillar 4", "NEEDED"],
            ["Bond MDURATION, ratings", "Bloomberg Terminal", "Pillar 4", "NEEDED"],
            ["ICE BofA credit index returns", "Bloomberg Terminal", "Pillar 4", "NEEDED"],
            ["SPXXAI daily returns", "Goldman Sachs [institutional]", "Robustness B4", "CONTINGENT"],
          ].map(([d, s, p, st], i) =>
            new TableRow({
              children: [d, s, p, st].map((text, j) =>
                new TableCell({ borders, width: { size: [3000,2200,2360,1800][j], type: WidthType.DXA }, shading: { fill: st === "NEEDED" && j === 3 ? "FFF0F0" : i % 2 === 0 ? "EBF3FB" : "FFFFFF", type: ShadingType.CLEAR }, margins: { top: 80, bottom: 80, left: 120, right: 120 }, children: [new Paragraph({ children: [new TextRun({ text, font: "Arial", size: 20, bold: j === 3 && text === "NEEDED" })] })] })
              ),
            })
          ),
        ],
      }),
      pageBreak(),

      // ─── SECTION 7: ANNOTATED BIBLIOGRAPHY (KEY PAPERS) ────────────────────
      h1("7. Annotated Bibliography — Key Papers"),
      para("35+ papers across 6 clusters. Proximity score: 1 = directly competes; 5 = tangential background. Full annotated bibliography in quality_reports/literature/saaspocalypse/annotated_bibliography.md."),

      h2("Cluster 1 — AI/LLM Release Events and Equity Markets"),
      h3("Andrews & Farboodi (2025) — Proximity 1"),
      para("\"Do Markets Believe in Transformative AI?\" NBER WP 34243. Event study on Treasury/TIPS yields around 15 major AI releases; 21bp average decline in long-maturity nominal yields. Primary empirical comparator for Pillar 4. Dissertation extends to SaaS-issuer credit spreads."),
      h3("Conlon, Corbet & Muñiz (2025) — Proximity 1"),
      para("\"Echoes of Innovation.\" SSRN 5284184. US firm CARs around multiple GenAI releases; heterogeneous across sectors. Dissertation extends by isolating SaaS vs. non-SaaS, applying FF5, using DiD correction, and adding bond pillar."),
      h3("Bertomeu et al. (2023/2025) — Proximity 1"),
      para("\"Impact of Generative AI on Information Processing.\" JAE 80(1), 2025. Italy ChatGPT ban as QNE; 6% market-value decline for AI-exposed firms. Identification template for Pillar 3 DiD design."),
      h3("Eisfeldt, Schubert & Zhang (2023) — Proximity 1"),
      para("\"Generative AI and Firm Values.\" NBER WP 31221. Forthcoming, JF. AMH portfolio; 5% return post-ChatGPT. AMH measure used in Pillar 2. Does not study phase dynamics or bond markets."),

      h2("Cluster 2 — Event Study Methodology"),
      h3("Kolari & Pynnönen (2010) — Proximity 2"),
      para("\"Event Study Testing with Cross-sectional Correlation.\" RFS 23(11). KP correction for event-date clustering: multiplies BMP variance by 1 + (N−1)ρ̄. Primary Pillar 1 test statistic because all firms share event date Feb 5, 2026."),
      h3("MacKinlay (1997) — Proximity 2"),
      para("\"Event Studies in Economics and Finance.\" JEL 35(1). Canonical event study protocol. Methodology section follows MacKinlay's framework."),
      h3("Boehmer, Musumeci & Poulsen (1991) — Proximity 2"),
      para("\"Event-Study Methodology Under Conditions of Event-Induced Variance.\" JFE 30(2). BMP standardized cross-sectional test. Primary parametric test alongside KP correction."),
      h3("Rambachan & Roth (2023) — Proximity 3"),
      para("\"A More Credible Approach to Parallel Trends.\" ReStud 90(5). HonestDiD package. Used in Robustness A2 to compute sensitivity of DiD estimates to parallel trends violations of magnitude M."),

      h2("Cluster 3 — Pástor-Veronesi Framework"),
      h3("Pástor & Veronesi (2009) — Proximity 2"),
      para("\"Technological Revolutions and Stock Prices.\" AER 99(4). Three-phase model: (1) discount-rate dominance → price fall; (2) deepening; (3) cash-flow learning → partial reversal. Core theoretical framework for the dissertation's event architecture."),
      h3("Pástor & Veronesi (2003, 2006) — Proximity 2"),
      para("Stock valuation with learning about profitability; Nasdaq bubble calibration. Theoretical precursors providing the learning mechanism that generates Phase 3 reversal."),

      h2("Cluster 5 — Corporate Bond Event Study"),
      h3("Ederington, Guan & Yang (2015) — Proximity 2"),
      para("EGY standardization for bond event studies providing ~4x power improvement. Used in Pillar 4 as primary bond test statistic (ASR composite)."),
      h3("Mueller et al. (2024) — Proximity 2"),
      para("\"Corporate Bond Market Event Studies.\" SSRN 4859838. Power degrades rapidly below N=15 with event-induced variance. Directly addresses Pillar 4 small-N concern; recommends permutation inference."),
      h3("Campbell & Taksler (2003) — Proximity 2"),
      para("\"Equity Volatility and Corporate Bond Yields.\" JF 58(6). Idiosyncratic equity vol explains cross-sectional bond yields as well as credit ratings. Mechanism test F6/C4 in bond pillar."),

      h2("Cluster 6 — SaaS Economics & AI Disruption"),
      h3("Dell'Acqua et al. (2026) — Proximity 3"),
      para("\"Navigating the Jagged Technological Frontier.\" Org Science. AI improves frontier-task performance +40%; worsens non-frontier tasks −19% in BCG RCT (N=758). Theoretical basis for Pillar 2 within-SaaS heterogeneity and Falsification Test F3."),
      h3("Brynjolfsson, Li & Raymond (2025) — Proximity 3"),
      para("\"Generative AI at Work.\" QJE 140(2). 14% average productivity gain; 34% for novice workers; near-zero for experienced. Establishes the productivity-substitution mechanism motivating SaaS disruption risk."),
      h3("Farrell & Shapiro (1988) — Proximity 3"),
      para("\"Dynamic Competition with Switching Costs.\" RAND JE 19(1). Theoretical foundation for NDR-as-switching-cost mechanism in Pillar 2: high-NDR SaaS firms retain locked-in customers even when superior AI substitutes emerge."),
      pageBreak(),

      // ─── SECTION 8: NEXT STEPS ─────────────────────────────────────────────
      h1("8. Next Steps"),
      para("The pipeline is currently blocked on data collection. The following actions are required to advance to the execution phase:"),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [600, 5000, 3760],
        rows: [
          new TableRow({
            children: ["#", "Action", "Notes"].map((t, i) =>
              new TableCell({ borders, width: { size: [600,5000,3760][i], type: WidthType.DXA }, shading: { fill: "1F3864", type: ShadingType.CLEAR }, margins: { top: 80, bottom: 80, left: 120, right: 120 }, children: [new Paragraph({ children: [new TextRun({ text: t, font: "Arial", size: 20, bold: true, color: "FFFFFF" })] })] })
            ),
          }),
          ...[
            ["1", "Pull Bloomberg data: equity returns, constituents, fundamentals, bond BGN prices", "All as of Jan 31, 2026 point-in-time"],
            ["2", "Download Fama-French 5-factor daily data from Ken French Data Library", "Public; no access barrier"],
            ["3", "Collect Syntax SYSAAS constituent list as of Jan 31, 2026", "Binding assumption for Pillar 3 treatment definition"],
            ["4", "Collect NDR, ARR Growth, Gross Margin from filings for ~65 SaaS firms", "Report missing data rate per pre-specified decision rule"],
            ["5", "Run /analyze in Claude Code once data is in data/ directory", "R pipeline in scripts/R/saaspocalypse/"],
            ["6", "Run /write once analysis outputs are in quality_reports/", "Draft paper sections"],
            ["7", "Run /review --peer [journal] for pre-submission stress test", "30 journal profiles available"],
          ].map(([n, a, note], i) =>
            new TableRow({
              children: [n, a, note].map((text, j) =>
                new TableCell({ borders, width: { size: [600,5000,3760][j], type: WidthType.DXA }, shading: { fill: i % 2 === 0 ? "EBF3FB" : "FFFFFF", type: ShadingType.CLEAR }, margins: { top: 80, bottom: 80, left: 120, right: 120 }, children: [new Paragraph({ children: [new TextRun({ text, font: "Arial", size: 20 })] })] })
              ),
            })
          ),
        ],
      }),
      new Paragraph({ children: [], spacing: { before: 240 } }),
      new Paragraph({
        children: [new TextRun({ text: "Quality Gate Thresholds: Score ≥ 80 required to commit | Score ≥ 90 required for PR | Score ≥ 95 required for submission (all components ≥ 80)", font: "Arial", size: 20, italics: true, color: "555555" })],
        alignment: AlignmentType.CENTER,
        border: { top: { style: BorderStyle.SINGLE, size: 4, color: "2E75B6", space: 4 } },
        spacing: { before: 240, after: 0 },
      }),
    ],
  }],
});

Packer.toBuffer(doc).then(buffer => {
  fs.writeFileSync("C:/Users/Rio/clo-author/saaspocalypse_research_report.docx", buffer);
  console.log("Done: saaspocalypse_research_report.docx");
});
