namespace CentimeAL.CentimeAL;

using Microsoft.Sales.Receivables;
using Microsoft.Sales.History;

page 70256 PaymentLinkedTransactions
{
    APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Payment Linked Transactions';
    DelayedInsert = true;
    EntityName = 'paymentLinkedTxn';
    EntitySetName = 'paymentLinkedTxns';
    PageType = API;
    SourceTable = "Detailed Cust. Ledg. Entry";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'id';
                    Editable = false;
                }

                field(Amount; Rec.Amount)
                {
                    Caption = 'txnAmount';
                    ToolTip = 'Specifies the amount of the transaction.';
                }

                field(DocumentNo; Rec."Document No.")
                {
                    Caption = 'txnNumber';
                    ToolTip = 'Specifies the transaction number.';
                }

                field(DocumentType; Rec."Document Type")
                {
                    Caption = 'txnType';
                    ToolTip = 'Specifies the transaction type (e.g., Invoice, Credit Memo).';
                }

                field(PostingDate; Rec."Posting Date")
                {
                    Caption = 'txnDate';
                    ToolTip = 'Specifies the posting date of the transaction.';
                }

                field(CurrencyCode; Rec."Currency Code")
                {
                    Caption = 'currencyCode';
                    ToolTip = 'Specifies the currency code of the transaction.';
                }

                field(DebitAmount; Rec."Debit Amount")
                {
                    Caption = 'debitAmount';
                    ToolTip = 'Specifies the debit amount.';
                }

                field(CreditAmount; Rec."Credit Amount")
                {
                    Caption = 'creditAmount';
                    ToolTip = 'Specifies the credit amount.';
                }

                field(LinkedDocumentNo; LinkedDocNoVar)
                {
                    Caption = 'txnId';
                    Editable = false;
                    ToolTip = 'Specifies the linked transaction ID (Sales Invoice or Credit Memo).';
                }

                field(AppliedCustLedgerEntryNo; Rec."Applied Cust. Ledger Entry No.")
                {
                    Caption = 'appliedCustLedgerEntryNo';
                    ToolTip = 'Specifies the applied customer ledger entry number.';
                }

                field(InitialDocumentType; Rec."Initial Document Type")
                {
                    Caption = 'initialDocumentType';
                    ToolTip = 'Specifies the initial document type.';
                }

                field(EntryType; Rec."Entry Type")
                {
                    Caption = 'entryType';
                    ToolTip = 'Specifies the entry type.';
                }

                field(Discount; DiscountVar)
                {
                    Caption = 'discount';
                    Editable = false;
                    ToolTip = 'Specifies any payment discount applied.';
                }

                field(ExternalDocumentNo; ExternalDocNoVar)
                {
                    Caption = 'externalDocumentNo';
                    Editable = false;
                    ToolTip = 'Specifies the external document number of the linked transaction.';
                }

                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'createdTime';
                    ToolTip = 'Specifies the creation time.';
                }

                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'updatedTime';
                    ToolTip = 'Specifies the modification time.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        FetchLinkedTransactionDetails();
    end;
    trigger OnOpenPage()
        begin
            Rec.SetFilter("Entry Type", '<>%1', Rec."Entry Type"::"Initial Entry");
        end;

    var
        LinkedDocNoVar: Code[20];
        DiscountVar: Decimal;
        ExternalDocNoVar: Code[35];
        PaymentDateVar: Date;
        PaymentNumberVar: Code[35];

  local procedure FetchLinkedTransactionDetails()
var
    CustLedgerEntry: Record "Cust. Ledger Entry";
begin
    Clear(LinkedDocNoVar);
    Clear(ExternalDocNoVar);
    Clear(DiscountVar);

    // Try main entry
    CustLedgerEntry.Reset();
    CustLedgerEntry.SetRange("Entry No.", Rec."Cust. Ledger Entry No.");

    if CustLedgerEntry.FindFirst() then
        if CustLedgerEntry."Document Type" <> CustLedgerEntry."Document Type"::Payment then begin
            LinkedDocNoVar := CustLedgerEntry."Document No.";
            ExternalDocNoVar := CustLedgerEntry."External Document No.";
            exit;
        end;

    // Fallback: applied entry
    CustLedgerEntry.Reset();
    CustLedgerEntry.SetRange("Entry No.", Rec."Applied Cust. Ledger Entry No.");

    if CustLedgerEntry.FindFirst() then begin
        LinkedDocNoVar := CustLedgerEntry."Document No.";
        ExternalDocNoVar := CustLedgerEntry."External Document No.";
    end;
end;

}
