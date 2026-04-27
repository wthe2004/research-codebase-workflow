Before implementing, write a plan and store it in ./docs/plans/ with the filename "[feature/bug/hotfix]/<title>/timestamp"

The plan must include:

1. Goal

- What problem are we solving?
- What is the expected behavior after the change?
- What is out of scope?

2. Files to Modify

- Which files will be changed?
- Will any files be added or deleted?
- Why is each file involved?

3. Existing Pattern to Follow

- Which existing file/function/component should this change mimic?
- What pattern, naming style, error handling style, or test style should be preserved?

4. Implementation Steps

- Briefly describe the implementation in 3–6 steps.
- Provide pseudocode if the logic is non-trivial.

5. API / Dependency Check

- List any important APIs, functions, classes, imports, or dependencies used.
- Confirm they exist in the repo or dependency files.
- Do not invent APIs.

6. Risk Check

- Could this break existing behavior?
- Does this touch data, config, permissions, database schema, or external APIs?
- Are there any hard-coded values, monkey patches, mocks, or temporary workarounds?

7. Test Plan

- What tests will be added or updated?
- What does each test verify?
- Cover at least the happy path and one failure or edge case.
- If no test is added, explain why.

8. Review Checklist

- No unrelated changes.
- No hallucinated APIs.
- Existing behavior preserved.
- Code style matches the repo.
- Tests pass.
