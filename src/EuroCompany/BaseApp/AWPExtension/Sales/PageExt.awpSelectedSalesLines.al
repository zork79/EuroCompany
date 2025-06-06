namespace EuroCompany.BaseApp.AWPExtension.Sales;

using EuroCompany.BaseApp.Setup;

pageextension 80018 "awpSelected Sales Lines" extends "AltAWPSelected Sales Lines"
{
    layout
    {
        modify(TotalParcels)
        {
            Caption = 'No. of logistic units';
            Description = 'CS_LOG_001';
        }
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
