# Branching and PR workflow

This document describes my project-level conventions for organizing branches and pull requests, and how I work with AI assistants (Claude Code, GitHub Copilot review) inside that flow. It complements the unit-level templates in `templates/` (plan, PR checklist, docs checklist).

## 1. Branching model

I use a double-trunk model:

- `main`: release / stable. Only receives merges from `dev`.
- `dev`: active integration branch. Receives merges from short-lived feature branches.
- Feature branches: `[feat|fix|chore|docs|refactor]/<descriptive-name>`, branched off `dev`, deleted after merge.

A long-running project may also keep older feature branches (e.g. `feat/<old-thing>`) as historical references; they are deleted only after the audit confirms they hold zero unique commits relative to `dev` / `main`.

## 2. Branch protection

On GitHub, both `main` and `dev` get the same ruleset:

- Require pull request before merging
- Block force pushes
- Block deletions
- Linear history NOT required (allow merge commits)
- Approvals NOT required (single-author projects)

Approvals can be turned off because GitHub never counts the author's own approval anyway, and a self-review is a discipline, not a gate. The point of branch protection here is to prevent accidental direct push and prevent rewriting published history.

For PR merging, prefer "Create a merge commit" (preserves PR boundary in the log) over squash or rebase. This gives `git log --graph` a tree that maps cleanly to PR history.

## 3. PR lifecycle

### 3.1 PR 0 bootstrap

The very first PR on a fresh repo adds `.github/pull_request_template.md`. This is the one PR that does not have a template to fill out itself — you write its description by hand, demonstrating the structure that all subsequent PRs will inherit.

The template is the **precis** version of the full checklist: four short sections that get filled out for every PR. The full checklist (`templates/pr-checklist.md`) is the **deeper** audit that lives separately (see §3.3).

Recommended precis template:

```markdown
## Summary

<!-- What changed and why. One paragraph. Focus on the why; the diff already shows the what. -->

## Test plan

<!-- How this PR was verified. Check what was actually run. Add additional smoke / manual verification checkboxes below if relevant. -->

- [ ] `<test command>` passes
- [ ] `<lint command>` clean

## Scope check

- [ ] No unrelated changes (diff matches the PR title)
- [ ] No hallucinated APIs (every imported symbol / called function exists)
- [ ] Existing behavior preserved, or behavior changes documented in Summary

## Specific risk

<!-- Performance, data migration, backward compatibility, security, secrets, anything reviewers should scrutinize. Write "None." if truly nothing. -->

---

<sub>For larger PRs, also write a full checklist report at `docs/prs/<branch>-<YYYYMMDD_HHMMSS>.md` based on `templates/pr-checklist.md`.</sub>
```

### 3.2 Per-PR steps

For every PR after PR 0:

1. Open a GitHub issue describing the feature / fix / chore first. The issue is the unit of intent — it captures the goal, scope, and any open questions before any code is written. Even one-line issues are fine; the point is having a stable URL to point the branch and PR at.
2. Branch off `dev` with a `[type]/<name>` name. Link the branch to the issue via GitHub's "Create a branch" button on the issue page (preferred), or by including `#<issue-number>` in the branch's first commit / PR description so GitHub auto-links them. The PR should close the issue on merge via a `Closes #<n>` line in the PR body.
3. Implement the change. Commit with a clear message.
4. Walk the full `templates/pr-checklist.md` (~110 items). For each item, mark **applicable / N/A with reason / concerns**. Every claim of the form "command X passes" must be backed by an actual run of X recorded in the report — no fabrication.
5. Save the checklist report to `docs/prs/<branch-with-slashes-replaced-by-dashes>-<YYYYMMDD_HHMMSS>.md`. Get the timestamp at PR creation time via `date +%Y%m%d_%H%M%S`. The report is a per-PR audit artifact; it stays with the project even after the PR's web view is archived.
6. Push the feature branch and open the GitHub PR. The precis template auto-loads; fill it in. Include `Closes #<issue-number>` in the body so the linked issue closes on merge.
7. Triage any review feedback (see §5 for AI-assisted handling).
8. Merge via "Create a merge commit". Delete the feature branch.

### 3.3 Two-layer review

- **Precis** (4 sections, in PR description): for the reviewer's at-a-glance scan. Lives in GitHub.
- **Full checklist report** (`docs/prs/<branch>-<ts>.md`): the deeper audit. Lives in the repo. Surfaces claims of behavior preservation, data layer impact, security/permissions, performance, etc., with verification evidence.

Why both: the precis is fast to read and write, but easy to skip thoroughly. The full report forces a deliberate pass through 110 items including all the ML/CV-specific concerns (data loaders, output shape, train-loop sanity, reproducibility, etc.). The precis is the human-readable summary; the report is the audit trail.

If the project has not yet enabled `docs/` for tracking, the report is still written, just into a gitignored area until a later PR narrows the gitignore.

## 4. Style conventions for prose

