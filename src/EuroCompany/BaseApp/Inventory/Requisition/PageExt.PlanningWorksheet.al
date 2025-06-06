namespace EuroCompany.BaseApp.Inventory.Requisition;

using Microsoft.Inventory.Requisition;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.Routing;
using Microsoft.Manufacturing.WorkCenter;

pageextension 80194 "Planning Worksheet" extends "Planning Worksheet"
{
    layout
    {
        modify("Routing No.")
        {
            Description = 'CS_PRO_039';
            Visible = true;
        }
        movebefore("Routing No."; APsSubcontrPhaseExist)

        movelast(Control1; "Routing No.")

        addlast(Control1)
        {
            field("ecWork Center No."; Rec."ecWork Center No.")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_039';
                Editable = false;
            }
            field(ecBand; Rec.ecBand)
            {
                ApplicationArea = All;
                Description = 'CS_PRO_039';
                DrillDown = false;
                Lookup = false;
            }
            field("ecItem Type"; Rec."ecItem Type")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_043';
                DrillDown = false;
                Lookup = false;
            }
            field("ecReordering Policy"; Rec."ecReordering Policy")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_039';
                Editable = false;
            }
        }
    }

}
