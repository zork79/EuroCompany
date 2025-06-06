namespace EuroCompany.BaseApp.Manufacturing.MachineCenter;

using Microsoft.Manufacturing.MachineCenter;

pageextension 80228 "Machine Center Card" extends "Machine Center Card"
{

    layout
    {
        addlast(content)
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom Attributes';

                field("ecRemove Log. Units on Pick"; Rec."ecRemove Log. Units on Pick")
                {
                    ApplicationArea = Manufacturing;
                }
            }
        }
    }
}
