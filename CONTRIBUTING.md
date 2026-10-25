# Contributing

Contributions are made through pull requests. You can propose a question,
add a subquestion, contribute a full or partial answer, improve a proof,
develop a formalization, update the conceptual map, or improve shared
macros and project components.

## Propose a question or subquestion

The PR description has only two fields:

```text
Question
State the question precisely.

Additional information (optional)
Add any useful assumptions, motivation, sources, or relation to another question.
```

A question proposal can consist of this description alone. Its identifier
and placement are agreed in the discussion. At merge time, record the
accepted statement in `questions/<id>.md` and add it to the README table.
For a decision problem, an Input / Question formulation is useful.

Subquestions may initially be sections of the parent question's page.
Give them stable identifiers when accepted; manuscript section numbers
can change independently of these identifiers.

## Contribute to an existing question

Identify the question in the PR's Question field and describe the
contribution under Additional information. Place related material under
the same question identifier:

- `ai-tex/<id>/source.tex` for AI-generated research notes.
- `human-tex/<id>/source.tex` for human-authored notes.
- `conceptual-map/questions/<id>.tex` for its part of the shared map.
- `lean/DepDis/<id>/` for question-specific Lean modules.

Human-authored means that a human takes authorship and responsibility for
the content. Human review is recorded separately in the question statuses. 
Text fragments can be split into further files as they grow.

TeX fragments should contain manuscript content and use the shared
`preamble.tex`. Include accepted fragments from `main.tex`; include map
fragments from `conceptual-map/main.tex`. Alternative drafts can remain
available in their note folders.

## Coordinate ongoing work

Contributors can propose working on a question,
subquestion, or a defined part of a proof or formalization. Describe the
proposed scope and approximate working period in the PR's Additional
information field.

Once agreed, record the contributor, scope, and approximate working period
on the question's page:

```text
Work in progress: @handle — the question or part being worked on.
Working period: the agreed approximate period.
```

Please coordinate with the listed contributor before
undertaking substantial overlapping work or submitting a complete solution
to the agreed question. Comments, review, and supporting contributions
remain welcome. 

Coordinating work in this way can be especially helpful for BSc/MSc
students. Keep the note up to date and remove it when the work has 
ended or been set aside.

## Improve shared parts

Contributions to `preamble.tex` are welcome, including adding or improving
macros, notation, packages, and theorem environments. Identify the shared
part in the PR's Question field and describe the change under Additional
information. The same approach applies to build scripts and other shared
components.

Both the manuscript and the conceptual map use `preamble.tex`; rebuild
both PDFs with `./scripts/build-pdfs.sh` after changing it.

## Question pages and statuses

Each question page contains its precise statement, any subquestions, a
status table, and links to its notes, manuscript sections, and formalization.
Use these four fields, each with values `yes`, `no`, or `partially`:

| Field | Meaning |
| --- | --- |
| Solved | The question has a complete answer in this repository. A proof of undecidability is an answer. |
| Human-checked solution | A human has reviewed the stated answer and its mathematical argument. |
| Formalized | The stated result has a completed machine-checked proof. |
| Human-checked formalization | A human has reviewed the formal statement, its assumptions, and its correspondence to the intended result. |

Use `no` when the corresponding work or review has not been recorded.
For each `partially` entry, add a short explanation of what is covered
and what remains. Human reviewers record their name or handle and the
scope of their review on the question page. Human-check fields are updated
by the human reviewer; a successful Lean build is recorded separately.

Keep the README summary in sync with the question pages. A new question
will normally start with all four fields set to `no`.

## Lean organization and checks

There is one Lake project in `lean/`. Put reusable definitions and lemmas
under `lean/DepDis/Common/`, and question-specific material under its
question directory. Import accepted modules in `lean/DepDis.lean`.

List principal result dependencies in `lean/Check.lean` with
`#print axioms DepDis.YourTheorem`. The audit accepts only `propext`,
`Classical.choice`, and `Quot.sound`. A partially formalized question can
contain completed definitions and lemmas while its remaining obligations
are described in the question page.

Run the checks relevant to your contribution:

```sh
./scripts/build-pdfs.sh
./scripts/check.sh
```

Review the rendered PDFs after changing TeX, and include updated manuscript
or map PDFs with those changes. Commit Lean toolchain or dependency
changes together with the generated `lake-manifest.json`.

Contributions are provided under the repository's MIT License. Keep
attribution and third-party license notices where applicable.
