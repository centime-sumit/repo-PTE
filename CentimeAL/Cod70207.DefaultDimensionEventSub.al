namespace CentimeAL.CentimeAL;

using Microsoft.Finance.Dimension; // Default Dimension
using Microsoft.Purchases.Vendor; // Vendor
using Microsoft.Sales.Customer; // Customer
using Microsoft.Inventory.Item; // Item
using Microsoft.HumanResources.Employee; // Employee
using Microsoft.Finance.GeneralLedger.Account; // G/L Account
using Microsoft.FixedAssets.FixedAsset; // Fixed Asset
using Microsoft.Inventory.Costing; // Item Charge
using Microsoft.Projects.Resources.Resource; // Resource
using Microsoft.Finance.AllocationAccount; // Allocation Account

codeunit 70207 "DefaultDimensionEventSub"
{
    /// <summary>
    /// Handles Insert event for Default Dimension records.
    /// Updates the parent record's lastModifiedDatetime timestamp.
    /// </summary>
    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertDefaultDimension(var Rec: Record "Default Dimension")
    begin
        UpdateParentRecordTimestamp(Rec."Table ID", Rec."No.");
    end;

    /// <summary>
    /// Handles Modify event for Default Dimension records.
    /// Updates the parent record's lastModifiedDatetime timestamp.
    /// </summary>
    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyDefaultDimension(var Rec: Record "Default Dimension"; var xRec: Record "Default Dimension")
    begin
        UpdateParentRecordTimestamp(Rec."Table ID", Rec."No.");
        
        // If Table ID or No. changed, also update the old parent record
        if (xRec."Table ID" <> Rec."Table ID") or (xRec."No." <> Rec."No.") then
            UpdateParentRecordTimestamp(xRec."Table ID", xRec."No.");
    end;

    /// <summary>
    /// Handles Delete event for Default Dimension records.
    /// Updates the parent record's lastModifiedDatetime timestamp.
    /// </summary>
    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteDefaultDimension(var Rec: Record "Default Dimension")
    begin
        UpdateParentRecordTimestamp(Rec."Table ID", Rec."No.");
    end;

    /// <summary>
    /// Updates the parent record's timestamp fields after a dimension change.
    /// Dynamically handles different table types (Vendor, Customer, Item, Employee, G/L Account, Resource, Fixed Asset, etc.).
    /// </summary>
    /// <param name="TableID">The Table ID of the parent record (e.g., 23 for Vendor)</param>
    /// <param name="ParentNo">The No. field value of the parent record</param>
    local procedure UpdateParentRecordTimestamp(TableID: Integer; ParentNo: Code[20])
    begin
        case TableID of
            Database::Vendor:
                UpdateVendorTimestamp(ParentNo);
            Database::Customer:
                UpdateCustomerTimestamp(ParentNo);
            Database::Item:
                UpdateItemTimestamp(ParentNo);
            Database::Employee:
                UpdateEmployeeTimestamp(ParentNo);
            Database::"G/L Account":
                UpdateGLAccountTimestamp(ParentNo);
            Database::Resource:
                UpdateResourceTimestamp(ParentNo);
            Database::"Fixed Asset":
                UpdateFixedAssetTimestamp(ParentNo);
            Database::"Item Charge":
                UpdateItemChargeTimestamp(ParentNo);
            Database::"Allocation Account":
                UpdateAllocationAccountTimestamp(ParentNo);
            // Add more cases as needed for other table types
        end;
    end;

    /// <summary>
    /// Updates the Vendor record's timestamp fields.
    /// </summary>
    local procedure UpdateVendorTimestamp(VendorNo: Code[20])
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(VendorNo) then begin
            // Modify(true) updates SystemModifiedAt automatically
            Vendor.Modify(true);
        end;
    end;

    /// <summary>
    /// Updates the Customer record's timestamp fields.
    /// </summary>
    local procedure UpdateCustomerTimestamp(CustomerNo: Code[20])
    var
        Customer: Record Customer;
    begin
        if Customer.Get(CustomerNo) then begin
            // Modify(true) updates SystemModifiedAt automatically
            Customer.Modify(true);
        end;
    end;

    /// <summary>
    /// Updates the Item record's timestamp fields.
    /// </summary>
    local procedure UpdateItemTimestamp(ItemNo: Code[20])
    var
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then begin
            // Item table may not have "Last Modified Date Time" field
            // just call Modify(true) to update SystemModifiedAt
            Item.Modify(true);
        end;
    end;

    /// <summary>
    /// Updates the Employee record's timestamp fields.
    /// </summary>
    local procedure UpdateEmployeeTimestamp(EmployeeNo: Code[20])
    var
        Employee: Record Employee;
    begin
        if Employee.Get(EmployeeNo) then begin
            // Employee table may not have "Last Modified Date Time" field
            // just call Modify(true) to update SystemModifiedAt
            Employee.Modify(true);
        end;
    end;

    /// <summary>
    /// Updates the G/L Account record's timestamp fields.
    /// </summary>
    local procedure UpdateGLAccountTimestamp(GLAccountNo: Code[20])
    var
        GLAccount: Record "G/L Account";
    begin
        if GLAccount.Get(GLAccountNo) then begin
            // Modify(true) updates SystemModifiedAt automatically
            GLAccount.Modify(true);
        end;
    end;

    /// <summary>
    /// Updates the Resource record's timestamp fields.
    /// </summary>
    local procedure UpdateResourceTimestamp(ResourceNo: Code[20])
    var
        Resource: Record Resource;
    begin
        if Resource.Get(ResourceNo) then begin
            // Modify(true) updates SystemModifiedAt automatically
            Resource.Modify(true);
        end;
    end;

    /// <summary>
    /// Updates the Fixed Asset record's timestamp fields.
    /// </summary>
    local procedure UpdateFixedAssetTimestamp(FixedAssetNo: Code[20])
    var
        FixedAsset: Record "Fixed Asset";
    begin
        if FixedAsset.Get(FixedAssetNo) then begin
            // Modify(true) updates SystemModifiedAt automatically
            FixedAsset.Modify(true);
        end;
    end;

    /// <summary>
    /// Updates the Item Charge record's timestamp fields.
    /// </summary>
    local procedure UpdateItemChargeTimestamp(ItemChargeNo: Code[20])
    var
        ItemCharge: Record "Item Charge";
    begin
        if ItemCharge.Get(ItemChargeNo) then begin
            // Modify(true) updates SystemModifiedAt automatically
            ItemCharge.Modify(true);
        end;
    end;

    /// <summary>
    /// Updates the Allocation Account record's timestamp fields.
    /// </summary>
    local procedure UpdateAllocationAccountTimestamp(AllocationAccountNo: Code[20])
    var
        AllocationAccount: Record "Allocation Account";
    begin
        if AllocationAccount.Get(AllocationAccountNo) then begin
            // Modify(true) updates SystemModifiedAt automatically
            AllocationAccount.Modify(true);
        end;
    end;
}
