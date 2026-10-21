# Competitive Programming Toolkit & C++ Library

A high-performance, battle-tested competitive programming library and workspace featuring **188 production-grade C++ snippets** organized across 11 domain-specific modules, automated compilation scripts with strict GCC sanitizer enforcement, automated differential stress-testing tooling, and editor optimizations for VS Code.

---

## Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Featured Components](#featured-components)
  - [1. Advanced Coordinate Compression (`Compressor`)](#1-advanced-coordinate-compression-compressor)
  - [2. Persistent Segment Tree & Workflows](#2-persistent-segment-tree--workflows)
  - [3. Core Template & Fast I/O](#3-core-template--fast-io)
- [Modular Snippets Catalog (171 Snippets)](#modular-snippets-catalog-171-snippets)
  - [Module Breakdown](#module-breakdown)
  - [Detailed Catalog by Category](#detailed-catalog-by-category)
- [Developer Tools & Automation](#developer-tools--automation)
  - [1. Build & Run Helper (`tools/run.sh`)](#1-build--run-helper-toolsrunsh)
  - [2. Automated Differential Stress Tester (`tools/stress.sh`)](#2-automated-differential-stress-tester-toolsstresssh)
- [VS Code Integration & Settings](#vs-code-integration--settings)
- [Recommended Contest Workflow](#recommended-contest-workflow)
- [Prerequisites & Setup](#prerequisites--setup)

---

## Overview

Designed for competitive programming on platforms like **Codeforces**, **AtCoder**, **CSES**, **CodeChef**, and **USACO**:

- **Safety-First Local Execution**: Catches segmentation faults, out-of-bounds indexing, and undefined behavior locally via AddressSanitizer (`-fsanitize=address,undefined`) and GLIBCXX debug checks (`-D_GLIBCXX_DEBUG`).
- **Differential Stress Testing**: Automated verification of candidate solutions against slow brute-force implementations on randomized inputs, producing minimal failing testcases.
- **11 Domain-Specific Snippet Modules**: 171 modular snippets organized logically by algorithmic domain for rapid tab-completion during timed contests.
- **Modern C++17/20 Implementation**: Optimized for clean interfaces, minimal boilerplate, zero-overhead abstraction, and fast execution.

---

## Repository Structure

```text
.
├── .vscode/
│   ├── cp-templates.code-snippets              # Contest boilerplate, macros, fast I/O, debug print
│   ├── cp-techniques.code-snippets             # Coordinate compression, 2D prefix sums, bit tricks
│   ├── cp-segtree.code-snippets                # Iterative SegTree (Monoid) & Li Chao Tree
│   ├── cp-lazy-segtree.code-snippets           # Lazy Segment Tree (ACL style range ops)
│   ├── cp-persistent-segtree.code-snippets     # Persistent SegTree (PST) & Lazy PST (Flip/Sum)
│   ├── cp-merge-sort-tree.code-snippets        # Static & Point-Update (PBDS) Merge Sort Trees
│   ├── cp-dsu-fenwick.code-snippets            # DSU (Standard/Rollback/Potential), Fenwick, PBDS
│   ├── cp-hash-linked-list.code-snippets       # Hash tables, Anti-hack custom hash, Linked Lists
│   ├── cp-stack-queue.code-snippets            # Stacks, Queues, Deque, Monotonic Stacks, Shunting-Yard
│   ├── cp-advanced-trees.code-snippets         # BST, AVL Tree, Red-Black Tree, Heaps, Tries
│   ├── cp-graph-paths.code-snippets            # BFS, Dijkstra, 0-1 BFS, Bellman-Ford, Floyd-Warshall
│   ├── cp-graph-connectivity.code-snippets     # MST, SCC (Tarjan/Kosaraju), 2-SAT, Bridges, BCC
│   ├── cp-graph-flows.code-snippets            # Dinic Max Flow, Min-Cost Max-Flow, Hopcroft-Karp
│   ├── cp-graph-trees.code-snippets            # HLD, Centroid Decomposition, LCA, Euler Tour
│   ├── cp-math-number-theory.code-snippets     # Sieves, Miller-Rabin, Pollard's Rho, BSGS, Tonelli-Shanks
│   ├── cp-math-combinatorics.code-snippets     # Binomial, Catalan, Combinations, Permutations
│   ├── cp-math-algebra.code-snippets           # Modular integer (mint), Matrix, Linear Basis, CRT
│   ├── cp-math-polynomials.code-snippets       # NTT, Polynomial Convolution, Inverse, Bostan-Mori
│   ├── cp-dp.code-snippets                     # LIS, LCS, Knapsacks, Digit DP, SOS DP, D&C optimization
│   ├── cp-strings.code-snippets                # KMP, Z-algorithm, Manacher, Rolling Hash, Suffix Array
│   ├── cp-geometry.code-snippets               # Points & Vectors, Convex Hulls, Polygon Area
│   ├── cp-searching-sorting.code-snippets      # Binary Search, Ternary Search, Mo's Algorithm, Sorts
│   ├── cp-backtracking.code-snippets           # N-Queens, Knight's Tour, Graph Coloring, Combinations
│   └── settings.json                           # VS Code configuration for snippet expansion
├── tools/
│   ├── run.sh                             # Compilation runner (debug with sanitizers or fast -O2)
│   └── stress.sh                          # Automated differential stress tester
└── README.md                              # Toolkit documentation
```

---

## Featured Components

### 1. Advanced Coordinate Compression (`Compressor`)

Prefixes: `cp-coordinate-compression`, `cp-compress`

An idiomatic, cache-friendly template struct that avoids repetitive binary searches by precomputing ranks for all array elements in $\mathcal{O}(1)$ time, while offering dedicated methods for dynamic/arbitrary query values.

```cpp
template <class T> struct Compressor {
    vector<T> vals;   // sorted distinct values (reverse lookup: vals[rank])
    vector<int> rnk;  // rnk[i] = rank of a[i] in O(1) without binary search

    Compressor() = default;
    Compressor(const vector<T> &a) { init(a); }

    void init(const vector<T> &a);
    int size() const;
    int operator[](int i) const;          // O(1) rank of original array element a[i]
    const T &value(int rank) const;       // O(1) reverse lookup (rank -> original value)

    // Binary search methods for arbitrary / dynamic query values (e.g. k-query):
    int rank(const T &x) const;           // Rank of x if present, else largest rank <= x (-1 if x < min)
    int rank_leq(const T &x) const;       // Largest rank with value <= x (-1 if x < min)
    int rank_lt(const T &x) const;        // Largest rank with value < x (-1 if x <= min)
    int rank_geq(const T &x) const;       // Smallest rank with value >= x (size() if x > max)
    int rank_gt(const T &x) const;        // Smallest rank with value > x (size() if x >= max)
    int rank_exact(const T &x) const;     // Exact rank if present, -1 if absent
};
```

#### Usage Example

```cpp
vector<ll> a = {10, 50, 20, 50, 30};
Compressor<ll> C(a);

// O(1) lookup for array elements:
int r = C[2];             // Rank of a[2] (20) -> 1 (zero binary search!)
ll orig = C.value(1);     // Original value at rank 1 -> 20

// Binary search for dynamic query values:
int r1 = C.rank_leq(25);  // Largest value <= 25 is 20 -> rank 1
int r2 = C.rank_geq(25);  // Smallest value >= 25 is 30 -> rank 2
```

---

### 2. Persistent Segment Tree & Workflows

Prefixes: `cp-persistent-segtree`, `cp-pst`, `cp-pst-init`, `cp-pst-kth`, `cp-pst-leq`, `cp-pst-count`

A path-copying persistent segment tree built over value universes. Enables offline and online subarray queries on any version $0 \dots N$ in $\mathcal{O}(\log M)$ time per query.

#### Snippet Workflow

1. **Build (`cp-pst-init`)**:
   ```cpp
   Compressor<ll> C(a);
   PersistentSegTree pst(C.size());
   pst.build(C.rnk);
   ```
2. **$k$-th Smallest in $a[l \dots r]$ (`cp-pst-kth`)**:
   ```cpp
   ll val = C.value(pst.kth(l, r, k));  // 0-based l, r; 1-based k
   ```
3. **Count Elements $\le x$ in $a[l \dots r]$ (`cp-pst-leq`)**:
   ```cpp
   int cnt = pst.count_leq(l, r, C.rank_leq(x));
   ```
4. **Count Elements in Range $[lo, hi]$ in $a[l \dots r]$ (`cp-pst-count`)**:
   ```cpp
   int cnt = pst.count_range(l, r, C.rank_geq(lo), C.rank_leq(hi));
   ```
5. **Count Elements $> k$ (K-Query Online)**:
   ```cpp
   int ans = (r - l + 1) - pst.count_leq(l, r, C.rank_leq(k));
   ```

---

### 3. Core Template & Fast I/O

Prefixes: `cp-template`, `cpplate`

- Fast standard I/O synchronization (`cin.tie(nullptr)`).
- 64-bit and 128-bit integer aliases (`ll`, `i128`).
- Standard competitive constants: `INF = 2e18`, `MOD = 1e9 + 7`, `MOD9 = 998244353`.
- Multi-testcase harness (`click_clack_boom()`).
- Rich math utility macros: `isqrt`, `prefXor`, `xorRange`, `YES`/`NO`.

---

## Modular Snippets Catalog (200 Snippets across 23 Files)

### Module Breakdown

| Module File | Category | Snippets | Primary Algorithms & Data Structures |
| :--- | :--- | :---: | :--- |
| [`cp-templates.code-snippets`](./.vscode/cp-templates.code-snippets) | Templates & Prelude | **3** | Full contest template, competitive prelude/types, debug printer. |
| [`cp-techniques.code-snippets`](./.vscode/cp-techniques.code-snippets) | Techniques & Tricks | **9** | Coordinate compression (`Compressor`), 2D prefix sums, submask iteration, bit tricks. |
| [`cp-segtree.code-snippets`](./.vscode/cp-segtree.code-snippets) | Segment Trees (Basic) | **11** | Iterative SegTree (Monoid), point set/update, range queries, Li Chao Tree. |
| [`cp-lazy-segtree.code-snippets`](./.vscode/cp-lazy-segtree.code-snippets) | Lazy Segment Trees | **9** | Range Add/Set/Affine/Flip with Range Sum/Min/Max (ACL style). |
| [`cp-persistent-segtree.code-snippets`](./.vscode/cp-persistent-segtree.code-snippets) | Persistent SegTree | **15** | Standard PST, Lazy PST Flip (Hashing), Lazy PST Range Add & Sum (Rollbacks). |
| [`cp-merge-sort-tree.code-snippets`](./.vscode/cp-merge-sort-tree.code-snippets) | Merge Sort Trees | **19** | Static MST (order counts) & Point-Update Dynamic PBDS MST ($k$-th queries). |
| [`cp-dsu-fenwick.code-snippets`](./.vscode/cp-dsu-fenwick.code-snippets) | DSU & Fenwick Trees | **7** | DSU (Standard, Rollback, Potential), Fenwick (1D, Range-Add, 2D), PBDS. |
| [`cp-hash-linked-list.code-snippets`](./.vscode/cp-hash-linked-list.code-snippets) | Hash & Linked Lists | **6** | Separate Chaining, Anti-Hack custom hash, Singly/Doubly/Circular lists. |
| [`cp-stack-queue.code-snippets`](./.vscode/cp-stack-queue.code-snippets) | Stacks & Queues | **7** | Array/List stacks, Circular queues, Deque, Monotonic stacks, Shunting-Yard. |
| [`cp-advanced-trees.code-snippets`](./.vscode/cp-advanced-trees.code-snippets) | Trees & Heaps | **6** | BST, AVL Tree, Red-Black Tree, Binary Heap, Trie, Binary XOR Trie. |
| [`cp-graph-paths.code-snippets`](./.vscode/cp-graph-paths.code-snippets) | Graph Traversal & Paths | **9** | BFS, Dijkstra, 0-1 BFS, Bellman-Ford, Floyd-Warshall, Johnson, Topo Sort. |
| [`cp-graph-connectivity.code-snippets`](./.vscode/cp-graph-connectivity.code-snippets) | Graph Connectivity | **9** | Kruskal, Prim, Boruvka, Tarjan SCC, 2-SAT, Bridges, Kosaraju, BCC. |
| [`cp-graph-flows.code-snippets`](./.vscode/cp-graph-flows.code-snippets) | Flows & Matching | **3** | Dinic Max Flow & Min Cut, Min-Cost Max-Flow (SPFA), Hopcroft-Karp. |
| [`cp-graph-trees.code-snippets`](./.vscode/cp-graph-trees.code-snippets) | Tree Algorithms | **5** | Heavy-Light Decomposition (HLD), Centroid Decomposition, LCA, Euler Tour. |
| [`cp-math-number-theory.code-snippets`](./.vscode/cp-math-number-theory.code-snippets) | Number Theory | **12** | Sieves, Miller-Rabin, Pollard's Rho, BSGS, Tonelli-Shanks, Lucas, Floor Sum. |
| [`cp-math-combinatorics.code-snippets`](./.vscode/cp-math-combinatorics.code-snippets) | Combinatorics | **10** | Binomial coefficients, Catalan numbers, Permutations, Combinations table. |
| [`cp-math-algebra.code-snippets`](./.vscode/cp-math-algebra.code-snippets) | Algebra & Modulo | **7** | Modular integer (`mint`), Matrix exponentiation, Linear Systems, Linear Basis, CRT. |
| [`cp-math-polynomials.code-snippets`](./.vscode/cp-math-polynomials.code-snippets) | Polynomials & NTT | **5** | NTT, Polynomial Convolution, Inversion, Lagrange Interpolation, Bostan-Mori. |
| [`cp-searching-sorting.code-snippets`](./.vscode/cp-searching-sorting.code-snippets) | Search & Sorting | **15** | Predicate Binary Search (`first-true`), Ternary Search, Mo's Algorithm, Sorts. |
| [`cp-dp.code-snippets`](./.vscode/cp-dp.code-snippets) | Dynamic Programming | **12** | LIS, LCS, Knapsacks (0/1, Unbounded, Bitset), Digit DP, SOS DP, Bitmask TSP. |
| [`cp-strings.code-snippets`](./.vscode/cp-strings.code-snippets) | String Algorithms | **9** | KMP, Z-Algorithm, Manacher, Anti-Hack Rolling Hash, Suffix Array + LCP. |
| [`cp-geometry.code-snippets`](./.vscode/cp-geometry.code-snippets) | Geometry | **8** | Points & Vectors, Monotone Chain Convex Hull, Graham Scan, Polygon Area. |
| [`cp-backtracking.code-snippets`](./.vscode/cp-backtracking.code-snippets) | Backtracking | **4** | N-Queens, Knight's Tour, Graph $m$-Coloring, Combinations generator. |
| **Total** | | **200** | **All files under 500 lines** |

---

### Detailed Catalog by Category

<details>
<summary><b>1. Templates & Core Prelude (3 snippets)</b></summary>

- `cp-template`, `cpplate`: Full contest boilerplate with fast I/O, multi-testcase loop, and standard aliases.
- `cp-common-types`, `cp-prelude`: Type shortcuts (`vll`, `pll`, `vpll`), directions arrays, bit helpers.
- `cp-debug`, `dbg`: Multi-variable inline debug printer for vectors, pairs, maps, and tuples.

</details>

<details>
<summary><b>2. Algorithmic Techniques (9 snippets)</b></summary>

- `cp-coordinate-compression`, `cp-compress`: $\mathcal{O}(1)$ array element rank lookup with dedicated binary search query methods.
- `cp-prefix-sums-2d`, `pref2d`: 2D prefix sums table with $\mathcal{O}(1)$ rectangle query.
- `cp-submask-iteration`, `submasks`: Efficient $\mathcal{O}(3^n)$ iteration through all submasks of all masks.
- `cp-meet-in-the-middle`: Split-and-search subset sum counter for $N \le 40$.
- `cp-custom-hash`, `safe-hash`: Anti-hack custom hash based on `splitmix64` for `unordered_map`/`unordered_set`.
- `cp-bit-tricks`, `cp-bit-ops`: Fast bit manipulation routines (LSB, popcount, power of two).
- `cp-subarray-count`: Count subarrays with target sum using frequency map.

</details>

<details>
<summary><b>3. Segment Trees & Range Queries (42 snippets)</b></summary>

- `cp-segtree`, `segtree`: Iterative Point-Update Range-Query Segment Tree.
- `cp-lazy-segtree`: AtCoder Library (ACL) style general Lazy Segment Tree with user-defined monoids and mappings.
- Specialized Lazy Trees: Range-Add Range-Sum, Range-Set Range-Sum, Range-Add Range-Min, Range-Add Range-Max.
- `cp-persistent-segtree`, `cp-pst`: Path-copying Persistent Segment Tree over values.
- `cp-pst-init`: 3-line compress and build using `Compressor`.
- `cp-pst-kth`: $k$-th smallest query in subarray $a[l \dots r]$ translated back to value.
- `cp-pst-leq`: Count elements $\le x$ in subarray $a[l \dots r]$.
- `cp-pst-count`: Count elements in value range $[lo, hi]$ in subarray $a[l \dots r]$.
- **Lazy Persistent Segment Tree (Range Flip / Hash)**:
  - `cp-lazy-pst-flip`, `cp-lazy-pst-binary`, `cp-lazy-pst`: Binary range flips with rolling string hash and $\mathcal{O}(\log n)$ lexicographical comparison (0-indexed).
  - `cp-lazy-pst-flip-init`: Instantiate binary LazyPersistentSegTree of length $n$.
  - `cp-lazy-pst-flip-update`: Invert range $[l, r]$ and create new version.
  - `cp-lazy-pst-flip-compare`: Lexicographically compare two tree versions in $\mathcal{O}(\log n)$.
  - `cp-lazy-pst-flip-print`: Print full bit sequence of a root version.
- **Persistent Lazy Segment Tree (Range Add, Range Sum)**:
  - `cp-lazy-pst-sum`, `cp-persistent-lazy-segtree`, `cp-pst-lazy`: Range Add and Range Sum with historical queries without allocation, and version rollbacks (0-indexed).
  - `cp-lazy-pst-sum-init`: Instantiate PersistentLazySegTree of length $n$ with initial array $a$.
  - `cp-lazy-pst-sum-update`: Add $d$ to range $[l, r]$ on latest version and push new root.
  - `cp-lazy-pst-sum-query`: Query range sum of $[l, r]$ on historical version `ver`.
  - `cp-lazy-pst-sum-rollback`: Roll back to a previous version `ver`.
- **Merge Sort Tree (Range Order Queries - Static)**:
  - `cp-merge-sort-tree`, `cp-mst`: Merge Sort Tree for static range order queries in $\mathcal{O}(\log^2 n)$ (0-indexed, lean struct with generic lambda query).
  - `cp-mst-init`: Instantiate MergeSortTree over vector `a`.
  - `cp-mst-leq`: Count elements $\le x$ in range $[l, r]$ (`upper_bound`).
  - `cp-mst-lt`: Count elements $< x$ in range $[l, r]$ (`lower_bound`).
  - `cp-mst-geq`: Count elements $\ge x$ in range $[l, r]$ (`end - lower_bound`).
  - `cp-mst-gt`: Count elements $> x$ in range $[l, r]$ (`end - upper_bound`).
  - `cp-mst-range`: Count elements in value range $[x, y]$ within range $[l, r]$.
  - `cp-mst-query`: Custom canonical segment query lambda over range $[l, r]$.
  - `cp-mst-helpers`, `cp-mst-utils`: Standalone helper functions (`count_leq`, `count_lt`, `count_geq`, `count_gt`, `count_range`).
- **Point Update Merge Sort Tree (Dynamic PBDS MST)**:
  - `cp-point-update-mst`, `cp-pmst`: Point-update Merge Sort Tree via PBDS ordered set of pairs with duplicate handling (0-indexed).
  - `cp-pmst-init`: Instantiate PointUpdateMergeSortTree over vector `a`.
  - `cp-pmst-update`: Point update $a[idx] = new\_val$ in $\mathcal{O}(\log^2 n)$.
  - `cp-pmst-leq`: Count elements $\le x$ in range $[l, r]$ in $\mathcal{O}(\log^2 n)$.
  - `cp-pmst-lt`: Count elements $< x$ in range $[l, r]$ in $\mathcal{O}(\log^2 n)$.
  - `cp-pmst-geq`: Count elements $\ge x$ in range $[l, r]$ in $\mathcal{O}(\log^2 n)$.
  - `cp-pmst-gt`: Count elements $> x$ in range $[l, r]$ in $\mathcal{O}(\log^2 n)$.
  - `cp-pmst-range`: Count elements in value range $[x, y]$ within range $[l, r]$ in $\mathcal{O}(\log^2 n)$.
  - `cp-pmst-kth`: Range $k$-th smallest element query via binary search on answer in $\mathcal{O}(\log^3 n)$.
  - `cp-pmst-helpers`, `cp-pmst-utils`: Standalone helper functions (`count_leq`, `count_lt`, `count_geq`, `count_gt`, `count_range`, `kth`).
- `cp-lichao-tree`: Li Chao Segment Tree for dynamic line insertions and minimum/maximum evaluation at $x$.

</details>

<details>
<summary><b>4. Data Structures (26 snippets)</b></summary>

- **Disjoint Set Union**:
  - `cp-dsu`: Standard DSU with path compression and union-by-rank/size.
  - `cp-rollback-dsu`: Stack-based undoable DSU for offline dynamic connectivity.
  - `cp-potential-dsu`: Weighted DSU tracking value differences across components.
- **Fenwick Trees (Binary Indexed Trees)**:
  - `cp-fenwick`, `bit`: Standard 1D point-update range-sum Fenwick tree.
  - `cp-range-fenwick`: Range-update range-query Fenwick tree via two linear BITs.
  - `cp-fenwick-2d`: 2D Fenwick tree for 2D point update and rectangle sum.
- **Trees & Policy-Based Structures**:
  - `cp-pbds`: GNU Policy-Based Ordered Set (`find_by_order`, `order_of_key`).
  - `cp-trie`: String Trie with frequency counting and prefix search.
  - `cp-xor-trie`: Binary Trie for maximum/minimum XOR pair queries.
  - BST, AVL Tree, Red-Black Tree, Min/Max Binary Heap implementations.
- **Linear Buffers**: Circular Array Queue, Circular Array Deque, Singly / Doubly / Circular Linked Lists.

</details>

<details>
<summary><b>5. Graph Theory & Trees (26 snippets)</b></summary>

- **Shortest Paths**:
  - `cp-dijkstra`: Priority queue Dijkstra with path reconstruction.
  - `cp-01-bfs`: Double-ended queue BFS for graphs with $0/1$ edge weights.
  - `cp-spfa`, `bellman-ford`: Shortest Path Faster Algorithm with negative cycle detection.
  - `cp-floyd-warshall`: $\mathcal{O}(V^3)$ all-pairs shortest paths.
- **Network Flow & Matching**:
  - `cp-dinic`: $\mathcal{O}(V^2 E)$ Dinic's Maximum Flow and Minimum Cut.
  - `cp-mcmf`: Min-Cost Max-Flow using SPFA / potential-based augmentation.
  - `cp-hopcroft-karp`: $\mathcal{O}(E \sqrt{V})$ maximum cardinality bipartite matching.
- **Connectivity & Decompositions**:
  - `cp-tarjan-scc`: Iterative Tarjan strongly connected components solver.
  - `cp-2sat`: 2-Satisfiability solver with boolean variable assignment.
  - `cp-bridges-art`: Bridges and articulation points discovery in undirected graphs.
  - `cp-hld`: Heavy-Light Decomposition with path and subtree mappings.
  - `cp-lca`: Binary lifting Lowest Common Ancestor with distance queries.
  - `cp-centroid-decomp`: Centroid Decomposition for path queries on trees.
- **Spanning Trees**: Kruskal's with DSU, Prim's, Borůvka's algorithm.

</details>

<details>
<summary><b>6. Mathematics & Number Theory (34 snippets)</b></summary>

- **Modular Arithmetic**:
  - `cp-mint`: Full modular integer (`mint`) with auto-reduction, division, and inverse.
  - `cp-power-mod`: Fast binary modular exponentiation.
  - `cp-ext-gcd`: Extended Euclidean algorithm for modular inverse and Bézout coefficients.
- **Primes & Factorization**:
  - `cp-linear-sieve`: $\mathcal{O}(n)$ linear sieve computing SPF, Euler's Totient, and Möbius functions.
  - `cp-miller-rabin`: Deterministic 64-bit Miller-Rabin primality test.
  - `cp-pollard-rho`: $\mathcal{O}(n^{1/4})$ integer factorization algorithm.
  - `cp-segmented-sieve`: Range primes sieve $[L, R]$ where $R - L \le 10^7$.
- **Advanced Algebra & Polynomials**:
  - `cp-ntt`: Number Theoretic Transform under modulo 998244353.
  - `cp-matrix`: Matrix multiplication, exponentiation, and Gaussian elimination.
  - `cp-linear-basis`: XOR vector basis for subset XOR maximum/k-th queries.
  - `cp-crt`: Chinese Remainder Theorem solver.
  - `cp-baby-giant`: Baby-Step Giant-Step discrete logarithm solver.
  - `cp-tonelli-shanks`: Modular square root solver.
  - `cp-lucas`: Lucas' Theorem for binomial coefficients modulo small prime $p$.
  - Combinatorics table, Catalan numbers, Pascal DP, Floor Sum.

</details>

<details>
<summary><b>7. String Algorithms (9 snippets)</b></summary>

- `cp-kmp`: Knuth-Morris-Pratt prefix function ($\pi$) and pattern matching.
- `cp-z-algo`: Z-Algorithm for longest common prefix array.
- `cp-manacher`: Manacher's algorithm for finding all palindrome radii in $\mathcal{O}(n)$.
- `cp-rolling-hash`: Anti-hack polynomial rolling hash under Mersenne prime modulo $2^{61}-1$.
- `cp-aho-corasick`: Multi-pattern dictionary matching with failure transitions.
- `cp-suffix-array`: Suffix Array and Kasai LCP construction in $\mathcal{O}(n \log n)$.
- `cp-booth`: Booth's algorithm for finding the lexicographically smallest cyclic shift.
- `cp-lyndon`: Lyndon factorization via Duval's algorithm.

</details>

<details>
<summary><b>8. Computational Geometry (8 snippets)</b></summary>

- `cp-point-2d`: 2D point and vector struct with cross product, dot product, and orientation.
- `cp-convex-hull`: Andrew's Monotone Chain convex hull algorithm in $\mathcal{O}(n \log n)$.
- `cp-graham-scan`: Graham scan convex hull.
- `cp-polygon-area`: Shoelace formula for polygon area.
- `cp-point-in-polygon`: Ray casting algorithm for arbitrary polygon point location.
- `cp-segment-intersection`: Precise segment-segment intersection test.
- `cp-closest-pair`: Sweep-line $\mathcal{O}(n \log n)$ closest pair of 2D points.

</details>

<details>
<summary><b>9. Search & Sorting (15 snippets)</b></summary>

- `cp-binary-search`: Monotone predicate binary search (`first-true`).
- `cp-ternary-search`: Ternary search for unimodal function extrema.
- `cp-mos-algorithm`: Mo's algorithm with Hilbert curve / block sorting for offline range queries.
- Sorting implementations: Merge Sort, Quick Sort, Heap Sort, Counting Sort, Radix Sort, Bucket Sort.

</details>

<details>
<summary><b>10. Backtracking (4 snippets)</b></summary>

- `cp-nqueens`: $N$-Queens solver using bitmasks.
- `cp-knights-tour`: Warnsdorff's heuristic knight's tour.
- `cp-graph-coloring`: Backtracking $m$-coloring for small graphs.
- `cp-backtrack-comb`: Combinations and permutations generators.

</details>

---

## Developer Tools & Automation

### 1. Build & Run Helper (`tools/run.sh`)

[tools/run.sh](./mnt/c/Users/Gurjot%20Singh/Documents/Competitive%20Programming/tools/run.sh) provides automated compilation and execution with safety diagnostics or optimized release flags.

#### Syntax

```bash
tools/run.sh <source.cpp> [input_file] [mode: debug|fast]
```

#### Modes

| Mode | Flags | Purpose |
| :--- | :--- | :--- |
| `debug` *(default)* | `-std=c++17 -g -O1 -Wall -Wextra -Wno-unused-result -Wshadow -D_GLIBCXX_DEBUG -fsanitize=address,undefined` | Identifies out-of-bounds indexing, dangling pointers, integer overflow, and UB with line-level diagnostics. |
| `fast` | `-std=c++17 -O2 -Wall -Wextra -Wno-unused-result` | Emulates online judge execution for accurate runtime benchmarks. |

#### Input Redirection

- Reads from `input_file` if provided.
- Automatically reads from `input.txt` if present in the current directory.
- Falls back to interactive standard input (`stdin`).

#### Examples

```bash
# Debug mode with sanitizers (reads from input.txt if present)
tools/run.sh solution.cpp

# Fast mode for time benchmarking
tools/run.sh solution.cpp input.txt fast
```

---

### 2. Automated Differential Stress Tester (`tools/stress.sh`)

[tools/stress.sh](./mnt/c/Users/Gurjot%20Singh/Documents/Competitive%20Programming/tools/stress.sh) conducts differential testing between an optimized solution and a brute-force solution on randomized testcases.

#### Syntax

```bash
tools/stress.sh <sol.cpp> <brute.cpp> <gen.cpp> [iterations=500]
```

- `sol.cpp`: Optimized candidate solution (compiled with GCC sanitizers).
- `brute.cpp`: Reference brute-force solution.
- `gen.cpp`: Randomized test generator (accepts random seed as `argv[1]`).
- `iterations`: Number of randomized runs (defaults to `500`).

#### Failure Artifacts

Upon mismatch, crash, or timeout (5s for `sol`, 20s for `brute`):
1. Execution halts immediately with diff preview.
2. Artifacts are preserved in the current directory:
   - `failing_input.txt`: Exact input triggering the bug.
   - `failing_sol.txt`: Output from candidate solution.
   - `failing_brute.txt`: Expected output from brute-force solution.

---

## VS Code Integration & Settings

[.vscode/settings.json](./mnt/c/Users/Gurjot%20Singh/Documents/Competitive%20Programming/.vscode/settings.json) ensures instant snippet expansion:

```json
{
  "editor.snippetSuggestions": "top",
  "editor.suggest.showSnippets": true,
  "editor.tabCompletion": "on",
  "editor.acceptSuggestionOnEnter": "on",
  "[cpp]": {
    "editor.snippetSuggestions": "top",
    "editor.suggestSelection": "first"
  }
}
```

---

## Recommended Contest Workflow

1. **Initialize Problem**: Create `A.cpp`, type `cpplate` or `cp-template`, and hit `Tab`.
2. **Inject Data Structures**: Type snippet prefixes (e.g., `cp-coordinate-compression`, `cp-pst-init`, `dsu`, `cp-lazy-segtree`) and tab through placeholders.
3. **Run Sample Tests**:
   ```bash
   tools/run.sh A.cpp
   ```
4. **Stress Test Edge Cases** (if WA on secret tests):
   ```bash
   tools/stress.sh A.cpp brute.cpp gen.cpp 1000
   ```

---

## Prerequisites & Setup

Install GCC, GDB, and core utilities on Linux or WSL:

```bash
sudo apt update
sudo apt install -y build-essential g++ gdb coreutils diffutils
chmod +x tools/*.sh
```
