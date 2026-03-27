namespace CentimeAL.CentimeAL;

using Microsoft.CRM.Contact;

page 70214 "Contact Job Responsibilty"
{
    APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'contactJobResponsibility';
    DelayedInsert = true;
    EntityName = 'contactJobResponsibility';
    EntitySetName = 'contactJobResponsibilties';
    PageType = API;
    SourceTable = "Contact Job Responsibility";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(contactCompanyName; Rec."Contact Company Name")
                {
                    Caption = 'Contact Company Name';
                }
                field(contactName; Rec."Contact Name")
                {
                    Caption = 'Contact Name';
                }
                field(contactNo; Rec."Contact No.")
                {
                    Caption = 'Contact No.';
                }
                field(jobResponsibilityCode; Rec."Job Responsibility Code")
                {
                    Caption = 'Job Responsibility Code';
                }
                field(jobResponsibilityDescription; Rec."Job Responsibility Description")
                {
                    Caption = 'Job Responsibility Description';
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
}
