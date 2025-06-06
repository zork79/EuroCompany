namespace EuroCompany.BaseApp.Manufacturing.Reports;

using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Manufacturing;
using EuroCompany.BaseApp.Manufacturing.Document;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Manufacturing.Capacity;
using Microsoft.Manufacturing.Document;
using System.Utilities;

report 50011 "ecProduction Program"
{
    ApplicationArea = All;
    Caption = 'Production Program';
    DefaultLayout = RDLC;
    Description = 'CS_PRO_018';
    PreviewMode = PrintLayout;
    RDLCLayout = '.\src\EuroCompany\BaseApp\Manufacturing\Reports\ProductionDailyProgram.Layout.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(ProdOrderLine; "Prod. Order Line")
        {
            RequestFilterFields = "ecProductive Status", "ecWork Center No.", "Routing No.", "Starting Date", "Ending Date";

            column(lblTitle; lblTitle) { }
            column(lblPrevOperation; lblPrevOperation) { }
            column(lblDate; lblDate) { }
            column(lblLineManager; lblLineManager) { }
            column(lblSignature; lblSignature) { }
            column(lblProdOrderNo; lblProdOrderNo) { }
            column(lblItemNo; lblItemNo) { }
            column(lblBrand; lblBrand) { }
            column(lblDescription; lblDescription) { }
            column(lblGramsForNoConsPkg; lblGrams) { }
            column(lblPackages; lblPackages) { }
            column(lblFilm; lblFilm) { }
            column(lblCarton; lblCarton) { }
            column(lblFilmRemQty; lblFilmRemQty) { }
            column(lblRemaningQty; lblRemaningQty) { }
            column(lblPalletNo; lblPalletNo) { }
            column(lblHours; lblHours) { }
            column(lblTotalHours; lblTotalHours) { }
            column(lblUnitOfMeasure; lblUnitOfMeasure) { }
            column(lblDateFilter; lblDateFilter) { }
            column(lblBand; lblBand) { }

            column(Company; Company) { }
            column(ExecutionDate; Format(Today, 0, '<Day,2> <Month Text> <Year4>')) { }
            column(ecPrevalent_Operation_Type; "ecPrevalent Operation Type") { }
            column(ecPrevalent_Operation_No_; "ecPrevalent Operation No.") { }
            column(Starting_Date_Time; Format("Starting Date-Time")) { }
            column(Starting_Date; Format(DT2Date("Starting Date-Time"))) { }
            column(Starting_Time; Format(DT2Time("Starting Date-Time"))) { }
            column(Ending_Date; Format("Ending Date-Time")) { }
            column(OrderStartingDate; OrderStartingDate) { }
            column(ecBand; ecBand) { }
            column(Prod__Order_No_; "Prod. Order No.") { }
            column(Line_No_; "Line No.") { }
            column(Item_No_; "Item No.") { }
            column(Description; Description) { }
            column(BrandCode; BrandCode) { }
            column(WeightInGrams; WeightInGrams) { }
            column(NoConsumerUnitsPerPkg; NoConsumerUnitsPerPkg) { }
            column(ecFilm_Packaging_Code; "ecFilm Packaging Code") { }
            column(FilmQuantity; FilmQuantity)
            {
                DecimalPlaces = 2 : 2;
            }
            column(FilmQuantityOriginal; FilmQuantityOriginal)
            {
                DecimalPlaces = 2 : 2;
            }
            column(ecCartons_Packaging_Code; "ecCartons Packaging Code") { }
            column(Remaining_Quantity; "Remaining Quantity")
            {
                DecimalPlaces = 2 : 2;
            }
            column(PalletQty; PalletQty)
            {
                DecimalPlaces = 2 : 2;
            }
            column(PalletTotQty; PalletTotQty)
            {
                DecimalPlaces = 2 : 2;
            }
            column(UnitOfMeasureCode; "Unit of Measure Code") { }
            column(RemainingTimeText; RemainingTimeText) { }
            column(GramsForNoConsPkgText; GramsForNoConsPkgText) { }
            column(Quantity; Quantity)
            {
                DecimalPlaces = 2 : 2;
            }
            column(ecProduction_Notes; "ecProduction Notes") { }
            column(ecPlanning_Notes; "ecPlanning Notes") { }

            dataitem(ProdOrderComponent; "Prod. Order Component")
            {

                DataItemLink = Status = field(Status), "Prod. Order No." = field("Prod. Order No."), "Prod. Order Line No." = field("Line No.");
                DataItemLinkReference = ProdOrderLine;
                DataItemTableView = sorting(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.") order(ascending);

                column(ProdOrdComp_Status; Status) { }
                column(ProdOrdComp_ProdOrderNo; "Prod. Order No.") { }
                column(ProdOrdComp_ProdOrderLineNo; "Prod. Order Line No.") { }
                column(ProdOrdComp_LineNo; "Line No.") { }
                column(ProdOrdComp_ItemNo; "Item No.") { }
                column(ProdOrdComp_Description; Description) { }

                trigger OnAfterGetRecord()
                var
                    lItem: Record Item;
                begin
                    lItem.Get("Item No.");
                    if (lItem."ecItem Type" in [lItem."ecItem Type"::"Carton Packaging", lItem."ecItem Type"::"Film Packaging"]) then begin
                        CurrReport.Skip();
                    end;
                end;
            }

            dataitem(Integer; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));

                column(RemaningHours; RemainingHours) { }
                column(RemaningMinutes; RemainingMinutes) { }
            }

            trigger OnPreDataItem()
            begin
                ProdOrderLine.SetCurrentKey("ecPrevalent Operation Type", "ecPrevalent Operation No.");
                ProdOrderLine.SetRange(Status, ProdOrderLine.Status::Released);
                ProdOrderLine.SetRange("Starting Date", 0D, OrderStartingDate);
            end;

            trigger OnAfterGetRecord()
            var
                lItem: Record Item;
                lItemUnitofMeasure: Record "Item Unit of Measure";
                lProdOrderComponent: Record "Prod. Order Component";
                lUoMMgt: Codeunit "Unit of Measure Management";
                lPackageQty: Decimal;
            begin
                PalletQty := 0;
                lItem.Get(ProdOrderLine."Item No.");
                BrandCode := lItem.ecBrand;
                if (lItem."ecConsumer Unit of Measure" <> '') then begin
                    WeightInGrams := lItem."ecWeight in Grams";
                    NoConsumerUnitsPerPkg := lItem."ecNo. Consumer Units per Pkg.";
                end;

                FilmQuantity := 0;
                FilmQuantityOriginal := 0;
                Clear(lProdOrderComponent);
                lProdOrderComponent.SetRange(Status, ProdOrderLine.Status);
                lProdOrderComponent.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                lProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
                lProdOrderComponent.SetRange("Item No.", ProdOrderLine."ecFilm Packaging Code");
                if not lProdOrderComponent.IsEmpty then begin
                    lProdOrderComponent.FindLast();
                    FilmQuantity := lProdOrderComponent."Quantity per" * ProdOrderLine."Remaining Quantity";
                    FilmQuantityOriginal := lProdOrderComponent."Expected Quantity";
                end;

                if (lItem."ecNo. Of Units per Layer" <> 0) and (lItem."ecNo. of Layers per Pallet" <> 0) and (lItem."ecPackage Unit Of Measure" <> '') then begin
                    lItemUnitofMeasure.Get("Item No.", lItem."ecPackage Unit Of Measure");
                    lPackageQty := lUoMMgt.CalcQtyFromBase(ProdOrderLine."Remaining Qty. (Base)", lItemUnitofMeasure."Qty. per Unit of Measure");
                    PalletQty := Round(lPackageQty / (lItem."ecNo. Of Units per Layer" * lItem."ecNo. of Layers per Pallet"), 0.5, '=');
                    PalletTotQty := Round(lUoMMgt.CalcQtyFromBase(ProdOrderLine."Quantity (Base)", lItemUnitofMeasure."Qty. per Unit of Measure") /
                                         (lItem."ecNo. Of Units per Layer" * lItem."ecNo. of Layers per Pallet"), 0.5, '=');
                end;

                RemainingTimeText := '';
                RemainingHours := 0;
                RemainingMinutes := 0;
                RemainingTime := GetProdOrderLineRemaningHours(ProdOrderLine);
                if (RemainingTime <> 0) then begin
                    RemainingHours := RemainingTime div 1;
                    RemainingMinutes := Round((RemainingTime - RemainingHours) * 60, 1, '=');

                    RemainingTimeText := Format(RemainingHours) + ':';
                    if (RemainingMinutes < 10) then begin
                        RemainingTimeText += '0';
                    end;
                    RemainingTimeText += Format(RemainingMinutes);
                end;

                GramsForNoConsPkgText := '';
                GramsForNoConsPkgText := Format(WeightInGrams) + ' X ' + Format(NoConsumerUnitsPerPkg);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    Caption = 'Filters';

                    field(OrderStartingDateField; OrderStartingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Select orders starting by...';
                    }
                }
            }
        }
    }

    var
        RemainingTimeText: Text;
        GramsForNoConsPkgText: Text;
        BrandCode: Code[20];
        Company: Code[100];
        OrderStartingDate: Date;
        NoConsumerUnitsPerPkg: Integer;
        WeightInGrams: Decimal;
        FilmQuantity: Decimal;
        FilmQuantityOriginal: Decimal;
        PalletQty: Decimal;
        PalletTotQty: Decimal;
        RemainingTime: Decimal;
        RemainingHours: Integer;
        RemainingMinutes: Integer;

        lblTitle: Label 'PRODUCTION PROGRAM';
        lblPrevOperation: Label 'LINE NO.';
        lblDate: Label 'DATE';
        lblLineManager: Label 'LINE MANAGER';
        lblSignature: Label 'SIGNATURE';
        lblProdOrderNo: Label 'Order no.';
        lblItemNo: Label 'Item no.';
        lblBrand: Label 'Brand';
        lblDescription: Label 'Description';
        lblGrams: Label 'GR';
        lblPackages: Label 'Pkg';
        lblFilm: Label 'Film';
        lblCarton: Label 'Carton';
        lblFilmRemQty: Label 'Film qty';
        lblRemaningQty: Label 'Qty';
        lblPalletNo: Label 'PLT';
        lblHours: Label 'Hours';
        lblTotalHours: Label 'Total hours';
        lblUnitOfMeasure: Label 'UM';
        lblDateFilter: Label 'ORDERS STARTING BY...';
        lblBand: Label 'Band';

    trigger OnInitReport()
    begin
        Company := CompanyName;
    end;

    local procedure GetProdOrderLineRemaningHours(var pProdOrderLine: Record "Prod. Order Line"): Decimal
    var
        lProdOrderRoutingLine: Record "Prod. Order Routing Line";
        lRemaningTime: Decimal;
    begin
        if (pProdOrderLine."Prod. Order No." = '') then exit(0);

        lRemaningTime := 0;
        Clear(lProdOrderRoutingLine);
        lProdOrderRoutingLine.SetRange(Status, pProdOrderLine.Status);
        lProdOrderRoutingLine.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        lProdOrderRoutingLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        lProdOrderRoutingLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
        if lProdOrderRoutingLine.FindSet() then begin
            repeat
                if (pProdOrderLine."Finished Quantity" = 0) then begin
                    lRemaningTime += ConvertToHours(lProdOrderRoutingLine, lProdOrderRoutingLine."Setup Time", lProdOrderRoutingLine."Setup Time Unit of Meas. Code");
                end;
                if (lProdOrderRoutingLine."Next Operation No." = '') then begin
                    lRemaningTime += ConvertToHours(lProdOrderRoutingLine, lProdOrderRoutingLine."Run Time" * pProdOrderLine."Remaining Quantity",
                                                    lProdOrderRoutingLine."Run Time Unit of Meas. Code");
                end;
            until (lProdOrderRoutingLine.Next() = 0);
        end;

        exit(lRemaningTime);
    end;

    local procedure ConvertToHours(pProdOrderRoutingLine: Record "Prod. Order Routing Line"; pTimeValue: Decimal; pUnitOfMeasure: Code[10]): Decimal
    var
        lCapacityUnitofMeasure: Record "Capacity Unit of Measure";
        lTimeInHours: Decimal;

        lblError: Label 'Unit of measure "%1" is not supported!';
        lblError002: Label 'Capacity Unit of Measure = "%1" does not exist for Prod. Order = "%2", Routing Reference No. = "%3", Operation No. = "%4"';
    begin
        if not lCapacityUnitofMeasure.Get(pUnitOfMeasure) then begin
            Error(lblError002, pUnitOfMeasure, pProdOrderRoutingLine."Prod. Order No.",
                                               pProdOrderRoutingLine."Routing Reference No.",
                                               pProdOrderRoutingLine."Operation No.");
        end;
        case lCapacityUnitofMeasure.Type of
            lCapacityUnitofMeasure.Type::Minutes: // Minuti
                lTimeInHours := pTimeValue / 60;
            lCapacityUnitofMeasure.Type::Seconds: // Secondi
                lTimeInHours := pTimeValue / 3600;
            lCapacityUnitofMeasure.Type::Hours: // Ore (già in ore)
                lTimeInHours := pTimeValue;
            lCapacityUnitofMeasure.Type::Days: // Giorni
                lTimeInHours := (pTimeValue * 24);
            else
                Error(lblError, pUnitOfMeasure);
        end;

        exit(lTimeInHours);
    end;
}
