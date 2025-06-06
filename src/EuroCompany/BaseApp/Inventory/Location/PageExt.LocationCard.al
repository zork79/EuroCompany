namespace EuroCompany.BaseApp.Inventory.Location;
using Microsoft.Inventory.Location;

pageextension 80204 "Location Card" extends "Location Card"
{
    layout
    {
        addlast(content)
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom Attributes';

                group(PalletMgt)
                {
                    Caption = 'Pallet management';

                    field("ecPallets Bin Code"; Rec."ecPallets Bin Code")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
}