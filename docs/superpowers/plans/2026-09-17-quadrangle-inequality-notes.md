# Quadrangle Inequality Notes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a concise Typst explanation of the conditions behind the existing decision-monotonicity and quadrangle-inequality DP implementations.

**Architecture:** Keep the GitHub-synchronized C++ header unchanged. Put all explanatory prose in one target-only Typst file and include it under the existing dynamic-programming heading immediately before the raw header listing.

**Tech Stack:** Typst source text, C++17 template API documentation, Git

## Global Constraints

- Use GitHub `JimmyWang0417/Algorithm-Competitive-Codes` ref `master`, commit `83bb30e44e3cfc7cea24b0ffd4e3ea9c8eb7c010`, as the implementation authority.
- Do not modify `Templates/dynamic_programming/monotone_dp.hpp`.
- Do not add a full proof, worked problem, partition theory, or unrelated DP material.
- Explain both the Monge transition-matrix use and the interval-DP/Knuth use without treating their hypotheses as interchangeable.
- Do not compile C++, compile Typst, or create a PDF in this update.

---

### Task 1: Add and Integrate the Decision-Monotonicity Note

**Files:**
- Create: `Templates/dynamic_programming/monotone_dp.typ`
- Modify: `Templates/dynamic_programming/main.typ`
- Preserve: `Templates/dynamic_programming/monotone_dp.hpp`

**Interfaces:**
- Consumes: the transition value `calc(i, j)`, strict comparator `cmp`, interval cost `cost(l, r)`, and base value `zero` already accepted by `monotone_dp.hpp`.
- Produces: prose and formulas immediately preceding the corresponding C++ listing; no runtime or API change.

- [x] **Step 1: Record the preserved-header baseline and verify the include is absent**

Run:

```bash
sha256sum Templates/dynamic_programming/monotone_dp.hpp
rg -F '#include "monotone_dp.typ"' Templates/dynamic_programming/main.typ
```

Expected: the hash is recorded and `rg` exits with status `1` because the new note is not yet included.

- [x] **Step 2: Write the focused Typst note**

Create `monotone_dp.typ` with these exact content units:

1. Define `dp_j = min_i A(i,j)` and the smallest optimal decision `opt_j`.
2. State the minimum-version Monge inequality
   `A(i_1,j_1)+A(i_2,j_2) <= A(i_1,j_2)+A(i_2,j_1)` for ordered indices and conclude that `opt_j` is nondecreasing.
3. Explain that `A(i,j)=previous_dp_i+w(i,j)` inherits the inequality from `w`, and that maximization reverses the inequality.
4. Map the bounded overload of `monotoneDP` to divide-and-conquer optimization and the vector overload to candidate dominance intervals; state that the latter needs the single-crossing property supplied by Monge, not merely a claimed monotone optimum.
5. State the exact recurrence used by `quadrangleDP`:

```text
dp[l][r] = min_{l <= k < r}(dp[l][k] + dp[k + 1][r]) + w(l,r).
```

6. For `a <= b <= c <= d`, state both sufficient cost conditions
   `w(a,c)+w(b,d) <= w(a,d)+w(b,c)` and
   `w(b,c) <= w(a,d)`, then the bound
   `opt[l][r-1] <= opt[l][r] <= opt[l+1][r]` and the `O(n^3)` to `O(n^2)` reduction.
7. Explain `n`, `zero`, `cost`, `cmp`, the returned `(dp, from)`, strict-comparison tie handling, and the need to prove the conditions before calling the optimized interfaces.

- [x] **Step 3: Include the note beside its implementation**

Change the existing section to:

```typst
=== 决策单调性优化 DP
#include "monotone_dp.typ"
#raw(read("monotone_dp.hpp"), lang: "cpp", block: true)
```

- [x] **Step 4: Perform non-build validation**

Run:

```bash
rg -n '四边形不等式|区间包含单调性|quadrangleDP|O\(n\^3\)|O\(n\^2\)' Templates/dynamic_programming/monotone_dp.typ
rg -F '#include "monotone_dp.typ"' Templates/dynamic_programming/main.typ
sha256sum Templates/dynamic_programming/monotone_dp.hpp
git diff --check
git diff -- Templates/dynamic_programming/main.typ Templates/dynamic_programming/monotone_dp.typ Templates/dynamic_programming/monotone_dp.hpp
```

Expected: every required topic and the include are present, the header hash matches Step 1, whitespace validation passes, and the diff contains no C++ change.

- [x] **Step 5: Commit the completed note**

```bash
git add Templates/dynamic_programming/main.typ Templates/dynamic_programming/monotone_dp.typ docs/superpowers/plans/2026-09-17-quadrangle-inequality-notes.md
git commit -m "docs: explain quadrangle inequality DP"
```
