# Makefile Template Synchronization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the codebook Makefile template with the sibling worktree's current ordinary and sanitizer build rules.

**Architecture:** Copy the single authoritative template byte-for-byte, retain its existing Typst entry, validate both pattern rules with `make -n`, then regenerate metadata and compile both codebook layouts.

**Tech Stack:** GNU Make, GCC C++20, Typst 0.15.1, Git, `Generator.py`

## Global Constraints

- Source: `../Algorithm-Competitive-Codes/Templates/initialization_misc/makefile`.
- Target: `Templates/initialization_misc/makefile`.
- Do not import `../Algorithm-Competitive-Codes/Environment/makefile`.
- Preserve the existing Typst Makefile entry.
- Source and target must compare byte-for-byte.

---

### Task 1: Synchronize and Verify the Makefile Template

**Files:**
- Modify: `Templates/initialization_misc/makefile`.
- Preserve: `Templates/initialization_misc/main.typ`.
- Modify: `README.md` through `Generator.py`.

**Interfaces:**
- Consumes: source ordinary `%` and sanitizer `%-asan` pattern rules.
- Produces: the same two rules in the rendered codebook and updated repository statistics.

- [ ] **Step 1: Confirm the pre-sync difference**

```bash
cmp ../Algorithm-Competitive-Codes/Templates/initialization_misc/makefile Templates/initialization_misc/makefile
```

Expected: nonzero because the target still contains the two-line C++17 rule.

- [ ] **Step 2: Replace the target with exact source content**

The target must contain the complete 11-line source Makefile, including the ordinary C++20 rule and `%-asan` sanitizer rule.

- [ ] **Step 3: Verify content, entry, and rule expansion**

```bash
cmp ../Algorithm-Competitive-Codes/Templates/initialization_misc/makefile Templates/initialization_misc/makefile
rg -n 'raw\(read\("makefile"\)' Templates/initialization_misc/main.typ
make -n -f Templates/initialization_misc/makefile /tmp/makefile-sync-probe
make -n -f Templates/initialization_misc/makefile /tmp/makefile-sync-probe-asan
```

Expected: byte comparison succeeds, the entry occurs once, the first dry-run expands the optimized C++20 command, and the second expands both sanitizer flags.

- [ ] **Step 4: Regenerate metadata and compile both layouts**

```bash
./Generator.py
typst compile --root . codebook/wide/main.typ /tmp/cp-wide.pdf
typst compile --root . codebook/compact/main.typ /tmp/cp-compact.pdf
```

Expected: README reports an 11-line Makefile and both Typst commands exit zero.

- [ ] **Step 5: Commit and audit**

```bash
git add Templates/initialization_misc/makefile README.md
git commit -m "sync: update makefile template"
git status --short --branch
```

Expected: the commit contains only the Makefile and regenerated README; the worktree is clean apart from ignored local files.

