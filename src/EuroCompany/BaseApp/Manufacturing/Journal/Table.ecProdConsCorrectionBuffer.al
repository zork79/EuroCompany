namespace EuroCompany.BaseApp.Manufacturing.Journal;

using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.Manufacturing.Document;
using Microsoft.Warehouse.Structure;

table 90000 "ecProd.Cons. Correction Buffer"
{
    Caption = 'Prod. Cons. Correction Buffer';
    DataCaptionFields = "Key";
    DataClassification = CustomerContent;
    Description = 'CS_PRO_050';
    TableType = Temporary;

    fields
    {
        field(1; "Key"; Code[10])
        {
            Caption = 'Key';
            Editable = false;
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item no.';
            TableRelation = Item."No.";

            trigger OnValidate()
            var
                lItem: Record Item;
            begin
                if ("Item No." <> xRec."Item No.") then begin
                    "Variant Code" := '';
                    "Bin Code" := '';
                    "Lot No." := '';
                    "Serial No." := '';
                    "Pallet No." := '';
                    "Box No." := '';
                    Description := '';
                    "Description 2" := '';
                    "Unit of Measure Code" := '';
                    "Qty. in Inventory" := 0;
                    "Qty. Effective" := 0;
                    "Qty. Delta" := 0;
                end;

                if ("Item No." = '') then exit;

                lItem.Get("Item No.");
                lItem.TestField(Blocked, false);

                Description := lItem.Description;
                "Description 2" := lItem."Description 2";
                "Unit of Measure Code" := lItem."Base Unit of Measure";
            end;
        }
        field(15; "Variant Code"; Code[10])
        {
            Caption = 'Variant code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));

            trigger OnValidate()
            begin
                if ("Variant Code" <> xRec."Variant Code") then begin
                    "Bin Code" := '';
                    "Lot No." := '';
                    "Serial No." := '';
                    "Pallet No." := '';
                    "Box No." := '';
                    Description := '';
                    "Description 2" := '';
                    "Unit of Measure Code" := '';
                    "Qty. in Inventory" := 0;
                    "Qty. Effective" := 0;
                    "Qty. Delta" := 0;
                end;
            end;
        }
        field(20; Description; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Description 2"; Text[50])
        {
            CalcFormula = lookup(Item."Description 2" where("No." = field("Item No.")));
            Caption = 'Description 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of measure code';
            Editable = false;
            TableRelation = "Unit of Measure".Code;
        }
        field(50; "Location Code"; Code[10])
        {
            Caption = 'Location code';
            TableRelation = Location.Code;

            trigger OnValidate()
            begin
                if (Rec."Location Code" <> xRec."Location Code") then begin
                    Validate("Pallet No.", '');
                    Validate("Box No.", '');

                    Validate("Bin Code", '');
                end;
            end;
        }
        field(55; "Bin Code"; Code[20])
        {
            Caption = 'Bin code';
            TableRelation = Bin.Code where("Location Code" = field("Location Code"));

            trigger OnValidate()
            begin
                if (Rec."Bin Code" <> xRec."Bin Code") then begin
                    Validate("Pallet No.", '');
                    Validate("Box No.", '');
                end;
            end;
        }
        field(80; "Pallet No."; Code[50])
        {
            Caption = 'Pallet no.';

            trigger OnLookup()
            var
                lAWPLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
                lPalletNo: Code[50];
                lBoxNo: Code[50];
                lLotNo: Code[50];
                lSerialNo: Code[50];
            begin
                if ("Item No." = '') then exit;
                if lAWPLogisticUnitsMgt.LookupPallet("Item No.", "Variant Code", "Location Code", "Bin Code", lPalletNo, lBoxNo, lLotNo, lSerialNo) then begin
                    "Pallet No." := lPalletNo;
                    "Box No." := lBoxNo;
                    "Lot No." := lLotNo;
                    "Serial No." := lSerialNo;
                    Validate("Pallet No.");
                    Validate("Box No.");
                    Validate("Lot No.");
                    Validate("Serial No.");
                end;
            end;

            trigger OnValidate()
            var
                lProductionFunctions: Codeunit "ecProduction Functions";
            begin
                if ("Pallet No." = '') and (Rec."Pallet No." <> xRec."Pallet No.") then begin
                    "Lot No." := '';
                    "Serial No." := '';
                    "Box No." := '';
                    "Qty. in Inventory" := 0;
                    "Qty. Effective" := 0;
                    "Qty. Delta" := 0;
                end else begin
                    if ("Pallet No." <> '') then begin
                        Validate("Qty. in Inventory", lProductionFunctions.GetPalletBoxQuantity("Item No.", "Variant Code", "Location Code", "Bin Code",
                                                                                                "Pallet No.", "Box No.", "Lot No.", "Serial No."));
                    end;
                end;
            end;
        }
        field(85; "Box No."; Code[50])
        {
            Caption = 'Box no.';

            trigger OnLookup()
            var
                lAWPLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
                lPalletNo: Code[50];
                lBoxNo: Code[50];
                lLotNo: Code[50];
                lSerialNo: Code[50];
            begin
                if ("Item No." = '') then exit;
                if lAWPLogisticUnitsMgt.LookupBox("Item No.", "Variant Code", "Location Code", "Bin Code", lPalletNo, lBoxNo, lLotNo, lSerialNo) then begin
                    "Pallet No." := lPalletNo;
                    "Box No." := lBoxNo;
                    "Lot No." := lLotNo;
                    "Serial No." := lSerialNo;
                    Validate("Pallet No.");
                    Validate("Box No.");
                    Validate("Lot No.");
                    Validate("Serial No.");
                end;
            end;

            trigger OnValidate()
            var
                lProductionFunctions: Codeunit "ecProduction Functions";
            begin
                if ("Box No." = '') and (Rec."Box No." <> xRec."Box No.") then begin
                    "Lot No." := '';
                    "Serial No." := '';
                    "Pallet No." := '';
                    "Qty. in Inventory" := 0;
                    "Qty. Effective" := 0;
                    "Qty. Delta" := 0;
                end else begin
                    if ("Box No." <> '') then begin
                        Validate("Qty. in Inventory", lProductionFunctions.GetPalletBoxQuantity("Item No.", "Variant Code", "Location Code", "Bin Code",
                                                                                                "Pallet No.", "Box No.", "Lot No.", "Serial No."));
                        Validate("Qty. Effective", 0);
                    end;
                end;
            end;
        }
        field(100; "Lot No."; Code[50])
        {
            Caption = 'Lot no.';
            Editable = false;
        }
        field(105; "Serial No."; Code[50])
        {
            Caption = 'Serial no.';
            Editable = false;
        }
        field(120; "Qty. in Inventory"; Decimal)
        {
            Caption = 'Qty. in inventory';
            Editable = false;
        }
        field(125; "Qty. Effective"; Decimal)
        {
            Caption = 'Qty. effective';

            trigger OnValidate()
            var
                lError001: Label '%1 cannot be greater than %2!';
            begin
                "Qty. Delta" := "Qty. Effective" - "Qty. in Inventory";
                if (Rec."Qty. Delta" > 0) then Error(lError001, FieldCaption("Qty. Effective"), FieldCaption("Qty. in Inventory"));
                "Recalculation Required" := true;
            end;
        }
        field(130; "Qty. Delta"; Decimal)
        {
            Caption = 'Qty. delta';
            Editable = false;
        }
        field(500; "Prod. Order Status"; Enum "Production Order Status")
        {
            Caption = 'Prod. order status';
            Editable = false;
        }
        field(505; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. order no.';
            Editable = false;
        }
        field(510; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. order line no.';
            Editable = false;
        }
        field(530; "Prod. Order Comp. Line No."; Integer)
        {
            Caption = 'Prod. order comp. line no.';
            Editable = false;
        }
        field(800; "Qty. Consumed"; Decimal)
        {
            Caption = 'Qty. consumed';
            Editable = false;
        }
        field(805; "Qty. Adjusted"; Decimal)
        {
            Caption = 'Qty. adjusted';
            Editable = false;
        }
        field(1000; Selected; Boolean)
        {
            Caption = 'Selected';
            Editable = false;

            trigger OnValidate()
            begin
                if xRec.Selected and not Rec.Selected then begin
                    "Qty. Adjusted" := 0;
                    "Qty. Delta" := 0;
                end;
            end;
        }
        field(1100; "Recalculation Required"; Boolean)
        {
            Caption = 'Recalc. required';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Key", "Prod. Order Status", "Prod. Order No.", "Prod. Order Line No.", "Prod. Order Comp. Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Qty. Consumed") { }
    }
}
