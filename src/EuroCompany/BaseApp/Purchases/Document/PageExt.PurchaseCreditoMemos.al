namespace EuroCompany.BaseApp.Purchases.Document;
using Microsoft.Purchases.Document;
pageextension 80126 "Purchase Credito Memos" extends "Purchase Credit Memos"
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
    }
}