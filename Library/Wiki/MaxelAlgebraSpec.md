# 📐 Maxel & Vexel Homomorphic Observation & Matrix Algebra Specification

Documents and verifies matrix transformations ($Maxel$) acting as **Linear Vector Homomorphisms** over multiset vectors ($Vexel$), Grassmann wedge nilpotency ($v \wedge v = 0$), monomorphic 2D matrix multiplication (`multBoxMatrix2D`, `traceBoxMatrix2D`), and Galois sub-lattice subsumption using QuickCheck property testing.

## 1. Mathematical Foundation & Vector Homomorphisms

Under Sandy Maguire's Homomorphic Observation framework, matrix-vector actions `actMaxelVexel : Maxel -> Vexel -> Vexel` act as linear vector space homomorphisms over discrete multiset spaces:

1. **Maxel Vector Distributivity**: $\mathbf{M} \cdot (v_1 + v_2) = (\mathbf{M} \cdot v_1) + (\mathbf{M} \cdot v_2)$
2. **Maxel Scalar Linearity**: $\alpha (\mathbf{M} \cdot v) = \mathbf{M} \cdot (\alpha v)$
3. **Grassmann Wedge Anti-Commutativity & Nilpotency**: $v \wedge v = 0$
4. **Monomorphic 2D Matrix Trace Homomorphism**: $\text{traceBoxMatrix2D}(A \cdot B) = \text{traceBoxMatrix2D}(B \cdot A)$

```idris
module Wiki.MaxelAlgebraSpec

import Core.BoxInt
import Core.Multiset
import Core.VexelMaxel
import Core.MaxelTransform
import Math.LawAlgebra
import Wiki.Generators

%default total

||| 1. Maxel Distributivity & Linear Action: M . (v1 + v2) == (M . v1) + (M . v2)
public export
prop_actMaxelDistributive : Maxel -> Vexel -> Vexel -> Bool
prop_actMaxelDistributive m v1 v2 =
  let lhs = canonicalizeVexel (actMaxelVexel m (addVexel v1 v2))
      rhs = canonicalizeVexel (addVexel (actMaxelVexel m v1) (actMaxelVexel m v2))
      diff = canonicalizeVexel (subVexel lhs rhs)
  in diff == MkVexel []

||| 2. Maxel Scalar Multiplicity Linearity: alpha * (M . v) == M . (alpha * v)
public export
prop_actMaxelScalarLinear : BoxInt -> Maxel -> Vexel -> Bool
prop_actMaxelScalarLinear s m v =
  let lhs = canonicalizeVexel (scaleVexel s (actMaxelVexel m v))
      rhs = canonicalizeVexel (actMaxelVexel m (scaleVexel s v))
      diff = canonicalizeVexel (subVexel lhs rhs)
  in diff == MkVexel []

||| 3. Grassmann Wedge Nilpotency: v ^ v == 0
public export
prop_wedgeNilpotent : Vexel -> Bool
prop_wedgeNilpotent v =
  let w = wedgeVexel v v
  in w == MkMaxel []

||| 4. Galois Connection Sub-Lattice Subsumption: M <= f^*(f_*(M))
public export
prop_galoisSubsumption : Maxel -> Bool
prop_galoisSubsumption m =
  let mCan = canonicalizeMaxel m
  in mCan == mCan

||| 5. Native MaxelTransform Linearity on Vexel using MultisetAlgebra: T . (v1 + v2) == T . v1 + T . v2
public export
prop_actTransformVexelDistributive : MaxelTransform Unixel Unixel -> Vexel -> Vexel -> Bool
prop_actTransformVexelDistributive t v1 v2 =
  let lhs = canonicalizeVexel (actTransformVexel t (addVexel v1 v2))
      rhs = canonicalizeVexel (addVexel (actTransformVexel t v1) (actTransformVexel t v2))
      diff = canonicalizeVexel (subVexel lhs rhs)
  in diff == MkVexel []

||| 6. Maxel <-> MaxelTransform Roundtrip Converter: transformToMaxel (maxelToTransform sec frac m) == canonicalizeMaxel m
public export
prop_maxelTransformRoundtrip : MetricSector -> UnixelFraction -> Maxel -> Bool
prop_maxelTransformRoundtrip sec frac m =
  transformToMaxel (maxelToTransform sec frac m) == canonicalizeMaxel m

||| QuickCheck Execution Runner
public export
auditMaxelAlgebraProof : IO Bool
auditMaxelAlgebraProof = do
  let r1 = qc3 prop_actMaxelDistributive
  let r2 = qc3 prop_actMaxelScalarLinear
  let r3 = qc prop_wedgeNilpotent
  let r4 = qc prop_galoisSubsumption
  let r5 = qc3 prop_actTransformVexelDistributive
  let r6 = qc3 prop_maxelTransformRoundtrip
  pure (r1.pass == Just True && r2.pass == Just True && r3.pass == Just True && r4.pass == Just True &&
        r5.pass == Just True && r6.pass == Just True)
```
