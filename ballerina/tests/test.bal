// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
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
import smartsheet.mock.server as _;

configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable string token = isLiveServer ? os:getEnv("SMARTSHEET_TOKEN") : "test_token";
configurable string serviceUrl = isLiveServer ? "https://api.smartsheet.com/2.0" : "http://localhost:9090";

ConnectionConfig config = {auth: {token}};
final Client smartsheet = check new Client(config, serviceUrl);

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteFolder() returns error? {
    GenericResult response = check smartsheet->/folders/[123456789].delete();
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.message !is (), "Expected message to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteSheet() returns error? {
    SuccessResult response = check smartsheet->/sheets/[987654321].delete();
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.message !is (), "Expected message to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteColumn() returns error? {
    GenericResult response = check smartsheet->/sheets/[987654321]/columns/[1001].delete();
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.message !is (), "Expected message to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteRows() returns error? {
    RowListResponse response = check smartsheet->/sheets/[987654321]/rows.delete(ids = "1234567890,2345678901");
    test:assertTrue(response?.result !is (), "Expected result to be present");
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteWorkspace() returns error? {
    GenericResult response = check smartsheet->/workspaces/["123456789"].delete();
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.message !is (), "Expected message to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetFolder() returns error? {
    Folder response = check smartsheet->/folders/[123456789].get();
    test:assertTrue(response?.name !is (), "Expected folder name to be present");
    test:assertTrue(response?.id !is (), "Expected folder id to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testListFolders() returns error? {
    SearchResponse response = check smartsheet->/folders/[123456789]/folders.get();
    test:assertTrue(response?.result !is (), "Expected result to be present");
    test:assertTrue(response?.totalCount !is (), "Expected totalCount to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testSearchEverything() returns error? {
    UserCreateResponse response = check smartsheet->/search.get(query = "test");
    test:assertTrue(response?.results !is (), "Expected results to be present");
    test:assertTrue(response?.totalCount !is (), "Expected totalCount to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testListSheets() returns error? {
    AlternateEmailListResponse response = check smartsheet->/sheets.get();
    SchemasSheet[]? sheetsData = response.data;
    if sheetsData is SchemasSheet[] {
        test:assertTrue(sheetsData.length() > 0, "Expected a non-empty sheets array");
    }
    test:assertTrue(response?.totalCount !is (), "Expected totalCount to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetSheet() returns error? {
    anydata response = check smartsheet->/sheets/[987654321].get();
    test:assertTrue(response !is (), "Expected sheet data to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetAttachment() returns error? {
    AttachmentResponse response = check smartsheet->/sheets/[987654321]/attachments/["456789"].get();
    test:assertTrue(response?.id !is (), "Expected attachment id to be present");
    test:assertTrue(response?.name !is (), "Expected attachment name to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testListColumns() returns error? {
    ColumnListResponse response = check smartsheet->/sheets/[987654321]/columns.get();
    GetColumn[]? columnsData = response.data;
    if columnsData is GetColumn[] {
        test:assertTrue(columnsData.length() > 0, "Expected a non-empty columns array");
    }
    test:assertTrue(response?.totalCount !is (), "Expected totalCount to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetColumn() returns error? {
    ColumnResponse response = check smartsheet->/sheets/[987654321]/columns/[1001].get();
    test:assertTrue(response?.id !is (), "Expected column id to be present");
    test:assertTrue(response?.title !is (), "Expected column title to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetRow() returns error? {
    RowResponse response = check smartsheet->/sheets/[987654321]/rows/[2001].get();
    test:assertTrue(response?.id !is (), "Expected row id to be present");
    test:assertTrue(response?.rowNumber !is (), "Expected row number to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testListUsers() returns error? {
    UserListResponse response = check smartsheet->/users.get();
    User[]? usersData = response.data;
    if usersData is User[] {
        test:assertTrue(usersData.length() > 0, "Expected a non-empty users array");
    }
    test:assertTrue(response?.totalCount !is (), "Expected totalCount to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetCurrentUser() returns error? {
    UserImgProfileResponse response = check smartsheet->/users/me.get();
    test:assertTrue(response?.id !is (), "Expected user id to be present");
    test:assertTrue(response?.email !is (), "Expected user email to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testListWorkspaces() returns error? {
    WorkspaceShareListResponse response = check smartsheet->/workspaces.get();
    WorkspaceListing[]? workspacesData = response.data;
    if workspacesData is WorkspaceListing[] {
        test:assertTrue(workspacesData.length() > 0, "Expected a non-empty workspaces array");
    }
    test:assertTrue(response?.totalCount !is (), "Expected totalCount to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetWorkspace() returns error? {
    Workspace response = check smartsheet->/workspaces/["123456789"].get();
    test:assertTrue(response?.id !is (), "Expected workspace id to be present");
    test:assertTrue(response?.name !is (), "Expected workspace name to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateFolderInFolder() returns error? {
    FolderCreateResponse response = check smartsheet->/folders/[123456789]/folders.post({name: "Test Folder"});
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    anydata? result = response?.result;
    test:assertTrue(result !is (), "Expected result to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateSheet() returns error? {
    CreateSheetBody sheetsBody = {name: "Test Sheet", columns: []};
    WebhookResponse response = check smartsheet->/sheets.post(sheetsBody);
    int? resultCode = response?.resultCode;
    test:assertTrue(resultCode !is (), "Expected resultCode to be present");
    anydata? result = response?.result;
    test:assertTrue(result !is (), "Expected result to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testAttachFileToSheet() returns error? {
    byte[] fileContent = "test file content".toBytes();
    AttachmentVersionResponse response = check smartsheet->/sheets/[987654321]/attachments.post(fileContent);
    anydata? id = response?.id;
    test:assertTrue(id !is (), "Expected attachment id to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testAddColumns() returns error? {
    ColumnCreateResponse response = check smartsheet->/sheets/[987654321]/columns.post({title: "New Column", 'type: "TEXT_NUMBER"});
    anydata? id = response?.id;
    test:assertTrue(id !is (), "Expected column id to be present");
    anydata? title = response?.title;
    test:assertTrue(title !is (), "Expected column title to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testAddRows() returns error? {
    RowMoveResponse response = check smartsheet->/sheets/[987654321]/rows.post([{cells: [{columnId: 1001, value: "Test"}]}]);
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.result !is (), "Expected result to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testShareSheet() returns error? {
    ShareCreateResponse response = check smartsheet->/sheets/[987654321]/shares.post([{email: "test@example.com", accessLevel: "VIEWER"}]);
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.result !is (), "Expected result to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateWorkspace() returns error? {
    WorkspaceResponse response = check smartsheet->/workspaces.post({name: "Test Workspace"});
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.result !is (), "Expected result to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateFolder() returns error? {
    CrossSheetReferenceResponse response = check smartsheet->/folders/[123456789].put({name: "Updated Folder"});
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.result !is (), "Expected result to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateSheet() returns error? {
    AttachmentListResponse response = check smartsheet->/sheets/[987654321].put({name: "Updated Sheet"});
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.result !is (), "Expected result to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateColumn() returns error? {
    ColumnUpdateResponse response = check smartsheet->/sheets/[987654321]/columns/[1001].put({title: "Updated Column"});
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.result !is (), "Expected result to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateRows() returns error? {
    RowCopyResponse response = check smartsheet->/sheets/[987654321]/rows.put([{id: 2001, cells: [{columnId: 1001, value: "Updated"}]}]);
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
    test:assertTrue(response?.result !is (), "Expected result to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateWorkspace() returns error? {
    WorkspaceCreateResponse response = check smartsheet->/workspaces/["123456789"].put({name: "Updated Workspace"});
    test:assertTrue(response?.result !is (), "Expected result to be present");
    test:assertTrue(response?.resultCode !is (), "Expected resultCode to be present");
}