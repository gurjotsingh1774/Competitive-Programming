# Competitive Programming Toolkit & C++ Library

A high-performance, battle-tested competitive programming workspace featuring an extensive C++ snippet library (140+ algorithms & data structures), automated compilation scripts with strict sanitizer enforcement, differential stress testing tooling, and optimized VS Code configuration.

---

## Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Developer Tools & Automation](#developer-tools--automation)
  - [1. Compilation & Run Helper (`tools/run.sh`)](#1-compilation--run-helper-toolsrunsh)
  - [2. Automated Stress Testing (`tools/stress.sh`)](#2-automated-stress-testing-toolsstresssh)
- [C++ Snippets Library (`.vscode/cp.code-snippets`)](#c-snippets-library-vscodepcode-snippets)
  - [Snippet Catalog](#snippet-catalog)
  - [VS Code Integration & Settings](#vs-code-integration--settings)
- [Recommended Workflow](#recommended-workflow)
- [Prerequisites & Setup](#prerequisites--setup)

---

## Overview

This repository is optimized for speed, safety, and reliability during contests across platforms like **Codeforces**, **AtCoder**, **CSES**, and **CodeChef**:

- **Safety-First Local Execution**: Catches segmentation faults, out-of-bounds accesses, and undefined behavior locally via GCC Sanitizers (`-fsanitize=address,undefined`) and `_GLIBCXX_DEBUG`.
- **Differential Stress Testing**: Automated verification of candidate solutions against slow, brute-force solutions on randomized testcases.
- **Fast Code Expansion**: 149 pre-configured VS Code snippets covering standard templates, data structures, graph theory, dynamic programming, number theory, and string algorithms.

---

## Repository Structure

```text
.
├── .vscode/
│   ├── cp.code-snippets     # 149+ C++ snippets covering core algorithms & data structures
│   └── settings.json        # Editor tuning for top-priority snippet auto-completion
├── tools/
│   ├── run.sh               # Build & run runner (debug mode with sanitizers or fast O2 release)
│   └── stress.sh            # Automated differential stress-testing utility
└── README.md                # Project documentation
```

---

## Developer Tools & Automation

### 1. Compilation & Run Helper (`tools/run.sh`)

[tools/run.sh](file:///mnt/c/Users/Gurjot%20Singh/Documents/Competitive%20Programming/tools/run.sh) handles the compilation and execution of C++ solution files with standard safety flags or optimized release flags.

#### Syntax

```bash
tools/run.sh <source.cpp> [input_file] [mode: debug|fast]
```

#### Compilation Modes

| Mode | Flags | Purpose |
| :--- | :--- | :--- |
| `debug` *(default)* | `-std=c++17 -g -O1 -Wall -Wextra -Wno-unused-result -Wshadow -D_GLIBCXX_DEBUG -fsanitize=address,undefined` | Identifies out-of-bounds indexing, null/dangling pointers, integer overflows, and UB with line-level diagnostics. |
| `fast` | `-std=c++17 -O2 -Wall -Wextra -Wno-unused-result` | Emulates the online judge execution environment for accurate time/memory benchmarking. |

#### Input Redirection

- If an `input_file` is explicitly passed (e.g. `in.txt`), input is piped from that file.
- If no input file is specified but `input.txt` exists in the current directory, it will automatically read from `input.txt`.
- Otherwise, it waits for interactive standard input (`stdin`).

#### Examples

```bash
# Debug mode with sanitizers (reads from input.txt if present)
tools/run.sh solution.cpp

# Debug mode with a custom test file
tools/run.sh solution.cpp custom_test.txt

# Fast -O2 mode for performance and runtime benchmarks
tools/run.sh solution.cpp input.txt fast
```

---

### 2. Automated Stress Testing (`tools/stress.sh`)

[tools/stress.sh](file:///mnt/c/Users/Gurjot%20Singh/Documents/Competitive%20Programming/tools/stress.sh) conducts differential testing between an optimized candidate solution and an obviously correct brute-force solution using a randomized generator.

#### Syntax

```bash
tools/stress.sh <sol.cpp> <brute.cpp> <gen.cpp> [iterations=500]
```

- `sol.cpp`: The candidate solution (compiled with AddressSanitizer and UndefinedBehaviorSanitizer).
- `brute.cpp`: The reference/brute-force implementation.
- `gen.cpp`: The test generator (accepts a random seed as `argv[1]` and writes the test to `stdout`).
- `iterations`: Number of randomized testcases to execute (defaults to `500`).

#### Failure Handling & Artifacts

If a runtime error, timeout (5s for `sol`, 20s for `brute`), or output mismatch occurs:
1. The script immediately halts execution.
2. The failing seed and diff preview are printed to the terminal.
3. The following artifact files are automatically saved in the working directory for debugging:
   - `failing_input.txt`: The exact input that triggered the bug.
   - `failing_sol.txt`: Output produced by the candidate solution.
   - `failing_brute.txt`: Expected output produced by the brute-force solution.

#### Example

```bash
tools/stress.sh sol.cpp brute.cpp gen.cpp 1000
```

---

## C++ Snippets Library (`.vscode/cp.code-snippets`)

The snippet file contains 149 production-grade implementations designed for competitive programming.

### Key Prefixes

| Shortcut Prefix | Name | Description |
| :--- | :--- | :--- |
| `cp-template`, `cpplate` | CP Boilerplate | Complete template with fast I/O, modular arithmetic constants, type aliases, and multi-testcase loop. |
| `cp-dsu`, `dsu` | Disjoint Set Union | Standard Disjoint Set Union with path compression and union-by-rank/size. |
| `cp-rollback-dsu` | Rollback DSU | Undoable DSU supporting stack-based snapshot rollbacks. |
| `cp-potential-dsu` | Potential DSU | Weighted DSU maintaining potential differences between elements. |
| `cp-fenwick`, `bit` | Fenwick Tree | Binary Indexed Tree supporting point updates and range sum queries. |
| `cp-lazy-segtree` | Lazy Segment Tree | AtCoder Library (ACL) style iterative/recursive lazy segment tree for range updates and range queries. |
| `cp-dijkstra` | Dijkstra’s Algorithm | Single-source shortest path with priority queue and path reconstruction. |
| `cp-dinic` | Dinic’s Algorithm | $O(V^2 E)$ Maximum Network Flow and Minimum Cut solver. |
| `cp-hld` | Heavy-Light Decomposition | Tree path queries and subtree updates mapped to segment trees. |
| `cp-miller-rabin` | Miller-Rabin Primality | Deterministic 64-bit Miller-Rabin primality test. |
| `cp-pollard-rho` | Pollard’s Rho | $O(n^{1/4})$ integer factorization algorithm. |
| `cp-ntt` | Number Theoretic Transform | Fast polynomial multiplication under modulo 998244353. |
| `cp-rolling-hash` | Rolling Hash ($2^{61}-1$) | Anti-hack rolling hash with Mersenne prime modulo $2^{61}-1$. |
| `cp-aho-corasick` | Aho-Corasick Automaton | Multi-pattern string searching automaton with failure links and dictionary links. |
| `cp-convex-hull` | Convex Hull | Andrew’s Monotone Chain convex hull algorithm in $O(n \log n)$. |

### Snippet Catalog

<details>
<summary><b>1. Core Template & General Utilities</b></summary>

- `CP Boilerplate` (`cp-template`, `cp-boilerplate`, `cpplate`)
- `Common Types & Prelude` (`cp-common-types`, `cp-prelude`)
- `Anti-Hack Custom Hash` (`custom-hash`, `safe-hash`)
- `Bitwise Arithmetic Utilities` (`cp-bit-tricks`, `bit-ops`)
- `All Submask Iteration` (`cp-submask-iteration`, `submasks`)
- `Coordinate Compression` (`cp-coordinate-compression`, `compress`)
- `2D Prefix Sums` (`cp-prefix-sums-2d`, `pref2d`)
- `Subarray Count Technique` (Prefix Frequency Hashing)

</details>

<details>
<summary><b>2. Data Structures</b></summary>

- **DSU Variants**: Standard DSU, Rollback (Undoable) DSU, Potential (Weighted) DSU.
- **Fenwick Trees (BIT)**: Standard 1D BIT, Range-Add Range-Sum BIT, 2D Fenwick Tree.
- **Segment Trees**: Iterative Segment Tree, Lazy Segment Tree (ACL style), Persistent Segment Tree, Li Chao Tree.
- **Trees & Sets**: Policy-Based Ordered Set (`__gnu_pbds::tree`), Binary Search Tree (BST), AVL Tree, Red-Black Tree, Binary Heap (Min/Max).
- **Tries**: Standard String Trie, Binary XOR Trie.
- **Linear Structures**: Monotonic Stack, Circular Buffer Queue, Circular Array Deque, Singly / Doubly / Circular Linked Lists.
- **Hash Tables**: Custom Hash Table with Separate Chaining.

</details>

<details>
<summary><b>3. Graph Theory & Trees</b></summary>

- **Shortest Paths**: Dijkstra (with path recovery), 0-1 BFS, Bellman-Ford (negative cycle detection), Floyd-Warshall, Johnson's Algorithm.
- **Connectivity & Components**: Iterative Tarjan SCC, Kosaraju SCC, 2-SAT Solver, Bridges & Articulation Points, Biconnected Components (BCC).
- **Flows & Matching**: Dinic’s Algorithm (Max Flow & Min Cut), Min-Cost Max-Flow (SPFA), Hopcroft-Karp (Bipartite Matching).
- **Minimum Spanning Tree**: Kruskal’s, Prim’s, Borůvka’s, Reverse-Delete.
- **Tree Algorithms**: Lowest Common Ancestor (Binary Lifting), Heavy-Light Decomposition (HLD), Centroid Decomposition, Euler Tour Intervals, Tree Diameter.
- **Traversals**: Unweighted BFS, 2D Grid BFS, Topological Sort (Kahn's), Bipartite 2-Coloring.

</details>

<details>
<summary><b>4. Dynamic Programming</b></summary>

- **Classic Sequences**: Longest Increasing Subsequence (LIS), Longest Common Subsequence (LCS), Edit Distance (Levenshtein), Kadane’s Maximum Subarray Sum.
- **Knapsack Variants**: 0/1 Bounded Knapsack, Unbounded Knapsack, Bitset Subset Sums.
- **Advanced DP**: Digit DP, Bitmask TSP, Sum Over Subsets (SOS DP / Yates’s Algorithm), Divide & Conquer DP Optimization, Matrix Chain Multiplication (MCM).

</details>

<details>
<summary><b>5. Mathematics & Number Theory</b></summary>

- **Modular Arithmetic**: Modular Integer (`mint`), Fast Exponentiation (`power_mod`), Extended Euclidean & Modular Inverse.
- **Primes & Factors**: Linear Sieve (SPF, Euler's Totient, Möbius, Divisors), Segmented Sieve, Deterministic 64-bit Miller-Rabin, Pollard’s Rho.
- **Equations & Modular Theorems**: Chinese Remainder Theorem (CRT), Linear Diophantine Solver, Baby-Step Giant-Step, Tonelli-Shanks Modular Sqrt, Primitive Root, Floor Sum.
- **Combinatorics**: Multiplicative Binomial Coefficients, Pascal DP, Catalan Numbers, Lucas' Theorem, Combinations/Permutations Generators.
- **Linear Algebra & Polynomials**: Matrix Operations & Gaussian Elimination, Linear XOR Basis, Number Theoretic Transform (NTT), Polynomial Convolution & Inversion, Bostan-Mori / Fiduccia Linear Recurrences, Lagrange Interpolation, Fast Doubling Fibonacci.

</details>

<details>
<summary><b>6. String Algorithms</b></summary>

- **Pattern Matching**: Z-Algorithm, Prefix Function (KMP), Aho-Corasick Automaton, Boyer-Moore-Horspool.
- **Palindromes & Hashes**: Manacher’s Algorithm, Rolling Hash modulo $2^{61}-1$.
- **Suffix Structures**: Suffix Array & Kasai LCP.
- **Factorization & Rotations**: Smallest Cyclic Shift (Booth’s algorithm), Lyndon Factorization (Duval’s algorithm).

</details>

<details>
<summary><b>7. Computational Geometry</b></summary>

- Integer Points & Vector Operations (dot product, cross product).
- Convex Hull: Andrew’s Monotone Chain, Graham Scan, Jarvis March.
- Polygon Operations: Shoelace Polygon Area, Point-in-Polygon (Ray Casting).
- Intersection: Segment Intersection & Collinearity.
- Closest Pair of Points (Sweep-line).

</details>

<details>
<summary><b>8. Search, Sort & Paradigms</b></summary>

- Binary Search on Monotone Predicates (`first-true`).
- Ternary Search & Fibonacci Search.
- Meet in the Middle (Subset Sums).
- Mo’s Algorithm (Offline Range Queries).
- Backtracking: N-Queens, Knight’s Tour, K-Knights, Graph $m$-Coloring.
- Sorting Implementations: Merge, Quick, Heap, Counting, Radix, Bucket, Insertion, Bubble, Selection.

</details>

---

### VS Code Integration & Settings

[.vscode/settings.json](file:///mnt/c/Users/Gurjot%20Singh/Documents/Competitive%20Programming/.vscode/settings.json) is pre-configured to ensure snippets trigger instantaneously:

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

## Recommended Workflow

### Step 1: Initialize Problem Solution

Create a new solution file (e.g., `A.cpp`), type `cpplate` or `cp-template`, and hit `Tab` to expand the full template.

### Step 2: Write Logic & Pull Snippets

Incorporate pre-built algorithms directly into your solution. For example, typing `dsu` or `cp-lazy-segtree` and pressing `Tab` injects a clean, parameterized implementation.

### Step 3: Local Verification

Run the solution against sample tests using [tools/run.sh](file:///mnt/c/Users/Gurjot%20Singh/Documents/Competitive%20Programming/tools/run.sh):

```bash
# Writes samples to input.txt
tools/run.sh A.cpp
```

### Step 4: Stress Testing (Optional)

If you suspect edge cases or are failing on a secret test:
1. Write a brute-force solution `brute.cpp`.
2. Write a random test generator `gen.cpp`.
3. Launch [tools/stress.sh](file:///mnt/c/Users/Gurjot%20Singh/Documents/Competitive%20Programming/tools/stress.sh):

```bash
tools/stress.sh A.cpp brute.cpp gen.cpp 1000
```

---

## Prerequisites & Setup

Ensure the following packages are installed on your Linux / WSL environment:

```bash
sudo apt update
sudo apt install -y build-essential g++ coreutils diffutils
```

Verify `tools/run.sh` and `tools/stress.sh` have execution permissions:

```bash
chmod +x tools/*.sh
```
