---
name: tools
description: Utility commands — commit, compile, validate-bib, journal, context-status, deploy, learn. Replaces individual utility skills.
argument-hint: "[subcommand: commit | compile | validate-bib | journal | context | deploy | learn] [args]"
allowed-tools: Read,Grep,Glob,Write,Edit,Bash,Task
---

# Tools

Utility subcommands for project maintenance and infrastructure.

**Input:** `$ARGUMENTS` — subcommand followed by any arguments.

---

## Subcommands

### `/tools commit [message]` — Git Commit
Stage changes, create commit, optionally create PR and merge.
- Run git status to identify changes
- Stage relevant files (never stage .env or credentials)
- Create commit with descriptive message
- If quality score available and >= 80, note in commit

### `/tools compile [file]` — LaTeX Compilation
3-pass XeLaTeX + bibtex compilation.

For papers:
```bash
cd Paper && TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode [file]
BIBINPUTS=..:$BIBINPUTS bibtex [file_base]
TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode [file]
TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode [file]
```

For talks:
```bash
cd Talks && TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode [file]
```

### `/tools validate-bib` — Bibliography Validation
Cross-reference all \cite{} keys in paper and talk files against Bibliography_base.bib.
Report: missing entries, unused entries, duplicate keys.

### `/tools journal` — Research Journal
Regenerate the research journal timeline from quality reports and git history.
Shows chronological record of agent actions, phase transitions, scores, decisions.

### `/tools context` — Context Status
Show current context status and session health.
Check context usage, whether auto-compact is approaching, what state will be preserved.

### `/tools deploy` — Deploy Guide Site
Render Quarto guide site and sync to GitHub Pages.
```bash
cd guide && quarto render
```
Then commit docs/ changes and push.

### `/tools learn` — Extract Learnings
Extract reusable knowledge from the current session into MEMORY.md.
Look for non-obvious discoveries, workarounds, multi-step workflows.
Follow the two-tier system: generic → MEMORY.md, machine-specific → .claude/state/personal-memory.md.

---

## Principles
- **Each subcommand is lightweight.** No multi-agent orchestration needed.
- **Compile always uses 3-pass.** Ensures references and citations resolve.
- **validate-bib catches drift.** Run before commits to catch broken citations.
