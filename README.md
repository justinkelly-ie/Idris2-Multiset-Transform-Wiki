# 📚 Idris2-Multiset2-Wiki

**Literate Documentation, Formal Specifications, and Verification Suite for [Idris2-Multiset2](../Idris2-Multiset2).**

[![Idris2](https://img.shields.io/badge/Idris2-Verified_Wiki-blue.svg)](https://github.com/idris-lang/Idris2)

---

## 📖 Introduction

`Idris2-Multiset2-Wiki` is the executable verification suite and literate knowledge base for `Idris2-Multiset2`.

### 🗺️ Quick Reference & Catalogs
* **[Multiset Tree Architecture](Library/Wiki/Foundations/Multiset_Tree_Architecture.md)** — Literate overview of $O(\log N)$ multiset trees, Polynumbers, UnixelFractions, and Galois Connections.

---

## 🛠️ Building & Verifying

```bash
# Build verification executable
toolbox run -c fedora-toolbox-44 /var/home/justin/.local/bin/idris2 --build Idris2-Multiset2-Wiki.ipkg

# Run verification suite
toolbox run -c fedora-toolbox-44 ./build/exec/multiset2-verify
```

---

© Justin Kelly. All rights reserved.
