namespace EuroCompany.BaseApp.AWPExtension.Transfers;

using EuroCompany.BaseApp.Setup;

pageextension 80029 "awpSelected Transfer Lines" extends "AltAWPSelected Transfer Lines"
{
    layout
    {
        modify(gShippingGroup)
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
