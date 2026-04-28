# Testing for ML and Computer Vision Research Projects

## Why Testing

- Tests allow us to find flaws in our software
- Good tests document the code by describing the intent
- Automated tests saves time, compared to manual tests
- Automated tests allow us to safely change and refactor our code without introducing regressions

### The Fundamentals

- We consider code to be incomplete if it is not accompanied by tests
- We write unit tests (tests without external dependencies) that can run before every PR merge to validate that we don't have regressions
- We write Integration tests/E2E tests that test the whole system end to end, and run them regularly
- We write our tests early and block any further code merging if tests fail
- We run load tests/performance tests where appropriate to validate that the system performs under stress

## Build for Testing

Testing is a critical part of the development process. It is important to build your application with testing in mind. Here are some tips to help you build for testing:

- **Parameterize everything.** Rather than hard-code any variables, consider making everything a configurable parameter with a reasonable default. This will allow you to easily change the behavior of your application during testing. Particularly during performance testing, it is common to test different values to see what impact that has on performance. If a range of defaults need to change together, consider one or more parameters which set "modes", changing the defaults of a group of parameters together.

- **Document at startup.** When your application starts up, it should log all parameters. This ensures the person reviewing the logs and application behavior know exactly how the application is configured.

- **Log all activity.** If the system is performing some activity (reading data from a database, calling an external service, etc.), it should log that activity. Ideally, there should be a log message saying the activity is starting and another log message saying the activity is complete. This allows someone reviewing the logs to understand what the application is doing and how long it is taking. Depending on how noisy this is, different messages can be associated with different log levels, but it is important to have the information available when it comes to debugging a deployed system.

- **Log performance metrics.** Even if you are using monitoring tools to capture how long dependency calls are taking, it is often useful to know how long certain functions of your application took. It then becomes possible to evaluate the performance characteristics of your application as it is deployed on different compute platforms with different limitations on CPU, memory, and network bandwidth.

## Testing Pyramid and Test Types

The testing pyramid illustrates that the majority of your tests should be at the bottom of the pyramid (unit tests). As you move up the pyramid, the number of tests gets smaller. Also, going up the pyramid, tests get slower and more expensive to write, run, and maintain.

|                       | Unit Test              | Integration Test                             | System Testing                                            | E2E Test                                                      |
|-----------------------|------------------------|----------------------------------------------|-----------------------------------------------------------|---------------------------------------------------------------|
| **Scope**             | Modules, APIs          | Modules, interfaces                          | Application, system                                       | All sub-systems, network dependencies, services and databases |
| **Size**              | Tiny                   | Small to medium                              | Large                                                     | X-Large                                                       |
| **Environment**       | Development            | Integration test                             | QA test                                                   | Production like                                               |
| **Data**              | Mock data              | Test data                                    | Test data                                                 | Copy of real production data                                  |
| **System Under Test** | Isolated unit test     | Interfaces and flow data between the modules | Particular system as a whole                              | Application flow from start to end                            |
| **Scenarios**         | Developer perspectives | Developers and IT Pro tester perspectives    | Developer and QA tester perspectives                      | End-user perspectives                                         |
| **When**              | After each build       | After Unit testing                           | Before E2E testing and after Unit and Integration testing | After System testing                                          |
| **Automated or Manual** | Automated            | Manual or automated                          | Manual or automated                                       | Manual                                                        |

## Smoke Testing

Smoke tests, sometimes named *Sanity*, *Acceptance*, or *Build/Release Verification* tests, are a sub-type of system/functional tests that are usually used as gates that verify the application's readiness as a preliminary step. If an application passes the smoke tests, it is acceptable, or in a stable-enough state, for the next stages of testing or deployment.

Smoke tests are meant to find, as early as possible, if an application is working or not. The goal of smoke tests is to save time; if the current version of the application does not pass smoke tests, then the rest of the integration or deployment chain for it can be abandoned. Smoke tests do not aim to provide full functionality coverage but instead focus on a few quick acceptance invocations for which the application should, at all times, respond correctly to.

Smoke tests cover only the most critical application path, and should not be used to actually test the application's behavior, keeping execution time and complexity to minimum. The tests can be formed of a subset of the application's integration or e2e tests, and they cover as much of the functionality with as little depth as required.

The golden rule of a good smoke test is that it saves time on validating that the application is acceptable to a stage where better, more thorough testing will begin.

### ML Model Smoke Tests

Since these will often take a bit longer to run it's important to be able to separate them from unit tests so that the developers on the team can still run unit tests as part of their test driven development. One way to do this is using marks (e.g. `@pytest.mark.longrunning`) and running `pytest -v -m "not longrunning"` for the fast inner loop.

## Unit Testing

Unit testing is a fundamental tool in every developer's toolbox. Unit tests not only help us test our code, they encourage good design practices, reduce the chances of bugs reaching production, and can even serve as examples or documentation on how code functions. Properly written unit tests can also improve developer efficiency.

Unit testing refers to a very specific type of testing; a unit test should be:

- **Provably reliable** - should be 100% reliable so failures indicate a bug in the code
- **Fast** - should run in milliseconds, a whole unit testing suite shouldn't take longer than a couple seconds
- **Isolated** - removing all external dependencies ensures reliability and speed

### Why Unit Testing

#### Reduce Costs

There is no question that the later a bug is found, the more expensive it is to fix; especially so if the bug makes it into production. A 2008 research study by IBM estimates that a bug caught in production could cost 6 times as much as if it was caught during implementation.

#### Increase Developer Confidence

A strong unit test suite helps increase the confidence of the developer that their change is not going to cause any downstream bugs. Having unit tests also helps with making safe, mechanical refactors that are provably safe; using things like refactoring tools to do mechanical refactoring and running unit tests that cover the refactored code should be enough to increase confidence in the commit.

#### Speed Up Development

Unit tests take time to write, but they also speed up development. The Developer Inner Loop is the process that developers go through as they are authoring code. This varies from developer to developer and language to language but typically is something like code -> build -> run -> repeat. When unit tests are inserted into the inner loop, developers can get early feedback and results from the code they are writing. Since unit tests execute really quickly, running tests shouldn't be seen as a barrier to entry for this loop.

#### Documentation as Code

