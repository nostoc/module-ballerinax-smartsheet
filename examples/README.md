# Examples

The `smartsheet` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-smartsheet/tree/main/examples), covering use cases like sheet collaboration setup, project workspace initialization, and project health monitoring.

1. [Sheet collaboration setup](https://github.com/ballerina-platform/module-ballerinax-smartsheet/tree/main/examples/sheet-collaboration-setup) - Set up collaboration features and permissions for Smartsheet sheets to enable team workflows.

2. [Project workspace initialization](https://github.com/ballerina-platform/module-ballerinax-smartsheet/tree/main/examples/project-workspace-initialization) - Initialize a complete project workspace with sheets, folders, and templates for project management.

3. [Project health monitoring](https://github.com/ballerina-platform/module-ballerinax-smartsheet/tree/main/examples/project-health-monitoring) - Monitor and track the health status of projects by analyzing sheet data and generating reports.

4. [Project collaboration audit](https://github.com/ballerina-platform/module-ballerinax-smartsheet/tree/main/examples/project-collaboration-audit) - Audit collaboration activities and user interactions within project sheets for compliance tracking.

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