namespace CentimeAL.CentimeAL;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Bank.BankAccount;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Purchases.Payables;
using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Purchases.Vendor;

codeunit 70205 "Grouped Vend Payment Mgt."
{
    // Permissions =
    //     tabledata "Grouped Vend Payment Buffer" = rimd,
    //     tabledata "Grouped Vend Payment App" = rimd,
    //     tabledata "Gen. Journal Line" = rimd,
    //     tabledata "Vendor Ledger Entry" = rimd;
    // procedure CreateAndApplyPayment(var HeaderBuf: Record "Grouped Vend Payment Buffer")
    // var
    //     AppBuf: Record "Grouped Vend Payment App";
    //     GenJnlLine: Record "Gen. Journal Line";
    //     GenJnlTemplate: Record "Gen. Journal Template";
    //     GenJnlBatch: Record "Gen. Journal Batch";
    //     Vendor: Record Vendor;
    //     BankAcc: Record "Bank Account";
    //     VendLedgEntry: Record "Vendor Ledger Entry";
    //     GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    //     TotalAmountToApply: Decimal;
    // begin
    //     // Validate basic input
    //    // GenJnlTemplate.Get(HeaderBuf."Journal Template Name");
    //     //GenJnlBatch.Get(HeaderBuf."Journal Template Name", HeaderBuf."Journal Batch Name");
    //     GenJnlBatch.GetBySystemId(HeaderBuf."Journal Batch Id");
    //     Vendor.Get(HeaderBuf."Vendor No.");
    //     BankAcc.Get(HeaderBuf."Bank Account No.");
    //     // Sum total amount
    //     TotalAmountToApply := 0;
    //     AppBuf.SetRange("Header Id", HeaderBuf.Id);
    //     if AppBuf.FindSet() then
    //         repeat
    //             TotalAmountToApply += AppBuf."Amount To Apply";
    //         until AppBuf.Next() = 0;
    //     if TotalAmountToApply = 0 then
    //         Error('Total Amount To Apply must be non-zero.');
    //     // Create one payment line in Gen. Journal
    //     GenJnlLine.Init();
    //     // GenJnlLine.Validate("Journal Template Name", HeaderBuf."Journal Template Name");
    //     // GenJnlLine.Validate("Journal Batch Name", HeaderBuf."Journal Batch Name");
    //     GenJnlLine.Validate("Journal Template Name", GenJnlBatch."Journal Template Name");
    //     GenJnlLine.Validate("Journal Batch Name", GenJnlBatch.Name);

    //     GenJnlLine."Line No." := 0;
    //     GenJnlLine.Insert(true);
    //     GenJnlLine.Validate("Posting Date", HeaderBuf."Posting Date");
    //     GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
    //     if HeaderBuf."Document No." <> '' then
    //         GenJnlLine.Validate("Document No.", HeaderBuf."Document No.");
    //     GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Vendor);
    //     GenJnlLine.Validate("Account No.", HeaderBuf."Vendor No.");
    //     GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
    //     GenJnlLine.Validate("Bal. Account No.", HeaderBuf."Bank Account No.");
    //     if HeaderBuf."Currency Code" <> '' then
    //         GenJnlLine.Validate("Currency Code", HeaderBuf."Currency Code");
    //     // Payments are negative in BC
    //     GenJnlLine.Validate(Amount, TotalAmountToApply);
    //     GenJnlLine.Modify(true);
    //     // Apply vendor entries with partial amounts
    //     ApplyVendorEntries(HeaderBuf, GenJnlLine, AppBuf);
    //     // Optionally post
    //     if HeaderBuf."Post After Apply" then begin
    //         GenJnlPostLine.RunWithCheck(GenJnlLine);
    //     end;
    // end;
    // local procedure ApplyVendorEntries(var HeaderBuf: Record "Grouped Vend Payment Buffer";
    //                                   var GenJnlLine: Record "Gen. Journal Line";
    //                                   var AppBuf: Record "Grouped Vend Payment App")
    // var
    //     VendLedgEntry: Record "Vendor Ledger Entry";
    //     GenJnlApply: Codeunit "Gen. Jnl.-Apply";
    // begin
    //     AppBuf.SetRange("Header Id", HeaderBuf.Id);
    //     if not AppBuf.FindSet() then
    //         exit;
    //     // Generate unique Applies-to ID for all entries
    //     GenJnlLine."Applies-to ID" :=
    //         DelChr(UserId, '=', ' /<>') + Format(HeaderBuf."Posting Date") +
    //         Format(GenJnlLine."Line No.") + DelChr(CreateGuid(), '=', '{}');
    //     GenJnlLine.Modify(true);
    //     repeat
    //         FindVendLedgEntry(HeaderBuf."Vendor No.", AppBuf."Document Type",
    //                          AppBuf."Document No.", VendLedgEntry);
    //         // Link entry to payment with partial amount
    //         // VendLedgEntry."Applies-to ID" := GenJnlLine."Applies-to ID";
    //         // VendLedgEntry."Amount to Apply" := AppBuf."Amount To Apply";
    //         // VendLedgEntry.Modify(true);
            
    
    //         begin
    //             GenJnlApply.SetVendApplIdAPI(GenJnlLine, VendLedgEntry);
    //             VendLedgEntry."Amount to Apply" := AppBuf."Amount To Apply";
    //             VendLedgEntry.Modify(true);

    //             GenJnlApply.ApplyVendorLedgerEntryAPI(GenJnlLine);
    //         end;

    //     until AppBuf.Next() = 0;
    // end;
    // local procedure FindVendLedgEntry(VendNo: Code[20]; DocType: Enum "Gen. Journal Document Type";
    //                                 DocNo: Code[20]; var VendLedgEntry: Record "Vendor Ledger Entry")
    // var
    //     FilterDocType: Integer;
    // begin
    //     case DocType of
    //         DocType::Invoice:
    //             FilterDocType := VendLedgEntry."Document Type"::Invoice.AsInteger();
    //         DocType::"Credit Memo":
    //             FilterDocType := VendLedgEntry."Document Type"::"Credit Memo".AsInteger();
    //     end;
    //     VendLedgEntry.Reset();
    //     VendLedgEntry.SetRange("Vendor No.", VendNo);
    //     VendLedgEntry.SetRange("Document Type", FilterDocType);
    //     VendLedgEntry.SetRange("Document No.", DocNo);
    //     VendLedgEntry.SetRange(Open, true);
    //     if not VendLedgEntry.FindFirst() then
    //         Error('Open vendor ledger entry not found for %1 %2', Format(DocType), DocNo);
    // end;
}
