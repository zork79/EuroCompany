namespace EuroCompany.BaseApp.AWPExtension.ShippingCosts;

using EuroCompany.BaseApp.Setup;

pageextension 80035 "awpShipping Costs Type" extends "AltAWPShipping Costs Type"
{
    trigger OnOpenPage()
    var
        lECGeneralSetup: Record "ecGeneral Setup";
        lError001: Label '#TODO#', Locked = true;
    begin
        //EC365-s
        lECGeneralSetup.Get();
        if not lECGeneralSetup."Enable Shipping Group/Costs" then begin
            Error(lError001);
        end;
        //EC365-e
    end;
}
