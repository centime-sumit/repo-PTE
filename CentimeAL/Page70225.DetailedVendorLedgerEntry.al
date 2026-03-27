namespace CentimeAL.CentimeAL;

using Microsoft.Purchases.Payables;

page 70225 DetailedVendorLedgerEntry
{
    APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'detailedVendorLedgerEntry';
    DelayedInsert = true;
    EntityName = 'detailedVendorLedgerEntry';
    EntitySetName = 'detailedVendorLedgerEntries';
    PageType = API;
    SourceTable = "Detailed Vendor Ledg. Entry";
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
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(amountLCY; Rec."Amount (LCY)")
                {
                    Caption = 'Amount (LCY)';
                }
                field(applicationNo; Rec."Application No.")
                {
                    Caption = 'Application No.';
                }
                field(appliedVendLedgerEntryNo; Rec."Applied Vend. Ledger Entry No.")
                {
                    Caption = 'Applied Vend. Ledger Entry No.';
                }
                field(creditAmount; Rec."Credit Amount")
                {
                    Caption = 'Credit Amount';
                }
                field(creditAmountLCY; Rec."Credit Amount (LCY)")
                {
                    Caption = 'Credit Amount (LCY)';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(debitAmount; Rec."Debit Amount")
                {
                    Caption = 'Debit Amount';
                }
                field(debitAmountLCY; Rec."Debit Amount (LCY)")
                {
                    Caption = 'Debit Amount (LCY)';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field(entryType; Rec."Entry Type")
                {
                    Caption = 'Entry Type';
                }
                field(exchRateAdjmtRegNo; Rec."Exch. Rate Adjmt. Reg. No.")
                {
                    Caption = 'Exch. Rate Adjmt. Reg. No.';
                }
                field(genBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    Caption = 'Gen. Bus. Posting Group';
                }
                field(genProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    Caption = 'Gen. Prod. Posting Group';
                }
                field(initialDocumentType; Rec."Initial Document Type")
                {
                    Caption = 'Initial Document Type';
                }
                field(initialEntryDueDate; Rec."Initial Entry Due Date")
                {
                    Caption = 'Initial Entry Due Date';
                }
                field(initialEntryGlobalDim1; Rec."Initial Entry Global Dim. 1")
                {
                    Caption = 'Initial Entry Global Dim. 1';
                }
                field(initialEntryGlobalDim2; Rec."Initial Entry Global Dim. 2")
                {
                    Caption = 'Initial Entry Global Dim. 2';
                }
                field(journalBatchName; Rec."Journal Batch Name")
                {
                    Caption = 'Journal Batch Name';
                }
                field(ledgerEntryAmount; Rec."Ledger Entry Amount")
                {
                    Caption = 'Ledger Entry Amount';
                }
                field(maxPaymentTolerance; Rec."Max. Payment Tolerance")
                {
                    Caption = 'Max. Payment Tolerance';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(postingGroup; Rec."Posting Group")
                {
                    Caption = 'Vendor Posting Group';
                }
                field(reasonCode; Rec."Reason Code")
                {
                    Caption = 'Reason Code';
                }
                field(remainingPmtDiscPossible; Rec."Remaining Pmt. Disc. Possible")
                {
                    Caption = 'Remaining Pmt. Disc. Possible';
                }
                field(sourceCode; Rec."Source Code")
                {
                    Caption = 'Source Code';
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
                field(taxJurisdictionCode; Rec."Tax Jurisdiction Code")
                {
                    Caption = 'Tax Jurisdiction Code';
                }
                field(transactionNo; Rec."Transaction No.")
                {
                    Caption = 'Transaction No.';
                }
                field(unapplied; Rec.Unapplied)
                {
                    Caption = 'Unapplied';
                }
                field(unappliedByEntryNo; Rec."Unapplied by Entry No.")
                {
                    Caption = 'Unapplied by Entry No.';
                }
                field(useTax; Rec."Use Tax")
                {
                    Caption = 'Use Tax';
                }
                field(userID; Rec."User ID")
                {
                    Caption = 'User ID';
                }
                field(vatBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    Caption = 'VAT Bus. Posting Group';
                }
                field(vatProdPostingGroup; Rec."VAT Prod. Posting Group")
                {
                    Caption = 'VAT Prod. Posting Group';
                }
                field(vendorLedgerEntryNo; Rec."Vendor Ledger Entry No.")
                {
                    Caption = 'Vendor Ledger Entry No.';
                }
                field(vendorNo; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(linkedDiscount; PmtDiscRcdLCYVar)
                {
                    Caption = 'Discount received';
                }
                field(linkedExternalDocumentNo; ExternalDocumentNoVar)
                {
                    Caption = 'Linked txn number';
                }

                field(linkedPostingDate; PostingDateVar)
                {
                    Caption = 'linked txn date';
                }

                field(linkedDocumentNo; DocumentNoVar)
                {
                    Caption = 'Linked Document No';
                }
                field(PaymentDateVar; PaymentDateVar)
                {
                    Caption = 'PaymentDateVar';
                }
                field(PaymentNumberVar; PaymentNumberVar)
                {
                    Caption = 'PaymentNumberVar';
                }
            }
        }
    }

    trigger OnAfterGetRecord()

    begin
        getVenderLedgerEntryDetails();
    end;

    var
        PmtDiscRcdLCYVar: Decimal;
        ExternalDocumentNoVar: Code[35];
        PostingDateVar: Date;
        DocumentNoVar: Code[20];

        PaymentDateVar: Date;
        PaymentNumberVar: Code[35];
        AmountLcyVar: Decimal;
        AmountVar: Decimal;



    local procedure getVenderLedgerEntryDetails()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VendorLedgerEntry2: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntry.SetRange("Entry No.", Rec."Vendor Ledger Entry No.");
        if VendorLedgerEntry.FindSet() then begin
            PmtDiscRcdLCYVar := VendorLedgerEntry."Pmt. Disc. Rcd.(LCY)";
            ExternalDocumentNoVar := VendorLedgerEntry."External Document No.";
            PostingDateVar := VendorLedgerEntry."Posting Date";
            DocumentNoVar := VendorLedgerEntry."Document No.";
        end;

        VendorLedgerEntry2.SetRange("Document No.", Rec."Document No.");
        if VendorLedgerEntry2.FindSet() then begin
            PaymentDateVar := VendorLedgerEntry2."Posting Date";
            PaymentNumberVar := VendorLedgerEntry2."External Document No.";
        end;
    end;
}
