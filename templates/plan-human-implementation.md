In this plan template, the human will implement the plan.
Before implementing, write a plan and store it in ./docs/plans/ with the filename "[feature/bug/hotfix]/<title>/timestamp_human"
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

Than, we have a very detailed implementation steps. 

Each step should be estimated to take around 50 lines of code. And inside each step, to help human student write the code, you should break a step into smaller sub-steps that are around 5-10 lines of code.

During each step, the plan includes:

- What file to modify?
    - Will any files be added or deleted?
    - Why is each file involved?
- What is the change, or what is the new function to add?
- How to implement the logic?
- Any existing pattern to follow?
- Which existing file/function/component should this change mimic?
    - What pattern, naming style, error handling style, or test style should be preserved?
    - Any original code?

Note that any implementation should be followed by a test plan.

- What need to be tested? What tests will be added or updated?
- What does each test verify?
- Cover at least the happy path and one failure or edge case.
- If no test is added, explain why.

And for each step, Check:
- API / Dependency Check
    - List any important APIs, functions, classes, imports, or dependencies used.
    - Confirm they exist in the repo or dependency files.
- Risk
    - Are there any hard-coded values, monkey patches, mocks, or temporary workarounds? Avoid as much as possible, and if necessary explain why.
    - Could this break existing behavior?
    - Does this touch data, config, permissions, database schema, or external APIs?

## PR lifecycle integration

After the plan is approved, create a draft PR and switch to the branch if not already on the branch. If the plan requires multiple PRs, state why.
