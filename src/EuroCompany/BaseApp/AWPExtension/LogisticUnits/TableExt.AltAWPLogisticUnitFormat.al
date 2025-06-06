namespace EuroCompany.BaseApp.AWPExtension.LogisticUnits;
using EuroCompany.BaseApp.Warehouse.Pallets;

tableextension 80098 "AltAWPLogistic Unit Format" extends "AltAWPLogistic Unit Format"
{
    fields
    {
        field(50000; "ecPallet/Box Grouping Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Pallet/Box Grouping Code';
            TableRelation = "ecPallet Grouping Code";
        }
        field(50001; "ecCHEP Gtin"; Code[14])
        {
            DataClassification = CustomerContent;
            Caption = 'CHEP Gtin';
        }
    }
}