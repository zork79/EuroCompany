namespace EuroCompany.BaseApp.AWPExtension.ShippingOrder;

using EuroCompany.BaseApp.Setup;

pageextension 80039 "awpPosted Out Ship Orders" extends "AltAWPPosted Out Ship Orders"
{
    layout
    {
        modify("Total Shipping Costs")
        {
            Description = 'EC365';
            Visible = ShippingGroupCostsEnable;
        }
    }

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
