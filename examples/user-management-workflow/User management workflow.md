# User Management Workflow

This example demonstrates a comprehensive user management workflow using Smartsheet, including auditing existing users, adding new team members with appropriate permissions, and setting up automated webhooks for real-time activity monitoring.

## Prerequisites

1. **Smartsheet Setup**
   > Refer the [Smartsheet setup guide](https://central.ballerina.io/ballerinax/smartsheet/latest#setup-guide) here.

2. For this example, create a `Config.toml` file with your credentials:

```toml
smartsheetToken = "<Your Smartsheet Token>"
```

## Run the example

Execute the following command to run the example. The script will print its progress to the console.

```shell
bal run
```

The workflow will:
- Retrieve and audit the current list of users in your organization
- Add new team members (a project coordinator and a team member) with different permission levels
- Set up automated webhooks for user management and sheet activity monitoring
- Display a summary of all completed operations