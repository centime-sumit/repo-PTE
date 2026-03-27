namespace CentimeAL.CentimeAL;

using Microsoft.Purchases.History;
using Microsoft.API.V2;
using Microsoft.Upgrade;
using System.Upgrade;
using Microsoft.Purchases.Document;
using Microsoft.Integration.Entity;

page 70227 PurchaseReceiptLines
{
    APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'purchaseReceiptLines';
    DelayedInsert = true;
    EntityName = 'purchaseReceiptLine';
    EntitySetName = 'purchaseReceiptLines';
    PageType = API;
    SourceTable = "Purch. Rcpt. Line";
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
                field(documentId; Rec."Document Id")
                {
                    Caption = 'Document Id';
                }
                field(sequence; Rec."Line No.")
                {
                    Caption = 'Sequence';
                }
                field(lineType; Rec.Type)
                {
                    Caption = 'Line Type';
                }
                field(lineObjectNumber; Rec."No.")
                {
                    Caption = 'Line Object No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit Of Measure Code';
                }
                field(unitCost; Rec."Direct Unit Cost")
                {
                    Caption = 'Direct Unit Cost';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(discountPercent; Rec."Line Discount %")
                {
                    Caption = 'Discount Percent';
                }
                field(taxPercent; Rec."VAT %")
                {
                    Caption = 'Tax Percent';
                }
                field(expectedReceiptDate; Rec."Expected Receipt Date")
                {
                    Caption = 'Expected Receipt Date';
                }
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
                field("quantityBilled"; Rec."Qty. Invoiced (Base)")
                {
                    Caption = 'quantityBilled';
                    Editable = false;
                }

            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTagDefinitions: Codeunit "Upgrade Tag Definitions";
    begin
        if not UpgradeTag.HasUpgradeTag(UpgradeTagDefinitions.GetNewPurchRcptLineUpgradeTag()) then
            Error(SetupNotCompletedErr);
    end;

    var
        SetupNotCompletedErr: Label 'Data required by the API was not set up. To set up the data, invoke the action from the API Setup page.';


    var
        TempGLNo: Code[20];
        TempGLName: Text[100];
        LineResolver: Codeunit "LineGLResolver";

    local procedure GetResolvedGLAccountNo(): Code[20]
    var
        GLNo: Code[20];
        GLName: Text[100];
    begin
        ResolveLineGLFromPostedPurchLine(Rec, GLNo, GLName);
        exit(GLNo);
    end;

    local procedure GetResolvedGLAccountName(): Text[100]
    var
        GLNo: Code[20];
        GLName: Text[100];
    begin
        ResolveLineGLFromPostedPurchLine(Rec, GLNo, GLName);
        exit(GLName);
    end;

    local procedure ResolveLineGLFromPostedPurchLine(var PostedLine: Record "Purch. Rcpt. Line"; var GLNo: Code[20]; var GLName: Text[100])
    var
        PostedHeader: Record "Purch. Rcpt. Header";
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


}
