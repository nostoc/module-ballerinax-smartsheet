import ballerina/io;
import ballerinax/smartsheet;

configurable string smartsheetAccessToken = ?;
configurable string webhookCallbackUrl = ?;
configurable string clientProjectName = ?;

public function main() returns error? {
    // Initialize Smartsheet client
    smartsheet:ConnectionConfig config = {
        auth: {
            token: smartsheetAccessToken
        }
    };
    
    smartsheet:Client smartsheetClient = check new (config);
    
    io:println("Starting project management setup for client: " + clientProjectName);
    
    // Step 1: Create a dedicated workspace for the new client project
    smartsheet:WorkspacesBody workspacePayload = {
        name: clientProjectName + " - Project Workspace"
    };
    
    smartsheet:CreateWorkspaceHeaders workspaceHeaders = {
        authorization: "Bearer " + smartsheetAccessToken,
        contentType: "application/json"
    };
    
    smartsheet:CreateWorkspaceQueries workspaceQueries = {
        accessApiLevel: 1
    };
    
    smartsheet:WorkspaceResponse workspaceResponse = check smartsheetClient->/workspaces.post(
        workspacePayload, 
        workspaceHeaders, 
        {"queries": workspaceQueries}
    );
    
    io:println("Created workspace successfully");
    io:println("Workspace Response: ", workspaceResponse);
    
    // Extract workspace ID for subsequent operations
    decimal? workspaceId = workspaceResponse.result?.id;
    if workspaceId is () {
        return error("Failed to get workspace ID from response");
    }
    
    string workspaceIdStr = workspaceId.toString();
    io:println("Workspace ID: " + workspaceIdStr);
    
    // Step 2: Set up proper folder structure within the workspace
    string[] folderNames = [
        "01 - Project Planning",
        "02 - Requirements & Documentation", 
        "03 - Development & Testing",
        "04 - Deliverables & Reports",
        "05 - Client Communications"
    ];
    
    foreach string folderName in folderNames {
        smartsheet:FolderNameOnly folderPayload = {
            name: folderName
        };
        
        smartsheet:CreateWorkspaceFolderHeaders folderHeaders = {
            authorization: "Bearer " + smartsheetAccessToken,
            contentType: "application/json"
        };
        
        smartsheet:CellHistoryResponse folderResponse = check smartsheetClient->/workspaces/[workspaceIdStr]/folders.post(
            folderPayload,
            folderHeaders
        );
        
        io:println("Created folder: " + folderName);
        io:println("Folder Response: ", folderResponse);
    }
    
    // Step 3: Establish a webhook to monitor all activities within the workspace
    smartsheet:WebhooksBody webhookPayload = {
        name: clientProjectName + " - Activity Monitor",
        callbackUrl: webhookCallbackUrl,
        scope: "sheet",
        scopeObjectId: <int>workspaceId
    };
    
    smartsheet:CreateWebhookHeaders webhookHeaders = {
        authorization: "Bearer " + smartsheetAccessToken,
        contentType: "application/json"
    };
    
    smartsheet:WorkspaceFolderCreateResponse webhookResponse = check smartsheetClient->/webhooks.post(
        webhookPayload,
        webhookHeaders
    );
    
    io:println("Created webhook for workspace monitoring");
    io:println("Webhook Response: ", webhookResponse);
    
    io:println("Project management setup completed successfully!");
    io:println("- Workspace created: " + clientProjectName + " - Project Workspace");
    io:println("- Folder structure established with 5 organizational folders");
    io:println("- Webhook configured for real-time activity monitoring");
    io:println("- Ready for integration with external systems like Slack or Microsoft Teams");
}