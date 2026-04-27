Before implementing, write a plan and store it in ./docs/plans/ with the filename "[feature/bug/hotfix]/<title>/timestamp"

The plan must include:

1. Goal and Scope

- What feature/problem are we solving?
- What is explicitly out of scope?
- What are the acceptance criteria?

2. Files

- How many files will be added?
- Which files will be modified?
- What does each file contain?
- Why is each file necessary?

3. Design

- What is the implementation strategy?
- Why is this design chosen?
- What alternatives were considered?
- How does this fit the existing architecture?

4. Coupling / Decoupling

- What existing modules, APIs, states, or schemas does this depend on?
- What parts are decoupled?
- Are UI, business logic, data access, and configuration separated properly?

5. Non-engineered Code / Technical Debt

- Are there any monkey patches, hard-coded values, global states, mocks, duplicated logic, or temporary workarounds?
- If yes, why are they needed?
- What is the cleaner long-term solution?

6. Reuse Existing Code

- Which existing file or pattern is being mimicked?
- What code is reused or adapted?
- What is added compared with the source pattern?
- What is removed compared with the source pattern?

7. Original Code

- If new logic is original, what existing code, API, or documentation is it based on?
- Provide pseudocode before implementation.

8. Hallucination Check

- List every important API, function, class, import, and dependency.
- Confirm whether each one exists.
- Provide evidence from the repo, type definitions, package files, or official docs.

9. Data / State / Migration Impact

- Does this change database schema, config, environment variables, cache, local storage, API format, or model input/output?
- Is it backward compatible?
- Is migration or rollback needed?

10. Error Handling

- What failure cases are handled?
- What error messages or fallback behavior will be used?

11. Security / Privacy / Permissions

- Does this touch user data, credentials, database access, files, or external APIs?
- Are there injection, leakage, or permission risks?

12. Performance

- Could this introduce N+1 queries, repeated large reads, blocking calls, or high token/API cost?
- What happens if the data size grows?

13. Test Plan

- What tests will be added?
- What is the purpose of each test?
- Why is each test designed this way?
- Does the test plan cover happy path, edge cases, failure cases, and regression cases?
- What remains untested and why?

14. Rollback Plan

- How can this change be safely reverted?
- Are there generated files, migrations, or configs that need rollback?

15. Review Checklist

- Did we avoid unrelated changes?
- Did we avoid hallucinated APIs?
- Did we preserve existing behavior?
- Did we follow existing code style?
- Did we add sufficient tests?
