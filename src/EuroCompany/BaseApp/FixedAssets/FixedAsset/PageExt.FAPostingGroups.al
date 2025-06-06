namespace EuroCompany.BaseApp.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.FixedAsset;

pageextension 80174 "FA Posting Groups" extends "FA Posting Groups"
{
    layout
    {
        addlast(Control1)
        {
            field("ecDepreciation Table Code"; Rec."ecDepreciation Table Code")
            {
                ApplicationArea = All;
            }
        }
    }
}