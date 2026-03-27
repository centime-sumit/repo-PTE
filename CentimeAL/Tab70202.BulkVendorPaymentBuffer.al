table 70202 "Bulk Vendor Payment Buffer"
{
    Caption = 'Bulk Vendor Payment Buffer';
    DataClassification = ToBeClassified;
    ObsoleteState = Removed;
    ObsoleteReason = 'Feature reverted';
    ObsoleteTag = 'v1.0';
    
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; Payload; Text[2048])
        {
            Caption = 'Payload';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
