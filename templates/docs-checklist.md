# Docs Checklist

---

## Anti-patterns sweep — read your diff against these 8

- [ ] **Non-existent** — "No main README, so you don't know where to start when you clone a repository." / "No 'how to contribute' section, so you don't know which is the branch policy, where to add new documents, etc."
- [ ] **Hidden** — "Impossible to find useful documentation as it's scattered all over the place. E.g., no idea how to compile, run and test the code as the README is hidden in a folder within a folder within a folder."
- [ ] **Incomplete** — "Missing settings in the 'how to run this' document that are required to run the application."
- [ ] **Inaccurate** — "Documents not updated along with the code, so they don't mention the right folders, settings, etc."
- [ ] **Obsolete** — "Design documents that don't apply anymore, sitting next to valid documents. Which one shows the latest decisions?"
- [ ] **Out of order** — "Documents not organized per subject/workstream so not easy to find relevant information when you change to a new workstream." / "Design decision logs out of order and without a date that helps to determine which is the final decision on something."
- [ ] **Duplicate** — "No settings file available in a centralized place as a single source of truth, so developers must keep sharing their own versions, and we end up with many files that might or might not work."
- [ ] **Afterthought** — "Key documents created several weeks into the project: onboarding, how to run the app, etc."

---

## Repo-level docs that should exist / be up to date

- [ ] **Introduction**
- [ ] **Getting started**
  - [ ] Onboarding
  - [ ] Setup: programming language, frameworks, platforms, tools, etc.
  - [ ] Sandbox environment
- [ ] **Structure**: folders, projects, etc.
- [ ] **How to compile, test, build, deploy the solution/each project**
  - [ ] Linux
- [ ] **Design Decision Logs** (only when a non-trivial decision was made in this PR)

- [ ] **Environment lock**: `environment.yml` / `requirements.txt` + CUDA version pinned
- [ ] **Data preparation**: where to download, target directory layout, preprocessing command, expected manifest/split files
- [ ] **Per-script run instructions**: minimal command + expected output path + rough wall-clock + GPU memory
- [ ] **Reproduction map**: which config + commit + checkpoint reproduces which table/figure
- [ ] **Config semantics**: which fields are paper hyperparams vs engineering switches; which combos are known-good

---

## 3. Code comments touched by this PR

- [ ] If you added implementation comments, they explain **why**, not what
  > "the use of these comments is often considered a code smell. If you need to clarify your code, that may mean the code is too complex. So you should work towards the removal of the clarification by making the code simpler, easier to read, and understand. Still, these comments can be useful to give overviews of the code, or provide additional context information that is not available in the code itself."
- [ ] Useful-comment shapes you should match:
  > "Single line comment ... that explains **why** that piece of code is there"
  > "Multi-line comment ... that provides **additional context**"
- [ ] Research-specific _why-notes_ recorded for: non-obvious normalize order, layers forced to fp32, deviations from the paper, seed-sensitive code paths, anything that "looks deletable but isn't"

---

## 5. PR description quality

- [ ] Title and Description filled in (link the PR template if you have one)
- [ ] Linked work items / issues
- [ ] Description is:

  > "Actionable / Specific / Detailed / Includes assets (script, data, code, etc.) to reproduce scenario and validate solution / Includes details about the customer scenario / what the customer was trying to achieve"

  Research translation: include the exact command run, the config diff, the metric/figure produced, and (if applicable) the seed.

---

## 6. Markdown hygiene (run before pushing)

- [ ] `markdownlint` clean — "to verify Markdown syntax and enforce rules that make the text more readable."
- [ ] `lychee` clean — "to extract links from markdown texts and check whether each link is alive (200 OK) or dead."
- [ ] (Optional) `write-good` — "to check English prose."
- [ ] Diagrams, if any, follow the Mermaid convention from `docs/documentation/tools/languages.md`:
  > "Mermaid files (.mmd) can be source-controlled along with your code. It's also recommended to include image files (.png) with the rendered diagrams under source control. Your markdown files should link the image files, so they can be read without the need of a Mermaid rendering tool (e.g., during Pull Request review)."

---

## 7. Final pass

- [ ] Every doc you touched is still **accurate** against the code in this PR (re-read it after the last code change)
- [ ] No **duplicate** copies of settings, env files, or run commands left behind
- [ ] No **obsolete** doc sitting next to the new one — delete or supersede explicitly