Writing unit tests is a great way to show how the units of code you are writing are supposed to be used. In some ways, unit tests are better than any documentation or samples because they are (or at least should be) executed with every build so there is confidence that they are not out of date.

### Unit Testing Design Blocks

The **system under test** (abbreviated SUT) is the "unit" we are testing. Generally these are methods or functions, but depending on the language these could be different. In general, you want the unit to be as small as possible though.

### Techniques

#### Abstraction

Abstraction is when we take an exact implementation detail, and we generalize it into a concept instead. For unit tests, abstraction is commonly used to break a hard dependency and replace it with an abstraction. That abstraction then allows for greater flexibility in the code and allows for a mock or simulator to be used in its place.

One of the side effects of abstracting dependencies is that you may have an abstraction that has no test coverage. This is a case where unit testing is not well-suited, you can not expect to unit test everything, things like dependencies will always be an uncovered case. This is why even if you have a robust unit testing suite, integration or functional testing should still be used.

#### Dependency Injection

Dependency injection is a technique which allows us to extract dependencies from our code. In a normal use-case of a dependant class, the dependency is constructed and used within the system under test. This creates a hard dependency between the two classes, which can make it particularly hard to test in isolation.

By injecting the dependencies into our system rather than constructing them, we have "inverted control" of the dependency. Not using dependency injection can lead to code that is not unit testable since there is no way to inject mocked objects. Keeping testability in mind from the beginning and evaluating using dependency injection can save you from a time-intensive refactor later.

One of the downsides of dependency injection is that it can easily go overboard. While there are no longer hard dependencies, there is still coupling between the interfaces, and passing around every interface implementation into every class presents just as many downsides as not using Dependency Injection. Being intentional with what dependencies get injected to what classes, is key to developing a maintainable system.

#### Test-Driven Development

Test-Driven Development (TDD) is a technique for writing your code that will lead you to a testable design from the start. The basic premise of test-driven development is that you come up with a list behaviors you want your system to have. You then take one behavior from the list, write the test, and then modify the system to make the test pass. Then you move on to the next behavior on your list and repeat this process. Once you've exhausted your list, you're done! This approach has the benefit of guaranteeing a testable design is built into the system since the test was written first.

### Best Practices

#### Arrange/Act/Assert

One common form of organizing your unit test code is called Arrange/Act/Assert. This divides up your unit test into 3 different discrete sections:

1. Arrange - Set up all the variables, mocks, interfaces, and state you will need to run the test
2. Act - Run the system under test, passing in any of the above objects that were created
3. Assert - Check that with the given state that the system acted appropriately

Using this pattern to write tests makes them very readable and also familiar to future developers who would need to read your unit tests.

#### Keep Tests Small and Test Only One Thing

Unit tests should be short and test only one thing. This makes it easy to diagnose when there was a failure without needing something like which line number the test failed at. When using Arrange/Act/Assert, think of it like testing just one thing in the "Act" phase.

#### Using a Standard Naming Convention for All Unit Tests

Establishing a standard is not only important for keeping your code consistent, but a good standard also improves the readability and debug-ability of a test. A recommended convention is `UnitName_StateUnderTest_ExpectedResult`. Having descriptive names makes it trivial to find the test when there is a failure, and also already explains what the expectation of the test was and what state caused it to fail.

### Things to Avoid

- **Sleeps** - A sleep can be an indicator that perhaps something is making a request to a dependency that it should not be. Adding sleeps to your unit tests also breaks one of our original tenets of unit testing: tests should be fast, as in order of milliseconds.
- **Reading from disk** - It can be really tempting to put the expected value of a function return in a file and read that file to compare the results. This creates a dependency with the system drive, and it breaks our tenet of keeping our unit tests isolated and 100% reliable.
- **Calling third-party APIs** - When you do not control a third-party library that you are calling into, it's impossible to know for sure what that is doing, and it is best to abstract it out. It is best to wrap third party API calls in interfaces or other structures so that they do not get invoked in unit tests.

### Mocking in Unit Tests

One of the key components of writing unit tests is to remove the dependencies your system has and replacing it with an implementation you control. A test double is a generic term for any "pretend" object used in place of a real one.

#### Stubs

Stub allows you to have predetermined behavior that substitutes real behavior. The dependency (abstract class or interface) is implemented as a stub with a logic as expected by the client. The key concept here is that stubs should never fail a unit or integration test where a mock can. Stubs do not require any sort of framework to run, but are usually supported by mocking frameworks to quickly build the stubs.

**Upsides**: Do not require any framework, easy to set up.
**Downsides**: Can involve rewriting the same code many times, lots of boilerplate.

#### Mocks

Mocks are pre-programmed objects with expectations which form a specification of the calls they are expected to receive. In other words, mocks are a replacement object for the dependency that has certain expectations that are placed on it; those expectations might be things like validating a sub-method has been called a certain number of times or that arguments are passed down in a certain way.

The main difference between a mock and most of the other test doubles is that mocks do **behavioral verification**, whereas other test doubles do **state verification**. The major downside to behavioral verification is that it is tied to the implementation. If tests need to be updated every time because the behavior of the method has changed, then you lose confidence because bugs could also be introduced into the test code.

**Upsides**: Easy to write. Encourages testable design.
**Downsides**: Behavioral testing can present problems with maintainability. Usually requires a framework.

#### Fakes

**Fake** objects actually have working implementations, but usually take some shortcut which may make them not suitable for production. One of the common examples of using a Fake is an in-memory database - typically you want your database to be able to save data somewhere between application runs, but when writing unit tests if you have a fake implementation of your database APIs that store all data in memory, you can use these for unit tests and not break abstraction as well as still keep your tests fast.

Writing a fake does take more time than other test doubles, because they are full implementations, and can have their own suite of unit tests. In this sense though, they increase confidence in your code even more because your test double has been thoroughly tested for bugs before you even use it as a downstream dependency.

**Upsides**: No framework needed. Encourages testable design. Code can be "promoted" to product code.
**Downsides**: Takes more time to implement.

### Unit Testing ML and Data Science Code

The purpose of this section is to provide guidance for testing the most common operations in ML/Data Science projects. Testing the code used for ML or data science projects follows the same principles of any other software project.

