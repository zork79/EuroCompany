namespace EuroCompany.BaseApp.Manufacturing.Routing;

using Microsoft.Manufacturing.Routing;

pageextension 80179 Routing extends Routing
{
    layout
    {
        addlast(content)
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom Attributes';

                field("ecProduction Process Type"; Rec."ecProduction Process Type")
                {
                    ApplicationArea = All;
                    Description = 'CS_QMS_011';
                }
            }
        }
    }
}
