namespace CentimeAL.CentimeAL;

using Microsoft.HumanResources.Employee;

pageextension 70202 EmployeeCardPaymentCurrencyExt extends "Employee Card"
{
    layout
    {
        addafter("Employee Posting Group")
        {
            field("Payment Currency Code"; Rec."Payment Currency Code")
            {
                ApplicationArea = All;
            }
        }
    }
}

