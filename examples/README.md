# Examples

The `sap.commerce` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples), covering use cases like B2B order management, product support ticketing, and catalog navigation workflow.

1. [B2B order management](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples/b2b-order-management) - Integrate SAP Commerce to manage business-to-business order processing and fulfillment workflows.

2. [Product support ticketing](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples/product-support-ticketing) - Create and manage customer support tickets for product-related inquiries and issues.

3. [Catalog navigation workflow](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples/catalog-navigation-workflow) - Implement product catalog browsing and navigation functionality for e-commerce applications.

4. [Subsidiary organizational setup](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples/subsidiary-organizational-setup) - Configure organizational structures and hierarchies for subsidiary companies within SAP Commerce.

## Prerequisites

1. Generate SAP Commerce credentials to authenticate the connector as described in the [Setup guide](https://central.ballerina.io/ballerinax/sap.commerce/latest#setup-guide).

2. For each example, create a `Config.toml` file the related configuration. Here's an example of how your `Config.toml` file should look:

    ```toml
    token = "<Access Token>"
    ```

## Running an Example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```