Some scenarios might seem different or more difficult to test. The best way to approach this is to always have a test design session, where the focus is on the input/outputs, exceptions and testing the behavior of data transformations. Designing the tests first makes it easier to test as it forces a more modular style, where each function has one purpose, and extracting common functionality functions and modules.

#### Saving and Loading Data

Reading and writing to csv, reading images or loading audio files are common scenarios encountered in ML projects. There's no need to test functions from third-party libraries (e.g. `read_csv`, `isfile`) - we can leave testing them to those library developers. The only thing we need to test is the logic in our functions: that data is loaded if the file exists with the right parameters, and doesn't load the file if it doesn't exist, and that it returns the expected results.

One way to do this would be to provide a sample file and call the function. This requires separate files to be present for the tests to run. This can cause the same test to run on one machine and then fail on a build server which is not a desired behavior.

A much better way is to **mock** calls to file access functions. Instead of calling the real function, we return a predefined return value, or call a stub that doesn't have any side effects. This way no files are needed in the repository to execute the test, and the test will always work the same, independent of what machine it runs on.

#### Using the Same Sample Data for Multiple Tests

If more than one test will use the same sample data, fixtures are a good way to reuse this sample data. The sample data can be the contents of a json file, or a csv, or a DataFrame, or even an image.

The sample data is still hard coded if possible, and does not need to be large. Only add as much sample data as required for the tests to make the tests readable. Use the fixture to return the sample data, and add this as a parameter to the tests where you want to use the sample data.

#### Transforming Data

For cleaning and transforming data, test fixed input and output, but try to limit each test to one verification. For example, create one test to verify the output shape of the data, and one to verify that any padding is made appropriately. To test different inputs and expected outputs automatically, use parametrize.

#### Model Load or Predict

When **unit** testing we should mock model load and model predictions similarly to mocking file access. There may be cases when you want to load your model to do smoke tests, or integration tests. Since these will often take a bit longer to run it's important to be able to separate them from unit tests so that the developers on the team can still run unit tests as part of their test driven development.

#### Basic Unit Tests for ML Models

ML unit tests are not intended to check the accuracy or performance of a model. Unit tests for an ML model is for code quality checks - for example:

- Does the model accept the correct inputs and produce the correctly shaped outputs?
- Do the weights of the model update when running `fit`?

These tests are much closer to a narrow integration test. However, the benefits of having simple tests for the ML model help to stop a poorly configured model from spending hours in training, while still producing poor results.

Examples of how to implement these tests (for Deep Learning models) include:

- Build a model and compare the shape of input layers to that of an example source of data. Then, compare the output layer shape to the expected output.
- Initialize the model and record the weights of each layer. Then, run a single epoch of training on a dummy data set, and compare the weights of the "trained model" - only check if the values have changed.
- Train the model on a dummy dataset for a single epoch, and then validate with dummy data - only validate that the prediction is formatted correctly, this model will not be accurate.

#### Data Validation

An important part of the unit testing is to include test cases for data validation. For example, no data supplied, images that are not in the expected format, data containing null values or outliers to make sure that the data processing pipeline is robust.

#### Model Testing

Apart from unit testing code, we can also test, debug and validate our models in different ways during the training process. Some options to consider at this stage:

- Adversarial and Boundary tests to increase robustness
- Verifying accuracy for under-represented classes

## Integration Testing

Integration testing is a software testing methodology used to determine how well individually developed components, or modules of a system communicate with each other. This method of testing confirms that an aggregate of a system, or sub-system, works together correctly or otherwise exposes erroneous behavior between two or more units of code.

### Why Integration Testing

Because one component of a system may be developed independently or in isolation of another it is important to verify the interaction of some or all components. A complex system may be composed of databases, APIs, interfaces, and more, that all interact with each other or additional external systems. Integration tests expose system-level issues such as broken database schemas or faulty third-party API integration. It ensures higher test coverage and serves as an important feedback loop throughout development.

Compared to unit-tests, integration tests are fewer in quantity, usually run slower, and are more expensive to set up and develop.

> It is important to note the difference between integration and acceptance testing. Integration testing confirms a group of components work together as intended from a technical perspective, while acceptance testing confirms a group of components work together as intended from a business scenario.

### Integration Testing Approaches

#### Big Bang

Big Bang integration testing is when all components are tested as a single unit. This is best for small systems as a system too large may be difficult to localize for potential errors from failed tests. This approach also requires all components in the system under test to be completed which may delay when testing begins.

#### Incremental Testing

Incremental testing is when two or more components that are logically related are tested as a unit. After testing the unit, additional components are combined and tested all together. This process repeats until all necessary components are tested.

**Top Down**: Higher level components are tested following the control flow of a software system. What is commonly referred to as stubs are used to emulate the behavior of lower level modules not yet complete or merged in the integration test.

**Bottom Up**: Lower level modules are tested together. What is commonly referred to as drivers are used to emulate the behavior of higher level modules not yet complete or included in the integration test.

A third approach known as the sandwich or hybrid model combines the bottom up and top down approaches to test lower and higher level components at the same time.

### Things to Avoid

There is a tradeoff a developer must make between integration test code coverage and engineering cycles. With mock dependencies, test data, and multiple environments at test, too many integration tests are infeasible to maintain and become increasingly less meaningful. Too much mocking will slow down the test suite, make scaling difficult, and may be a sign the developer should consider other tests for the scenario such as acceptance or E2E.

Integration tests of complex systems require high maintenance. Avoid testing business logic in integration tests by keeping test suites separate. Do not test beyond the acceptance criteria of the task and be sure to clean up any resources created for a given test.

### Transferring Responsibility to Integration Tests

In some situations it is worth considering to include the integration tests in the inner development loop to provide a sufficient code coverage to ensure the system is working properly. The prerequisite for this approach to be successful is to have integration tests being able to execute at a speed comparable to that of unit tests both locally and in a CI environment.

Instead of several unit tests needed to test a specific case of functionality of the system, one integration scenario is created that covers the entire flow. This covers both the integration between components and the correctness of its business logic. It has the advantage of testing the system as a black box without any knowledge of its internals. Code refactoring has no impact on tests.

## End-to-End Testing

End-to-end (E2E) testing is a software testing methodology to test a functional and data application flow consisting of several sub-systems working together from start to end.

