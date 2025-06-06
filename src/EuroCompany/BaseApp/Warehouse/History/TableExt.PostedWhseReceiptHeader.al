namespace EuroCompany.BaseApp.Warehouse.History;
using Microsoft.Warehouse.History;
using EuroCompany.BaseApp.Warehouse.Pallets;

tableextension 80102 "Posted Whse. Receipt Header" extends "Posted Whse. Receipt Header"
{
    fields
    {
        //#229
        field(50000; "ecAllow Adjmt. In Ship/Receipt"; Boolean)
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
        field(50005; "ecPallet Status Mgt."; Enum "ecPallet Status Mgt.")
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
    }
}