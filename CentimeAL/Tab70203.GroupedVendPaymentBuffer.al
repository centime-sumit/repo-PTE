table 70203 "Grouped Vend Payment Buffer"
{
 Caption = 'Grouped Vendor Payment Buffer';
    DataClassification = ToBeClassified;
    ObsoleteState = Removed;
    ObsoleteReason = 'Feature reverted';
    ObsoleteTag = 'v1.0';
    fields
    {
        field(1; "Id"; Guid)
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Journal Template Name"; Code[10]) { }
        field(3; "Journal Batch Name"; Code[10]) { }
        field(4; "Vendor No."; Code[20]) { }
        field(5; "Bank Account No."; Code[20]) { }
        field(6; "Posting Date"; Date) { }
        field(7; "Document No."; Code[20]) { }
        field(8; "Currency Code"; Code[10]) { }
        field(9; "Post After Apply"; Boolean) { }
        field(10; "Journal Batch Id"; Guid)
        {
            Caption = 'Journal Batch Id';
        }
    }
    keys
    {
        key(PK; "Id") { Clustered = true; }
    }
}
