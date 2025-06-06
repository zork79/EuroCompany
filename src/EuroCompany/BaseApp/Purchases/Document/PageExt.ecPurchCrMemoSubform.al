namespace EuroCompany.BaseApp.Purchases.Document;
using Microsoft.Purchases.Document;
pageextension 80225 "ecPurch. Cr. Memo Subform" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        addafter("VAT Prod. Posting Group")
        {
            field("VAT Identifier"; Rec."VAT Identifier")
            {
                ApplicationArea = All;
            }
            field("ecVAT Purchase Account"; Rec."ecVAT Purchase Account")
            {
                ApplicationArea = All;
            }
            field("ecPurchase Account"; Rec."ecPurchase Account")
            {
                ApplicationArea = All;
            }
            field("ecAccount Name"; Rec."ecAccount Name")
            {
                ApplicationArea = All;
            }
        }
    }
}