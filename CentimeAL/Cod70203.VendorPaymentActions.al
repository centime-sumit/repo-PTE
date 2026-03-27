namespace CentimeAL.CentimeAL;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Purchases.Payables;
codeunit 70203 "Vendor Payment Actions"
{
    Subtype = Normal;
    local procedure ProcessCredits(
    CreditsArray: JsonArray;
    var PaymentLine: Record "Gen. Journal Line")
var
    Token: JsonToken;
    CreditObj: JsonObject;
    CreditEntry: Record "Vendor Ledger Entry";
    CreditId: Text;
    CreditAmount: Decimal;
    i: Integer;
begin
    for i := 0 to CreditsArray.Count() - 1 do begin
        // 1. Get token (correct AL syntax)
        CreditsArray.Get(i, Token);
        // 2. Must be an object
        if not Token.IsObject() then
            Error('Invalid credit entry at index %1', i);
        // 3. Convert token → JsonObject
        CreditObj := Token.AsObject();
        // 4. Extract fields
        CreditId := GetTextField(CreditObj, 'creditId');
        CreditAmount := GetDecimalField(CreditObj, 'creditAmount');
        // 5. Load vendor ledger credit entry
        if not CreditEntry.GetBySystemId(CreditId) then
            Error('Credit %1 not found.', CreditId);
        // 6. Create an apply journal line
        CreateApplyLine(PaymentLine, CreditEntry.SystemId, CreditAmount);
    end;
end;
local procedure GetTextField(JsonObj: JsonObject; FieldName: Text) Result: Text
var
    Token: JsonToken;
begin
    if JsonObj.Get(FieldName, Token) then
        exit(Token.AsValue().AsText());
end;
local procedure GetDecimalField(JsonObj: JsonObject; FieldName: Text) Result: Decimal
var
    Token: JsonToken;
begin
    if JsonObj.Get(FieldName, Token) then
        exit(Token.AsValue().AsDecimal());
end;
local procedure CreateApplyLine(
    var PaymentLine: Record "Gen. Journal Line";
    AppliesToId: Guid;
    ApplyAmount: Decimal)
var
    TempLine: Record "Gen. Journal Line";
begin
    TempLine.Init();
    TempLine."Journal Template Name" := PaymentLine."Journal Template Name";
    TempLine."Journal Batch Name" := PaymentLine."Journal Batch Name";
    TempLine."Posting Date" := PaymentLine."Posting Date";
    TempLine."Document Type" := PaymentLine."Document Type";
    TempLine."Document No." := PaymentLine."Document No.";
    TempLine."Account Type" := PaymentLine."Account Type";
    TempLine."Account No." := PaymentLine."Account No.";
    // THIS LINKS THE APPLICATION
    TempLine."Applies-to ID" := AppliesToId;
    // The amount MUST be negative for payments
    TempLine.Amount := -ApplyAmount;
    TempLine.Insert();
end;
local procedure ProcessLinkedTxn(LinkedTxn: JsonObject; var PaymentLine: Record "Gen. Journal Line")
var
    Token: JsonToken;
    CreditsArray: JsonArray;
    InvoiceEntry: Record "Vendor Ledger Entry";
    InvoiceId: Text;
    TxnAmount: Decimal;
    DiscountAmount: Decimal;
begin
    // 1. Extract required fields
    InvoiceId := GetTextField(LinkedTxn, 'txnId');
    TxnAmount := GetDecimalField(LinkedTxn, 'txnAmount');
    DiscountAmount := GetDecimalField(LinkedTxn, 'discountAmount');
    // 2. Load vendor ledger entry (invoice)
    if not InvoiceEntry.GetBySystemId(InvoiceId) then
        Error('Invoice %1 not found.', InvoiceId);
    // 3. Apply invoice partial amount
    if TxnAmount > 0 then
        CreateApplyLine(PaymentLine, InvoiceEntry.SystemId, TxnAmount);
    // 4. Apply discount as another application line
    if DiscountAmount > 0 then
        CreateApplyLine(PaymentLine, InvoiceEntry.SystemId, DiscountAmount);
    // 5. Apply credits array
    if LinkedTxn.Get('credits', Token) then begin
        if Token.IsArray() then begin
            CreditsArray := Token.AsArray();
            ProcessCredits(CreditsArray, PaymentLine);
        end;
    end;
end;
[ServiceEnabled]
[Scope('Cloud')]
procedure applyLinkedTxns(JsonRequest: Text): Text
var
    JsonObj: JsonObject;
    LinkedTxnsArray: JsonArray;
    LinkedToken: JsonToken;
    LinkedTxn: JsonObject;
    PaymentLine: Record "Gen. Journal Line";
    VendorPaymentId: Guid;
    i: Integer;
begin
    // Parse JSON
    JsonObj.ReadFrom(JsonRequest);

    // The request MUST include the vendorPaymentId explicitly
    if not JsonObj.Get('vendorPaymentId', LinkedToken) then
        Error('vendorPaymentId missing.');

    VendorPaymentId := LinkedToken.AsValue().AsText();  


    if not PaymentLine.GetBySystemId(VendorPaymentId) then
        Error('Vendor Payment not found: %1', VendorPaymentId);

    // Get linkedTxns
    if not JsonObj.Get('linkedTxns', LinkedToken) then
        Error('linkedTxns array missing.');

    LinkedTxnsArray := LinkedToken.AsArray();

    for i := 0 to LinkedTxnsArray.Count() - 1 do begin
        LinkedTxnsArray.Get(i, LinkedToken);
        LinkedTxn := LinkedToken.AsObject();
        ProcessLinkedTxn(LinkedTxn, PaymentLine);
    end;

    exit('OK');
end;

}