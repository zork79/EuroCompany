namespace EuroCompany.BaseApp.Sales.Document;

using Microsoft.Sales.Document;
pageextension 80119 "Sales Return Order List" extends "Sales Return Order List"
{
    layout
    {
        addafter("Document Date")
        {
            field("ecRef. Date For Calc. Due Date"; Rec."ecRef. Date For Calc. Due Date")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
        }
    }
}