A modern software system consists of its interconnection with multiple sub-systems. These sub-systems can be within the same organization or can be components of different organizations. If there is any failure or fault in any sub-system, it can adversely affect the whole software system leading to its collapse.

### Horizontal E2E Test

This method is used very commonly. It occurs horizontally across the context of multiple applications.

The inbound data may be injected from various sources, but it then "flattens" into a horizontal processing pipeline that may include various components, such as a gateway API, data transformation, data validation, storage, etc. Throughout the entire Extract-Transform-Load (ETL) processing, the data flow can be tracked and monitored under the horizontal spectrum.

### Vertical E2E Test

In this method, all most critical transactions of any application are verified and evaluated right from the start to finish. Each individual layer of the application is tested starting from top to bottom.

Each layer (tier) is required to be fully tested in conjunction with the "connected" layers above and beneath, in which services "talk" to each other during the end to end data flow. This method is much more difficult.

### E2E Test Case Design Guidelines

- Test cases should be designed from the end user's perspective.
- Should focus on testing some existing features of the system.
- Multiple scenarios should be considered for creating multiple test cases.
- Different sets of test cases should be created to focus on multiple scenarios of the system.

## Performance Testing and Profiling

Performance testing is a type of testing intended to determine the responsiveness, throughput, reliability, and/or scalability of a system under a given workload.

### Why Performance Testing

Performance testing is commonly conducted to accomplish one or more of the following:

- **Tune the system's performance**: Identifying bottlenecks and issues at different load levels. Comparing performance characteristics for different system configurations. Come up with a scaling strategy.

- **Assist in capacity planning**: Capacity planning is the process of determining what type of hardware and software resources are required to run an application to support pre-defined performance goals.

- **Assess the system's readiness for release**: Evaluating the system's performance characteristics (response time, throughput) in a production-like environment.

- **Evaluate the performance impact of application changes**: Comparing the performance characteristics after a change to the values during previous runs (or baseline values), can provide an indication of performance regression or enhancements introduced due to a change.

### Key Performance Testing Categories

#### Load Testing

This is the subcategory that focuses on validating the performance characteristics of a system when the system faces the load volumes which are expected during production operation. An **Endurance Test** or a **Soak Test** is a load test carried over a long duration ranging from several hours to days.

#### Stress Testing

This focuses on validating the performance characteristics of a system when the system faces extreme load. The goal is to evaluate how does the system handle being pressured to its limits, does it recover (i.e., scale-out) or does it just break and fail?

#### Spike Testing

The goal of Spike testing is to validate that a system can respond well to large and sudden spikes.

#### Chaos Testing

Chaos testing or Chaos engineering is the practice of experimenting on a system to build confidence that the system can withstand turbulent conditions in production. Its goal is to identify weaknesses before they manifest system wide.

### Performance Best Practices

- **Make one change at a time.** Don't make multiple changes to the system between tests. If you do, you won't know which change caused the performance to improve or degrade.
- **Automate testing.** Strive to automate the setup and teardown of resources for a performance run as much as possible. Manual execution can lead to misconfigurations.

### Performance Monitor Metrics

When executing the various types of testing approaches, it is important to capture various metrics to see how the system performs. At the basic hardware level, there are four areas to consider: Physical disk, Memory, Processor, Network.

These four areas are inextricably linked, meaning that poor performance in one area will lead to poor performance in another area.

| Counter                     | Description |
|:----------------------------|:-----------|
| Avg. Disk Queue Length      | This value describes the disk queue over time. Having any physical disk with an average queue length over 2 for prolonged periods of time can be an indication that your disk is a bottleneck. |
| % Processor time            | The percentage of total elapsed time that the processor was busy executing. 70% is generally considered a good target number. |
| % Privileged (Kernel Mode) time | Measures the percentage of elapsed time the processor spent executing in kernel mode. A high percentage (greater than 25%) may indicate driver or hardware issue. |
| Queue Length                | The number of threads that are ready to execute but waiting for a core to become available. |
| Available MBs               | The amount of memory that is available to applications. Low memory can trigger Page Faults. If available memory dips below 10%, more memory should be obtained. |
| Pages/sec                   | The rate at which pages are being read and written as a result of page faults. Sustained values greater than 50 can mean that system memory is a bottleneck. |
| Bytes Total/sec             | The number of bytes sent and received over the network. |

### ML-Specific Performance Considerations

System metrics to consider:

- CPU/GPU/memory usage
- Cost per prediction
- Time taken to make a prediction

Have goals and hard limits for performance, speed of prediction and costs been established, so they can be considered if trade-offs need to be made?

Some machine learning models achieve high ML performance, but they are costly and time-consuming to run. In those cases, a less performant and cheaper model could be preferred. Hence, it is important to calculate the model performance metrics (accuracy, precision, recall, RMSE etc), but also to gather data on how expensive it will be to run the model and how long it will take to run. Once this data is gathered, an informed decision should be made on what model to productionize.

### Profiling ML Code

Data Science projects, especially the ones that involve Deep Learning techniques, usually are resource intensive. One model training iteration might be multiple hours long. Although large data volumes processing genuinely takes time, minor bugs and suboptimal implementation of some functional pieces might cause extra resources consumption.

Profiling can be used to identify performance bottlenecks and see which functions are the costliest in the application code. Based on the outputs of the profiler, one can focus on largest and easiest-to-resolve inefficiencies and therefore achieve better code performance.

There are two types of profilers: deterministic (all events are tracked, e.g. cProfile) and statistical (sampling with regular intervals, e.g., py-spy).

For PyTorch, the updated PyTorch profiler is supplied together with the PyTorch distribution and doesn't require any additional installation. Using PyTorch profiler one can record CPU side operations as well as CUDA kernel launches on GPU side. The profiler can visualize analysis results using TensorBoard plugin as well as provide suggestions on bottlenecks and potential code improvements.

> Note: one epoch of model training is usually enough for profiling. There's no need to run more epochs and produce additional cost.

> Note: it's not recommended to run profilers simultaneously. Profilers also consume resources, therefore a simultaneous run might significantly affect the results.

### Iterative Performance Test Template

Performance tests are done in iterations and each iteration should have a clear goal. The results of any iteration is immutable regardless whether the goal was achieved or not. If the iteration failed or the goal is not achieved then a new iteration of testing is carried out with appropriate fixes. It is recommended to keep track of the recorded iterations to maintain a timeline of how system evolved and which changes affected the performance in what way.

