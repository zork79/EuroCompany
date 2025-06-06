namespace EuroCompany.BaseApp.APsExtension;
using EuroCompany.BaseApp.Inventory;
using EuroCompany.BaseApp.Inventory.Barcode;
using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Inventory.Item;

pageextension 80212 "APsTRD Customer Contract Card" extends "APsTRD Customer Contract Card"
{
    layout
    {
        addafter(Note)
        {
            field(salesManagerCode; rec."ecSales Manager Code")
            {
                ApplicationArea = All;
                Description = 'GAP_443_TRADE';
            }
            field(salesManagerName; rec."ecSales Manager Name")
            {
                ApplicationArea = All;
                Description = 'GAP_443_TRADE';
                editable = false;
            }
        }
    }
}
