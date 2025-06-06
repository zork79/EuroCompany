namespace EuroCompany.BaseApp.Purchases.History;

using Microsoft.Purchases.History;

pageextension 80113 "Posted Purchase Receipt" extends "Posted Purchase Receipt"
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