namespace CentimeAL.CentimeAL;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Integration.Graph;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Vendor;

codeunit 70204 BulkVendorPaymentHandler
{
      var
        GraphMgtVendorPayments: Codeunit "Graph Mgt - Vendor Payments";
        LibraryAPIGeneralJournal: Codeunit "Library API - General Journal";
        Vendor: Record Vendor;
        PurchInvHdr: Record "Purch. Inv. Header";


procedure ProcessBulkPayments(JsonText: Text): Text
var
    PaymentsArray: JsonArray;
    Token: JsonToken;
    Obj: JsonObject;
begin
    // Expect a raw JSON array: [ {...}, {...} ]
    PaymentsArray.ReadFrom(JsonText);

    foreach Token in PaymentsArray do begin
        Obj := Token.AsObject();
        CreateOneVendorPayment(Obj);
    end;

    exit('SUCCESS');
end;

local procedure CreateOneVendorPayment(Item: JsonObject)
var
    TempLine: Record "Gen. Journal Line" temporary;
    Line: Record "Gen. Journal Line";
    BatchName: Code[20];
    JournalBatchId: Guid;
    DocTypeTxt: Text;
    NextLineNo: Integer;
begin
    JournalBatchId := GetGuid(Item, 'journalId');
    BatchName := GetBatchNameFromId(JournalBatchId);

    TempLine."Journal Batch Id" := JournalBatchId;
    TempLine."Account Type" := TempLine."Account Type"::Vendor;
    TempLine."Account No." := GetText(Item, 'vendorNumber');
    TempLine."Document No." := GetText(Item, 'documentNumber');
    TempLine."External Document No." := GetText(Item, 'externalDocumentNumber');
    TempLine.Description := GetText(Item, 'description');
    TempLine.Amount := GetDecimal(Item, 'amount');
    TempLine."Posting Date" := GetDate(Item, 'postingDate');

    DocTypeTxt := GetText(Item, 'appliesToDocType');

    // -----------------------------
    // INVOICE APPLICATION
    // -----------------------------
    if DocTypeTxt <> 'CreditMemo' then begin
        TempLine."Applies-to Doc. Type" := TempLine."Applies-to Doc. Type"::Invoice;
        TempLine."Applies-to Doc. No." := GetText(Item, 'appliesToInvoiceNumber');
        TempLine."Applies-to Invoice Id" := GetGuid(Item, 'appliesToInvoiceId');
    end else begin
    // -----------------------------
    // CREDIT MEMO APPLICATION
    // -----------------------------
        TempLine."Applies-to Doc. Type" := TempLine."Applies-to Doc. Type"::"Credit Memo";
        TempLine."Applies-to Doc. No." := GetText(Item, 'appliesToInvoiceNumber');
        TempLine.Amount := -Abs(TempLine.Amount); // credit memo is negative
    end;


    // Generate safe unique Line No.
    NextLineNo := GetNextLineNo('PAYMENT', BatchName);

    Clear(Line);

    GraphMgtVendorPayments.SetVendorPaymentsTemplateAndBatch(Line, BatchName);

    LibraryAPIGeneralJournal.InitializeLine(
        Line,
        NextLineNo,
        TempLine."Document No.",
        TempLine."External Document No."
    );

    if Line."Document No." = '' then
        Line."Document No." := TempLine."Document No.";

    // -----------------------------
    // APPLY VALUES BASED ON DOC TYPE
    // -----------------------------
    if DocTypeTxt <> 'CreditMemo' then begin
        // Use BC standard logic for invoice application
        GraphMgtVendorPayments.SetVendorPaymentsValues(Line, TempLine);
end else begin
    // Manual override for Credit Memo
    Line."Account Type" := Line."Account Type"::Vendor;
    Line."Account No." := TempLine."Account No.";
    Line.Validate("Account No.");

    Line."Applies-to Doc. Type" := Line."Applies-to Doc. Type"::"Credit Memo";
    Line."Applies-to Doc. No." := TempLine."Applies-to Doc. No.";

    Line.Amount := TempLine.Amount;
end;
    Line.Validate(Amount, TempLine.Amount);
    Line.Insert(true);
end;
//Helper function

local procedure GetText(Item: JsonObject; FieldName: Text): Text
var
    Token: JsonToken;
    JVal: JsonValue;
begin
    if not Item.Get(FieldName, Token) then
        exit('');

    JVal := Token.AsValue();
    exit(JVal.AsText());
end;



local procedure GetDecimal(Item: JsonObject; FieldName: Text): Decimal
var
    Token: JsonToken;
    JVal: JsonValue;
begin
    if not Item.Get(FieldName, Token) then
        exit(0);

    JVal := Token.AsValue();
    exit(JVal.AsDecimal());
end;

local procedure GetDate(Item: JsonObject; FieldName: Text): Date
var
    Token: JsonToken;
    JVal: JsonValue;
begin
    if not Item.Get(FieldName, Token) then
        exit(0D);

    JVal := Token.AsValue();
    exit(JVal.AsDate());
end;
local procedure GetGuid(Item: JsonObject; FieldName: Text): Guid
var
    Token: JsonToken;
    V: JsonValue;
    GuidText: Text;
    ResultGuid: Guid;
begin
    if not Item.Get(FieldName, Token) then
        exit(ResultGuid); // empty guid

    V := Token.AsValue();

    // Null or empty → return empty guid
    if V.IsNull() then
        exit(ResultGuid);

    GuidText := V.AsText();

    if GuidText = '' then
        exit(ResultGuid);

    // Convert text → Guid
    if not Evaluate(ResultGuid, GuidText) then
        Error('Invalid GUID value for field %1: %2', FieldName, GuidText);

    exit(ResultGuid);
end;




local procedure GetBatchNameFromId(JournalBatchId: Guid): Code[20]
var
    GenJournalBatch: Record "Gen. Journal Batch";
begin
    // Lookup by SystemId
    if GenJournalBatch.GetBySystemId(JournalBatchId) then
        exit(GenJournalBatch.Name);

    Error('Journal Batch not found for Id %1', JournalBatchId);
end;

local procedure GetNextLineNo(TemplateName: Code[20]; BatchName: Code[20]): Integer
var
    Line: Record "Gen. Journal Line";
begin
    Line.Reset();
    Line.SetRange("Journal Template Name", TemplateName);
    Line.SetRange("Journal Batch Name", BatchName);

    if Line.FindLast() then
        exit(Line."Line No." + 10000)
    else
        exit(10000); // first line
end;

}
