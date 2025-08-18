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

import ballerina/http;
import ballerina/log;

listener http:Listener httpListener = new (9090);

http:Service mockService = service object {
    # Delete Sheet
    #
    # + Authorization - API Access Token used to authenticate requests to Smartsheet APIs
    # + sheetId - Sheet Id of the sheet being accessed
    # + return - returns can be any of following types
    # http:Ok (SUCCESS)
    # http:DefaultStatusCodeResponse (Generic Error Payload)
    resource function delete sheets/[decimal sheetId](@http:Header {name: "Authorization"} string? authorization) returns SuccessResult|ErrorDefault {
        return {
            resultCode: 0,
            message: "SUCCESS"
        };
    }

    # Delete Rows
    #
    # + sheetId - Sheet Id of the sheet being accessed
    # + Authorization - API Access Token used to authenticate requests to Smartsheet APIs
    # + ids - A comma-separated list of row Ids
    # + ignoreRowsNotFound - **true** or **false**. If set to **false** and any of the specified row Ids are not found, no rows are deleted, and the "not found" [error](/api/smartsheet/openapi/schemas/error) is returned
    # + return - returns can be any of following types
    # http:Ok (Returns [Result object](/api/smartsheet/openapi/schemas/result) containing row Ids corresponding to all rows that were successfully deleted (including any child rows of rows specified in the URL))
    # http:NotFound (Not Found.  See Smartsheet Error Code and Message for details.
    # )
    resource function delete sheets/[decimal sheetId]/rows(@http:Header {name: "Authorization"} string? authorization, string ids, boolean ignoreRowsNotFound = false) returns RowListResponse|ErrorNotFound {
        string[] rowIds = re `\s*,\s*`.split(ids);
        decimal[] deletedRowIds = [];

        foreach string rowId in rowIds {
            decimal|error id = decimal:fromString(rowId);
            if id is decimal {
                deletedRowIds.push(id);
            }
        }

        return {
            resultCode: 0,
            message: "SUCCESS",
            result: deletedRowIds
        };
    }

    # Get Folder
    #
    # + Authorization - API Access Token used to authenticate requests to Smartsheet APIs
    # + folderId - Folder Id where you can create sheets, sights, reports, templates, and other folders
    # + include - A comma-separated list of optional elements to include in the response:
    # * **source** - adds the Source object indicating which object the folder was created from, if any
    # * **distributionLink**
    # * **ownerInfo** Returns the user with owner permissions, or the user with admin permissions if there is no owner assigned. If no owner or admins are assigned, the Plan Asset Admin is returned. If no Plan Asset Admin is assigned, the System Admin is returned.
    # * **sheetVersion**
    # * **permalinks**
    # + return - returns can be any of following types
    # http:Ok (A single Folder object)
    # http:DefaultStatusCodeResponse (Generic Error Payload)
    resource function get folders/[decimal folderId](@http:Header {name: "Authorization"} string? authorization, "source"|"distributionLink"|"ownerInfo"|"sheetVersion"? include) returns Folder|ErrorDefault {
        return {
            id: folderId,
            name: "Sample Folder",
            permalink: "https://app.smartsheet.com/folders/" + folderId.toString(),
            sheets: [
                {
                    id: 12345,
                    name: "Sample Sheet 1",
                    permalink: "https://app.smartsheet.com/sheets/12345"
                },
                {
                    id: 12346,
                    name: "Sample Sheet 2",
                    permalink: "https://app.smartsheet.com/sheets/12346"
                }
            ],
            folders: [
                {
                    id: 67890,
                    name: "Subfolder 1",
                    permalink: "https://app.smartsheet.com/folders/67890"
                }
            ],
            reports: [
                {
                    id: 11111,
                    name: "Sample Report",
                    permalink: "https://app.smartsheet.com/reports/11111"
                }
            ]
        };
    }

    # List Sheets
    #
    # + accessApiLevel - Allows COMMENTER access for inputs and return values. For backwards-compatibility, VIEWER is the default. For example, to see whether a user has COMMENTER access for a sheet, use accessApiLevel=1
    # + Authorization - API Access Token used to authenticate requests to Smartsheet APIs
    # + include - A comma-separated list of optional elements to include in the response:
    # * **sheetVersion** - current version number of each sheet, should not be combined with pagination
    # * **source** - the Source object for any sheet that was created from another sheet, if any
    # + includeAll - If true, include all results, that is, do not paginate. Mutually exclusive with page and pageSize (they are ignored if includeAll=true is specified)
    # + modifiedSince - When specified with a date and time value, response only includes the objects that are modified on or after the date and time specified. If you need to keep track of frequent changes, it may be more useful to use Get Sheet Version
    # + numericDates - You can optionally choose to receive and send dates/times in numeric format, as milliseconds since the UNIX epoch (midnight on January 1, 1970 in UTC time), using the query string parameter numericDates with a value of true. This query parameter works for any API request
    # + page - Which page to return. Defaults to 1 if not specified. If you specify a value greater than the total number of pages, the last page of results is returned
    # + pageSize - The maximum number of items to return per page. Unless otherwise stated for a specific endpoint, defaults to 100. If only page is specified, defaults to a page size of 100. For reports, the default is 100 rows. If you need larger sets of data from your report, returns a maximum of 10,000 rows per request
    # + return - returns can be any of following types
    # http:Ok (SUCCESS)
    # http:DefaultStatusCodeResponse (Generic Error Payload)
    resource function get sheets(@http:Header {name: "Authorization"} string? authorization, "sheetVersion"|"source"? include, string? modifiedSince, decimal accessApiLevel = 0, boolean includeAll = false, boolean numericDates = false, decimal page = 1, decimal pageSize = 100) returns AlternateEmailListResponse|ErrorDefault {
        return {
            pageNumber: page,
            pageSize: pageSize,
            totalPages: 1,
            totalCount: 3,
            data: [
                {
                    id: 12345,
                    name: "Project Planning Sheet",
                    accessLevel: "OWNER",
                    permalink: "https://app.smartsheet.com/sheets/12345",
                    createdAt: "2024-01-15T10:30:00Z",
                    modifiedAt: "2024-01-20T14:45:00Z",
                    version: 5
                },
                {
                    id: 12346,
                    name: "Budget Tracking",
                    accessLevel: "EDITOR",
                    permalink: "https://app.smartsheet.com/sheets/12346",
                    createdAt: "2024-01-10T09:15:00Z",
                    modifiedAt: "2024-01-18T16:20:00Z",
                    version: 3
                },
                {
                    id: 12347,
                    name: "Task Management",
                    accessLevel: "VIEWER",
                    permalink: "https://app.smartsheet.com/sheets/12347",
                    createdAt: "2024-01-05T11:00:00Z",
                    modifiedAt: "2024-01-15T13:30:00Z",
                    version: 7
                }
            ]
        };
    }

    # Get Sheet
    #
    # + Authorization - API Access Token used to authenticate requests to Smartsheet APIs
    # + sheetId - Sheet Id of the sheet being accessed
    # + Accept - The Accept request-header field can be used to specify certain media types which are acceptable for the response
    # + accessApiLevel - Allows COMMENTER access for inputs and return values. For backwards-compatibility, VIEWER is the default. For example, to see whether a user has COMMENTER access for a sheet, use accessApiLevel=1
    # + include - A comma-separated list of optional elements to include in the response:
    # * **attachments** - includes the metadata for sheet-level and row-level attachments. To include discussion attachments, both attachments and discussions must be present in the include list.
    # * **columnType** -includes columnType attribute in the row's cells indicating the type of the column the cell resides in.
    # * **crossSheetReferences** - includes the cross-sheet references
    # * **discussions** - includes sheet-level and row-level discussions. To include discussion attachments, both attachments and discussions must be present in the include list.
    # * **filters** - includes filteredOut attribute indicating if the row should be displayed or hidden according to the sheet's filters.
    # * **filterDefinitions** - includes type of filter, operators used, and criteria
    # * **format** -  includes column, row, cell, and summary fields formatting.
    # * **ganttConfig** - includes Gantt chart details.
    # * **objectValue** - when used in combination with a level query parameter, includes the email addresses for multi-contact data.
    # * **ownerInfo** - includes the owner's email address and the owner's user Id.
    # * **rowPermalink** - includes permalink attribute that represents a direct link to the row in the Smartsheet application.
    # * **source** - adds the Source object indicating which report, sheet  Sight (aka dashboard), or template the sheet was created from, if any.
    # * **writerInfo** - includes createdBy and modifiedBy attributes on the row or summary fields, indicating the row or summary field's creator, and last modifier
    # + exclude - A comma-separated list of element types to exclude from the response:
    # * **filteredOutRows** - excludes filtered-out rows from response payload if a sheet filter is applied; includes total number of filtered rows
    # * **linkInFromCellDetails** - excludes the following attributes from the **cell.linkInFromCell** object: `columnId`, `rowId`, `status`
    # * **linksOutToCellsDetails** - excludes the following attributes from the **cell.linksOutToCells** array elements: `columnId`, `rowId`, `status`
    # * **nonexistentCells** - excludes empty cells
    # + columnIds - A comma-separated list of column ids. The response contains only the specified columns in the "columns" array, and individual rows' "cells" array only contains cells in the specified columns
    # + filterId - Overrides the existing include={filters} parameter if both are supplied. Applies the given filter (if accessible by the calling user) and marks the affected rows as "filteredOut": true
    # + ifVersionAfter - If version specified is still the current sheet version, then returns an abbreviated Sheet object with only the sheet version property. Otherwise, if the sheet has been modified, returns the complete Sheet object. Intended to allow clients with a cached copy to make sure they have the latest version
    # + level - Specifies whether object data types, such as multi-contact data are returned in a backwards-compatible, text format in text/number columns.<br>  - Set `level=0` (default) to use text/number columns for multi-contact data and multi-picklist data.<br>  - Set `level=1` to use multiple-entry contact list columns for multi-contact data; multi-picklist data is returned in text/number columns.<br>  - Set `level=2` to use multiple-entry contact list columns for multi-contact data and use multiple-entry picklist columns for multi-picklist data
    # + pageSize - The maximum number of items to return per page. Unless otherwise stated for a specific endpoint, defaults to 100. If only page is specified, defaults to a page size of 100. For reports, the default is 100 rows. If you need larger sets of data from your report, returns a maximum of 10,000 rows per request
    # + page - Which page to return. Defaults to 1 if not specified. If you specify a value greater than the total number of pages, the last page of results is returned
    # + paperSize - applies to PDF format only
    # + rowIds - A comma-separated list of row Ids on which to filter the rows included in the result
    # + rowNumbers - A comma-separated list of row numbers on which to filter the rows included in the result. Non-existent row numbers are ignored
    # + rowsModifiedSince - Filter to return only rows that have been modified since the date/time provided. Date should be in ISO-8601 format
    # + return - returns can be any of following types
    # http:Ok (The Sheet that was loaded)
    # http:DefaultStatusCodeResponse (Generic Error Payload)
    resource function get sheets/[decimal sheetId](@http:Header {name: "Authorization"} string? authorization, @http:Header {name: "Accept"} string? accept, "attachments"|"columnType"|"crossSheetReferences"|"discussions"|"filters"|"filterDefinitions"|"format"|"ganttConfig"|"objectValue"|"ownerInfo"|"rowPermalink"|"source"|"writerInfo"? include, "filteredOutRows"|"linkInFromCellDetails"|"linksOutToCellsDetails"|"nonexistentCells"? exclude, string? columnIds, string? filterId, int? ifVersionAfter, string? rowIds, string? rowNumbers, string? rowsModifiedSince, decimal accessApiLevel = 0, int level = 0, decimal pageSize = 100, decimal page = 1, "LETTER"|"LEGAL"|"WIDE"|"ARCHD"|"A4"|"A3"|"A2"|"A1"|"A0" paperSize = "LETTER") returns anydata {
        return {
            id: sheetId,
            name: "Sample Sheet " + sheetId.toString(),
            accessLevel: "OWNER",
            permalink: "https://app.smartsheet.com/sheets/" + sheetId.toString(),
            version: 10,
            totalRowCount: 5,
            createdAt: "2024-01-15T10:30:00Z",
            modifiedAt: "2024-01-20T14:45:00Z",
            columns: [
                {
                    id: 1001,
                    index: 0,
                    title: "Task Name",
                    'type: "TEXT_NUMBER",
                    primary: true,
                    width: 200
                },
                {
                    id: 1002,
                    index: 1,
                    title: "Assigned To",
                    'type: "CONTACT_LIST",
                    width: 150
                },
                {
                    id: 1003,
                    index: 2,
                    title: "Status",
                    'type: "PICKLIST",
                    options: ["Not Started", "In Progress", "Complete"],
                    width: 100
                },
                {
                    id: 1004,
                    index: 3,
                    title: "Due Date",
                    'type: "DATE",
                    width: 120
                }
            ],
            rows: [
                {
                    id: 2001,
                    rowNumber: 1,
                    expanded: true,
                    createdAt: "2024-01-15T10:30:00Z",
                    modifiedAt: "2024-01-20T14:45:00Z",
                    cells: [
                        {
                            columnId: 1001,
                            value: "Project Planning",
                            displayValue: "Project Planning"
                        },
                        {
                            columnId: 1002,
                            value: "john.doe@example.com",
                            displayValue: "John Doe"
                        },
                        {
                            columnId: 1003,
                            value: "In Progress",
                            displayValue: "In Progress"
                        },
                        {
                            columnId: 1004,
                            value: "2024-02-15",
                            displayValue: "02/15/24"
                        }
                    ]
                },
                {
                    id: 2002,
                    rowNumber: 2,
                    expanded: true,
                    createdAt: "2024-01-16T09:15:00Z",
                    modifiedAt: "2024-01-19T11:30:00Z",
                    cells: [
                        {
                            columnId: 1001,
                            value: "Design Review",
                            displayValue: "Design Review"
                        },
                        {
                            columnId: 1002,
                            value: "jane.smith@example.com",
                            displayValue: "Jane Smith"
                        },
                        {
                            columnId: 1003,
                            value: "Not Started",
                            displayValue: "Not Started"
                        },
                        {
                            columnId: 1004,
                            value: "2024-02-20",
                            displayValue: "02/20/24"
                        }
                    ]
                }
            ]
        };
    }

    # List Columns
    #
    # + sheetId - Sheet Id of the sheet being accessed
    # + Authorization - API Access Token used to authenticate requests to Smartsheet APIs
    # + level - Specifies whether object data types, such as multi-contact data are returned in a backwards-compatible, text format in text/number columns.<br>  - Set `level=0` (default) to use text/number columns for multi-contact data and multi-picklist data.<br>  - Set `level=1` to use multiple-entry contact list columns for multi-contact data; multi-picklist data is returned in text/number columns.<br>  - Set `level=2` to use multiple-entry contact list columns for multi-contact data and use multiple-entry picklist columns for multi-picklist data
    # + page - Which page to return. Defaults to 1 if not specified. If you specify a value greater than the total number of pages, the last page of results is returned
    # + pageSize - The maximum number of items to return per page. Unless otherwise stated for a specific endpoint, defaults to 100. If only page is specified, defaults to a page size of 100. For reports, the default is 100 rows. If you need larger sets of data from your report, returns a maximum of 10,000 rows per request
    # + includeAll - If true, include all results, that is, do not paginate. Mutually exclusive with page and pageSize (they are ignored if includeAll=true is specified)
    # + return - Returns [IndexResult object]() containing an array of [Column objects]()
    resource function get sheets/[decimal sheetId]/columns(@http:Header {name: "Authorization"} string? authorization, int level = 0, decimal page = 1, decimal pageSize = 100, boolean includeAll = false) returns ColumnListResponse {
        return {
            pageNumber: page,
            pageSize: pageSize,
            totalPages: 1,
            totalCount: 4,
            data: [
                {
                    id: 1001,
                    index: 0,
                    title: "Task Name",
                    'type: "TEXT_NUMBER",
                    validation: false
                },
                {
                    id: 1002,
                    index: 1,
                    title: "Assigned To",
                    'type: "CONTACT_LIST",
                    validation: false
                },
                {
                    id: 1003,
                    index: 2,
                    title: "Status",
                    'type: "PICKLIST",
                    validation: true
                },
                {
                    id: 1004,
                    index: 3,
                    title: "Due Date",
                    'type: "DATE",
                    validation: false
                }
            ]
        };
    }

    # Get Row
    #
    # + sheetId - Sheet Id of the sheet being accessed
    # + rowId - Row Id in the sheet being accessed
    # + Authorization - API Access Token used to authenticate requests to Smartsheet APIs
    # + accessApiLevel - Allows COMMENTER access for inputs and return values. For backwards-compatibility, VIEWER is the default. For example, to see whether a user has COMMENTER access for a sheet, use accessApiLevel=1
    # + include - A comma-separated list of elements to include in the response.
    # See [Row Include Flags](/api/smartsheet/openapi/rows).
    # Also supports the **columns** include flag, which adds a columns array that specifies all of the columns for the sheet. This enables you to have the full context of the cells in the row.
    # The **filters** include flag returns a **filteredOut** attribute indicating if the row should be displayed or hidden according to the sheet's filters
    # + exclude - A comma-separated list of element types to exclude from the response:
    # * **filteredOutRows** - excludes filtered-out rows from response payload if a sheet filter is applied; includes total number of filtered rows
    # * **linkInFromCellDetails** - excludes the following attributes from the **cell.linkInFromCell** object: `columnId`, `rowId`, `status`
    # * **linksOutToCellsDetails** - excludes the following attributes from the **cell.linksOutToCells** array elements: `columnId`, `rowId`, `status`
    # * **nonexistentCells** - excludes empty cells
    # + level - Specifies whether object data types, such as multi-contact data are returned in a backwards-compatible, text format in text/number columns.<br>  - Set `level=0` (default) to use text/number columns for multi-contact data and multi-picklist data.<br>  - Set `level=1` to use multiple-entry contact list columns for multi-contact data; multi-picklist data is returned in text/number columns.<br>  - Set `level=2` to use multiple-entry contact list columns for multi-contact data and use multiple-entry picklist columns for multi-picklist data
    # + return - Returns [Row object]() populated according to the specified parameters
    resource function get sheets/[decimal sheetId]/rows/[decimal rowId](@http:Header {name: "Authorization"} string? authorization, "columns"|"filters"? include, "filteredOutRows"|"linkInFromCellDetails"|"linksOutToCellsDetails"|"nonexistentCells"? exclude, decimal accessApiLevel = 0, int level = 0) returns RowResponse {
        return {
            id: rowId,
            rowNumber: 1,
            sheetId: sheetId,
            expanded: true,
            createdAt: "2024-01-15T10:30:00Z",
            modifiedAt: "2024-01-20T14:45:00Z",
            cells: [
                {
                    columnId: 1001,
                    value: "Sample Task",
                    displayValue: "Sample Task"
                },
                {
                    columnId: 1002,
                    value: "user@example.com",
                    displayValue: "Sample User"
                },
                {
                    columnId: 1003,
                    value: "In Progress",
                    displayValue: "In Progress"
                },
                {
                    columnId: 1004,
                    value: "2024-02-15",
                    displayValue: "02/15/24"
                }
            ]
        };
    }

    # List Users
    #
    # + Authorization - API Access Token used to authenticate requests to Smartsheet APIs
    # + email - Comma-separated list of email addresses on which to filter the results
    # + include - If the API request is submitted by a system administrator and when specified with a value of 'lastLogin', response includes a lastLogin attribute for each user that indicates the Last login date/time of the user.
    # **Note** If the number of users included in the response is > 100, you must paginate your query to see the lastLogin attribute. For large responses, the lastLogin attribute is never included
    # + includeAll - If true, include all results, that is, do not paginate. Mutually exclusive with page and pageSize (they are ignored if includeAll=true is specified)
    # + numericDates - You can optionally choose to receive and send dates/times in numeric format, as milliseconds since the UNIX epoch (midnight on January 1, 1970 in UTC time), using the query string parameter numericDates with a value of true. This query parameter works for any API request
    # + page - Which page to return. Defaults to 1 if not specified. If you specify a value greater than the total number of pages, the last page of results is returned
    # + pageSize - The maximum number of items to return per page. Unless otherwise stated for a specific endpoint, defaults to 100. If only page is specified, defaults to a page size of 100. For reports, the default is 100 rows. If you need larger sets of data from your report, returns a maximum of 10,000 rows per request
    # + return - returns can be any of following types
    # http:Ok (IndexResult object containing an array of [User objects](/api/smartsheet/openapi/users/user)
    # )
    # http:DefaultStatusCodeResponse (Generic Error Payload)
    resource function get users(@http:Header {name: "Authorization"} string? authorization, string? email, string? include, boolean includeAll = false, boolean numericDates = false, decimal page = 1, decimal pageSize = 100) returns UserListResponse|ErrorDefault {
        return {
            pageNumber: page,
            pageSize: pageSize,
            totalPages: 1,
            totalCount: 3,
            data: [
                {
                    id: 1001,
                    firstName: "John",
                    lastName: "Doe",
                    name: "John Doe",
                    email: "john.doe@example.com",
                    status: "ACTIVE",
                    admin: false,
                    groupAdmin: false,
                    licensedSheetCreator: true,
                    resourceViewer: false,
                    sheetCount: -1
                },
                {
                    id: 1002,
                    firstName: "Jane",
                    lastName: "Smith",
                    name: "Jane Smith",
                    email: "jane.smith@example.com",
                    status: "ACTIVE",
                    admin: true,
                    groupAdmin: true,
                    licensedSheetCreator: true,
                    resourceViewer: true,
                    sheetCount: -1
                },
                {
                    id: 1003,
                    firstName: "Bob",
                    lastName: "Johnson",
                    name: "Bob Johnson",
                    email: "bob.johnson@example.com",
                    status: "ACTIVE",
                    admin: false,
                    groupAdmin: false,
                    licensedSheetCreator: false,
                    resourceViewer: false,
                    sheetCount: -1
                }
            ]
        };
    }

    # Get Current User
    #
    # + Authorization - API Access Token used to authenticate requests to Smartsheet APIs
    # + include - When specified with a value of 'groups', response includes an array of groups (groupId, name, and description only) that the user is a member of
    # + return - returns can be any of following types
    # http:Ok (IndexResultUnknownPages object containing a UserProfile object
    # )
    # http:DefaultStatusCodeResponse (Generic Error Payload)
    resource function get users/me(@http:Header {name: "Authorization"} string? authorization, "groups"? include) returns UserImgProfileResponse|ErrorDefault {
        return {
            id: 1001,
            firstName: "Current",
            lastName: "User",
            email: "current.user@example.com",
            locale: "en_US",
            timeZone: "US/Pacific",
            admin: false,
            groupAdmin: false,
            licensedSheetCreator: true,
            resourceViewer: false,
            sheetCount: -1,
            title: "Project Manager",
            department: "Engineering",
            company: "Example Corp",
            workPhone: "+1-555-123-4567",
            mobilePhone: "+1-555-987-6543",
            account: {
                id: 12345,
                name: "Example Corp Account"
            },
            data: include == "groups" ? [
                    {
                        id: 5001,
                        name: "Project Managers",
                        description: "Group for all project managers"
                    },
                    {
                        id: 5002,
                        name: "Engineering Team",
                        description: "Engineering department group"
                    }
                ] : []
        };
    }
    # List Workspaces
    #
    # + Authorization - API Access Token used to authenticate requests to Smartsheet APIs
    # + accessApiLevel - Allows COMMENTER access for inputs and return values. For backwards-compatibility, VIEWER is the default. For example, to see whether a user has COMMENTER access for a sheet, use accessApiLevel=1
    # + includeAll - If true, include all results, that is, do not paginate. Mutually exclusive with page and pageSize (they are ignored if includeAll=true is specified)
    # + page - Which page to return. Defaults to 1 if not specified. If you specify a value greater than the total number of pages, the last page of results is returned
    # + pageSize - The maximum number of items to return per page. Unless otherwise stated for a specific endpoint, defaults to 100. If only page is specified, defaults to a page size of 100. For reports, the default is 100 rows. If you need larger sets of data from your report, returns a maximum of 10,000 rows per request
    # + return - returns can be any of following types
    # http:Ok (IndexResult object containing an array of Workspace objects)
    # http:DefaultStatusCodeResponse (Generic Error Payload)
    resource function get workspaces(@http:Header {name: "Authorization"} string? authorization, decimal accessApiLevel = 0, boolean includeAll = false, decimal page = 1, decimal pageSize = 100) returns WorkspaceShareListResponse|ErrorDefault {
        return {
            pageNumber: page,
            pageSize: pageSize,
            totalPages: 1,
            totalCount: 2,
            data: [
                {
                    id: 3001,
                    name: "Marketing Workspace",
                    accessLevel: "OWNER",
                    permalink: "https://app.smartsheet.com/workspaces/3001"
                },
                {
                    id: 3002,
                    name: "Engineering Workspace",
                    accessLevel: "EDITOR",
                    permalink: "https://app.smartsheet.com/workspaces/3002"
                }
            ]
        };
    }

    # Add Columns
    #
    # + sheetId - Sheet Id of the sheet being accessed
    # + Authorization - API Access Token used to authenticate requests to Smartsheet APIs
    # + Content\-Type - Required for POST and PUT requests. Defines the structure for the request body
    # + payload - A [Column object]() that contains the following attributes
    # + return - Returns [Result object](/api/smartsheet/openapi/schemas/result) containing the newly created columns -- either a single [Column object](/api/smartsheet/openapi/columns/column) or an array of Column objects, corresponding to what was specified in the request
    resource function post sheets/[decimal sheetId]/columns(@http:Header {name: "Authorization"} string? authorization, @http:Payload ColumnObjectAttributes payload, @http:Header {name: "Content-Type"} string? contentType = "application/json") returns ColumnCreateResponseOk {
        decimal newColumnId = 2000 + sheetId;
        return {
            body: {
                resultCode: 0,
                message: "SUCCESS",
                result: [
                    {
                        id: newColumnId,
                        index: payload.index ?: 0,
                        title: payload.title ?: "New Column",
                        'type: payload.'type ?: "TEXT_NUMBER",
                        validation: payload.validation ?: false,
                        width: payload.width ?: 150,
                        options: payload.options ?: []
                    }
                ]
            }
        };
    }

    # Add Rows
    #
    # + sheetId - Sheet Id of the sheet being accessed
    # + Authorization - API Access Token used to authenticate requests to Smartsheet APIs
    # + accessApiLevel - Allows COMMENTER access for inputs and return values. For backwards-compatibility, VIEWER is the default. For example, to see whether a user has COMMENTER access for a sheet, use accessApiLevel=1
    # + Content\-Type - Required for POST and PUT requests. Defines the structure for the request body
    # + allowPartialSuccess - When specified with a value of true, enables partial success for this bulk operation. See [Bulk operations > Partial success](/api/smartsheet/guides/advanced-topics/scalability-options) for more information
    # + overrideValidation - You may use the query string parameter **overrideValidation** with a value of **true** to allow a cell value outside of the validation limits. You must specify **strict** with a value of **false** to bypass value type checking
    # + payload - [Row object](/api/smartsheet/openapi/rows/row) or an array of Row objects, with the following attributes:
    # + return - returns can be any of following types
    # http:Ok (Returns [Result object](/api/smartsheet/openapi/schemas/result) containing the newly created rows -- either a single [Row object](/api/smartsheet/openapi/rows/row) or array of Row objects, corresponding to what was specified in the request, as well as the new version of the sheet)
    # http:DefaultStatusCodeResponse (When **allowPartialSuccess=false** (or not specified):
    #
    # If an error occurs, the [Error object](/api/smartsheet/openapi/schemas/error) returned contains a **detail** attribute set to an object with the following attribute:
    # * **index**: the array index of the row that caused the error (0 if a single Row was passed in)
    #
    # If any error occurs, the entire request fails (no rows are added), and the error response returned describes the first problem that was encountered. For example:
    # ```
    # {
    #   "errorCode": 1042,
    #   "message": "The cell value in column 5504245941200772 did not conform to the strict requirements for type CHECKBOX."
    #   "detail": {
    #     "index": 4
    #   }
    # }
    # ```
    #
    # When **allowPartialSuccess=true**:
    #
    # When partial success is enabled, and one or more of the objects in the request fail to be added/updated/deleted, a standard [Result object](/api/smartsheet/openapi/schemas/result) is returned, but with a **message** of **'PARTIAL_SUCCESS'** (instead of **'SUCCESS'**), and a **resultCode** of **3**. Additionally, the object contains a **failedItems** attribute -- an array of [BulkItemFailure objects](/api/smartsheet/openapi/schemas/bulkitemfailure) that contains an item for each object in the request that failed to be added/updated/deleted.
    # )
    resource function post sheets/[decimal sheetId]/rows(@http:Header {name: "Authorization"} string? authorization, @http:Payload SheetIdRowsBody1 payload, decimal accessApiLevel = 0, @http:Header {name: "Content-Type"} string? contentType = "application/json", boolean allowPartialSuccess = false, boolean overrideValidation = false) returns RowMoveResponseOk|ErrorDefault {
        decimal newRowId = 3000 + sheetId;
        return {
            body: {
                resultCode: 0,
                message: "SUCCESS",
                result: [
                    {
                        id: newRowId,
                        rowNumber: 1,
                        sheetId: sheetId,
                        expanded: true,
                        createdAt: "2024-08-11T10:30:00Z",
                        modifiedAt: "2024-08-11T10:30:00Z",
                        version: 1,
                        cells: payload is Row ? payload.cells : []
                    }
                ]
            }
        };
    }

    # Update Sheet
    #
    # + Authorization - API Access Token used to authenticate requests to Smartsheet APIs
    # + sheetId - Sheet Id of the sheet being accessed
    # + accessApiLevel - Allows COMMENTER access for inputs and return values. For backwards-compatibility, VIEWER is the default. For example, to see whether a user has COMMENTER access for a sheet, use accessApiLevel=1
    # + payload - [Sheet object](/api/smartsheet/openapi/sheets/sheet) limited to the following attributes:
    # + return - Returns [Result object](/api/smartsheet/openapi/schemas/result) containing a [Sheet object](/api/smartsheet/openapi/sheets/sheet) for the updated sheet
    resource function put sheets/[decimal sheetId](@http:Header {name: "Authorization"} string? authorization, @http:Payload UpdateSheet payload, decimal accessApiLevel = 0) returns AttachmentListResponse {
        return {
            resultCode: 0,
            message: "SUCCESS",
            result: {
                id: sheetId,
                name: payload.name ?: "Updated Sheet",
                accessLevel: "OWNER",
                permalink: "https://app.smartsheet.com/sheets/" + sheetId.toString(),
                version: 11,
                totalRowCount: 5,
                createdAt: "2024-01-15T10:30:00Z",
                modifiedAt: "2024-08-11T10:30:00Z",
                userSettings: payload.userSettings,
                projectSettings: payload.projectSettings
            }
        };
    }

    # Update Rows
    #
    # + sheetId - Sheet Id of the sheet being accessed
    # + Authorization - API Access Token used to authenticate requests to Smartsheet APIs
    # + accessApiLevel - Allows COMMENTER access for inputs and return values. For backwards-compatibility, VIEWER is the default. For example, to see whether a user has COMMENTER access for a sheet, use accessApiLevel=1
    # + Content\-Type - Required for POST and PUT requests. Defines the structure for the request body
    # + allowPartialSuccess - When specified with a value of true, enables partial success for this bulk operation. See [Bulk operations > Partial success](/api/smartsheet/guides/advanced-topics/scalability-options) for more information
    # + overrideValidation - You may use the query string parameter **overrideValidation** with a value of **true** to allow a cell value outside of the validation limits. You must specify **strict** with a value of **false** to bypass value type checking
    # + payload - [Row object](/api/smartsheet/openapi/rows/row) or an array of Row objects, with the following attributes:
    # + return - returns can be any of following types
    # http:Ok (Returns [Result object](/api/smartsheet/openapi/schemas/result) containing an array of the updated rows)
    # http:DefaultStatusCodeResponse (When **allowPartialSuccess=false** (or not specified):
    #
    # If an error occurs, the [Error object](/api/smartsheet/openapi/schemas/error) returned contains a **detail** attribute set to an object with the following attribute:
    # * **index**: the array index of the row that caused the error (0 if a single Row was passed in)
    # * **rowId**: the id of the row that caused the error (omitted if the row was missing an Id)
    #
    # If any error occurs, the entire request fails (no rows are added), and the error response returned describes the first problem that was encountered. For example:
    # ```
    # {
    # "errorCode": 1042,
    # "message": "The cell value in column 5504245941200772 did not conform to the strict requirements for type CHECKBOX."
    # "detail": {
    #   "index": 4
    #   "rowId": 6572427401553796
    #   }
    # }
    # ```
    # When **allowPartialSuccess=true**:
    #
    # When partial success is enabled, and one or more of the objects in the request fail to be added/updated/deleted, a standard [Result object](/api/smartsheet/openapi/schemas/result) is returned, but with a **message** of **'PARTIAL_SUCCESS'** (instead of **'SUCCESS'**), and a **resultCode** of **3**. Additionally, the object contains a **failedItems** attribute -- an array of [BulkItemFailure objects](/api/smartsheet/openapi/schemas/bulkitemfailure) that contains an item for each object in the request that failed to be added/updated/deleted.
    # )
    resource function put sheets/[decimal sheetId]/rows(@http:Header {name: "Authorization"} string? authorization, @http:Payload SheetIdRowsBody payload, decimal accessApiLevel = 0, @http:Header {name: "Content-Type"} string? contentType = "application/json", boolean allowPartialSuccess = false, boolean overrideValidation = false) returns RowCopyResponse|ErrorDefault {
        return {
            resultCode: 0,
            message: "SUCCESS",
            result: [
                {
                    id: payload is Row ? (payload.id ?: 2001) : 2001,
                    rowNumber: 1,
                    expanded: true,
                    createdAt: "2024-01-15T10:30:00Z",
                    modifiedAt: "2024-08-11T10:30:00Z",
                    version: 12,
                    cells: payload is Row ? payload.cells : []
                }
            ]
        };
    }
};

function init() returns error? {
    if isLiveServer {
        log:printInfo("Skipping mock server initialization as the tests are running on live server");
        return;
    }
    log:printInfo("Initiating mock server");
    check httpListener.attach(mockService, "/");
    check httpListener.'start();
}

public type ErrorDefault record {|
    *http:DefaultStatusCodeResponse;
    Error body;
|};

public type ColumnCreateResponseOk record {|
    *http:Ok;
    ColumnCreateResponse body;
|};

public type RowMoveResponseOk record {|
    *http:Ok;
    RowMoveResponse body;
|};

public type ErrorNotFound record {|
    *http:NotFound;
    Error body;
|};
