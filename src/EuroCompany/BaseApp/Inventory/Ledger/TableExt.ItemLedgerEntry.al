namespace EuroCompany.BaseApp.Inventory.Ledger;

using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Customer;
using Microsoft.Manufacturing.Document;
using Microsoft.Inventory.Item;

tableextension 80020 "Item Ledger Entry" extends "Item Ledger Entry"
{
    fields
    {
        //#229
        field(50000; "ecCausal Pallet Entry"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Causal Pallet Entry';
            Editable = false;
        }
        field(50001; "ecUnit Logistcs Code"; Code[20])
        {
            Caption = 'Unit Logistics Code';
            FieldClass = FlowField;
            CalcFormula = lookup("AltAWPLogistic Unit Format".Code where("Inventory Register Item No." = field("Item No.")));
            Editable = false;
        }
        field(50002; "ecPallet Grouping Code"; Code[20])
        {
            Caption = 'Pallet Grouping Code';
            FieldClass = FlowField;
            CalcFormula = lookup("AltAWPLogistic Unit Format"."ecPallet/Box Grouping Code" where("Inventory Register Item No." = field("Item No.")));
            Editable = false;
        }
        field(50003; "ecCHEP Gtin"; Code[14])
        {
            Caption = 'CHEP Gtin';
            FieldClass = FlowField;
            CalcFormula = lookup("AltAWPLogistic Unit Format"."ecCHEP Gtin" where(Code = field("Item No.")));
            Editable = false;
        }
        field(50004; "ecMember's CPR Code"; Code[10])
        {
            Caption = 'Member s CPR Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."ecMember's CPR Code" where("No." = field("Source No.")));
            Editable = false;
        }
        field(50005; "ecSource Doc. No."; Code[20])
        {
            Caption = 'Source Doc. No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50006; "ecSource Description"; Text[100])
        {
            Caption = 'Source Description';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50007; "ecEnable Inventory Register"; Boolean)
        {
            Caption = 'Enable Inventory Register';
            FieldClass = FlowField;
            CalcFormula = exist("AltAWPLogistic Unit Format" where("Inventory Register Item No." = field("Item No."), "Enable Inventory Register" = const(true)));
            Editable = false;
        }
        field(50008; "ecExported For CPR"; Boolean)
        {
            Caption = 'Exported For CPR';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //#229
        field(50009; "ecPlanning Level Code"; Integer)
        {
            Caption = 'Planning level code';
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Line"."Planning Level Code" where(Status = const(Released), "Prod. Order No." = field("Order No."), "Line No." = field("Order Line No.")));
        }
        field(50010; "ecMass Balance Mgt. BIO"; Boolean)
        {
            Caption = 'Mass. Balance Mgt. BIO';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."ecItem Trk. Summary Mgt." where("No." = field("Item No.")));
        }
    }
    keys
    {
        key(ecKey1; "Item No.", "Variant Code", "Order No.", "Order Type", "Entry Type", "Posting Date")
        {
        }
    }

    trigger OnAfterInsert()
    var
        lLotNoInformation: Record "Lot No. Information";
    begin
        //CS_PRO_008-s
        Clear(lLotNoInformation);
        if (Rec."Lot No." <> '') and lLotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") then begin
            if (Rec."Expiration Date" <> 0D) then lLotNoInformation.Validate("ecExpiration Date", Rec."Expiration Date");
            lLotNoInformation.Modify(true);
        end;
        //CS_PRO_008-e
    end;


}
