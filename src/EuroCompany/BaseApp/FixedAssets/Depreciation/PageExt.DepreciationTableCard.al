namespace EuroCompany.BaseApp.FixedAssets.Depreciation;
using Microsoft.FixedAssets.Depreciation;

pageextension 80186 "Depreciation Table Card" extends "Depreciation Table Card"
{
    layout
    {
        addlast(content)
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom Attributes';

                field("ecUsed Asset"; Rec."ecUsed Asset")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}