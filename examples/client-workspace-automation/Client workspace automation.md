# Client Workspace Automation

This example demonstrates how to automate the setup of a complete project management workspace in Smartsheet for new client projects. The script creates a dedicated workspace, establishes an organized folder structure, and configures real-time monitoring through webhooks.

## Prerequisites

1. **Smartsheet Setup**
   > Refer the [Smartsheet setup guide](https://central.ballerina.io/ballerinax/smartsheet/latest#setup-guide) here.

2. For this example, create a `Config.toml` file with your credentials:

```toml
smartsheetAccessToken = "<Your Smartsheet Access Token>"
webhookCallbackUrl = "<Your Webhook Callback URL>"
clientProjectName = "<Your Client Project Name>"
```

## Run the example

Execute the following command to run the example. The script will print its progress to the console.

```shell
bal run
```

The script will:
- Create a dedicated workspace for the client project
- Set up 5 organizational folders for project management
- Configure a webhook for real-time activity monitoring
- Display confirmation messages for each completed step