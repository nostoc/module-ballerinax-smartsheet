# Sheet Collaboration Setup

This example demonstrates how to set up a comprehensive sheet monitoring and collaboration system using Smartsheet. The script retrieves all sheets in an organization, configures automated webhook notifications for real-time updates, and establishes sharing permissions for project stakeholders.

## Prerequisites

1. **Smartsheet Setup**
   > Refer the [Smartsheet setup guide](https://central.ballerina.io/ballerinax/smartsheet/latest#setup-guide) here.

2. For this example, create a `Config.toml` file with your credentials:

```toml
accessToken = "<Your Access Token>"
```

## Run the example

Execute the following command to run the example. The script will print its progress to the console.

```shell
bal run
```

The script will:
1. Retrieve and display all sheets in your organization
2. Set up automated webhook notifications for the first sheet
3. Configure sharing permissions for project stakeholders (project manager, team lead, and stakeholder)