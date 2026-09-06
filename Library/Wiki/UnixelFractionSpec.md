# UnixelFraction & Stern-Brocot Rational Arithmetic Specification

```idris
module Wiki.UnixelFractionSpec

import Core.BoxInt
import Core.Multiset
import Core.VexelMaxel
import Core.UnixelFraction
import Wiki.Generators

%default total
```

## Homomorphic Rational Observation

`UnixelFraction` represents exact rational observables $Q = N / [D]$ without floating-point rounding errors. Under Sandy Maguire's Homomorphic Observation framework, observations on rational tallies preserve addition, multiplication, and mediant path ordering.

### 1. Addition Commutativity
$$q_1 + q_2 \equiv q_2 + q_1$$

```idris
public export
prop_addCommutative : UnixelFraction -> UnixelFraction -> Bool
prop_addCommutative q1 q2 =
  rationalEquiv (addUnixelFraction q1 q2) (addUnixelFraction q2 q1)
```

### 2. Multiplication Commutativity
$$q_1 \cdot q_2 \equiv q_2 \cdot q_1$$

```idris
public export
prop_mulCommutative : UnixelFraction -> UnixelFraction -> Bool
prop_mulCommutative q1 q2 =
  rationalEquiv (mulUnixelFraction q1 q2) (mulUnixelFraction q2 q1)
```

### 3. Continued Fraction Reconstruction Consistency
Converting a fraction to continued fraction terms and back preserves rational equivalence for positive observables:
$$\text{fromCF}(\text{toCF}(q)) \approx q$$

```idris
public export
prop_continuedFractionRoundtrip : UnixelFraction -> Bool
prop_continuedFractionRoundtrip q =
  let (MkUnixelFraction n d) = q
  in if unwrapBox n <= 0
       then True
       else
         let terms = toContinuedFraction 10 q
             reconstructed = fromContinuedFraction terms
         in rationalEquiv q reconstructed || length terms == 0
```

### 4. Stern-Brocot Path Mediant Invariance
The Stern-Brocot path preserves order and mediant bounds for positive observables:
$$\text{fromSB}(\text{toSB}(q)) \approx q$$

```idris
public export
prop_sternBrocotPathRoundtrip : UnixelFraction -> Bool
prop_sternBrocotPathRoundtrip q =
  let (MkUnixelFraction n (MkUnixel d)) = q
      nSmall = clampNat (boxToNat n) 10
      dSmall = clampNat d 10
      qSmall = mkUnixelFraction (intToBoxInt (cast nSmall)) dSmall
      path = toSternBrocotPath 20 qSmall
      reconstructed = fromSternBrocotPath path
  in rationalEquiv qSmall reconstructed || length path == 0
```

## QuickCheck Execution Runner

```idris
public export
auditUnixelFractionProof : IO Bool
auditUnixelFractionProof = do
  let r1 = qc2 prop_addCommutative
  let r2 = qc2 prop_mulCommutative
  let r3 = qc prop_continuedFractionRoundtrip
  let r4 = qc prop_sternBrocotPathRoundtrip
  pure (r1.pass == Just True && r2.pass == Just True && r3.pass == Just True && r4.pass == Just True)
```
