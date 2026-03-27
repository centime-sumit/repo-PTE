namespace CentimeAL.CentimeAL;

using Microsoft.Sales.Receivables;

page 70226 DetailedCustomerLedgerEntry
{
    APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'detailedCustomerLedgerEntry';
    DelayedInsert = true;
    EntityName = 'detailedCustomerLedgerEntry';
    EntitySetName = 'detailedCustomerLedgerEntries';
    PageType = API;
    SourceTable = "Detailed Cust. Ledg. Entry";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId) { Caption = 'Id'; Editable = false; }
                field(amount; Rec.Amount) { Caption = 'Amount'; }
                field(amountLCY; Rec."Amount (LCY)") { Caption = 'Amount (LCY)'; }
                field(applicationNo; Rec."Application No.") { Caption = 'Application No.'; }
                field(appliedCustLedgerEntryNo; Rec."Applied Cust. Ledger Entry No.") { Caption = 'Applied Cust. Ledger Entry No.'; }
                field(creditAmount; Rec."Credit Amount") { Caption = 'Credit Amount'; }
                field(creditAmountLCY; Rec."Credit Amount (LCY)") { Caption = 'Credit Amount (LCY)'; }
                field(currencyCode; Rec."Currency Code") { Caption = 'Currency Code'; }
                field(debitAmount; Rec."Debit Amount") { Caption = 'Debit Amount'; }
                field(debitAmountLCY; Rec."Debit Amount (LCY)") { Caption = 'Debit Amount (LCY)'; }
                field(documentNo; Rec."Document No.") { Caption = 'Document No.'; }
                field(documentType; Rec."Document Type") { Caption = 'Document Type'; }
                field(entryNo; Rec."Entry No.") { Caption = 'Entry No.'; }
                field(entryType; Rec."Entry Type") { Caption = 'Entry Type'; }
                field(postingDate; Rec."Posting Date") { Caption = 'Posting Date'; }
                field(customerNo; Rec."Customer No.") { Caption = 'Customer No.'; }
                field(linkedDiscount; PmtDiscRcdLCYVar) { Caption = 'Discount granted'; }
                field(linkedExternalDocumentNo; ExternalDocumentNoVar) { Caption = 'Linked txn number'; }
                field(linkedPostingDate; PostingDateVar) { Caption = 'Linked txn date'; }
                field(linkedDocumentNo; DocumentNoVar) { Caption = 'Linked Document No'; }
                field(paymentDate; PaymentDateVar) { Caption = 'Payment Date'; }
                field(paymentNumber; PaymentNumberVar) { Caption = 'Payment Number'; }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        getCustomerLedgerEntryDetails();
    end;

    var
        PmtDiscRcdLCYVar: Decimal;
        ExternalDocumentNoVar: Code[35];
        PostingDateVar: Date;
        DocumentNoVar: Code[20];
        PaymentDateVar: Date;
        PaymentNumberVar: Code[35];

    local procedure getCustomerLedgerEntryDetails()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CustLedgerEntry2: Record "Cust. Ledger Entry";
    begin
        // First search: Find the main customer ledger entry for this detailed entry
        CustLedgerEntry.SetRange("Entry No.", Rec."Cust. Ledger Entry No.");
        if CustLedgerEntry.FindSet() then begin
            //PmtDiscRcdLCYVar := CustLedgerEntry."Pmt. Disc. Rcd.(LCY)";
            ExternalDocumentNoVar := CustLedgerEntry."External Document No.";
            PostingDateVar := CustLedgerEntry."Posting Date";
            DocumentNoVar := CustLedgerEntry."Document No.";
        end;

        // Second search: Find all related ledger entries with same document number
        CustLedgerEntry2.SetRange("Document No.", Rec."Document No.");
        if CustLedgerEntry2.FindSet() then begin
            PaymentDateVar := CustLedgerEntry2."Posting Date";
            PaymentNumberVar := CustLedgerEntry2."External Document No.";
        end;
    end;
}
