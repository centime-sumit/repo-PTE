namespace CentimeAL.CentimeAL;

using Microsoft.Purchases.History;
using Microsoft.Purchases.Document;

page 70238 PurchaseCreditMemoLines
{
    APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'PurchaseCreditMemoLines';
    DelayedInsert = true;
    EntityName = 'purchaseCreditMemoLine';
    EntitySetName = 'purchaseCreditMemoLines';
    PageType = API;
    SourceTable = "Purch. Cr. Memo Line";
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                    Editable = false;
                }
                field(id; Rec."Line No.")
                {
                    Caption = 'id';
                }
                field(documentId; Rec."Document No.")
                {
                    Caption = 'documentId';
                }
                field(sequence; Rec."Line No.")
                {
                    Caption = 'sequence';
                }
                field(itemId; Rec."No.")
                {
                    Caption = 'itemId';
                }
                field(accountId; Rec."Gen. Bus. Posting Group")
                {
                    Caption = 'accountId';
                }
                field(lineType; Rec.Type)
                {
                    Caption = 'lineType';
                }
                field(lineObjectNumber; Rec."No.")
                {
                    Caption = 'lineObjectNumber';
                }
                field(description; Rec.Description)
                {
                    Caption = 'description';
                }
                field(unitOfMeasureId; Rec."Unit of Measure Code")
                {
                    Caption = 'unitOfMeasureId';
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'unitOfMeasureCode';
                }
                field(unitCost; Rec."Direct Unit Cost")
                {
                    Caption = 'unitCost';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'quantity';
                }
                field(discountAmount; Rec."Line Discount Amount")
                {
                    Caption = 'discountAmount';
                }
                field(discountPercent; Rec."Line Discount %")
                {
                    Caption = 'discountPercent';
                }
                field(discountAppliedBeforeTax; Rec."Prepayment Line")
                {
                    Caption = 'discountAppliedBeforeTax';
                }
                field(amountExcludingTax; Rec.Amount)
                {
                    Caption = 'amountExcludingTax';
                }
                field(taxCode; Rec."VAT Prod. Posting Group")
                {
                    Caption = 'taxCode';
                }
                field(taxPercent; Rec."VAT %")
                {
                    Caption = 'taxPercent';
                }
                field(amountIncludingTax; Rec."Amount Including VAT")
                {
                    Caption = 'amountIncludingTax';
                }
                field(invoiceDiscountAllocation; Rec."Inv. Discount Amount")
                {
                    Caption = 'invoiceDiscountAllocation';
                }
                field(netAmount; Rec.Amount)
                {
                    Caption = 'netAmount';
                }
                field(netAmountIncludingTax; Rec."Amount Including VAT")
                {
                    Caption = 'netAmountIncludingTax';
                }
                field(itemVariantId; Rec."Variant Code")
                {
                    Caption = 'itemVariantId';
                }
                field(locationId; Rec."Location Code")
                {
                    Caption = 'locationId';
                }

                // Resolved G/L fields (read-only)
                field(derivedGLAccountNo; GetResolvedGLAccountNo())
                {
                    Caption = 'derivedGLAccountNo';
                    Editable = false;
                }

                field(derivedGLAccountName; GetResolvedGLAccountName())
                {
                    Caption = 'derivedGLAccountName';
                    Editable = false;
                }
            }
        }
    }

    var
        LineResolver: Codeunit "LineGLResolver";

    local procedure ResolveLineGLFromPostedCreditMemoLine(var PostedLine: Record "Purch. Cr. Memo Line"; var GLNo: Code[20]; var GLName: Text[100])
    var
        PostedHeader: Record "Purch. Cr. Memo Hdr.";
        TempPurchLine: Record "Purchase Line";
    begin
        GLNo := '';
        GLName := '';

        // Build a temporary Purchase Line record from the posted credit memo line
        // so LineGLResolver has the fields it expects.
        if PostedHeader.Get(PostedLine."Document No.") then begin
            TempPurchLine.Init();
            TempPurchLine."No." := PostedLine."No.";
            TempPurchLine.Type := PostedLine.Type;
            TempPurchLine."Line No." := PostedLine."Line No.";
            TempPurchLine."Buy-from Vendor No." := PostedLine."Buy-from Vendor No.";
            TempPurchLine."Location Code" := PostedLine."Location Code";
            TempPurchLine."Document No." := PostedHeader."No.";

            // Call centralized resolver
            LineResolver.ResolveGLAccount(TempPurchLine, GLNo, GLName);
        end;
    end;

    local procedure GetResolvedGLAccountNo(): Code[20]
    var
        GLNo: Code[20];
        GLName: Text[100];
    begin
        ResolveLineGLFromPostedCreditMemoLine(Rec, GLNo, GLName);
        exit(GLNo);
    end;

    local procedure GetResolvedGLAccountName(): Text[100]
    var
        GLNo: Code[20];
        GLName: Text[100];
    begin
        ResolveLineGLFromPostedCreditMemoLine(Rec, GLNo, GLName);
        exit(GLName);
    end;


}
