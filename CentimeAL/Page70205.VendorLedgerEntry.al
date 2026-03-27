namespace CentimeAL.CentimeAL;

using Microsoft.Purchases.Payables;

page 70205 VendorLedgerEntry
{
    APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Vendor ledger entry';
    DelayedInsert = true;
    EntityName = 'vendorLedgerEntry';
    EntitySetName = 'vendorLedgerEntries';
    PageType = API;
    SourceTable = "Vendor Ledger Entry";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }

                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the amount of the entry.';
                }

                field(AmountLCY; Rec."Amount (LCY)")
                {
                    ToolTip = 'Specifies the amount of the entry in LCY';
                }

                field(BalAccountNo; Rec."Bal. Account No.")
                {
                    ToolTip = 'Specifies the number of the balancing account.';
                }

                field(CurrencyCode; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the currency code for the amount on the line.';
                }

                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the vendor entry.';
                }

                field(DocumentNo; Rec."Document No.")
                {
                    ToolTip = 'Specifies the purchase document number.';
                }

                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ToolTip = 'Specifies a document number that refers to the vendor''s numbering system.';
                }

                field(PaymentMethodCode; Rec."Payment Method Code")
                {
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
                }

                field(PostingDate; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the vendor entry''s posting date.';
                }

                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }

                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }

                field(VendorNo; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the number of the vendor account that the entry is linked to.';
                }

                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies if the entry has been part of a reverse transaction.';
                }

                field(AdjustedCurrencyFactor; Rec."Adjusted Currency Factor")
                {
                    ToolTip = 'Specifies the value of the Adjusted Currency Factor field.';
                }
                field("DocumentType"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the type of document.';
                }
                field("BalAccountType"; Rec."Bal. Account Type")
                {
                    ToolTip = 'Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.';
                }
            }
            part(detailedVendorLedgerEntries; DetailedVendorLedgerEntry)
            {
                Caption = 'linked transactions';
                EntityName = 'detailedVendorLedgerEntry';
                EntitySetName = 'detailedVendorLedgerEntries';
                SubPageLink = "Document No." = Field("Document No.");

            }
        }

    }
    actions
    {

    }
}
