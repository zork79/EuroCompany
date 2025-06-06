/* 
//inserito in TRADE
namespace EuroCompany.BaseApp.APsExtension;
using EuroCompany.BaseApp.Sales.AdvancedTrade;
using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Utilities;
using System.IO;

tableextension 80095 ApsTRDExcelBuffer extends "Excel Buffer"
{
    fields
    {
        field(50000; "Font Size"; integer)
        {
            Caption = 'Font Size';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_025';
            enabled = true;
            notBlank = false;
        }
        field(50001; "Background Color"; integer)
        {
            Caption = 'Background Color';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_025';
            enabled = true;
            notBlank = false;
        }
        field(50002; "Font Name"; Text[100])
        {
            Caption = 'Font Name';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_025';
            enabled = true;
            notBlank = false;
        }
        field(50003; "Font Color"; integer)
        {
            Caption = 'Font Color';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_025';
            enabled = true;
            notBlank = false;
        }
    }
}
//Inserito in TRADE
*/