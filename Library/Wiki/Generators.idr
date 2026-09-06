module Wiki.Generators

import public QuickCheck
import Data.List
import Core.BoxInt
import Core.Multiset
import Core.VexelMaxel
import Core.UnixelFraction
import Core.MultisetTree
import Core.UniverseState
import Math.LawAlgebra

%default total

public export
clampNat : Nat -> Nat -> Nat
clampNat n Z = 1
clampNat n (S maxVal) = integerToNat (cast {to=Integer} n `mod` cast {to=Integer} (S maxVal)) + 1

public export
Arbitrary BoxInt where
  arbitrary = map intToBoxInt arbitrary
  coarbitrary b gen = coarbitrary (unwrapBox b) gen

public export
Arbitrary Unixel where
  arbitrary = map (\n => MkUnixel (clampNat n 20)) arbitrary
  coarbitrary (MkUnixel i) gen = coarbitrary i gen

public export
Arbitrary Pixel where
  arbitrary = do
    r <- map (\n => clampNat n 10) arbitrary
    c <- map (\n => clampNat n 10) arbitrary
    pure (MkPixel r c)
  coarbitrary (MkPixel r c) gen = coarbitrary r (coarbitrary c gen)

public export
Arbitrary Vexel where
  arbitrary = do
    ts <- arbitrary {a = List (Unixel, BoxInt)}
    pure (canonicalizeVexel (MkVexel (take 5 ts)))
  coarbitrary (MkVexel terms) gen =
    let t = map (\(MkUnixel i, w) => (i, unwrapBox w)) terms
    in coarbitrary t gen

public export
Arbitrary Maxel where
  arbitrary = do
    ps <- arbitrary {a = List (Pixel, BoxInt)}
    pure (canonicalizeMaxel (MkMaxel (take 5 ps)))
  coarbitrary (MkMaxel pxs) gen =
    let t = map (\(MkPixel r c, w) => (r, c, unwrapBox w)) pxs
    in coarbitrary t gen

public export
Arbitrary UnixelFraction where
  arbitrary = do
    n <- arbitrary {a = BoxInt}
    dRaw <- arbitrary {a = Nat}
    pure (mkUnixelFraction n (clampNat dRaw 50))
  coarbitrary (MkUnixelFraction n (MkUnixel d)) gen =
    coarbitrary (unwrapBox n) (coarbitrary d gen)

public export
Arbitrary SternBrocotBranch where
  arbitrary = do
    b <- arbitrary {a = Bool}
    pure (if b then BranchL else BranchR)
  coarbitrary BranchL gen = coarbitrary (the Nat 0) gen
  coarbitrary BranchR gen = coarbitrary (the Nat 1) gen

public export
qc : (Arbitrary a, Show a, Testable prop) => (a -> prop) -> QCRes
qc f = quickCheck (MkFn f)

public export
qc2 : (Arbitrary a, Show a, Arbitrary b, Show b, Testable prop) => (a -> b -> prop) -> QCRes
qc2 f = quickCheck (MkFn (\x => MkFn (f x)))

public export
qc3 : (Arbitrary a, Show a, Arbitrary b, Show b, Arbitrary c, Show c, Testable prop) => (a -> b -> c -> prop) -> QCRes
qc3 f = quickCheck (MkFn (\x => MkFn (\y => MkFn (f x y))))

public export
qc4 : (Arbitrary a, Show a, Arbitrary b, Show b, Arbitrary c, Show c, Arbitrary d, Show d, Testable prop) => (a -> b -> c -> d -> prop) -> QCRes
qc4 f = quickCheck (MkFn (\x => MkFn (\y => MkFn (\z => MkFn (f x y z)))))
