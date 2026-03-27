namespace CentimeAL.CentimeAL;

using Microsoft.HumanResources.Employee;
using Microsoft.Finance.Currency;


tableextension 70201 EmployeePaymentCurrencyExt extends Employee
{
    fields
    {
        field(70201; "Payment Currency Code"; Code[10])
        {
            Caption = 'Payment Currency Code';
            TableRelation = Currency.Code;
            DataClassification = CustomerContent;
        }
    }
}
