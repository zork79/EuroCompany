namespace EuroCompany.BaseApp.AWPExtension.ShippingCosts;

using EuroCompany.BaseApp.Setup;

reportextension 80000 "awpShipping Cost To Invoice" extends "AltAWPShipping Cost To Invoice"
{
    trigger OnPreReport()
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
