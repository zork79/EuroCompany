namespace EuroCompany.BaseApp.Purchases.Document;
using Microsoft.Purchases.Document;
pageextension 80127 "Purchase Credit Memo" extends "Purchase Credit Memo"
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