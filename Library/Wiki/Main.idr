module Wiki.Main

import Core.MultisetTree
import Core.Polynumber
import Core.UnixelFraction
import Core.VexelMaxel
import Math.LawAlgebra
import System
import Wiki.MaxelAlgebraSpec
import Wiki.UnixelFractionSpec
import Wiki.MultisetTreeSpec
import Wiki.StatefulLawSpec

%default total

printTestResult : String -> Bool -> IO Unit
printTestResult name pass = 
  if pass 
     then putStrLn ("  [TEST] " ++ name ++ ": PASSED ✅")
     else putStrLn ("  [TEST] " ++ name ++ ": FAILED ❌")

main : IO ()
main = do
  putStrLn "========================================================"
  putStrLn "  🗃️ IDRIS2-MULTISET-TRANSFORM: VERIFICATION SUITE 🗃️  "
  putStrLn "========================================================"

  putStrLn "\n--------------------------------------------------------"
  putStrLn "  ⚡ IDRIS2-QUICKCHECK GENERATIVE PROPERTY SUITES ⚡  "
  putStrLn "--------------------------------------------------------"

  p1 <- auditMaxelAlgebraProof
  printTestResult "Maxel & Vexel Homomorphic Properties (QuickCheck)" p1

  p2 <- auditUnixelFractionProof
  printTestResult "UnixelFraction Rational Arithmetic & Mediant (QuickCheck)" p2

  p3 <- auditMultisetTreeProof
  printTestResult "O(log N) MultisetTree Invariants (QuickCheck)" p3

  p4 <- auditStatefulLawProof
  printTestResult "UniverseState Capacity & Law Monoid (QuickCheck)" p4

  putStrLn "\n--------------------------------------------------------"
  putStrLn "  🔍 STATIC PROOF WITNESS AUDITS 🔍  "
  putStrLn "--------------------------------------------------------"
  printTestResult "O(log N) MultisetTree Lookup & Insertion" auditMultisetTreeLookupProof
  printTestResult "MultisetTree Token Multiplicity Sum" auditMultisetTreeTokenSumProof
  printTestResult "Canonical BoxSpec Tree Ordering" auditBoxSpecTreeOrderingProof
  printTestResult "Tree Universe State Logarithmic Scaling" auditTreeUniverseScalingProof
  printTestResult "Continued Fraction Reconstruction" auditContinuedFractionProof
  printTestResult "Stern-Brocot Mediant Pathfinding" auditSternBrocotProof
  printTestResult "Hehner Constructivist Scale Conversions" auditHehnerScaleConversionProof
  printTestResult "Multiset Born Rule & Hehner Bit Bag" auditMultisetHehnerTriadProof
  printTestResult "Multiset Compactness & Jaccard Overlap" auditMultisetCompactnessRatioProof
  printTestResult "Law Algebra Monoid & Galois Connection" auditLawAlgebraMonoidProof

  let allQc = p1 && p2 && p3 && p4
  let allAudits = auditMultisetTreeLookupProof && auditMultisetTreeTokenSumProof &&
                  auditBoxSpecTreeOrderingProof && auditTreeUniverseScalingProof &&
                  auditContinuedFractionProof && auditSternBrocotProof &&
                  auditHehnerScaleConversionProof && auditMultisetHehnerTriadProof &&
                  auditMultisetCompactnessRatioProof && auditLawAlgebraMonoidProof

  putStrLn "========================================================"
  if allQc && allAudits
     then putStrLn "  ✨ ALL MULTISET TRANSFORM PROOFS & QUICKCHECK PASSED ✨  "
     else do
       putStrLn "  ❌ SOME VERIFICATION TESTS FAILED ❌  "
       exitWith (ExitFailure 1)
