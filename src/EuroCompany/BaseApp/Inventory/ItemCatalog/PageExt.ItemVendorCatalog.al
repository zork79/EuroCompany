namespace EuroCompany.BaseApp.Inventory.ItemCatalog;

using Microsoft.Inventory.Item.Catalog;

pageextension 80064 "Item Vendor Catalog" extends "Item Vendor Catalog"
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