Each iteration should record:

- **Goal**: In bullet points, the goal for this iteration. The goal should be small and measurable.
- **Date and Duration**: When this iteration started and ended.
- **Application Code**: Commit id and link to the commit for the code being tested.
- **Application Configuration**: Configuration for the application.
- **System Configuration**: Configuration of the infrastructure.
- **Results**: Attach supporting documents, links to dashboards for metrics and logs. Capture screenshots for CPU/Memory/Disk usage.
- **Observations**: Insights derived from test results. Mention outcomes supporting the goal. If any observation results in a work item, add the link.

## Shadow Testing

Shadow testing is one approach to reduce risks before going to production. Shadow testing is also known as "Shadow Deployment" or "Shadowing Traffic".

### When to Use

Shadow Testing reduces risks when you consider replacing the current environment (V-Current) with candidate environment with new feature (V-Next). This approach is monitoring and capturing differences between two environments then compare and reduces all risks before you introduce a new feature/release.

In our test cases, code coverage is very important however sometimes providing code coverage can be tricky to replicate real-life combinations and possibilities. In this approach, to test V-Next environment we have side by side deployment, we're replicating the same traffic with V-Current environment and directing same traffic to V-Next environment, the only difference is we don't return any response from V-Next environment to users, but we collect those responses to compare with V-Current responses.

Referencing back to one of the Principles of Chaos Engineering:

> Systems behave differently depending on environment and traffic patterns. Since the behavior of utilization can change at any time, sampling real traffic is the only way to reliably capture the request path.

With this Shadow Testing approach we're leveraging real customer behavior in V-Next environment with sampling real traffic and mitigating the risks which users may face on production. At the same time we're testing V-Next environment infrastructure for scaling with real sampled traffic. We're testing actual behavior of the product and this causes zero impact to production to test new features since traffic is replicated to V-Next environment.

### Applicable to

- **Production deployments**: V-Next in Shadow testing always working separately and not affecting production. Users are not affected with this test.
- **Infrastructure**: Shadow testing replicating the same traffic, in test environment you can have the same traffic on the production. It helps to produce real life test scenarios.
- **Handling Scale**: All traffic is replicated, and you have a chance to see how your system scales.

### Advantages

- Zero impact to production environment
- No need to generate test scenarios and test data
- We can test real-life scenarios with real-life data
- We can simulate scale with replicated production traffic

## Fault Injection and Robustness Testing

Fault injection testing is the deliberate introduction of errors and faults to a system to validate and harden its stability and reliability. The goal is to improve the system's design for resiliency and performance under intermittent failure conditions over time.

### Problem Addressed

Systems need to be resilient to the conditions that caused inevitable production disruptions. Modern applications are built with an increasing number of dependencies; on infrastructure, platform, network, 3rd party software or APIs, etc. Each dependent component may fail. Furthermore, its interactions with other components may propagate the failure.

Fault injection methods are a way to increase coverage and validate software robustness and error handling, either at build-time or at run-time, with the intention of "embracing failure" as part of the development lifecycle.

### Applicable to

* **Software** - Error handling code paths, in-process memory management.
* **Protocol** - Vulnerabilities in communication interfaces such as command line parameters or APIs. **Fuzzing** provides invalid, unexpected, or random data as input to assess the level of protocol stability of a component.
* **Infrastructure** - Outages, networking issues, hardware failures.

### Terminology

* **Fault** - The adjudged or hypothesized cause of an error.
* **Error** - That part of the system state that may cause a subsequent failure.
* **Failure** - An event that occurs when the delivered service deviates from correct state.
* **Fault-Error-Failure cycle** - A key mechanism in dependability: A fault may cause an error. An error may cause further errors within the system boundary; therefore each new error acts as a fault. When error states are observed at the system boundary, they are termed failures.

### Fault Injection and Chaos Engineering

Fault injection testing is a specific approach to testing one condition. It introduces a failure into a system to validate its robustness. Chaos engineering, coined by Netflix, is a practice for generating new information. There is an overlap in concerns and often in tooling between the terms, and many times chaos engineering uses fault injection to introduce the required effects to the system.

### Hypothesis-Driven Approach

Fault injection tests rely on metrics observability and are usually statistical. The following high-level steps provide a sample of practicing fault injection and chaos engineering:

* Measure and define a steady (healthy) state for the system's interoperability.
* Create hypotheses based on predicted behavior when a fault is introduced.
* Introduce real-world fault-events to the system.
* Measure the state and compare it to the baseline state.
* Document the process and the observations.
* Identify and act on the result.

### Fault Injection in the Development Cycle

Automated fault injection coverage in a CI pipeline promotes a Shift-Left approach of testing earlier in the lifecycle for potential issues. Examples of performing fault injection during the development lifecycle:

* Using fuzzing tools in CI.
* Execute existing end-to-end scenario tests (such as integration or stress tests), which are augmented with fault injection.
* Write regression and acceptance tests based on issues that were found and fixed or based on resolved service incidents.
* Ad-hoc (manual) validations of fault in the dev environment for new features.

### Best Practices

Experimenting in production has the benefit of running tests against a live system with real user traffic, but it has the potential to cause unnecessary pain. Thinking about the **Blast Radius** of the effect, should the test fail, is a crucial step:

* Run tests in a non-production environment first.
* Grow the risk incrementally - Start with hardening the core and expand out in layers. At each point, progress should be locked in with automated regression tests.

## Data Quality and Model Readiness

### Data Quality and Governance

- [ ] There is access to data.
- [ ] Labels exist for dataset of interest.
- [ ] Data quality evaluation.
- [ ] Able to track data lineage.
- [ ] Understanding of where the data is coming from and any policies related to data access.

### Evaluation and Metrics

- [ ] Clear definition of how performance will be measured.
- [ ] The evaluation metrics are somewhat connected to the success criteria.
- [ ] The metrics can be calculated with the datasets available.
- [ ] Evaluation flow can be applied to all versions of the model.
- [ ] Evaluation code is unit-tested and reviewed by all team members.
- [ ] Evaluation flow facilitates further results and error analysis.

### Model Baseline

