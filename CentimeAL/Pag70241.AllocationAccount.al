namespace CentimeAL.CentimeAL;

using Microsoft.Finance.AllocationAccount;

page 70241 AllocationAccount
{
    APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'allocationAccount';
    DelayedInsert = true;
    EntityName = 'allocationAccount';
    EntitySetName = 'allocationAccounts';
    PageType = API;
    SourceTable = "Allocation Account";
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(accountType; Rec."Account Type")
                {
                    Caption = 'Account type';
                }
                field(documentLinesSplit; Rec."Document Lines Split")
                {
                    Caption = 'Split Document Lines';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
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

                part(defaultDimensions; "DefaultDimensions")
                {
                    Caption = 'Default Dimensions';
                    EntityName = 'defaultDimension';
                    EntitySetName = 'defaultDimensions';
                    SubPageLink = "Table ID" = CONST(Database::"Allocation Account"),
                              "No." = FIELD("No.");
                }
            }
        }
    }
}
