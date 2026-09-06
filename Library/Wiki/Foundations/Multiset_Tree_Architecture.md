# 🗃️ Multiset Tree Architecture & Galois Law Algebra

**Formal Specification of $O(\log N)$ Multiset Search Trees, Reflected Polynumbers, UnixelFractions, and Galois Connections ($f_* \dashv f^*$).**

---

## 🏛️ Overview

`Idris2-Multiset2` formalizes next-generation constructivist data structures:

1. **Balanced Binary Multiset Search Trees (`MultisetTree a`)**:
   Provides $O(\log N)$ lookup, insertion, and token multiplicity sum preservation, replacing linear association lists for large-scale token operations.
2. **Reflected Polynumber Multisets (`Polynumber`)**:
   Nested monomial terms $c \cdot x^k$, Goh factorization, cyclotomic division ($\Phi_{137}$), and Wildberger Multiple-Spread recurrence polynomials $S_n(s)$.
3. **Rational UnixelFractions (`UnixelFraction`)**:
   Exact rational numbers $Q = N / [D]$ with cross-multiplication equivalence (`rationalEquiv`), continued fraction convergents, and Stern-Brocot pathfinding.
4. **Pure Algebraic Galois Connection ($f_* \dashv f^*$)**:
   Adjunction between multiset pushforward ($f_*$) and pullback ($f^*$) over finite microstate lattices.

---

## 🛠️ Module Catalog

| Module | Description |
|---|---|
| [`Core.Multiset`](../../Idris2-Multiset2/src/Core/Multiset.idr) | Fundamental `Box` multiset containers, BoxSpec Dyck walks, and Young integer partitions. |
| [`Core.MultisetTree`](../../Idris2-Multiset2/src/Core/MultisetTree.idr) | $O(\log N)$ balanced multiset trees and `TreeUniverseState`. |
| [`Core.Polynumber`](../../Idris2-Multiset2/src/Core/Polynumber.idr) | Polynumber Cauchy product, cyclotomic division, and Caret operation ($\wedge$). |
| [`Core.UnixelFraction`](../../Idris2-Multiset2/src/Core/UnixelFraction.idr) | Rational `UnixelFraction`, Stern-Brocot pathfinding, and Hehner scale conversions. |
| [`Core.VexelMaxel`](../../Idris2-Multiset2/src/Core/VexelMaxel.idr) | Multiset tensor hierarchy (`Unixel`, `Pixel`, `Voxel`, `Vexel`, `Maxel`, `Boxel`, `HyperBoxel`). |
| [`Math.LawAlgebra`](../../Idris2-Multiset2/src/Math/LawAlgebra.idr) | Monoid $(\wedge, \otimes)$, multiset pushforward ($f_*$), pullback ($f^*$), and Galois Connections. |
