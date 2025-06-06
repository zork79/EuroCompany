namespace EuroCompany.BaseApp.Sales.Receivables;

using Microsoft.Sales.Receivables;

pageextension 80116 "Customer Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Document Date")
        {
            field("ecRef. Date For Calc. Due Date"; Rec."ecRef. Date For Calc. Due Date")
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("ecCredit Insured"; Rec."ecCredit Insured")
            {
                ApplicationArea = All;
            }
        }
    }
}