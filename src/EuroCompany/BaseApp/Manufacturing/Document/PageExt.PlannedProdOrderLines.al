namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Manufacturing.Document;

pageextension 80050 "Planned Prod. Order Lines" extends "Planned Prod. Order Lines"
{
    layout
    {
        modify("Routing No.")
        {
            Editable = false;
        }

        addafter(Control1)
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
