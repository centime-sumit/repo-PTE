table 70204 "Grouped Vend Payment App"
{
Caption = 'Grouped Vendor Payment Application';
    DataClassification = ToBeClassified;
    ObsoleteState = Removed;
    ObsoleteReason = 'Feature reverted';
    ObsoleteTag = 'v1.0';
    fields
    {
        field(1; "Header Id"; Guid) { }
        field(2; "Line No."; Integer) { }
        field(3; "Document Type"; Enum "Gen. Journal Document Type") { }
        field(4; "Document No."; Code[20]) { }
        field(5; "Amount To Apply"; Decimal) { }
    }
    keys
    {
        key(PK; "Header Id", "Line No.") { Clustered = true; }
    }
}
