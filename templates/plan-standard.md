Note that usually a standard plan is enough.
Before implementing, write a plan and store it in ./docs/plans/ with the filename "[feature/bug/hotfix]/<title>/timestamp"
Note that when writing the plan, avoid tables and use subheadings instead.

Before writing the plan, check if the corresponding issue and branch is created.

The plan must include:

1. Goal

- What problem are we solving?
- What is the expected behavior after the change?
- What is out of scope?

2. Implementation Steps

- Briefly describe the implementation in steps. Note that each step should be around 50 lines, no more than 100 lines, and definitely not more than 200 lines of code.
- Each step should be a checkpoint for code review, so it is human-in-loop. Implement each step after the previous step is approved.

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