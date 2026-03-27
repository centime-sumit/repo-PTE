namespace CentimeAL.CentimeAL;

using Microsoft.Integration.Entity;
using Microsoft.Purchases.Payables;

codeunit 70201 "PurchInvLastModUpdater"
{
    SingleInstance = true;

    procedure UpdateAll(): Integer
    var
        PurchInvAgg: Record "Purch. Inv. Entity Aggregate";
        VendLedgEntry: Record "Vendor Ledger Entry";
        UpdatedCount: Integer;
        VendorModDt: DateTime;
    begin
        UpdatedCount := 0;

        // Iterate all aggregates
        if PurchInvAgg.FindSet(true, false) then begin
            repeat
                if PurchInvAgg."Vendor Ledger Entry No." <> 0 then begin
                    // match vendor ledger entry by Entry No.
                    VendLedgEntry.SetRange("Entry No.", PurchInvAgg."Vendor Ledger Entry No.");
                    if VendLedgEntry.FindFirst() then begin
                        VendorModDt := VendLedgEntry.SystemModifiedAt;
                        if VendorModDt > PurchInvAgg."Vendor Ledger Last Modified Date" then begin
                            PurchInvAgg."Vendor Ledger Last Modified Date" := VendorModDt;
                            PurchInvAgg.Modify();
                            UpdatedCount += 1;
                        end;
                    end;
                end;
            until PurchInvAgg.Next() = 0;
        end;

        exit(UpdatedCount);
    end;

    procedure UpdateForVendorLedgerEntry(VendLedgEntryNo: Integer)
    var
        PurchInvAgg: Record "Purch. Inv. Entity Aggregate";
        VendLedgEntry: Record "Vendor Ledger Entry";
        VendorModDt: DateTime;
    begin
        if VendLedgEntryNo = 0 then
            exit;

        // get vendor ledger entry once
        VendLedgEntry.SetRange("Entry No.", VendLedgEntryNo);
        if not VendLedgEntry.FindFirst() then
            exit;

        VendorModDt := VendLedgEntry.SystemModifiedAt;

        // update only aggregates that reference this vendor ledger entry
        PurchInvAgg.SetRange("Vendor Ledger Entry No.", VendLedgEntryNo);
        if PurchInvAgg.FindSet(true, false) then begin
            repeat
                if VendorModDt > PurchInvAgg."Vendor Ledger Last Modified Date" then begin
                    PurchInvAgg."Vendor Ledger Last Modified Date" := VendorModDt;
                    PurchInvAgg.Modify();
                end;
            until PurchInvAgg.Next() = 0;
        end;
    end;

    trigger OnRun()
    var
        Count: Integer;
    begin
        Count := UpdateAll();
        Message('%1 purchase-invoice aggregates updated.', Count);
    end;
}
