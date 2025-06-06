namespace EuroCompany.BaseApp.Warehouse.Ledger;
using Microsoft.Warehouse.Ledger;

pageextension 80205 "Warehouse Entries" extends "Warehouse Entries"
{
    layout
    {
        addlast(Control1)
        {
            //#229
            field("ecCHEP Gtin"; Rec."ecCHEP Gtin")
            {
                ApplicationArea = All;
            }
            field("ecMember's CPR Code"; Rec."ecMember's CPR Code")
            {
                ApplicationArea = All;
            }
            field("ecPallet Movement Reason Code"; Rec."ecPallet Movement Reason Code")
            {
                ApplicationArea = All;
            }
            field("ecPallet Grouping Code"; Rec."ecPallet Grouping Code")
            {
                ApplicationArea = All;
            }
            field("ecBox Movement Reason Code"; Rec."ecBox Movement Reason Code")
            {
                ApplicationArea = All;
            }
            field("ecBox Grouping Code"; Rec."ecBox Grouping Code")
            {
                ApplicationArea = All;
            }
            //#229
        }
    }
}