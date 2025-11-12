# SAP Commerce Catalog Navigation Workflow

This example demonstrates how to navigate and retrieve product catalog hierarchies from SAP Commerce, including fetching catalogs, examining catalog structures, and retrieving category information for building navigation menus.

## Prerequisites

1. **SAP Commerce Setup**
   > Refer the [SAP Commerce setup guide](https://central.ballerina.io/ballerinax/sap.commerce/latest) here.

2. For this example, create a `Config.toml` file with your credentials:

```toml
clientId = "<Your Client ID>"
clientSecret = "<Your Client Secret>"
serviceUrl = "http://localhost:9001/occ/v2"
baseSiteId = "electronics"
```

## Run the Example

Execute the following command to run the example. The script will print its progress to the console as it navigates through the catalog hierarchy.

```shell
bal run
```

The workflow will:
1. Retrieve all available product catalogs for the site
2. Examine specific catalog structure
3. Fetch detailed category information for navigation menu
4. Retrieve subcategory information for complete navigation structure