namespace CentimeAL.CentimeAL;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;
using Microsoft.Purchases.Document;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.Projects.Resources.Resource;


codeunit 70200 "LineGLResolver"
{
    SingleInstance = true;

    var
        GLAccountCache: Dictionary of [Text, Code[20]];
        GLNameCache: Dictionary of [Text, Text[100]];

    procedure ResolveGLAccount(
        PurchLine: Record "Purchase Line";
        var GLAccountNo: Code[20];
        var GLAccountName: Text[100])
    var
        ItemRec: Record Item;
        ResRec: Record Resource;
        FARec: Record "Fixed Asset";
        ChargeRec: Record "Item Charge";
        VendorRec: Record Vendor;
        GenSetup: Record "General Posting Setup";
        FAPosting: Record "FA Posting Group";
        GLAcct: Record "G/L Account";
        GenProdPostingGroup: Code[20];
        FAPostingGroup: Code[20];
        cacheKey: Text;
        GenBusPostingGroup: Code[20];


    begin
        GLAccountNo := '';
        GLAccountName := '';
        GenProdPostingGroup := '';
        FAPostingGroup := '';

        // 1️⃣ Vendor
        if PurchLine."Buy-from Vendor No." <> '' then
            VendorRec.Get(PurchLine."Buy-from Vendor No.");
            GenBusPostingGroup := VendorRec."Gen. Bus. Posting Group";


        // 2️⃣ Resolve posting groups ONCE
        case PurchLine.Type of
            PurchLine.Type::Item:
                if ItemRec.Get(PurchLine."No.") then
                    GenProdPostingGroup := ItemRec."Gen. Prod. Posting Group";

            PurchLine.Type::Resource:
                if ResRec.Get(PurchLine."No.") then
                    GenProdPostingGroup := ResRec."Gen. Prod. Posting Group";

            PurchLine.Type::"Charge (Item)":
                if ChargeRec.Get(PurchLine."No.") then
                    GenProdPostingGroup := ChargeRec."Gen. Prod. Posting Group";

            PurchLine.Type::"Fixed Asset":
                if FARec.Get(PurchLine."No.") then
                    FAPostingGroup := FARec."FA Posting Group";
        end;

        // 3️⃣ Cache key
        if PurchLine.Type = PurchLine.Type::"Fixed Asset" then
            cacheKey := GetFACacheKey(PurchLine.Type, FAPostingGroup)
        else
            cacheKey := GetCacheKey(
                PurchLine.Type,
                VendorRec."Gen. Bus. Posting Group",
                GenProdPostingGroup);

            // 3️⃣ Cache lookup
            if GLAccountCache.Get(cacheKey, GLAccountNo) then begin
                GLNameCache.Get(cacheKey, GLAccountName);
                exit;
            end;


        // 4️⃣ Resolve GL Account
        case PurchLine.Type of
            PurchLine.Type::"G/L Account":
                GLAccountNo := PurchLine."No.";

            PurchLine.Type::Item,
            PurchLine.Type::Resource,
            PurchLine.Type::"Charge (Item)":
                begin
                    if (GenBusPostingGroup <> '') and (GenProdPostingGroup <> '') then
                        if GenSetup.Get(VendorRec."Gen. Bus. Posting Group", GenProdPostingGroup) then
                            GLAccountNo := GenSetup."Purch. Account";
                end;

            PurchLine.Type::"Fixed Asset":
                begin
                    if FAPostingGroup <> '' then
                        if FAPosting.Get(FAPostingGroup) then
                            GLAccountNo := FAPosting."Acquisition Cost Account";
                end;
        end;

        // 5️⃣ GL Name
        if (GLAccountNo <> '') and GLAcct.Get(GLAccountNo) then
            GLAccountName := GLAcct.Name;

        // 6️⃣ Cache only valid results
        if GLAccountNo <> '' then begin
            GLAccountCache.Add(cacheKey, GLAccountNo);
            GLNameCache.Add(cacheKey, GLAccountName);
        end;
        
        if (GLAccountNo = '') and (PurchLine.Type = PurchLine.Type::Item) then begin
            GLAccountNo :=
                Format(PurchLine.Type) + '|' +
                GenBusPostingGroup + '|' +
                GenProdPostingGroup;

            GLAccountName := 'DEBUG: Unresolved Item GL';
        end;

    end;

    local procedure GetCacheKey(
        LineType: Enum "Purchase Line Type";
        GenBusPostingGroup: Code[20];
        GenProdPostingGroup: Code[20]): Text
    begin
        exit(
            Format(LineType) + '|' +
            GenBusPostingGroup + '|' +
            GenProdPostingGroup
        );
    end;

    local procedure GetFACacheKey(
        LineType: Enum "Purchase Line Type";
        FAPostingGroup: Code[20]): Text
    begin
        exit(
            Format(LineType) + '|' +
            FAPostingGroup
        );
    end;
}

