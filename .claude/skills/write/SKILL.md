---
name: write
description: Draft academic economics paper sections with notation protocol, anti-hedging, and humanizer pass. Replaces /draft-paper and /humanizer.
argument-hint: "[section or mode: intro | strategy | results | conclusion | abstract | full | humanize] [file path (optional)]"
allowed-tools: Read,Grep,Glob,Write,Edit,Task
---

# Write

Draft paper sections or apply humanizer pass by dispatching the **Writer** agent.

**Input:** `$ARGUMENTS` — section name or mode, optionally followed by file path.

---

## Modes

### `/write [section]` — Draft Paper Section
Draft a specific section: `intro`, `strategy`, `results`, `conclusion`, `abstract`, or `full`.

**Agent:** Writer
**Output:** LaTeX section file in Paper/sections/

Workflow:
1. Read existing paper, research spec, literature review, results summary
2. Read domain-profile.md for field conventions
3. Check Bibliography_base.bib for available citations
4. Dispatch Writer with section standards:
   - Introduction: contribution in first 2 pages, effect sizes with units
   - Strategy: estimating equation displayed and numbered, assumptions explicit
   - Results: every estimate with units and magnitudes
   - Conclusion: restate with effect size, limitations, implications
5. Writer applies notation protocol and anti-hedging rules
6. Humanizer pass runs automatically before finalizing
7. Save to Paper/sections/[section].tex

### `/write humanize [file]` — Humanizer Pass Only
Strip AI writing patterns from existing text without rewriting content.

**Agent:** Writer (humanizer mode)
**Output:** Edited file with AI patterns removed

Strips 24 patterns across 4 categories:
- Structural: forced narrative arcs, artificial progression
- Lexical: "delve,leverage,nuanced,robust"
- Rhetorical: rule-of-three, negative parallelisms, em dash overuse
- Formatting: excessive bullet points, promotional language

---

## Section Standards

| Section | Length | Key Requirements |
|---------|--------|-----------------|
| Introduction | 1000-1500 words | Hook → question → method → finding → contribution → roadmap |
| Strategy | 800-1200 words | Formal assumption, numbered equation, threats addressed |
| Results | 800-1500 words | Main spec, effect sizes in economic terms, heterogeneity |
| Conclusion | 500-700 words | Restate with effect size, policy, limitations, future |
| Abstract | 100-150 words | Question, method, finding with magnitude, implication |

---

## Principles
- **This is the user's paper, not Claude's.** Match their voice and style.
- **Never fabricate results.** Use TBD placeholders.
- **Citations must be verifiable.** Only cite confirmed papers.
- **Humanizer is automatic.** Every draft gets de-AI-ified.
