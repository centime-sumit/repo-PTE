namespace CentimeAL.CentimeAL;

using Microsoft.FixedAssets.FixedAsset;

page 70209 FixedAsset
{
    APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'fixedAsset';
    DelayedInsert = true;
    EntityName = 'fixedAsset';
    EntitySetName = 'fixedAssets';
    PageType = API;
    SourceTable = "Fixed Asset";
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(acquired; Rec.Acquired)
                {
                    Caption = 'Acquired';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
                field(budgetedAsset; Rec."Budgeted Asset")
                {
                    Caption = 'Budgeted Asset';
                }
                field(comment; Rec.Comment)
                {
                    Caption = 'Comment';
                }
                field(componentOfMainAsset; Rec."Component of Main Asset")
                {
                    Caption = 'Component of Main Asset';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field(faClassCode; Rec."FA Class Code")
                {
                    Caption = 'FA Class Code';
                }
                field(faLocationCode; Rec."FA Location Code")
                {
                    Caption = 'FA Location Code';
                }
                field(faLocationId; Rec."FA Location Id")
                {
                    Caption = 'FA Location Code';
                }
                field(faPostingGroup; Rec."FA Posting Group")
                {
                    Caption = 'FA Posting Group';
                }
                field(faSubclassCode; Rec."FA Subclass Code")
                {
                    Caption = 'FA Subclass Code';
                }
                field(globalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Global Dimension 1 Code';
                }
                field(globalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    Caption = 'Global Dimension 2 Code';
                }
                field(image; Rec.Image)
                {
                    Caption = 'Image';
                }
                field(inactive; Rec.Inactive)
                {
                    Caption = 'Inactive';
                }
                field(insured; Rec.Insured)
                {
                    Caption = 'Insured';
                }
                field(lastDateModified; Rec."Last Date Modified")
                {
                    Caption = 'Last Date Modified';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(mainAssetComponent; Rec."Main Asset/Component")
                {
                    Caption = 'Main Asset/Component';
                }
                field(maintenanceVendorNo; Rec."Maintenance Vendor No.")
                {
                    Caption = 'Maintenance Vendor No.';
                }
                field(nextServiceDate; Rec."Next Service Date")
                {
                    Caption = 'Next Service Date';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(noSeries; Rec."No. Series")
                {
                    Caption = 'No. Series';
                }
                field(responsibleEmployee; Rec."Responsible Employee")
                {
                    Caption = 'Responsible Employee';
                }
                field(responsibleEmployeeId; Rec."Responsible Employee Id")
                {
                    Caption = 'Responsible Employee';
                }
                field(satClassificationCode; Rec."SAT Classification Code")
                {
                    Caption = 'SAT Classification Code';
                }
                field(satFederalAutotransport; Rec."SAT Federal Autotransport")
                {
                    Caption = 'SAT Federal Autotransport';
                }
                field(satTrailerType; Rec."SAT Trailer Type")
                {
                    Caption = 'SAT Trailer Type';
                }
                field(sctPermissionNo; Rec."SCT Permission No.")
                {
                    Caption = 'SCT Permission No.';
                }
                field(sctPermissionType; Rec."SCT Permission Type")
                {
                    Caption = 'SCT Permission Type';
                }
                field(searchDescription; Rec."Search Description")
                {
                    Caption = 'Search Description';
                }
                field(serialNo; Rec."Serial No.")
                {
                    Caption = 'Serial No.';
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
                field(underMaintenance; Rec."Under Maintenance")
                {
                    Caption = 'Under Maintenance';
                }
                field(vehicleGrossWeight; Rec."Vehicle Gross Weight")
                {
                    Caption = 'Vehicle Gross Weight';
                }
                field(vehicleLicencePlate; Rec."Vehicle Licence Plate")
                {
                    Caption = 'Vehicle Licence Plate';
                }
                field(vehicleYear; Rec."Vehicle Year")
                {
                    Caption = 'Vehicle Year';
                }
                field(vendorNo; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(warrantyDate; Rec."Warranty Date")
                {
                    Caption = 'Warranty Date';
                }
                part(defaultDimensions; "DefaultDimensions")
                {
                    Caption = 'Default Dimensions';
                    EntityName = 'defaultDimension';
                    EntitySetName = 'defaultDimensions';
                    SubPageLink = "Table ID" = CONST(Database::"Fixed Asset"),
                              "No." = FIELD("No.");
                }
            }
        }
    }
}