- [ ] Well-defined baseline model exists and its performance is calculated.
- [ ] The performance of other ML models can be compared with the model baseline.

A good way to think of a model baseline is the simplest model one can come up with: either a simple threshold, a random guess or a very basic linear model. This baseline is the reference point your model needs to outperform.

As an example, for **image classification**: If your classes are unbalanced (70% cats and 30% no cats) and if you always predict cats, your naive classifier has 70% accuracy and this can be your baseline. If your classes are balanced, then a simple convolutional architecture can be the baseline (1 conv layer + 1 max pooling + 1 dense). Additionally, human accuracy at labelling can also be the baseline.

### Are Machine Learning Performance Metrics Defined for Both Training and Scoring?

The methodology of translating the training metrics to scoring metrics should be well-defined and understood. Well-defined ML performance metrics are essential in production so that a decrease or increase in model performance can be accurately detected.

Things to consider:

- If you change the period of assessing the performance, you might get a different result.
- The overall accuracy might be good, but the model may be performing poorly for some subgroups. If this is a significant subgroup for the production data, then your accuracy might suffer greatly when in production.
- If sampling techniques (over-sampling, under-sampling) are used to train a model when classes are imbalanced, ensure the metrics used during training are comparable with the ones used in scoring.
- If the number of samples used for training and testing is small, the performance metrics might change significantly as new data is scored.

### Is the Model Benchmarked?

The trained model is well benchmarked if machine learning performance metrics (such as accuracy, recall, RMSE or whatever is appropriate) are measured on the train and test set. Furthermore, the train and test set split should be well documented and reproducible.

### Data Distribution Analysis

The data distribution of your training, test and validation dataset (including labels) should be analyzed to ensure they all come from the same distribution. If this is not the case, some options to consider are: re-shuffling, re-sampling, modifying the data, more samples need to be gathered or features removed from the dataset.

Some potential questions to ask:

- How much does the training and test data represent the end result?
- Is the distribution of each individual feature consistent across all your datasets?
- Is there any data lineage information? Where did the data come from? How was the data collected?

### Data Quality Monitoring

Data validation best practices include:

- Employing automated data quality testing processes at each stage of the data pipeline
- Re-routing data that fails quality tests to a separate data store for diagnosis and resolution
- Employing end-to-end data observability on data freshness, distribution, volume, schema and lineage

Note that data validation is distinct from data drift detection. Data validation detects errors in the data (ex. a datum is outside of the expected range), while data drift detection uncovers legitimate changes in the data that are truly representative of the phenomenon being modeled (ex. user preferences change). Data validation issues should trigger re-routing and rectification, while data drift should trigger adaptation or retraining of a model.

### Data Drift Monitoring

It is imperative to understand if the new data in production will be significantly different from the data in the training phase. It is also important to check that the data distribution information can be obtained for any of the new data coming in. Drift monitoring can inform when changes are occurring and what their characteristics are (ex. abrupt vs gradual) and guide effective adaptation or retraining strategies to maintain performance.

Possible questions to ask:

- What are some examples of drift, or deviation from the norm, that have been experienced in the past or that might be expected?
- Is there a drift detection strategy in place? Does it align with expected types of changes?
- Are there warnings when anomalies in input data are occurring?
- Is there an adaptation strategy in place? Does it align with expected types of changes?

### Model Performance Monitoring

It is important to define how the model will be monitored when it is in production and how that data is going to be used to make decisions. Ideally, model monitoring should be done automatically.

Model monitoring should lead to:

- Ability to identify changes in model performance
- Warnings when anomalies in model output are occurring
- Retraining decisions and adaptation strategy

## Model Experimentation and Reproducibility

### Goals

- **Performance**: Find the best performing solution
- **Operationalization**: Keep an eye towards production, making sure that operationalization is feasible
- **Code quality**: Maintain code and artifacts quality
- **Reproducibility**: Keep research active by allowing experiment tracking and reproducibility
- **Collaboration**: Foster the collaboration and joint work of multiple people on the team

### Challenges

- **Trial and error process**: Difficult to plan and estimate durations and capacity.
- **Quick and dirty**: We want to fail fast and get a sense of what's working efficiently.
- **Collaboration**: How do we form a team-wide trial and error process and effective brainstorming.
- **Code quality**: How do we maintain the quality of non-production code during research.
- **Operationalization**: Switching between approaches might have a significant impact on operationalization (e.g. GPU/CPU, batch/online, parallel/sequential, runtime environments).

### Virtual Environments

In languages like Python and R, it is always advised to employ virtual environments. Virtual environments facilitate reproducibility, collaboration and productization. These environments' configuration files can be used to build the code from source in a consistent way.

All virtual environments frameworks create isolation, some also propose dependency management and additional features. Decision on which framework to use depends on the complexity of the development environment and on the ease of use of the framework.

- **venv** is included in Python, is the easiest to use, but lacks more advanced features like dependency management.
- **Conda** is a popular package, dependency and environment management framework. It supports multiple stacks (Python, R) and multiple versions of the same environment.
- **Poetry** is a Python dependency management system which manages dependencies in a standard way using `pyproject.toml` files and `lock` files. It provides a robust way to create reproducible and stable environments.

### Experiment Tracking

Experiment tracking tools allow data scientists and researchers to keep track of previous experiments for better understanding of the experimentation process and for the reproducibility of experiments or models.

Expected outcomes:

1. Decide on an experiment tracking framework
2. Ensure it is accessible to all users
3. Document set-up on local environments
4. Define datasets and evaluation in a way which will allow the comparison of all experiments. **Consistency across datasets and evaluation is paramount for experiment comparison**.
5. Ensure full reproducibility by assuring that all required details are tracked (i.e. dataset names and versions, parameters, code, environment)

### Experimentation Setup Checklist

- [ ] Well-defined train/test dataset with labels.
- [ ] Reproducible and logged experiments in an environment accessible by all data scientists to quickly iterate.
- [ ] Defined experiments/hypothesis to test.
- [ ] Results of experiments are documented.
- [ ] Model hyper parameters are tuned systematically.
- [ ] Same performance evaluation metrics and consistent datasets are used when comparing candidate models.

### Datasets and Models Abstractions

