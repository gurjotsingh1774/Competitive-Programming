# Guide: Persistent Lazy Segment Trees in Competitive Programming

This guide covers the two distinct variants of **Persistent Lazy Segment Trees**:
1. **Hashing / Binary Flip Version (`LazyPersistentSegTree`)**: Exemplified by **[CodeChef - SUBINVER (SubInversing)](https://www.codechef.com/problems/SUBINVER)**.
2. **Arithmetic Range Add / Range Sum Version (`PersistentLazySegTree`)**: Exemplified by **[SPOJ - TTMINUS / HDU 4348 (To the Moon)](https://www.spoj.com/problems/TTMINUS/)**.

---

## Quick Comparison

| Feature | 1. Binary Range Flip + Hashing (`cp-lazy-pst-flip`) | 2. Range Add + Range Sum (`cp-lazy-pst-sum`) |
| :--- | :--- | :--- |
| **Snippet Struct** | `LazyPersistentSegTree` | `PersistentLazySegTree` |
| **Data Managed** | Binary sequence (`0` / `1`) of length $N$ | 64-bit integer values (`long long`) |
| **Lazy Operation** | Invert/flip bits in range $[l, r]$ (`lazy ^= 1`) | Add constant $d$ to range $[l, r]$ (`lazy += d`) |
| **Primary Queries** | $\mathcal{O}(\log N)$ lexicographical comparison between any two versions | $\mathcal{O}(\log N)$ range sum at historical version $T$ without allocating nodes |
| **Key Invariant** | Rolling polynomial hash (`mint hash`) detects matching subtrees in $\mathcal{O}(1)$ | Push-down is performed on updates; queries maintain a running `carried_lazy` |
| **Classic Problem** | **CodeChef: SUBINVER** | **SPOJ: TTMINUS (To the Moon)** |

---

## 1. Hashing Version: CodeChef - SUBINVER (SubInversing)

* **Problem Link**: [https://www.codechef.com/problems/SUBINVER](https://www.codechef.com/problems/SUBINVER)
* **Snippet Prefix**: `cp-lazy-pst-flip`, `cp-lazy-pst-binary`, `cp-lazy-pst`

### Problem Summary
You are given a binary array of length $N$ initially filled with all `0`s. You are given $U$ operations, where the $i$-th operation inverts (flips `0` $\leftrightarrow$ `1`) all elements in a given range $[L_i, R_i]$.
Applying updates produces different versions of the binary string. You need to identify the **lexicographically maximum** binary string among the generated states and output it.

### Why Standard Methods Fail
* Generating and storing all states naively requires $\mathcal{O}(N \times U)$ space and time ($\approx 10^5 \times 10^5 = 10^{10}$ ops), causing TLE and MLE.
* Comparing two large binary numbers of length $10^5$ naively takes $\mathcal{O}(N)$ time.

### How `LazyPersistentSegTree` Solves It
1. **Path-Copying Persistence**: Each range flip creates a new root version in $\mathcal{O}(\log N)$ time and memory, reusing unchanged nodes.
2. **Rolling Polynomial Hashing**: Each node stores `mint hash` representing $\sum \text{bit}_i \times \text{BASE}^i$.
   - If `t[u].hash == t[v].hash`, the binary substrings in both versions are **identical** ($\mathcal{O}(1)$ check).
   - If they differ, we traverse down to the left child; if the left children match, the first difference must be in the right child. This finds the **first differing bit in $\mathcal{O}(\log N)$**, determining which version is lexicographically larger.

### Full Solution Using the Snippet (0-Indexed)

```cpp
#include <bits/stdc++.h>
using namespace std;

// 1. Include Modular Integer (mint)
struct mint {
    long long v = 0;
    static const int MOD = 1e9 + 7;
    mint(long long v_ = 0) : v(v_ % MOD) { if (v < 0) v += MOD; }
    mint power(long long p) const {
        mint res = 1, a = *this;
        while (p > 0) {
            if (p & 1) res = res * a;
            a = a * a;
            p >>= 1;
        }
        return res;
    }
    mint operator+(const mint &o) const { return mint(v + o.v); }
    mint operator-(const mint &o) const { return mint(v - o.v); }
    mint operator*(const mint &o) const { return mint(v * o.v); }
    bool operator==(const mint &o) const { return v == o.v; }
};

// 2. Include LazyPersistentSegTree (cp-lazy-pst-flip)
struct LazyPersistentSegTree {
    struct Node {
        int l = 0, r = 0;
        int lazy = 0;
        int bit = 0;
        mint hash = 0;
    };

    int n;
    vector<Node> t;
    vector<int> roots;
    vector<mint> pref_pow;
    const mint BASE = 37;

    LazyPersistentSegTree(int n_ = 1) : n(n_) {
        pref_pow.assign(n + 1, 0);
        for (int i = 1; i <= n; i++) pref_pow[i] = pref_pow[i - 1] + BASE.power(i - 1);
        t.reserve(300 * n);
        t.push_back(Node());
        roots.push_back(build(0, n - 1));
    }

    mint get_segment_full_hash(int lo, int hi) const {
        return pref_pow[hi + 1] - pref_pow[lo];
    }

    int clone(int u) {
        t.push_back(t[u]);
        return (int)t.size() - 1;
    }

    int push(int u, int lo, int hi, int flip = 0) {
        int cur = clone(u);
        t[cur].lazy ^= flip;
        if (t[cur].lazy) {
            t[cur].hash = get_segment_full_hash(lo, hi) - t[cur].hash;
            t[cur].bit ^= 1;
            if (lo != hi) {
                int lc = clone(t[cur].l);
                int rc = clone(t[cur].r);
                t[lc].lazy ^= 1;
                t[rc].lazy ^= 1;
                t[cur].l = lc;
                t[cur].r = rc;
            }
            t[cur].lazy = 0;
        }
        return cur;
    }

    int build(int lo, int hi) {
        int cur = (int)t.size();
        t.push_back(Node());
        if (lo == hi) return cur;
        int mid = (lo + hi) >> 1;
        int lc = build(lo, mid);
        int rc = build(mid + 1, hi);
        t[cur].l = lc;
        t[cur].r = rc;
        return cur;
    }

    int invert(int prev, int lo, int hi, int ql, int qr) {
        int cur = push(prev, lo, hi);
        if (lo > qr || hi < ql) return cur;
        if (ql <= lo && hi <= qr) return push(cur, lo, hi, 1);
        int mid = (lo + hi) >> 1;
        int lc = invert(t[cur].l, lo, mid, ql, qr);
        int rc = invert(t[cur].r, mid + 1, hi, ql, qr);
        t[cur].l = lc;
        t[cur].r = rc;
        t[cur].hash = t[lc].hash + t[rc].hash;
        return cur;
    }

    int compare(int u, int v, int lo, int hi) {
        u = push(u, lo, hi);
        v = push(v, lo, hi);
        if (t[u].hash == t[v].hash) return 0;
        if (lo == hi) {
            if (t[u].bit == t[v].bit) return 0;
            return (t[u].bit > t[v].bit) ? 1 : 2; // 1: u > v, 2: u < v
        }
        int mid = (lo + hi) >> 1;
        int cmp_left = compare(t[u].l, t[v].l, lo, mid);
        if (cmp_left != 0) return cmp_left;
        return compare(t[u].r, t[v].r, mid + 1, hi);
    }

    void update_range(int l, int r) {
        roots.push_back(invert(roots.back(), 0, n - 1, l, r));
    }

    int compare_versions(int u, int v) {
        return compare(roots[u], roots[v], 0, n - 1);
    }

    void print(int root_idx, int lo, int hi) {
        int cur = push(root_idx, lo, hi);
        if (lo == hi) {
            cout << t[cur].bit;
            return;
        }
        int mid = (lo + hi) >> 1;
        print(t[cur].l, lo, mid);
        print(t[cur].r, mid + 1, hi);
    }

    void print_version(int root_idx) {
        print(roots[root_idx], 0, n - 1);
    }
};

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);

    int n, u;
    if (!(cin >> n >> u)) return 0;

    LazyPersistentSegTree pst(n);
    int best_version = 0;

    for (int step = 1; step <= u; step++) {
        int l, r;
        cin >> l >> r;
        l--; r--; // Convert to 0-based
        pst.update_range(l, r); // Creates version 'step'

        // If current version is lexicographically larger than best_version, update
        if (pst.compare_versions(step, best_version) == 1) {
            best_version = step;
        }
    }

    // Output the maximum binary string found
    pst.print_version(best_version);
    cout << "\n";
    return 0;
}
```

---

## 2. Sum / Arithmetic Version: SPOJ - TTMINUS (To the Moon)

* **Problem Link**: [https://www.spoj.com/problems/TTMINUS/](https://www.spoj.com/problems/TTMINUS/)
* **Snippet Prefix**: `cp-lazy-pst-sum`, `cp-persistent-lazy-segtree`, `cp-pst-lazy`

### Problem Summary
You are given an array $A$ of size $N$ ($N \le 10^5$) and $M$ queries ($M \le 10^5$):
1. `C l r d`: Add $d$ to all elements in range $[l, r]$ and advance time by 1.
2. `Q l r`: Query the sum of elements in $[l, r]$ at the **current** time.
3. `H l r t`: Query the sum of elements in $[l, r]$ at a **historical** time $t$ ($t \le \text{current time}$).
4. `B t`: **Roll back** the system state to time $t$ (erasing all subsequent updates).

### Why Standard Lazy SegTree Fails
* Standard lazy segment trees modify and push tags in-place. Once an update occurs, previous states are irreversibly overwritten.
* Saving snapshots of normal segment trees requires $\mathcal{O}(N)$ memory per update ($\approx 10^5 \times 10^5$ integers $\rightarrow$ 40 GB RAM, causing MLE).

### How `PersistentLazySegTree` Solves It
1. **Immutable Historical Versions**: Every `modify(l, r, d)` creates a new root without altering earlier nodes.
2. **Carried Lazy Evaluation for Read Queries**: When querying a past version `query(roots[t], ...)`, lazy tags are **not** pushed down into memory (which would allocate new nodes and cause MLE). Instead, pending tags are accumulated on-the-fly via a parameter `carried_lazy`.
3. **$\mathcal{O}(1)$ Version Rollback**: Rolling back to time $t$ simply resizes the `roots` vector: `roots.resize(t + 1)`.

### Full Solution Using the Snippet (0-Indexed)

```cpp
#include <bits/stdc++.h>
using namespace std;
using ll = long long;

// Include PersistentLazySegTree (cp-lazy-pst-sum)
struct PersistentLazySegTree {
    struct Node {
        int l = 0, r = 0;
        ll sum = 0;
        ll lazy = 0;
    };

    int n;
    vector<Node> t;
    vector<int> roots;

    PersistentLazySegTree(int n_ = 1) : n(n_) {
        t.reserve(60 * n + 1000);
        t.push_back(Node());
        vector<ll> zeros(n, 0);
        roots.push_back(build(0, n - 1, zeros));
    }

    PersistentLazySegTree(int n_, const vector<ll>& a) : n(n_) {
        t.reserve(60 * n + 1000);
        t.push_back(Node());
        roots.push_back(build(0, n - 1, a));
    }

    int clone(int u) {
        t.push_back(t[u]);
        return (int)t.size() - 1;
    }

    void apply_tag(int cur, int lo, int hi, ll val) {
        t[cur].sum += (ll)(hi - lo + 1) * val;
        t[cur].lazy += val;
    }

    int push(int u, int lo, int hi) {
        int cur = clone(u);
        if (t[cur].lazy != 0 && lo != hi) {
            int mid = (lo + hi) >> 1;
            int lc = clone(t[cur].l);
            int rc = clone(t[cur].r);

            apply_tag(lc, lo, mid, t[cur].lazy);
            apply_tag(rc, mid + 1, hi, t[cur].lazy);

            t[cur].l = lc;
            t[cur].r = rc;
            t[cur].lazy = 0;
        }
        return cur;
    }

    int build(int lo, int hi, const vector<ll>& a) {
        int cur = (int)t.size();
        t.push_back(Node());
        if (lo == hi) {
            t[cur].sum = (lo < (int)a.size() ? a[lo] : 0);
            return cur;
        }
        int mid = (lo + hi) >> 1;
        int lc = build(lo, mid, a);
        int rc = build(mid + 1, hi, a);
        t[cur].l = lc;
        t[cur].r = rc;
        t[cur].sum = t[lc].sum + t[rc].sum;
        return cur;
    }

    int update_range(int prev, int lo, int hi, int ql, int qr, ll val) {
        int cur = push(prev, lo, hi);
        if (lo > qr || hi < ql) return cur;

        if (ql <= lo && hi <= qr) {
            apply_tag(cur, lo, hi, val);
            return cur;
        }

        int mid = (lo + hi) >> 1;
        int lc = update_range(t[cur].l, lo, mid, ql, qr, val);
        int rc = update_range(t[cur].r, mid + 1, hi, ql, qr, val);

        t[cur].l = lc;
        t[cur].r = rc;
        t[cur].sum = t[lc].sum + t[rc].sum;
        return cur;
    }

    // Query on version u without allocating new nodes in memory
    ll query(int u, int lo, int hi, int ql, int qr, ll carried_lazy = 0) const {
        if (!u || lo > qr || hi < ql) return 0;

        carried_lazy += t[u].lazy;
        if (ql <= lo && hi <= qr) {
            return t[u].sum + (ll)(hi - lo + 1) * (carried_lazy - t[u].lazy);
        }

        int mid = (lo + hi) >> 1;
        return query(t[u].l, lo, mid, ql, qr, carried_lazy) +
               query(t[u].r, mid + 1, hi, ql, qr, carried_lazy);
    }

    void modify(int l, int r, ll d) {
        roots.push_back(update_range(roots.back(), 0, n - 1, l, r, d));
    }

    ll query_version(int t_version, int l, int r) const {
        return query(roots[t_version], 0, n - 1, l, r);
    }

    void rollback(int t_version) {
        roots.resize(t_version + 1);
    }
};

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);

    int n, m;
    while (cin >> n >> m) {
        vector<ll> a(n);
        for (int i = 0; i < n; i++) cin >> a[i];

        PersistentLazySegTree tree(n, a);

        while (m--) {
            char type;
            cin >> type;
            if (type == 'C') {
                int l, r; ll d;
                cin >> l >> r >> d;
                l--; r--; // Convert to 0-based
                tree.modify(l, r, d);
            } else if (type == 'Q') {
                int l, r;
                cin >> l >> r;
                l--; r--;
                cout << tree.query_version((int)tree.roots.size() - 1, l, r) << "\n";
            } else if (type == 'H') {
                int l, r, t_req;
                cin >> l >> r >> t_req;
                l--; r--;
                cout << tree.query_version(t_req, l, r) << "\n";
            } else if (type == 'B') {
                int t_req;
                cin >> t_req;
                tree.rollback(t_req);
            }
        }
    }

    return 0;
}
```

---

## Summary of Triggers

| Snippet Prefix | Purpose | Use Case |
|---|---|---|
| `cp-lazy-pst-sum` | Struct definition | Range Add + Range Sum with historical queries & rollbacks |
| `cp-lazy-pst-sum-init` | Initialization | `PersistentLazySegTree tree(n, a);` |
| `cp-lazy-pst-sum-update` | Range update | `tree.modify(l, r, d);` |
| `cp-lazy-pst-sum-query` | Historical query | `tree.query_version(ver, l, r);` |
| `cp-lazy-pst-sum-rollback`| State rollback | `tree.rollback(ver);` |
| `cp-lazy-pst-flip` | Struct definition | Binary range flip + rolling hash + $\mathcal{O}(\log N)$ compare |
| `cp-lazy-pst-flip-init` | Initialization | `LazyPersistentSegTree pst(n);` |
| `cp-lazy-pst-flip-update` | Range flip | `pst.update_range(l, r);` |
| `cp-lazy-pst-flip-compare`| Compare | `pst.compare_versions(u, v);` |
| `cp-lazy-pst-flip-print` | Output | `pst.print_version(ver);` |
