# Q1 formalization

This project accompanies the English [research note](../../../ai-tex/Q1/source.pdf).
It uses **Lean 4.35.0** and mathlib commit
`56a005855ea17e0b0958f73ec801ae140b0a1679`.

**The main theorem and the counterteam-size corollaries are fully proved.**
The formalization includes source universality, both directions of the
semantic reduction, and a primitive-recursive certificate for the
complete encoded reduction. No undecidability or compiler-correctness
hypothesis remains in the final theorems.

## Main theorem interfaces

[Complexity](Complexity.lean) assembles the exact classification:

```lean
Complexity.implication_coRE_complete :
  Complexity.CoREComplete Coded.Implication

Complexity.finite_implication_coRE_complete :
  Complexity.CoREComplete Coded.FiniteImplication
```

Here `CoREComplete P` means that the complement of `P` is `REPred` and
every co-r.e. predicate on natural numbers many-one reduces to `P` through
a mathlib `Computable` map. The module also gives explicit
`¬ ComputablePred` and `¬ REPred` results, both for general consequents
and for the fixed consequent.

The fixed consequent is literally

```text
=(w,z) ∨ =(w,z) ∨ =(U,w) ∨ =(U,w) ∨ =(V,w) ∨ =(V,w).
```

The variable names are `U=0`, `V=1`, `w=2`, and `z=3`. Repeated atom
occurrences are retained. Disjunction has lax cover semantics; cover
parts may overlap or be empty. Values range over arbitrary domains.

`fixed_hardness_restricted` carries both restrictions through the same
computable reduction: each premise is nonempty with at most five atom
occurrences, and every occurring variable except `0,1,2,4,5` has an
explicit bound of at most three values among the premises. The latter
condition includes variables mentioned in the consequent and is defined
as `FiveUnboundedColumns` in [ComplexityBounds](ComplexityBounds.lean).

[Compactness](Compactness.lean) proves
`finiteEntails_iff_entails`, so finite and arbitrary implication coincide.
[FinalModelBound](FinalModelBound.lean) connects undecidability to
counterteam sizes. The bound concerns the **number of rows in a
mathematical team**, not the size of an encoded search witness. For every
computable proposed bound, some invalid restricted instance requires
more rows in every finite counterteam, over every value domain.

## Proof chain

```mermaid
flowchart TD
  A[mathlib partial-recursive evaluation] --> B[Fixed universal four-stack machine]
  B --> C[Finite stack graph and register program]
  C --> D[Prime encoding into two counters]
  D --> E[Input initialization and normalized program]
  E --> F[Primitive-recursive Boolean row predicate and DNF graph]
  F --> G[Pure dependence premises with a fixed consequent]
  G --> H[co-r.e. hardness]
  I[Finite character and primitive-recursive counterteam checking] --> J[co-r.e. upper bound]
  H --> K[co-r.e. completeness and undecidability]
  J --> K
  K --> L[No computable counterteam row bound]
```

| Layer | Principal modules |
| --- | --- |
| Team semantics and finite character | [Basic](Basic.lean), [Coloring](Coloring.lean), [Compactness](Compactness.lean), [Projection](Projection.lean), [FiniteVariables](FiniteVariables.lean) |
| Encoded upper bound | [CodedSyntax](CodedSyntax.lean), [CodedCheck](CodedCheck.lean), [CodedSemantics](CodedSemantics.lean), [Computability](Computability.lean) |
| Actual universal source | [UniversalTM2](UniversalTM2.lean), [UniversalInput](UniversalInput.lean), [UniversalHardness](UniversalHardness.lean), [TM2Renaming](TM2Renaming.lean) |
| Exact finite machine simulations | [TM2Microsteps](TM2Microsteps.lean), [TM2StackGraph](TM2StackGraph.lean), [StackNetwork](StackNetwork.lean), [RegisterCompiler](RegisterCompiler.lean), [TM2CounterReduction](TM2CounterReduction.lean) |
| Effective normalized source family | [ProgramNormalization](ProgramNormalization.lean), [NormalizationCoding](NormalizationCoding.lean), [UniversalCounterProgram](UniversalCounterProgram.lean) |
| Counterteam to halting run | [Hall](Hall.lean), [SemanticSaturation](SemanticSaturation.lean), [SaturatedPorts](SaturatedPorts.lean), [SemanticSoundness](SemanticSoundness.lean), [MachineExtraction](MachineExtraction.lean) |
| Halting run to finite counterteam | [TokenConstruction](TokenConstruction.lean), [CanonicalGraph](CanonicalGraph.lean), [CanonicalCountermodel](CanonicalCountermodel.lean), [MachineRealization](MachineRealization.lean) |
| Uniform dependence compiler | [CompilerSyntax](CompilerSyntax.lean), [CompilerSoundness](CompilerSoundness.lean), [CompilerCompleteness](CompilerCompleteness.lean), [MachineRowVariant](MachineRowVariant.lean) |
| Fully certified encoded compiler | [RawBooleanRows](RawBooleanRows.lean), [BooleanDNF](BooleanDNF.lean), [BooleanGraphCode](BooleanGraphCode.lean), [RawMachineTheory](RawMachineTheory.lean), [CompilerFrontend](CompilerFrontend.lean), [RawCompiler](RawCompiler.lean) |
| Quantitative counterteam normalization | [BoundedCounterteams](BoundedCounterteams.lean), [ModelBound](ModelBound.lean), [FinalModelBound](FinalModelBound.lean) |

The semantic reduction works in both directions: an arbitrary counterteam
forces a real halting run, and a halting run yields a finite counterteam.
The effective frontend uses an explicit DNF row formula.
`MachineRowVariant` proves that this choice preserves the semantics of
the earlier Shannon-based construction; the two syntactic outputs are
not identified.

## Computability and classical definitions

The universal program is selected from mathlib's proved representation
theorem. Its fixed finite instruction table and a fixed finite numbering
of its controls may use classical choice. They are constants in the
reduction; the varying input family has an explicit `Primrec` certificate.
No universality assumption is added. The project does not print or execute
the enormous selected universal instruction table.

Similarly, a few dependent internal definitions are marked `noncomputable`
to avoid unnecessary code generation. Computability claims are separate
proved statements using mathlib's `Primrec` and `Computable`, not conclusions
inferred merely from having written a Lean function.

## Build and audit

```sh
# From the repository root:
(cd lean && lake exe cache get)
./scripts/check.sh
```

The script builds the entire library with warnings treated as errors,
then checks the axiom dependencies of the principal results in
[Check.lean](../../Check.lean). It accepts only `propext`, `Classical.choice`, and
`Quot.sound`. There are no `sorry`, `admit`, custom axioms, or
`native_decide` proofs. Finite gadget checks use kernel-checked `decide`.

The build writes its audit to `build/lean-check.log`. The shared Lean project
pins its toolchain and dependencies in `lean/lean-toolchain`,
`lean/lakefile.toml`, and `lean/lake-manifest.json`. Dependency caches and
build products are ignored by Git.

Import this formalization with `import DepDis.Q1` or a specific
`DepDis.Q1` module. Declaration names retain their original `DepDis`
namespaces. The source proofs were imported with only module paths
adjusted to the shared repository layout.
