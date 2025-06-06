namespace EuroCompany.BaseApp.Manufacturing.Capacity;

using Microsoft.Manufacturing.Capacity;

pageextension 80184 "Capacity Ledger Entries" extends "Capacity Ledger Entries"
{
    layout
    {
        modify("Run Time")
        {
            Visible = true;
        }
        modify("Setup Time")
        {
            Visible = true;
        }
    }
}
