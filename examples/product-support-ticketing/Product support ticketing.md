# Product Support Ticketing

This example demonstrates how to create a comprehensive B2B customer support system using SAP Commerce. The script retrieves product information, analyzes customer reviews, and creates a detailed support ticket with full product context for faster issue resolution.

## Prerequisites

1. **SAP Commerce Setup**
   > Refer to the [SAP Commerce setup guide](https://central.ballerina.io/ballerinax/sap.commerce/latest) to obtain the necessary credentials and configure your SAP Commerce instance.

2. For this example, create a `Config.toml` file with your credentials:

```toml
clientId = "<Your Client ID>"
clientSecret = "<Your Client Secret>"
tokenUrl = "http://localhost:9001/occ/v2/authorizationserver/oauth/token"
serviceUrl = "http://localhost:9001/occ/v2"
```

## Run the example

Execute the following command to run the example. The script will print its progress to the console as it gathers product information, analyzes reviews, and creates a support ticket.

```shell
bal run
```

The script will:
1. Initialize the SAP Commerce client
2. Retrieve product information from the cameras category
3. Analyze product reviews for common issues
4. Create a comprehensive support ticket with all gathered context