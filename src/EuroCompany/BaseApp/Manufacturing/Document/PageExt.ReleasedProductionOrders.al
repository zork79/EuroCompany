namespace EuroCompany.BaseApp.Manufacturing.Document;

using Microsoft.Manufacturing.Document;

pageextension 80181 "Released Production Orders" extends "Released Production Orders"
{
    layout
    {
        addafter("Routing No.")
        {
            field("ecProduction Process Type"; Rec."ecProduction Process Type")
            {
                ApplicationArea = All;
                Description = 'CS_QMS_011';
                DrillDown = false;
                Editable = false;
            }
        }
    }
}
