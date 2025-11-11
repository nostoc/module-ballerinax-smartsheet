# Project Collaboration Audit

This example demonstrates how to perform a comprehensive audit of project-related Smartsheet documents by searching for sheets containing specific keywords, analyzing their access levels and sharing configurations, and automatically sending detailed audit reports to stakeholders via email.

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

The script will perform the following steps:
1. Search for sheets containing project keywords ("Project Alpha", "Marketing Campaign", "Q4 Initiative")
2. Retrieve detailed information for all found sheets including access levels and sharing configurations
3. Generate comprehensive audit reports and send them via email to specified stakeholders
4. Display a summary of the audit findings including access level distribution and sharing statistics