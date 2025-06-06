namespace EuroCompany.BaseApp.Purchases.Document;

using Microsoft.Purchases.Document;

pageextension 80115 "Purchase Return Order" extends "Purchase Return Order"
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