namespace EuroCompany.BaseApp.Sales.Document;

using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Manufacturing;
using EuroCompany.BaseApp.Setup;
using Microsoft.Finance.Currency;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Sales.Document;

tableextension 80076 "Sales Line" extends "Sales Line"
{
    fields
    {
        modify("AltAWPParcel Units")
        {
            Caption = 'No. of logistic units';
            Description = 'CS_LOG_001';
        }
        modify("AltAWPQuantity to Handle")
        {
            trigger OnAfterValidate()
            begin
                ecCheckQuantity(FieldNo("AltAWPQuantity to Handle"));
            end;
        }
        modify("APsComposed Discount")
        {
            trigger OnAfterValidate()
            begin
                KitExhibitorCheckLine();  //CS_PRO_009-n
            end;
        }
        modify("Line Amount")
        {
            trigger OnAfterValidate()
            begin
                KitExhibitorCheckLine();  //CS_PRO_009-n
            end;
        }
        modify("Line Discount %")
        {
            trigger OnAfterValidate()
            begin
                KitExhibitorCheckLine();  //CS_PRO_009-n
            end;
        }
        modify("Line Discount Amount")
        {
            trigger OnAfterValidate()
            begin
                KitExhibitorCheckLine();  //CS_PRO_009-n
            end;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                lxSalesLine: Record "Sales Line";
                lKitProdExhibitorItemBOM: Record "ecKit/Prod. Exhibitor Item BOM";
                lProductionFunctions: Codeunit "ecProduction Functions";
            begin
                //CS_PRO_009-s                
                if (Rec.Type = Rec.Type::Item) and (Rec."Document Type" = Rec."Document Type"::Order) then begin
                    if lxSalesLine.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.") then begin
                        if (lxSalesLine."No." <> Rec."No.") and lProductionFunctions.IsKitProductExhibitorItem(lxSalesLine."No.") then begin
                            if (lxSalesLine."ecKit/Exhibitor BOM Entry No." <> 0) then begin
                                Clear(lKitProdExhibitorItemBOM);
                                lKitProdExhibitorItemBOM.SetRange("Entry No.", lxSalesLine."ecKit/Exhibitor BOM Entry No.");
                                if not lKitProdExhibitorItemBOM.IsEmpty then lKitProdExhibitorItemBOM.DeleteAll(true);
                            end;
                        end;
                    end;
                end;
                //CS_PRO_009-e
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                lSalesLine: Record "Sales Line";
                lProductionFunctions: Codeunit "ecProduction Functions";
            begin
                //CS_PRO_009-s
                if (Rec.Type = Rec.Type::Item) and (Rec."Document Type" = Rec."Document Type"::Order) and (Rec."Quantity Shipped" = 0) then begin
                    if lSalesLine.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.") and lProductionFunctions.IsKitProductExhibitorItem(lSalesLine."No.") and
                       (lSalesLine.Quantity <> Rec.Quantity)
                    then begin
                        Rec."ecKit/Exhibitor Recalc. Req." := true;
                    end else begin
                        if not lSalesLine.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.") and lProductionFunctions.IsKitProductExhibitorItem(Rec."No.") then begin
                            Rec."ecKit/Exhibitor Recalc. Req." := true;
                        end;
                    end;
                end;
                //CS_PRO_009-e
            end;
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                KitExhibitorCheckLine();  //CS_PRO_009-n
            end;
        }
        field(50000; "ecConsumer Unit of Measure"; Code[10])
        {
            Caption = 'Consumer Unit of Measure';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_014';
            TableRelation =
            if (Type = const(Item), "No." = filter(<> '')) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            if (Type = const(Resource), "No." = filter(<> '')) "Resource Unit of Measure".Code where("Resource No." = field("No."))
            else
            if (Type = filter("Charge (Item)" | "Fixed Asset" | "G/L Account")) "Unit of Measure";

            trigger OnValidate()
            begin
                //CS_VEN_014-VI-s
                if ("ecConsumer Unit of Measure" <> '') then begin
                    TestField(Type, Type::Item);
                end;

                ecRecalcQtyPerConsumerUM();
                Validate("ecQty. per Consumer UM");
                //CS_VEN_014-VI-e
            end;

        }
        field(50001; "ecQty. per Consumer UM"; Decimal)
        {
            Caption = 'Qty. per Consumer UM';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'CS_VEN_014';
            Editable = false;
            InitValue = 1;

            trigger OnValidate()
            begin
                ecUpdateConsumerUMQuantity();
            end;
        }
        field(50002; "ecQuantity (Consumer UM)"; Decimal)
        {
            Caption = 'Quantity (Consumer UM)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'CS_VEN_014';

            trigger OnValidate()
            begin
                //CS_VEN_014-VI-s
                if ("ecQuantity (Consumer UM)" <> 0) then begin
                    TestField(Type, Type::Item);
                    TestField("ecConsumer Unit of Measure");
                    TestField("ecQty. per Consumer UM");
                end;

                ecCheckQuantity(FieldNo("ecQuantity (Consumer UM)"));
                ecUpdateQuantityByConsumerUM();
                //CS_VEN_014-VI-e
            end;
        }
        field(50003; "ecUnit Price (Consumer UM)"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price (Consumer UM)';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_014';

            trigger OnValidate()
            begin
                //CS_VEN_014-VI-s
                ecUpdateUnitPriceByConsumerUnitPrice();
                //CS_VEN_014-VI-e
            end;
        }
        field(50010; "ecKit/Exhibitor Recalc. Req."; Boolean)
        {
            Caption = 'Kit/Prod. Exhibitor recal. required';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_009';
            Editable = false;
        }
        field(50011; "ecKit/Exhibitor Item"; Boolean)
        {
            CalcFormula = lookup(Item."ecKit/Product Exhibitor" where("No." = field("No.")));
            Caption = 'Kit/Exhibitor Item';
            Description = 'CS_PRO_009';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "ecKit/Exhib. Manual Price"; Boolean)
        {
            Caption = 'Kit/Exhibitor manual price';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_009';
            Editable = false;
        }
        field(50015; "ecKit/Exhibitor BOM Entry No."; Integer)
        {
            Caption = 'Kit/Exhibitor BOM Entry No.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_009';
            Editable = false;
        }
        field(50020; "ecKit/Exhib. BOM Price Lines"; Integer)
        {
            CalcFormula = count("ecKit/Prod. Exhibitor Item BOM" where("Entry No." = field("ecKit/Exhibitor BOM Entry No.")));
            Caption = 'Kit/Exhib. BOM Price Lines';
            Description = 'CS_PRO_009';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50025; "ecKit/Exhib. BOM Price Errors"; Integer)
        {
            CalcFormula = count("ecKit/Prod. Exhibitor Item BOM" where("Entry No." = field("ecKit/Exhibitor BOM Entry No."), "Error Text" = filter(<> '')));
            Caption = 'Kit/Exhib. BOM price errors';
            Description = 'CS_PRO_009';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50030; "ecAttacch. Kit/Exhib. Line No."; Integer)
        {
            Caption = 'Attacched To Kit/Exhib. Line No.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_009';
            Editable = false;
        }
        field(50050; "ecExclude From Item Ledg.Entry"; Boolean)
        {
            Caption = 'Exclude from Item Ledg. Entry';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_036';

            trigger OnValidate()
            var
                Temp_lTrackingSpecification: Record "Tracking Specification" temporary;
                latsItemTrackingHandler: Codeunit "AltATSItem Tracking Handler";
            begin
                if (Rec."Document Type" = Rec."Document Type"::Invoice) then begin
                    Rec.TestField("AltAWPWarehouse Shipment No.", '');
                    Rec.TestField("Shipment No.", '');
                end;
                if (Rec."Document Type" = Rec."Document Type"::"Credit Memo") then begin
                    Rec.TestField("AltAWPWarehouse Receipt No.", '');
                    Rec.TestField("Return Receipt No.", '');
                end;

                latsItemTrackingHandler.SetSourceSalesLine(Rec);
                if latsItemTrackingHandler.GetItemTrackingLines(Temp_lTrackingSpecification) then begin
                    latsItemTrackingHandler.DeleteAllItemTrackingLines();
                end;
            end;
        }
    }

    trigger OnAfterDelete()
    var
        lKitProdExhibitorItemBOM: Record "ecKit/Prod. Exhibitor Item BOM";
    begin
        if (Rec."ecKit/Exhibitor BOM Entry No." <> 0) and (Rec."Document Type" = Rec."Document Type"::Order) then begin
            Clear(lKitProdExhibitorItemBOM);
            lKitProdExhibitorItemBOM.SetRange("Entry No.", Rec."ecKit/Exhibitor BOM Entry No.");
            if not lKitProdExhibitorItemBOM.IsEmpty then lKitProdExhibitorItemBOM.DeleteAll(true);
        end;
    end;

    internal procedure ecUpdateConsumerUMQuantity()
    var
        lawpLogisticsFunctions: Codeunit "AltAWPLogistics Functions";
    begin
        //CS_VEN_014-VI-s
        "ecQuantity (Consumer UM)" := 0;
        if ("ecConsumer Unit of Measure" <> '') and (Type = Type::Item) then begin
            ecCheckQuantity(FieldNo(Quantity));

            "ecQuantity (Consumer UM)" := lawpLogisticsFunctions.ConvertItemQtyInUM("No.",
                                                                                    Quantity,
                                                                                    "Unit of Measure Code",
                                                                                    "ecConsumer Unit of Measure");

            ecCheckQuantity(FieldNo("ecQuantity (Consumer UM)"));
        end;
        //CS_VEN_014-VI-e
    end;

    local procedure ecRecalcQtyPerConsumerUM()
    var
        lawpLogisticsFunctions: Codeunit "AltAWPLogistics Functions";
    begin
        "ecQty. per Consumer UM" := 0;

        if (Type = Type::Item) then begin
            "ecQty. per Consumer UM" := 1;
            if ("ecConsumer Unit of Measure" <> "Unit of Measure Code") and
               ("ecConsumer Unit of Measure" <> '')
            then begin
                "ecQty. per Consumer UM" := lawpLogisticsFunctions.CalcItemUMConversionFactor("No.",
                                                                                              "Unit of Measure Code",
                                                                                              "ecConsumer Unit of Measure");
            end;
        end;
    end;

    internal procedure ecUpdateQuantityByConsumerUM()
    var
        lawpLogisticsFunctions: Codeunit "AltAWPLogistics Functions";
    begin
        //CS_VEN_014-VI-s
        if (Type = Type::Item) then begin
            TestField("ecQty. per Consumer UM");

            ecRecalcQtyPerConsumerUM();
            Validate(Quantity, lawpLogisticsFunctions.ConvertItemQtyInUM("No.",
                                                                         "ecQuantity (Consumer UM)",
                                                                         "ecConsumer Unit of Measure",
                                                                         "Unit of Measure Code"));
        end;
        //CS_VEN_014-VI-e
    end;

    local procedure ecCheckQuantity(pCalledByFieldNo: Integer)
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
        if (Type = Type::Item) then begin
            case pCalledByFieldNo of
                FieldNo("ecQuantity (Consumer UM)"):
                    begin
                        lFieldName := FieldCaption("ecQuantity (Consumer UM)");
                        lQuantityValue := "ecQuantity (Consumer UM)";
                        lUMCode := "ecConsumer Unit of Measure";
                        lUMCode2 := "Unit of Measure Code";
                    end;

                FieldNo("AltAWPQuantity to Handle"):
                    begin
                        lFieldName := FieldCaption("AltAWPQuantity to Handle");
                        lQuantityValue := "AltAWPQuantity to Handle";
                        lUMCode := "Unit of Measure Code";
                        lUMCode2 := "ecConsumer Unit of Measure";
                    end;

                else begin
                    lFieldName := FieldCaption(Quantity);
                    lQuantityValue := Quantity;
                    lUMCode := "Unit of Measure Code";
                    lUMCode2 := "ecConsumer Unit of Measure";
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
        end;
        //CS_VEN_014-VI-e
    end;

    local procedure ecUpdateUnitPriceByConsumerUnitPrice()

    begin
        //CS_VEN_014-VI-s
        if ("ecUnit Price (Consumer UM)" <> 0) then begin
            TestField(Type, Type::Item);
            TestField("ecConsumer Unit of Measure");

            Validate("Unit Price", "ecUnit Price (Consumer UM)" * "ecQty. per Consumer UM");
        end else begin
            Validate("Unit Price", 0);
        end;
        //CS_VEN_014-VI-e
    end;

    internal procedure ecUpdateConsumerUMUnitPrice()
    var
        lSalesHeader: Record "Sales Header";
        lCurrency: Record Currency;
        lQtyPerConsumerUM: Decimal;
    begin
        //CS_VEN_014-VI-s
        "ecUnit Price (Consumer UM)" := 0;

        if (Type = Type::Item) and ("ecQty. per Consumer UM" <> 0) then begin
            lQtyPerConsumerUM := "ecQty. per Consumer UM";

            if ("ecQuantity (Consumer UM)" <> 0) and (Quantity <> 0) then begin
                // Ricalcolo il fattore di conversione per evitare problemi derivanti dall'arrotondamento
                // effettuato sul campo "ecQty. per Consumer UM"
                lQtyPerConsumerUM := "ecQuantity (Consumer UM)" / Quantity;
            end;

            GetSalesHeader(lSalesHeader, lCurrency);
            "ecUnit Price (Consumer UM)" := Round("Unit Price" / lQtyPerConsumerUM, lCurrency."Unit-Amount Rounding Precision");
        end;
        //CS_VEN_014-VI-e
    end;

    local procedure KitExhibitorCheckLine()
    var
        lxSalesLine: Record "Sales Line";
    begin
        //CS_PRO_009-s
        if (Rec."Document Type" = Rec."Document Type"::Order) and not Rec."ecKit/Exhibitor Recalc. Req." then begin
            if not lxSalesLine.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.") or
               (lxSalesLine."APsComposed Discount" <> Rec."APsComposed Discount") or
               (lxSalesLine."Line Amount" <> Rec."Line Amount") or
               (lxSalesLine."Line Discount %" <> Rec."Line Discount %") or
               (lxSalesLine."Line Discount Amount" <> Rec."Line Discount Amount") or
               (lxSalesLine."Unit Price" <> Rec."Unit Price")
            then begin
                Rec.CalcFields("ecKit/Exhibitor Item");
                if Rec."ecKit/Exhibitor Item" and (Rec."Outstanding Quantity" <> 0) then begin
                    "ecKit/Exhib. Manual Price" := true;
                    "ecKit/Exhibitor Recalc. Req." := true;
                end;
            end;
        end;
        //CS_PRO_009-e
    end;
    #region 306

    procedure ecShowLinePricingDetail()
    var
        lDocLinePricing: Record "APsTRD Doc. Line Pricing";
        lDocLinePricingDetail: Page "APsTRD Doc.LinePricing Detail";
    begin
        if lDocLinePricing.Get("APsTRD Pricing Det. EntryNo.") then begin
            lDocLinePricing.SetRecFilter();
            lDocLinePricingDetail.SetTableView(lDocLinePricing);
            lDocLinePricingDetail.Run();
        end;
    end;

    procedure ecGetMaxUnitPriceListTolerance() rMaxUnitPriceListTolerance: Decimal
    var
        lGeneralSetup: Record "ecGeneral Setup";
        lMaxUnitPriceListTolerancePerc: Decimal;
    begin
        Clear(lMaxUnitPriceListTolerancePerc);
        Clear(rMaxUnitPriceListTolerance);

        if not lGeneralSetup.Get() then
            lGeneralSetup.Init();

        lMaxUnitPriceListTolerancePerc := lGeneralSetup."ecPrice Diff. Tolerance %";

        rMaxUnitPriceListTolerance := "ecUnit Price (Consumer UM)" * (lMaxUnitPriceListTolerancePerc / 100);
    end;

    procedure ecHasOutOfToleranceUnitPriceListDiff(): Boolean
    var
        lCurrency: Record Currency;
        lSalesHeader: Record "Sales Header";
        lDocLinePricing: Record "APsTRD Doc. Line Pricing";
        lMaxToleranceUnitPriceList: Decimal;
        lUnitPriceList: Decimal;
        lUnitPriceDiff: Decimal;
        lUnitPriceListDiff: Decimal;
    begin
        Clear(lMaxToleranceUnitPriceList);
        Clear(lUnitPriceList);
        Clear(lUnitPriceDiff);
        Clear(lUnitPriceListDiff);

        if not lDocLinePricing.Get(Rec."APsTRD Pricing Det. EntryNo.") then
            lDocLinePricing.Init();

        lUnitPriceList := lDocLinePricing."Unit Price List";

        //if lDocLinePricing."Std. Unit Price" <> 0 then begin
        GetSalesHeader(lSalesHeader, lCurrency);

        lMaxToleranceUnitPriceList := ecGetMaxUnitPriceListTolerance();

        lUnitPriceDiff := Rec."Unit Price" - lDocLinePricing."Std. Unit Price";
        lUnitPriceListDiff := Round(lUnitPriceDiff * (Rec."ecUnit Price (Consumer UM)" / Rec."Unit Price"), lCurrency."Unit-Amount Rounding Precision");
        //end;

        if ((lUnitPriceList = 0) and (Rec."Unit Price" <> 0)) or (-lUnitPriceListDiff > lMaxToleranceUnitPriceList) then
            exit(true);

        exit(false);
    end;

    procedure ecRestoreUnitPriceList()
    var
        lDocLinePricing: Record "APsTRD Doc. Line Pricing";
    begin
        if lDocLinePricing.Get(Rec."APsTRD Pricing Det. EntryNo.") then
            if lDocLinePricing."Std. Unit Price" <> 0 then
                if Rec."Unit Price" <> lDocLinePricing."Std. Unit Price" then begin
                    Rec.SetHideValidationDialog(true);
                    Rec.Validate("Unit Price", lDocLinePricing."Std. Unit Price");
                    Rec.SetHideValidationDialog(false);
                    Rec.Modify(true);
                end;
    end;
    #endregion 306
}
