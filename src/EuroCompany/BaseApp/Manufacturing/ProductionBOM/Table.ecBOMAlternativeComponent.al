namespace EuroCompany.BaseApp.Manufacturing.ProductionBOM;

using Microsoft.Inventory.Item;
using Microsoft.Manufacturing.ProductionBOM;

table 50004 "ecBOM Alternative Component"
{
    Caption = 'BOM Alternative Component';
    DataClassification = CustomerContent;
    Description = 'GAP_PRO_003';

    fields
    {
        field(10; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.';
        }
        field(11; "Prod. BOM Version Code"; Code[20])
        {
            Caption = 'Version Code';
        }
        field(12; "Prod. BOM Line No."; Integer)
        {
            Caption = 'Prod. BOM Line No.';
        }
        field(50; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No." where(Type = filter(Inventory | "Non-Inventory"));

            trigger OnValidate()
            var
                lItem: Record Item;
                lProductionBOMLine: Record "Production BOM Line";
            begin
                if (Rec."Item No." <> xRec."Item No.") then begin
                    Rec."Variant Code" := '';
                    Rec."Quantity per" := 0;
                    Rec."Unit of Measure Code" := '';
                    if lItem.Get(Rec."Item No.") and lProductionBOMLine.Get("Production BOM No.", "Prod. BOM Version Code", "Prod. BOM Line No.") then begin
                        Rec."Quantity per" := lProductionBOMLine."Quantity per";
                        Rec."Unit of Measure Code" := lItem."Base Unit of Measure";
                    end;
                end;

                CalcFields("Item Description");
            end;
        }
        field(51; "Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(80; "Quantity per"; Decimal)
        {
            Caption = 'Quantity per';
            DecimalPlaces = 0 : 5;
        }
        field(90; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(100; "Scrap %"; Decimal)
        {
            Caption = 'Scrap %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
        }
    }
    keys
    {
        key(PK; "Production BOM No.", "Prod. BOM Version Code", "Prod. BOM Line No.", "Item No.", "Variant Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        TestRecord();
    end;

    trigger OnModify()
    begin
        TestRecord();
    end;

    local procedure TestRecord()
    begin
        Rec.TestField("Production BOM No.");
        Rec.TestField("Prod. BOM Line No.");
        Rec.TestField("Item No.");
        Rec.TestField("Quantity per");
        Rec.TestField("Unit of Measure Code");
    end;
}
