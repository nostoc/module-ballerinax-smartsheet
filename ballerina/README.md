## Overview

[SAP Commerce](https://www.sap.com/products/crm/commerce.html) is a comprehensive e-commerce platform that enables businesses to deliver personalized, omnichannel customer experiences across all touchpoints, from B2B and B2C commerce to mobile and social channels.

The `ballerinax/sap.commerce` package offers APIs to connect and interact with [SAP Commerce API](https://help.sap.com/docs/SAP_COMMERCE_CLOUD_PUBLIC_CLOUD/0185aa721ea64c8fb7b1e9eff4c1c0e9/8c91f3a486691014b085fb1c153a4a7b.html) endpoints, specifically based on [SAP Commerce REST API v2](https://help.sap.com/docs/SAP_COMMERCE_CLOUD_PUBLIC_CLOUD/0185aa721ea64c8fb7b1e9eff4c1c0e9/715c5d01865c4e4dbe1f5db7bd5c2677.html).
## Setup guide

To use the SAP Commerce connector, you must have access to the SAP Commerce Cloud API through an [SAP Commerce Cloud developer account](`https://developers.sap.com/topics/sap-commerce-cloud.html`) and obtain an API access token. If you do not have an SAP Commerce Cloud account, you can sign up for one [here](`https://www.sap.com/products/crm/commerce-cloud.html`).

### Step 1: Create an SAP Commerce Cloud Account

1. Navigate to the [SAP Commerce Cloud website](`https://www.sap.com/products/crm/commerce-cloud.html`) and sign up for an account or log in if you already have one.

2. Ensure you have a valid SAP Commerce Cloud subscription, as the API access requires an active Commerce Cloud environment with appropriate licensing.

### Step 2: Generate an API Access Token

1. Log in to your SAP Commerce Cloud Administration Console.

2. Navigate to System → API → OAuth2 and select the OAuth2 tab.

3. Create a new OAuth2 client by clicking "Create OAuth2 Client" and configure the client credentials with the required scopes for your integration.

4. Generate the access token using the client credentials flow with your OAuth2 client ID and secret.

> **Tip:** You must copy and store this key somewhere safe. It won't be visible again in your account settings for security reasons.
## Quickstart

To use the `SAP Commerce` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerina/oauth2;
import ballerinax/sap.commerce as sapcommerce;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file with your credentials:

```toml
clientId = "<Your_Client_Id>"
clientSecret = "<Your_Client_Secret>"
refreshToken = "<Your_Refresh_Token>"
```

2. Create a `sapcommerce:ConnectionConfig` and initialize the client:

```ballerina
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

final sapcommerce:Client sapCommerceClient = check new({
    auth: {
        clientId,
        clientSecret,
        refreshToken
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Create a new cost center

```ballerina
public function main() returns error? {
    sapcommerce:B2BCostCenter newCostCenter = {
        code: "CC-001",
        name: "Marketing Department",
        activeFlag: true,
        currency: {
            isocode: "USD",
            name: "US Dollar",
            active: true
        }
    };

    sapcommerce:B2BCostCenter response = check sapCommerceClient->createCostCenter("electronics", newCostCenter);
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```
## Examples

The `sap.commerce` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples), covering the following use cases:

1. [B2b order management](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples/b2b-order-management) - Demonstrates how to manage business-to-business orders using Ballerina connector for SAP Commerce.
2. [Product support ticketing](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples/product-support-ticketing) - Illustrates creating and managing product support tickets and customer service workflows.
3. [Catalog navigation workflow](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples/catalog-navigation-workflow) - Shows how to navigate and interact with product catalogs and category structures.
4. [Subsidiary organizational setup](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples/subsidiary-organizational-setup) - Demonstrates setting up organizational structures for subsidiary companies and business units.