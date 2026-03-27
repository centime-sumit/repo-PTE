namespace CentimeAL.CentimeAL;

using Microsoft.Purchases.Payables;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Sales.Receivables;
using Microsoft.Finance.ReceivablesPayables;

page 70218 "ApplyCustomerEntries"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Apply Customer Entry';
    EntitySetCaption = 'Apply Customer Entries';
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    PageType = API;
    EntityName = 'applyCustomerEntry';
    EntitySetName = 'applyCustomerEntries';
    SourceTable = CustomerLedgerEntryBuffer;
    SourceTableTemporary = true;
    Extensible = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    APIGroup = 'sync';
    APIPublisher = 'Centime';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(applied; Applied)
                {
                    Caption = 'Applied';
                }
                field(appliesToId; Rec."Applies-to ID")
                {
                    Caption = 'Applies-to Id';
                    Editable = false;
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                    Editable = false;
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                    Editable = false;
                }
                field(documentNumber; Rec."Document No.")
                {
                    Caption = 'Document No.';
                    Editable = false;
                }
                field(externalDocumentNumber; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                    Editable = false;
                }
                field(customerNumber; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                    Editable = false;
                }
                field(customerName; Rec."Customer Name")
                {
                    Caption = 'Customer Name';
                    Editable = false;
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                    Editable = false;
                }
                field(remainingAmount; Rec."Remaining Amount")
                {
                    Caption = 'Remaining Amount';
                    Editable = false;
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date';
                    Editable = false;
                }
                field(journalId; Rec."Gen. Journal Line Id")
                {
                    Caption = 'Journal Line Id';
                }
                field(customerId; Rec."Customer Id")
                {
                    Caption = 'Customer Id';
                }
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Customer Id';
                }
                field(updateEntry; updateEntry)
                {
                    Caption = 'Update entry';
                }
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    var
        CustomerIdFilter: Text;
        GenJournalLineIdFilter: Text;
        FilterView: Text;
    begin
        CustomerIdFilter := Rec.GetFilter("Customer Id");
        GenJournalLineIdFilter := Rec.GetFilter("Gen. Journal Line Id");
        if (CustomerIdFilter = '') or (GenJournalLineIdFilter = '') then
            Error(FiltersNotSpecifiedErr);
        if RecordsLoaded then
            exit(true);
        FilterView := Rec.GetView();
        Rec.LoadDataFromFilter(CustomerIdFilter, GenJournalLineIdFilter);
        Rec.SetView(FilterView);
        if not Rec.FindFirst() then
            exit(false);
        RecordsLoaded := true;
        exit(true);
    end;

    trigger OnAfterGetRecord()
    begin
        SetCalculatedFields();
    end;

    trigger OnModifyRecord(): Boolean
    var
        GenJournalLine: Record "Gen. Journal Line";
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        GenJnlApply: Codeunit CustomerGenJournalApply;
    begin
        GenJournalLine.GetBySystemId(Rec."Gen. Journal Line Id");
        CustomerLedgerEntry.Get(Rec."Entry No.");
        GenJnlApply.SetCustApplIdAPI(GenJournalLine, CustomerLedgerEntry);
        GenJnlApply.ApplyCustomerLedgerEntryAPI(GenJournalLine);
        CustomerLedgerEntry.Get(Rec."Entry No.");
        Rec.TransferFields(CustomerLedgerEntry);
        CustomerLedgerEntry.CalcFields("Remaining Amount");
        Rec."Remaining Amount" := CustomerLedgerEntry."Remaining Amount";
        Rec.Modify();
        SetCalculatedFields();
        exit(false);
    end;

    var
        FiltersNotSpecifiedErr: Label 'You must specify a customer payment to get apply customer entries.';
        RecordsLoaded: Boolean;
        Applied: Boolean;
        journalId: Guid;
        customerId: Guid;
        updateEntry: Boolean;

    local procedure SetCalculatedFields()
    begin
        Applied := Rec."Applies-to ID" <> '';
    end;
}