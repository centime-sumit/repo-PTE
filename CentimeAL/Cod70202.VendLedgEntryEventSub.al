namespace CentimeAL.CentimeAL;

using Microsoft.Purchases.Payables; // Detailed Vendor Ledg. Entry
// no need to "use" your updater codeunit; call it by name

codeunit 70202 "VendLedgEntryEventSub"
{
   

    [EventSubscriber(ObjectType::Table, Database::"Detailed Vendor Ledg. Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertDetailedVendLedgEntry(var Rec: Record "Detailed Vendor Ledg. Entry")
    var
        Updater: Codeunit "PurchInvLastModUpdater";
    begin
        Updater.UpdateForVendorLedgerEntry(Rec."Vendor Ledger Entry No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Detailed Vendor Ledg. Entry", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyDetailedVendLedgEntry(var Rec: Record "Detailed Vendor Ledg. Entry"; var xRec: Record "Detailed Vendor Ledg. Entry")
    var
        Updater: Codeunit "PurchInvLastModUpdater";
    begin
        // If the referenced Vendor Ledger Entry No changed, update aggregates for both old and new numbers,
        // otherwise update for the current number.
        if xRec."Vendor Ledger Entry No." <> Rec."Vendor Ledger Entry No." then begin
            Updater.UpdateForVendorLedgerEntry(xRec."Vendor Ledger Entry No.");
            Updater.UpdateForVendorLedgerEntry(Rec."Vendor Ledger Entry No.");
        end else
            Updater.UpdateForVendorLedgerEntry(Rec."Vendor Ledger Entry No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Detailed Vendor Ledg. Entry", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteDetailedVendLedgEntry(var Rec: Record "Detailed Vendor Ledg. Entry")
    var
        Updater: Codeunit "PurchInvLastModUpdater";
    begin
        Updater.UpdateForVendorLedgerEntry(Rec."Vendor Ledger Entry No.");
    end;
}
