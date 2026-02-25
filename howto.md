# Degree Sequences & Bipartite Graphs — How-To

All scripts are in `src/` and require [SageMath](https://www.sagemath.org/).

---

## Scripts

### `factor.sage`

| | |
|---|---|
| **Goal** | Compute the prime factorization of an integer using Sage's `factor()`. |
| **Input** | A single integer `n` as a command-line argument. |
| **Output** | The prime factorization of `n`, printed to stdout. |

```bash
sage src/factor.sage 360
# => 2^3 * 3^2 * 5
```

---

### `realize.sage`

| | |
|---|---|
| **Goal** | Check whether a degree sequence is graphic (realizable) using Sage's Havel–Hakimi implementation, and if so, build and plot the realized graph. |
| **Input** | A degree sequence as space-separated integers on the command line. |
| **Output** | Prints whether the sequence is graphic. On success, saves a plot of the realized graph to `realization.png` and opens it. |

```bash
sage src/realize.sage 3 3 2 2 2
# => "Sequence is graphic!" + realization.png
```

---

### `test_graphic_show_steps.sage`

| | |
|---|---|
| **Goal** | Walk through the Havel–Hakimi algorithm step-by-step, printing the reduced sequence at each iteration. Then plot the final realization. |
| **Input** | A degree sequence as space-separated integers on the command line. |
| **Output** | Step-by-step trace of Havel–Hakimi printed to stdout. If graphic, saves the final graph to `realization.png`. |

```bash
sage src/test_graphic_show_steps.sage 3 3 2 2 2
```

---

### `count_subforests.sage`

| | |
|---|---|
| **Goal** | Count (by brute-force enumeration of edge subsets) the total number of acyclic subgraphs (subforests) of several example graphs. |
| **Input** | None — examples are hardcoded (K_{2,2}, path P_4, cycle C_4, K_{3,3}). |
| **Output** | For each example: vertices, edges, edge count, and total subforest count printed to stdout. |

```bash
sage src/count_subforests.sage
```

---

### `count_subforests_bipartite.sage`

| | |
|---|---|
| **Goal** | Same as `count_subforests.sage`, but enforces that the input graph is bipartite. Also demonstrates error handling for non-bipartite input. |
| **Input** | None — examples are hardcoded (K_{2,2}, P_4, C_4, K_{3,3}, plus a triangle to trigger the error). |
| **Output** | For each example: vertices, edges, bipartiteness check, and subforest count. For the triangle, prints a `ValueError`. |

```bash
sage src/count_subforests_bipartite.sage
```

---

### `draw_tetrahedron.sage`

| | |
|---|---|
| **Goal** | Render an interactive 3D tetrahedron using Sage's `tetrahedron()`. |
| **Input** | None. |
| **Output** | Opens a 3D viewer window showing a red, semi-transparent meshed tetrahedron. |

```bash
sage src/draw_tetrahedron.sage
```

---

### `helpers.sage`

Shared library loaded by the counting scripts. Provides:

| Function | Description |
|---|---|
| `is_forest(graph)` | Returns `True` if the graph is acyclic. |
| `count_subforests(graph)` | Returns `(count, list_of_subforests)` for any graph. |
| `count_subforests_fast(graph)` | Returns only the count (no list), for any graph. |
| `count_subforests_bipartite(graph)` | Like `count_subforests`, but raises `ValueError` if the graph is not bipartite. |
| `count_subforests_bipartite_fast(graph)` | Like `count_subforests_fast`, but raises `ValueError` if the graph is not bipartite. |
