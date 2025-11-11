import ballerina/io;
import ballerinax/smartsheet;

configurable string accessToken = ?;

public function main() returns error? {
    // Initialize Smartsheet client
    smartsheet:ConnectionConfig config = {
        auth: {
            token: accessToken
        }
    };
    
    smartsheet:Client smartsheetClient = check new(config);
    
    // Step 1: Retrieve all sheets in the organization
    io:println("=== Step 1: Retrieving all sheets in organization ===");
    
    smartsheet:AlternateEmailListResponse sheetsResponse = check smartsheetClient->/sheets();
    
    if sheetsResponse.data is smartsheet:SchemasSheet[] {
        smartsheet:SchemasSheet[] sheets = <smartsheet:SchemasSheet[]>sheetsResponse.data;
        io:println(string `Found ${sheets.length()} sheets in organization:`);
        
        // Display critical project sheets
        foreach smartsheet:SchemasSheet sheet in sheets {
            smartsheet:Name? sheetName = sheet.name;
            smartsheet:Id? sheetId = sheet.id;
            
            if sheetName is smartsheet:Name && sheetId is smartsheet:Id {
                string nameStr = sheetName.toString();
                string idStr = sheetId.toString();
                io:println(string `- Sheet: ${nameStr} (ID: ${idStr})`);
                io:println(string `  Access Level: ${sheet.accessLevel ?: "N/A"}`);
                io:println(string `  Created: ${sheet.createdAt ?: "N/A"}`);
                io:println(string `  Modified: ${sheet.modifiedAt ?: "N/A"}`);
            }
        }
        
        // Step 2: Set up automated webhook notifications for the first sheet
        if sheets.length() > 0 {
            smartsheet:SchemasSheet firstSheet = sheets[0];
            smartsheet:Id? firstSheetId = firstSheet.id;
            smartsheet:Name? firstSheetName = firstSheet.name;
            
            if firstSheetId is smartsheet:Id && firstSheetName is smartsheet:Name {
                string sheetNameStr = firstSheetName.toString();
                
                io:println(string `\n=== Step 2: Setting up webhook for sheet: ${sheetNameStr} ===`);
                
                smartsheet:WebhooksBody webhookPayload = {
                    name: string `Project Monitor - ${sheetNameStr}`,
                    callbackUrl: "https://your-webhook-endpoint.com/smartsheet/callback",
                    scope: "sheet",
                    scopeObjectId: <int>firstSheetId,
                    events: ["*"],
                    version: 1
                };
                
                smartsheet:WorkspaceFolderCreateResponse webhookResponse = check smartsheetClient->/webhooks.post(webhookPayload);
                
                if webhookResponse.result is smartsheet:Webhook {
                    smartsheet:Webhook webhook = <smartsheet:Webhook>webhookResponse.result;
                    io:println(string `Webhook created successfully:`);
                    io:println(string `- Webhook ID: ${webhook.id ?: "N/A"}`);
                    io:println(string `- Name: ${webhook.name ?: "N/A"}`);
                    io:println(string `- Status: ${webhook.status ?: "N/A"}`);
                    io:println(string `- Callback URL: ${webhook.callbackUrl ?: "N/A"}`);
                }
                
                // Step 3: Configure sharing permissions for stakeholders
                io:println(string `\n=== Step 3: Configuring sharing permissions for sheet: ${sheetNameStr} ===`);
                
                // Share with project stakeholders
                smartsheet:Share[] shares = [
                    {
                        email: "project.manager@company.com",
                        accessLevel: "ADMIN",
                        subject: string `Access to ${sheetNameStr} - Project Management`,
                        message: "You have been granted admin access to this critical project sheet for monitoring and collaboration."
                    },
                    {
                        email: "team.lead@company.com", 
                        accessLevel: "EDITOR",
                        subject: string `Access to ${sheetNameStr} - Team Collaboration`,
                        message: "You have been granted editor access to collaborate on this project sheet."
                    },
                    {
                        email: "stakeholder@company.com",
                        accessLevel: "VIEWER",
                        subject: string `Access to ${sheetNameStr} - Project Updates`,
                        message: "You have been granted view access to monitor project progress."
                    }
                ];
                
                smartsheet:TokenResponse shareResponse = check smartsheetClient->/sheets/[firstSheetId]/shares.post(
                    shares,
                    {},
                    {sendEmail: true, accessApiLevel: 1}
                );
                
                if shareResponse.result is smartsheet:Share|smartsheet:Share[] {
                    io:println("Sharing permissions configured successfully:");
                    
                    if shareResponse.result is smartsheet:Share[] {
                        smartsheet:Share[] shareResults = <smartsheet:Share[]>shareResponse.result;
                        foreach smartsheet:Share share in shareResults {
                            io:println(string `- Shared with: ${share.email ?: "N/A"}`);
                            io:println(string `  Access Level: ${share.accessLevel ?: "N/A"}`);
                            io:println(string `  Share ID: ${share.id ?: "N/A"}`);
                        }
                    } else {
                        smartsheet:Share share = <smartsheet:Share>shareResponse.result;
                        io:println(string `- Shared with: ${share.email ?: "N/A"}`);
                        io:println(string `  Access Level: ${share.accessLevel ?: "N/A"}`);
                        io:println(string `  Share ID: ${share.id ?: "N/A"}`);
                    }
                }
            }
        }
    }
    
    io:println("\n=== Sheet Monitoring and Collaboration System Setup Complete ===");
    io:println("✓ Retrieved all organizational sheets");
    io:println("✓ Configured automated webhook notifications");
    io:println("✓ Set up sharing permissions for stakeholders");
    io:println("\nThe system is now ready for comprehensive project monitoring and collaboration!");
}