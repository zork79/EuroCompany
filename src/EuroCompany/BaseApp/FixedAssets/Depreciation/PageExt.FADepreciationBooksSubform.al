namespace EuroCompany.BaseApp.FixedAssets.Depreciation;
using Microsoft.FixedAssets.Depreciation;

pageextension 80188 "FA Depreciation Books Subform" extends "FA Depreciation Books Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("ecUsed Asset"; Rec."ecUsed Asset")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}