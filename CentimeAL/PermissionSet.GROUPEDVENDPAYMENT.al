namespace CentimeAL.CentimeAL;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Bank.BankAccount;
using Microsoft.Purchases.Vendor;
using Microsoft.Purchases.Payables;

permissionset 70201 "GROUPED VEND PAYMENT"
{
    Assignable = true;
    Caption = 'GROUPED VEND PAYMENT', MaxLength = 30;
     Permissions =
        tabledata "Grouped Vend Payment Buffer" = rimd,
        tabledata "Grouped Vend Payment App" = rimd,
        tabledata "Gen. Journal Line" = rimd,
        tabledata "Vendor Ledger Entry" = rimd,
        tabledata Vendor = r,
        tabledata "Bank Account" = r,
        tabledata "Gen. Journal Batch"= r;
}
