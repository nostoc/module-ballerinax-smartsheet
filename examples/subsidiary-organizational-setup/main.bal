import ballerina/io;
import ballerinax/sap.commerce;

configurable string clientId = "your_client_id";
configurable string clientSecret = "your_client_secret";
configurable string tokenUrl = "http://localhost:9001/occ/v2/authorizationserver/oauth/token";
configurable string serviceUrl = "http://localhost:9001/occ/v2";
configurable string baseSiteId = "electronics-spa";
configurable string userId = "procurement.manager@company.com";

public function main() returns error? {
    
    commerce:ConnectionConfig config = {
        auth: {
            clientId: clientId,
            clientSecret: clientSecret,
            tokenUrl: tokenUrl
        }
    };
    
    commerce:Client sapCommerceClient = check new (config, serviceUrl);
    
    io:println("Starting B2B organizational setup for acquired subsidiary...");
    
    // Step 1: Create organizational unit for the acquired subsidiary
    io:println("\n1. Creating organizational unit for subsidiary...");
    
    commerce:OrgUnitUserGroup subsidiaryOrgUnit = {
        uid: "subsidiary-acme-corp",
        name: "ACME Corp Subsidiary",
        roles: ["b2badmingroup"],
        orgUnit: {
            uid: "acme-subsidiary",
            name: "ACME Corporation Subsidiary",
            active: true
        }
    };
    
    commerce:OrgUnitUserGroup createdOrgUnit = check sapCommerceClient->createOrgUnitUserGroup(
        baseSiteId, 
        userId, 
        subsidiaryOrgUnit,
        fields = "FULL"
    );
    
    io:println("✓ Created organizational unit: " + (createdOrgUnit.name ?: "Unknown"));
    io:println("  UID: " + (createdOrgUnit.uid ?: "Unknown"));
    
    // Step 2: Create cost centers for different departments
    io:println("\n2. Creating cost centers for departments...");
    
    // IT Department Cost Center
    commerce:B2BCostCenter itCostCenter = {
        code: "CC-IT-ACME",
        name: "IT Department - ACME Subsidiary",
        activeFlag: true,
        currency: {
            isocode: "USD",
            symbol: "$",
            name: "US Dollar",
            active: true
        },
        "unit": {
            uid: "acme-subsidiary"
        }
    };
    
    commerce:B2BCostCenter createdItCostCenter = check sapCommerceClient->createCostCenter(
        baseSiteId, 
        itCostCenter,
        fields = "FULL"
    );
    
    io:println("✓ Created IT cost center: " + (createdItCostCenter.name ?: "Unknown"));
    io:println("  Code: " + (createdItCostCenter.code ?: "Unknown"));
    
    // Marketing Department Cost Center
    commerce:B2BCostCenter marketingCostCenter = {
        code: "CC-MKT-ACME",
        name: "Marketing Department - ACME Subsidiary",
        activeFlag: true,
        currency: {
            isocode: "USD",
            symbol: "$",
            name: "US Dollar",
            active: true
        },
        "unit": {
            uid: "acme-subsidiary"
        }
    };
    
    commerce:B2BCostCenter createdMarketingCostCenter = check sapCommerceClient->createCostCenter(
        baseSiteId, 
        marketingCostCenter,
        fields = "FULL"
    );
    
    io:println("✓ Created Marketing cost center: " + (createdMarketingCostCenter.name ?: "Unknown"));
    io:println("  Code: " + (createdMarketingCostCenter.code ?: "Unknown"));
    
    // Operations Department Cost Center
    commerce:B2BCostCenter operationsCostCenter = {
        code: "CC-OPS-ACME",
        name: "Operations Department - ACME Subsidiary",
        activeFlag: true,
        currency: {
            isocode: "USD",
            symbol: "$",
            name: "US Dollar",
            active: true
        },
        "unit": {
            uid: "acme-subsidiary"
        }
    };
    
    commerce:B2BCostCenter createdOperationsCostCenter = check sapCommerceClient->createCostCenter(
        baseSiteId, 
        operationsCostCenter,
        fields = "FULL"
    );
    
    io:println("✓ Created Operations cost center: " + (createdOperationsCostCenter.name ?: "Unknown"));
    io:println("  Code: " + (createdOperationsCostCenter.code ?: "Unknown"));
    
    // Step 3: Create budgets for each cost center
    io:println("\n3. Creating budget allocations...");
    
    // IT Department Budget
    commerce:Budget itBudget = {
        code: "BUDGET-IT-2024",
        name: "IT Department Budget 2024",
        budget: 50000.00,
        currency: {
            isocode: "USD",
            symbol: "$",
            name: "US Dollar"
        },
        costCenters: [{
            code: "CC-IT-ACME",
            name: "IT Department - ACME Subsidiary"
        }],
        "unit": {
            uid: "acme-subsidiary"
        },
        active: true,
        startDate: "2024-01-01T00:00:00Z",
        endDate: "2024-12-31T23:59:59Z"
    };
    
    commerce:Budget createdItBudget = check sapCommerceClient->createBudget(
        baseSiteId, 
        userId, 
        itBudget,
        fields = "FULL"
    );
    
    decimal itBudgetAmount = createdItBudget.budget ?: 0;
    io:println("✓ Created IT budget: " + (createdItBudget.name ?: "Unknown"));
    io:println("  Amount: $" + itBudgetAmount.toString());
    
    // Marketing Department Budget
    commerce:Budget marketingBudget = {
        code: "BUDGET-MKT-2024",
        name: "Marketing Department Budget 2024",
        budget: 75000.00,
        currency: {
            isocode: "USD",
            symbol: "$",
            name: "US Dollar"
        },
        costCenters: [{
            code: "CC-MKT-ACME",
            name: "Marketing Department - ACME Subsidiary"
        }],
        "unit": {
            uid: "acme-subsidiary"
        },
        active: true,
        startDate: "2024-01-01T00:00:00Z",
        endDate: "2024-12-31T23:59:59Z"
    };
    
    commerce:Budget createdMarketingBudget = check sapCommerceClient->createBudget(
        baseSiteId, 
        userId, 
        marketingBudget,
        fields = "FULL"
    );
    
    decimal marketingBudgetAmount = createdMarketingBudget.budget ?: 0;
    io:println("✓ Created Marketing budget: " + (createdMarketingBudget.name ?: "Unknown"));
    io:println("  Amount: $" + marketingBudgetAmount.toString());
    
    // Operations Department Budget
    commerce:Budget operationsBudget = {
        code: "BUDGET-OPS-2024",
        name: "Operations Department Budget 2024",
        budget: 100000.00,
        currency: {
            isocode: "USD",
            symbol: "$",
            name: "US Dollar"
        },
        costCenters: [{
            code: "CC-OPS-ACME",
            name: "Operations Department - ACME Subsidiary"
        }],
        "unit": {
            uid: "acme-subsidiary"
        },
        active: true,
        startDate: "2024-01-01T00:00:00Z",
        endDate: "2024-12-31T23:59:59Z"
    };
    
    commerce:Budget createdOperationsBudget = check sapCommerceClient->createBudget(
        baseSiteId, 
        userId, 
        operationsBudget,
        fields = "FULL"
    );
    
    decimal operationsBudgetAmount = createdOperationsBudget.budget ?: 0;
    io:println("✓ Created Operations budget: " + (createdOperationsBudget.name ?: "Unknown"));
    io:println("  Amount: $" + operationsBudgetAmount.toString());
    
    // Summary
    io:println("\n=== Organizational Setup Complete ===");
    io:println("Subsidiary: ACME Corp");
    io:println("Cost Centers Created: 3 (IT, Marketing, Operations)");
    io:println("Total Budget Allocated: $225,000");
    io:println("Setup enables proper spending controls and approval workflows");
    
    io:println("\n✓ B2B organizational setup completed successfully!");
}