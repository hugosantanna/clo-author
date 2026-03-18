---
name: analyze
description: End-to-end data analysis dispatching Coder and Data-engineer for implementation, coder-critic for review. Supports R, Stata, Python, Julia. Replaces /data-analysis.
argument-hint: "[dataset path or goal] Options: --dual [lang1,lang2]"
allowed-tools: Read,Grep,Glob,Write,Edit,Bash,Task
---

# Analyze

Run end-to-end data analysis by dispatching the **Coder** (analysis), **Data-engineer** (cleaning + figures), and **coder-critic** (code review).

**Input:** `$ARGUMENTS` — dataset path or description of analysis goal.

---

## Workflow

### Step 1: Context Gathering
1. Read domain-profile.md for field conventions
2. Read strategy memo in `quality_reports/` if it exists
3. Check CLAUDE.md for language preference (R/Stata/Python/Julia)
4. Scan existing scripts in `scripts/` for project patterns

### Step 2: Data Preparation (if needed)
If raw data provided, dispatch **Data-engineer** first:
- Clean and wrangle raw data
- Handle missing values, construct variables per strategy memo
- Generate summary statistics table
- Create publication-quality descriptive figures
- Save cleaned data, codebook, and figures

### Step 3: Main Analysis
Dispatch **Coder** agent:
- Stage 0: Data loading (from cleaned data or raw)
- Stage 1: Main specification (from strategy memo)
- Stage 2: Robustness checks
- Stage 3: Publication-ready output (tables to Tables/, figures to Figures/)
- Save scripts to scripts/R/ (or appropriate language directory)

### Step 4: Code Review
Dispatch **coder-critic** agent (full mode — all 12 categories):
- Strategic alignment (code-strategy, sanity, robustness)
- Code quality (structure, reproducibility, figures, RDS, polish)
- If strategy memo exists, cross-reference code against stated design

### Step 5: Fix Issues
If coder-critic finds Critical/Major issues:
1. Re-dispatch Coder with fixes (max 3 rounds)
2. Re-run coder-critic to verify

### Step 6: Present Results
1. Results summary with key estimates and SEs
2. Scripts created with paths
3. Output files in Tables/ and Figures/
4. Code review score
5. TODO items

---

## Dual-Language Mode (`--dual r,python`)

When `--dual [lang1,lang2]` is provided (e.g., `--dual r,python`, `--dual r,stata`):

1. **Data-engineer** runs once — language-agnostic cleaning, saves to `Data/cleaned/`
2. **Two Coder agents** dispatched in parallel — same strategy memo, different languages
3. **coder-critic** reviews each implementation independently (max 3 rounds each)
4. **Comparison step** — verify numerical alignment per `domain-profile.md` tolerances:
   - Point estimates must match within declared tolerance
   - Standard errors must match within declared tolerance
   - Flag any divergences with exact values from both languages
5. Save comparison report to `Output/cross_language_comparison.md`

If results diverge beyond tolerance, both Coder agents are re-dispatched to investigate. The comparison report includes a side-by-side table of all estimates.

Inspired by Scott Cunningham's approach: if two independent implementations agree, neither has a bug.

---

## Principles
- **Strategy alignment.** If strategy memo exists, code MUST implement it faithfully.
- **Worker-critic pairing.** Coder creates, coder-critic critiques. Never skip review.
- **saveRDS everything.** Every computed object gets saved for downstream use.
- **Publication-ready output.** Tables and figures directly includable in the paper.
- **Cross-language convergence.** When `--dual` is used, divergence is a bug until proven otherwise.
