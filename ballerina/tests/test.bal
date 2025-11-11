// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/os;
import ballerina/test;
import ballerina/http;
import smartsheet.mock.server as _;

configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable string accessToken = isLiveServer ? os:getEnv("SMARTSHEET_ACCESS_TOKEN") : "test_token";
configurable string serviceUrl = isLiveServer ? "https://api.smartsheet.com/2.0" : "http://localhost:9090";

ConnectionConfig config = {
    auth: {
        token: accessToken
    }
};

final Client smartsheetClient = check new Client(config, serviceUrl);

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteFolder() returns error? {
    GenericResult response = check smartsheetClient->/folders/[1234567890123456].delete();
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.message !is (), "Expected message to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteSheet() returns error? {
    SuccessResult response = check smartsheetClient->/sheets/[1111111111111111].delete();
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.message !is (), "Expected message to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteColumn() returns error? {
    GenericResult response = check smartsheetClient->/sheets/[1111111111111111]/columns/[2222222222222222].delete();
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.message !is (), "Expected message to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteRows() returns error? {
    RowListResponse response = check smartsheetClient->/sheets/[1111111111111111]/rows.delete(ids = "5555555555555555,6666666666666666");
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.message !is (), "Expected message to be present");
    test:assertTrue(response?.result !is (), "Expected result to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteWorkspace() returns error? {
    GenericResult response = check smartsheetClient->/workspaces/["5555555555555555"].delete();
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.message !is (), "Expected message to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetFolder() returns error? {
    Folder response = check smartsheetClient->/folders/[1234567890123456].get();
    test:assertTrue(response?.name !is (), "Expected folder name to be present");
    test:assertTrue(response?.id !is (), "Expected folder id to be present");
    test:assertTrue(response?.permalink !is (), "Expected folder permalink to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testListFolders() returns error? {
    SearchResponse response = check smartsheetClient->/folders/[1234567890123456]/folders.get();
    test:assertTrue(response?.result !is (), "Expected result to be present");
    test:assertTrue(response?.pageNumber !is (), "Expected pageNumber to be present");
    test:assertTrue(response?.totalPages !is (), "Expected totalPages to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testSearchEverything() returns error? {
    UserCreateResponse response = check smartsheetClient->/search.get(query = "project");
    test:assertTrue(response?.results !is (), "Expected results to be present");
    test:assertTrue(response?.totalCount !is (), "Expected totalCount to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testListSheets() returns error? {
    AlternateEmailListResponse response = check smartsheetClient->/sheets.get();
    test:assertTrue(response?.data !is (), "Expected data to be present");
    SchemasSheet[]? sheetsData = response.data;
    if sheetsData is SchemasSheet[] {
        test:assertTrue(sheetsData.length() > 0, "Expected non-empty sheets array");
    }
    test:assertTrue(response?.pageNumber !is (), "Expected pageNumber to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetSheet() returns error? {
    anydata response = check smartsheetClient->/sheets/[1111111111111111].get();
    test:assertTrue(response !is (), "Expected sheet data to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetAttachment() returns error? {
    AttachmentResponse response = check smartsheetClient->/sheets/[1111111111111111]/attachments/["9876543210987654"].get();
    test:assertTrue(response?.id !is (), "Expected attachment id to be present");
    test:assertTrue(response?.name !is (), "Expected attachment name to be present");
    test:assertTrue(response?.attachmentType !is (), "Expected attachment type to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testListColumns() returns error? {
    ColumnListResponse response = check smartsheetClient->/sheets/[1111111111111111]/columns.get();
    test:assertTrue(response?.data !is (), "Expected data to be present");
    GetColumn[]? columnsData = response.data;
    if columnsData is GetColumn[] {
        test:assertTrue(columnsData.length() > 0, "Expected non-empty columns array");
    }
    test:assertTrue(response?.pageNumber !is (), "Expected pageNumber to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetColumn() returns error? {
    ColumnResponse response = check smartsheetClient->/sheets/[1111111111111111]/columns/[2222222222222222].get();
    test:assertTrue(response?.id !is (), "Expected column id to be present");
    test:assertTrue(response?.title !is (), "Expected column title to be present");
    test:assertTrue(response?.'type !is (), "Expected column type to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetRow() returns error? {
    RowResponse response = check smartsheetClient->/sheets/[1111111111111111]/rows/[5555555555555555].get();
    test:assertTrue(response?.id !is (), "Expected row id to be present");
    test:assertTrue(response?.rowNumber !is (), "Expected row number to be present");
    test:assertTrue(response?.cells !is (), "Expected cells to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testListUsers() returns error? {
    UserListResponse response = check smartsheetClient->/users.get();
    test:assertTrue(response?.data !is (), "Expected data to be present");
    User[]? usersData = response.data;
    if usersData is User[] {
        test:assertTrue(usersData.length() > 0, "Expected non-empty users array");
    }
    test:assertTrue(response?.pageNumber !is (), "Expected pageNumber to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetCurrentUser() returns error? {
    UserImgProfileResponse response = check smartsheetClient->/users/me.get();
    test:assertTrue(response?.id !is (), "Expected user id to be present");
    test:assertTrue(response?.email !is (), "Expected user email to be present");
    test:assertTrue(response?.firstName !is (), "Expected user firstName to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testListWorkspaces() returns error? {
    WorkspaceShareListResponse response = check smartsheetClient->/workspaces.get();
    test:assertTrue(response?.data !is (), "Expected data to be present");
    WorkspaceListing[]? workspacesData = response.data;
    if workspacesData is WorkspaceListing[] {
        test:assertTrue(workspacesData.length() > 0, "Expected non-empty workspaces array");
    }
    test:assertTrue(response?.pageNumber !is (), "Expected pageNumber to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetWorkspace() returns error? {
    Workspace response = check smartsheetClient->/workspaces/["5555555555555555"].get();
    test:assertTrue(response?.id !is (), "Expected workspace id to be present");
    test:assertTrue(response?.name !is (), "Expected workspace name to be present");
    test:assertTrue(response?.accessLevel !is (), "Expected workspace access level to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateFolder() returns error? {
    FolderIdFoldersBody payload = {
        name: "Test Folder"
    };
    SharedSecretResponse response = check smartsheetClient->/folders/[1234567890123456]/folders.post(payload);
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateSheet() returns error? {
    SheetsBody payload = {
        name: "Test Sheet",
        columns: [
            {
                title: "Task Name",
                'type: "TEXT_NUMBER",
                primary: true
            }
        ]
    };
    WebhookResponse response = check smartsheetClient->/sheets.post(payload);
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testAttachFileToSheet() returns error? {
    byte[] fileContent = "test file content".toBytes();
    AttachmentVersionResponse response = check smartsheetClient->/sheets/[1111111111111111]/attachments.post(fileContent);
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testAddColumns() returns error? {
    ColumnObjectAttributes payload = {
        title: "New Column",
        'type: "TEXT_NUMBER",
        index: 1
    };
    ColumnCreateResponse response = check smartsheetClient->/sheets/[1111111111111111]/columns.post(payload);
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testAddRows() returns error? {
    SheetIdRowsBody1 payload = [
        {
            cells: [
                {
                    columnId: 1111111111111111,
                    value: "New Task"
                }
            ]
        }
    ];
    RowMoveResponse response = check smartsheetClient->/sheets/[1111111111111111]/rows.post(payload);
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testShareSheet() returns error? {
    SheetIdSharesBody payload = {
        email: "test@example.com",
        accessLevel: "VIEWER"
    };
    TokenResponse response = check smartsheetClient->/sheets/[1111111111111111]/shares.post(payload);
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateWorkspace() returns error? {
    WorkspacesBody payload = {
        name: "Test Workspace"
    };
    WorkspaceResponse response = check smartsheetClient->/workspaces.post(payload);
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateFolder() returns error? {
    Folder payload = {
        name: "Updated Folder Name"
    };
    CrossSheetReferenceResponse response = check smartsheetClient->/folders/[1234567890123456].put(payload);
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.message !is (), "Expected message to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateSheet() returns error? {
    UpdateSheet payload = {
        name: "Updated Sheet Name"
    };
    AttachmentListResponse response = check smartsheetClient->/sheets/[1111111111111111].put(payload);
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.message !is (), "Expected message to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateColumn() returns error? {
    ColumnObjectAttributes payload = {
        title: "Updated Column Title",
        index: 1
    };
    ColumnUpdateResponse response = check smartsheetClient->/sheets/[1111111111111111]/columns/[2222222222222222].put(payload);
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.message !is (), "Expected message to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateRows() returns error? {
    SheetIdRowsBody payload = [
        {
            id: 5555555555555555,
            cells: [
                {
                    columnId: 1111111111111111,
                    value: "Updated Task Name"
                }
            ]
        }
    ];
    RowCopyResponse response = check smartsheetClient->/sheets/[1111111111111111]/rows.put(payload);
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.message !is (), "Expected message to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateWorkspace() returns error? {
    WorkspacesworkspaceIdBody payload = {
        name: "Updated Workspace Name"
    };
    WorkspaceCreateResponse response = check smartsheetClient->/workspaces/["5555555555555555"].put(payload);
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.message !is (), "Expected message to be present");
}