Inside PR descriptions, commit message bodies, and markdown docs, **do not hard-wrap natural-language paragraphs**. Each paragraph is one logical line; let GitHub / the editor wrap visually.

The 72/80-column convention came from email clients in the 80s. It is irrelevant for modern rendering surfaces (GitHub PR view, hover preview, mobile, Slack quote) which already wrap, and it makes the source look broken in those views.

Code lines still follow whatever the project's linter enforces (e.g. `ruff` `line-length`). This rule is about prose, not code.

Branch naming and section headers, however, are short and don't need wrapping rules.

For commit messages: subject line stays ≤ 50–72 chars (different convention; about `git log --oneline` readability). The body is prose and follows the no-hard-wrap rule.

## 5. AI-assisted PR work

The following conventions apply when an AI assistant (e.g. Claude Code) is collaborating on PRs.

### 5.1 Language split

Project artifacts (commits, PR descriptions, code comments, markdown docs, internal AI thinking) stay in English regardless of the human collaborator's preferred chat language. The AI's chat replies use the human's preferred language.

### 5.2 Ask before any git or PR action

The AI must propose any branch create/delete, remote add/push, merge, reset, force op, `gh pr create`, branch rename, or other state-changing operation in chat first, and wait for explicit "go" before running it. Auto/autonomous modes do not override this rule.

Read-only diagnostics (`git status`, `git log`, `git diff`, `gh pr view`, `gh api ... read-only endpoints`) do not need approval.

This rule exists because branch topology, remote state, and PR lifecycle are exactly the places where a small AI mistake costs a lot of cleanup. The cost of pausing to confirm is one extra chat turn; the cost of an unwanted action is potentially lost commits or a broken protected branch.

### 5.3 Copilot review handling

When GitHub Copilot reviews a PR (manually triggered via "Get Copilot review"), the AI assistant fetches comments via `gh pr view` / `gh api repos/<owner>/<repo>/pulls/<num>/comments`, then triages each suggestion:

- **Obviously correct** (typo, clear bug, missing import, broken syntax): fix directly with a fix-up commit and push to the PR branch. Commit message starts with `fix(copilot): <what>`.
- **Complex / debatable** (architectural, stylistic, "should we add X"): bring to chat, present each item, await human decision before changing anything.
- **Wrong / disagree** (Copilot demanding over-engineering, contradicting project conventions, suggesting irrelevant defensive code): push back with a technical reason both in chat and in a reply to the Copilot comment.

Replies to Copilot comments are posted via `gh api .../comments/<id>/replies -X POST -f body="[Claude]: <message>"`. **Every reply is prefixed with `[Claude]:`** so it is clear the AI (not the human owner) is speaking. This matters when Copilot or future maintainers read the thread.

Final report back to the human: "accepted N, rejected M (with reasons), deferred K to discussion", with links to fix-up commits.

### 5.4 Cross-AI prompt pattern

Sometimes the work requires a separate AI session in a different repo (e.g. organizing commits in a vendored fork, working in a sibling project). The pattern:

1. The "main" AI session writes a self-contained prompt. It must include: the current state of the target repo, what to do, hard boundaries (e.g. never push to upstream), inherited workflow rules (link to this doc and to `templates/pr-checklist.md`), and what to report back at the end.
2. The human starts a fresh AI session in the target repo, pastes the prompt, and oversees the work.
3. The fresh session has zero memory of the main session, so the prompt must bootstrap conventions explicitly. It is fine to point at the playbook directory by absolute path; it is not fine to assume the fresh session has any prior context.
4. When the fresh session is done, the main session resumes and integrates the result (e.g. updates submodule pointer, opens a follow-up PR).

A prompt template should live alongside the work it describes (e.g. project-local `docs/tmp/<task>-prompt.md` or similar gitignored scratch space) so it can evolve project-by-project.

### 5.5 Authorship

When the AI writes the diff: include `Co-Authored-By: <ai-name> <noreply@<vendor>>` in the commit message. This is the default for commits the AI authors substantively.

When the AI is **organizing** pre-existing human work (e.g. batching uncommitted human changes into clean commits, splitting a mega-diff): the commits are **the human's authorship**. Do not add `Co-Authored-By` lines for the AI. The AI is acting as a courier.

The boundary is "did the AI generate the code being committed". Generation gets credit; organizing does not.

## See also

- `docs/source-control-minimal-cv-research.md` — minimal source-control conventions (branch naming, secrets handling). The branching model in §1 above is consistent with that file.
- `templates/pr-checklist.md` — the full ~110-item checklist walked in §3.2 step 3.
- `templates/docs-checklist.md` — anti-pattern sweep for any markdown docs touched.
- `templates/plan-mini.md` and `templates/plan-standard.md` — planning templates used **before** writing code, not part of this PR-time workflow. Plans live in `docs/plans/<YYYYMMDD_HHMMSS>_<slug>.md` per the project's CLAUDE.md.
