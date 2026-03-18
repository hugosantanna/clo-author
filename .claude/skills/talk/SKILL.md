---
name: talk
description: Create and audit Beamer presentations. Combines talk creation, visual audit, and compilation. Replaces /create-talk, /visual-audit, /compile-latex (for talks).
argument-hint: "[mode: create | audit | compile] [format: job-market | seminar | short | lightning] [file path]"
allowed-tools: Read,Grep,Glob,Write,Edit,Task,Bash
---

# Talk

Create, audit, or compile Beamer presentations.

**Input:** `$ARGUMENTS` — mode and format/path.

---

## Modes

### `/talk create [format]` — Create New Talk
Generate a Beamer presentation from the paper.

**Agents:** Storyteller (creator) → storyteller-critic (reviewer)

Formats:
| Format | Slides | Duration | Scope |
|--------|--------|----------|-------|
| job-market | 40-50 | 45-60 min | Full story, all results |
| seminar | 25-35 | 30-45 min | Motivation, main result, robustness |
| short | 10-15 | 15 min | Question, method, key result |
| lightning | 3-5 | 5 min | Hook, one result, so-what |

Workflow:
1. Read paper (Paper/main.tex)
2. Dispatch Storyteller to design narrative arc and build slides
3. Compile with XeLaTeX
4. Dispatch storyteller-critic to review (5 categories: narrative, visual, fidelity, scope, compilation)
5. Fix critical issues (max 3 rounds)
6. Save to Talks/[format]_talk.tex

### `/talk audit [file]` — Visual Audit
Check existing slides for layout issues.

Run visual quality checks:
- Text overflow on any slide
- Font sizes (>= 10pt for projection)
- Table readability
- Figure sizing and labels
- Consistent formatting
- Overfull hbox warnings

### `/talk compile [file]` — Compile Talk
3-pass XeLaTeX compilation for Beamer:
```bash
cd Talks && TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode [file]
```

---

## Principles
- **Paper is authoritative.** Every claim must appear in the paper.
- **Less is more.** Especially for short and lightning formats.
- **Advisory scoring.** Talk scores don't block commits.
- **One idea per slide.** Figures over tables (tables in backup).
