namespace EuroCompany.BaseApp.FixedAssets.Depreciation;
using Microsoft.FixedAssets.Depreciation;

pageextension 80185 "Depreciation Table List" extends "Depreciation Table List"
{
    layout
    {
        addlast(Control1)
        {
            field("ecUsed Asset"; Rec."ecUsed Asset")
            {
                ApplicationArea = All;
            }
        }
    }
}