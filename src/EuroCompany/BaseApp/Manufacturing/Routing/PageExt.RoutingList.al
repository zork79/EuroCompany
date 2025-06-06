namespace EuroCompany.BaseApp.Manufacturing.Routing;

using Microsoft.Manufacturing.Routing;

pageextension 80178 "Routing List" extends "Routing List"
{
    layout
    {
        addlast(Control1)
        {
            field("ecProduction Process Type"; Rec."ecProduction Process Type")
            {
                ApplicationArea = All;
                Description = 'CS_QMS_011';
            }
        }
    }
}
