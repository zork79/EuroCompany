namespace EuroCompany.BaseApp.Warehouse.History;

using EuroCompany.BaseApp.Setup;
using Microsoft.Warehouse.History;



pageextension 80030 "Posted Whse. Receipt List" extends "Posted Whse. Receipt List"
{
    layout
    {
        modify("AltAWPTotal Shipping Costs")
        {
            Description = 'EC365';
            Visible = ShippingGroupCostsEnable;
        }
    }

    actions
    {
        modify(AltAWPShowShippingCosts)
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
