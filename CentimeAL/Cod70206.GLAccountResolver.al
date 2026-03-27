namespace CentimeAL.CentimeAL;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Bank.BankAccount;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.Setup;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;

codeunit 70206 "GL Account Resolver"
{
    /// <summary>
    /// Resolves GL account number based on account type and account number.
    /// For Bank Accounts, Fixed Assets, Vendors, and Customers, derives the underlying GL account.
    /// </summary>
    procedure ResolveGLAccountNo(AccountType: Enum "Gen. Journal Account Type"; AccountNo: Code[20]): Code[20]
    begin
        case AccountType of
            AccountType::"G/L Account":
                exit(GetGLAccountNo(AccountNo));
            AccountType::"Bank Account":
                exit(GetGLAccountNoFromBankAccount(AccountNo));
            AccountType::"Fixed Asset":
                exit(GetGLAccountNoFromFixedAsset(AccountNo));
            AccountType::Vendor:
                exit(GetGLAccountNoFromVendor(AccountNo));
            AccountType::Customer:
                exit(GetGLAccountNoFromCustomer(AccountNo));
        end;
        exit('');
    end;

    local procedure GetGLAccountNo(AccountNo: Code[20]): Code[20]
    var
        GLAccount: Record "G/L Account";
    begin
        if AccountNo <> '' then
            if GLAccount.Get(AccountNo) then
                exit(GLAccount."No.");
        exit('');
    end;

    local procedure GetGLAccountNoFromBankAccount(BankAccountNo: Code[20]): Code[20]
    var
        BankAccount: Record "Bank Account";
        BankPostingGroup: Record "Bank Account Posting Group";
    begin
        if BankAccountNo <> '' then
            if BankAccount.Get(BankAccountNo) then
                if BankPostingGroup.Get(BankAccount."Bank Acc. Posting Group") then
                    exit(BankPostingGroup."G/L Account No.");
        exit('');
    end;

    local procedure GetGLAccountNoFromFixedAsset(FixedAssetNo: Code[20]): Code[20]
    var
        FixedAsset: Record "Fixed Asset";
        FAPostingGroup: Record "FA Posting Group";
    begin
        if FixedAssetNo <> '' then
            if FixedAsset.Get(FixedAssetNo) then
                if FAPostingGroup.Get(FixedAsset."FA Posting Group") then
                    exit(FAPostingGroup."Acquisition Cost Account");
        exit('');
    end;

    local procedure GetGLAccountNoFromVendor(VendorNo: Code[20]): Code[20]
    var
        Vendor: Record Vendor;
        VendorPostingGroup: Record "Vendor Posting Group";
    begin
        if VendorNo <> '' then
            if Vendor.Get(VendorNo) then
                if VendorPostingGroup.Get(Vendor."Vendor Posting Group") then
                    exit(VendorPostingGroup."Payables Account");
        exit('');
    end;

    local procedure GetGLAccountNoFromCustomer(CustomerNo: Code[20]): Code[20]
    var
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
    begin
        if CustomerNo <> '' then
            if Customer.Get(CustomerNo) then
                if CustomerPostingGroup.Get(Customer."Customer Posting Group") then
                    exit(CustomerPostingGroup."Receivables Account");
        exit('');
    end;
}