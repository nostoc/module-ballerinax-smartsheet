import ballerina/io;
import ballerinax/smartsheet;

configurable string accessToken = "your_access_token_here";

public function main() returns error? {
    
    // Initialize the Smartsheet client
    smartsheet:ConnectionConfig config = {
        auth: {
            token: accessToken
        }
    };
    
    smartsheet:Client smartsheetClient = check new (config);
    
    // Step 1: Search for sheets containing project keywords
    string[] projectKeywords = ["Project Alpha", "Marketing Campaign", "Q4 Initiative"];
    record {string name; smartsheet:SearchResultItem[] results;}[] allSearchResults = [];
    
    io:println("=== STEP 1: Searching for sheets with project keywords ===");
    
    foreach string keyword in projectKeywords {
        io:println(string `Searching for sheets containing: "${keyword}"`);
        
        smartsheet:UserCreateResponse searchResponse = check smartsheetClient->/search.get(
            query = keyword,
            scopes = ["sheetNames", "cellData"]
        );
        
        smartsheet:SearchResultItem[] sheetResults = [];
        smartsheet:SearchResultItem[]? searchResults = searchResponse.results;
        if searchResults is smartsheet:SearchResultItem[] {
            foreach smartsheet:SearchResultItem item in searchResults {
                if item.objectType == "sheet" {
                    sheetResults.push(item);
                }
            }
        }
        
        allSearchResults.push({
            name: keyword,
            results: sheetResults
        });
        
        io:println(string `Found ${sheetResults.length()} sheets for keyword: "${keyword}"`);
    }
    
    // Step 2: Collect unique sheet IDs and retrieve detailed information
    decimal[] uniqueSheetIds = [];
    foreach var searchResult in allSearchResults {
        foreach smartsheet:SearchResultItem item in searchResult.results {
            decimal? objectId = item.objectId;
            if objectId is decimal {
                decimal sheetId = objectId;
                boolean exists = false;
                foreach decimal existingId in uniqueSheetIds {
                    if existingId == sheetId {
                        exists = true;
                        break;
                    }
                }
                if !exists {
                    uniqueSheetIds.push(sheetId);
                }
            }
        }
    }
    
    io:println(string `\n=== STEP 2: Retrieving detailed information for ${uniqueSheetIds.length()} unique sheets ===`);
    
    record {decimal id; string name; string accessLevel; boolean hasSharing; int shareCount;}[] sheetDetails = [];
    
    foreach decimal sheetId in uniqueSheetIds {
        io:println(string `Retrieving details for sheet ID: ${sheetId}`);
        
        smartsheet:FavoriteResponse sheetResponse = check smartsheetClient->/sheets/[sheetId].get(
            include = "ownerInfo"
        );
        
        if sheetResponse is smartsheet:SchemasSheet {
            string sheetName = sheetResponse.name ?: string `Sheet ${sheetId}`;
            string? accessLevelValue = sheetResponse.accessLevel;
            string accessLevel = accessLevelValue is string ? accessLevelValue : "UNKNOWN";
            
            anydata sharesData = sheetResponse["shares"];
            boolean hasSharing = sharesData is smartsheet:Share[];
            int shareCount = 0;
            
            if sharesData is smartsheet:Share[] {
                shareCount = sharesData.length();
            }
            
            sheetDetails.push({
                id: sheetId,
                name: sheetName,
                accessLevel: accessLevel,
                hasSharing: hasSharing,
                shareCount: shareCount
            });
            
            io:println(string `  Sheet: "${sheetName}"`);
            io:println(string `  Access Level: ${accessLevel}`);
            io:println(string `  Share Count: ${shareCount}`);
            io:println(string `  Has Sharing: ${hasSharing}`);
        }
    }
    
    // Step 3: Generate and send email reports to stakeholders
    io:println("\n=== STEP 3: Generating and sending email reports ===");
    
    string[] stakeholderEmails = ["project.manager@company.com", "team.lead@company.com"];
    
    // Create summary report content
    string reportContent = generateSummaryReport(allSearchResults, sheetDetails);
    
    foreach string stakeholderEmail in stakeholderEmails {
        io:println(string `Preparing to send report to: ${stakeholderEmail}`);
        
        // Send email report for each sheet with detailed findings
        foreach var sheetDetail in sheetDetails {
            smartsheet:Recipient[] recipients = [
                {
                    email: stakeholderEmail
                }
            ];
            
            smartsheet:SheetEmail emailPayload = {
                sendTo: recipients,
                subject: string `Sheet Audit Report: ${sheetDetail.name}`,
                message: string `Dear Stakeholder,

Please find below the audit findings for sheet: ${sheetDetail.name}

Sheet Details:
- Sheet ID: ${sheetDetail.id}
- Access Level: ${sheetDetail.accessLevel}
- Number of Shares: ${sheetDetail.shareCount}
- Has Sharing Enabled: ${sheetDetail.hasSharing}

${reportContent}

This report was generated as part of the team collaboration audit process.

Best regards,
Project Management System`,
                ccMe: true
            };
            
            smartsheet:ProofCreateResponse emailResult = check smartsheetClient->/sheets/[sheetDetail.id]/emails.post(emailPayload);
            
            if emailResult.resultCode == 0 {
                io:println(string `Successfully sent audit report for sheet "${sheetDetail.name}" to ${stakeholderEmail}`);
            } else {
                io:println(string `Warning: Email sending may have encountered issues for sheet "${sheetDetail.name}"`);
            }
        }
    }
    
    io:println("\n=== AUDIT PROCESS COMPLETED ===");
    io:println(string `Total sheets audited: ${sheetDetails.length()}`);
    io:println(string `Total stakeholders notified: ${stakeholderEmails.length()}`);
}

function generateSummaryReport(record {string name; smartsheet:SearchResultItem[] results;}[] searchResults, 
                              record {decimal id; string name; string accessLevel; boolean hasSharing; int shareCount;}[] sheetDetails) returns string {
    
    string summary = "\n=== COLLABORATION AUDIT SUMMARY ===\n\n";
    
    summary += "Search Results by Keyword:\n";
    foreach var result in searchResults {
        summary += string `- "${result.name}": ${result.results.length()} sheets found\n`;
    }
    
    summary += "\nSheet Access Level Distribution:\n";
    map<int> accessLevelCounts = {};
    foreach var sheet in sheetDetails {
        string level = sheet.accessLevel;
        accessLevelCounts[level] = (accessLevelCounts[level] ?: 0) + 1;
    }
    
    foreach var [level, count] in accessLevelCounts.entries() {
        summary += string `- ${level}: ${count} sheets\n`;
    }
    
    summary += "\nSharing Statistics:\n";
    int totalShares = 0;
    int sheetsWithSharing = 0;
    foreach var sheet in sheetDetails {
        totalShares += sheet.shareCount;
        if sheet.hasSharing {
            sheetsWithSharing += 1;
        }
    }
    
    summary += string `- Total sheets with sharing enabled: ${sheetsWithSharing}\n`;
    summary += string `- Average shares per sheet: ${totalShares / sheetDetails.length()}\n`;
    
    return summary;
}