import ballerina/io;
import ballerinax/sap.commerce;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string serviceUrl = "http://localhost:9001/occ/v2";
configurable string baseSiteId = "electronics";
configurable string userId = "b2badmin@example.com";

public function main() returns error? {
    
    commerce:ConnectionConfig config = {
        auth: {
            clientId: clientId,
            clientSecret: clientSecret,
            tokenUrl: "http://localhost:9001/occ/v2/authorizationserver/oauth/token"
        }
    };
    
    commerce:Client sapCommerceClient = check new (config, serviceUrl);
    
    io:println("=== B2B E-commerce Order Management Workflow ===");
    
    string orderCode = "B2B-ORDER-001";
    
    io:println("\n1. Retrieving B2B order details...");
    xml orderDetails = check sapCommerceClient->getUserOrders(
        baseSiteId, 
        orderCode, 
        userId,
        {},
        {fields: "FULL"}
    );
    io:println("Order Details Retrieved:");
    io:println(orderDetails);
    
    io:println("\n2. Fetching compliance documentation attachments...");
    commerce:SAPOrderAttachmentList attachments = check sapCommerceClient->getUserOrderAttachments(
        baseSiteId,
        orderCode,
        userId,
        {},
        {
            fields: "FULL",
            pageSize: 10,
            currentPage: 0,
            sort: "sapFileName:asc"
        }
    );
    
    io:println("Order Attachments Retrieved:");
    commerce:SAPOrderAttachment[]? attachmentArray = attachments.sapAttachments;
    if attachmentArray is commerce:SAPOrderAttachment[] {
        foreach commerce:SAPOrderAttachment attachment in attachmentArray {
            io:println(string `- File: ${attachment.sapFileName ?: "N/A"}, ID: ${attachment.sapAttachmentId ?: "N/A"}`);
        }
    }
    
    commerce:Pagination? paginationInfo = attachments.pagination;
    if paginationInfo is commerce:Pagination {
        io:println(string `Total attachments: ${paginationInfo.totalCount ?: 0}`);
    }
    
    io:println("\n3. Processing order cancellation request...");
    
    commerce:CancellationRequestEntryInput[] cancellationEntries = [
        {
            orderEntryNumber: 0,
            quantity: 2
        },
        {
            orderEntryNumber: 1, 
            quantity: 1
        }
    ];
    
    commerce:CancellationRequestEntryInputList cancellationRequest = {
        cancellationRequestEntryInputs: cancellationEntries,
        cancelReason: "Customer requested partial cancellation due to budget constraints"
    };
    
    error? cancellationResult = sapCommerceClient->doCancelOrder(
        baseSiteId,
        orderCode,
        userId,
        cancellationRequest
    );
    
    if cancellationResult is error {
        io:println("Order cancellation failed: " + cancellationResult.message());
    } else {
        io:println("Order cancellation processed successfully");
    }
    
    io:println("\n4. Retrieving updated order status after cancellation...");
    xml updatedOrderDetails = check sapCommerceClient->getUserOrders(
        baseSiteId,
        orderCode,
        userId,
        {},
        {fields: "DEFAULT"}
    );
    io:println("Updated Order Details:");
    io:println(updatedOrderDetails);
    
    io:println("\n=== B2B Order Management Workflow Completed ===");
}