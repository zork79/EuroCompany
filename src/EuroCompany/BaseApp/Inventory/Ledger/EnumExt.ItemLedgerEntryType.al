namespace EuroCompany.BaseApp.Inventory.Ledger;
using Microsoft.Inventory.Ledger;

enumextension 50000 "Item Ledger Entry Type" extends "Item Ledger Entry Type"
{
    value(50000; Scrap)
    {
        Caption = 'Scrap';
    }
    value(50001; "Direct Sale")
    {
        Caption = 'Direct Sale';
    }
}