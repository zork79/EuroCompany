/*
// spostato in App Trade
namespace EuroCompany.BaseApp.APsExtension;
using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Inventory.Item;
using EuroCompany.BaseApp.Sales.AdvancedTrade;
using Microsoft.Inventory.Item.Catalog;

pageextension 80213 "APsTRD Promotion Card " extends "APsTRD Promotion Card"
{
    layout
    {
        addafter("Ending Date")
        {
            field("Calculation Date Type"; rec."ecCalculation Date Type")
            {
                ApplicationArea = All;
                Description = 'GAP_447_TRADE';
                Editable = true;
                Enabled = true;
            }
        }
    }
}
// spostato in App Trade
*/