# B2B Order Management

This example demonstrates how to manage B2B e-commerce orders using SAP Commerce, including retrieving order details, fetching compliance documentation attachments, processing order cancellations, and checking updated order status.

## Prerequisites

1. **SAP Commerce Setup**
   > Refer the [SAP Commerce setup guide](https://central.ballerina.io/ballerinax/sap.commerce/latest#setup-guide) here.

2. For this example, create a `Config.toml` file with your credentials:

```toml
clientId = "<Your Client ID>"
clientSecret = "<Your Client Secret>"
serviceUrl = "http://localhost:9001/occ/v2"
baseSiteId = "electronics"
userId = "b2badmin@example.com"
```

## Run the example

Execute the following command to run the example. The script will print its progress to the console.

```shell
bal run
```

The script will:
1. Retrieve B2B order details for order "B2B-ORDER-001"
2. Fetch compliance documentation attachments for the order
3. Process a partial order cancellation request
4. Retrieve the updated order status after cancellation