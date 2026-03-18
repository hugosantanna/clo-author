---
name: discover
description: Discovery phase combining research interviews, literature search, data discovery, and ideation. Routes to appropriate agents based on arguments. Replaces /interview-me, /lit-review, /find-data, /research-ideation.
argument-hint: "[mode: interview | lit | data | ideate] [topic or query]"
allowed-tools: Read,Grep,Glob,Write,Edit,WebSearch,WebFetch,Task
---

# Discover

Launch the Discovery phase of research. Routes to the appropriate agents based on the mode specified.

**Input:** `$ARGUMENTS` — a mode keyword followed by a topic or query.

---

## Modes

### Default (no mode specified)
If no mode keyword is given, start with an interactive interview to build the research specification.

### `/discover interview [topic]` — Research Interview
Conduct a structured conversational interview to formalize a research idea.

**Agents:** Direct conversation (no agent dispatch)
**Output:** Research specification + domain profile

Interview structure:
1. Big Picture (1-2 questions): phenomenon, why it matters
2. Theoretical Motivation (1-2 questions): intuition, predictions
3. Data and Setting (1-2 questions): data access, institutional context
4. Identification (1-2 questions): natural experiments, threats
5. Expected Results (1-2 questions): predictions, implications
6. Contribution (1 question): gap being filled

After interview (5-8 exchanges), produce:
- Research specification → `quality_reports/research_spec_[topic].md`
- Domain profile → `.claude/rules/domain-profile.md` (if still template)

### `/discover lit [topic]` — Literature Review
Search and synthesize academic literature.

**Agents:** Librarian (collector) → librarian-critic (reviewer)
**Output:** Annotated bibliography + BibTeX entries + frontier map

Workflow:
1. Read domain-profile.md for field journals and seminal references
2. Dispatch Librarian to search: top-5 journals, field journals, NBER/SSRN, citation chains
3. Dispatch librarian-critic to check coverage, gaps, recency, scope
4. If gaps found, re-dispatch Librarian for targeted search (max 1 round)
5. Save to `quality_reports/lit_review_[topic].md`

### `/discover data [requirements]` — Data Discovery
Find and assess datasets for the research question.

**Agents:** Explorer (finder) → explorer-critic (assessor)
**Output:** Ranked data sources with feasibility grades

Workflow:
1. Read research spec and strategy memo if they exist
2. Dispatch Explorer to search: public microdata, admin data, surveys, international, novel sources
3. Dispatch explorer-critic to check measurement validity, sample selection, external validity, ID compatibility
4. Save to `quality_reports/data_exploration_[topic].md`

### `/discover ideate [topic]` — Research Ideation
Generate structured research questions and hypotheses from a topic or dataset.

**Agents:** Direct generation (no agent dispatch)
**Output:** Research questions with empirical strategies

Generate:
1. 3-5 research questions with clear hypotheses
2. For each: potential identification strategy, data requirements, expected contribution
3. Rank by feasibility and novelty
4. Save to `quality_reports/research_ideas_[topic].md`

---

## Principles

- **Interview style:** Be curious, not prescriptive. Draw out the researcher's thinking.
- **Literature honesty:** Never fabricate citations. Mark unverified as `% UNVERIFIED`.
- **Data feasibility matters:** A perfect dataset you can't access is useless.
- **Domain-profile aware:** Always read domain-profile.md first for field calibration.
- **Worker-critic pairing:** Librarian + librarian-critic, Explorer + explorer-critic. Never skip the critic.
