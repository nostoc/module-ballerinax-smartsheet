# Project Health Monitoring

This example demonstrates how to set up an automated project portfolio health monitoring system using Smartsheet. The script retrieves workspace information, configures automated email reports for stakeholders, and establishes webhooks for real-time project metrics monitoring.

## Prerequisites

1. **Smartsheet Setup**
   > Refer the [Smartsheet setup guide](https://central.ballerina.io/ballerinax/smartsheet/latest#setup-guide) here.

2. For this example, create a `Config.toml` file with your credentials:

```toml
accessToken = "<Your Access Token>"
projectReportId = 1234567890
callbackUrl = "<Your Callback URL>"
```

## Run the example

Execute the following command to run the example. The script will print its progress to the console.

```shell
bal run
```