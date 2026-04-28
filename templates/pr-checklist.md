# PR Checklist for CV Research Code

Run through this checklist before submitting any pull request.

## Code Quality

- [ ] Code conforms with the agreed coding conventions (linters pass)
- [ ] Code compiles and runs without errors or warnings
- [ ] No commented-out tests in the mainline branch
- [ ] No sleeps in unit tests
- [ ] No reading from disk in unit tests
- [ ] No third-party API calls in unit tests
- [ ] Documentation updated to match the changes
- [ ] No dead code (unused imports, unreachable branches, orphan functions/classes, commented-out code blocks, leftover debug prints, unused variables/parameters)
- [ ] No hardcoded values unless truly necessary — paths, hyperparameters, magic numbers, URLs, device IDs, dataset roots, and seeds are pulled from config files, CLI args, or environment variables; if a literal must stay inline, justify it with a brief comment

## Unit Tests

- [ ] New code is accompanied by unit tests
- [ ] Unit tests are provably reliable (100% reliable, failures indicate a bug)
- [ ] Unit tests are fast (run in milliseconds)
- [ ] Unit tests are isolated (no external dependencies)
- [ ] Tests follow Arrange/Act/Assert structure
- [ ] Each test tests only one thing
- [ ] Tests follow the standard naming convention (`UnitName_StateUnderTest_ExpectedResult` or team equivalent)
- [ ] All new and existing tests pass locally

## ML/CV Specific Tests

- [ ] Data loading functions are tested with mocks (no real files needed to run tests)
- [ ] Data transformation functions have tests for fixed input and output
- [ ] Output shape is verified for transformation functions
- [ ] Model accepts the correct inputs and produces the correctly shaped outputs
- [ ] Model weights update when running `fit` (verified via single-epoch training on dummy data)
- [ ] Prediction format is validated on dummy data
- [ ] Test cases exist for data validation (no data, wrong format, null values, outliers)
- [ ] Long-running tests are marked separately (e.g. `@pytest.mark.longrunning`) so unit tests stay fast

## Integration Tests

- [ ] Interactions between components are tested
- [ ] Test data and mock dependencies do not slow down the suite excessively
- [ ] Resources created for a given test are cleaned up
- [ ] Tests are not written in a production environment

## Evaluation and Metrics

- [ ] Evaluation logic is approved by all stakeholders
- [ ] Evaluation flow is applicable for all present and future models (does not assume a specific prediction structure)
- [ ] Evaluation code is unit-tested and reviewed by all team members
- [ ] Evaluation flow facilitates further results and error analysis
- [ ] Same performance evaluation metrics and consistent datasets are used when comparing candidate models
- [ ] Performance metrics are automatically tracked into the experiment tracker

## Model Baseline and Benchmarking

- [ ] Well-defined baseline model exists and its performance is calculated
- [ ] The performance of the new model is compared with the model baseline
- [ ] ML performance metrics (accuracy, recall, RMSE, etc.) are measured on both train and test set
- [ ] Train/test split is well documented and reproducible

## Data Quality

- [ ] Data distribution of training, testing and validation sets has been analyzed (all from the same distribution)
- [ ] Distribution of each individual feature is consistent across all datasets
- [ ] Data lineage information is available (where the data came from, how it was collected)
- [ ] No data quality issues (outliers, null values) introduced

## Reproducibility

- [ ] Virtual environment configuration files are up to date (`requirements.txt`, `environment.yml`, or `pyproject.toml`)
- [ ] Experiments are logged with all required details (dataset names and versions, parameters, code, environment)
- [ ] Folder structure is consistent with the agreed project structure
- [ ] `.gitignore` correctly excludes data, models, and local artifacts
- [ ] Notebooks are stored and versioned according to the agreed convention (e.g. output stripped)
- [ ] Random seeds are fixed where appropriate

## Performance and Profiling

- [ ] Performance impact of changes has been considered
- [ ] No obvious performance regressions introduced
- [ ] CPU/GPU/memory usage is acceptable for the change
- [ ] Goals and hard limits for performance, speed of prediction and costs have been respected
- [ ] If a performance test was run, results are documented (commit id, configuration, observations)

## PR Hygiene

- [ ] PR is small and focused (solves one goal, has only one reason to change)
- [ ] PR is consistent (all changes aim to solve one goal)
- [ ] PR does not break the build
- [ ] PR includes related tests as part of the PR
- [ ] PR description is well-written following the agreed convention
- [ ] No secrets or credentials are hard-coded
- [ ] Build was run locally before pushing
- [ ] CI pipeline passes on the latest commit

## Code Coverage

- [ ] Test coverage is at or above the minimum threshold (typically 80%)
- [ ] Coverage report is published to CI

## Smoke Test (before merge)

- [ ] Model loads without errors
- [ ] Forward pass runs without crashing
- [ ] Output shape is correct
- [ ] Training loop runs for at least one iteration without errors
- [ ] Configuration is logged at startup
