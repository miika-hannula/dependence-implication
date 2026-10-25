# Lean formalization

This is one Lake project for the dependence-implication research project.
It starts with an empty library, pinned to Lean **4.35.0**, and no external
dependencies. Question-specific modules are added through pull requests.

```text
DepDis.lean             Library entry point
Check.lean              Axiom dependencies of principal results
DepDis/Common/          Shared definitions and lemmas
DepDis/<question-id>/   Modules for an accepted question
```

Import accepted modules from `DepDis.lean`. Add principal theorem checks
to `Check.lean` using `#print axioms DepDis.YourTheorem`.
The project's audit accepts only `propext`, `Classical.choice`, and
`Quot.sound`.

From this directory:

```sh
lake build
lake env lean Check.lean
```

For the combined PDF build and axiom audit, run from the repository root:

```sh
./scripts/check.sh
```

If a contribution adds dependencies, record them in `lakefile.toml` and
commit the generated `lake-manifest.json`. The toolchain file is the
source of the Lean version used locally and in CI.

Question pages and the README summary record the extent of each
formalization and its separate human review.
