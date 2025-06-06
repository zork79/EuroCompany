namespace EuroCompany.BaseApp.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.Depreciation;

tableextension 80085 "FA Posting Group" extends "FA Posting Group"
{
    fields
    {
        field(50000; "ecDepreciation Table Code"; Code[10])
        {
            Caption = 'Depreciation Table Code';
            DataClassification = CustomerContent;
            TableRelation = "Depreciation Table Header";
        }
    }

}