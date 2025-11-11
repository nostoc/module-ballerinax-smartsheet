## Overview

[Smartsheet](https://www.smartsheet.com/) is a cloud-based platform that enables teams to plan, capture, manage, automate, and report on work at scale, empowering you to move from idea to impact, fast.

The `ballerinax/smartsheet` package offers APIs to connect and interact with [Smartsheet API](https://developers.smartsheet.com/api/smartsheet/introduction) endpoints, specifically based on [Smartsheet API v2.0](https://developers.smartsheet.com/api/smartsheet/openapi).
## Setup guide

To use the Smartsheet connector, you must have access to the Smartsheet API through a [Smartsheet developer account](`https://developers.smartsheet.com/`) and obtain an API access token. If you do not have a Smartsheet account, you can sign up for one [here](`https://www.smartsheet.com/try-it`).

### Step 1: Create a Smartsheet Account

1. Navigate to the [Smartsheet website](`https://www.smartsheet.com/`) and sign up for an account or log in if you already have one.

2. Ensure you have a Business or Enterprise plan, as the Smartsheet API is restricted to users on these plans.

### Step 2: Generate an API Access Token

1. Log in to your Smartsheet account.

2. On the left Navigation Bar at the bottom, select Account (your profile image), then Personal Settings.

3. In the new window, navigate to the API Access tab and select Generate new access token.

> **Tip:** You must copy and store this key somewhere safe. It won't be visible again in your account settings for security reasons.
## Quickstart

To use the `smartsheet` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerinax/smartsheet;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the obtained access token:

```toml
token = "<Your_Smartsheet_Access_Token>"
```

2. Create a `smartsheet:ConnectionConfig` and initialize the client:

```ballerina
configurable string token = ?;

final smartsheet:Client smartsheetClient = check new({
    auth: {
        token
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Create a new group

```ballerina
public function main() returns error? {
    smartsheet:GroupCreate1 newGroup = {
        name: "Marketing Team",
        description: "Marketing department collaboration group",
        members: [
            {email: "john.doe@example.com"},
            {email: "jane.smith@example.com"}
        ]
    };

    smartsheet:GroupCreateResponse response = check smartsheetClient->/groups.post(newGroup);
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```
## Examples

The `smartsheet` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-smartsheet/tree/main/examples), covering the following use cases:

1. [Sheet collaboration setup](https://github.com/ballerina-platform/module-ballerinax-smartsheet/tree/main/examples/sheet-collaboration-setup) - Demonstrates how to configure collaboration settings and permissions for Smartsheet sheets.
2. [Project workspace initialization](https://github.com/ballerina-platform/module-ballerinax-smartsheet/tree/main/examples/project-workspace-initialization) - Illustrates setting up a complete project workspace with initial structure and configurations.
3. [Project health monitoring](https://github.com/ballerina-platform/module-ballerinax-smartsheet/tree/main/examples/project-health-monitoring) - Shows how to monitor and track project health metrics and status indicators.
4. [Project collaboration audit](https://github.com/ballerina-platform/module-ballerinax-smartsheet/tree/main/examples/project-collaboration-audit) - Demonstrates auditing and tracking collaboration activities within project workspaces.