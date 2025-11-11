import ballerina/io;
import ballerinax/smartsheet;

configurable string accessToken = ?;

type ProjectCollaborationReport record {
    string projectName;
    decimal sheetId;
    int discussionCount;
    int totalComments;
    int unresolvedIssues;
    decimal engagementScore;
};

public function main() returns error? {
    smartsheet:ConnectionConfig config = {
        auth: {
            token: accessToken
        }
    };

    smartsheet:Client smartsheetClient = check new (config);

    io:println("=== Project Management Automation Workflow ===");
    io:println("Step 1: Retrieving all sheets in the organization...");

    smartsheet:ListSheetsQueries sheetsQuery = {
        includeAll: true,
        include: "sheetVersion"
    };

    smartsheet:AlternateEmailListResponse sheetsResponse = check smartsheetClient->/sheets.get(queries = sheetsQuery);
    
    if sheetsResponse.data is () {
        io:println("No sheets found in the organization");
        return;
    }

    smartsheet:SchemasSheet[] sheets = <smartsheet:SchemasSheet[]>sheetsResponse.data;
    io:println(string `Found ${sheets.length()} sheets in the organization`);

    ProjectCollaborationReport[] collaborationReports = [];

    foreach smartsheet:SchemasSheet sheet in sheets {
        if sheet.id is decimal && sheet.name is string {
            decimal sheetId = <decimal>sheet.id;
            string sheetName = <string>sheet.name;
            
            io:println(string `\nStep 2: Analyzing discussions for sheet: ${sheetName} (ID: ${sheetId})`);

            smartsheet:DiscussionsListQueries discussionsQuery = {
                include: "comments",
                includeAll: true
            };

            smartsheet:DiscussionCreateResponse|error discussionsResponse = smartsheetClient->/sheets/[sheetId]/discussions.get(queries = discussionsQuery);
            
            if discussionsResponse is error {
                io:println(string `Warning: Could not retrieve discussions for sheet ${sheetName}: ${discussionsResponse.message()}`);
                continue;
            }

            int discussionCount = 0;
            int totalComments = 0;
            int unresolvedIssues = 0;

            if discussionsResponse.data is smartsheet:Discussion[] {
                smartsheet:Discussion[] discussions = <smartsheet:Discussion[]>discussionsResponse.data;
                discussionCount = discussions.length();
                
                foreach smartsheet:Discussion discussion in discussions {
                    totalComments += 1;
                    if discussion.title is string && (<string>discussion.title).includes("issue") {
                        unresolvedIssues += 1;
                    }
                }
            }

            decimal engagementScore = discussionCount > 0 ? <decimal>totalComments / <decimal>discussionCount : 0.0;

            ProjectCollaborationReport report = {
                projectName: sheetName,
                sheetId: sheetId,
                discussionCount: discussionCount,
                totalComments: totalComments,
                unresolvedIssues: unresolvedIssues,
                engagementScore: engagementScore
            };

            collaborationReports.push(report);

            io:println(string `  - Discussions: ${discussionCount}`);
            io:println(string `  - Total Comments: ${totalComments}`);
            io:println(string `  - Unresolved Issues: ${unresolvedIssues}`);
            io:println(string `  - Engagement Score: ${engagementScore}`);
        }
    }

    io:println("\nStep 3: Generating and sending email reports to stakeholders...");

    string emailSubject = "Weekly Project Collaboration Report";
    string emailMessage = generateCollaborationSummary(collaborationReports);

    smartsheet:RecipientIndividual[] recipients = [
        {email: "project.manager@company.com"},
        {email: "team.lead@company.com"}
    ];

    smartsheet:SheetEmail emailReport = {
        sendTo: recipients,
        ccMe: true,
        subject: emailSubject,
        message: emailMessage
    };

    foreach ProjectCollaborationReport report in collaborationReports {
        if report.discussionCount > 0 {
            smartsheet:ProofCreateResponse|error emailResult = smartsheetClient->/sheets/[report.sheetId]/emails.post(emailReport);
            
            if emailResult is error {
                io:println(string `Warning: Could not send email for ${report.projectName}: ${emailResult.message()}`);
            } else {
                io:println(string `Email sent successfully for project: ${report.projectName}`);
            }
        }
    }

    io:println("\n=== Project Management Automation Workflow Complete ===");
    io:println("Summary of analyzed projects:");
    
    int totalProjects = collaborationReports.length();
    int activeProjects = 0;
    int totalDiscussions = 0;
    int totalUnresolvedIssues = 0;

    foreach ProjectCollaborationReport report in collaborationReports {
        if report.discussionCount > 0 {
            activeProjects += 1;
        }
        totalDiscussions += report.discussionCount;
        totalUnresolvedIssues += report.unresolvedIssues;
    }

    io:println(string `- Total Projects: ${totalProjects}`);
    io:println(string `- Active Projects (with discussions): ${activeProjects}`);
    io:println(string `- Total Discussions: ${totalDiscussions}`);
    io:println(string `- Total Unresolved Issues: ${totalUnresolvedIssues}`);
}

function generateCollaborationSummary(ProjectCollaborationReport[] reports) returns string {
    string summary = "Weekly Project Collaboration Summary\n\n";
    summary += "Project Activity Overview:\n";
    string separatorLine = "";
    int separatorLength = 50;
    int i = 0;
    while i < separatorLength {
        separatorLine += "=";
        i += 1;
    }
    summary += separatorLine + "\n\n";

    foreach ProjectCollaborationReport report in reports {
        summary += string `Project: ${report.projectName}\n`;
        summary += string `- Sheet ID: ${report.sheetId}\n`;
        summary += string `- Active Discussions: ${report.discussionCount}\n`;
        summary += string `- Total Comments: ${report.totalComments}\n`;
        summary += string `- Unresolved Issues: ${report.unresolvedIssues}\n`;
        summary += string `- Engagement Score: ${report.engagementScore}\n`;
        
        if report.unresolvedIssues > 0 {
            summary += "  ⚠️  ATTENTION: This project has unresolved issues requiring immediate attention.\n";
        }
        
        decimal highEngagementThreshold = 5.0d;
        decimal lowEngagementThreshold = 2.0d;
        
        if report.engagementScore > highEngagementThreshold {
            summary += "  ✅ HIGH ENGAGEMENT: This project shows excellent team collaboration.\n";
        } else if report.engagementScore < lowEngagementThreshold && report.discussionCount > 0 {
            summary += "  📈 LOW ENGAGEMENT: Consider encouraging more team participation.\n";
        }
        
        summary += "\n";
    }

    summary += "\nRecommendations:\n";
    summary += "- Review projects with unresolved issues marked above\n";
    summary += "- Encourage participation in low-engagement projects\n";
    summary += "- Schedule follow-up meetings for high-priority items\n";
    
    return summary;
}