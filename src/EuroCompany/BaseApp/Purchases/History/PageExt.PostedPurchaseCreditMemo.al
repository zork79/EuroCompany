namespace EuroCompany.BaseApp.Purchases.History;

using Microsoft.Purchases.History;

pageextension 80109 "Posted Purchase Credit Memo" extends "Posted Purchase Credit Memo"
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