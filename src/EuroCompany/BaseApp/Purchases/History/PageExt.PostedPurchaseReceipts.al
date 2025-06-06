namespace EuroCompany.BaseApp.Purchases.History;

using Microsoft.Purchases.History;

pageextension 80112 "Posted Purchase Receipts" extends "Posted Purchase Receipts"
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