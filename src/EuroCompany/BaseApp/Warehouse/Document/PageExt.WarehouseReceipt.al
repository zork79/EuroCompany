namespace EuroCompany.BaseApp.Warehouse.Document;

using EuroCompany.BaseApp.Setup;
using Microsoft.Warehouse.Document;

pageextension 80034 "Warehouse Receipt" extends "Warehouse Receipt"
{
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
