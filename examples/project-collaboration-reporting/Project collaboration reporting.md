# Project Collaboration Reporting

This example demonstrates how to automate project collaboration analysis by retrieving all sheets from a Smartsheet organization, analyzing discussions and comments for each project, and generating comprehensive collaboration reports that are automatically emailed to stakeholders.

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