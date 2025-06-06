namespace EuroCompany.BaseApp.Purchases.Document;
using EuroCompany.BaseApp.Setup;
using Microsoft.Purchases.Document;

pageextension 80033 "Purch. Invoice Subform" extends "Purch. Invoice Subform"
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
    actions
    {
        modify(AltAWPGetShippingCosts)
        {
            Description = 'EC365';
            Enabled = ShippingGroupCostsEnable;
        }
    }

    var
        ShippingGroupCostsEnable: Boolean;

    trigger OnOpenPage()
    var
        lECGeneralSetup: Record "ecGeneral Setup";
    begin
        //EC365-s
        lECGeneralSetup.Get();
        ShippingGroupCostsEnable := lECGeneralSetup."Enable Shipping Group/Costs";
        //EC365-e
    end;
}
