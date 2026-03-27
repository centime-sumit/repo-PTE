namespace CentimeAL.CentimeAL;

page 70220 BulkVendorPayments
{
    /*APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'bulkVendorPayments';
    DelayedInsert = true;
    EntityName = 'bulkVendorPayment';
    EntitySetName = 'bulkVendorPayments';
    PageType = API;
    SourceTable = "Bulk Vendor Payment Buffer";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field(payload; Rec.Payload)
                {
                    Caption = 'Payload';
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'SystemCreatedBy';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    Caption = 'SystemModifiedBy';
                }
            }
        }
    }

trigger OnInsertRecord(BelowxRec: Boolean): Boolean
var
    Handler: Codeunit "BulkVendorPaymentHandler";
begin
    // Process payload
    Handler.ProcessBulkPayments(Rec.Payload);

    // Prevent API from inserting this record
    exit(false);
end;

*/


}
