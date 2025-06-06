namespace EuroCompany.BaseApp.Warehouse.Pallets;
using Microsoft.Foundation.AuditCodes;

table 50039 "ecGeneral Pallet Setup"
{
    Caption = 'General Pallet Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Sequence No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sequence No.';
            AutoIncrement = true;
            Editable = false;
        }
        field(2; Document; Enum "ecPallets Document Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Document';
        }
        field(3; "Source Document Type"; Enum "ecPallet Source Doc. Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Source Document Type';

            trigger OnValidate()
            begin
                PalletsMgt.GeneralChecksGeneralSetup(Rec);
            end;
        }
        field(4; "BC Reason Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'BC Reason Code';
            TableRelation = "Reason Code";
        }
        field(5; "Allow Adjmt. In Ship/Receipt"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Adjmt. In Shipment/Receipt';
        }
        field(6; "Pallet Grouping Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Pallet Grouping Code';
            TableRelation = "ecPallet Grouping Code";
        }
        field(7; "Pallet Movement Reason"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Pallet Movement Reason';
        }
    }

    keys
    {
        key(Key1; "Sequence No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Rec.Validate("Sequence No.", 0);
    end;

    var
        PalletsMgt: Codeunit "ecPallets Management";
}