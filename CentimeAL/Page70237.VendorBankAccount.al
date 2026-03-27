namespace CentimeAL.CentimeAL;

using Microsoft.Purchases.Vendor;

page 70237 vendorBankAccount
{
    APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'VendorBankAccount';
    DelayedInsert = true;
    EntityName = 'vendorBankAccount';
    EntitySetName = 'vendorBankAccounts';
    PageType = API;
    SourceTable = "Vendor Bank Account";
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
                field(vendorNumber; Rec."Vendor No.")
                {
                    Caption = 'vendorNumber';
                }
                field(Code; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(bankAccountNumber; Rec."Bank Account No.")
                {
                    Caption = 'bankAccountNumber';
                }
                field(bankBranchNumber; Rec."Bank Branch No.")
                {
                    Caption = 'bankBranchNumber';
                }
                field(bankClearningCode; Rec."Bank Clearing Code")
                {
                    Caption = 'bankClearningCode';
                }
                field(transitNumber; Rec."Transit No.")
                {
                    Caption = 'transitNumber';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'currencyCode';
                }
                field(SWIFTCode; Rec."SWIFT Code")
                {
                    Caption = 'SWIFTCode';
                }
                field(BankCode; Rec."Bank Code")
                {
                    Caption = 'BankCode';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
            }
        }
    }
}
