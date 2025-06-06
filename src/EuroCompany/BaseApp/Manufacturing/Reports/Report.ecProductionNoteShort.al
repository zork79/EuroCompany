namespace EuroCompany.BaseApp.Manufacturing.Reports;

using Microsoft.Foundation.Comment;
using Microsoft.Foundation.Company;
using Microsoft.Inventory.Costing;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.Manufacturing.Document;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.Routing;
using Microsoft.Manufacturing.WorkCenter;
using Microsoft.Purchases.Document;
using Microsoft.Sales.Document;
using Microsoft.Warehouse.Document;
using System.Text;
using System.Utilities;

report 50001 "ecProduction Note Short"
{
    ApplicationArea = All;
    Caption = 'Production Note';
    DefaultLayout = RDLC;
    Description = 'CS_PRO_038';
    PreviewMode = PrintLayout;
    RDLCLayout = '.\src\EuroCompany\BaseApp\Manufacturing\Reports\ProductionNoteShort.Layout.rdlc';

    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(ProductionOrder; "Production Order")
        {
            DataItemTableView = sorting("No.", Status)
                                order(ascending)
                                where(Status = const(Released),
                                      Blocked = const(false));
            PrintOnlyIfDetail = true;

            column(COMPANYNAME; CompanyName) { }
            column(lblODVNo; lblODVNo) { }
            column(lblOperation2; lblOperation2) { }
            column(lblProcessingInstruction; lblProcessingInstruction) { }
            column(lblProcessingMethod; lblProcessingMethod) { }
            column(lblTask; lblTask) { }
            column(Logo; CompanyInfo.Picture) { }
            column(MandatoryLotNoText; MandatoryLotNoText) { }
            column(ProdOrderNo; "No.") { }

            dataitem(ProdOrderLine; "Prod. Order Line")
            {
                DataItemLink = Status = field(Status),
                               "Prod. Order No." = field("No.");
                DataItemTableView = sorting(Status, "Prod. Order No.", "Line No.")
                                    order(ascending);
                PrintOnlyIfDetail = true;
                RequestFilterFields = "Prod. Order No.", "Line No.";

                column(BinCode_ProdOrderLine; ProdOrderLine."Bin Code") { }
                column(CustomerName; CustomerName) { }
                column(CustRef; CustRef) { }
                column(DeliveryAreaCode; SalesHeader."AltAWPDelivery Area Code") { }
                column(DeliveryAreaName; DeliveryAreaName) { }
                column(DepotCode; DepotCode) { }
                column(Description2_ProdOrderLine; ProdOrderLine."Description 2") { }
                column(Description_ProdOrderLine; ProdOrderLine.Description) { }
                column(Descrption2_ProdOrderLine; ProdOrderLine."Description 2") { }
                column(DimSede; DimSede) { }
                column(DueDate_ProdOrderLine; Format(ProdOrderLine."Due Date")) { }
                column(EndingDate_ProdOrderLine; Format(ProdOrderLine."Ending Date")) { }
                column(ExternalOperation; ExternalOperation) { }
                column(FreightType; Format(SalesHeader."AltAWPFreight Type")) { }
                column(HideDesignCardExternalRefBool; HideDesignCardExternalRefBool) { }
                column(HideDesignCardKitsDetailBool; HideDesignCardKitsDetailBool) { }
                column(ImageBase64String; ImageBase64String) { }
                column(ItemNo_ProdOrderLine; ProdOrderLine."Item No.") { }
                column(JobCustMachineNo; JobCustMachineNo) { }
                column(JobNo; JobNo) { }
                column(JobSellToCustName; JobSellToCustName) { }
                column(JobTaskNo; JobTaskNo) { }
                column(LineNo_ProdOrderLine; ProdOrderLine."Line No.") { }
                column(LocationCode_ProdOrderLine; ProdOrderLine."Location Code") { }
                column(LotSizeQty; LotSizeQty) { DecimalPlaces = 0 : 5; }
                column(OdvReference; OdvReference) { }
                column(PrintKitDetails; PrintKitDetails) { }
                column(ProdOrderLineItemBarcode; ProdOrderLineItemBarcode) { }
                column(ProdOrderLineBarcodePaddLeft; ProdOrderLineBarcodePaddLeft) { }
                column(ProdOrderNo_ProdOrderLine; "Prod. Order No.") { }
                column(ProductionPlanNo_ProdOrderLine; '' /*TODO ProdOrderLine."Production Plan No."*/) { }
                column(Quantity_ProdOrderLine; Format(ProdOrderLine.Quantity, 0, '<Precision,0:5><Standard Format,0>')) { }
                column(RemainingQuantity_ProdOrderLine; Format(ProdOrderLine."Remaining Quantity", 0, '<Precision,0:5><Standard Format,0>')) { }
                column(SalesOrderLineNo; ProdOrderLine."AltAWPSales Order Line No.") { }
                column(SalesOrderNo; ProdOrderLine."AltAWPSales Order No.") { }
                column(SellToCity; SalesHeader."Ship-to City") { }
                column(SellToCustomerNo; SalesHeader."Sell-to Customer No.") { }
                column(SellToName; SalesHeader."Sell-to Customer Name") { }
                column(ShipmentDate; SalesLine."Shipment Date") { }
                column(ShippingAgentName; ShippingAgentName) { }
                column(ShippingGroupNo_ProdOrderLine; GetShippingGroupNo(SalesLine)) { }
                column(ShipToCity; SalesHeader."Ship-to City") { }
                column(ShipToCode; SalesHeader."Ship-to Code") { }
                column(ShipToName; SalesHeader."Ship-to Name") { }
                column(StartingDate_ProdOrderLine; Format(ProdOrderLine."Starting Date")) { }
                column(Status_ProdOrderLine; ProdOrderLine.Status) { }
                column(SubdividedPhasesKey; SubdividedPhasesKey) { }
                column(SubdividedPhasesKey2; SubdividedPhasesKey2) { }
                column(SubOrderDueDate; Format(SubOrderDueDate)) { }
                column(TargetQty; TargetQty) { DecimalPlaces = 0 : 5; }
                column(UoM_ProdOrderLine; ProdOrderLine."Unit of Measure Code") { }
                column(VariantCode; ProdOrderLine."Variant Code") { }
                column(BarcodeProdOrderLine; BarcodeProdOrderLine) { }
                column(DestConsumptionBin; DestConsumptionBin) { }
                column(FatherProdOrderLineItemNo; FatherProdOrderLine."Item No.") { }
                column(FatherProdOrderLineVariantCode; FatherProdOrderLine."Variant Code") { }
                column(FatherProdOrderLineDescription; FatherProdOrderLine.Description) { }
                column(FatherProdOrderLineDescription2; FatherProdOrderLine."Description 2") { }
                column(FatherProdOrderLinePrevalentOperation; ParentWorkMachineCenter) { }
                column(ReservedBinCode; ReservedBinCode) { }
                column(OutputBinBarcode; ReservedBinBarcode) { }
                column(FatherConsBinBarcode; FatherConsBinBarcode) { }
                column(SendAheadQty; SendAheadQty) { }
                column(TubsQty; TubsQty) { }
                column(TubsQuantityPer; TubsQuantityPer) { }
                column(ProductionNotes; "ecProduction Notes") { }
                column(PlanningNotes; "ecPlanning Notes") { }

                dataitem(ProdOrderCommentLine; "Prod. Order Comment Line")
                {
                    DataItemLink = Status = field(Status),
                                   "Prod. Order No." = field("Prod. Order No.");
                    DataItemTableView = sorting(Status, "Prod. Order No.", "Line No.")
                                        order(ascending);

                    trigger OnAfterGetRecord()
                    begin
                        Temp_ProdOrderCommentLine := ProdOrderCommentLine;
                        Temp_ProdOrderCommentLine.Insert();
                    end;

                    trigger OnPreDataItem()
                    begin
                        ExistsProdOrderCommentLine := not ProdOrderCommentLine.IsEmpty;
                    end;
                }
                dataitem(CommentLine; "Comment Line")
                {
                    DataItemLink = "No." = field("Item No.");
                    DataItemTableView = sorting("Table Name", "No.", "Line No.")
                                        order(ascending)
                                        where("Table Name" = const(Item));

                    trigger OnAfterGetRecord()
                    begin
                        Temp_CommentLine := CommentLine;
                        Temp_CommentLine.Insert();
                    end;

                    trigger OnPreDataItem()
                    begin
                        ExistsCommentLine := not CommentLine.IsEmpty;
                    end;
                }
                dataitem(ProdOrderRoutingLine; "Prod. Order Routing Line")
                {
                    DataItemLink = Status = field(Status),
                                   "Prod. Order No." = field("Prod. Order No."),
                                   "Routing Reference No." = field("Routing Reference No."),
                                   "Routing No." = field("Routing No.");
                    DataItemLinkReference = ProdOrderLine;
                    DataItemTableView = sorting(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.")
                                        order(ascending);

                    column(ArrayHeaderTotal1; ArrayHeaderTotal[1]) { }
                    column(ArrayHeaderTotal2; ArrayHeaderTotal[2]) { }
                    column(ArrayHeaderTotal3; ArrayHeaderTotal[3]) { }
                    column(ArrayHeaderTotal4; ArrayHeaderTotal[4]) { }
                    column(ArrayHeaderTotal5; ArrayHeaderTotal[5]) { }
                    column(ArrayHeaderTotal6; ArrayHeaderTotal[6]) { }
                    column(Barcode_ProdOrderRoutingLine; Barcode_HumanCode) { }
                    column(OpBarcode; OpBarcode) { }
                    column(CurrOperation; CurrOperation) { }
                    column(ExistsCommentLine; ExistsCommentLine) { }
                    column(ExistsProdOrderCommentLine; ExistsProdOrderCommentLine) { }
                    column(No_ProdOrderRoutingLine; ProdOrderRoutingLine."No.") { }
                    column(OperationIDC128_ProdOrderRoutingLine; Barcode) { }
                    column(OperationNo_ProdOrderRoutingLine; ProdOrderRoutingLine."Operation No.") { }
                    column(OperationText; OperationText) { }
                    column(ProdOrderNo_ProdOrderRoutingLine; ProdOrderRoutingLine."Prod. Order No.") { }
                    column(ProdOrderRoutingLineGroup; 1) { }
                    column(RoutingInstructionDescr; RoutingInstructionDescr) { }
                    column(RoutingLinkCode_ProdOrderRoutingLine; ProdOrderRoutingLine."Routing Link Code") { }
                    column(RoutingNo_ProdOrderRoutingLine; ProdOrderRoutingLine."Routing No.") { }
                    column(RoutingReferenceNo_ProdOrderRoutingLine; ProdOrderRoutingLine."Routing Reference No.") { }
                    column(RoutingStatus_ProdOrderRoutingLine; "Routing Status") { }
                    column(RtngLineNoDescr; RtngLineNoDescr) { }
                    column(RtngRemainingOutputQty; RtngRemainingOutputQty) { }
                    column(RtngTotalOutputQty; RtngTotalOutputQty) { DecimalPlaces = 0 : 2; }
                    column(RunTime_ProdOrderRoutingLine; ProdOrderRoutingLine."Run Time") { }
                    column(RunTimeUnitMeasCode_ProdOrderRoutingLine; RunTimeUnitOfMeas) { }
                    column(SetupTime_ProdOrderRoutingLine; "Setup Time") { }
                    column(SetupTimeUnitMeasCode_ProdOrderRoutingLine; SetupTimeUnitOfMeas) { }
                    column(StandardTaskCode_ProdOrderRoutingLine; ProdOrderRoutingLine."Standard Task Code") { }
                    column(StandardTaskDescription_ProdOrderRoutingLine; StandardTaskDescription) { }
                    column(Status_ProdOrderRoutingLine; ProdOrderRoutingLine.Status) { }
                    column(SubdividedPhases; SubdividedPhases) { }
                    column(TotalOperation; TotalOperation) { }
                    column(Type_ProdOrderRoutingLine; RtngLineType) { }
                    column(WaitTime_ProdOrderRoutingLine; "Wait Time") { }
                    column(WaitTimeUnitofMeas; WaitTimeUnitofMeas) { }
                    column(WorkCenterName_ProdOrderRoutingLine; WorkCenter.Name) { }
                    column(WorkCenterNo_ProdOrderRoutingLine; ProdOrderRoutingLine."Work Center No.") { }

                    trigger OnAfterGetRecord()
                    var
                        lPurchaseLine: Record "Purchase Line";
                        lWorkCenterNo: Code[20];
                    begin
                        CurrOperation += 1;

                        Clear(Barcode);
                        Clear(Barcode_HumanCode);
                        Clear(OpBarcode);
                        Barcode_HumanCode := AltAWP_GetOperationBarcodeString();

                        if (Barcode_HumanCode <> '') then begin
                            Barcode_HumanCode := BarcodeSetup."Bin Barcode Prefix" + BarcodeSetup."Barcode Elements Separator" + Barcode_HumanCode;
                            OpBarcode := awpBarcodeFunctions.MakeBarcode(Barcode_HumanCode, Enum::"AltATSBarcode Symbology"::"Code 128", 1, 18, false, 0);
                        end;

                        Clear(BarcodeInStream);
                        TempBlob.CreateInStream(BarcodeInStream);
                        OpIDBase64String := Base64Convert.ToBase64(BarcodeInStream);

                        Clear(RtngLineType);
                        Clear(RtngLineNoDescr);
                        case Type of
                            Type::"Machine Center":
                                begin
                                    RtngLineType := MachineCenterTxt;
                                    if MachineCenter.Get("No.") then begin
                                        RtngLineNoDescr := MachineCenter.Name;
                                    end;
                                end;
                            Type::"Work Center":
                                begin
                                    RtngLineType := WorkCenterTxt;
                                    if WorkCenter.Get("No.") then begin
                                        RtngLineNoDescr := WorkCenter.Name;
                                    end;
                                end;
                        end;

                        RoutingInstructionDescr := StrSubstNo(Txt002, ProdOrderRoutingLine."Operation No.", ProdOrderRoutingLine.Description);
                        ProdOrderRoutingLineCurrRec += 1;

                        if SubdividedPhases then begin
                            if (ProdOrderRoutingLineCurrRec > 1) then begin
                                if ("Operation No." <> PrevOperationNo) then begin
                                    SubdividedPhasesKey += 1;
                                end;
                            end;
                        end;

                        Clear(ExternalOperation);
                        Clear(lWorkCenterNo);
                        if SubdividedPhases then begin
                            ExternalOperation := IsExternalOperation(ProdOrderRoutingLine);
                        end;

                        Clear(SubOrderDueDate);
                        if ExternalOperation then begin
                            SubOrderDueDate := ProdOrderLine."Due Date";
                            Clear(lPurchaseLine);
                            lPurchaseLine.SetRange("Prod. Order No.", "Prod. Order No.");
                            lPurchaseLine.SetRange("Routing Reference No.", "Routing Reference No.");
                            lPurchaseLine.SetRange("Routing No.", "Routing No.");
                            lPurchaseLine.SetRange("Operation No.", "Operation No.");
                            if lPurchaseLine.FindFirst() then begin
                                SubOrderDueDate := lPurchaseLine."Expected Receipt Date";
                            end;
                        end;

                        PrevOperationNo := "Operation No.";

                        StandardTaskDescription := "Standard Task Code";
                        if StandardTask.Get("Standard Task Code") then begin
                            StandardTaskDescription := StandardTaskDescription + ' - ' + StandardTask.Description;
                        end;

                        OperationText := StrSubstNo(lblOperation, "Operation No.");

                        Clear(SetupTimeUnitOfMeas);
                        if ("Setup Time" <> 0) then SetupTimeUnitOfMeas := "Setup Time Unit of Meas. Code";

                        Clear(WaitTimeUnitofMeas);
                        if ("Wait Time" <> 0) then begin
                            WaitTimeUnitofMeas := "Wait Time Unit of Meas. Code";
                        end;

                        Clear(RunTimeUnitOfMeas);
                        if ("Run Time" <> 0) then RunTimeUnitOfMeas := "Run Time Unit of Meas. Code";

                        if ClearLogo then begin
                            Clear(CompanyInfo.Picture);
                        end;
                        ClearLogo := true;

                        Clear(RtngTotalOutputQty);
                        RtngTotalOutputQty := CostCalculationManagement.CalcQtyAdjdForRoutingScrap(ProdOrderLine."Quantity (Base)", ProdOrderRoutingLine."Scrap Factor % (Accumulated)", ProdOrderRoutingLine."Fixed Scrap Qty. (Accum.)");
                        RtngTotalOutputQty := RtngTotalOutputQty / ProdOrderLine."Qty. per Unit of Measure";

                        Clear(RtngRemainingOutputQty);
                        RtngRemainingOutputQty := RtngTotalOutputQty - CostCalculationManagement.CalcActOutputQtyBase(ProdOrderLine, ProdOrderRoutingLine);
                        if (RtngRemainingOutputQty < 0) then RtngRemainingOutputQty := 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        //TODO SETRANGE("Not Print Production Note", FALSE);

                        TotalOperation := ProdOrderRoutingLine.Count;
                        CurrOperation := 0;

                        ProdOrderRoutingLineCurrRec := 0;
                        PrevOperationNo := '';
                        SubdividedPhasesKey := 1;
                        SubdividedPhasesKey2 := 1;
                    end;
                }
                dataitem(ProdOrderComponent; "Prod. Order Component")
                {
                    DataItemLink = Status = field(Status),
                                   "Prod. Order No." = field("Prod. Order No."),
                                   "Prod. Order Line No." = field("Line No.");
                    DataItemTableView = sorting(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.")
                                        order(ascending);

                    column(ComponentBarcode; ComponentBarcode) { }
                    column(Description2_ProdOrderComponent; ProdOrderComponentDesc2) { }
                    column(Description_ProdOrderComponent; ProdOrderComponent.Description) { }
                    column(ExpectedQty_ProdOrderComponent; ProdOrderComponent."Expected Quantity") { }
                    column(ItemComponentBarcode; OpIDBase64String) { }
                    column(ItemDimension_ProdOrderComponent; ItemDimension) { }
                    column(ItemNo_ProdOrderComponent; ProdOrderComponent."Item No.") { }
                    column(LineNo_ProdOrderComponent; ProdOrderComponent."Line No.") { }
                    column(LocationCode_ProdOrderComponent; ProdOrderComponent."Location Code") { }
                    column(Material_ProdOrderComponent; MaterialTextComp) { }
                    column(OperationNo; OperationNo) { }
                    column(Position_ProdOrderComponent; ProdOrderComponent.Position) { }
                    column(ProdOrderComponentGroup; 1) { }
                    column(ProdOrderLineNo_ProdOrderComponent; ProdOrderComponent."Prod. Order Line No.") { }
                    column(ProdOrderNo_ProdOrderComponent; ProdOrderComponent."Prod. Order No.") { }
                    column(QtyPer_ProdOrderComponent; ProdOrderComponent."Quantity per")
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(RemainingQty_ProdOrderComponent; ProdOrderComponent."Remaining Quantity") { }
                    column(RoutingLinkCode_ProdOrderComponent; ProdOrderComponent."Routing Link Code") { }
                    column(ShelfNo_ProdOrderComponent; ItemShelfNo) { }
                    column(Status_ProdOrderComponent; ProdOrderComponent.Status) { }
                    column(UoM_ProdOrderComponent; ProdOrderComponent."Unit of Measure Code") { }
                    column(VariantCode_ProdOrderComponent; ProdOrderComponent."Variant Code") { }
                    column(TubsQuantityPerComponent; TubsQuantityPerComponent) { }

                    trigger OnAfterGetRecord()
                    var
                        lItemVariant: Record "Item Variant";
                        lProdOrderRoutingLine: Record "Prod. Order Routing Line";
                    begin
                        if not Item.Get("Item No.") then Clear(Item);

                        ProdOrderComponentDesc2 := Item."Description 2";

                        if lItemVariant.Get("Item No.", "Variant Code") then begin
                            if (lItemVariant.Description <> '') then begin
                                ProdOrderComponent.Description := lItemVariant.Description;
                            end;
                            if (lItemVariant."Description 2" <> '') then begin
                                ProdOrderComponentDesc2 := lItemVariant."Description 2";
                            end;
                        end;

                        ItemComponentBarcode := '';
                        ComponentBarcode := '';
                        if ("Item No." <> '') then begin
                            ItemComponentBarcode := BarcodeSetup."Item Barcode Prefix" + BarcodeSetup."Barcode Elements Separator" + "Item No.";
                            ComponentBarcode := awpBarcodeFunctions.MakeBarcode(ItemComponentBarcode, Enum::"AltATSBarcode Symbology"::"Code 128", 1, 18, false, 0);
                        end;

                        Clear(BarcodeInStream);
                        TempBlob.CreateInStream(BarcodeInStream);
                        ItemBase64String := Base64Convert.ToBase64(BarcodeInStream);

                        Clear(OperationNo);
                        Clear(lProdOrderRoutingLine);
                        lProdOrderRoutingLine.SetRange(Status, ProdOrderComponent.Status);
                        lProdOrderRoutingLine.SetRange("Prod. Order No.", ProdOrderComponent."Prod. Order No.");
                        lProdOrderRoutingLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
                        lProdOrderRoutingLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
                        lProdOrderRoutingLine.SetRange("Routing Link Code", ProdOrderComponent."Routing Link Code");
                        if lProdOrderRoutingLine.FindLast() then begin
                            OperationNo := lProdOrderRoutingLine."Operation No.";
                        end;

                        TubsQuantityPerComponent := Round(ProdOrderComponent."Quantity per" * TubsTargetQty, 1, '>');
                        TubsQuantityPer += TubsQuantityPerComponent;
                    end;
                }

                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                var
                    lLocation: Record Location;
                    lProdOrderComponent: Record "Prod. Order Component";
                    lProdOrderRoutingLine: Record "Prod. Order Routing Line";
                    lAWPProductionFunctions: Codeunit "AltAWPProduction Functions";
                begin
                    ProdOrderLineItemBarcode := BarcodeSetup."Item Barcode Prefix" + BarcodeSetup."Barcode Elements Separator" + "Item No.";
                    ProdOrderLineItemBarcode := awpBarcodeFunctions.MakeBarcode(ProdOrderLineItemBarcode, Enum::"AltATSBarcode Symbology"::"Code 128", 1, 18, false, 0);

                    BarcodeProdOrderLine := BarcodeSetup."Document Barcode Prefix" + BarcodeSetup."Barcode Elements Separator" +
                                            "Prod. Order No." + BarcodeSetup."Barcode Elements Separator" + Format("Line No.");
                    BarcodeProdOrderLine := awpBarcodeFunctions.MakeBarcode(BarcodeProdOrderLine, Enum::"AltATSBarcode Symbology"::"Code 128", 1, 18, false, 0);

                    ProdOrderLine.CalcFields("AltAWPSales Order No.", "AltAWPSales Order Line No.");
                    if not SalesHeader.Get(SalesHeader."Document Type"::Order, ProdOrderLine."AltAWPSales Order No.") then begin
                        Clear(SalesHeader);
                    end;

                    if not SalesLine.Get(SalesHeader."Document Type"::Order, ProdOrderLine."AltAWPSales Order No.", ProdOrderLine."AltAWPSales Order Line No.") then begin
                        Clear(SalesLine);
                    end;

                    DepotCode := '';
                    if lLocation.Get(ProductionOrder."Location Code") then begin
                        DepotCode := lLocation."AltAWPBranch Code";
                    end;

                    DeliveryAreaName := '';

                    if not DeliveryArea.Get(DeliveryArea."Record Type"::"Area", SalesHeader."AltAWPDelivery Area Code") then begin
                        Clear(DeliveryArea);
                    end;
                    DeliveryAreaName := DeliveryArea.Name;

                    DestConsumptionBin := '';
                    FatherConsBinBarcode := '';
                    Clear(lProdOrderComponent);
                    lProdOrderComponent.SetRange(Status, Status);
                    lProdOrderComponent.SetRange("Prod. Order No.", "Prod. Order No.");
                    lProdOrderComponent.SetRange("Item No.", "Item No.");
                    lProdOrderComponent.SetRange("Supplied-by Line No.", "Line No.");
                    if not lProdOrderComponent.IsEmpty then begin
                        lProdOrderComponent.FindFirst();
                        FatherProdOrderLine.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.", lProdOrderComponent."Prod. Order Line No.");
                        DestConsumptionBin := lProdOrderComponent."Bin Code";

                        FatherConsBinBarcode := BarcodeSetup."Bin Barcode Prefix" + BarcodeSetup."Barcode Elements Separator" + DestConsumptionBin;
                        FatherConsBinBarcode := awpBarcodeFunctions.MakeBarcode(FatherConsBinBarcode, Enum::"AltATSBarcode Symbology"::"Code 128", 1, 30, false, 0);
                    end;

                    ParentWorkMachineCenter := '';
                    Clear(lProdOrderRoutingLine);
                    lProdOrderRoutingLine.SetRange(Status, FatherProdOrderLine.Status);
                    lProdOrderRoutingLine.SetRange("Prod. Order No.", FatherProdOrderLine."Prod. Order No.");
                    lProdOrderRoutingLine.SetRange("Routing Reference No.", FatherProdOrderLine."Routing Reference No.");
                    lProdOrderRoutingLine.SetRange("Routing No.", FatherProdOrderLine."Routing No.");
                    lProdOrderRoutingLine.SetRange("Routing Link Code", lProdOrderComponent."Routing Link Code");
                    if not lProdOrderRoutingLine.IsEmpty then begin
                        lProdOrderRoutingLine.FindLast();
                        ParentWorkMachineCenter := lProdOrderRoutingLine."No.";
                    end;

                    ReservedBinBarcode := '';
                    ReservedBinCode := lAWPProductionFunctions.GetProdOrderLineReservedConsumptionBin(ProdOrderLine, false);
                    if (ReservedBinCode <> '') then begin
                        ReservedBinBarcode := BarcodeSetup."Bin Barcode Prefix" + BarcodeSetup."Barcode Elements Separator" + ReservedBinCode;
                        ReservedBinBarcode := awpBarcodeFunctions.MakeBarcode(ReservedBinBarcode, Enum::"AltATSBarcode Symbology"::"Code 128", 1, 18, false, 0);
                    end;

                    TubsQty := 0;
                    TubsTargetQty := 0;
                    SendAheadQty := ProdOrderLine."ecSend-Ahead Quantity";
                    if (SendAheadQty <> 0) then TubsQty := Round(ProdOrderLine."Remaining Qty. (Base)" / SendAheadQty, 1, '>');
                    if (TubsQty <> 0) then TubsTargetQty := ProdOrderLine."Remaining Qty. (Base)" / TubsQty;
                    TubsQuantityPer := 0;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
        ReportTitle_Label = 'WORK SHEET';
        ODP_Label = 'Production order no.';
        Job_Label = 'Job No.';
        JobTask_Label = 'Task No.';
        CustRef_Label = 'Customer Ref.';
        JobSellToCust_Label = 'Customer';
        JobCustMachineNo_Label = 'Customer machine no.';
        StartingDate_Label = 'Start date';
        EndingDate_Label = 'End date';
        LineNo_Label = 'Row No.';
        ItemNo_Label = 'Item no.';
        Description_Label = 'Description';
        Draw_Label = 'Draw';
        DrawRelease_Label = 'Rev. Disegno';
        Quantity_Label = 'Quantity';
        RoutingTitle_Label = 'Prod. Order Routing';
        OperationID_Label = 'Operation ID';
        Operation_Label = 'Oper.';
        Task_Label = 'Task';
        RtngLineType_Label = 'Type';
        RtngLineNo_Label = 'Work Center/Machine Centr';
        RoutingLink_Label = 'Link';
        RunTime_Label = 'Unit Work Time';
        SetupTime_Label = 'Setup time';
        Min_Label = 'Min';
        Min_Label2 = 'Minutes';
        Hour_Label = 'Hours';
        TotRunTimePz_Label = 'Work time/unit';
        TotSetupTime_Label = 'Setup time';
        TotRunTime = 'Total work time';
        TotalWorkTime = 'Production total time';
        ComponentsTitle_Label = 'Lista riepilogativa dei materiali';
        CompLinePosTitle_Label = 'Pos.';
        CompItemNoTitle_Label = 'Item';
        CompDescrTitle_Label = 'Description';
        CompMatTypeTitle_Label = 'Material';
        CompUoMTitle_Label = 'UM';
        CompQtyPerTitle_Label = 'Qty per';
        CompExpQtyTitle_Label = 'Total Q.ty';
        CompDimensionTitle_Label = 'Dimension';
        RtngToolTitle_Label = 'Lista riepilogativa delle attrezzature';
        RtngToolOperNoTitle_Label = 'Operation';
        RtngToolNoTitle_Label = 'Code';
        RtngToolDescrTitle_Label = 'Description';
        RtngCommentTitle_Label = 'Working method';
        RtngCommOperNoTitle_Label = 'Operation';
        RtngCommNoteTitle_Label = 'Notes';
        PageNo_Caption = 'Page';
        ExtText_Caption = 'Item additional information';
        CommOrd_Caption = 'Notes';
        WorkingNotes = 'Working notes';
        ProductionNote = 'Production note';
        TotalTime_Label = 'Total time';
        Variant_Label = 'Variant';
        ProcessingInstruction_Label = 'Working instruction';
        Depot_Label = 'Depot';
        Location_Label = 'Location';
        ProdPlan_Label = 'Production Plan';
        Name_Label = 'Name';
        City_Label = 'City';
        DeliveryArea_Label = 'Delivery Area';
        ReceivePlan_Label = 'Receive Plan';
        ExpirationDate_Label = 'Expiration Date';
        SaleOrder_Label = 'Sale Order';
        Bin_Label = 'Bin';
        ControlNotes_Label = 'Quality control note:';
        DeclarationTime_Label = 'Declaration of time';
        Operator_Label = 'Operator';
        Start_Label = 'Start';
        End_Label = 'End';
        Qty_Label = 'Quantity';
        TotMin_Label = 'Total minutes';
        PackagingDetail_Label = 'Packaging detail';
        WithdrawalNotes_Label = 'Withdrawal Notes';
        FreightType_Label = 'Freight Type';
        ShipmentDate_Label = 'Shipment date';
        VsOfferta_Label = 'Vs. Offerta';
        NsOfferta_Label = 'Ns. Offerta';
        VsOrdine_Label = 'Vs. Ordine';
        VsRiferimento_Label = 'Vs. Riferimento';
        VsCodice_Label = 'Vs. Codice';
        VsDisegno_Label = 'Vs. Disegno';
        PxUnitario_Label = 'Px Unitario';
        Quantita_Label = 'Quantità';
        QuantitaResidua_Label = 'Q.tà Residua';
        QuantitaTotale_Label = 'Q.tà Totale';
        Residuo_Label = 'Residuo';
        Totale_Label = 'Totale';
        Progettazione_Label = 'DESIGN';
        QtaRiferimento_Label = 'Reference Qty:';
        QtaDimensioneLotto_Label = 'Lot Dimension Qty';
        NrElemento_Label = 'Element No.';
        DescrizioneComponente_Label = 'Element Description';
        QtaPerKit_Label = 'Quantity';
        Riferimento_Label = 'Reference';
        Spedizioniere_Label = 'Shipper';
        MaterialeConforme_Label = 'Material Compliant';
        Operatore_Label = 'Operator';
        ControlliConformita_Label = 'CONTROLLI DI CONFORMITA'' - MISURE RILEVATE';
        UM_Label = 'UM';
        C_Label = 'C';
        NC_Label = 'NC';
        WaitingTime_Label = 'Waiting time';
        OperationNo_Label = 'Operation Code';
        OperationQty_Label = 'Operation Qty';
        Destination_Label = 'Destination item';
        WorkMachineCenter_Label = 'Work/Machine center';
        ConsumptionBin_Label = 'Consumption bin';
        ReservedBin_Label = 'Reserved bin';
        Code_Label = 'Code';
        TubsQtyPer_Label = 'Tub qty per';
        SendAheadQty_Label = 'Send Ahead Qty';
        TubsQty_Label = 'Tubs no.';
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);

        SubdividedPhases := false;
    end;

    trigger OnPreReport()
    begin
        SubdividedPhasesKey := 0;
        SubdividedPhasesKey2 := 0;
        ClearLogo := false;

        BarcodeSetup.GetGeneralSetup();
        BarcodeSetup.TestField("Item Barcode Prefix");
        BarcodeSetup.TestField("Barcode Elements Separator");
    end;

    var
        BarcodeSetup: Record "AltAWPBarcode Setup";
        Temp_CommentLine: Record "Comment Line" temporary;
        CompanyInfo: Record "Company Information";
        FatherProdOrderLine: Record "Prod. Order Line";
        Item: Record Item;
        MachineCenter: Record "Machine Center";
        Temp_ProdOrderCommentLine: Record "Prod. Order Comment Line" temporary;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        StandardTask: Record "Standard Task";
        WorkCenter: Record "Work Center";
        DeliveryArea: Record "AltAWPDelivery Area";
        awpBarcodeFunctions: Codeunit "AltAWPBarcode Functions";
        Base64Convert: Codeunit "Base64 Convert";
        CostCalculationManagement: Codeunit "Cost Calculation Management";
        TempBlob: Codeunit "Temp Blob";
        ClearLogo: Boolean;
        ExistsCommentLine: Boolean;
        ExistsProdOrderCommentLine: Boolean;
        ExternalOperation: Boolean;
        HideDesignCardExternalRefBool: Boolean;
        HideDesignCardKitsDetailBool: Boolean;
        PrintKitDetails: Boolean;
        SubdividedPhases: Boolean;
        ItemShelfNo: Code[10];
        OperationNo: Code[10];
        PrevOperationNo: Code[10];
        DepotCode: Code[20];
        DimSede: Code[20];
        JobNo: Code[20];
        JobTaskNo: Code[20];
        DestConsumptionBin: Code[20];
        ReservedBinCode: Code[20];
        CustRef: Code[50];
        SubOrderDueDate: Date;
        ArrayHeaderTotal: array[20] of Decimal;
        LotSizeQty: Decimal;
        RtngRemainingOutputQty: Decimal;
        RtngTotalOutputQty: Decimal;
        TargetQty: Decimal;
        TubsQty: Decimal;
        TubsTargetQty: Decimal;
        TubsQuantityPer: Decimal;
        TubsQuantityPerComponent: Decimal;
        SendAheadQty: Decimal;
        BarcodeInStream: InStream;
        CurrOperation: Integer;
        ProdOrderRoutingLineCurrRec: Integer;
        SubdividedPhasesKey: Integer;
        SubdividedPhasesKey2: Integer;
        TotalOperation: Integer;
        lblODVNo: Label 'Ordine di vendita';
        lblOperation: Label ' - Operation %1';
        lblOperation2: Label 'Operation';
        lblProcessingInstruction: Label 'ISTRUZIONI DI LAVORAZIONE';
        lblProcessingMethod: Label 'METODO DI LAVORAZIONE';
        lblTask: Label 'Task';
        MachineCenterTxt: Label 'Centro Lav.';
        Txt002: Label 'OPERAZIONE %1 - %2';
        WorkCenterTxt: Label 'Area produz.';
        ComponentBarcode: Text;
        DeliveryAreaName: Text;
        ImageBase64String: Text;
        ItemBase64String: Text;
        ItemComponentBarcode: Text;
        JobCustMachineNo: Text;
        JobSellToCustName: Text;
        MandatoryLotNoText: Text;
        MaterialTextComp: Text;
        OdvReference: Text;
        OperationText: Text;
        OpIDBase64String: Text;
        ProdOrderComponentDesc2: Text;
        ParentWorkMachineCenter: Text;
        ProdOrderLineItemBarcode: Text;
        RoutingInstructionDescr: Text;
        ShippingAgentName: Text;
        StandardTaskDescription: Text;
        WaitTimeUnitofMeas: Text;
        RunTimeUnitOfMeas: Text;
        SetupTimeUnitOfMeas: Text;
        ProdOrderLineBarcodePaddLeft: Text;
        OpBarcode: Text;
        BarcodeProdOrderLine: Text;
        ReservedBinBarcode: Text;
        FatherConsBinBarcode: Text;
        CustomerName: Text[50];
        RtngLineType: Text[50];
        ItemDimension: Text[100];
        RtngLineNoDescr: Text[100];
        Barcode: Text[250];
        Barcode_HumanCode: Text[250];

    procedure SetParameters(pHideTimes: Boolean; pSubdividedPhases: Boolean)
    begin
        //PR24-s
        SubdividedPhases := pSubdividedPhases;
        //PR24-e
    end;

    local procedure IsExternalOperation(pProdOrderRoutingLine: Record "Prod. Order Routing Line") rIsExternalOperation: Boolean
    var
        lMachineCenter: Record "Machine Center";
        lWorkCenter: Record "Work Center";
        lWorkCenterNo: Code[20];
    begin
        //PR29-s
        Clear(rIsExternalOperation);
        Clear(lWorkCenterNo);
        lWorkCenterNo := pProdOrderRoutingLine."No.";
        if (pProdOrderRoutingLine.Type = pProdOrderRoutingLine.Type::"Machine Center") then begin
            Clear(lMachineCenter);
            if lMachineCenter.Get(ProdOrderRoutingLine."No.") then begin
                lWorkCenterNo := lMachineCenter."No.";
            end;
        end;

        if (lWorkCenterNo <> '') then begin
            if lWorkCenter.Get(lWorkCenterNo) and (lWorkCenter."Subcontractor No." <> '') then begin
                rIsExternalOperation := true;
            end;
        end;

        exit(rIsExternalOperation);
        //PR29-e
    end;

    procedure GetShippingGroupNo(pSalesLine: Record "Sales Line") rShippingGroupNo: Code[20]
    var
        lWarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        Clear(rShippingGroupNo);

        pSalesLine.CalcFields("AltAWPWarehouse Shipment No.");

        if (pSalesLine."AltAWPWarehouse Shipment No." <> '') and lWarehouseShipmentHeader.Get(pSalesLine."AltAWPWarehouse Shipment No.") then begin
            rShippingGroupNo := lWarehouseShipmentHeader."AltAWPShipping Group No.";
        end;

        exit(rShippingGroupNo);
    end;
}
