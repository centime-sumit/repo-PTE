namespace CentimeAL.CentimeAL;

using Microsoft.Sales.History;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.PaymentTerms;
using Microsoft.Finance.Currency;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.Setup;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Sales.Document;
using Microsoft.Finance.GeneralLedger.Journal;
using System.Text;

/// <summary>
/// Sales Invoice API sourced from Customer Ledger Entry.
/// This ensures SystemModifiedAt updates when payments are applied,
/// enabling reliable incremental sync with a single API call.
/// 
/// Use: $filter=lastModifiedDateTime gt {lastSync}
/// </summary>
page 70244 "Sales Invoice Ledger API"
{
    PageType = API;
    APIPublisher = 'Centime';
    APIGroup = 'sync';
    APIVersion = 'v2.0';
    EntityName = 'enhancedSalesInvoice';
    EntitySetName = 'enhancedSalesInvoices';
    SourceTable = "Cust. Ledger Entry";
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                // System ID for OData key (ledger entry)
                field(id; Rec.SystemId) { }

                // Invoice Identifiers (primary key is from ledger for payment tracking)
                field(invoiceId; InvoiceSystemId) { }
                field(invoiceNumber; Rec."Document No.") { }

                // Customer Information
                field(customerId; BillToCustomerNo) { }
                field(customerName; BillToCustomerName) { }
                field(buyerId; SellToCustomerNo) { }
                field(buyerName; SellToCustomerName) { }
                field(billToContact; BillToContact) { }

                // Billing Address - from invoice header
                field(billToAddressLine; BillingAddressLine) { }
                field(billToCity; BillToCity) { }
                field(billToState; BillToState) { }
                field(billToCountry; BillToCountry) { }
                field(billToZipCode; BillToZipCode) { }

                // Dates
                field(txnDate; Rec."Posting Date") { }
                field(dueDate; Rec."Due Date") { }
                field(calculatedDueDate; CalculatedDueDate) { }
                field(discountExpiryDate; DiscountExpiryDate) { }
                field(discountPercent; DiscountPercent) { }
                field(glCreatedTime; InvoiceSystemCreatedAt) { }
                field(glUpdatedTime; InvoiceSystemModifiedAt) { }
                field(lastModifiedDateTime; Rec.SystemModifiedAt) { }
                field(effectiveModifiedDateTime; Rec.SystemModifiedAt) { }

                // Currency and Exchange
                field(currencyCode; CurrencyCodeValue) { }
                field(exchangeRate; ExchangeRateValue) { }

                // Financial Amounts - from ledger entry (always current)
                field(txnTotalAmount; TxnTotalAmountValue) { }
                field(txnTotalTax; TxnTotalTaxValue) { }
                field(txnBalance; RemainingAmount) { }
                field(discountTotal; TotalDiscountAmount) { }

                // Home Currency (LCY) Amounts - from ledger entry
                field(homeTotalAmount; HomeTotalAmount) { }
                field(homeBalance; HomeBalance) { }
                field(homeDeposit; HomeDeposit) { }

                // Costs
                field(shippingCost; ShippingCost) { }
                field(handlingCost; HandlingCost) { }

                // Terms
                field(termId; PaymentTermsCode) { }
                field(termName; PaymentTermName) { }

                // Location and Classification
                field(locationId; LocationCode) { }
                field(arAccountId; ARAccountId) { }
                field(classId; CustomerPostingGroup) { }
                field(departmentId; GlobalDimension2Code) { }

                // Description
                field(description; PostingDescription) { }

                // Additional flags
                field(emailFailureFlag; false) { }
                field(discountItemId; '') { }

                // Invoice Lines as JSON string
                field(invoiceLines; InvoiceLinesJson) { }

                // Linked Transactions as JSON string
                field(invoiceLinkedTxns; LinkedTxnsJson) { }
            }
        }
    }

    var
        // Invoice header fields (looked up)
        InvoiceSystemId: Guid;
        BillToCustomerNo: Code[20];
        BillToCustomerName: Text[100];
        SellToCustomerNo: Code[20];
        SellToCustomerName: Text[100];
        BillToContact: Text[100];
        BillingAddressLine: Text[150];
        BillToCity: Text[50];
        BillToState: Text[50];
        BillToCountry: Code[10];
        BillToZipCode: Code[20];
        InvoiceSystemCreatedAt: DateTime;
        InvoiceSystemModifiedAt: DateTime;
        LocationCode: Code[10];
        CustomerPostingGroup: Code[20];
        GlobalDimension2Code: Code[20];
        PostingDescription: Text[100];
        PaymentTermsCode: Code[10];

        // Calculated field variables
        CurrencyCodeValue: Code[10];
        ExchangeRateValue: Decimal;
        TxnTotalAmountValue: Decimal;
        TxnTotalTaxValue: Decimal;
        RemainingAmount: Decimal;
        TotalDiscountAmount: Decimal;
        HomeTotalAmount: Decimal;
        HomeBalance: Decimal;
        HomeDeposit: Decimal;
        ShippingCost: Decimal;
        HandlingCost: Decimal;
        PaymentTermName: Text[100];
        ARAccountId: Code[20];
        InvoiceLinesJson: Text;
        LinkedTxnsJson: Text;
        CalculatedDueDate: Date;
        DiscountExpiryDate: Date;
        DiscountPercent: Decimal;

    trigger OnOpenPage()
    begin
        // Only show Invoice entries
        Rec.SetRange("Document Type", Rec."Document Type"::Invoice);
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateAllFields();
    end;

    local procedure CalculateAllFields()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        // Initialize all fields
        ClearCalculatedFields();

        // Look up the Sales Invoice Header
        if not SalesInvoiceHeader.Get(Rec."Document No.") then
            exit; // Exit if invoice header not found

        // Get header fields
        InvoiceSystemId := SalesInvoiceHeader.SystemId;
        BillToCustomerNo := SalesInvoiceHeader."Bill-to Customer No.";
        BillToCustomerName := SalesInvoiceHeader."Bill-to Name";
        SellToCustomerNo := SalesInvoiceHeader."Sell-to Customer No.";
        SellToCustomerName := SalesInvoiceHeader."Sell-to Customer Name";
        BillToContact := SalesInvoiceHeader."Bill-to Contact";
        LocationCode := SalesInvoiceHeader."Location Code";
        CustomerPostingGroup := SalesInvoiceHeader."Customer Posting Group";
        GlobalDimension2Code := SalesInvoiceHeader."Shortcut Dimension 2 Code";
        PostingDescription := SalesInvoiceHeader."Posting Description";
        PaymentTermsCode := SalesInvoiceHeader."Payment Terms Code";
        InvoiceSystemCreatedAt := SalesInvoiceHeader.SystemCreatedAt;
        InvoiceSystemModifiedAt := SalesInvoiceHeader.SystemModifiedAt;

        // Billing address
        BillingAddressLine := SalesInvoiceHeader."Bill-to Address";
        if SalesInvoiceHeader."Bill-to Address 2" <> '' then
            BillingAddressLine := BillingAddressLine + ', ' + SalesInvoiceHeader."Bill-to Address 2";
        BillToCity := SalesInvoiceHeader."Bill-to City";
        BillToState := SalesInvoiceHeader."Bill-to County";
        BillToCountry := SalesInvoiceHeader."Bill-to Country/Region Code";
        BillToZipCode := SalesInvoiceHeader."Bill-to Post Code";

        // Calculate fields
        CalculateCurrencyAndExchange(SalesInvoiceHeader);
        CalculateAmounts(SalesInvoiceHeader);
        CalculateBalancesFromLedger();
        CalculateCosts(SalesInvoiceHeader);
        GetPaymentTermName();
        CalculateDueDateAndDiscount();
        GetARAccount();
        BuildInvoiceLinesJson(SalesInvoiceHeader);
        BuildLinkedTxnsJson();
    end;

    local procedure ClearCalculatedFields()
    begin
        InvoiceSystemId := CreateGuid();
        BillToCustomerNo := '';
        BillToCustomerName := '';
        SellToCustomerNo := '';
        SellToCustomerName := '';
        BillToContact := '';
        BillingAddressLine := '';
        BillToCity := '';
        BillToState := '';
        BillToCountry := '';
        BillToZipCode := '';
        LocationCode := '';
        CustomerPostingGroup := '';
        GlobalDimension2Code := '';
        PostingDescription := '';
        PaymentTermsCode := '';
        InvoiceSystemCreatedAt := 0DT;
        InvoiceSystemModifiedAt := 0DT;
        CurrencyCodeValue := '';
        ExchangeRateValue := 0;
        TxnTotalAmountValue := 0;
        TxnTotalTaxValue := 0;
        RemainingAmount := 0;
        TotalDiscountAmount := 0;
        HomeTotalAmount := 0;
        HomeBalance := 0;
        HomeDeposit := 0;
        ShippingCost := 0;
        HandlingCost := 0;
        PaymentTermName := '';
        ARAccountId := '';
        InvoiceLinesJson := '[]';
        LinkedTxnsJson := '[]';
        CalculatedDueDate := 0D;
        DiscountExpiryDate := 0D;
        DiscountPercent := 0;
    end;

    local procedure CalculateCurrencyAndExchange(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        if SalesInvoiceHeader."Currency Code" = '' then begin
            GeneralLedgerSetup.Get();
            CurrencyCodeValue := GeneralLedgerSetup."LCY Code";
            ExchangeRateValue := 1;
        end else begin
            CurrencyCodeValue := SalesInvoiceHeader."Currency Code";
            ExchangeRateValue := CurrencyExchangeRate.ExchangeRate(SalesInvoiceHeader."Posting Date", SalesInvoiceHeader."Currency Code");
        end;
    end;

    local procedure CalculateAmounts(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceHeader.CalcFields(Amount, "Amount Including VAT");

        TxnTotalTaxValue := SalesInvoiceHeader."Amount Including VAT" - SalesInvoiceHeader.Amount;
        TxnTotalAmountValue := SalesInvoiceHeader."Amount Including VAT";

        // Calculate discount total from lines
        TotalDiscountAmount := 0;
        SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        if SalesInvoiceLine.FindSet() then
            repeat
                TotalDiscountAmount += SalesInvoiceLine."Line Discount Amount";
            until SalesInvoiceLine.Next() = 0;
    end;

    local procedure CalculateBalancesFromLedger()
    begin
        // Get current balance directly from the ledger entry (always up-to-date)
        Rec.CalcFields("Remaining Amount", "Remaining Amt. (LCY)", "Amount (LCY)", Amount);

        RemainingAmount := Rec."Remaining Amount";
        HomeTotalAmount := Rec."Amount (LCY)";
        HomeBalance := Rec."Remaining Amt. (LCY)";
        HomeDeposit := HomeTotalAmount - HomeBalance;
    end;

    local procedure CalculateCosts(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        ShippingCost := 0;
        HandlingCost := 0;

        SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        if SalesInvoiceLine.FindSet() then
            repeat
                if SalesInvoiceLine.Type = SalesInvoiceLine.Type::"Charge (Item)" then begin
                    if (StrPos(LowerCase(SalesInvoiceLine.Description), 'ship') > 0) or
                       (StrPos(LowerCase(SalesInvoiceLine.Description), 'freight') > 0) then
                        ShippingCost += SalesInvoiceLine."Amount Including VAT"
                    else if (StrPos(LowerCase(SalesInvoiceLine.Description), 'handl') > 0) then
                        HandlingCost += SalesInvoiceLine."Amount Including VAT";
                end;
            until SalesInvoiceLine.Next() = 0;
    end;

    local procedure GetPaymentTermName()
    var
        PaymentTerms: Record "Payment Terms";
    begin
        PaymentTermName := '';
        if PaymentTerms.Get(PaymentTermsCode) then
            PaymentTermName := PaymentTerms.Description;
    end;

    local procedure CalculateDueDateAndDiscount()
    var
        PaymentTerms: Record "Payment Terms";
    begin
        CalculatedDueDate := 0D;
        DiscountExpiryDate := 0D;
        DiscountPercent := 0;

        if PaymentTerms.Get(PaymentTermsCode) then begin
            if Format(PaymentTerms."Due Date Calculation") <> '' then
                CalculatedDueDate := CalcDate(PaymentTerms."Due Date Calculation", Rec."Posting Date")
            else
                CalculatedDueDate := Rec."Due Date";

            if Format(PaymentTerms."Discount Date Calculation") <> '' then
                DiscountExpiryDate := CalcDate(PaymentTerms."Discount Date Calculation", Rec."Posting Date");

            DiscountPercent := PaymentTerms."Discount %";
        end else begin
            CalculatedDueDate := Rec."Due Date";
        end;
    end;

    local procedure GetARAccount()
    var
        CustomerPostingGroup: Record "Customer Posting Group";
    begin
        ARAccountId := '';
        if CustomerPostingGroup.Get(Rec."Customer Posting Group") then
            ARAccountId := CustomerPostingGroup."Receivables Account";
    end;

    local procedure BuildInvoiceLinesJson(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        JsonArray: JsonArray;
        JsonObj: JsonObject;
        GLAccountNo: Code[20];
        ItemIdValue: Text[50];
        LineTypeText: Text[30];
    begin
        Clear(JsonArray);
        InvoiceLinesJson := '[]';

        SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        if SalesInvoiceLine.FindSet() then begin
            repeat
                Clear(JsonObj);

                JsonObj.Add('lineId', Format(SalesInvoiceLine."Line No."));
                LineTypeText := GetLineTypeText(SalesInvoiceLine.Type);
                JsonObj.Add('lineType', LineTypeText);

                ItemIdValue := '';
                if SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item then
                    ItemIdValue := SalesInvoiceLine."No."
                else if SalesInvoiceLine.Type = SalesInvoiceLine.Type::Resource then
                    ItemIdValue := SalesInvoiceLine."No.";
                JsonObj.Add('itemId', ItemIdValue);

                GLAccountNo := GetGLAccountForLine(SalesInvoiceLine);
                JsonObj.Add('accountId', GLAccountNo);
                JsonObj.Add('description', SalesInvoiceLine.Description);
                JsonObj.Add('quantity', SalesInvoiceLine.Quantity);
                JsonObj.Add('unitPrice', SalesInvoiceLine."Unit Price");
                JsonObj.Add('amount', SalesInvoiceLine.Amount);
                JsonObj.Add('txnAmount', SalesInvoiceLine."Amount Including VAT");
                JsonObj.Add('locationId', SalesInvoiceLine."Location Code");
                JsonObj.Add('classId', SalesInvoiceLine."Shortcut Dimension 1 Code");
                JsonObj.Add('departmentId', SalesInvoiceLine."Shortcut Dimension 2 Code");
                JsonObj.Add('billable', true);

                JsonArray.Add(JsonObj);
            until SalesInvoiceLine.Next() = 0;
        end;

        JsonArray.WriteTo(InvoiceLinesJson);
    end;

    local procedure GetLineTypeText(LineType: Enum "Sales Line Type"): Text[30]
    begin
        case LineType of
            LineType::" ":
                exit('Comment');
            LineType::"G/L Account":
                exit('Account');
            LineType::Item:
                exit('Item');
            LineType::Resource:
                exit('Resource');
            LineType::"Fixed Asset":
                exit('FixedAsset');
            LineType::"Charge (Item)":
                exit('ItemCharge');
            else
                exit(Format(LineType));
        end;
    end;

    local procedure GetGLAccountForLine(SalesInvoiceLine: Record "Sales Invoice Line"): Code[20]
    var
        GLPostingSetup: Record "General Posting Setup";
        FixedAsset: Record "Fixed Asset";
        FAPostingGroup: Record "FA Posting Group";
        GLAccountNo: Code[20];
    begin
        GLAccountNo := '';

        case SalesInvoiceLine.Type of
            SalesInvoiceLine.Type::Item:
                begin
                    if GLPostingSetup.Get(SalesInvoiceLine."Gen. Bus. Posting Group", SalesInvoiceLine."Gen. Prod. Posting Group") then
                        GLAccountNo := GLPostingSetup."Sales Account";
                end;
            SalesInvoiceLine.Type::"G/L Account":
                GLAccountNo := SalesInvoiceLine."No.";
            SalesInvoiceLine.Type::Resource:
                begin
                    if GLPostingSetup.Get(SalesInvoiceLine."Gen. Bus. Posting Group", SalesInvoiceLine."Gen. Prod. Posting Group") then
                        GLAccountNo := GLPostingSetup."Sales Account";
                end;
            SalesInvoiceLine.Type::"Fixed Asset":
                begin
                    if FixedAsset.Get(SalesInvoiceLine."No.") then
                        if FAPostingGroup.Get(FixedAsset."FA Posting Group") then
                            GLAccountNo := FAPostingGroup."Sales Bal. Acc.";
                end;
            SalesInvoiceLine.Type::"Charge (Item)":
                begin
                    if GLPostingSetup.Get(SalesInvoiceLine."Gen. Bus. Posting Group", SalesInvoiceLine."Gen. Prod. Posting Group") then
                        GLAccountNo := GLPostingSetup."Sales Account";
                end;
        end;

        exit(GLAccountNo);
    end;

    local procedure BuildLinkedTxnsJson()
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        AppliedCustLedgerEntry: Record "Cust. Ledger Entry";
        JsonArray: JsonArray;
        JsonObj: JsonObject;
        TxnTypeText: Text[30];
    begin
        Clear(JsonArray);
        LinkedTxnsJson := '[]';

        // Find all application entries for this ledger entry
        DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", Rec."Entry No.");
        DetailedCustLedgEntry.SetRange("Entry Type", DetailedCustLedgEntry."Entry Type"::Application);
        if DetailedCustLedgEntry.FindSet() then begin
            repeat
                if DetailedCustLedgEntry."Applied Cust. Ledger Entry No." <> 0 then begin
                    if AppliedCustLedgerEntry.Get(DetailedCustLedgEntry."Applied Cust. Ledger Entry No.") then begin
                        if AppliedCustLedgerEntry."Document Type" in [
                            AppliedCustLedgerEntry."Document Type"::Payment,
                            AppliedCustLedgerEntry."Document Type"::"Credit Memo",
                            AppliedCustLedgerEntry."Document Type"::Refund
                        ] then begin
                            Clear(JsonObj);

                            JsonObj.Add('txnId', Format(AppliedCustLedgerEntry."Entry No."));
                            JsonObj.Add('txnNumber', AppliedCustLedgerEntry."Document No.");

                            TxnTypeText := GetDocumentTypeText(AppliedCustLedgerEntry."Document Type");
                            JsonObj.Add('txnType', TxnTypeText);
                            JsonObj.Add('txnDate', Format(AppliedCustLedgerEntry."Posting Date", 0, 9));
                            JsonObj.Add('txnAmount', Abs(DetailedCustLedgEntry.Amount));

                            JsonArray.Add(JsonObj);
                        end;
                    end;
                end;
            until DetailedCustLedgEntry.Next() = 0;
        end;

        JsonArray.WriteTo(LinkedTxnsJson);
    end;

    local procedure GetDocumentTypeText(DocType: Enum "Gen. Journal Document Type"): Text[30]
    begin
        case DocType of
            DocType::Payment:
                exit('Payment');
            DocType::"Credit Memo":
                exit('CreditMemo');
            DocType::Refund:
                exit('Refund');
            DocType::Invoice:
                exit('Invoice');
            DocType::"Finance Charge Memo":
                exit('FinanceCharge');
            DocType::Reminder:
                exit('Reminder');
            else
                exit(Format(DocType));
        end;
    end;
}
