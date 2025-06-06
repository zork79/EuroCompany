namespace EuroCompany.BaseApp.Sales.AdvancedTrade;
using EuroCompany.BaseApp.Inventory;
using EuroCompany.BaseApp.Inventory.Barcode;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Catalog;
using Microsoft.Sales.Document;

table 90006 "ecItem Selection Buffer"
{
    Caption = 'Item Selection Buffer';
    DataClassification = CustomerContent;
    Description = 'CS_VEN_032';
    TableType = Temporary;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = Item."No.";
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Search Description"; Code[100])
        {
            Caption = 'Search Description';
        }
        field(5; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(20; "Sales Unit of Measure"; Code[10])
        {
            Caption = 'Sales Unit of Measure';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("No."));
        }
        field(25; "Consumer Unit of Measure"; Code[20])
        {
            Caption = 'Consumer Unit of Measure';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("No."));
        }
        field(26; "Qty. per Consumer UM"; Decimal)
        {
            Caption = 'Qty. per Consumer UM';
            DecimalPlaces = 0 : 5;
            Description = 'CS_VEN_014';
            Editable = false;
            InitValue = 1;
        }
        field(30; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(31; "Item Category Description"; Text[100])
        {
            CalcFormula = lookup("Item Category".Description where(Code = field("Item Category Code")));
            Caption = 'Item Category Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "Product Group Code"; Code[20])
        {
            Caption = 'Product Group Code';
            TableRelation = "AltAWPProduct Group".Code where("Item Category Code" = field("Item Category Code"));
        }
        field(36; "Product Group Description"; Text[100])
        {
            CalcFormula = lookup("AltAWPProduct Group".Description where("Item Category Code" = field("Item Category Code"), Code = field("Product Group Code")));
            Caption = 'Product Group Description';
            Description = 'AWP004';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; Selected; Boolean)
        {
            Caption = 'Selected';
        }
        field(101; "Qty. to Handle"; Decimal)
        {
            Caption = 'Qty. to Handle';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                UpdateConsumerUMQuantity();
                Selected := ("Qty. to Handle" > 0);
            end;
        }
        field(105; "Qty. to Handle (Consumer UM)"; Decimal)
        {
            Caption = 'Qty. to Handle (Consumer UM)';
            DecimalPlaces = 0 : 5;
            Description = 'CS_VEN_014';
            MinValue = 0;

            trigger OnValidate()
            begin
                //CS_VEN_014-VI-s
                if ("Qty. to Handle (Consumer UM)" <> 0) then begin
                    TestField("Consumer Unit of Measure");
                    TestField("Qty. per Consumer UM");
                end;

                CheckQuantity(FieldNo("Qty. to Handle (Consumer UM)"));
                UpdateQuantityByConsumerUM();
                //CS_VEN_014-VI-e
            end;
        }
        field(150; "No. Of Units per Layer"; Decimal)
        {
            Caption = 'No. of units per layer';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(151; "No. of Layers per Pallet"; Decimal)
        {
            Caption = 'No. of layers per pallet';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(152; "Number Of Units Per Pallet"; Decimal)
        {
            Caption = 'Number of units per pallet';
            DecimalPlaces = 0 : 5;
        }
        field(153; "Pallet Type"; Code[20])
        {
            Caption = 'Pallet format';
            TableRelation = "AltAWPLogistic Unit Format".Code where("Application Type" = filter("Box Only" | "Box and Pallet"));
        }
        field(154; Stackable; Boolean)
        {
            Caption = 'Stackable';
        }
        field(155; "Weight in Grams"; Decimal)
        {
            Caption = 'Weight in grams';
            DecimalPlaces = 0 : 5;
        }
        field(156; "EAN-13 Barcode"; Code[50])
        {
            Caption = 'EAN-13';
        }
        field(157; "ITF-14 Barcode"; Code[50])
        {
            Caption = 'ITF-14';
        }
        field(158; "Item Reference No."; Code[50])
        {
            Caption = 'Item reference no.';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        Item: Record Item;
        GlobalSalesHeader: Record "Sales Header";

    local procedure GetItem()
    begin
        if (Item."No." <> "No.") then begin
            Item.Get("No.");
        end;
    end;

    procedure IsNonInventoriableType(): Boolean
    begin
        GetItem();
        exit(Item.Type in [Item.Type::"Non-Inventory", Item.Type::Service]);
    end;

    procedure CopyFromItem(pItem: Record Item)
    var
        lLogistcFunctions: Codeunit "ecLogistc Functions";
        lBarcodeFunctions: Codeunit "ecBarcode Functions";
        lawpLogisticsFunctions: Codeunit "AltAWPLogistics Functions";
        lPalletType: Code[20];
        lNoOfUnitsPerLayer: Decimal;
        lNoOfLayersPerPallet: Decimal;
        lStackable: Boolean;
    begin
        Rec.Init();
        Rec."No." := pItem."No.";
        Rec.Description := pItem.Description;
        Rec."Search Description" := pItem."Search Description";
        Rec."Description 2" := pItem."Description 2";
        Rec."Item Category Code" := pItem."Item Category Code";
        Rec."Product Group Code" := pItem."AltAWPProduct Group Code";

        Rec."Sales Unit of Measure" := pItem."Sales Unit of Measure";
        if (Rec."Sales Unit of Measure" = '') then begin
            Rec."Sales Unit of Measure" := pItem."Base Unit of Measure";
        end;

        Rec."Consumer Unit of Measure" := pItem."ecConsumer Unit of Measure";
        if (Rec."Consumer Unit of Measure" = '') then begin
            Rec."Consumer Unit of Measure" := Rec."Sales Unit of Measure";
        end;

        "Qty. per Consumer UM" := 1;
        if ("Consumer Unit of Measure" <> "Sales Unit of Measure") and
           ("Consumer Unit of Measure" <> '')
        then begin
            "Qty. per Consumer UM" := lawpLogisticsFunctions.CalcItemUMConversionFactor("No.",
                                                                                        "Sales Unit of Measure",
                                                                                        "Consumer Unit of Measure");
        end;

        lLogistcFunctions.GetItemLogisticsParameters(Rec."No.", '',
                                                     Enum::"AltAWPWhse Ship Subject Type"::Customer,
                                                     GlobalSalesHeader."Sell-to Customer No.",
                                                     lPalletType, lNoOfUnitsPerLayer,
                                                     lNoOfLayersPerPallet, lStackable);

        Rec."No. Of Units per Layer" := lNoOfUnitsPerLayer;
        Rec."No. of Layers per Pallet" := lNoOfLayersPerPallet;
        Rec."Number Of Units Per Pallet" := lNoOfLayersPerPallet * lNoOfUnitsPerLayer;
        Rec."Pallet Type" := lPalletType;
        Rec.Stackable := lStackable;
        Rec."Weight in Grams" := pItem."ecWeight in Grams";
        Rec."EAN-13 Barcode" := lBarcodeFunctions.GetItemBarcodeByType(Rec."No.", '', pItem."ecConsumer Unit of Measure",
                                                                       Enum::"AltAWPBarcode Symbology"::"EAN-13");
        Rec."ITF-14 Barcode" := lBarcodeFunctions.GetItemBarcodeByType(Rec."No.", '', pItem."ecPackage Unit Of Measure",
                                                                       Enum::"AltAWPBarcode Symbology"::"ITF-14");
        FindItemReference(Rec);
    end;

    local procedure FindItemReference(var pItemSelectionBuffer: Record "ecItem Selection Buffer")
    var
        lItemReference: Record "Item Reference";
        lCalculationDate: Date;
    begin
        pItemSelectionBuffer."Item Reference No." := '';
        if (GlobalSalesHeader."No." = '') then exit;

        lCalculationDate := GetDateForCalculation();

        lItemReference.Reset();
        lItemReference.SetRange("Item No.", pItemSelectionBuffer."No.");
        lItemReference.SetRange("Variant Code", '');
        lItemReference.SetRange("Unit of Measure", pItemSelectionBuffer."Sales Unit of Measure");

        if (lCalculationDate <> 0D) then begin
            lItemReference.SetFilter("Starting Date", '<=%1', lCalculationDate);
            lItemReference.SetFilter("Ending Date", '>=%1|%2', lCalculationDate, 0D);
        end;

        lItemReference.SetRange("Reference Type", lItemReference."Reference Type"::Customer);
        lItemReference.SetRange("Reference Type No.", GlobalSalesHeader."Sell-to Customer No.");
        if lItemReference.FindFirst() then begin
            pItemSelectionBuffer."Item Reference No." := lItemReference."Reference No.";
        end;
    end;

    internal procedure SetSourceSalesHeader(var pSalesHeader: Record "Sales Header")
    begin
        GlobalSalesHeader := pSalesHeader;
    end;

    local procedure GetDateForCalculation(): Date
    var
        lCalculationDate: Date;
    begin
        lCalculationDate := 0D;
        if (GlobalSalesHeader."No." = '') then begin
            lCalculationDate := GlobalSalesHeader."Posting Date";
        end else begin
            if GlobalSalesHeader."Document Type" in [GlobalSalesHeader."Document Type"::Invoice, GlobalSalesHeader."Document Type"::"Credit Memo"] then begin
                lCalculationDate := GlobalSalesHeader."Posting Date"
            end else begin
                lCalculationDate := GlobalSalesHeader."Order Date";
            end;
        end;
        if (lCalculationDate = 0D) then lCalculationDate := WorkDate();

        exit(lCalculationDate);
    end;

    internal procedure UpdateConsumerUMQuantity()
    var
        lawpLogisticsFunctions: Codeunit "AltAWPLogistics Functions";
    begin
        //CS_VEN_014-VI-s
        "Qty. to Handle (Consumer UM)" := 0;
        if ("Consumer Unit of Measure" <> '') then begin
            CheckQuantity(FieldNo("Qty. to Handle"));

            "Qty. to Handle (Consumer UM)" := lawpLogisticsFunctions.ConvertItemQtyInUM("No.",
                                                                                        "Qty. to Handle",
                                                                                        "Sales Unit of Measure",
                                                                                        "Consumer Unit of Measure");

            CheckQuantity(FieldNo("Qty. to Handle (Consumer UM)"));
        end;
        //CS_VEN_014-VI-e
    end;

    local procedure CheckQuantity(pCalledByFieldNo: Integer)
    var
        lItem: Record Item;
        lQuantityValue: Decimal;
        lUMCode: Code[10];
        lUMCode2: Code[10];
        lFieldName: Text;

        lInvalidConsumerUnitQtyErr: Label 'The value of field "%1" must be a multiple of %2 when the unit of measure is "%3"';
        lInvalidPackageUnitQtyErr: Label 'The value of field "%1" must be an integer when the unit of measure is "%2"';
    begin
        //CS_VEN_014-VI-s
        case pCalledByFieldNo of
            FieldNo("Qty. to Handle (Consumer UM)"):
                begin
                    lFieldName := FieldCaption("Qty. to Handle (Consumer UM)");
                    lQuantityValue := "Qty. to Handle (Consumer UM)";
                    lUMCode := "Consumer Unit of Measure";
                    lUMCode2 := "Sales Unit of Measure";
                end;

            else begin
                lFieldName := FieldCaption("Qty. to Handle");
                lQuantityValue := "Qty. to Handle";
                lUMCode := "Sales Unit of Measure";
                lUMCode2 := "Consumer Unit of Measure";
            end;
        end;

        if (lQuantityValue <> 0) then begin
            lItem.Get("No.");
            if (lItem."ecPackage Unit Of Measure" <> '') and
               (lUMCode = lItem."ecPackage Unit Of Measure")
            then begin
                if (Round(lQuantityValue, 1) <> lQuantityValue) then begin
                    Error(lInvalidPackageUnitQtyErr, lFieldName, lUMCode);
                end;
            end;

            if (lItem."ecConsumer Unit of Measure" <> '') and
               (lUMCode = lItem."ecConsumer Unit of Measure") and
               (lUMCode2 = lItem."ecPackage Unit Of Measure")
            then begin
                if (lItem."ecNo. Consumer Units per Pkg." <> 0) then begin
                    if (lQuantityValue mod lItem."ecNo. Consumer Units per Pkg." <> 0) then begin
                        Error(lInvalidConsumerUnitQtyErr, lFieldName, lItem."ecNo. Consumer Units per Pkg.", lUMCode);
                    end;
                end;
            end;
        end;
        //CS_VEN_014-VI-e
    end;

    internal procedure UpdateQuantityByConsumerUM()
    var
        lawpLogisticsFunctions: Codeunit "AltAWPLogistics Functions";
    begin
        //CS_VEN_014-VI-s
        TestField("Qty. per Consumer UM");

        Validate("Qty. to Handle", lawpLogisticsFunctions.ConvertItemQtyInUM("No.",
                                                                             "Qty. to Handle (Consumer UM)",
                                                                             "Consumer Unit of Measure",
                                                                             "Sales Unit of Measure"));
        //CS_VEN_014-VI-e
    end;

}