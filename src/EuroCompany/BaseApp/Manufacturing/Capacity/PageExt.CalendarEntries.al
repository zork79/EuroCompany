namespace EuroCompany.BaseApp.Manufacturing.Capacity;

using Microsoft.Manufacturing.Capacity;

pageextension 80045 "Calendar Entries" extends "Calendar Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("ecApplied Calendar Code"; Rec."ecApplied Calendar Code")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_018';
            }
        }
    }
}
