# Subsidiary Organizational Setup

This example demonstrates how to automate the setup of B2B organizational structures for a newly acquired subsidiary using SAP Commerce. The script creates organizational units, cost centers for different departments, and allocates budgets with proper spending controls.

## Prerequisites

1. **SAP Commerce Setup**
   > Refer the [SAP Commerce setup guide](https://central.ballerina.io/ballerinax/sap.commerce/latest#setup-guide) here.

2. For this example, create a `Config.toml` file with your credentials:

```toml
clientId = "<Your Client ID>"
clientSecret = "<Your Client Secret>"
tokenUrl = "http://localhost:9001/occ/v2/authorizationserver/oauth/token"
serviceUrl = "http://localhost:9001/occ/v2"
baseSiteId = "electronics-spa"
userId = "procurement.manager@company.com"
```

## Run the example

Execute the following command to run the example. The script will print its progress to the console as it creates the organizational structure.

```shell
bal run
```

The script will perform the following operations:
1. Create an organizational unit for the ACME Corp subsidiary
2. Set up cost centers for IT, Marketing, and Operations departments
3. Allocate budgets of $50,000, $75,000, and $100,000 respectively
4. Display a summary of the complete organizational setup