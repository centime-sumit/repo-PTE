namespace CentimeAL.CentimeAL;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.API.V2;
using Microsoft.Bank.BankAccount;

page 70229 "Accounts"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Account';
    EntitySetCaption = 'Accounts';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'account';
    EntitySetName = 'accounts';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "G/L Account";
    Extensible = false;
    APIPublisher = 'Centime';
    APIGroup = 'sync';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(number; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(displayName; Rec.Name)
                {
                    Caption = 'Display Name';
                }
                field(category; Rec."Account Category")
                {
                    Caption = 'Category';
                }
                field(subCategory; Rec."Account Subcategory Descript.")
                {
                    Caption = 'Subcategory';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
                field(accountType; Rec."API Account Type")
                {
                    Caption = 'Account Type';
                }
                field(directPosting; Rec."Direct Posting")
                {
                    Caption = 'Direct Posting';
                }
                field(netChange; Rec."Net Change")
                {
                    Caption = 'Net Change';
                }
                field(consolidationTranslationMethod; Rec."Consol. Translation Method")
                {
                    Caption = 'Consolidation Translation Method';
                }
                field(consolidationDebitAccount; Rec."Consol. Debit Acc.")
                {
                    Caption = 'Consolidation Debit Account';
                }
                field(consolidationCreditAccount; Rec."Consol. Credit Acc.")
                {
                    Caption = 'Consolidation Credit Account';
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'Created Date';
                }
                field(globalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Global Dimension 1 Code';
                }
                field(globalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    Caption = 'Global Dimension 2 Code';
                }
                field(generalBusinessPostingGroup; Rec."Gen. Bus. Posting Group")
                {

                }
                field(generalProductPostingGroup; Rec."Gen. Prod. Posting Group")
                {

                }
                field(generalPostingType; Rec."Gen. Posting Type")
                {

                }
                field(BankNameVar; BankNameVar) { }
                field(BankAccountNumberVar; BankAccountNumberVar) { }
                field(BankBranchNumberVar; BankBranchNumberVar) { }
                field(BankAccountIdVar; BankAccountIdVar) { }
                field(BankCurrencyCodeVar; BankCurrencyCodeVar) { }

                part(defaultDimensions; "DefaultDimensions")
                {
                    Caption = 'Default Dimensions';
                    EntityName = 'defaultDimension';
                    EntitySetName = 'defaultDimensions';
                    SubPageLink = "Table ID" = const(15), "No." = field("No.");
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        BankAccount: Record "Bank Account";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
        bestBankNo: Code[20];
    begin
        // Clear previous values (prevents stale results)
        BankNameVar := '';
        BankAccountNumberVar := '';
        BankBranchNumberVar := '';
        BankAccountIdVar := '';
        BankCurrencyCodeVar := '';
        bestBankNo := '';

        // Find posting-group rows that point to this G/L account
        BankAccountPostingGroup.SetRange("G/L Account No.", Rec."No.");
        if BankAccountPostingGroup.FindSet() then begin
            repeat
                // For each posting-group code, find bank accounts that use that posting group
                BankAccount.SetRange("Bank Acc. Posting Group", BankAccountPostingGroup.Code);
                if BankAccount.FindSet() then begin
                    repeat
                        // Deterministic selection:
                        // pick smallest Bank Account No. as fallback tie-breaker.
                        // Replace this condition to prefer SAVINGS/CHECKING/currency/is_default if needed.
                        if (bestBankNo = '') or (BankAccount."No." < bestBankNo) then begin
                            bestBankNo := BankAccount."No.";
                            BankNameVar := BankAccount.Name;
                            BankAccountNumberVar := BankAccount."Bank Account No.";
                            BankBranchNumberVar := BankAccount."Bank Branch No.";
                            BankAccountIdVar := BankAccount."No.";
                            BankCurrencyCodeVar := BankAccount."Currency Code";
                        end;
                    until BankAccount.Next() = 0;
                end;
            until BankAccountPostingGroup.Next() = 0;
        end;
    end;


    var
        BankNameVar: Text[100];
        BankAccountNumberVar: Text[30];
        BankBranchNumberVar: Text[30];
        BankAccountIdVar: Code[20];
        BankCurrencyCodeVar: Code[10];

}