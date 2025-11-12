
# Ballerina sap.commerce connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/actions/workflows/build-with-bal-test-graalvm.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-sap.commerce.svg)](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/sap.commerce.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%sap.commerce)

## Overview

[SAP Commerce](https://www.sap.com/products/crm/commerce.html) is a comprehensive e-commerce platform that enables businesses to deliver personalized, omnichannel customer experiences across all touchpoints, from B2B and B2C commerce to mobile and social channels.

The `ballerinax/sap.commerce` package offers APIs to connect and interact with [SAP Commerce API](https://help.sap.com/docs/SAP_COMMERCE_CLOUD_PUBLIC_CLOUD/9d346683b0084da2938be8a285c0c27a/8c91f3a486691014b085fb11c44412fc.html) endpoints, specifically based on [SAP Commerce REST API v2](https://help.sap.com/docs/SAP_COMMERCE_CLOUD_PUBLIC_CLOUD/9d346683b0084da2938be8a285c0c27a/8c91f3a486691014b085fb11c44412fc.html).
## Setup guide

To use the SAP Commerce connector, you must have access to the SAP Commerce Cloud API through a [SAP Commerce Cloud developer account](`https://developers.sap.com/topics/commerce-cloud.html`) and obtain an API access token. If you do not have a SAP Commerce Cloud account, you can sign up for one [here](`https://www.sap.com/products/crm/commerce-cloud.html`).

### Step 1: Create a SAP Commerce Cloud Account

1. Navigate to the [SAP Commerce Cloud website](`https://www.sap.com/products/crm/commerce-cloud.html`) and sign up for an account or log in if you already have one.

2. Ensure you have a valid SAP Commerce Cloud subscription, as the SAP Commerce Cloud APIs are only available to licensed customers with active subscriptions.

### Step 2: Generate an API Access Token

1. Log in to your SAP Commerce Cloud Portal.

2. Navigate to the Administration area and select API Credentials.

3. Click on Create New Credential and select the appropriate OAuth client type for your integration needs.

4. Configure the client settings including grant types and scopes, then generate the client credentials (client ID and client secret).

5. Use these credentials to obtain an OAuth access token through the SAP Commerce Cloud OAuth endpoint.

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

final sapcommerce:Client sapcommerceClient = check new({
    auth: {
        clientId,
        clientSecret,
        refreshToken
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Create a cost center

```ballerina
public function main() returns error? {
    sapcommerce:B2BCostCenter newCostCenter = {
        code: "CC001",
        name: "Marketing Department",
        activeFlag: true,
        currency: {
            isocode: "USD",
            name: "US Dollar"
        }
    };

    sapcommerce:B2BCostCenter response = check sapcommerceClient->createCostCenter("electronics", newCostCenter);
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```
## Examples

The `sap.commerce` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples), covering the following use cases:

1. [B2b order management](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples/b2b-order-management) - Demonstrates how to manage business-to-business order processing workflows using Ballerina connector for SAP Commerce.
2. [Product support ticketing](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples/product-support-ticketing) - Illustrates creating and managing product support tickets and customer service workflows.
3. [Catalog navigation workflow](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples/catalog-navigation-workflow) - Shows how to navigate and interact with product catalogs and category structures.
4. [Subsidiary organizational setup](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples/subsidiary-organizational-setup) - Demonstrates setting up organizational structures and subsidiary configurations.
## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

    > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

    > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

    ```bash
    ./gradlew clean build
    ```

2. To run the tests:

    ```bash
    ./gradlew clean test
    ```

3. To build the without the tests:

    ```bash
    ./gradlew clean build -x test
    ```

4. To run tests against different environments:

    ```bash
    ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
    ```

5. To debug the package with a remote debugger:

    ```bash
    ./gradlew clean build -Pdebug=<port>
    ```

6. To debug with the Ballerina language:

    ```bash
    ./gradlew clean build -PbalJavaDebug=<port>
    ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToCentral=true
    ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).


## Useful links

* For more information go to the [`sap.commerce` package](https://central.ballerina.io/ballerinax/sap.commerce/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
