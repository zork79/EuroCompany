namespace EuroCompany.BaseApp.Inventory.Item;

table 50047 "ecKit/Prod. Exhibitor Item BOM"
{
    Caption = 'Kit/Prod. Exhibitor Item BOM';
    DataClassification = CustomerContent;
    Description = 'CS_PRO_009';
    DrillDownPageId = "ecKit/Prod. Exhibitor Item BOM";
    LookupPageId = "ecKit/Prod. Exhibitor Item BOM";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(100; "Source Order No."; Code[20])
        {
            Caption = 'Source Order No.';
        }
        field(110; "Source Order Line No."; Integer)
        {
            Caption = 'Source Order Line No.';
        }
        field(150; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(155; "Variant Code"; Code[10])
        {
            Caption = 'Variant code';
        }
        field(180; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(200; "Unit Of Measure Code"; Code[10])
        {
            Caption = 'Unit Of Measure';
        }
        field(300; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(320; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
        }
        field(400; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(450; "Composed Discount"; Text[50])
        {
            Caption = 'Composed Discount';
        }
        field(500; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
        }
        field(550; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
        }
        field(600; "Consumer UM"; Code[20])
        {
            Caption = 'Consumer UM';
        }
        field(605; "Quantity (Consumer UM)"; Decimal)
        {
            Caption = 'Quantity (Consumer UM)';
            DecimalPlaces = 0 : 5;
        }
        field(610; "Unit Price (Consumer UM)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price (Consumer UM)';
        }
        field(820; "Prod. BOM Quantity"; Decimal)
        {
            Caption = 'Prod. BOM Quantity';
        }
        field(5000; "Error Text"; Text[500])
        {
            Caption = 'Error text';
        }
    }
    keys
    {
        key(PK; "Entry No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Item No.", "Variant Code", "Unit Of Measure Code", "Prod. BOM Quantity") { }
    }

    trigger OnInsert()
    var
        lKitProdExhibitorItemBOM: Record "ecKit/Prod. Exhibitor Item BOM";
    begin
        TestField("Entry No.");
        if (Rec."Line No." = 0) then begin
            Rec."Line No." := 10000;

            Clear(lKitProdExhibitorItemBOM);
            lKitProdExhibitorItemBOM.SetRange("Entry No.", Rec."Entry No.");
            if not lKitProdExhibitorItemBOM.IsEmpty then begin
                lKitProdExhibitorItemBOM.FindLast();
                Rec."Line No." += lKitProdExhibitorItemBOM."Line No.";
            end;
        end;
    end;
}
