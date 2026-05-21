# Cycle Selection Issue in the Recursive Bijection

## Background

We are constructing a bijection
$$f_G : \{\text{spanning forests of } G\} \to \{\text{distinct degree sequences of all spanning subgraphs of } G\}$$
recursively on the edges of $G$. The construction peels off the last edge $e_n$ (by label), recurses on $G' = G - e_n$, and then handles subforests that contain $e_n$ via:

$$f_G(H) = \text{completeAltCycles}\!\left(f_{G'}(H \setminus e_n) \cup \{e_n\},\; G,\; e_n\right)$$

The function `completeAltCycles` looks for a cycle $C$ in $G$ through $e_n$ on which the current subgraph **alternates** — meaning it contains exactly one of the two alternating halves of $C$ — and adds the missing half.

When $G$ has only one cycle through $e_n$, this step is unambiguous. When there are multiple such cycles and the current subgraph alternates on more than one simultaneously, a **tie-breaking rule** is needed. We currently use: **complete the longest alternating cycle, stop after the first.**

---

## Where the Rule Works: $G_b$ (7 edges, 2 cycles)

$G_b$ has left vertices $\{1,4,5\}$, right vertices $\{2,3,6\}$, and edges:

```
'1'=(1,2)  '2'=(1,3)  '3'=(2,4)  '4'=(3,4)  '5'=(4,6)  '6'=(5,6)  '7'=(3,5)
```

The last edge is `'7' = (3,5)`. Two cycles of $G_b$ pass through `'7'`:

| Cycle | Edges | Length |
|-------|-------|--------|
| $C_4$ | `'4','5','6','7'` — vertices $3,4,6,5$ | 4 |
| $C_6$ | `'2','3','5','6','7'` + one more — vertices $1,2,4,6,5,3$ | 6 |

These two cycles are **nested**: the 4-cycle's edges are a subset of the 6-cycle's edges.

**The collision scenario (before the fix).** Forest `['1','5','7']` alternated on *both* cycles simultaneously. Completing the 4-cycle (shorter, found first) mapped it to a subgraph with degree sequence $(1,1,2,2,2,2)$, the same as the image of a different forest. Completing the 6-cycle instead maps it to `['1','2','3','5','6','7']` with degree $(2,2,2,2,2,2)$ — unique.

**Why "longest wins" fixes it.** The 4-cycle and 6-cycle completions produce *different-sized* images. The longer cycle adds more edges, reaching a subgraph that no shorter-cycle completion can reach from any other forest. Preferring the longer cycle breaks the collision.

**Verified:** $G_b$ gives 112 forests, 112 distinct degree sequences, and `getf` covers all 112. ✓

---

## Where the Rule Fails: $K_{2,3}$ (6 edges, 3 four-cycles)

$K_{2,3}$ has left vertices $\{0,1\}$, right vertices $\{2,3,4\}$, and all six edges between them:

```
'1'=(0,2)  '2'=(0,3)  '3'=(0,4)  '4'=(1,2)  '5'=(1,3)  '6'=(1,4)
```

The last edge is `'6' = (1,4)`. Two cycles pass through `'6'`:

| Cycle | Edges | Length |
|-------|-------|--------|
| $C_2$ | `'1','3','4','6'` — vertices $0,2,1,4$ | 4 |
| $C_3$ | `'2','3','5','6'` — vertices $0,3,1,4$ | 4 |

Both cycles have **the same length**. Moreover, they are **non-nested**: $C_2$ and $C_3$ share only the edge `'3'=(0,4)` — they are two independent 4-cycles that happen to both pass through `'6'`.

### The Collision

Three spanning trees of $K_{2,3}$ all map to the full graph under `getf`:

| Forest | Edges | Cycle triggered | Image |
|--------|-------|-----------------|-------|
| `['1','2','4','6']` | $(0,2),(0,3),(1,2),(1,4)$ | $C_3$ (adds `'3','5'`) | full $K_{2,3}$ |
| `['1','2','5','6']` | $(0,2),(0,3),(1,3),(1,4)$ | $C_2$ (adds `'3','4'`)  | full $K_{2,3}$ |
| `['1','3','5','6']` | $(0,2),(0,4),(1,3),(1,4)$ | $C_1$ in sub-recursion  | full $K_{2,3}$ |

The full $K_{2,3}$ is the **only** subgraph with degree sequence $(3,3,2,2,2)$, so only one forest can correctly map there. The other two should map to distinct 5-edge subgraphs — specifically the ones missing edge `'4'` (degree $(3,2,1,2,2)$) and missing edge `'5'` (degree $(2,3,2,1,2)$) — but `getf` never reaches those degree sequences.

### Why "Longest Wins" Cannot Help

Each of the three forests has **exactly one** alternating cycle through `'6'` — there is no tie to break within any individual forest's processing. The "longest wins" rule is irrelevant because:

1. For `['1','2','4','6']`: only $C_3$ alternates (because edge `'4'=(1,2)` is already in the base, which prevents $C_2$ from being fully alternating).
2. For `['1','2','5','6']`: only $C_2$ alternates (edge `'5'=(1,3)` is in the base, blocking $C_3$).
3. For `['1','3','5','6']`: the collision originates *inside the sub-recursion* on $K_{2,3} - \text{'6'}$, where cycle $C_1$ (the sole cycle of that subgraph) completes the sub-forest to all 5 remaining edges. Adding `'6'` then saturates the graph without any further cycle completion.

The fundamental problem: in $K_{2,3}$, completing *any* alternating 4-cycle through `'6'` from a 4-edge alternating base always adds the 2 remaining edges and fills all 6 edges. The symmetry of $K_{2,3}$'s cycle structure means multiple recursive paths converge on the same saturated image.

---

## Why the Count Still Holds

Although `getf` fails as a bijection, the combinatorial count is correct:

$$|\text{spanning forests of } K_{2,3}| = 54 = |\text{distinct degree sequences of all spanning subgraphs}|$$

This is verified directly by enumeration and is independent of whether we have an explicit bijective map. The bijection *exists* — we just haven't constructed it yet.

---

## Ideas for Fixing the Construction

### Idea 1: Lexicographic Tie-Breaking on the Missing Half

When multiple cycles of equal length through $e_n$ are simultaneously alternating in $H$, prefer the cycle whose **missing half** (the edges to be added) has the lexicographically largest set of edge labels.

**Why it might work:** it gives a deterministic canonical choice. Different forests that trigger different cycles would be steered toward different completions, potentially avoiding collisions.

**Problem:** as traced above, each colliding forest in $K_{2,3}$ triggers only *one* cycle — there is no tie within a single forest. The collision is caused by the *recursive structure* producing the same image from different inputs, not by ambiguous cycle selection at the top level. Lexicographic tie-breaking would not affect these cases.

### Idea 2: Complete All Simultaneously Alternating Cycles

Instead of completing one cycle and stopping, apply all alternating cycles simultaneously (treating the additions as a single atomic step).

**Why it might work:** if $H$ alternates on two cycles $C$ and $C'$ through $e_n$, completing both at once adds $(\text{missing half of } C) \cup (\text{missing half of } C')$, producing a larger image that might be distinct from any single-cycle completion.

**Problem:** as checked by tracing, in $K_{2,3}$ each colliding forest alternates on exactly *one* cycle through `'6'` (not two), so completing all cycles still applies only one completion per forest. The collision persists.

### Idea 3: Edge Ordering Constraint

Choose the edge label ordering so that the **last edge** lies in at most one cycle of $G$.

**Why it might work:** if $e_n$ is in only one cycle, `completeAltCycles` is unambiguous at the top level of the recursion, eliminating top-level collisions.

**Problem:** this does not eliminate collisions arising in sub-recursions (as in forest `['1','3','5','6']`). It also places a strong constraint on which edge orderings are valid, and it is not obvious that such an ordering always exists for arbitrary bipartite graphs.

### Idea 4: Use Fundamental Cycles with Respect to a Spanning Tree

Fix a spanning tree $T$ of $G$. For each non-tree edge $e$, define its **fundamental cycle** $C_e$ as the unique cycle in $T \cup \{e\}$. Order edges so that tree edges come first, then non-tree edges by label. At each recursive step, the "last edge" $e_n$ is a non-tree edge and has a unique fundamental cycle $C_{e_n}$.

**Why it might work:** fundamental cycles are unique by definition, eliminating multi-cycle ambiguity at each top-level recursion step. This would fix cases like `['1','2','5','6']` where the top-level step triggers an ambiguous cycle.

**Problem:** the sub-recursions use the same bijection on $G - e_n$, which may itself encounter non-tree edges lying in multiple cycles of the sub-graph. Uniqueness of fundamental cycles in $G$ does not guarantee uniqueness in all sub-graphs. Also, forest `['1','3','5','6']` collides due to a sub-recursion, not the top level, so this idea alone may not suffice.

### Idea 5: Restrict to Series-Parallel Graphs

A **series-parallel** bipartite graph has the property that any two cycles share at most one edge. In such graphs, when $H$ alternates on two cycles through $e_n$ simultaneously, those cycles are nested (one contains the other), and the "longest wins" rule is always unambiguous.

**Why it might work:** this is exactly the structure that makes $G_b$ work — the 4-cycle is nested inside the 6-cycle. Series-parallel graphs may be the natural domain where the current construction is provably correct.

**Next step:** verify that the bijection works correctly for all series-parallel bipartite graphs with the current "longest wins" rule. If so, this characterizes the class of graphs for which `getf` is a valid bijection and motivates either restricting the claim to this class or finding a stronger construction for the general case.

### Idea 6: Alternative Bijection via Involutions

Replace the alternating-cycle construction entirely with a different approach. One known technique for bijective proofs of this type is to construct an **involution** on all spanning subgraphs that pairs non-forests with subgraphs sharing their degree sequence, leaving forests as fixed points. If such an involution exists, it directly witnesses the count equality.

**Why it might work:** involution-based proofs often avoid the recursive cycle-selection problem entirely.

**Difficulty:** constructing the involution explicitly for bipartite graphs requires identifying a canonical pairing for each non-forest subgraph, which is non-trivial and may require different machinery (e.g., the Tutte polynomial or a direct combinatorial argument on the degree sequence multiset).

---

## Summary Table

| Approach | Fixes $G_b$? | Fixes $K_{2,3}$? | Generality | Difficulty |
|----------|-------------|-----------------|------------|------------|
| Longest cycle wins (current) | ✓ | ✗ | Nested-cycle graphs | Low |
| Lex tie-breaking on missing half | ✓ | ✗ | Unclear | Low |
| Complete all alternating cycles | ✓ | ✗ | Unclear | Low |
| Edge ordering constraint | Partial | Partial | Restricted orderings | Medium |
| Fundamental cycles via spanning tree | Likely ✓ | Partial | Unclear | Medium |
| Restrict to series-parallel graphs | ✓ | N/A | Series-parallel only | Medium |
| Involution-based bijection | ✓ | ✓ (if constructible) | All bipartite graphs | High |