By creating abstractions to building blocks (e.g., datasets, models, evaluators), we allow the easy introduction of new logic into the experimentation pipeline while keeping the agreed upon experimentation flow intact.

Expected outcomes:

1. Different building blocks have defined APIs allowing them to be replaced or extended.
2. Replacing building blocks does not break the original experimentation flow.
3. Mock building blocks are used for unit tests.
4. APIs/mocks are shared with the engineering teams for integration with other modules.

### Model Evaluation Checklist

- [ ] Evaluation logic is approved by all stakeholders.
- [ ] Relationship between evaluation logic and business KPIs is analyzed and decided.
- [ ] Evaluation flow is applicable for all present and future models (i.e. does not assume some prediction structure or method-specific process).
- [ ] Evaluation code is unit-tested and reviewed by all team members.
- [ ] Evaluation flow facilitates further results and error analysis.

### Source Control and Folder Structure

Applied ML projects often contain source code, notebooks, devops scripts, documentation, scientific resources, datasets and more. We recommend coming up with an agreed folder structure to keep resources tidy. Consider deciding upon a generic folder structure for projects (e.g. which contains the folders `data`, `src`, `docs` and `notebooks`), or adopt popular structures like the CookieCutter Data Science folder structure.

Source control should be applied to allow collaboration, versioning, code reviews, traceability and backup. In data science projects, source control should be used for code, and the storing and versioning of other artifacts (e.g. data, scientific literature) should be decided upon depending on the scenario.

Expected outcomes:

- Defined folder structure for all users to use, pushed to the repo.
- `.gitignore` file determining which folders should be synced with `git` and which should be kept locally.
- Determine how notebooks are stored and versioned (e.g. strip output from Jupyter notebooks).

## Test Planning

We should be intentional when we think about how to test our applications. One way to make sure that we are testing the right things is to build test plans for various scenarios and work out test cases at the design stage.

### Building Test Cases

As we design the code we can start by defining a set of test cases that will ensure that all acceptance criteria are met. Going through this exercise doesn't only produce test cases, it also helps clarify the acceptance criteria and informs how we should build the solution.

1. **Understand the Acceptance Criteria** - Thoroughly read and understand the acceptance criteria. Clarify any ambiguities.
2. **Identify Test Scenarios** - Consider both positive and negative scenarios (happy paths, and error cases) to cover edge cases. Determine what is in and out of scope.
3. **Define Test Cases** - For each test scenario, define detailed test cases. Each test case should be documented with:
    - **TestCase Title:** What is being tested
    - **Preconditions:** Any setup or test data required before executing the test
    - **Test Steps:** Step-by-step instructions to execute the test
    - **Expected Result:** The expected outcome of the test

    The test can be described in the Given-When-Then format:

    **Given** the initial context or state, **When** the action or event, **Then** the precise outcome

4. **Automate where Possible** - If feasible, automate the test cases. Focus on automating hot paths, and critical areas.
5. **Review and Refine** - Review the test cases with peers or stakeholders. Refine based on feedback.

### Grouping Test Cases into Test Plans

We can create different test plans and organize the test cases under these test plans. Benefits:

- We can make sure that all aspects of the application are tested, including functional, non-functional and edge cases
- They provide clear objectives and scope, which helps developers understand what needs to be tested
- They help manage and execute tests systematically
- By identifying and prioritizing test cases based on risk, test plans help us focus on the most critical areas
- They help us understand what tests are most important to automate

### Common Test Plans

- **Full Regression Test Plan**: To verify that recent changes have not adversely affected existing functionality. Includes all functional, integration, and system test cases.
- **Smoke Test Plan**: To perform a quick check to ensure that the most critical functionalities are working. Basic functionality and high-priority test cases.
- **Functional Test Plan**: To verify that each function conforms to the specification. Test cases that validate specific functionality and business logic.
- **Area Regression Test Plan**: To verify that changes in a specific area have not affected other parts. Test cases related to the specific area and its integration points.
- **Load Test Plan**: To determine how the system performs under heavy load conditions. Test cases that simulate high usage and measure response times.

### How to Group Test Cases into a Test Plan

1. **Identify the Scope:** Determine the scope of each test plan based on testing objectives
2. **Select Relevant Test Cases:** Choose test cases that align with the scope and objectives of each test plan
3. **Organize Test Cases:** Group the selected test cases into the respective test plans
4. **Review and Validate:** Review the grouped test cases to ensure they cover all necessary aspects
5. **Document the Test Plans:** Clearly document each test plan, including the purpose, scope, and list of test cases

## Continuous Integration

### Why CI

- We want to have an automated build and deployment of our software
- We want automated configuration of all components
- We want to be able to quickly re-build the environment from scratch in case of disaster
- We want the latest version of the code to always be deployed to our dev/test environments
- We want a reliable release strategy, where the policies for release are well understood by all

### Goals

Continuous integration automation is an integral part of the software development lifecycle intended to reduce build integration errors and maximize velocity. A robust build automation pipeline will:

- Accelerate team velocity
- Prevent integration problems
- Avoid last minute chaos during release dates
- Provide a quick feedback cycle for system-wide impact of local changes
- Separate build and deployment stages
- Measure and report metrics around build failures / successes
- Increase visibility across the team enabling tighter communication
- Reduce human errors, which is probably the most important part of automating the builds

### Build Automation

An automated build should encompass the following principles:

- **Build Task**: A single step within your build pipeline that compiles your code project into a single build artifact.
- **Unit Testing**: Your build definition includes validation steps to execute a suite of automated unit tests to ensure that application components meets its design and behaves as intended.
- **Code Style Checks**: Code across an engineering team must be formatted to agreed coding standards. Such standards keep code consistent, and most importantly easy for the team to read and refactor. Code standards are maintained within a single configuration file. There should be a step in your build pipeline that asserts code in the latest commit conforms to the known style definition.
- **Build Script Target**: A single command should have the capability of building the system. This is also true for builds running on a CI server or on a developers local machine.
- **No IDE Dependencies**: It's essential to have a build that's runnable through standalone scripts and not dependent on a particular IDE.

### Integration Validation

An effective way to identify bugs in your build at a rapid pace is to invest early into a reliable suite of automated tests that validate the baseline functionality of the system:

