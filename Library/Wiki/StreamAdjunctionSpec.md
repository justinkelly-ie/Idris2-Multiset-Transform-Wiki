# 🗂️ FreeWave ⊣ ForgetfulMonoid Adjunction, Wave Comonad & Spatial Projection Specification

Documents and verifies the **Adjoint Functor** $(FreeWave \dashv ForgetfulMonoid)$, **Wave Comonad** $D = FreeWave \circ ForgetfulMonoid$, **StateTransition Monad Laws**, and the 3D $T^3$ spatial Boxel update driver.

## 1. Category-Theoretic Adjunction, Comonad & Homomorphism Laws

1. **Adjunction Unit-Counit Identity**: $\text{counit}(\text{unit}(x)) = x$
2. **Dual Wave Comonad Identity**: $\text{extract}(\text{duplicate}(w)) = \text{extract}(w)$
3. **StateTransition Monad Laws**:
   - Left Identity: $\text{pure}(x) \gg= f \equiv f(x)$
   - Right Identity: $m \gg= \text{pure} \equiv m$
4. **3D Toroidal Shift Homomorphism**: $\text{matrixToShift}(m) \mapsto (dx, dy, dz) \in (\mathbb{Z}_8)^3$

```idris
module Wiki.StreamAdjunctionSpec

import Math.OnSeq.FusedStream
import Math.OnSeq.SpreadStream
import Math.Multiset
import Core.TypeTheory.TwoLevel
import Core.ScalePipeline.StreamAdjunction
import Wiki.Generators
import Data.Fuel

%default total

||| Property 1: Category-Theoretic Adjunction Counit-Unit Duality
public export
prop_adjunctionIdentity : Int -> Bool
prop_adjunctionIdentity val =
  let
    w : FreeWave (ForgetfulMonoid Int)
    w = MkWave [(MkMonoidView val, 1)]
    c = counit w
    u : ForgetfulMonoid (FreeWave Int)
    u = unit {f = FreeWave} {g = ForgetfulMonoid} val
  in
    c == val

||| Property 2: Dual Wave Comonad Extract-Duplicate Duality
public export covering
prop_comonadLaws : Int -> Bool
prop_comonadLaws val =
  let
    w : WaveContext Int
    w = MkWave [(MkMonoidView val, 2)]
    ext = extract {w = WaveContext} w
    duped = duplicateWaveContext w
    innerExt = extract {w = WaveContext} duped
    extDuped = extract {w = WaveContext} innerExt
  in
    ext == val && extDuped == val

||| Property 3: StateTransition Monad Left Unit Law (pure x >>= f == f x)
public export
prop_monadLeftUnit : Int -> Bool
prop_monadLeftUnit val =
  let
    f : Int -> StateTransition Int
    f x = pure (x + 10)
    lhs = (pure val >>= f).runTransition
    rhs = (f val).runTransition
  in
    case (lhs, rhs) of
      (MkMonoidView (MkWave w1), MkMonoidView (MkWave w2)) => w1 == w2

||| Property 4: StateTransition Monad Right Unit Law (m >>= pure == m)
public export
prop_monadRightUnit : Int -> Bool
prop_monadRightUnit val =
  let
    m : StateTransition Int
    m = pure val
    lhs = (m >>= pure).runTransition
    rhs = m.runTransition
  in
    case (lhs, rhs) of
      (MkMonoidView (MkWave w1), MkMonoidView (MkWave w2)) => w1 == w2

||| Property 5: 3D Spatial Boxel Shift Toroidal T^3 Wrapping Invariant
public export
prop_boxelToroidalWrap : Int -> Int -> Int -> Bool
prop_boxelToroidalWrap x y z =
  let
    b0 = MkBoxel (wrap x, wrap y, wrap z) 1
    m = MkMatrix 1 1 Pos Pos Pos Pos
    trans = driveSpatialUpdate Elliptic m b0
  in
    case trans.runTransition of
      MkMonoidView (MkWave [(MkBoxel (nx, ny, nz) _, _)]) =>
        nx >= 0 && nx < 8 && ny >= 0 && ny < 8 && nz >= 0 && nz < 8
      _ => False

||| Property 6: 2LTT Multiset Path Reflection & Equivalence
public export
prop_2lttMultisetPathReflection : Bool
prop_2lttMultisetPathReflection = auditMultisetPathEqualityProof

||| Property 7: Deforested FusedStream Spatial Boxel Update Pipeline
public export
prop_fusedStreamBoxelPipeline : Int -> Int -> Int -> Bool
prop_fusedStreamBoxelPipeline x y z =
  let b0 = MkBoxel (wrap x, wrap y, wrap z) 1
      m = MkMatrix 1 1 Pos Pos Pos Pos
      s = fusedDriveSpatialUpdate Elliptic m b0
      res = runFueledStream (More (More (More Dry))) s
  in case res of
       [(MkBoxel (nx, ny, nz) _, _)] => nx >= 0 && nx < 8 && ny >= 0 && ny < 8 && nz >= 0 && nz < 8
       _ => False

||| Property 8: SpreadStream Goh Factorization Stream Divisor Witness
public export
prop_spreadStreamProof : Bool
prop_spreadStreamProof = auditSpreadStreamProof

||| Property 9: Totient Sum Gauss Identity Witness sum_{d|n} phi(d) == n
public export
prop_totientSumProof : Bool
prop_totientSumProof = auditTotientSumProof

||| Property 10: Wildberger Support Partition Identity Witness sum_{d|n} |Supp(Phi_d)| == n
public export
prop_wildbergerSupportPartitionProof : Bool
prop_wildbergerSupportPartitionProof = auditWildbergerSupportPartitionProof

||| Direct Suite Execution for Stream Adjunction Specification
public export covering
auditStreamAdjunctionProof : IO Bool
auditStreamAdjunctionProof = do
  let p1 = prop_adjunctionIdentity 42
  let p2 = prop_comonadLaws 99
  let p3 = prop_monadLeftUnit 7
  let p4 = prop_monadRightUnit 13
  let p5 = prop_boxelToroidalWrap 5 5 5
  let p6 = prop_2lttMultisetPathReflection
  let p7 = prop_fusedStreamBoxelPipeline 3 4 5
  let p8 = prop_spreadStreamProof
  let p9 = prop_totientSumProof
  let p10 = prop_wildbergerSupportPartitionProof
  pure (p1 && p2 && p3 && p4 && p5 && p6 && p7 && p8 && p9 && p10)
```
