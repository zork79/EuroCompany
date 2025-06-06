namespace EuroCompany.BaseApp.Warehouse.History;
using Microsoft.Warehouse.History;
using EuroCompany.BaseApp.Warehouse.Pallets;

tableextension 80101 "Posted Whse. Shipment Header" extends "Posted Whse. Shipment Header"
{
    fields
    {
        //#229
        field(50002; "ecAllow Adjmt. In Ship/Receipt"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Adjmt. In Shipment/Receipt';

            trigger OnValidate()
            var
                PalletsMgt: Codeunit "ecPallets Management";
                Active: Boolean;
                ModificatiionNotAllowedErr: Label 'Field modification not allowed as the pallet management status must be different from "Completed" or "In progress".';
            begin
                if ((Rec."ecPallet Status Mgt." = Rec."ecPallet Status Mgt."::Completed) or (Rec."ecPallet Status Mgt." = Rec."ecPallet Status Mgt."::"In progress") and (Rec."ecAllow Adjmt. In Ship/Receipt" <> xRec."ecAllow Adjmt. In Ship/Receipt")) then
                    Error(ModificatiionNotAllowedErr);

                if (Rec."ecAllow Adjmt. In Ship/Receipt" <> xRec."ecAllow Adjmt. In Ship/Receipt") and (Rec."ecAllow Adjmt. In Ship/Receipt") and (Rec."ecPallet Status Mgt." = Rec."ecPallet Status Mgt."::"Not required") then begin
                    PalletsMgt.CheckAllowAdjmtInShipReceipt(Rec, Active);
                    if Active then begin
                        Rec."ecAllow Adjmt. In Ship/Receipt" := true;
                        Rec."ecPallet Status Mgt." := Rec."ecPallet Status Mgt."::Required;
                    end;
                end;

                if (Rec."ecAllow Adjmt. In Ship/Receipt" <> xRec."ecAllow Adjmt. In Ship/Receipt") and (not Rec."ecAllow Adjmt. In Ship/Receipt") then begin
                    PalletsMgt.CheckAllowAdjmtInShipReceipt(Rec, Active);
                    if Active then begin
                        Rec."ecAllow Adjmt. In Ship/Receipt" := true;
                        Rec."ecPallet Status Mgt." := Rec."ecPallet Status Mgt."::Required;
                    end;
                end;
            end;
        }
        field(50003; "ecPallet Status Mgt."; Enum "ecPallet Status Mgt.")
        {
            DataClassification = CustomerContent;
            Caption = 'Pallet Status Mgt.';
            Editable = false;
        }
        field(50010; "ecAlready Checked"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Already Checked';
            Editable = false;
        }
        //#229
        modify("AltAWPManual Parcels")
        {
            Caption = 'Manual logistic units';
            Description = 'CS_LOG_001';
        }
        modify("AltAWPParcel Units")
        {
            Caption = 'No. of logistic units';
            Description = 'CS_LOG_001';
        }

        field(50000; "ecNo. Parcels"; Integer)
        {
            Caption = 'No. parcels';
            DataClassification = CustomerContent;
            Description = 'CS_LOG_001';

            trigger OnValidate()
            begin
                if (CurrFieldNo = FieldNo("ecNo. Parcels")) and (Rec."ecNo. Parcels" <> xRec."ecNo. Parcels") then begin
                    "ecManual Parcels" := true;
                end;
            end;
        }
        field(50001; "ecManual Parcels"; Boolean)
        {
            Caption = 'Manual parcels';
            DataClassification = CustomerContent;
            Description = 'CS_LOG_001';
            Editable = false;
        }
        field(50008; "ecNo. Theoretical Pallets"; Decimal)
        {
            Caption = 'No. of theoretical pallets';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 1;
            Description = 'CS_LOG_001';
            Editable = false;
        }
    }
}
