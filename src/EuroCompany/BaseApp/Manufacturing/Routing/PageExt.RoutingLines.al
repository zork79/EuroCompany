namespace EuroCompany.BaseApp.Manufacturing.Routing;

using Microsoft.Manufacturing.Routing;

pageextension 80062 "Routing Lines" extends "Routing Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("ecPrevalent Operation"; Rec."ecPrevalent Operation")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_039';
                Visible = false;
            }
        }
    }
}
