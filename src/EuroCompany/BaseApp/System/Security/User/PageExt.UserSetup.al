namespace EuroCompany.BaseApp.System.Security.User;

using System.Security.User;

pageextension 80146 "User Setup" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("ecEnable Prod. Order Sched."; Rec."ecEnable Prod. Order Sched.")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_018';
            }
        }
    }
}
