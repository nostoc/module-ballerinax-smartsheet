## Overview

[sap.commerce](https://www.sap.commerce.com/) is a cloud-based platform that enables teams to plan, capture, manage, automate, and report on work at scale, empowering you to move from idea to impact, fast.

The `ballerinax/sap.commerce` package offers APIs to connect and interact with [sap.commerce API](https://developers.sap.commerce.com/api/sap.commerce/introduction) endpoints, specifically based on [sap.commerce API v2.0](https://developers.sap.commerce.com/api/sap.commerce/openapi).


## Setup guide

To use the sap.commerce connector, you must have access to the sap.commerce API through a [sap.commerce developer account](https://developers.sap.commerce.com/) and obtain an API access token. If you do not have a sap.commerce account, you can sign up for one [here](https://www.sap.commerce.com/try-it).

### Step 1: Create a sap.commerce Account

1. Navigate to the [sap.commerce website](https://www.sap.commerce.com/) and sign up for an account or log in if you already have one.

2. Ensure you have a Business or Enterprise plan, as the sap.commerce API is restricted to users on these plans.

### Step 2: Generate an API Access Token

1. Log in to your sap.commerce account.

2. On the left Navigation Bar at the bottom, select Account (your profile image), then Personal Settings.

3. In the new window, navigate to the API Access tab and select Generate new access token.

![generate API token ](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-sap.commerce/refs/heads/main/docs/setup/resources/generate-api-token.png)


> **Tip:** You must copy and store this key somewhere safe. It won't be visible again in your account settings for security reasons

## Quickstart


To use the `sap.commerce` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `sap.commerce` module.

```ballerina
import ballerinax/sap.commerce;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the obtained access token as follows:

```toml
token = "<Your_sap.commerce_Access_Token>"
```

2. Create a `sap.commerce:ConnectionConfig` with the obtained access token and initialize the connector with it.

```ballerina
configurable string token = ?;

final sap.commerce:Client sap.commerce = check new({
    auth: {
        token
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Create a new sheet


```ballerina
public function main() returns error? {
    sap.commerce:SheetsBody newSheet = {
        name: "New Project Sheet",
        columns: [
            {
                title: "Task Name",
                type: "TEXT_NUMBER",
                primary: true
            },
            {
                title: "Status",
                type: "PICKLIST",
                options: ["Not Started", "In Progress", "Complete"]
            },
            {
                title: "Due Date",
                type: "DATE"
            }
        ]
    };

    sap.commerce:WebhookResponse response = check sap.commerce->/sheets.post(newSheet);
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```


## Examples

The `sap.commerce` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples), covering the following use cases:

1. [Project task management](https://github.com/ballerina-platform/module-ballerinax-sap.commerce/tree/main/examples/project_task_management) - Demonstrates how to automate project task creation using Ballerina connector for sap.commerce.

