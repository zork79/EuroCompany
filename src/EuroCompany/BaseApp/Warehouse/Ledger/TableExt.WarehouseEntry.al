namespace EuroCompany.BaseApp.Warehouse.Ledger;

using Microsoft.Warehouse.Ledger;

tableextension 80056 "Warehouse Entry" extends "Warehouse Entry"
{
    fields
    {
        field(50000; "ecNo. Of Parcels"; Integer)
        {
            Caption = 'No. Of Parcels';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            Editable = false;
        }
        field(50002; "ecUnit Weight"; Decimal)
        {
            Caption = 'Unit Weight';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            Editable = false;
        }
        field(50005; "ecTotal Weight"; Decimal)
        {
            Caption = 'Total Weight';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            Editable = false;
        }
        field(50010; ecSelected; Boolean)
        {
            Caption = 'Selected';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_004';
        }
        field(50011; "ecTransaction ID"; Integer)
        {
            Caption = 'Transaction ID';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_004';
            Editable = false;
        }
        //#229
        field(50012; "ecCHEP Gtin"; Code[14])
        {
            Caption = 'CHEP Gtin';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50013; "ecMember's CPR Code"; Code[10])
        {
            Caption = 'Member s CPR Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50014; "ecPallet Movement Reason Code"; Code[20])
        {
            Caption = 'Pallet Movement Reason Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50015; "ecPallet Grouping Code"; Code[20])
        {
            Caption = 'Pallet Grouping Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50016; "ecBox Movement Reason Code"; Code[20])
        {
            Caption = 'Box Movement Reason Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50017; "ecBox Grouping Code"; Code[20])
        {
            Caption = 'Box Grouping Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //#229
    }

    keys
    {
        key(ecKey1; "Item No.", "Bin Code", "Location Code", "Variant Code", "Entry Type") { }
    }
}
