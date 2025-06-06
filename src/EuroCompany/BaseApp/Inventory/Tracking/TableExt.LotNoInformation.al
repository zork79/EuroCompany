namespace EuroCompany.BaseApp.Inventory.Tracking;
using EuroCompany.BaseApp.Inventory.Item;



using EuroCompany.BaseApp.Inventory.Tracking;
using Microsoft.Foundation.Address;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Catalog;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Vendor;

tableextension 80006 "Lot No. Information" extends "Lot No. Information"
{
    fields
    {

        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                //CS_PRO_043-s
                InitItemValues();
                //CS_PRO_043-e
            end;
        }
        field(50000; "ecInventory Posting Group"; Code[20])
        {
            CalcFormula = lookup(Item."Inventory Posting Group" where("No." = field("Item No.")));
            Caption = 'Inventory Posting Group';
            Description = 'CS_PRO_018';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "ecItem Type"; Enum "ecItem Type")
        {
            CalcFormula = lookup(Item."ecItem Type" where("No." = field("Item No.")));
            Caption = 'Item type';
            Description = 'CS_PRO_018';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50300; "ecNo. Of Item Ledg. Entries"; Integer)
        {
            CalcFormula = count("Item Ledger Entry" where("Item No." = field("Item No."),
                                                          "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));
            Caption = 'No. of movments';
            Description = 'CS_PRO_008';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50320; "ecItem Category Code"; Code[20])
        {
            CalcFormula = lookup(Item."Item Category Code" where("No." = field("Item No.")));
            Caption = 'Item category code';
            Description = 'CS_PRO_011';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50321; "ecProduct Group Code"; Code[20])
        {
            CalcFormula = lookup(Item."AltAWPProduct Group Code" where("No." = field("Item No.")));
            Caption = 'Product group code';
            Description = 'CS_PRO_011';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50325; "ecLot Creation Process"; Enum "ecLot Creation Process")
        {
            Caption = 'Lot creation process';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_011';
            Editable = false;
        }
        field(50330; ecVariety; Code[20])
        {
            Caption = 'Variety';
            DataClassification = CustomerContent;
            Description = 'GAP_VEN_002';
            TableRelation = ecVariety;
        }
        field(50335; ecGauge; Code[20])
        {
            Caption = 'Gauge';
            DataClassification = CustomerContent;
            Description = 'GAP_VEN_002';
            TableRelation = ecGauge;
        }
        field(50357; "ecLot No. Information Status"; Enum "ecLot No. Info Status")
        {
            Caption = 'Lot no. information status';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_008';
            Editable = false;

            trigger OnValidate()
            var
                lTrackingFunctions: Codeunit "ecTracking Functions";
            begin
                //CS_PRO_008-s
                if (Rec."ecLot No. Information Status" = Rec."ecLot No. Information Status"::Released) then begin
                    lTrackingFunctions.InheritParentLotNoInfoByReleasedChild(Rec);
                end;
                //CS_PRO_008-e
            end;
        }
        field(50358; "ecVendor Lot No."; Code[50])
        {
            Caption = 'Vendor lot no.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_008';
        }
        field(50360; "ecVendor No."; Code[20])
        {
            Caption = 'Vendor no.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_008';
            TableRelation = Vendor."No.";
        }
        field(50363; "ecOrigin Country Code"; Code[10])
        {
            Caption = 'Origin country code';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_008';
            TableRelation = "Country/Region".Code;
        }
        field(50365; "ecManufacturer No."; Code[10])
        {
            Caption = 'Manufacturer no.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_008';
            TableRelation = Manufacturer.Code;
        }
        field(50368; "ecExpiration Date"; Date)
        {
            Caption = 'Expiration date';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_008';
        }
        field(50375; "ecCrop Vendor Year"; Integer)
        {
            Caption = 'Crop vendor year';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_043';
        }
    }

    local procedure InitItemValues()
    var
        lItem: Record Item;
        lItemTrackingCode: Record "Item Tracking Code";
    begin
        //CS_PRO_008-s
        if lItem.Get(Rec."Item No.") then begin
            Description := lItem.Description;

            Rec.Validate("ecOrigin Country Code", lItem."Country/Region of Origin Code");
            Rec.Validate(ecVariety, lItem.ecVariety);
            Rec.Validate("ecManufacturer No.", lItem."Manufacturer Code");
            Rec.Validate(ecGauge, lItem.ecGauge);
            Rec."ecCrop Vendor Year" := 9999;

            if lItemTrackingCode.Get(lItem."Item Tracking Code") and (Format(lItem."Expiration Calculation") <> '') then begin
                Rec.Validate("ecExpiration Date", CalcDate(lItem."Expiration Calculation", Today));
            end;
        end;
        //CS_PRO_008-e
    end;
}
