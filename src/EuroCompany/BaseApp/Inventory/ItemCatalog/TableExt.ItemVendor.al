namespace EuroCompany.BaseApp.Inventory.ItemCatalog;

using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Inventory.Item.Catalog;

tableextension 80016 "Item Vendor" extends "Item Vendor"
{
    fields
    {
        field(50000; "ecPackaging Type"; Code[20])
        {
            Caption = 'Packaging Type';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_018';
            TableRelation = "ecPackaging Type";
        }
    }
}
