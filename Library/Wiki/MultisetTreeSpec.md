# Fast MultisetTree Invariants Specification

```idris
module Wiki.MultisetTreeSpec

import Core.BoxInt
import Core.Multiset
import Core.MultisetTree
import Wiki.Generators

%default total
```

## Homomorphic Tree Observation

`MultisetTree` provides $O(\log N)$ balanced search tree indexing over multiset elements and multiplicities. Under Homomorphic Observation, tree split, insertion, and merge operations strictly preserve total token multiplicities and lookup contracts.

### 1. Token Multiplicity Insertion & Lookup Invariant
$$\text{lookup}(k, \text{insert}(k, c, T)) \equiv \text{lookup}(k, T) + c$$

```idris
public export
prop_treeInsertLookup : BoxInt -> Nat -> BoxInt -> Bool
prop_treeInsertLookup k c target =
  let count = clampNat c 100
      t0 : MultisetTree BoxInt = Leaf
      t1 = insertTokenTree k count t0
  in if k == target
       then lookupTokenTree target t1 == count
       else lookupTokenTree target t1 == 0
```

### 2. Total Token Sum Additivity
$$\text{treeTokenSum}(\text{insert}(k, c, T)) \equiv \text{treeTokenSum}(T) + c$$

```idris
public export
prop_treeTokenSumAdditive : BoxInt -> Nat -> Bool
prop_treeTokenSumAdditive k c =
  let count = clampNat c 50
      t0 : MultisetTree BoxInt = Leaf
      t1 = insertTokenTree k count t0
  in treeTokenSum t1 == count
```

### 3. Tree Merge Multiplicity Conservation
$$\text{treeTokenSum}(T_1 \cup T_2) \equiv \text{treeTokenSum}(T_1) + \text{treeTokenSum}(T_2)$$

```idris
public export
prop_treeMergeConservesTokens : BoxInt -> Nat -> BoxInt -> Nat -> Bool
prop_treeMergeConservesTokens k1 c1 k2 c2 =
  let cnt1 = clampNat c1 50
      cnt2 = clampNat c2 50
      t1 = insertTokenTree k1 cnt1 (Leaf {a=BoxInt})
      t2 = insertTokenTree k2 cnt2 (Leaf {a=BoxInt})
      merged = mergeMultisetTrees t1 t2
  in treeTokenSum merged == treeTokenSum t1 + treeTokenSum t2
```

### 4. Distinct Element Count Sub-Additivity
$$\text{treeElementCount}(T_1 \cup T_2) \le \text{treeElementCount}(T_1) + \text{treeElementCount}(T_2)$$

```idris
public export
prop_treeMergeElementSubadditive : BoxInt -> Nat -> BoxInt -> Nat -> Bool
prop_treeMergeElementSubadditive k1 c1 k2 c2 =
  let cnt1 = clampNat c1 50
      cnt2 = clampNat c2 50
      t1 = insertTokenTree k1 cnt1 (Leaf {a=BoxInt})
      t2 = insertTokenTree k2 cnt2 (Leaf {a=BoxInt})
      merged = mergeMultisetTrees t1 t2
  in treeElementCount merged <= treeElementCount t1 + treeElementCount t2
```

## QuickCheck Execution Runner

```idris
public export
auditMultisetTreeProof : IO Bool
auditMultisetTreeProof = do
  let r1 = qc3 prop_treeInsertLookup
  let r2 = qc2 prop_treeTokenSumAdditive
  let r3 = qc4 prop_treeMergeConservesTokens
  let r4 = qc4 prop_treeMergeElementSubadditive
  pure (r1.pass == Just True && r2.pass == Just True && r3.pass == Just True && r4.pass == Just True)
```
