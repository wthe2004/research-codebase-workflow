Before implementing, write a plan and store it in ./docs/plans/ with the filename "[feature/bug/hotfix]/<title>/timestamp"
Note that when writing the plan, avoid tables and use subheadings instead.

Use [Caveman language](../docs/caveman-language.md) to write the plan.

Before writing the plan, check if the corresponding issue and branch is created.

The plan must include:

1. Goal

- What problem are we solving?
- What is the expected behavior after the change?
- What is out of scope?

2. Implementation Steps

- First, write one paragraph that describes how you design the overall changes.
- Briefly describe the implementation in steps. Note that each step should be around 50 lines, no more than 100 lines, and definitely not more than 200 lines of code.
- Each step should be a checkpoint for code review, so it is human-in-loop. Commit after human approval. Implement each step after the previous step is approved. 

3. Files to Modify

- What's your design?
- Explain the design choices, why this architecture can solve the problem
- Under this design, which files will be changed?
- Will any files be added or deleted?
- Why is each file involved?

4. Existing Pattern to Follow

- Which existing file/function/component should this change mimic?
- What pattern, naming style, error handling style, or test style should be preserved?
- Any original code?

5. API / Dependency Check

- List any important APIs, functions, classes, imports, or dependencies used.
- Confirm they exist in the repo or dependency files.

6. Risk Check

- Are there any hard-coded values, monkey patches, mocks, or temporary workarounds? Avoid as much as possible, and if necessary explain why.
- Could this break existing behavior?
- Does this touch data, config, permissions, database schema, or external APIs?

7. Test Plan

- What need to be tested? What tests will be added or updated? Cover as much as possible.
- What does each test verify?
- Cover at least the happy path and one failure or edge case.
- If no test is added, explain why.

## PR lifecycle integration

When this plan is implemented through a draft PR (one PR holding all the
step commits), the AI MUST automatically mark the PR ready-for-review
(`gh pr ready <num>`) immediately after the final step's commit lands and
the PR description has been updated to reflect "all steps complete". Do
not wait for the user to manually flip the draft toggle — once the last
step finishes, the PR is by definition no longer a work-in-progress.

The user retains the merge decision separately (the AI never runs
`gh pr merge`); marking ready-for-review only changes the GitHub draft
flag, it does not finalize anything. Treat it as a natural part of the
final step's commit-and-wrap-up turn, not a separate state-change gate.

If the plan is implemented via N independent PRs instead of one PR per
step, this rule applies to whichever PR is the last to land for each
step (i.e. each PR's own final commit triggers ready-for-review for
that PR).