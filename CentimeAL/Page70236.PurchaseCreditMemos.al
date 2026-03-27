namespace CentimeAL.CentimeAL;

using Microsoft.Integration.Entity;
using Microsoft.Purchases.Payables;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Posting;
using Microsoft.Utilities;

page 70236 "APIV2 - Purchase Credit Memos"
{
    APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'PurchaseCreditMemos';
    DelayedInsert = true;
    EntityName = 'purchaseCreditMemo';
    EntitySetName = 'purchaseCreditMemos';
    PageType = API;
    SourceTable = "Purch. Cr. Memo Entity Buffer";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                    Editable = false;
                }
                field(id; Rec.Id)
                {
                    Caption = 'Id';
                }
                field(number; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(creditMemoDate; Rec."Document Date")
                {
                    Caption = 'Credit Memo Date';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(dueDate; Rec."Due Date")
                {
                    Caption = 'Due Date';
                }
                field(vendorId; Rec."Vendor Id")
                {
                    Caption = 'Vendor Id';
                }
                field(vendorNumber; Rec."Buy-from Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(vendorName; Rec."Buy-from Vendor Name")
                {
                    Caption = 'Vendor Name';
                }
                field(payToVendorId; Rec."Pay-to Vendor Id")
                {
                    Caption = 'Pay-to Vendor Id';
                }
                field(payToVendorNumber; Rec."Pay-to Vendor No.")
                {
                    Caption = 'Pay-to Vendor No.';
                }
                field(payToName; Rec."Pay-to Name")
                {
                    Caption = 'Pay-to Name';
                }
                field(buyFromAddressLine1; Rec."Buy-from Address")
                {
                    Caption = 'Buy-from Address Line 1';
                }
                field(buyFromAddressLine2; Rec."Buy-from Address 2")
                {
                    Caption = 'Buy-from Address Line 2';
                }
                field(buyFromCity; Rec."Buy-from City")
                {
                    Caption = 'Buy-from City';
                }
                field(buyFromCountry; Rec."Buy-from Country/Region Code")
                {
                    Caption = 'Buy-from Country/Region Code';
                }
                field(buyFromState; Rec."Buy-from County")
                {
                    Caption = 'Buy-from State';
                }
                field(buyFromPostCode; Rec."Buy-from Post Code")
                {
                    Caption = 'Buy-from Post Code';
                }
                field(payToAddressLine1; Rec."Pay-to Address")
                {
                    Caption = 'Pay-to Address Line 1';
                }
                field(payToAddressLine2; Rec."Pay-to Address 2")
                {
                    Caption = 'Pay-to Address Line 2';
                }
                field(payToCity; Rec."Pay-to City")
                {
                    Caption = 'Pay-to City';
                }
                field(payToCountry; Rec."Pay-to Country/Region Code")
                {
                    Caption = 'Pay-to Country/Region Code';
                }
                field(payToState; Rec."Pay-to County")
                {
                    Caption = 'Pay-to State';
                }
                field(payToPostCode; Rec."Pay-to Post Code")
                {
                    Caption = 'Pay-to Post Code';
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                }
                field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Shortcut Dimension 2 Code';
                }
                field(currencyId; Rec."Currency Id")
                {
                    Caption = 'Currency Id';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(paymentTermsId; Rec."Payment Terms Id")
                {
                    Caption = 'Payment Terms Id';
                }
                field(shipmentMethodId; Rec."Shipment Method Id")
                {
                    Caption = 'Shipment Method Id';
                }
                field(purchaser; Rec."Purchaser Code")
                {
                    Caption = 'Purchaser';
                }
                field(pricesIncludeTax; Rec."Prices Including VAT")
                {
                    Caption = 'Prices Include Tax';
                }
                field(discountAmount; Rec."Invoice Discount Amount")
                {
                    Caption = 'discountAmount';
                }
                field(discountAppliedBeforeTax; Rec."Discount Applied Before Tax")
                {
                    Caption = 'Discount Applied Before Tax';
                }
                field(totalAmountExcludingTax; Rec.Amount)
                {
                    Caption = 'Total Amount Excluding Tax';
                }
                field(totalTaxAmount; Rec."Total Tax Amount")
                {
                    Caption = 'Total Tax Amount';
                }
                field(totalAmountIncludingTax; Rec."Amount Including VAT")
                {
                    Caption = 'Total Amount Including Tax';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date';
                }
                field(invoiceNumber; Rec."Applies-to Doc. No.")
                {
                    Caption = 'Invoice No.';
                }
                field(vendorReturnReasonId; Rec."Reason Code Id")
                {
                    Caption = 'Vendor Return Reason Id';
                }
                field(AmountLcyVar; AmountLcyVar)
                {
                    Caption = 'AmountLcyVar';
                }
                field(RemainingAmountVar; RemainingAmountVar)
                {
                    Caption = 'RemainingAmountVar';
                }
                field(RemainingAmountLcyVar; RemainingAmountLcyVar)
                {
                    Caption = 'RemainingAmountLcyVar';
                }
                field(vendorPostingGroup; Rec."Vendor Posting Group")
                {
                    Caption = 'Vendor Posting Group';
                }
                field(payablesAccount; GetPayablesAccount())
                {
                    Caption = 'Payables Account';
                }
                field(PaymentNumberVar; PaymentNumberVar)
                {
                    Caption = 'PaymentNumberVar';
                }
                part(purchaseCreditMemoLines; purchaseCreditMemoLines)
                {
                    Caption = 'purchaseCreditMemoLines';
                    EntityName = 'purchaseCreditMemoLine';
                    EntitySetName = 'purchaseCreditMemoLines';
                    SubPageLink = "Document No." = field("No."), Type = filter(<> " ");
                }

                part(DetailedVendorLedgerEntries; detailedVendorLedgerEntry)
                {
                    Caption = 'purchaseCreditMemoLinkedTransactions';
                    EntityName = 'detailedVendorLedgerEntry';
                    EntitySetName = 'detailedVendorLedgerEntries';
                    SubPageLink = "Vendor Ledger Entry No." = field("Vendor Ledger Entry No."), "Initial Document Type" = filter("Credit Memo"), "Unapplied" = const(false), "Entry Type" = filter("Application");
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        LoadVendorLedgerEntry();
    end;

    var
        AmountLcyVar: Decimal;
        RemainingAmountVar: Decimal;
        RemainingAmountLcyVar: Decimal;
        ExternalDocumentNoVar: Code[35];
        PaymentNumberVar: Code[35];


    local procedure LoadVendorLedgerEntry()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VendorLedgerEntry2: Record "Vendor Ledger Entry";

        HasAny: Boolean;
    begin
        VendorLedgerEntry.SetRange("Entry No.", Rec."Vendor Ledger Entry No.");

        if VendorLedgerEntry.FindSet() then begin
            HasAny := true;

            ExternalDocumentNoVar := VendorLedgerEntry."External Document No.";
            VendorLedgerEntry.CalcFields(VendorLedgerEntry."Remaining Amount");
            RemainingAmountVar := VendorLedgerEntry."Remaining Amount";
            VendorLedgerEntry.CalcFields(VendorLedgerEntry."Remaining Amt. (LCY)");
            RemainingAmountLcyVar := VendorLedgerEntry."Remaining Amt. (LCY)";
            VendorLedgerEntry.CalcFields(VendorLedgerEntry."Amount (LCY)");
            AmountLcyVar := VendorLedgerEntry."Amount (LCY)";
        end;

        VendorLedgerEntry2.SetRange("Document No.", Rec."No.");
        if VendorLedgerEntry2.FindSet() then begin
            PaymentNumberVar := VendorLedgerEntry2."External Document No.";
        end;
    end;

    local procedure GetPayablesAccount(): Code[20]
    var
        VendorPostingGroup: Record Microsoft.Purchases.Vendor."Vendor Posting Group";
    begin
        if VendorPostingGroup.Get(Rec."Vendor Posting Group") then
            exit(VendorPostingGroup."Payables Account");
    end;

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure Post(var ActionContext: WebServiceActionContext)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        GetDraftCreditMemo(PurchaseHeader);
        PostCreditMemo(PurchaseHeader, PurchCrMemoHdr);
        SetActionResponse(ActionContext, PurchCrMemoHdr.SystemId);
    end;

    local procedure GetDraftCreditMemo(var PurchaseHeader: Record "Purchase Header")
    begin
        if Rec.Posted then
            Error('Cannot post an already posted credit memo.');

        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::"Credit Memo");
        PurchaseHeader.SetRange("No.", Rec."No.");
        if not PurchaseHeader.FindFirst() then
            Error('The credit memo cannot be found.');
    end;

    local procedure PostCreditMemo(var PurchaseHeader: Record "Purchase Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        PreAssignedNo: Code[20];
    begin
        LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(PurchaseHeader);
        PreAssignedNo := PurchaseHeader."No.";
        PurchaseHeader.SendToPosting(Codeunit::"Purch.-Post");
        Commit();
        PurchCrMemoHdr.SetRange("Pre-Assigned No.", PreAssignedNo);
        PurchCrMemoHdr.FindFirst();
    end;

    local procedure SetActionResponse(var ActionContext: WebServiceActionContext; CreditMemoId: Guid)
    begin
        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"APIV2 - Purchase Credit Memos");
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), CreditMemoId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Deleted);
    end;
}