import ballerina/io;
import ballerinax/smartsheet;

configurable string smartsheetToken = ?;

public function main() returns error? {
    // Initialize Smartsheet client
    smartsheet:ConnectionConfig config = {
        auth: {
            token: smartsheetToken
        }
    };
    
    smartsheet:Client smartsheetClient = check new (config);
    
    io:println("=== COMPREHENSIVE USER MANAGEMENT WORKFLOW ===\n");
    
    // Step 1: Retrieve current list of all users for audit
    io:println("1. Retrieving current user list for audit...");
    smartsheet:UserListResponse userList = check smartsheetClient->/users.get(
        include = "lastLogin",
        includeAll = true,
        numericDates = false
    );
    
    io:println("Current users in organization:");
    smartsheet:User[]? userData = userList.data;
    if userData is smartsheet:User[] {
        foreach smartsheet:User user in userData {
            io:println(string `- ${user.firstName ?: "N/A"} ${user.lastName ?: "N/A"} (${user.email ?: "N/A"})`);
        }
    }
    io:println(string `Total users found: ${userList.totalCount ?: 0}\n`);
    
    // Step 2: Add new team members with proper permissions
    io:println("2. Adding new team members...");
    
    // Add a new project coordinator
    smartsheet:User newProjectCoordinator = {
        email: "sarah.johnson@company.com",
        firstName: "Sarah",
        lastName: "Johnson",
        licensedSheetCreator: true,
        groupAdmin: false,
        admin: false,
        resourceViewer: true
    };
    
    smartsheet:UserProfileResponse coordinatorResponse = check smartsheetClient->/users.post(
        newProjectCoordinator,
        sendEmail = true
    );
    
    io:println("Added project coordinator:");
    smartsheet:User? coordinatorResult = coordinatorResponse.result;
    if coordinatorResult is smartsheet:User {
        smartsheet:User addedUser = coordinatorResult;
        io:println(string `- ${addedUser.firstName ?: "N/A"} ${addedUser.lastName ?: "N/A"} (${addedUser.email ?: "N/A"})`);
        io:println(string `- Licensed Sheet Creator: ${addedUser.licensedSheetCreator}`);
        io:println(string `- Resource Viewer: ${addedUser.resourceViewer}`);
    }
    
    // Add a new team member
    smartsheet:User newTeamMember = {
        email: "mike.chen@company.com",
        firstName: "Mike",
        lastName: "Chen",
        licensedSheetCreator: false,
        groupAdmin: false,
        admin: false,
        resourceViewer: false
    };
    
    smartsheet:UserProfileResponse memberResponse = check smartsheetClient->/users.post(
        newTeamMember,
        sendEmail = true
    );
    
    io:println("Added team member:");
    smartsheet:User? memberResult = memberResponse.result;
    if memberResult is smartsheet:User {
        smartsheet:User addedUser = memberResult;
        io:println(string `- ${addedUser.firstName ?: "N/A"} ${addedUser.lastName ?: "N/A"} (${addedUser.email ?: "N/A"})`);
        io:println(string `- Licensed Sheet Creator: ${addedUser.licensedSheetCreator}`);
        io:println(string `- Resource Viewer: ${addedUser.resourceViewer}`);
    }
    io:println("");
    
    // Step 3: Set up automated notifications with webhooks
    io:println("3. Setting up automated webhooks for user activity monitoring...");
    
    // Create webhook for user management notifications
    smartsheet:WebhooksBody userWebhook = {
        name: "User Management Notifications",
        callbackUrl: "https://your-company.com/webhooks/user-management",
        scope: "sheet",
        scopeObjectId: 1234567890123456,
        events: [
            "*.*"
        ],
        version: 1
    };
    
    smartsheet:WorkspaceFolderCreateResponse webhookResponse = check smartsheetClient->/webhooks.post(
        userWebhook
    );
    
    io:println("Created webhook for user management:");
    smartsheet:Webhook? webhookResult = webhookResponse.result;
    if webhookResult is smartsheet:Webhook {
        smartsheet:Webhook createdWebhook = webhookResult;
        io:println(string `- Webhook Name: ${createdWebhook.name ?: "N/A"}`);
        io:println(string `- Callback URL: ${createdWebhook.callbackUrl ?: "N/A"}`);
        io:println(string `- Status: ${createdWebhook.status ?: "N/A"}`);
        io:println(string `- Scope: ${createdWebhook.scope ?: "N/A"}`);
    }
    
    // Create webhook for sheet activity monitoring
    smartsheet:WebhooksBody activityWebhook = {
        name: "Sheet Activity Monitor",
        callbackUrl: "https://your-company.com/webhooks/sheet-activity",
        scope: "sheet",
        scopeObjectId: 9876543210987654,
        events: [
            "*.created",
            "*.updated",
            "*.deleted"
        ],
        version: 1
    };
    
    smartsheet:WorkspaceFolderCreateResponse activityResponse = check smartsheetClient->/webhooks.post(
        activityWebhook
    );
    
    io:println("Created webhook for sheet activity:");
    smartsheet:Webhook? activityResult = activityResponse.result;
    if activityResult is smartsheet:Webhook {
        smartsheet:Webhook createdWebhook = activityResult;
        io:println(string `- Webhook Name: ${createdWebhook.name ?: "N/A"}`);
        io:println(string `- Callback URL: ${createdWebhook.callbackUrl ?: "N/A"}`);
        io:println(string `- Status: ${createdWebhook.status ?: "N/A"}`);
        io:println(string `- Scope: ${createdWebhook.scope ?: "N/A"}`);
    }
    
    io:println("\n=== USER MANAGEMENT WORKFLOW COMPLETED ===");
    io:println("✓ Audited existing users");
    io:println("✓ Added new team members with appropriate permissions");
    io:println("✓ Set up automated webhooks for real-time notifications");
    io:println("✓ Admin team will now receive notifications for all user and sheet activities");
}