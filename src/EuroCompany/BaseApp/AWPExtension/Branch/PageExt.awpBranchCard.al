namespace EuroCompany.BaseApp.AWPExtension.Branch;

using EuroCompany.BaseApp.Setup;

pageextension 80001 "awpBranch Card" extends "AltAWPBranch Card"
{
    layout
    {
        modify("Shipping Group No. Series")
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
