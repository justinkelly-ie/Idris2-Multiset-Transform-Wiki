# UniverseState & Law Algebra Monoid Specification

```idris
module Wiki.StatefulLawSpec

import Data.Vect
import Core.BoxInt
import Core.Multiset
import Core.UniverseState
import Math.LawAlgebra
import Wiki.Generators

%default total
```

## Stateful Law Monoid & Capacity Conservation

`UniverseState` and `CosmicMultiset` track system capacity across spatial lattices ($VM$), background ROM ($DE$), and historical ledgers ($DM$). Law Algebra forms a monoid under multiset union (`combineLaws`).

### 1. Vacuum State Capacity Invariant
$$\text{totalCapacity}(\text{seedVacuum}(vm, de, dm)) \equiv vm + de + dm$$

```idris
public export
prop_vacuumStateCapacity : Nat -> Nat -> Nat -> Bool
prop_vacuumStateCapacity vmRaw deRaw dmRaw =
  let vm = clampNat vmRaw 30
      de = clampNat deRaw 50
      dm = clampNat dmRaw 20
      vac = seedCosmicVacuum vm de dm
  in totalStateCapacity vac == vm + de + dm
```

### 2. Cosmic Multiset Budget Invariance
$$\text{totalCosmicMultisetBudget}(\text{stateToCosmicMultiset}(S)) \equiv vm + de + dm$$

```idris
public export
prop_cosmicMultisetBudgetInvariant : Nat -> Nat -> Nat -> Bool
prop_cosmicMultisetBudgetInvariant vmRaw deRaw dmRaw =
  let vm = clampNat vmRaw 30
      de = clampNat deRaw 50
      dm = clampNat dmRaw 20
      st = MkUniverseState {vmSize=vm} {deSize=de} {dmSize=dm}
            (replicate vm (intToBoxInt 1))
            (replicate de (intToBoxInt 1))
            (replicate dm (intToBoxInt 1))
      cMultiset = stateToCosmicMultiset st
  in totalCosmicMultisetBudget cMultiset == vm + de + dm
```

### 3. Law Monoid Composition Associativity
$$(M_1 \cup M_2) \cup M_3 \equiv M_1 \cup (M_2 \cup M_3)$$

```idris
public export
prop_lawMonoidAssociative : List (BoxInt, BoxInt) -> List (BoxInt, BoxInt) -> List (BoxInt, BoxInt) -> Bool
prop_lawMonoidAssociative l1 l2 l3 =
  let buildBox = foldl (\acc, (k, w) => insertBox k w acc) (MkBox [])
      m1 = buildBox l1
      m2 = buildBox l2
      m3 = buildBox l3
      lhs = combineLaws (combineLaws m1 m2) m3
      rhs = combineLaws m1 (combineLaws m2 m3)
      keys = map fst l1 ++ map fst l2 ++ map fst l3
  in all (\k => lookupBox k lhs == lookupBox k rhs) keys
```

### 4. Law Subsumption Reflexivity
$$\forall \text{keys}, \text{subsumesBox}(\text{keys}, M, M) \equiv \text{True}$$

```idris
public export
prop_lawSubsumptionReflexive : List BoxInt -> List (BoxInt, BoxInt) -> Bool
prop_lawSubsumptionReflexive keys pairs =
  let m = MkBox pairs
  in subsumesBox keys m m == True
```

## QuickCheck Execution Runner

```idris
public export
auditStatefulLawProof : IO Bool
auditStatefulLawProof = do
  let r1 = qc3 prop_vacuumStateCapacity
  let r2 = qc3 prop_cosmicMultisetBudgetInvariant
  let r3 = qc3 prop_lawMonoidAssociative
  let r4 = qc2 prop_lawSubsumptionReflexive
  pure (r1.pass == Just True && r2.pass == Just True && r3.pass == Just True && r4.pass == Just True)
```
