namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Manufacturing.Document;

pageextension 80049 "Simulated Prod. Order Lines" extends "Simulated Prod. Order Lines"
{
    layout
    {
        modify("Routing No.")
        {
            Editable = false;
        }

        addlast(Control1)
        {
            field("ecProduction Process Type"; Rec."ecProduction Process Type")
            {
                ApplicationArea = All;
                Editable = false;
                Description = 'CS_QMS_011';
                DrillDown = false;
                Visible = false;
            }
        }
    }
}
