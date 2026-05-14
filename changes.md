# Changes to `src/main.ipynb`

## Cell 0 (imports)

- Added `from sage.all import BipartiteGraph, Graph` 

---

## Cell 3 (`make_cycles`)

- Before: Called `G.all_simple_cycles()` on the original graph.
- Now: Builds a simple unlabeled copy `H` on the same vertex set as `G`, adds edges as sorted `(u, v)` pairs from `G.edges(labels=True)`, then calls `H.all_simple_cycles()` on that plain `Graph`.
- Why: Labeled `BipartiteGraph` (and some labeled instances) can misbehave on cycle enumeration; a plain `Graph` copy avoids that.
- Docstring updated to describe the unlabeled-copy approach.

---

## Cell 6 (edge-label helpers)

- Replaced invalid `//` comment syntax with a normal `#` comment.
- Added `parent_edge_order(G)`, returning `(all_labels, label_to_edge)` with labels sorted so every subgraph uses the same indicator coordinates as the root graph.
- `graph_to_indicator_tuple` / `indicator_tuple_to_graph` kept; they sit below the new helper.

---

## Cell 7 (demo)

- Uses `all_labels, label_to_edge = parent_edge_order(G)` instead of hand-building those from `G.edges`.

---

## Cell 8 (`complete_alt_cycles` and helpers)

- Removed the duplicate `make_cycles` definition (single source remains in cell 3).
- Replaced broken `complete_alt_cycles` with:
  - `_sorted_uv(u, v)`
  - `_add_labeled_edge_from_pair(H, G, ab)` — adds the matching labeled edge from `G` onto `H`
  - `complete_alt_cycles(H, G, new_labeled_edge)` — walks `make_cycles(G)`, normalizes cycle edges, splits alternating halves `c1` / `c2`, and when the pattern matches `find_alt_cycles`-style logic, adds missing cycle edges (with labels from `G`).

---

## Cell 10 (`getf`)

- Replaced `G.subgraphs()` with `all_subgraphs(G)` (full edge-subset enumeration).
- Dictionary keys are always `graph_to_indicator_tuple(H, edge_labels=root_labels)` so keys stay tuple indicators in a fixed global label order.
- Added optional arguments `root_labels=None, label_to_edge=None`; on the first call they are set from `parent_edge_order(G)`.
- Forest base: for each `H` in `all_subgraphs(G)`, `f[t] = H.copy()` with `t` the indicator tuple.
- Non-forest: peel the last edge in `sorted(G.edges(labels=True), key=lambda e: e[2])`, recurse on `Gm = G.copy()` with that edge deleted; for each subgraph `H`, either copy `f_prev[t]` if that edge label is missing, or delete it from `H`, look up `f_prev[t_minus]`, add the edge back to a copy of that image, then `complete_alt_cycles(base, G, e_last)`.
- Added a short docstring.

---

## Cell 11 (`main` and degree helpers)

- Replaced placeholder `main()` with a real driver plus helpers:
  - `bipartite_degree_ordered(H, left, right)`
  - `sorted_multiset_degrees(H)`
  - `vertex_order_degree_tuple(H)`
- `main()` asserts `getf` size on a labeled 4-cycle, builds bipartite G4 and Gb (labeled like the other test notebook), prints forest counts and distinct degree statistics for several codomain choices, and asserts `len(getf(G4)) == 2G4.size()` and `len(getf(Gb)) == 2**Gb.size()`.

---

## Cell 12 (new)

- Contains `main()` so “Run All” runs the verification block.

