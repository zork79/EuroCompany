namespace EuroCompany.BaseApp.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.FixedAsset;

pageextension 80175 "FA Posting Group Card" extends "FA Posting Group Card"
{
    layout
    {
        addafter(Allocation)
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom attributes';
                field("ecDepreciation Table Code"; Rec."ecDepreciation Table Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}