# research-codebase-workflow

Personal playbook for research + paper reproduction. Practices, checklists, templates for starting projects, reading others' code, building experimental codebases. Adapted from Microsoft [Code With Engineering Playbook](https://github.com/microsoft/code-with-engineering-playbook), MIT.

## Branching Model

- `main` and `dev` branches are protected and can only be pushed via PR.
- `dev` is the default branch, and `main` is only updated for major releases.

## Implementing a change

1. Create a github issue that describes the problem and the expected behavior after the change.
2. According to the issue, write a plan according to the template in `templates/plan-standard.md` or `templates/plan-human-implementation.md`, and save it to `docs/plans/`.
3. Create a branch off `dev` with the name `[type]/<issue-number>-<title>`, and push the plan to the branch.
4. After implementation, push the change to the branch, and open a PR.
5. After the PR is manually merged, delete the branch.

## Language

Use English for all text written to disk / pushed to GitHub.

Please refer to [`docs/caveman-language.md`](docs/caveman-language.md) for the style guide.

## Shell scripts

Shell stay thin: derive paths, hold defaults, call Python. See [`docs/shell-script-design.md`](docs/shell-script-design.md).

## Carve-out for this meta-repo

Note that for this meta-repo the workflow is simplified because it is docs only. I directly commit to `main`.

## License / attribution

Upstream: Microsoft [Code With Engineering Playbook](https://github.com/microsoft/code-with-engineering-playbook), MIT. Anything copied / paraphrased remains theirs. Rest is personal notes.
