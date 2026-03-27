namespace CentimeAL.CentimeAL;
using Microsoft.Integration.Graph;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Journal;

permissionset 70200 VPPAPerm
{
    Assignable = true;
    Caption = 'Vendor Payment Partial App';

    Permissions =
        // Your original table permission
        tabledata "Vendor Payment Partial App" = RIMD,
        table "Vendor Payment Partial App" = X,

        // NEW: Required for Bulk Vendor Payments API
        tabledata "Bulk Vendor Payment Buffer" = RIMD,
        table "Bulk Vendor Payment Buffer" = X,

        // NEW: Allow API Page execution
        page "BulkVendorPayments" = X,

        // NEW: Allow VendorPayments API to be invoked internally if needed
        page "VendorPayments" = X,

        // NEW: Codeunit that processes the bulk JSON
        codeunit "BulkVendorPaymentHandler" = X,

        // NEW: Microsoft internal objects you call
        codeunit "Graph Mgt - Vendor Payments" = X,
        codeunit "Library API - General Journal" = X,

        // NEW: Required for posting
        codeunit "Gen. Jnl.-Post Batch" = X,

        // NEW: Tables needed by your handler
        tabledata "Gen. Journal Line" = RIMD,
        table "Gen. Journal Line" = X,
        tabledata "Gen. Journal Batch" = R,
        table "Gen. Journal Batch" = X;

              
}
