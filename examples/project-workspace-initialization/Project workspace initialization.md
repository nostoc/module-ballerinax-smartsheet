# Project Workspace Initialization

This example demonstrates how to automate the setup of a complete project workspace in Smartsheet, including creating a workspace, organizing folder structure for different project phases, and setting up an initial project tracking sheet.

## Prerequisites

1. **Smartsheet Setup**
   > Refer the [Smartsheet setup guide](https://central.ballerina.io/ballerinax/smartsheet/latest#setup-guide) here.

2. For this example, create a `Config.toml` file with your credentials:

```toml
accessToken = "<Your Access Token>"
```

## Run the Example

Execute the following command to run the example. The script will print its progress to the console.

```shell
bal run
```

The script will perform the following automated setup steps:
1. Create a new workspace named "Project Alpha - Q4 2024"
2. Create organized folder structure for project phases (Planning, Design, Development, Testing, Deployment)
3. Set up an initial project tracking sheet for team collaboration