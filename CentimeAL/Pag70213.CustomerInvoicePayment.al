namespace CentimeAL.CentimeAL;

using Microsoft.Sales.Receivables;
using Microsoft.Sales.Customer;

page 70255 CustomerInvoicePayment
{
    APIGroup = 'sync';
    APIPublisher = 'Centime';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Customer Invoice Payment';
    DelayedInsert = true;
    EntityName = 'customerInvoicePayment';
    EntitySetName = 'customerInvoicePayments';
    PageType = API;
    SourceTable = "Cust. Ledger Entry";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(paymentId; Rec."Document No.")
                {
                    Caption = 'paymentId';
                    Editable = false;
                }

                field(paymentNumber; Rec."Document No.")
                {
                    Caption = 'paymentNumber';
                    ToolTip = 'Specifies the document number of the payment.';
                }

                field(PostingDate; Rec."Posting Date")
                {
                    Caption = 'txnDate';
                    ToolTip = 'Specifies the posting date of the payment.';
                }

                field(Amount; Rec.Amount)
                {
                    Caption = 'txnTotalAmount';
                    ToolTip = 'Specifies the total amount of the payment.';
                }

                field(AmountLCY; Rec."Amount (LCY)")
                {
                    Caption = 'homeTotalAmount';
                    ToolTip = 'Specifies the total amount in home/local currency.';
                }


                field(RemainingAmount; Rec."Remaining Amount")
                {
                    Caption = 'txnUnappliedAmount';
                    ToolTip = 'Specifies the remaining unapplied amount of the payment.';
                }

                field(Open; Rec.Open)
                {
                    Caption = 'paymentActiveStatus';
                    ToolTip = 'Specifies whether the payment is open or closed.';
                }

                field(Reversed; Rec.Reversed)
                {
                    Caption = 'voidStatus';
                    ToolTip = 'Specifies whether the payment has been reversed.';
                }

                field(CurrencyCode; Rec."Currency Code")
                {
                    Caption = 'currencyCode';
                    ToolTip = 'Specifies the currency code of the payment.';
                }

                field(Description; Rec.Description)
                {
                    Caption = 'description';
                    ToolTip = 'Specifies the description of the payment.';
                }

                field(BalAccountNo; Rec."Bal. Account No.")
                {
                    Caption = 'balAccountNo';
                    ToolTip = 'Specifies the balancing account number.';
                }

                field(BalAccountType; Rec."Bal. Account Type")
                {
                    Caption = 'balAccountType';
                    ToolTip = 'Specifies the balancing account type.';
                }

                field(GLAccountNo; GLAccountNoVar)
                {
                    Caption = 'glAccountNo';
                    Editable = false;
                    ToolTip = 'Specifies the GL account number derived from the balancing account.';
                }

                field(CustomerNo; Rec."Customer No.")
                {
                    Caption = 'buyerId';
                    ToolTip = 'Specifies the customer number.';
                }

                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    Caption = 'externalDocumentNo';
                    ToolTip = 'Specifies the external document number.';
                }

                field(DocumentType; Rec."Document Type")
                {
                    Caption = 'documentType';
                    ToolTip = 'Specifies the document type.';
                }

                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'glCreatedTime';
                    ToolTip = 'Specifies the creation time of the entry.';
                }

                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'glUpdatedTime';
                    ToolTip = 'Specifies the last modification time of the entry.';
                }

                field(DueDate; Rec."Due Date")
                {
                    Caption = 'dueDate';
                    ToolTip = 'Specifies the due date of the payment.';
                }

                field(EntryNo; Rec."Entry No.")
                {
                    Caption = 'entryNo';
                    ToolTip = 'Specifies the entry number.';
                }
                field(paymentMethodId; Rec."Payment Method Code")
                {
                    Caption = 'paymentMethodId';
                    ToolTip = 'Specifies the payment method code.';
                }
                field(exchangeRate; exchangeRate)
                {
                    Caption = 'exchangeRate';
                    ToolTip = 'Exchange rate derived from Adjusted Currency Factor.';
                }

            }

            part(paymentLinkedTxns; PaymentLinkedTransactions)
            {
                Caption = 'Payment Linked Transactions';
                EntityName = 'paymentLinkedTxn';
                EntitySetName = 'paymentLinkedTxns';
                SubPageLink = "Document No." = Field("Document No."), "Customer No." = Field("Customer No.");
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        GLAccountNoVar := ResolveGLAccount();
        ExchangeRateVar := CalculateExchangeRate();
        if Rec."Adjusted Currency Factor" <> 0 then
        exchangeRate := 1 / Rec."Adjusted Currency Factor"
        else
        exchangeRate := 1;

    end;

    var
        GLAccountNoVar: Code[20];
        ExchangeRateVar: Decimal;
        GLAccountResolver: Codeunit "GL Account Resolver";

        exchangeRate: Decimal;

    local procedure CalculateExchangeRate(): Decimal
    begin
        if Rec.Amount <> 0 then
            exit(Rec."Amount (LCY)" / Rec.Amount)
        else
            exit(1.0);
    end;

    local procedure ResolveGLAccount(): Code[20]
    begin
        exit(GLAccountResolver.ResolveGLAccountNo(Rec."Bal. Account Type", Rec."Bal. Account No."));
    end;

}
