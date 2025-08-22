# Project Task Management Integration

This example demonstrates how to automate project task creation using Ballerina connector for Smartsheet. When a new project is created via HTTP API, the system automatically creates initial tasks in Smartsheet and sends a summary notification message to Slack.

## Prerequisites

1. **Smartsheet Setup**
   - Create a Smartsheet account (Business/Enterprise plan required)
   - Generate an API access token
   - Create two sheets:
     - "Projects" sheet with columns: Project Name, Start Date, Status
     - "Tasks" sheet with columns: Task Name, Assigned To, Due Date, Project Name

   > Refer the [Smartsheet setup guide](https://github.com/ballerina-platform/module-ballerinax-smartsheet/blob/main/ballerina/README.md) here.

2. **Slack Setup**
   - Refer the [Slack setup guide](https://github.com/ballerina-platform/module-ballerinax-slack/blob/master/ballerina/README.md) here.

3. For this example, create a `Config.toml` file with your credentials. Here's an example of how your `Config.toml` file should look:

```toml
smartsheetToken = "SMARTSHEET_ACCESS_TOKEN"
projectsSheetName = "PROJECT_SHEET_NAME"
tasksSheetName = "TASK_SHEET_NAME"
slackToken = "SLACK_TOKEN"
slackChannel = "SLACK_CHANNEL"
```

## Run the Example

1. Execute the following command to run the example:

```bash
bal run
```

2. The service will start on port 8080. You can test the integration by sending a POST request to create a new project:

```bash
curl -X POST http://localhost:8080/projects \
  -H "Content-Type: application/json" \
  -d '{
    "projectName": "Website Redesign",
    "startDate": "2025-08-25",
    "status" : "ACTIVE",
    "assignedTo": "developer@example.com"
  }'
```

Or use this sample JSON payload:

```json
{
  "projectName": "Website Redesign",
  "startDate": "2025-08-25",
  "status" : "pending"
  "status" : "ACTIVE",
  "assignedTo": "developer@example.com"
}
```
<!--
The service will automatically:
- Find the Projects and Tasks sheets by name
- Get the column IDs for required columns
- Create initial tasks in the Tasks sheet with calculated due dates:
  - "Kick-off Meeting" (due: start date + 1 day)
  - "Requirement Gathering" (due: start date + 3 days)
  - "Resource Allocation" (due: start date + 5 days)
- Send a summary notification to the configured Slack channel
- Return a JSON response with the operation details

## Health Check

You can also check if the service is running:

```bash
curl http://localhost:8080/health
```

This will return a simple status response indicating the service is operational.
 -->
