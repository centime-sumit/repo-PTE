namespace CentimeAL.CentimeAL;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Account;

permissionset 70202 "PostedJnlEntryAPI"
{
    Assignable = true;
    Caption = 'Posted Jnl Entry API';
    Permissions =
        page "Posted Journal Entry API" = X,
        tabledata "Posted Gen. Journal Line" = r,
        tabledata "Gen. Journal Batch" = r,
        tabledata "G/L Account" = r;
}