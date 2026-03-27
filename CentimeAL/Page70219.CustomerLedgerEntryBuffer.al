namespace CentimeAL.CentimeAL;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Receivables;

table 70219 "CustomerLedgerEntryBuffer"
{
    Caption = 'Customer Ledger Entry Buffer';
    TableType = Temporary;
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(8; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(14; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
        }
        field(36; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(47; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';
        }
        field(63; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(8001; "Customer Id"; Guid)
        {
            Caption = 'Customer Id';
        }
        field(8002; "Gen. Journal Line Id"; Guid)
        {
            Caption = 'Gen. Journal Line Id';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure LoadDataFromFilter(CustomerIdFilter: Text; GenJournalLineIdFilter: Text)
    var
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
        GenJournalLine: Record "Gen. Journal Line";
    begin
        Customer.GetBySystemId(CustomerIdFilter);
        GenJournalLine.GetBySystemId(GenJournalLineIdFilter);
        CustomerLedgerEntry.SetRange(Open, true);
        CustomerLedgerEntry.SetRange("Customer No.", Customer."No.");

        if CustomerLedgerEntry.FindSet() then
            repeat
                Clear(Rec);
                Rec.TransferFields(CustomerLedgerEntry);
                CustomerLedgerEntry.CalcFields("Remaining Amount");
                Rec."Remaining Amount" := CustomerLedgerEntry."Remaining Amount";
                Rec.SystemId := CustomerLedgerEntry.SystemId;
                Rec."Customer Id" := Customer.SystemId;
                Rec."Gen. Journal Line Id" := GenJournalLine.SystemId;
                Rec.Insert();
            until CustomerLedgerEntry.Next() = 0;
    end;
}