# Sheet Collaboration Workflow

This example demonstrates a comprehensive Smartsheet collaboration workflow that automates sheet sharing with team members at different access levels and sets up email notifications for project updates.

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

The workflow will:
- Retrieve all sheets and identify project-related ones
- Share sheets with core team members (Editor access)
- Share sheets with stakeholders (Viewer access)  
- Set up automated email notifications for updates