namespace EuroCompany.BaseApp.Purchases.History;

using Microsoft.Purchases.History;

pageextension 80108 "Posted Purchase Credit Memos" extends "Posted Purchase Credit Memos"
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