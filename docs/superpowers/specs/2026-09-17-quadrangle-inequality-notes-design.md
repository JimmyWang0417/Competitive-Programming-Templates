# Quadrangle Inequality Notes Design

## Goal

Add the minimum theory needed to use the decision-monotonicity and quadrangle-
inequality DP interfaces that already exist in `monotone_dp.hpp`, without
turning the codebook into a general partition-theory or dynamic-programming
textbook.

## Authority and Current State

- The authoritative implementation is
  `JimmyWang0417/Algorithm-Competitive-Codes` on GitHub, ref `master`, commit
  `83bb30e44e3cfc7cea24b0ffd4e3ea9c8eb7c010`.
- The upstream and local `Templates/dynamic_programming/monotone_dp.hpp` files
  agree at that commit.
- The implementation already provides divide-and-conquer decision
  monotonicity, a candidate-interval variant, and `quadrangleDP`; this update
  changes no C++ API.

## Chosen Scope

Create one focused Typst note beside the header and include it under the
existing “决策单调性优化 DP” heading. The note will contain only:

1. the minimum-version Monge/quadrangle inequality and the reversed
   inequality used for maximization;
2. the implication from a Monge transition matrix to monotone optimal
   decisions, including the tie convention needed by the implementation;
3. the interval-DP recurrence implemented by `quadrangleDP`, the additional
   interval-inclusion monotonicity condition, the resulting Knuth bounds, and
   the reduction from cubic to quadratic time;
4. a short mapping from the three public interfaces to their preconditions;
5. a compact checklist warning that decision monotonicity alone does not
   justify the candidate-interval implementation unless the required
   single-crossing property also holds.

The note will not contain a full proof, worked problem, partition-number
theory, or unrelated DP optimizations.

## Mathematical Conventions

For minimization, use the Monge convention

```text
A(a,c) + A(b,d) <= A(a,d) + A(b,c),  a <= b, c <= d.
```

For interval cost `w`, specialize it to ordered endpoints
`a <= b <= c <= d`. For

```text
dp[l][r] = min_{l <= k < r}(dp[l][k] + dp[k + 1][r]) + w(l,r),
```

state the sufficient conditions `w(b,c) <= w(a,d)` and the quadrangle
inequality. With the smallest optimal split chosen on ties, state

```text
opt[l][r - 1] <= opt[l][r] <= opt[l + 1][r].
```

The maximization form reverses the inequalities and uses a matching strict
comparator.

## Files and Validation

- Create `Templates/dynamic_programming/monotone_dp.typ` for the explanation.
- Modify `Templates/dynamic_programming/main.typ` to include it immediately
  before the existing raw header listing.
- Leave `Templates/dynamic_programming/monotone_dp.hpp` unchanged.
- Do not compile C++, run Typst, or produce a PDF in this update. Validate by
  inspecting the exact diff, checking the include path, and confirming that
  the upstream-managed header remains byte-for-byte unchanged.
