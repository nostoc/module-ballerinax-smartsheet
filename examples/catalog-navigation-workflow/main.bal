import ballerina/io;
import ballerinax/sap.commerce;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string serviceUrl = "http://localhost:9001/occ/v2";
configurable string baseSiteId = "electronics";

public function main() returns error? {
    
    commerce:ConnectionConfig connectionConfig = {
        auth: {
            clientId: clientId,
            clientSecret: clientSecret,
            tokenUrl: "http://localhost:9001/occ/v2/authorizationserver/oauth/token"
        }
    };

    commerce:Client commerceClient = check new (connectionConfig, serviceUrl);

    io:println("=== B2B Product Catalog Management Workflow ===");
    io:println();

    io:println("Step 1: Retrieving all available product catalogs for the site...");
    commerce:GetCatalogsQueries catalogQueries = {
        fields: "FULL"
    };
    
    xml catalogsResponse = check commerceClient->getCatalogs(baseSiteId, {}, catalogQueries);
    io:println("Available catalogs:");
    io:println(catalogsResponse);
    io:println();

    io:println("Step 2: Examining specific catalog structure...");
    string catalogId = "electronicsProductCatalog";
    string catalogVersionId = "Online";
    
    xml catalogStructure = check commerceClient->getCatalogs(baseSiteId, {}, {fields: "DEFAULT"});
    io:println("Catalog structure for " + catalogId + ":");
    io:println(catalogStructure);
    io:println();

    io:println("Step 3: Fetching detailed category information for navigation menu...");
    string rootCategoryId = "1";
    
    commerce:GetCategoriesQueries categoryQueries = {
        fields: "FULL"
    };
    
    xml categoryDetails = check commerceClient->getCategories(
        baseSiteId, 
        catalogId, 
        catalogVersionId, 
        rootCategoryId, 
        {}, 
        categoryQueries
    );
    
    io:println("Root category details for navigation:");
    io:println(categoryDetails);
    io:println();

    io:println("Step 4: Fetching subcategory information for complete navigation structure...");
    string subCategoryId = "brand_5";
    
    xml subCategoryDetails = check commerceClient->getCategories(
        baseSiteId, 
        catalogId, 
        catalogVersionId, 
        subCategoryId, 
        {}, 
        {fields: "DEFAULT"}
    );
    
    io:println("Subcategory details:");
    io:println(subCategoryDetails);
    io:println();

    io:println("=== Product Catalog Management Workflow Complete ===");
    io:println("Successfully retrieved catalog hierarchy from top-level catalogs to specific categories.");
    io:println("This data can now be used to build navigation menus and understand product taxonomy.");
}