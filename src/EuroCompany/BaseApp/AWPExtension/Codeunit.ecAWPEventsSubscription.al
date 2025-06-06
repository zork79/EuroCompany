namespace EuroCompany.BaseApp.AWPExtension;

using EuroCompany.BaseApp.Inventory;
using EuroCompany.BaseApp.Manufacturing;
using EuroCompany.BaseApp.Purchases.Reports;
using EuroCompany.BaseApp.Restrictions;
using EuroCompany.BaseApp.Sales;
using EuroCompany.BaseApp.Sales.Reports;
using EuroCompany.BaseApp.Warehouse.Pallets;
using EuroCompany.BaseApp.Warehouse.Reports;
using Microsoft.Finance.Currency;
using Microsoft.Foundation.Reporting;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Manufacturing.Document;
using Microsoft.Purchases.Document;
using Microsoft.Sales.Comment;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;
using Microsoft.Warehouse.Activity;
using Microsoft.Warehouse.Document;
using Microsoft.Warehouse.History;
using Microsoft.Warehouse.Journal;
using Microsoft.Warehouse.Ledger;
using Microsoft.Warehouse.Setup;

codeunit 50005 "ecAWPEvents Subscription"
{
    #region Table

    #region Logistic Unit Detail

    [EventSubscriber(ObjectType::Table, Database::"AltAWPLogistic Unit Detail", 'OnBeforeShowLotNoInfoCard', '', false, false)]
    local procedure AWPLogisticUnitDetail_OnBeforeShowLotNoInfoCard(var AWPLogisticUnitDetail: Record "AltAWPLogistic Unit Detail"; var TrackingSpecification: Record "Tracking Specification")
    var
        lLotNoInformation: Record "Lot No. Information";
        lPurchaseHeader: Record "Purchase Header";
    begin
        //CS_PRO_008-s
        if not lLotNoInformation.Get(AWPLogisticUnitDetail."Item No.", AWPLogisticUnitDetail."Variant Code", AWPLogisticUnitDetail."Lot No.") then begin
            TrackingSpecification."Expiration Date" := AWPLogisticUnitDetail."Expiration Date";
            if (AWPLogisticUnitDetail."Whse. Document Type" = AWPLogisticUnitDetail."Whse. Document Type"::Receipt) and
            (AWPLogisticUnitDetail."Whse. Document No." <> '') and (AWPLogisticUnitDetail."Source Type" = Database::"Purchase Line")
            then begin
                TrackingSpecification."ecCreation Process" := TrackingSpecification."ecCreation Process"::"Purchase Receipt";
                if lPurchaseHeader.Get(lPurchaseHeader."Document Type"::Order, AWPLogisticUnitDetail."Source ID") then begin
                    TrackingSpecification."Vendor No." := lPurchaseHeader."Buy-from Vendor No.";
                end;
            end;
        end;
        //CS_PRO_008-e
    end;

    [EventSubscriber(ObjectType::Table, Database::"AltAWPLogistic Unit Detail", 'OnAfterShowLotNoInfoCard', '', false, false)]
    local procedure AWPLogisticUnitDetail_OnAfterShowLotNoInfoCard(var AWPLogisticUnitDetail: Record "AltAWPLogistic Unit Detail"; var TrackingSpecification: Record "Tracking Specification")
    var
        lLotNoInformation: Record "Lot No. Information";
        lAWPLogisticUnitDetail2: Record "AltAWPLogistic Unit Detail";
        lRecUpdated: Boolean;
    begin
        //CS_PRO_008-s
        //Receipt 
        lRecUpdated := false;
        if (AWPLogisticUnitDetail."Whse. Document Type" = AWPLogisticUnitDetail."Whse. Document Type"::Receipt) then begin
            if lLotNoInformation.Get(AWPLogisticUnitDetail."Item No.", AWPLogisticUnitDetail."Variant Code", AWPLogisticUnitDetail."Lot No.") then begin
                Clear(lAWPLogisticUnitDetail2);
                lAWPLogisticUnitDetail2.SetRange("Item No.", AWPLogisticUnitDetail."Item No.");
                lAWPLogisticUnitDetail2.SetRange("Variant Code", AWPLogisticUnitDetail."Variant Code");
                lAWPLogisticUnitDetail2.SetRange("Lot No.", AWPLogisticUnitDetail."Lot No.");
                if not lAWPLogisticUnitDetail2.IsEmpty then begin
                    lAWPLogisticUnitDetail2.FindSet();
                    repeat
                        if (lAWPLogisticUnitDetail2."Expiration Date" <> lLotNoInformation."ecExpiration Date") then begin
                            lAWPLogisticUnitDetail2.Validate("Expiration Date", lLotNoInformation."ecExpiration Date");
                            lRecUpdated := true;
                        end;
                        if (lAWPLogisticUnitDetail2."Lot No." <> lLotNoInformation."Lot No.") then begin
                            lAWPLogisticUnitDetail2.Validate("Lot No.", lLotNoInformation."Lot No.");
                            lRecUpdated := true;
                        end;
                        if lRecUpdated then lAWPLogisticUnitDetail2.Modify(true);
                    until (lAWPLogisticUnitDetail2.Next() = 0);
                end;
            end;
        end;
        //CS_PRO_008-e
    end;

    #endregion Logistic Unit Detail

    #region Sales Order Check Buffer
    [EventSubscriber(ObjectType::Table, Database::"AltAWPSales Order Check Buffer", 'OnAfterCopyFromSalesLine', '', false, false)]
    local procedure SalesOrderCheckBuffer_OnAfterCopyFromSalesLine(var Rec: Record "AltAWPSales Order Check Buffer" temporary;
                                                                   SalesLine: Record "Sales Line";
                                                                   SalesHeder: Record "Sales Header";
                                                                   Currency: Record Currency)
    begin
        //CS_VEN_031-VI-s
        Rec."ecSales Manager Code" := SalesHeder."ecSales Manager Code";
        Rec.CalcFields("ecSales Manager Name");
        //CS_VEN_031-VI-e  

        //CS_VEN_032-VI-s
        Rec."ecProduct Segment No." := SalesHeder."ecProduct Segment No.";
        Rec.CalcFields("ecProduct Segment Description");
        //CS_VEN_032-VI-e  

        //CS_VEN_014-VI-s
        Rec."ecConsumer Unit of Measure" := SalesLine."ecConsumer Unit of Measure";
        Rec."ecQty. per Consumer UM" := SalesLine."ecQty. per Consumer UM";
        Rec."ecQuantity (Consumer UM)" := SalesLine."ecQuantity (Consumer UM)";
        Rec."ecUnit Price (Consumer UM)" := SalesLine."ecUnit Price (Consumer UM)";
        //CS_VEN_014-VI-e
    end;
    #endregion Sales Order Check Buffer

    #region Prod. Order Component

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Component", 'OnBeforeUpdateSuppliedProdOrderLine', '', false, false)]
    local procedure ProdOrderComponent_OnBeforeUpdateSuppliedProdOrderLine(var ProdOrderComponent: Record "Prod. Order Component"; var IsHandled: Boolean)
    begin
        //CS_PRO_044-s
        IsHandled := true;
        //CS_PRO_044-e
    end;

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Component", 'OnAfterCheckComponentReadyForPick', '', false, false)]
    local procedure ProdOrderComponent_OnAfterCheckComponentReadyForPick(Rec: Record "Prod. Order Component"; var IsReady: Boolean)
    begin
        //CS_PRO_039-VI-s
        if IsReady then begin
            IsReady := Rec.ecIsComponentReadyForPick();
        end;
        //CS_PRO_039-VI-e        
    end;

    #endregion Prod. Order Component 

    #region Warehouse Shipment Header

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Shipment Header", OnAfterCalcInvoiceDeferralDate, '', false, false)]
    local procedure WarehouseShipmentHeader_OnAfterCalcInvoiceDeferralDate(var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        lSalesFunctions: Codeunit "ecSales Functions";
    begin
        lSalesFunctions.UpdateWhseShptDeferralInvDate(WarehouseShipmentHeader);
    end;

    #endregion Warehouse Shipment Header

    [EventSubscriber(ObjectType::Table, Database::"AltAWPItem Inventory Buffer", 'OnAfterCopyFromOpenWhseEntryQuery', '', false, false)]
    local procedure AWPItemInventoryBuffer_OnAfterCopyFromOpenWhseEntryQuery(var awpItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary)
    var
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_018-s
        if (awpItemInventoryBuffer."Lot No." <> '') then begin
            awpItemInventoryBuffer."ecMax Usable Date" := lProductionFunctions.CalcMaxUsableDateForItem(awpItemInventoryBuffer."Item No.", '', '',
                                                                                                        awpItemInventoryBuffer."Expiration Date");
        end;
        //CS_PRO_018-e
    end;

    #endregion #Table

    #region Comment Line Buffer

    [EventSubscriber(ObjectType::Table, Database::"AltAWPComment Line Buffer", 'OnBeforeInsertSalesCommentLine', '', false, false)]
    local procedure AWPCommentLineBuffer_OnBeforeInsertSalesCommentLine(var AWPCommentLineBuffer: Record "AltAWPComment Line Buffer" temporary; var SalesCommentLine: Record "Sales Comment Line")
    begin
        //CS_VEN_034-s
        AWPCommentLineBuffer."ecProduct Segment No." := SalesCommentLine."ecProduct Segment No.";
        //CS_VEN_034-e
    end;

    #endregion Comment Line Buffer

    #region Codeunit

    #region Edit/Undo Documents
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPEdit/Undo Documents", OnBeforeModifyPostedWhseShipmentHeader, '', false, false)]
    local procedure "AltAWPEdit/Undo Documents_OnBeforeModifyPostedWhseShipmentHeader"(var SourcePostedWhseShipmentHeader: Record "Posted Whse. Shipment Header"; EditPostedWhseShipmentHeader: Record "Posted Whse. Shipment Header")
    begin
        //#229
        SourcePostedWhseShipmentHeader.Validate("ecAllow Adjmt. In Ship/Receipt", EditPostedWhseShipmentHeader."ecAllow Adjmt. In Ship/Receipt");
        //#229

        //CS_LOG_001-s
        SourcePostedWhseShipmentHeader."ecNo. Parcels" := EditPostedWhseShipmentHeader."ecNo. Parcels";
        SourcePostedWhseShipmentHeader."ecManual Parcels" := EditPostedWhseShipmentHeader."ecManual Parcels";
        //CS_LOG_001-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPEdit/Undo Documents", OnBeforeModifyPostedWhseReceiptHeader, '', false, false)]
    local procedure "AltAWPEdit/Undo Documents_OnBeforeModifyPostedWhseReceiptHeader"(var SourcePostedWhseReceiptHeader: Record "Posted Whse. Receipt Header"; EditPostedWhseReceiptHeader: Record "Posted Whse. Receipt Header")
    begin
        //#229
        SourcePostedWhseReceiptHeader.Validate("ecAllow Adjmt. In Ship/Receipt", EditPostedWhseReceiptHeader."ecAllow Adjmt. In Ship/Receipt");
        //#229
    end;

    #endregion Edit/Undo Documents

    #region Item Journal Functions

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPItem Journal Functions", 'OnAfterItemJnlLineAllignComponents', '', false, false)]
    local procedure AWPItemJournalFunctions_OnAfterItemJnlLineAllignComponents(var pItemJournalLine: Record "Item Journal Line")
    var
        lItemJournalLine2: Record "Item Journal Line";
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_035-s
        Clear(lItemJournalLine2);
        lItemJournalLine2.SetRange("Journal Template Name", pItemJournalLine."Journal Template Name");
        lItemJournalLine2.SetRange("Journal Batch Name", pItemJournalLine."Journal Batch Name");
        lItemJournalLine2.SetRange("Order Type", pItemJournalLine."Order Type");
        lItemJournalLine2.SetRange("Order No.", pItemJournalLine."Order No.");
        lItemJournalLine2.SetRange("Order Line No.", pItemJournalLine."Order Line No.");
        if not lItemJournalLine2.IsEmpty then begin
            lProductionFunctions.AutomaticConsumptionProposal(lItemJournalLine2);
        end;
        //CS_PRO_035-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPItem Journal Functions", 'OnAfterCopyItemJnlLine', '', false, false)]
    local procedure AWPItemJournalFunctions_OnAfterCopyItemJnlLine(ItemJournalLine: Record "Item Journal Line"; var ItemJournalLine_New: Record "Item Journal Line")
    var
        lItem: Record Item;
    begin
        //CS_PRO_041_BIS-s
        if (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Consumption) and
            lItem.Get(ItemJournalLine."Item No.") and lItem."ecBy Product Item"
        then begin
            ItemJournalLine_New."AltAWPLot No." := ItemJournalLine."AltAWPLot No.";
            ItemJournalLine_New."AltAWPExpiration Date" := ItemJournalLine."AltAWPExpiration Date";
            ItemJournalLine_New.Modify(true);
        end;
        //CS_PRO_041_BIS-e
    end;

    #endregion Item Journal Functions

    #region Item Tracking Functions

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPItem Tracking Functions", 'OnBeforeLotNoInformationInsert', '', false, false)]
    local procedure AWPItemTrackingFunctions_OnBeforeLotNoInformationInsert(var LotNoInformation: Record "Lot No. Information"; var TrackingSpecification: Record "Tracking Specification")
    begin
        //CS_PRO_008-s
        if (TrackingSpecification."Expiration Date" <> 0D) then begin
            LotNoInformation."ecExpiration Date" := TrackingSpecification."Expiration Date";
        end;
        LotNoInformation."ecLot Creation Process" := TrackingSpecification."ecCreation Process";
        LotNoInformation.Validate("ecVendor No.", TrackingSpecification."Vendor No.");
        //CS_PRO_008-e
    end;

    #endregion Item Tracking Functions

    #region Whse. Documents Create
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPWhse. Documents Create", 'OnMakeWhseShipmentHashCode', '', false, false)]
    local procedure WhseDocumentsCreate_OnMakeWhseShipmentHashCode(WarehouseShipmentHeader: Record "Warehouse Shipment Header";
                                                                   SourceDocumentHeader: Variant;
                                                                   SourceDocumentLine: Variant;
                                                                   var DocumentKey: TextBuilder)
    var
        lSalesHeader: Record "Sales Header";
        lecSalesFunctions: Codeunit "ecSales Functions";
        lProductSegmentNo: Code[20];

        lSeparatorLbl: Label '#F#', Locked = true;
    begin
        //CS_VEN_033-VI-s
        lProductSegmentNo := '';
        if (WarehouseShipmentHeader."AltAWPSource Document Type" = WarehouseShipmentHeader."AltAWPSource Document Type"::"Sales Order") and
           (WarehouseShipmentHeader."AltAWPSubject Type" = WarehouseShipmentHeader."AltAWPSubject Type"::Customer) and
           (WarehouseShipmentHeader."AltAWPSubject No." <> '')
        then begin
            if SourceDocumentHeader.IsRecord then begin
                lSalesHeader := SourceDocumentHeader;

                lProductSegmentNo := lecSalesFunctions.GetSalesHeaderProductSegmentNo(lSalesHeader, 0);
                if WarehouseShipmentHeader."AltAWPCombine Shipments" then begin
                    lProductSegmentNo := lecSalesFunctions.GetSalesHeaderProductSegmentNo(lSalesHeader, 1);
                end;
            end;

            DocumentKey.Append(lSeparatorLbl + Format(lProductSegmentNo, 20));
        end;
        //CS_VEN_033-VI-e            
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPWhse. Documents Create", 'OnAfterSalesHeader2WhseShipmentHeader', '', false, false)]
    local procedure WhseDocumentsCreate_OnAfterSalesHeader2WhseShipmentHeader(pSalesHeader: Record "Sales Header";
                                                                              var pWarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        lecSalesFunctions: Codeunit "ecSales Functions";
    begin
        //CS_VEN_033-VI-s
        pWarehouseShipmentHeader."ecProduct Segment No." := lecSalesFunctions.GetSalesHeaderProductSegmentNo(pSalesHeader, 0);
        if pWarehouseShipmentHeader."AltAWPCombine Shipments" then begin
            pWarehouseShipmentHeader."ecProduct Segment No." := lecSalesFunctions.GetSalesHeaderProductSegmentNo(pSalesHeader, 1);
        end;
        //CS_VEN_033-VI-e 
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPWhse. Documents Create", 'OnAfterIsSalesLineCompatibleWithWhseShip', '', false, false)]
    local procedure WhseDocumentsCreate_OnAfterIsSalesLineCompatibleWithWhseShip(pSalesLine: Record "Sales Line";
                                                                                 lSalesHeader: Record "Sales Header";
                                                                                 pWarehouseShipmentHeader: Record "Warehouse Shipment Header";
                                                                                 pFromLineSelection: Boolean;
                                                                                 var rErrorMsg: Text)
    var
        lecSalesFunctions: Codeunit "ecSales Functions";
        lProductSegmentNo: Code[20];
        lInvalidFieldValueTxt: Label '%1 not compatible with the value of the document header.';
    begin
        //CS_VEN_033-VI-s
        lProductSegmentNo := lecSalesFunctions.GetSalesHeaderProductSegmentNo(lSalesHeader, 0);
        if pWarehouseShipmentHeader."AltAWPCombine Shipments" then begin
            lProductSegmentNo := lecSalesFunctions.GetSalesHeaderProductSegmentNo(lSalesHeader, 1);
        end;

        if (lProductSegmentNo <> pWarehouseShipmentHeader."ecProduct Segment No.") then begin
            rErrorMsg := StrSubstNo(lInvalidFieldValueTxt, pWarehouseShipmentHeader.FieldCaption("ecProduct Segment No."));
        end;
        //CS_VEN_033-VI-e 
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPWhse. Documents Create", 'OnAfterInsertWhseRcptLineByPurchaseLine', '', false, false)]
    local procedure AWPWhseDocumentsCreate_OnAfterInsertWhseRcptLineByPurchaseLine(var lWarehouseReceiptLine: Record "Warehouse Receipt Line";
                                                                                   pPurchaseLine: Record "Purchase Line";
                                                                                   pWarehouseReceiptHeader: Record "Warehouse Receipt Header")
    var
        PalletsMgt: Codeunit "ecPallets Management";
    begin
        //CS_ACQ_018-s
        lWarehouseReceiptLine."ecPackaging Type" := pPurchaseLine."ecPackaging Type";
        //CS_ACQ_018-e

        //CS_ACQ_013-s
        lWarehouseReceiptLine."ecContainer Type" := pPurchaseLine."ecContainer Type";
        lWarehouseReceiptLine."ecContainer No." := pPurchaseLine."ecContainer No.";
        lWarehouseReceiptLine."ecExpected Shipping Date" := pPurchaseLine."ecExpected Shipping Date";
        lWarehouseReceiptLine."ecDelay Reason Code" := pPurchaseLine."ecDelay Reason Code";
        lWarehouseReceiptLine."ecTransport Status" := pPurchaseLine."ecTransport Status";
        lWarehouseReceiptLine."ecShip. Documentation Status" := pPurchaseLine."ecShip. Documentation Status";
        lWarehouseReceiptLine."ecShiping Doc. Notes" := pPurchaseLine."ecShiping Doc. Notes";
        //CS_ACQ_013-e        

        //#229
        PalletsMgt.GetDefaultPalletBinCode(lWarehouseReceiptLine);
        //#229
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPWhse. Documents Create", 'OnAfterInsertWhseShipLineBySalesLine', '', false, false)]
    local procedure AWPWhseDocumentsCreate_OnAfterInsertWhseShipLineBySalesLine(pSalesLine: Record "Sales Line";
                                                                                var lWarehouseShipmentLine: Record "Warehouse Shipment Line";
                                                                                pWarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        //CS_VEN_014-VI-s
        if (pSalesLine."ecConsumer Unit of Measure" <> '') then begin
            lWarehouseShipmentLine."ecConsumer Unit of Measure" := pSalesLine."ecConsumer Unit of Measure";
            lWarehouseShipmentLine."ecQty. per Consumer UM" := 0;
            lWarehouseShipmentLine."ecQuantity (Consumer UM)" := 0;
            lWarehouseShipmentLine.Validate("ecQty. per Consumer UM", pSalesLine."ecQty. per Consumer UM");
        end;
        //CS_VEN_014-VI-e

        //CS_PRO_009-s
        lWarehouseShipmentLine."ecKit/Exhibitor BOM Entry No." := pSalesLine."ecKit/Exhibitor BOM Entry No.";
        //CS_PRO_009-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPWhse. Documents Create", 'OnAfterInsertWhseRcptLineBySalesLine', '', false, false)]
    local procedure AWPWhseDocumentsCreate_OnAfterInsertWhseRcptLineBySalesLine(pSalesLine: Record "Sales Line";
                                                                                var lWarehouseReceiptLine: Record "Warehouse Receipt Line";
                                                                                pWarehouseReceiptHeader: Record "Warehouse Receipt Header")
    begin
        //CS_VEN_014-VI-s
        if (pSalesLine."ecConsumer Unit of Measure" <> '') then begin
            lWarehouseReceiptLine."ecConsumer Unit of Measure" := pSalesLine."ecConsumer Unit of Measure";
            lWarehouseReceiptLine."ecQty. per Consumer UM" := 0;
            lWarehouseReceiptLine."ecQuantity (Consumer UM)" := 0;
            lWarehouseReceiptLine.Validate("ecQty. per Consumer UM", pSalesLine."ecQty. per Consumer UM");
        end;
        //CS_VEN_014-VI-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPWhse. Documents Create", 'OnBeforeModifyNewWhseShipHeaderBySalesLine', '', false, false)]
    local procedure WhseDocumentsCreate_OnBeforeModifyNewWhseShipHeaderBySalesLine(var pWarehouseShipmentHeader: Record "Warehouse Shipment Header";
                                                                                   lWarehouseShipmentHeader_Par: Record "Warehouse Shipment Header";
                                                                                   lSalesHeader: Record "Sales Header";
                                                                                   pSalesLine: Record "Sales Line")

    var
        lSalesFunctions: Codeunit "ecSales Functions";
    begin
        //CS_AFC_014-s
        lSalesFunctions.UpdateWhseShptDeferralInvDate(pWarehouseShipmentHeader);
        //CS_AFC_014-e
    end;
    #endregion Whse. Documents Create

    #region Whse. Documents Mgt.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPWhse. Documents Mgt.", 'OnSelectLogisticUnitForWhsePickTakeLineOnBeforeOpenPage', '', false, false)]
    local procedure WhseDocumentsMgt_OnSelectLogisticUnitForWhsePickTakeLineOnBeforeOpenPage(WarehouseActivityLine: Record "Warehouse Activity Line";
                                                                                             var Temp_ItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary)
    var
        lecRestrictionsMgt: Codeunit "ecRestrictions Mgt.";
        latsSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_PRO_011-VI-s
        if (WarehouseActivityLine."Activity Type" = WarehouseActivityLine."Activity Type"::Pick) then begin
            lecRestrictionsMgt.CheckPickRestrictionsOnItemInventoryBuffer(WarehouseActivityLine, Temp_ItemInventoryBuffer);
            latsSessionDataStore.AddSessionSetting('EC_SHOW_RESTRICTION_DETAILS', true);
        end;
        //CS_PRO_011-VI-e
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPWhse. Documents Mgt.", 'OnSelectLogisticUnitForWhsePickTakeLineOnAfterSelectEntry', '', false, false)]
    local procedure WhseDocumentsMgt_OnSelectLogisticUnitForWhsePickTakeLineOnAfterSelectEntry(var WarehouseActivityLine: Record "Warehouse Activity Line";
                                                                                               var Temp_ItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary)
    var
        lecRestrictionsMgt: Codeunit "ecRestrictions Mgt.";
    begin
        //CS_PRO-011-VI-s
        lecRestrictionsMgt.TestWarehousePickRestrictions(WarehouseActivityLine, Temp_ItemInventoryBuffer."Lot No.", false);
        //CS_PRO-011-VI-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPWhse. Documents Mgt.", 'OnBeforeCalcShippingDataOnWhseShipment', '', false, false)]
    local procedure WhseDocumentsMgt_OnBeforeCalcShippingDataOnWhseShipment(var WarehouseShipmentHeader: Record "Warehouse Shipment Header";
                                                                            ResetManualValues: Boolean;
                                                                            var AllowWeightsRecalc: Boolean;
                                                                            var AllowParcelsRecalc: Boolean)
    var
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
        lAllowTotPracelsRecalc: Boolean;
    begin
        //CS_LOG_001-s
        lAllowTotPracelsRecalc := (not WarehouseShipmentHeader."ecManual Parcels") or ResetManualValues;

        lATSSessionDataStore.AddSessionSetting('CalcShippingDataOnWhseShipment_AllowTotPracelsRecalc', lAllowTotPracelsRecalc);
        //CS_LOG_001-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPWhse. Documents Mgt.", 'OnAfterRecalcWhseShipHeaderTotals', '', false, false)]
    local procedure WhseDocumentsMgt_OnAfterRecalcWhseShipHeaderTotals(var pWarehouseShipmentHeader: Record "Warehouse Shipment Header";
                                                                       var pWhseShipHeader_Totals: Record "Warehouse Shipment Header";
                                                                       var pUpdateTotals: Boolean)
    var
        lLogistcFunctions: Codeunit "ecLogistc Functions";
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_LOG_001-s
        if lATSSessionDataStore.GetSessionSettingBooleanValue('CalcShippingDataOnWhseShipment_AllowTotPracelsRecalc') then begin
            pWhseShipHeader_Totals."ecNo. Parcels" := lLogistcFunctions.CalcWhseShipmentTotalParcels(pWarehouseShipmentHeader);
        end;

        pWhseShipHeader_Totals."ecNo. Theoretical Pallets" := lLogistcFunctions.CalcTheoreticalPalletsNo(pWarehouseShipmentHeader."Shipping Agent Code",
                                                                                                         pWarehouseShipmentHeader."Shipping Agent Service Code",
                                                                                                         pWarehouseShipmentHeader."AltAWPTotal Volume");

        pUpdateTotals := pUpdateTotals or
                         (pWarehouseShipmentHeader."ecNo. Parcels" <> pWhseShipHeader_Totals."ecNo. Parcels") or
                         (pWarehouseShipmentHeader."ecNo. Theoretical Pallets" <> pWhseShipHeader_Totals."ecNo. Theoretical Pallets");
        //CS_LOG_001-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPWhse. Documents Mgt.", 'OnCalcShippingDataOnWhseShipmentOnBeforeModifyRec', '', false, false)]
    local procedure WhseDocumentsMgt_OnCalcShippingDataOnWhseShipmentOnBeforeModifyRec(var pWarehouseShipmentHeader: Record "Warehouse Shipment Header";
                                                                                       var pWhseShipHeader_Totals: Record "Warehouse Shipment Header";
                                                                                       AllowWeightsRecalc: Boolean;
                                                                                       AllowParcelsRecalc: Boolean;
                                                                                       var pModifyRec: Boolean)
    var
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_LOG_001-s
        if lATSSessionDataStore.GetSessionSettingBooleanValue('CalcShippingDataOnWhseShipment_AllowTotPracelsRecalc') then begin
            pWarehouseShipmentHeader."ecNo. Parcels" := pWhseShipHeader_Totals."ecNo. Parcels";
            pWarehouseShipmentHeader."ecManual Parcels" := false;
        end;

        pWarehouseShipmentHeader."ecNo. Theoretical Pallets" := pWhseShipHeader_Totals."ecNo. Theoretical Pallets";

        lATSSessionDataStore.RemoveSessionSetting('CalcShippingDataOnWhseShipment_AllowTotPracelsRecalc');
        //CS_LOG_001-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPWhse. Documents Mgt.", 'OnResetManualValuesOnWhseShipmentOnBeforeModifyRec', '', false, false)]
    local procedure AltAWPWhseDocumentsMgt_OnResetManualValuesOnWhseShipmentOnBeforeModifyRec(var pWarehouseShipmentHeader: Record "Warehouse Shipment Header";
                                                                                              var pWhseShipHeader_Totals: Record "Warehouse Shipment Header";
                                                                                              var UpdateTotals: Boolean)
    begin
        //CS_LOG_001-s
        if (pWarehouseShipmentHeader."ecNo. Parcels" = pWhseShipHeader_Totals."ecNo. Parcels") and
           pWarehouseShipmentHeader."ecManual Parcels"
        then begin
            pWarehouseShipmentHeader."ecManual Parcels" := false;
            UpdateTotals := true;
        end;
        //CS_LOG_001-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPWhse. Documents Mgt.", 'OnAfterCheckWarehouseShipment', '', false, false)]
    local procedure AltAWPWhseDocumentsMgt_OnAfterCheckWarehouseShipment(WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        lSalesLine: Record "Sales Line";
        lWarehouseShipmentLine: Record "Warehouse Shipment Line";

        lPricingDetailBlockedErr: Label 'It is not possible to ship the line "%1" - (%2 - %3) as "%4" because the pricing detail on the sales order "%5" is blocked!';
    begin
        //CS_PRO_009-s
        if (WarehouseShipmentHeader."AltAWPSource Document Type" = WarehouseShipmentHeader."AltAWPSource Document Type"::"Sales Order") then begin
            Clear(lWarehouseShipmentLine);
            lWarehouseShipmentLine.SetRange("No.", WarehouseShipmentHeader."No.");
            lWarehouseShipmentLine.SetRange("AltAWPElement Type", lWarehouseShipmentLine."AltAWPElement Type"::Item);
            if lWarehouseShipmentLine.FindSet() then begin
                repeat
                    if lWarehouseShipmentLine."AltAWPFinal Shipment" then begin
                        lSalesLine.Get(lSalesLine."Document Type"::Order, lWarehouseShipmentLine."Source No.", lWarehouseShipmentLine."Source Line No.");
                        if (lSalesLine."Outstanding Quantity" <> lWarehouseShipmentLine.Quantity) then begin
                            if (lSalesLine."APsTRD Auto. Pricing Status" = lSalesLine."APsTRD Auto. Pricing Status"::Blocked) then begin
                                Error(lPricingDetailBlockedErr, Format(lWarehouseShipmentLine."Line No."), lWarehouseShipmentLine."AltAWPElement No.",
                                                                       lWarehouseShipmentLine.Description,
                                                                       lWarehouseShipmentLine.FieldCaption("AltAWPFinal Shipment"),
                                                                       lWarehouseShipmentLine."Source No.");
                            end;
                        end;
                    end;
                until (lWarehouseShipmentLine.Next() = 0);
            end;
        end;
        //CS_PRO_009-e
    end;

    #endregion Whse. Documents Mgt.

    #region Invoicing Functions
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPInvoicing Functions", 'OnAfterMakeDocKeyForSalesShipmentInvoicingHashCode', '', false, false)]
    local procedure InvoicingFunctions_OnAfterMakeDocKeyForSalesShipmentInvoicingHashCode(pSalesShipmentHeader: Record "Sales Shipment Header";
                                                                                          pSalesOrderHeader: Record "Sales Header";
                                                                                          lSeparatorLbl: Text;
                                                                                          var lDocumentKey: TextBuilder)
    var
        lecSalesFunctions: Codeunit "ecSales Functions";
    begin
        //CS_VEN_033-VI-s
        lDocumentKey.Append(lSeparatorLbl + Format(lecSalesFunctions.GetSalesHeaderProductSegmentNo(pSalesOrderHeader, 2), 20));
        //CS_VEN_033-VI-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPInvoicing Functions", 'OnBeforeModifyNewCumulativeSalesInvHeader', '', false, false)]
    local procedure InvoicingFunctions_OnBeforeModifyNewCumulativeSalesInvHeader(var pSalesHeader: Record "Sales Header";
                                                                                 lSalesShipmentHeader: Record "Sales Shipment Header";
                                                                                 pSalesShipmentLine: Record "Sales Shipment Line";
                                                                                 lSalesOrderHeader: Record "Sales Header";
                                                                                 lCustomer: Record Customer)
    var
        lCustomerSellTo: Record Customer;
        lecSalesFunctions: Codeunit "ecSales Functions";
    begin
        //CS_VEN_033-VI-e
        pSalesHeader."ecProduct Segment No." := lecSalesFunctions.GetSalesHeaderProductSegmentNo(lSalesOrderHeader, 2);
        if (pSalesHeader."ecProduct Segment No." <> '') then pSalesHeader.Validate("ecProduct Segment No.");
        if lCustomerSellTo.Get(pSalesHeader."Sell-to Customer No.") then begin
            if lCustomerSellTo."ecGroup Inv. By Prod. Segment" then begin
                pSalesHeader.Validate("ecSales Manager Code", lSalesOrderHeader."ecSales Manager Code");
            end;
        end;
        //CS_VEN_033-VI-s
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPInvoicing Functions", 'OnAfterUpdateSalesInvHeaderDataFromPostWhseShpt', '', false, false)]
    local procedure InvoicingFunctions_OnAfterUpdateSalesInvHeaderDataFromPostWhseShpt(var SalesHeader: Record "Sales Header"; PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header")
    begin
        //CS_LOG_001-s
        SalesHeader."ecNo. Parcels" := PostedWhseShipmentHeader."ecNo. Parcels";
        SalesHeader."ecManual Parcels" := PostedWhseShipmentHeader."ecManual Parcels";
        SalesHeader."ecNo. Theoretical Pallets" := PostedWhseShipmentHeader."ecNo. Theoretical Pallets";
        //CS_LOG_001-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPInvoicing Functions", 'OnAfterUpdateShippingInvoiceLogisticData', '', false, false)]
    local procedure InvoicingFunctions_OnAfterUpdateShippingInvoiceLogisticData(var SalesHeader: Record "Sales Header"; PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header")
    begin
        //CS_LOG_001-s
        SalesHeader."ecNo. Parcels" := PostedWhseShipmentHeader."ecNo. Parcels";
        SalesHeader."ecManual Parcels" := PostedWhseShipmentHeader."ecManual Parcels";
        SalesHeader."ecNo. Theoretical Pallets" := PostedWhseShipmentHeader."ecNo. Theoretical Pallets";
        //CS_LOG_001-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPLogistics Functions", 'OnAfterCalcShippingDataOnSalesDocumentOnBeforeModifySalesHeader', '', false, false)]
    local procedure InvoicingFunctions_OnAfterCalcShippingDataOnSalesDocumentOnBeforeModifySalesHeader(var SalesHeader: Record "Sales Header"; ForceRecalc: Boolean; var SomethingHasChanged: Boolean)
    var
        lLogistcFunctions: Codeunit "ecLogistc Functions";
    begin
        //CS_LOG_001-s
        if ForceRecalc or (not SalesHeader."ecManual Parcels") then begin
            SalesHeader."ecNo. Parcels" := lLogistcFunctions.CalcSalesDocumentTotalParcels(SalesHeader);
            SalesHeader."ecManual Parcels" := false;
        end;

        SalesHeader."ecNo. Theoretical Pallets" := lLogistcFunctions.CalcTheoreticalPalletsNo(SalesHeader."Shipping Agent Code",
                                                                                              SalesHeader."Shipping Agent Service Code",
                                                                                              SalesHeader."AltAWPTotal Volume");

        SomethingHasChanged := true;
        //CS_LOG_001-e
    end;

    #endregion Invoicing Functions

    #region AWPPrint Function
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPPrint Functions", 'OnHandleManageComposedDiscountValue', '', false, false)]
    local procedure AWPPrintFunctions_OnHandleManageComposedDiscountValue(pRecordVariant: Variant; var pComposedDiscount: Text)
    var
        lSalesLine: Record "Sales Line";
        lPurchaseLine: Record "Purchase Line";
        lSalesCrMemoLine: Record "Sales Cr.Memo Line";
        lSalesInvoiceLine: Record "Sales Invoice Line";
        lRecRef: RecordRef;
    begin
        if pRecordVariant.IsRecord then begin
            lRecRef.GetTable(pRecordVariant);
            case lRecRef.Number of
                37:
                    begin
                        lRecRef.SetTable(lSalesLine);
                        pComposedDiscount := lSalesLine."APsComposed Discount";
                    end;
                39:
                    begin
                        lRecRef.SetTable(lPurchaseLine);
                        pComposedDiscount := lPurchaseLine."APsComposed Discount";
                    end;
                113:
                    begin
                        lRecRef.SetTable(lSalesInvoiceLine);
                        pComposedDiscount := lSalesInvoiceLine."APsComposed Discount";
                    end;
                115:
                    begin
                        lRecRef.SetTable(lSalesCrMemoLine);
                        pComposedDiscount := lSalesCrMemoLine."APsComposed Discount";
                    end;
            end;
        end;
    end;
    #endregion AWPPrint Function

    #region

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPLogistic Units Mgt.", 'OnBeforePrintPackingListByWhseShipment', '', false, false)]
    local procedure AWPLogisticUnitsMgt_OnBeforePrintPackingListByWhseShipment(WhseShipmentNo: Code[20]; AlreadyPostedShipment: Boolean; DirectPrint: Boolean;
                                                                               var Temp_LabelBuffer: Record "AltAWPLogistic Labels Buffer" temporary; var IsHandled: Boolean)
    var
        Temp_lLabelBuffer2: Record "AltAWPLogistic Labels Buffer" temporary;
        lPackingList: Report "ecPacking List";
        lLogistcFunctions: Codeunit "ecLogistc Functions";
        latsAdvancedTypeHelper: Codeunit "AltATSAdvanced Type Helper";
        ldpsDirectPrintService: Codeunit "AltDPSDirectPrint Service";
        lRecordRef: RecordRef;
        lJReportData: Text;
    begin
        //GAP_VEN_001-s
        if DirectPrint then begin
            lRecordRef.GetTable(Temp_LabelBuffer);
            lJReportData := latsAdvancedTypeHelper.TableData2JsonText(lRecordRef, true);
            ldpsDirectPrintService.ExecutePrint(Report::"AltAWPPacking List", lJReportData, '', false);
            lRecordRef.Close();
        end else begin
            Clear(lPackingList);
            lLogistcFunctions.FillPackingListBuffer("Warehouse Journal Document Type"::Shipment, WhseShipmentNo, true, true, Temp_lLabelBuffer2);
            lPackingList.SetLabelBuffer(Temp_lLabelBuffer2);
            lPackingList.UseRequestPage(true);
            lPackingList.RunModal();
        end;

        IsHandled := true;
        //GAP_VEN_001-e
    end;

    #endregion

    #region AWPLogistics Functions

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPLogistics Functions", 'OnAfterInitWhseEntryFromWhseJnlLine', '', false, false)]
    local procedure AWPLogisticsFunctions_OnAfterInitWhseEntryFromWhseJnlLine(var WarehouseEntry: Record "Warehouse Entry"; var WarehouseJournalLine: Record "Warehouse Journal Line")
    begin
        //CS_ACQ_013-s
        WarehouseEntry."ecNo. Of Parcels" := WarehouseJournalLine."ecNo. Of Parcels";
        WarehouseEntry."ecTotal Weight" := WarehouseJournalLine."ecTotal Weight";
        WarehouseEntry."ecUnit Weight" := WarehouseJournalLine."ecUnit Weight";
        //CS_ACQ_013-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPLogistics Functions", 'OnAfterCalcItemUMConversionFactor', '', false, false)]
    local procedure AWPLogisticsFunctions_OnAfterCalcItemUMConversionFactor(ItemNo: Code[20]; SourceUM: Code[10]; TargetUM: Code[10]; var ConversionFactor: Decimal)
    var
        lItem: Record Item;
    begin
        //CS_VEN_014-VI-s
        // In caso di modifica allineare anche la funzione TRDGeneralFunctions_OnAfterCalcUdMConversionFactor 
        // presente nella CU "ecAPs Events Subscription"

        if lItem.Get(ItemNo) then begin
            if (TargetUM = lItem."ecConsumer Unit of Measure") and
               (SourceUM = lItem."ecPackage Unit Of Measure")
            then begin
                if (lItem."ecNo. Consumer Units per Pkg." <> 0) then begin
                    ConversionFactor := lItem."ecNo. Consumer Units per Pkg.";
                end;
            end;
        end;
        //CS_VEN_014-VI-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPLogistics Functions", 'OnAfterConvertItemQtyInUM', '', false, false)]
    local procedure AWPLogisticsFunctions_OnAfterConvertItemQtyInUM(ItemNo: Code[20]; SourceQty: Decimal; SourceUM: Code[10]; TargetUM: Code[10]; var ConvertedQty: Decimal)
    var
        lItem: Record Item;
        lUOMMgt: Codeunit "Unit of Measure Management";
        lConversionFactor: Decimal;
        lQtyRoundingPrecision: Decimal;
    begin
        //CS_VEN_014-VI-s
        // In caso di modifica allineare anche la funzione TRDGeneralFunctions_OnAfterConvertQtyInUdM 
        // presente nella CU "ecAPs Events Subscription"

        if lItem.Get(ItemNo) then begin
            if (SourceUM = lItem."ecConsumer Unit of Measure") and
               (TargetUM = lItem."ecPackage Unit Of Measure")
            then begin
                lConversionFactor := lItem."ecNo. Consumer Units per Pkg.";
                if (lConversionFactor <> 0) then begin
                    lQtyRoundingPrecision := lUOMMgt.GetQtyRoundingPrecision(lItem, TargetUM);
                    ConvertedQty := lUOMMgt.RoundQty(SourceQty / lConversionFactor, lQtyRoundingPrecision);
                end;
            end;
        end;
        //CS_VEN_014-VI-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPLogistics Functions", OnAfterSetPostedDocRefOnItemLedgEntry, '', false, false)]
    local procedure "AltAWPLogistics Functions_OnAfterSetPostedDocRefOnItemLedgEntry"(SourceDocTableNo: Integer; SourceDocNo: Code[20]; SourceDocLineNo: Integer; var ItemLedgerEntry: Record "Item Ledger Entry")
    var
        PalletsMgt: Codeunit "ecPallets Management";
    begin
        //#229
        PalletsMgt.ValidatePalletsLinkedFields(ItemLedgerEntry);
        //#229
    end;

    #endregion AWPLogistics Functions

    #region AWPLogistic Units Mgt.

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPLogistic Units Mgt.", 'OnBeforeInsertSplitWhseJnlLineByLogUnitsDetail', '', false, false)]
    local procedure AWPLogisticUnitsMgt_OnBeforeInsertSplitWhseJnlLineByLogUnitsDetail(var TempWhseJnlLine: Record "Warehouse Journal Line" temporary; var AWPLogisticUnitDetail: Record "AltAWPLogistic Unit Detail")
    begin
        //CS_ACQ_013-s
        TempWhseJnlLine."ecNo. Of Parcels" := AWPLogisticUnitDetail."ecNo. Of Parcels";
        TempWhseJnlLine."ecTotal Weight" := AWPLogisticUnitDetail."ecTotal Weight";
        TempWhseJnlLine."ecUnit Weight" := AWPLogisticUnitDetail."ecUnit Weight";
        //CS_ACQ_013-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPLogistic Units Mgt.", 'OnBeforeModifySplitWhseJnlLineByLogUnitsDetail', '', false, false)]
    local procedure AWPLogisticUnitsMgt_OnBeforeModifySplitWhseJnlLineByLogUnitsDetail(var TempWhseJnlLine: Record "Warehouse Journal Line" temporary; var AWPLogisticUnitDetail: Record "AltAWPLogistic Unit Detail")
    begin
        //CS_ACQ_013-s
        if (TempWhseJnlLine."ecNo. Of Parcels" = 0) and (TempWhseJnlLine."ecTotal Weight" = 0) and (TempWhseJnlLine."ecUnit Weight" = 0) then begin
            if (AWPLogisticUnitDetail."ecNo. Of Parcels" <> 0) or (AWPLogisticUnitDetail."ecTotal Weight" <> 0) or
               (AWPLogisticUnitDetail."ecUnit Weight" <> 0)
            then begin
                TempWhseJnlLine."ecNo. Of Parcels" := AWPLogisticUnitDetail."ecNo. Of Parcels";
                TempWhseJnlLine."ecTotal Weight" := AWPLogisticUnitDetail."ecTotal Weight";
                TempWhseJnlLine."ecUnit Weight" := AWPLogisticUnitDetail."ecUnit Weight";
            end;
        end;
        //CS_ACQ_013-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPLogistic Units Mgt.", 'OnAfterCreatePalletInfoCard', '', false, false)]
    local procedure AWPLogisticUnitsMgt_OnAfterCreatePalletInfoCard(WarehouseEntry: Record "Warehouse Entry")
    var
        lawpLogisticUnitInfo: Record "AltAWPLogistic Unit Info";
    begin
        //CS_ACQ_013-s
        if lawpLogisticUnitInfo.Get(lawpLogisticUnitInfo.Type::Pallet, WarehouseEntry."AltAWPPallet No.") then begin
            if (lawpLogisticUnitInfo."ecNo. Of Parcels" = 0) and (lawpLogisticUnitInfo."ecTotal Weight" = 0) and
               (lawpLogisticUnitInfo."ecUnit Weight" = 0)
            then begin
                lawpLogisticUnitInfo."ecNo. Of Parcels" := WarehouseEntry."ecNo. Of Parcels";
                lawpLogisticUnitInfo."ecTotal Weight" := WarehouseEntry."ecTotal Weight";
                lawpLogisticUnitInfo."ecUnit Weight" := WarehouseEntry."ecUnit Weight";
                lawpLogisticUnitInfo.Modify(false);
            end;
        end;
        //CS_ACQ_013-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPLogistic Units Mgt.", 'OnAfterCreateBoxInfoCard', '', false, false)]
    local procedure AWPLogisticUnitsMgt_OnAfterCreateBoxInfoCard(WarehouseEntry: Record "Warehouse Entry")
    var
        lawpLogisticUnitInfo: Record "AltAWPLogistic Unit Info";
    begin
        //CS_ACQ_013-s
        if (WarehouseEntry."AltAWPPallet No." <> '') then begin
            if lawpLogisticUnitInfo.Get(lawpLogisticUnitInfo.Type::Pallet, WarehouseEntry."AltAWPPallet No.") then begin
                lawpLogisticUnitInfo."ecNo. Of Parcels" := WarehouseEntry."ecNo. Of Parcels";
                lawpLogisticUnitInfo."ecTotal Weight" := WarehouseEntry."ecTotal Weight";
                lawpLogisticUnitInfo."ecUnit Weight" := WarehouseEntry."ecUnit Weight";
                lawpLogisticUnitInfo.Modify(false);
            end;
        end else begin
            if lawpLogisticUnitInfo.Get(lawpLogisticUnitInfo.Type::Box, WarehouseEntry."AltAWPBox No.") then begin
                if (lawpLogisticUnitInfo."ecNo. Of Parcels" = 0) and (lawpLogisticUnitInfo."ecTotal Weight" = 0) and
                   (lawpLogisticUnitInfo."ecUnit Weight" = 0)
                then begin
                    lawpLogisticUnitInfo."ecNo. Of Parcels" := WarehouseEntry."ecNo. Of Parcels";
                    lawpLogisticUnitInfo."ecTotal Weight" := WarehouseEntry."ecTotal Weight";
                    lawpLogisticUnitInfo."ecUnit Weight" := WarehouseEntry."ecUnit Weight";
                    lawpLogisticUnitInfo.Modify(false);
                end;
            end;
        end;
        //CS_ACQ_013-e
    end;

    #endregion AWPLogistic Units Mgt.


    #region AWPPrint Functions

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPPrint Functions", 'OnAfterInitializeReportSelections', '', false, false)]
    local procedure PrintFunctions_OnAfterInitializeReportSelections()
    var
        lAWPPrintFunctions: Codeunit "AltAWPPrint Functions";
    begin
        //GAP_ACQ_002-s
        lAWPPrintFunctions.InitializeReportSelectionsByUsage(Enum::"Report Selection Usage"::"P.Order", Report::"ecPurchases Order");
        lAWPPrintFunctions.InitializeReportSelectionsByUsage(Enum::"Report Selection Usage"::"S.Order", Report::"ecSales Order");
        lAWPPrintFunctions.InitializeReportSelectionsByUsage(Enum::"Report Selection Usage"::"S.Quote", Report::"ecSales Order");
        lAWPPrintFunctions.InitializeReportSelectionsByUsage(Enum::"Report Selection Usage"::"Pro Forma S. Invoice", Report::"ecSales Invoice TEST");
        lAWPPrintFunctions.InitializeReportSelectionsByUsage(Enum::"Report Selection Usage"::"AltAWPPro Forma S. Order", Report::"ecSales Order");
        lAWPPrintFunctions.InitializeReportSelectionsByUsage(Enum::"Report Selection Usage"::"S.Quote", Report::"ecSales Quote");
        lAWPPrintFunctions.InitializeReportSelectionsByUsage(Enum::"Report Selection Usage"::"AltAWPShipping Invoice", Report::"ecShipping Invoice");
        lAWPPrintFunctions.InitializeReportSelectionsByUsage(Enum::"Report Selection Usage"::"AltAWPShipping Invoice TEST", Report::"ecShipping Invoice TEST");
        lAWPPrintFunctions.InitializeReportSelectionsByUsage(Enum::"Report Selection Usage"::"AltAWPS.Inv. Not Posted", Report::"ecSales Invoice TEST");
        lAWPPrintFunctions.InitializeReportSelectionsByUsage(Enum::"Report Selection Usage"::"S.Invoice", Report::"ecSales Invoice");
        lAWPPrintFunctions.InitializeReportSelectionsByUsage(Enum::"Report Selection Usage"::"AltAWPS.Cr.Memo Not Posted", Report::"ecSales Credit Memo TEST");
        lAWPPrintFunctions.InitializeReportSelectionsByUsage(Enum::"Report Selection Usage"::"S.Cr.Memo", Report::"ecSales Credit Memo");
        lAWPPrintFunctions.InitializeWhseReportSelectionsByUsage(Enum::"Report Selection Warehouse Usage"::"Posted Shipment", Report::"ecShipping Document");
        lAWPPrintFunctions.InitializeWhseReportSelectionsByUsage(Enum::"Report Selection Warehouse Usage"::Shipment, Report::"ecWarehouse Shipment");
        lAWPPrintFunctions.InitializeWhseReportSelectionsByUsage(Enum::"Report Selection Warehouse Usage"::Pick, Report::"ecPicking - List");
        lAWPPrintFunctions.InitializeWhseReportSelectionsByUsage(Enum::"Report Selection Warehouse Usage"::"Invt. Pick", Report::"ecPicking - List");
        //GAP_ACQ_002-e
    end;

    #endregion AWPPrint Functions

    #region AWPComments Management

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPComments Management", 'OnBeforeInsertSalesCommentLine', '', false, false)]
    local procedure AWPCommentsManagement_OnBeforeInsertSalesCommentLine(var SalesCommentLine: Record "Sales Comment Line"; var Temp_CommentLineBuffer: Record "AltAWPComment Line Buffer" temporary)
    begin
        //CS_VEN_034-s        
        SalesCommentLine."ecProduct Segment No." := Temp_CommentLineBuffer."ecProduct Segment No.";
        if (SalesCommentLine."ecProduct Segment No." <> '') then begin
            SalesCommentLine."AltAWPSource Type" := 0;
            SalesCommentLine."AltAWPSource Subtype" := 0;
            SalesCommentLine."AltAWPSource No." := '';
            SalesCommentLine."AltAWPSource Line No." := 0;
        end;
        //CS_VEN_034-e
    end;

    #endregion AWPComments Management

    #region AWPPost Whse. Shipment

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPPost Whse. Shipment", 'OnAfterUpdatePostedWhseShipmentHeader', '', false, false)]
    local procedure AltAWPPostWhseShipment_OnAfterUpdatePostedWhseShipmentHeader(var PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
                                                                                 pWarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        //CS_LOG_001-s
        PostedWhseShipmentHeader."ecNo. Parcels" := pWarehouseShipmentHeader."ecNo. Parcels";
        PostedWhseShipmentHeader."ecManual Parcels" := pWarehouseShipmentHeader."ecManual Parcels";
        PostedWhseShipmentHeader."ecNo. Theoretical Pallets" := pWarehouseShipmentHeader."ecNo. Theoretical Pallets";
        //CS_LOG_001-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPPost Whse. Shipment", 'OnAfterInitWarehouseShipment', '', false, false)]
    local procedure AltAWPPostWhseShipment_OnAfterInitWarehouseShipment(var WarehouseShipmentHeader: Record "Warehouse Shipment Header";
                                                                        SuppressCommit: Boolean; HideDialogs: Boolean; CalledByShippingGroup: Boolean)
    var
        lSalesFunctions: Codeunit "ecSales Functions";
    begin
        //CS_AFC_014-s
        lSalesFunctions.UpdateWhseShptDeferralInvDate(WarehouseShipmentHeader);
        //CS_AFC_014-e
    end;

    #endregion AWPPost Whse. Shipment

    #endregion Codeunit

    #region Page
    #region Sales Orders Check
    [EventSubscriber(ObjectType::Page, Page::"AltAWPSales Orders Check", 'OnAfterApplyFilters', '', false, false)]
    local procedure awpSalesOrdersCheck_OnAfterApplyFilters(var Rec: Record "AltAWPSales Order Check Buffer" temporary;
                                                            FiltersArray: array[50] of Text;
                                                            CustomFiltersArray: array[50] of Text)
    begin
        //CS_VEN_031-VI-s
        Rec.SetRange("ecSales Manager Code");
        if (CustomFiltersArray[1] <> '') then begin
            Rec.SetFilter("ecSales Manager Code", CustomFiltersArray[1]);
        end;
        //CS_VEN_031-VI-e

        //CS_VEN_032-VI-s
        Rec.SetRange("ecProduct Segment No.");
        if (CustomFiltersArray[2] <> '') then begin
            Rec.SetFilter("ecProduct Segment No.", CustomFiltersArray[2]);
        end;
        //CS_VEN_032-VI-e
    end;

    [EventSubscriber(ObjectType::Page, Page::"AltAWPSales Orders Check", 'OnRefreshBufferOnAfterSetSalesHeaderFilters', '', false, false)]
    local procedure awpSalesOrdersCheck_OnRefreshBufferOnAfterSetSalesHeaderFilters(var SalesHeader: Record "Sales Header";
                                                                                    FiltersArray: array[50] of Text;
                                                                                    CustomFiltersArray: array[50] of Text)
    begin
        //CS_VEN_031-VI-s
        SalesHeader.SetRange("ecSales Manager Code");
        if (CustomFiltersArray[1] <> '') then begin
            SalesHeader.SetFilter("ecSales Manager Code", CustomFiltersArray[1]);
        end;
        //CS_VEN_031-VI-e

        //CS_VEN_032-VI-s
        SalesHeader.SetRange("ecProduct Segment No.");
        if (CustomFiltersArray[2] <> '') then begin
            SalesHeader.SetFilter("ecProduct Segment No.", CustomFiltersArray[2]);
        end;
        //CS_VEN_032-VI-e   
    end;
    #endregion Sales Orders Check

    #region AltAWPProduction Picking Wksh.

    [EventSubscriber(ObjectType::Page, Page::"AltAWPProduction Picking Wksh.", 'OnAfterCalcItemAvailability', '', false, false)]
    local procedure ProductionPickingWksh_OnAfterCalcItemAvailability(var Temp_ItemAvailabilityBuffer: Record "AltAWPItem Availability Buffer";
                                                                      var ProductionPickingWksh: Record "AltAWPProduction Picking Wksh";
                                                                      var Item: Record Item;
                                                                      AvailabilityDateFilter: Text)
    var
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        lProductionFunctions.CalcProdPickWorksheetQtyComponentLines(Temp_ItemAvailabilityBuffer, Item);
    end;

    #endregion AltAWPProduction Picking Wksh.

    [EventSubscriber(ObjectType::Page, Page::"AltAWPPurch. Lines Outstanding", 'OnBeforeOpenPageSetDateToShow', '', false, false)]
    local procedure AWPPurchLinesOutstanding_OnBeforeOpenPageSetDateToShow(var DateToShow: Option)
    begin
        //CS_ACQ_018-s
        DateToShow := 1;
        //CS_ACQ_018-e
    end;

    #endregion Page
}