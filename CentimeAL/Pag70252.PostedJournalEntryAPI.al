namespace CentimeAL.CentimeAL;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Integration.Graph;

page 70252 "Posted Journal Entry API"
{
    APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'postedJournalEntry';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    EntityName = 'journalEntry';
    EntitySetName = 'journalEntries';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = API;
    SourceTable = "Posted Gen. Journal Line";
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
                
                // Header-level canonical fields
                field(journalEntryId; Rec."Document No.")
                {
                    Caption = 'Journal Entry Id';
                    Editable = false;
                }
                field(journalEntryNumber; Rec."Document No.")
                {
                    Caption = 'Journal Entry Number';
                    Editable = false;
                }
                field(batchId; Rec."Document No.")
                {
                    Caption = 'Batch Id';
                    Editable = false;
                }
                field(journalEntryType; Rec."Journal Batch Name")
                {
                    Caption = 'Journal Entry Type';
                    Editable = false;
                }
                field(txnDate; Rec."Posting Date")
                {
                    Caption = 'Transaction Date';
                    Editable = false;
                }
                field(createdTime; Rec.SystemCreatedAt)
                {
                    Caption = 'Created Time';
                    Editable = false;
                }
                field(updatedTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Updated Time';
                    Editable = false;
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                    Editable = false;
                }
                field(currencyCode; GetCurrencyCode())
                {
                    Caption = 'Currency Code';
                    Editable = false;
                }
                field(exchangeRate; GetExchangeRate())
                {
                    Caption = 'Exchange Rate';
                    Editable = false;
                }
                field(journalEntryActiveStatus; 'Active')
                {
                    Caption = 'Journal Entry Active Status';
                    Editable = false;
                }
                field(type; 'JOURNAL_ENTRY')
                {
                    Caption = 'Type';
                    Editable = false;
                }

                // Line-level fields
                field(lineId; Rec."Line No.")
                {
                    Caption = 'Line Id';
                    Editable = false;
                }

                field(lineType; GetLineType())
                {
                    Caption = 'Line Type';
                    Editable = false;
                }
                field(accountId; AccountNo)
                {
                    Caption = 'Account Id';
                    Editable = false;
                }
                field(balaccountId; BalanceAccountNo)
                {
                    Caption = 'Bal Account Id';
                    Editable = false;
                }
                field(amount; GetAbsoluteAmount())
                {
                    Caption = 'Amount';
                    Editable = false;
                }
                field(homeAmount; GetHomeAmount())
                {
                    Caption = 'Home Amount';
                    Editable = false;
                }
                field(txnAmount; GetAbsoluteAmount())
                {
                    Caption = 'Transaction Amount';
                    Editable = false;
                }


                field(paymentMethodId; Rec."Payment Method Code")
                {
                    Caption = 'Payment Method Id';
                    Editable = false;
                }
               
            }
        }
    }

    trigger OnOpenPage()
    begin
        ApplyDocumentTypeFilter();
    end;

    trigger OnAfterGetRecord()
    var
        GLAccountResolver: Codeunit "GL Account Resolver";
    begin
        BalanceAccountNo := GLAccountResolver.ResolveGLAccountNo(
            Rec."Bal. Account Type",
            Rec."Bal. Account No."
        );

        AccountNo:= GLAccountResolver.ResolveGLAccountNo(
            Rec."Account Type",
            Rec."Account No."
        );

    end;

    var
        BalanceAccountNo: Code[20];
        AccountNo: Code[20];

    local procedure ApplyDocumentTypeFilter()
    var
        BlankDocType: Enum "Gen. Journal Document Type";
    begin
        // Filter to only blank or Refund document types
        Rec.SetFilter("Document Type", '%1|%2', BlankDocType::" ", BlankDocType::Refund);
    end;



    local procedure GetLineType(): Text
    begin
        // If debit amount is positive, it's DEBIT; if credit amount is positive, it's CREDIT
        if Rec."Debit Amount" > 0 then
            exit('DEBIT')
        else if Rec."Credit Amount" > 0 then
            exit('CREDIT')
        else
            exit('');
    end;

    local procedure GetAbsoluteAmount(): Decimal
    begin
        // Return absolute value: either debit or credit amount
        if Rec."Debit Amount" > 0 then
            exit(Rec."Debit Amount")
        else if Rec."Credit Amount" > 0 then
            exit(Rec."Credit Amount")
        else
            exit(0);
    end;

    local procedure GetHomeAmount(): Decimal
    begin
        // Amount in local currency (LCY) - absolute value
        // Use Debit Amount (LCY) or Credit Amount (LCY) as absolute values
        if Rec."Debit Amount" > 0 then
            exit(Rec."Debit Amount")
        else if Rec."Credit Amount" > 0 then
            exit(Rec."Credit Amount")
        else
            exit(0);
    end;

    local procedure GetCurrencyCode(): Text
    begin
        // Currency Code from Posted Gen. Journal Line
        exit(Rec."Currency Code");
    end;

    local procedure GetExchangeRate(): Decimal
    begin
        // Currency Factor (exchange rate) from Posted Gen. Journal Line
        // Default to 1.0 if zero or empty
        if Rec."Currency Factor" > 0 then
            exit(Rec."Currency Factor")
        else
            exit(1.0);
    end;
}