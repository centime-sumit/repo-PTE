namespace CentimeAL.CentimeAL;

using System.Diagnostics;
using Microsoft.Purchases.Vendor;

page 70212 ChangeLogEntry
{
    APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'changeLogEntry';
    DelayedInsert = true;
    EntityName = 'changeLogEntry';
    EntitySetName = 'changeLogEntries';
    PageType = API;
    SourceTable = "Change Log Entry";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field(dateAndTime; Rec."Date and Time")
                {
                    Caption = 'Date and Time';
                }
                field(oldValue; Rec."Old Value")
                {
                    Caption = 'Old Value';
                }
                field(changedRecordSystemId; Rec."Changed Record SystemId")
                {
                    Caption = 'Changed Record SystemId';
                }
                field(fieldCaption; Rec."Field Caption")
                {
                    Caption = 'Field Caption';
                }
                field(fieldLogEntryFeature; Rec."Field Log Entry Feature")
                {
                    Caption = 'Field Log Entry Feature';
                }
                field(fieldNo; Rec."Field No.")
                {
                    Caption = 'Field No.';
                }
                field(newValue; Rec."New Value")
                {
                    Caption = 'New Value';
                }
                field(notificationMessageId; Rec."Notification Message Id")
                {
                    Caption = 'Notification Message Id';
                }
                field(notificationStatus; Rec."Notification Status")
                {
                    Caption = 'Notification status';
                }
                field(primaryKey; PrimaryKeyOut)
                {
                    Caption = 'Primary Key';
                }
                field(primaryKeyField1Caption; Rec."Primary Key Field 1 Caption")
                {
                    Caption = 'Primary Key Field 1 Caption';
                }
                field(primaryKeyField1No; Rec."Primary Key Field 1 No.")
                {
                    Caption = 'Primary Key Field 1 No.';
                }
                field(primaryKeyField1Value; PrimaryKeyField1ValueOut)
                {
                    Caption = 'Primary Key Field 1 Value';
                }
                field(primaryKeyField2Caption; Rec."Primary Key Field 2 Caption")
                {
                    Caption = 'Primary Key Field 2 Caption';
                }
                field(primaryKeyField2No; Rec."Primary Key Field 2 No.")
                {
                    Caption = 'Primary Key Field 2 No.';
                }
                field(primaryKeyField2Value; Rec."Primary Key Field 2 Value")
                {
                    Caption = 'Primary Key Field 2 Value';
                }
                field(primaryKeyField3Caption; Rec."Primary Key Field 3 Caption")
                {
                    Caption = 'Primary Key Field 3 Caption';
                }
                field(primaryKeyField3No; Rec."Primary Key Field 3 No.")
                {
                    Caption = 'Primary Key Field 3 No.';
                }
                field(primaryKeyField3Value; Rec."Primary Key Field 3 Value")
                {
                    Caption = 'Primary Key Field 3 Value';
                }
                field("protected"; Rec."Protected")
                {
                    Caption = 'Protected';
                }
                field("recordID"; Rec."Record ID")
                {
                    Caption = 'Record ID';
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'SystemCreatedBy';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    Caption = 'SystemModifiedBy';
                }
                field(tableCaption; Rec."Table Caption")
                {
                    Caption = 'Table Caption';
                }
                field(tableNo; Rec."Table No.")
                {
                    Caption = 'Table No.';
                }
                field("time"; Rec."Time")
                {
                    Caption = 'Time';
                }
                field(typeOfChange; Rec."Type of Change")
                {
                    Caption = 'Type of Change';
                }
                field(userID; Rec."User ID")
                {
                    Caption = 'User ID';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        PrimaryKeyOut := Rec."Primary Key";
        PrimaryKeyField1ValueOut := GetPrimaryKeyField1ValueForOutput();
    end;

    var
        PrimaryKeyOut: Text[250];
        PrimaryKeyField1ValueOut: Text[100];

    local procedure GetPrimaryKeyField1ValueForOutput(): Text[100]
    begin
        if ShouldBlankPrimaryKeyField1Value() then
            exit('');

        exit(Rec."Primary Key Field 1 Value");
    end;

    local procedure ShouldBlankPrimaryKeyField1Value(): Boolean
    begin
        if UpperCase(Rec."Table Caption") <> 'VENDOR' then
            exit(false);

        if Rec."Type of Change" <> Rec."Type of Change"::Deletion then
            exit(false);

        if Rec."Primary Key Field 1 Value" = '' then
            exit(false);

        exit(HasVendorDeletionAnchorForPrimaryKey(Rec."Primary Key Field 1 Value"));
    end;

    local procedure HasVendorDeletionAnchorForPrimaryKey(VendorNo: Code[250]): Boolean
    var
        ChangeLogEntry: Record "Change Log Entry";
        Vendor: Record Vendor;
    begin
        ChangeLogEntry.SetRange("Table No.", Database::Vendor);
        ChangeLogEntry.SetRange("Type of Change", ChangeLogEntry."Type of Change"::Deletion);
        ChangeLogEntry.SetRange("Primary Key Field 1 Value", VendorNo);

        if not ChangeLogEntry.FindSet() then
            exit(false);

        repeat
            if not IsNullGuid(ChangeLogEntry."Changed Record SystemId") then
                if Vendor.Get(VendorNo) and (Vendor.SystemId = ChangeLogEntry."Changed Record SystemId") then
                    exit(true);
        until ChangeLogEntry.Next() = 0;

        exit(false);
    end;
}
