namespace EuroCompany.BaseApp.Inventory.Intrastat;

using Microsoft.Inventory.Intrastat;

tableextension 80055 "Service Tariff Number" extends "Service Tariff Number"
{
    fields
    {
        field(50000; "ecDescription 2"; Text[100])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
            Description = 'GAP_AFC_005';
        }
    }
}
