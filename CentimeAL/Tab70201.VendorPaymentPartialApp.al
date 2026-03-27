table 70201 "Vendor Payment Partial App"
{
    Caption = 'Vendor Payment Partial App';
    ObsoleteState = Removed;
    ObsoleteReason = 'Feature reverted';
    ObsoleteTag = 'v1.0';
    DataClassification = ToBeClassified;
    
     fields
    {
        field(1; "Entry Id"; Guid)
        {
            Caption = 'Entry Id';
            DataClassification = SystemMetadata;
        }

        field(2; "Parent Payment Id"; Guid)
        {
            Caption = 'Parent Payment Id';
            DataClassification = CustomerContent;
        }

        field(3; "Invoice Id"; Guid)
        {
            Caption = 'Invoice Id';
            DataClassification = CustomerContent;
        }

        field(4; "Amount To Apply"; Decimal)
        {
            Caption = 'Amount To Apply';
            DataClassification = CustomerContent;
            DecimalPlaces = 2:5;
        }

        field(5; "Created At"; DateTime)
        {
            Caption = 'Created At';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry Id") { Clustered = true; }
        key(ParentKey; "Parent Payment Id") { }
    }

    trigger OnInsert()
    begin
        if IsNullGuid("Entry Id") then
            "Entry Id" := CreateGuid();

        "Created At" := CurrentDateTime();
    end;
}
