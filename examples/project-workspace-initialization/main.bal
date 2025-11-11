import ballerina/io;
import ballerinax/smartsheet;

configurable string accessToken = ?;

public function main() returns error? {
    // Initialize the Smartsheet client
    smartsheet:ConnectionConfig config = {
        auth: {
            token: accessToken
        }
    };
    
    smartsheet:Client smartsheetClient = check new(config);
    
    io:println("Starting Automated Project Setup Workflow...");
    
    // Step 1: Create a new workspace for the project
    smartsheet:WorkspacesBody workspacePayload = {
        name: "Project Alpha - Q4 2024"
    };
    
    smartsheet:CreateWorkspaceHeaders workspaceHeaders = {
        authorization: "Bearer " + accessToken,
        contentType: "application/json"
    };
    
    smartsheet:WorkspaceResponse workspaceResponse = check smartsheetClient->/workspaces.post(workspacePayload, workspaceHeaders);
    
    io:println("✓ Workspace created successfully");
    io:println("Workspace ID: ", workspaceResponse.result?.id);
    io:println("Workspace Name: ", workspaceResponse.result?.name);
    
    string workspaceId = "";
    decimal? workspaceIdDecimal = workspaceResponse.result?.id;
    if workspaceIdDecimal is decimal {
        workspaceId = workspaceIdDecimal.toString();
    }
    
    // Step 2: Create folder structure for different project phases
    string[] projectPhases = ["01-Planning", "02-Design", "03-Development", "04-Testing", "05-Deployment"];
    
    smartsheet:CreateWorkspaceFolderHeaders folderHeaders = {
        authorization: "Bearer " + accessToken,
        contentType: "application/json"
    };
    
    foreach string phase in projectPhases {
        smartsheet:FolderNameOnly folderPayload = {
            name: phase
        };
        
        smartsheet:CellHistoryResponse folderResponse = check smartsheetClient->/workspaces/[workspaceId]/folders.post(folderPayload, folderHeaders);
        
        io:println("✓ Created folder: ", phase);
        io:println("Folder Name: ", folderResponse.result?.name);
    }
    
    // Step 3: Create an initial project tracking sheet within the workspace
    smartsheet:SheetToCreate projectSheet = {
        name: "Project Alpha - Master Tracker"
    };
    
    smartsheet:CreateSheetInWorkspaceHeaders sheetHeaders = {
        authorization: "Bearer " + accessToken,
        contentType: "application/json"
    };
    
    smartsheet:CreateSheetInWorkspaceQueries sheetQueries = {
        accessApiLevel: 1
    };
    
    smartsheet:WebhookResponse sheetResponse = check smartsheetClient->/workspaces/[workspaceId]/sheets.post(projectSheet, sheetHeaders, sheetQueries);
    
    io:println("✓ Project tracking sheet created successfully");
    
    // Display final summary
    io:println("\n=== Project Setup Complete ===");
    io:println("Workspace: Project Alpha - Q4 2024");
    io:println("Folders created: ", projectPhases.length());
    io:println("Project tracking sheet: Project Alpha - Master Tracker");
    io:println("Project workspace is ready for team collaboration!");
}