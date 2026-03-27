namespace CentimeAL.CentimeAL;

using Microsoft.Purchases.History;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;
using Microsoft.Integration.Graph;
using Microsoft.API.V2;

page 70224 "APIV2 - Purchase Receipts"
{
    APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'apiv2PurchaseReceipts';
    DelayedInsert = true;
    EntityName = 'purchaseReceipt';
    EntitySetName = 'purchaseReceipts';
    PageType = API;
    SourceTable = "Purch. Rcpt. Header";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(number; Rec."No.")
                {
                    Caption = 'No.';
                    Editable = false;
                }
                field(invoiceDate; Rec."Document Date")
                {
                    Caption = 'Invoice Date';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(dueDate; Rec."Due Date")
                {
                    Caption = 'Due Date';
                }
                field(vendorNumber; Rec."Buy-from Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(vendorName; Rec."Buy-from Vendor Name")
                {
                    Caption = 'Vendor Name';
                    Editable = false;
                }
                field(payToName; Rec."Pay-to Name")
                {
                    Caption = 'Pay-To Name';
                    Editable = false;
                }
                field(payToContact; Rec."Pay-to Contact")
                {
                    Caption = 'Pay-To Contact';
                    Editable = false;
                }
                field(payToVendorNumber; Rec."Pay-to Vendor No.")
                {
                    Caption = 'Pay-To Vendor No.';
                }
                field(shipToName; Rec."Ship-to Name")
                {
                    Caption = 'Ship-To Name';
                }
                field(shipToContact; Rec."Ship-to Contact")
                {
                    Caption = 'Ship-To Contact';
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
                field(shipToAddressLine1; Rec."Ship-to Address")
                {
                    Caption = 'Ship-to Address Line 1';
                }
                field(shipToAddressLine2; Rec."Ship-to Address 2")
                {
                    Caption = 'Ship-to Address Line 2';
                }
                field(shipToCity; Rec."Ship-to City")
                {
                    Caption = 'Ship-to City';
                }
                field(shipToCountry; Rec."Ship-to Country/Region Code")
                {
                    Caption = 'Ship-to Country/Region Code';
                }
                field(shipToState; Rec."Ship-to County")
                {
                    Caption = 'Ship-to State';
                }
                field(shipToPostCode; Rec."Ship-to Post Code")
                {
                    Caption = 'Ship-to Post Code';
                }
                field(payToAddressLine1; Rec."Pay-to Address")
                {
                    Caption = 'Pay To Address Line 1';
                    Editable = false;
                }
                field(payToAddressLine2; Rec."Pay-to Address 2")
                {
                    Caption = 'Pay To Address Line 2';
                    Editable = false;
                }
                field(payToCity; Rec."Pay-to City")
                {
                    Caption = 'Pay To City';
                    Editable = false;
                }
                field(payToCountry; Rec."Pay-to Country/Region Code")
                {
                    Caption = 'Pay To Country/Region Code';
                    Editable = false;
                }
                field(payToState; Rec."Pay-to County")
                {
                    Caption = 'Pay To State';
                    Editable = false;
                }
                field(payToPostCode; Rec."Pay-to Post Code")
                {
                    Caption = 'Pay To Post Code';
                    Editable = false;
                }
                field(currencyCode; CurrencyCodeTxt)
                {
                    Caption = 'Currency Code';
                }
                field(orderNumber; Rec."Order No.")
                {
                    Caption = 'Order No.';
                    Editable = false;
                }
                field(sourceDocumentNumber; SourceDocumentNumber)
                {
                    Caption = 'Source Document Number';
                    Editable = false;
                }

                field(sourceDocumentPostingDate; SourceDocumentPostingDate)
                {
                    Caption = 'Source Document Posting Date';
                    Editable = false;
                }

                field(sourceTotalAmountIncludingTax; SourceTotalAmountInclTax)
                {
                    Caption = 'Source Total Amount Including Tax';
                    Editable = false;
                }

                field(sourceExchangeRate; SourceExchangeRate)
                {
                    Caption = 'Source Exchange Rate';
                    Editable = false;
                }

                field(sourceTxnType; SourceTxnType)
                {
                    Caption = 'Source Transaction Type';
                    Editable = false;
                }
                field(PayablesAccount; GetVendorPayablesAccount())
                {
                    Caption = 'Payables Account';
                    Editable = false;
                }


                part(purchaseReceiptLines; purchaseReceiptLines)
                {
                    Caption = 'Lines';
                    EntityName = 'purchaseReceiptLine';
                    EntitySetName = 'purchaseReceiptLines';
                    SubPageLink = "Document Id" = field(SystemId);
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date';
                }


            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetCalculatedFields();
        ResolveSourceDocument();
    end;

    var
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        LCYCurrencyCode: Code[10];
        CurrencyCodeTxt: Text;
        SourceDocumentNumber: Code[20];
        SourceDocumentPostingDate: Date;
        SourceTotalAmountInclTax: Decimal;
        SourceExchangeRate: Decimal;
        SourceTxnType: Text[30];

    local procedure SetCalculatedFields()
    begin
        CurrencyCodeTxt := GraphMgtGeneralTools.TranslateNAVCurrencyCodeToCurrencyCode(LCYCurrencyCode, Rec."Currency Code");
    end;

    local procedure ResolveSourceDocument()
    var
        PurchHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        TotalInclVAT: Decimal;
    begin
        Clear(SourceDocumentNumber);
        Clear(SourceDocumentPostingDate);
        Clear(SourceTotalAmountInclTax);
        Clear(SourceExchangeRate);
        Clear(SourceTxnType);

        // 1️⃣ Try Purchase Order
        if PurchHeader.Get(PurchHeader."Document Type"::Order, Rec."Order No.") then begin
            SourceDocumentNumber := PurchHeader."No.";
            SourceDocumentPostingDate := PurchHeader."Posting Date";
            SourceTotalAmountInclTax := CalculatePOTotalInclVAT(PurchHeader."No.");
            SourceExchangeRate := PurchHeader."Currency Factor";
            SourceTxnType := 'PURCHASE_ORDER';
            exit;
        end;

        // 2️⃣ PO missing → SUM ALL invoices
        PurchInvHeader.Reset();
        PurchInvHeader.SetRange("Order No.", Rec."Order No.");
        PurchInvHeader.SetCurrentKey("Posting Date", "SystemCreatedAt", "No.");
        PurchInvHeader.Ascending(false);

        TotalInclVAT := 0;

        if PurchInvHeader.FindSet() then begin
            repeat
                TotalInclVAT += PurchInvHeader."Amount Including VAT";
            until PurchInvHeader.Next() = 0;

            // Representative invoice (last one due to DESC order)
            PurchInvHeader.FindFirst();

            SourceDocumentNumber := PurchInvHeader."No.";
            SourceDocumentPostingDate := PurchInvHeader."Posting Date";
            SourceTotalAmountInclTax := TotalInclVAT;
            SourceExchangeRate := PurchInvHeader."Currency Factor";
            SourceTxnType := 'PURCHASE_INVOICE';
        end;
    end;

    local procedure CalculatePOTotalInclVAT(OrderNo: Code[20]): Decimal
    var
        PurchLine: Record "Purchase Line";
        TotalInclVAT: Decimal;
    begin
        TotalInclVAT := 0;

        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", OrderNo);

        if PurchLine.FindSet() then
            repeat
                // Line Amount + VAT Amount
                TotalInclVAT += PurchLine."Amount Including VAT";
            until PurchLine.Next() = 0;

        exit(TotalInclVAT);
    end;

    local procedure GetVendorPayablesAccount(): Code[20]
    var
        VendPostingGroup: Record "Vendor Posting Group";
    begin
        if Rec."Vendor Posting Group" = '' then
            exit('');

        if VendPostingGroup.Get(Rec."Vendor Posting Group") then
            exit(VendPostingGroup."Payables Account");

        exit('');
    end;



}
