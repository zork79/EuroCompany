namespace EuroCompany.BaseApp.FixedAssets.Depreciation;
using Microsoft.FixedAssets.Depreciation;

tableextension 80092 "Depreciation Table Header" extends "Depreciation Table Header"
{
    fields
    {
        field(50000; "ecUsed Asset"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Used Asset';
        }
    }
}