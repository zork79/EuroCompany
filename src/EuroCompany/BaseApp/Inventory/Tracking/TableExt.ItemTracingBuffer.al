namespace EuroCompany.BaseApp.Inventory.Tracking;
using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;

tableextension 80048 "Item Tracing Buffer" extends "Item Tracing Buffer"
{
    fields
    {
        field(50000; "ecItem Type"; Enum "ecItem Type")
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50001; "ecItem Species"; Code[20])
        {
            Caption = 'Item Species';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50002; "ecItem Species Type"; Code[20])
        {
            Caption = 'Item Species Type';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50003; "ecItem Commercial Line"; Code[20])
        {
            Caption = 'Item Commercial Line';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50004; "ecItem Brand"; Code[20])
        {
            Caption = 'Item Brand';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50005; "ecItem Brand Type"; Code[20])
        {
            Caption = 'Item Brand Type';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50006; "ecLot Origin Country Code"; Code[10])
        {
            Caption = 'Lot Origin Country Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50007; "ecItem Unit Of Measure"; Code[10])
        {
            Caption = 'Item Unit Of Measure';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}