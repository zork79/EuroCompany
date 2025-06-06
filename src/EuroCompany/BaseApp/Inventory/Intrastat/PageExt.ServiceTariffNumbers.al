namespace EuroCompany.BaseApp.Inventory.Intrastat;

using Microsoft.Inventory.Intrastat;

pageextension 80139 "Service Tariff Numbers" extends "Service Tariff Numbers"
{
    layout
    {
        addlast(Control1130000)
        {
            field("ecDescription 2"; Rec."ecDescription 2")
            {
                ApplicationArea = All;
                Description = 'GAP_AFC_005';
            }
        }
    }
}
