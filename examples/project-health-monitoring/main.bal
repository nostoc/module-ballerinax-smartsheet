import ballerina/io;
import ballerinax/smartsheet;

configurable string accessToken = ?;
configurable decimal projectReportId = ?;
configurable string callbackUrl = ?;

public function main() returns error? {
    smartsheet:ConnectionConfig config = {
        auth: {
            token: accessToken
        }
    };

    smartsheet:Client smartsheetClient = check new (config);

    io:println("=== Project Portfolio Health Monitoring System ===\n");

    io:println("Step 1: Retrieving all workspaces to identify active projects...");
    smartsheet:WorkspaceShareListResponse workspacesResponse = check smartsheetClient->/workspaces();
    
    smartsheet:WorkspaceListing[]? workspaceData = workspacesResponse.data;
    if workspaceData is smartsheet:WorkspaceListing[] {
        smartsheet:WorkspaceListing[] workspaces = workspaceData;
        io:println(string `Found ${workspaces.length()} workspaces:`);
        
        foreach smartsheet:WorkspaceListing workspace in workspaces {
            io:println(string `  - ${workspace.name ?: "Unnamed"} (ID: ${workspace.id ?: 0})`);
        }
    } else {
        io:println("No workspaces found");
    }

    io:println("\nStep 2: Setting up automated email report for critical project sheet...");
    smartsheet:Recipient emailRecipient1 = {
        email: "project.manager@company.com"
    };
    smartsheet:Recipient emailRecipient2 = {
        email: "stakeholder1@company.com"
    };
    smartsheet:Recipient[] emailRecipients = [
        emailRecipient1,
        emailRecipient2
    ];
    
    smartsheet:SheetEmail emailReport = {
        sendTo: emailRecipients,
        subject: "Weekly Project Portfolio Health Report",
        message: "Please find the weekly project portfolio health report attached. This automated report provides key metrics and status updates for all active projects.",
        ccMe: true
    };

    smartsheet:Result emailResult = check smartsheetClient->/reports/[projectReportId]/emails.post(emailReport);
    io:println("Email report setup completed:");
    io:println(string `  - Result Code: ${emailResult.resultCode ?: 0}`);
    io:println(string `  - Message: ${emailResult.message ?: "SUCCESS"}`);

    io:println("\nStep 3: Creating webhook for real-time project metrics monitoring...");
    smartsheet:WebhooksBody webhookConfig = {
        name: "Project Portfolio Health Monitor",
        callbackUrl: callbackUrl,
        scope: "sheet",
        scopeObjectId: <int>projectReportId,
        events: ["*.*"],
        version: 1
    };

    smartsheet:WorkspaceFolderCreateResponse webhookResponse = check smartsheetClient->/webhooks.post(webhookConfig);
    
    smartsheet:Webhook? webhookResult = webhookResponse.result;
    if webhookResult is smartsheet:Webhook {
        smartsheet:Webhook webhook = webhookResult;
        io:println("Webhook created successfully:");
        io:println(string `  - Webhook ID: ${webhook.id ?: 0}`);
        io:println(string `  - Name: ${webhook.name ?: "Unknown"}`);
        io:println(string `  - Status: ${webhook.status ?: "Unknown"}`);
        io:println(string `  - Callback URL: ${webhook.callbackUrl ?: "Unknown"}`);
    }

    io:println("\n=== Project Portfolio Health Monitoring Setup Complete ===");
    io:println("The system is now configured to:");
    io:println("1. Monitor multiple project workspaces");
    io:println("2. Send automated email reports to stakeholders");
    io:println("3. Provide real-time notifications via webhooks");
    io:println("4. Enable proactive project management and stakeholder communication");
}