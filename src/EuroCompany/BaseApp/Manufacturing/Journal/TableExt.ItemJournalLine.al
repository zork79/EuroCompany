namespace EuroCompany.BaseApp.Manufacturing.Journal;

using Microsoft.Inventory.Journal;
using EuroCompany.BaseApp.Warehouse.Pallets;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Tracking;

tableextension 80091 "Item Journal Line" extends "Item Journal Line"
{
    fields
    {
        modify("AltAWPExpiration Date")
        {
            trigger OnAfterValidate()
            var
                lLotNoInformation: Record "Lot No. Information";
            begin
                if lLotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."AltAWPLot No.") then begin
                    if (lLotNoInformation."ecExpiration Date" <> Rec."AltAWPExpiration Date") then begin
                        lLotNoInformation.Validate("ecExpiration Date", Rec."AltAWPExpiration Date");
                        lLotNoInformation.Modify(true);
                    end;
                end;
            end;
        }
        //#229
        field(50000; "ecCausal Pallet Entry"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Causal Pallet Entry';
            Editable = false;
        }
        field(50001; "ecCHEP Gtin"; Code[14])
        {
            DataClassification = CustomerContent;
            Caption = 'CHEP Gtin';
            Editable = false;
        }
        field(50002; "ecMember's CPR Code"; Code[10])
        {
            Caption = 'Member s CPR Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."ecMember's CPR Code" where("No." = field("Source No.")));
            Editable = false;
        }
        field(50003; "ecSource Doc. No."; Code[20])
        {
            Caption = 'Source Doc. No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50004; "ecSource Description"; Text[100])
        {
            Caption = 'Source Description';
            DataClassification = CustomerContent;
        }
        //#229
    }

    trigger OnDelete()
    var
        ecPalletsMgt: Codeunit "ecPallets Management";
    begin
        //#229Status
        ecPalletsMgt.SetRequiredStatusInWhseDoc(Rec);
        //#229Status
    end;
}
