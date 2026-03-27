namespace CentimeAL.CentimeAL;

using Microsoft.Sales.Customer;
using Microsoft.Purchases.Vendor;

page 70213 VendorPostingGroups
{
    APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'vendorPostingGroups';
    DelayedInsert = true;
    EntityName = 'vendorPostingGroup';
    EntitySetName = 'vendorPostingGroups';
    PageType = API;
    SourceTable = "Vendor Posting Group";
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
                field(payablesAccount; Rec."Payables Account")
                {
                    Caption = 'Payables Account';
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
                field(paymentDiscCreditAcc; Rec."Payment Disc. Credit Acc.")
                {
                    Caption = 'Payment Disc. Credit Acc.';
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'SystemCreatedBy';
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    Caption = 'SystemModifiedBy';
                }
            }
        }
    }
}
