namespace EuroCompany.BaseApp.Sales.Receivables;

using Microsoft.Sales.Receivables;
tableextension 80043 "Customer Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "ecRef. Date For Calc. Due Date"; Date)
        {
            Caption = 'Ref. Date For Calc. Due Date';
            DataClassification = CustomerContent;
        }
        field(50001; "ecCredit Insured"; Boolean)
        {
            Caption = 'Credit Insured';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}