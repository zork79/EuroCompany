/*
// Spostato in App Trade
namespace EuroCompany.BaseApp.APsExtension;
using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Inventory.Item;
using EuroCompany.BaseApp.Sales.AdvancedTrade;
using Microsoft.Inventory.Item.Catalog;

tableextension 80108 "APsTRD Promo Header" extends "APsTRD Promo Header"
{
    fields
    {
        field(50001; "ecCalculation Date Type"; option)
        {
            Caption = 'Calculation Date Type';
            DataClassification = CustomerContent;
            Description = 'GAP_447_TRADE';
            OptionCaption = 'Order Date,Requested Delivery Date';
            OptionMembers = "Order Date","Requested Delivery Date";
            enabled = true;
        }
    }
}
// spostato in App Trade
*/