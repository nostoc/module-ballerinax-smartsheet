# Examples

The `smartsheet` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-smartsheet/tree/main/examples), covering use cases like user management workflows, sheet collaboration workflows, and project collaboration reporting.

1. [User management workflow](https://github.com/ballerina-platform/module-ballerinax-smartsheet/tree/main/examples/user-management-workflow) - Manage user accounts and permissions within Smartsheet workspaces.

2. [Sheet collaboration workflow](https://github.com/ballerina-platform/module-ballerinax-smartsheet/tree/main/examples/sheet-collaboration-workflow) - Facilitate collaborative workflows for shared Smartsheet documents.

3. [Project collaboration reporting](https://github.com/ballerina-platform/module-ballerinax-smartsheet/tree/main/examples/project-collaboration-reporting) - Generate comprehensive reports for project collaboration activities in Smartsheet.

4. [Client workspace automation](https://github.com/ballerina-platform/module-ballerinax-smartsheet/tree/main/examples/client-workspace-automation) - Automate workspace management and client onboarding processes in Smartsheet.

## Prerequisites

1. Generate Smartsheet credentials to authenticate the connector as described in the [Setup guide](https://central.ballerina.io/ballerinax/smartsheet/latest#setup-guide).

2. For each example, create a `Config.toml` file the related configuration. Here's an example of how your `Config.toml` file should look:

    ```toml
    token = "<Access Token>"
    ```

## Running an Example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```