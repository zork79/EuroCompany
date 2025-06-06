namespace EuroCompany.BaseApp.Inventory.ItemCatalog;

using Microsoft.Inventory.Item.Catalog;

pageextension 80066 "Vendor Item Catalog" extends "Vendor Item Catalog"
{
    layout
    {
        addlast(Control1)
        {
            field("ecPackaging Type"; Rec."ecPackaging Type")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_018';
            }
        }
    }
}