- Include tests in your pipeline to validate the build candidate conforms to automated functionality assertions. Any bugs or broken code should be reported in the test results including the failed test and relevant stack trace. All tests should be invoked through a single command.
- Keep the build fast. Consider automated test runtime when deciding to pull in dependencies like databases, external services and mock data loading into your test harness. Slow builds often become a bottleneck for dev teams when parallel builds on a CI server are not an option.

### Avoid Checking in Broken Builds

Automated build checks, tests, lint runs, etc should be validated locally before committing your changes to the repository. Test Driven Development is a practice dev crews should consider to help identify bugs and failures as early as possible within the development lifecycle.

### Code Coverage Checks

We recommend integrating code coverage tools within your build stage. Most coverage tools fail builds when the test coverage falls below a minimum threshold (80% coverage). The coverage report should be published to your CI system to track a time series of variations.

### Git Driven Workflow

- **Build on Commit**: Every commit to the baseline repository should trigger the CI pipeline to create a new build candidate. Build artifacts are built, packaged, validated and deployed continuously into a non-production environment per commit.
- **Avoid Commenting Out Failing Tests**: Avoid commenting out tests in the mainline branch. By commenting out tests, we get an incorrect indication of the status of the build.
- **Branch Policy Enforcement**: Protected branch policies should be setup on the main branch to ensure that CI stages have passed prior to starting a code review. Broken builds should block pull request reviews. Prevent commits directly into main branch.

### GitHub Actions Workflows

A workflow is a configurable automated process made up of one or more jobs where each of these jobs can be an action in GitHub. Currently, a YAML file format is supported for defining a workflow in GitHub.

The general approach is to have one pipeline, where the code is built, tested and deployed, and the artifact is then promoted to the next environment, eventually to be deployed into production.

There are multiple ways in GitHub that an environment setup can be achieved. One way is to have one workflow for multiple environments, but the complexity increases as additional processes and jobs are added. The plus point of having one workflow is that when an artifact flows from one environment to another the state and environment values between the deployment environments can be passed easily.

One way to get around the complexity of a single workflow is to have separate workflows for different environments, making sure that only the artifacts created and validated are promoted from one environment to another. Multiple workflows also helps to keep the deployments to the environments independent thus reducing the time to deploy and find issues earlier. Also, since the environments are independent of each other, any failures in deploying to one environment does not block deployments to other environments. One tradeoff in this method is that with different workflows for each environment, the maintenance increases as the complexity of workflows increase over time.

### CI with Jupyter Notebooks

A Data Science repository often has notebooks alongside scripts. Since notebooks require conversion for effective code review, a CI pipeline can automate this process: trigger on `.ipynb` file changes, convert notebooks to scripts using `nbconvert`, and commit the generated scripts back to the repository. This way, data scientists don't need to execute anything locally, and PR reviewers can add comments to the Python scripts.

## Map of Outcomes to Testing Techniques

| When I am working on... | I want to get this outcome... | ...so I should consider |
| -- | -- | -- |
| Development | Ensure program logic is correct for a variety of expected, mainline, edge and unexpected inputs | Unit testing; Functional tests; Integration testing |
| Development | Prevent regressions in logical correctness; earlier is better | Unit testing; Functional tests; Integration testing |
| Development | Validate that multiple components function together across multiple interfaces in a call chain | Integration testing; End-to-end tests |
| Development | Prove backward compatibility with existing callers and clients | Shadow testing |
| Development | Detect and prevent 'noisy neighbor' phenomena | Load testing |
| Development | Prevent regression in 'composite' scenario use cases / workflows | End-to-end testing |
| Development | Detect availability drops | Synthetic transaction testing |
| Development; Staging | Prove production system of provisioned capacity meets goals for reliability, availability, resource consumption, performance | Load testing (stress); Performance testing |
| Development; Staging | Understand key user experience performance characteristics - latency, chattiness, resiliency | Load testing; Performance testing |
| Development; Staging; Operation | Discover melt points (the loads at which failure occurs) for each individual component | Squeeze; Load testing (stress) |
| Development; Operation | Discover points where a system is not resilient to unpredictable yet inevitable failures | Chaos testing |

## Resources

### Testing
- [Unit Testing Best Practices](https://learn.microsoft.com/en-us/dotnet/core/testing/unit-testing-best-practices)
- [Martin Fowler - Mocks Aren't Stubs](https://martinfowler.com/articles/mocksArentStubs.html)
- [Integration Testing Approaches](https://www.softwaretestinghelp.com/what-is-integration-testing/)
- [Google SRE Book - System Tests](https://landing.google.com/sre/sre-book/chapters/testing-reliability/)
- [Towards Robust and Verified AI: Specification Testing, Robust Training, and Formal Verification](https://medium.com/@deepmindsafetyresearch/towards-robust-and-verified-ai-specification-testing-robust-training-and-formal-verification-69bd1bc48bda)

### Performance and Profiling
- [PyTorch Profiler Recipe](https://pytorch.org/tutorials/recipes/recipes/profiler_recipe.html)
- [Introducing PyTorch Profiler](https://pytorch.org/blog/introducing-pytorch-profiler-the-new-and-improved-performance-tool/)
- [The Python Profilers](https://docs.python.org/3/library/profile.html)

### ML Experimentation
- [CookieCutter Data Science](https://drivendata.github.io/cookiecutter-data-science/)
- [How To Get Baseline Results And Why They Matter](https://machinelearningmastery.com/how-to-get-baseline-results-and-why-they-matter/)
- [Always start with a stupid model, no exceptions](https://blog.insightdatascience.com/always-start-with-a-stupid-model-no-exceptions-3a22314b9aaa)
- [Learning Under Concept Drift: A Review](https://arxiv.org/pdf/2004.05785.pdf)
- [Understanding Dataset Shift](https://towardsdatascience.com/understanding-dataset-shift-f2a5a262a766)
- [Data Quality Fundamentals by Moses et al.](https://www.oreilly.com/library/view/data-quality-fundamentals/9781098112035/)

### CI/CD
- [Martin Fowler's Continuous Integration Best Practices](https://martinfowler.com/articles/continuousIntegration.html)
- [GitHub Actions](https://docs.github.com/en/actions)
- [GitHub Workflows](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [The One Page Test Plan](https://www.ministryoftesting.com/articles/the-one-page-test-plan)
