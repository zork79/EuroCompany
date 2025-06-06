namespace EuroCompany.BaseApp.Manufacturing.Document;

using Microsoft.Manufacturing.Document;

pageextension 80161 "Prod. Order Comp. Line List" extends "Prod. Order Comp. Line List"
{
    layout
    {
        addafter("Prod. Order No.")
        {
            field("ecParent Item No."; Rec."ecParent Item No.")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_018';
                Editable = false;
            }
        }
        addlast(Control1)
        {
            field("ecProductive Status"; Rec."ecProductive Status")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_018';
                DrillDown = false;
                Editable = false;
                Lookup = false;
            }
        }
    }
}
