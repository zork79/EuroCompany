namespace EuroCompany.BaseApp.AWPExtension.Setup;

using EuroCompany.BaseApp.Setup;

pageextension 80003 "awpGeneral Setup" extends "AltAWPGeneral Setup"
{
    layout
    {
        modify(ShippingGroups)
        {
            Description = 'EC365';
            Visible = ShippingGroupCostsEnable;
        }
        modify(ShippingCosts)
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
