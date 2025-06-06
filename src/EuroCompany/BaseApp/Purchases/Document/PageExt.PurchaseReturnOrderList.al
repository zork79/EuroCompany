namespace EuroCompany.BaseApp.Purchases.Document;

using Microsoft.Purchases.Document;
pageextension 80114 "Purchase Return Order List" extends "Purchase Return Order List"
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