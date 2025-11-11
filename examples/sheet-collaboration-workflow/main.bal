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
    
    io:println("=== Comprehensive Sheet Sharing and Collaboration Workflow ===");
    
    // Step 1: Retrieve all existing sheets to identify project-related ones
    io:println("\n1. Retrieving all sheets to identify project-related ones...");
    
    smartsheet:AlternateEmailListResponse sheetsResponse = check smartsheetClient->/sheets();
    
    if sheetsResponse.data is smartsheet:SchemasSheet[] {
        smartsheet:SchemasSheet[] sheets = <smartsheet:SchemasSheet[]>sheetsResponse.data;
        io:println(string `Found ${sheets.length()} sheets in the account`);
        
        // Filter project-related sheets (sheets containing "Project" in the name)
        smartsheet:SchemasSheet[] projectSheets = [];
        foreach smartsheet:SchemasSheet sheet in sheets {
            if sheet.name is string && sheet.name.toString().includes("Project") {
                projectSheets.push(sheet);
                io:println(string `Project sheet identified: ${sheet.name.toString()} (ID: ${sheet.id.toString()})`);
            }
        }
        
        if projectSheets.length() == 0 {
            io:println("No project-related sheets found. Creating example shares with first available sheet...");
            if sheets.length() > 0 {
                projectSheets.push(sheets[0]);
            }
        }
        
        // Step 2: Share specific sheets with different access levels
        io:println("\n2. Sharing sheets with team members and stakeholders...");
        
        foreach smartsheet:SchemasSheet sheet in projectSheets {
            if sheet.id is decimal {
                decimal sheetId = <decimal>sheet.id;
                
                // Share with core team member (Editor access)
                io:println(string `Sharing sheet "${sheet.name.toString()}" with core team member (Editor access)...`);
                
                smartsheet:Share coreTeamShare = {
                    email: "coreteam@company.com",
                    accessLevel: "EDITOR"
                };
                
                smartsheet:TokenResponse editorShareResponse = check smartsheetClient->/sheets/[sheetId]/shares.post(
                    coreTeamShare,
                    queries = {sendEmail: true}
                );
                
                if editorShareResponse.resultCode == 0 {
                    io:println("Successfully shared sheet with core team member (Editor access)");
                } else {
                    io:println("Editor share completed with partial success");
                }
                
                // Share with stakeholder (Viewer access)
                io:println(string `Sharing sheet "${sheet.name.toString()}" with stakeholder (Viewer access)...`);
                
                smartsheet:Share stakeholderShare = {
                    email: "stakeholder@company.com",
                    accessLevel: "VIEWER"
                };
                
                smartsheet:TokenResponse viewerShareResponse = check smartsheetClient->/sheets/[sheetId]/shares.post(
                    stakeholderShare,
                    queries = {sendEmail: true}
                );
                
                if viewerShareResponse.resultCode == 0 {
                    io:println("Successfully shared sheet with stakeholder (Viewer access)");
                } else {
                    io:println("Viewer share completed with partial success");
                }
                
                // Step 3: Set up automated email notifications
                io:println(string `Setting up email notifications for sheet "${sheet.name.toString()}"...`);
                
                smartsheet:Recipient coreTeamRecipient = {email: "coreteam@company.com"};
                smartsheet:Recipient stakeholderRecipient = {email: "stakeholder@company.com"};
                smartsheet:Recipient projectManagerRecipient = {email: "projectmanager@company.com"};
                
                smartsheet:Recipient[] recipients = [
                    coreTeamRecipient,
                    stakeholderRecipient,
                    projectManagerRecipient
                ];
                
                smartsheet:SheetEmail notificationEmail = {
                    sendTo: recipients,
                    subject: string `Important Updates: ${sheet.name.toString()}`,
                    message: "You are receiving this notification because there have been important updates to the shared project sheet. Please review the changes and take any necessary actions.",
                    ccMe: true
                };
                
                smartsheet:ProofCreateResponse emailResponse = check smartsheetClient->/sheets/[sheetId]/emails.post(
                    notificationEmail
                );
                
                if emailResponse.resultCode == 0 {
                    io:println("Email notification sent successfully to all team members");
                } else {
                    io:println("Email notification completed with partial success");
                }
                
                io:println(string `Collaboration setup completed for sheet: ${sheet.name.toString()}`);
                io:println("---");
            }
        }
        
        // Summary
        io:println("\n=== Workflow Summary ===");
        io:println(string `Total sheets processed: ${projectSheets.length()}`);
        io:println("✓ Retrieved and identified project-related sheets");
        io:println("✓ Shared sheets with core team members (Editor access)");
        io:println("✓ Shared sheets with stakeholders (Viewer access)");
        io:println("✓ Set up automated email notifications for updates");
        io:println("\nCollaboration workflow completed successfully!");
        
    } else {
        io:println("No sheets data received from the API");
    }
}