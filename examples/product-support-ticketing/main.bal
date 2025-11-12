import ballerina/io;
import ballerinax/sap.commerce;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string tokenUrl = "http://localhost:9001/occ/v2/authorizationserver/oauth/token";
configurable string serviceUrl = "http://localhost:9001/occ/v2";

public function main() returns error? {
    
    // Initialize the SAP Commerce client
    commerce:ConnectionConfig clientConfig = {
        auth: {
            tokenUrl: tokenUrl,
            clientId: clientId,
            clientSecret: clientSecret
        }
    };
    
    commerce:Client sapCommerceClient = check new(clientConfig, serviceUrl);
    io:println("Successfully initialized SAP Commerce client");
    
    // B2B Customer Support System Configuration
    string baseSiteId = "electronics-spa";
    string categoryId = "cameras";
    string productCode = "1934793";
    string customerId = "customer001";
    
    io:println("=== B2B Customer Support System: Product Issue Resolution ===");
    io:println("Customer reported issue with product: " + productCode);
    
    // Step 1: Retrieve products from the category to understand product context
    io:println("\n--- Step 1: Retrieving product information from category ---");
    
    commerce:GetProductsByCategoryQueries productQueries = {
        query: "camera:relevance",
        pageSize: 10,
        currentPage: 0,
        fields: "FULL"
    };
    
    string queryValue = productQueries.query ?: "";
    int:Signed32 pageSizeValue = productQueries.pageSize ?: 10;
    
    xml|error productsByCategory = sapCommerceClient->getProductsByCategory(
        baseSiteId, 
        categoryId, 
        {},
        query = queryValue,
        pageSize = pageSizeValue,
        currentPage = productQueries.currentPage,
        fields = productQueries.fields
    );
    
    if productsByCategory is error {
        io:println("Error retrieving products: " + productsByCategory.message());
        return productsByCategory;
    }
    
    io:println("Successfully retrieved products from category: " + categoryId);
    io:println("Product data: " + productsByCategory.toString());
    
    // Step 2: Get detailed product reviews to understand common issues
    io:println("\n--- Step 2: Retrieving product reviews for context ---");
    
    commerce:GetProductReviewsQueries reviewQueries = {
        fields: "FULL",
        maxCount: 20
    };
    
    int:Signed32 maxCountValue = reviewQueries.maxCount ?: 20;
    
    xml|error productReviews = sapCommerceClient->getProductReviews(
        baseSiteId,
        productCode,
        {},
        fields = reviewQueries.fields,
        maxCount = maxCountValue
    );
    
    if productReviews is error {
        io:println("Error retrieving product reviews: " + productReviews.message());
        return productReviews;
    }
    
    io:println("Successfully retrieved product reviews for: " + productCode);
    io:println("Reviews data: " + productReviews.toString());
    
    // Step 3: Create comprehensive support ticket with all product context
    io:println("\n--- Step 3: Creating detailed support ticket ---");
    
    commerce:TicketCategory ticketCategory = {
        id: "PRODUCT_ISSUE",
        name: "Product Technical Issue"
    };
    
    commerce:TicketAssociatedObject associatedObject = {
        code: productCode,
        'type: "Product"
    };
    
    commerce:TicketStarter ticketPayload = {
        subject: "Camera Product Issue - Model " + productCode + " - Battery Drain Problem",
        message: "Customer reports rapid battery drain issue with camera model " + productCode + 
                ". Based on product specifications and customer reviews analysis, this appears to be " +
                "related to the power management system. Customer purchased this item 3 months ago " +
                "and battery now drains within 2 hours of normal use. Please investigate potential " +
                "firmware update or hardware replacement options. Product context and review analysis " +
                "attached for support agent reference.",
        ticketCategory: ticketCategory,
        associatedTo: associatedObject
    };
    
    commerce:CreateTicketQueries ticketQueries = {
        fields: "FULL"
    };
    
    string fieldsValue = ticketQueries.fields ?: "FULL";
    
    commerce:Ticket|error supportTicket = sapCommerceClient->createTicket(
        baseSiteId,
        customerId,
        ticketPayload,
        {},
        fields = fieldsValue
    );
    
    if supportTicket is error {
        io:println("Error creating support ticket: " + supportTicket.message());
        return supportTicket;
    }
    
    io:println("Successfully created comprehensive support ticket!");
    io:println("Ticket details: " + supportTicket.toString());
    
    io:println("\n=== Support Ticket Creation Complete ===");
    io:println("✓ Product information gathered from category");
    io:println("✓ Product reviews analyzed for common issues");
    io:println("✓ Comprehensive support ticket created with full context");
    io:println("✓ Support agents now have complete product information for faster resolution");
    
    return;
}