namespace EuroCompany.BaseApp.AWPExtension.ShippingOrder;

using EuroCompany.BaseApp.Setup;

pageextension 80037 "awpInbound Shipping Order" extends "AltAWPInbound Shipping Order"
{
    actions
    {
        modify(ShowShippingCosts)
        {
            Description = 'EC365';
            Visible = ShippingGroupCostsEnable;
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
