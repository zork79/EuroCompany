namespace EuroCompany.BaseApp.Sales.Document;

using Microsoft.Sales.Document;

pageextension 80118 "Sales Credit Memos" extends "Sales Credit Memos"
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