namespace EuroCompany.BaseApp;

using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Inventory.Ledger;
using EuroCompany.BaseApp.Inventory.Reservation;
using EuroCompany.BaseApp.Inventory.Tracking;
using EuroCompany.BaseApp.Manufacturing;
using EuroCompany.BaseApp.Purchases.Document;
using EuroCompany.BaseApp.Restrictions;
using EuroCompany.BaseApp.Sales;
using EuroCompany.BaseApp.Sales.Commissions;
using EuroCompany.BaseApp.Setup;
using EuroCompany.BaseApp.Warehouse.Pallets;
using Microsoft.Assembly.History;
using Microsoft.CRM.Team;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Finance.VAT.Ledger;
using Microsoft.Foundation.NoSeries;
using Microsoft.Foundation.PaymentTerms;
using Microsoft.Inventory.Costing;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Planning;
using Microsoft.Inventory.Posting;
using Microsoft.Inventory.Requisition;
using Microsoft.Inventory.Tracking;
using Microsoft.Manufacturing.Capacity;
using Microsoft.Manufacturing.Document;
using Microsoft.Manufacturing.Journal;
using Microsoft.Manufacturing.ProductionBOM;
using Microsoft.Manufacturing.Routing;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Payables;
using Microsoft.Purchases.Posting;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;
using Microsoft.Sales.Posting;
using Microsoft.Sales.Receivables;
using Microsoft.Warehouse.Activity;
using Microsoft.Warehouse.Document;
using Microsoft.Warehouse.History;
using Microsoft.Warehouse.Journal;
using Microsoft.Warehouse.Ledger;
using Microsoft.Warehouse.Structure;
using System.Automation;

codeunit 50004 "ecStd Events Subscription"
{
    Access = Public;

    Permissions = tabledata "Posted Whse. Shipment Header" = rimd,
                tabledata "Posted Whse. Receipt Header" = rimd,
                tabledata "Purch. Inv. Header" = rimd,
                tabledata "Vendor Ledger Entry" = rimd;
    #region Table

    #region Sales Header
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCopyShipToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure SalesHeader_OnAfterCopyShipToCustomerAddressFieldsFromCustomer(var SalesHeader: Record "Sales Header";
                                                                                   SellToCustomer: Record Customer)
    begin
        //CS_VEN_031-VI
        SalesHeader.Validate("ecSales Manager Code", SellToCustomer."ecSales Manager Code");
        //CS_VEN_031-Ve
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterSetFieldsBilltoCustomer', '', false, false)]
    local procedure SalesHeader_OnAfterSetFieldsBilltoCustomer(var SalesHeader: Record "Sales Header";
                                                               Customer: Record Customer)
    var
        lecSalesFunctions: Codeunit "ecSales Functions";
    begin
        //CS_VEN_032-VI-s
        if (SalesHeader."ecProduct Segment No." <> '') then begin
            SalesHeader.Validate("ecProduct Segment No.", '');
        end;
        //CS_VEN_032-VI-e

        //CS_VEN_031-VI-s
        lecSalesFunctions.SalesHeader_SetDefaultSalesManager(SalesHeader, true);
        //CS_VEN_031-VI-e

        //CS_VEN_032-VI-s
        lecSalesFunctions.SalesHeader_SetDefaultProductSegment(SalesHeader);
        //CS_VEN_032-VI-e

        //CS_VEN_036-s
        SalesHeader."Payment Method Code" := Customer."Payment Method Code";
        //CS_VEN_036-e
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnBeforeValidateDocumentDate, '', false, false)]
    local procedure "Sales Header_OnBeforeValidateDocumentDate"(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    var
        EcSetup: Record "ecGeneral Setup";
    begin
        EcSetup.Get();
        if EcSetup."Use Custom Calc. Due Date" then
            if EcSetup."Use Document Date As Default" then
                SalesHeader.Validate("ecRef. Date For Calc. Due Date", SalesHeader."Document Date");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnInitRecordOnBeforeGetNextArchiveDocOccurrenceNo, '', false, false)]
    local procedure "Sales Header_OnInitRecordOnBeforeGetNextArchiveDocOccurrenceNo"(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        EcSetup: Record "ecGeneral Setup";
    begin
        EcSetup.Get();
        if EcSetup."Use Custom Calc. Due Date" then
            if EcSetup."Use Document Date As Default" then
                SalesHeader.Validate("ecRef. Date For Calc. Due Date", SalesHeader."Document Date");
    end;


    #endregion Sales Header

    #region Sales Line
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateNo', '', false, false)]
    local procedure SalesLine_OnBeforeValidateNo(var SalesLine: Record "Sales Line";
                                                 xSalesLine: Record "Sales Line";
                                                 CurrentFieldNo: Integer;
                                                 var IsHandled: Boolean)
    var
        lSalesHeader: Record "Sales Header";
        lecSalesFunctions: Codeunit "ecSales Functions";

        lSegmentNotIncludedMsg: Label 'The Item %1 is not included in product segment %2';
    begin
        //CS_VEN_032-VI-s
        //Rimosso controllo su compatibilità tra articolo e segmento perchè richiesto da EC
        if (CurrentFieldNo <> 0) then begin
            if (SalesLine."Document Type" <> SalesLine."Document Type"::"Credit Memo") and
               (SalesLine."Shipment No." = '') and (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."No." <> '')
            then begin
                if lSalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") and
                   (lSalesHeader."Sell-to Customer No." <> '') and (lSalesHeader."ecProduct Segment No." <> '')
                then begin
                    if not lecSalesFunctions.TestSalesLineItem(SalesLine, lSalesHeader, false) then begin
                        Message(lSegmentNotIncludedMsg, SalesLine."No.", lSalesHeader."ecProduct Segment No.");
                    end;
                end;
            end;
        end;
        //CS_VEN_032-VI-e
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnBeforeInitHeaderDefaults', '', false, false)]
    local procedure SalesLine_OnValidateNoOnBeforeInitHeaderDefaults(SalesHeader: Record "Sales Header";
                                                                     var SalesLine: Record "Sales Line";
                                                                     var TempSalesLine: Record "Sales Line" temporary)
    begin
        //CS_VEN_014-VI-s
        if (SalesLine.Type = SalesLine.Type::Item) then begin
            if SalesLine.HasTypeToFillMandatoryFields() then begin
                SalesLine."ecQuantity (Consumer UM)" := TempSalesLine."ecQuantity (Consumer UM)";
            end;
        end;
        //CS_VEN_014-VI-e
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterCopyFromItem', '', false, false)]
    local procedure SalesLine_OnAfterCopyFromItem(var SalesLine: Record "Sales Line";
                                                  Item: Record Item;
                                                  CurrentFieldNo: Integer;
                                                  xSalesLine: Record "Sales Line")
    begin
        //CS_VEN_014-VI-s
        if (Item."ecConsumer Unit of Measure" <> '') then begin
            SalesLine.Validate("ecConsumer Unit of Measure", Item."ecConsumer Unit of Measure");
        end else begin
            SalesLine.Validate("ecConsumer Unit of Measure", SalesLine."Unit of Measure Code");
        end;
        //CS_VEN_014-VI-e
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateQuantityOnAfterCalcBaseQty', '', false, false)]
    local procedure SalesLine_OnValidateQuantityOnAfterCalcBaseQty(var SalesLine: Record "Sales Line";
                                                                   xSalesLine: Record "Sales Line")
    begin
        //CS_VEN_014-VI-s
        SalesLine.ecUpdateConsumerUMQuantity();
        //CS_VEN_014-VI-e
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterUpdateAmountsDone', '', false, false)]
    local procedure SalesLine_OnAfterUpdateAmountsDone(var SalesLine: Record "Sales Line";
                                                       var xSalesLine: Record "Sales Line";
                                                       CurrentFieldNo: Integer)
    begin
        //CS_VEN_014-VI-s
        SalesLine.ecUpdateConsumerUMUnitPrice();
        //CS_VEN_014-VI-e
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateQtyToShipOnAfterCheck', '', true, true)]
    local procedure AltOnValidateQtyToShipOnAfterCheck(var SalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    var
        APsFOCPostingSetup: Record "APsFOC Posting Setup";
    begin
        //#391
        APsFOCPostingSetup.Reset();
        APsFOCPostingSetup.SetRange("Type", SalesLine.Type);
        APsFOCPostingSetup.SetRange("No.", SalesLine."No.");
        if not APsFOCPostingSetup.IsEmpty() then begin
            SalesLine."Qty. to Ship" := Abs(SalesLine."Qty. to Ship");
            SalesLine."Outstanding Quantity" := Abs(SalesLine."Qty. to Ship");
            if SalesLine.Modify() then;
        end;
        //#391
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateQuantity', '', true, true)]
    local procedure OnBeforeValidateQuantity(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CallingFieldNo: Integer; var IsHandled: Boolean)
    var
        APsFOCPostingSetup: Record "APsFOC Posting Setup";
        SalesLineLocal: Record "Sales Line";
    begin
        //#391
        if SalesLine."Document Type" = SalesLine."Document Type"::Invoice then
            if SalesLineLocal.Get(SalesLineLocal."Document Type"::Invoice, SalesLine."Document No.", SalesLine."Line No.") then begin
                APsFOCPostingSetup.Reset();
                APsFOCPostingSetup.SetRange("Type", SalesLine.Type);
                APsFOCPostingSetup.SetRange("No.", SalesLine."No.");
                if not APsFOCPostingSetup.IsEmpty() then begin
                    SalesLine.Quantity := xSalesLine.Quantity;
                    SalesLine."Outstanding Quantity" := Abs(SalesLine."Qty. to Ship");
                    IsHandled := true;
                end;
            end;
        //#391
    end;
    #endregion Sales Line

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnAfterInsertInvLineFromShptLine', '', false, false)]
    local procedure SalesShipmentLine_OnAfterInsertInvLineFromShptLine(var SalesLine: Record "Sales Line"; SalesOrderLine: Record "Sales Line"; var NextLineNo: Integer; SalesShipmentLine: Record "Sales Shipment Line")
    var
        lSalesFunctions: Codeunit "ecSales Functions";
    begin
        //CS_PRO_009-s
        lSalesFunctions.ManageKitExhibLineOnCreateSalesInv(SalesLine, NextLineNo);
        //CS_PRO_009-e
    end;

    #region Calendar Entry

    [EventSubscriber(ObjectType::Table, Database::"Calendar Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure CalendarEntry_OnAfterInsertEvent(var Rec: Record "Calendar Entry"; RunTrigger: Boolean)
    var
        lSessionDataStore: Codeunit "AltATSSession Data Store";
        lCalendarCode: Code[10];
    begin
        //CS_PRO_018-s
        lCalendarCode := lSessionDataStore.GetSessionSettingValue('CalcScheduleAppliedCalendarCode');
        if (lCalendarCode <> '') then begin
            Rec."ecApplied Calendar Code" := lCalendarCode;
        end;
        lSessionDataStore.RemoveSessionSetting('CalcScheduleAppliedCalendarCode');
        //CS_PRO_018-e  
    end;

    #endregion Calendar Entry

    #region Production Order

    [EventSubscriber(ObjectType::Table, Database::"Production Order", 'OnBeforeMultiLevelMessage', '', false, false)]
    local procedure ProductionOrder_OnBeforeMultiLevelMessage(var IsHandled: Boolean; var ProductionOrder: Record "Production Order"; var xProductionOrder: Record "Production Order"; CurrentFieldNo: Integer)
    var
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //GAP_PRO_018-s
        if lATSSessionDataStore.GetSessionSettingBooleanValue('HideMultiLevelMessage') then begin
            IsHandled := true;
        end;
        //GAP_PRO_018-e
    end;

    #endregion Production Order

    #region Prod. Order Component

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Component", 'OnAfterCopyFromPlanningComp', '', false, false)]
    local procedure ProdOrderComponent_OnAfterCopyFromPlanningComp(var ProdOrderComponent: Record "Prod. Order Component"; PlanningComponent: Record "Planning Component")
    begin
        //GAP_PRO_003-s
        ProdOrderComponent."ecSource Qty. per" := PlanningComponent."ecSource Qty. per";
        //GAP_PRO_003-e    
    end;

    #endregion Prod. Order Component

    #region Warehouse Shipment Line
    [EventSubscriber(ObjectType::Table, Database::"Warehouse Shipment Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure WarehouseShipmentLine_OnAfterValidateEvent_Quantity(var Rec: Record "Warehouse Shipment Line";
                                                                        var xRec: Record "Warehouse Shipment Line";
                                                                        CurrFieldNo: Integer)
    begin
        //CS_VEN_014-VI-s
        Rec.ecUpdateConsumerUMQuantity();
        //CS_VEN_014-VI-e
    end;

    #endregion Warehouse Shipment Line

    #region Requisition Line

    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", OnBeforeValidateEvent, 'Accept Action Message', false, false)]
    local procedure RequisitionLine_OnBeforeValidateEvent_AcceptActionMessage(var Rec: Record "Requisition Line";
                                                                              var xRec: Record "Requisition Line";
                                                                              CurrFieldNo: Integer)

    var
        lNotAcceptableMessageErr: Label 'Cannot accept this message directly.\You must accept the parent production of the production order %1';
    begin
        //CS_PRO_044-VI-s
        if (Rec."Accept Action Message") and (Rec."Planning Level" > 0) then begin
            if (Rec."Action Message" = Rec."Action Message"::New) and
               (Rec."Ref. Order Type" = Rec."Ref. Order Type"::"Prod. Order") and
               (Rec."Ref. Order Status" = Rec."Ref. Order Status"::Planned) and
               (Rec."Ref. Order No." <> '')
            then begin
                Error(lNotAcceptableMessageErr, Rec."Ref. Order No.");
            end;
        end;
        //CS_PRO_044-VI-e
    end;

    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnSetReplenishmentSystemFromProdOrderOnBeforeSetProdFields', '', false, false)]
    local procedure RequisitionLine_OnSetReplenishmentSystemFromProdOrderOnBeforeSetProdFields(var RequisitionLine: Record "Requisition Line";
                                                                                               Item: Record Item;
                                                                                               Subcontracting: Boolean;
                                                                                               var TempPlanningErrorLog: Record "Planning Error Log";
                                                                                               PlanningResiliency: Boolean)
    var
        lecProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_044-VI-s
        if not Subcontracting then begin
            lecProductionFunctions.CheckItemProductionPlanningParameters(Item, RequisitionLine."Location Code", RequisitionLine."Variant Code");
        end;
        //CS_PRO_044-VI-e
    end;

    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure RequisitionLine_OnBeforeInsertEvent(var Rec: Record "Requisition Line"; RunTrigger: Boolean)
    begin
        //CS_PRO_039-s
        Rec.UpdateRequisitionLine();
        //CS_PRO_039-e
    end;

    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnBeforeModifyEvent', '', false, false)]
    local procedure RequisitionLine_OnAfterInsertEvent(var Rec: Record "Requisition Line"; RunTrigger: Boolean)
    begin
        //CS_PRO_039-s
        Rec.UpdateRequisitionLine();
        //CS_PRO_039-e
    end;

    #endregion Requisition Line

    #region PaymentLines

    [EventSubscriber(ObjectType::Table, Database::"Payment Lines", OnCreatePaymentLinesSalesOnAfterPopulatePaymentLines, '', false, false)]
    local procedure "Payment Lines_OnCreatePaymentLinesSalesOnAfterPopulatePaymentLines"(var PaymentLines: Record "Payment Lines"; PaymentLinesTerms: Record "Payment Lines"; SalesHeader: Record "Sales Header")
    var
        EcSetup: Record "ecGeneral Setup";
    begin
        EcSetup.Get();
        if EcSetup."Use Custom Calc. Due Date" then
            if SalesHeader."ecRef. Date For Calc. Due Date" <> 0D then
                PaymentLines."Due Date" := CalcDate(PaymentLinesTerms."Due Date Calculation", SalesHeader."ecRef. Date For Calc. Due Date");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Payment Lines", OnCreatePaymentLiensPurchasesOnAfterPopulatePaymentLines, '', false, false)]
    local procedure "Payment Lines_OnCreatePaymentLiensPurchasesOnAfterPopulatePaymentLines"(var PaymentLines: Record "Payment Lines"; PaymentLinesTerms: Record "Payment Lines"; PurchaseHeader: Record "Purchase Header")
    var
        EcSetup: Record "ecGeneral Setup";
    begin
        EcSetup.Get();
        if EcSetup."Use Custom Calc. Due Date" then
            if PurchaseHeader."ecRef. Date For Calc. Due Date" <> 0D then
                PaymentLines."Due Date" := CalcDate(PaymentLinesTerms."Due Date Calculation", PurchaseHeader."ecRef. Date For Calc. Due Date");
    end;

    #endregion PaymentLines

    #region General Journal Lines

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnBeforeValidateDocumentDateFromPostingDate, '', false, false)]
    local procedure "Gen. Journal Line_OnBeforeValidateDocumentDateFromPostingDate"(var GenJournalLine: Record "Gen. Journal Line"; xGenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        EcSetup: Record "ecGeneral Setup";
    begin
        EcSetup.Get();
        if EcSetup."Use Custom Calc. Due Date" then
            GenJournalLine.Validate("ecRef. Date For Calc. Due Date", GenJournalLine."Posting Date");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnCreatePurchasePaymentLineOnAfterCalculateDueDate, '', false, false)]
    local procedure "Gen. Journal Line_OnCreatePurchasePaymentLineOnAfterCalculateDueDate"(var PaymentPurchase: Record "Payment Lines"; PaymentTermsLine: Record "Payment Lines"; GenJournalLine: Record "Gen. Journal Line")
    var
        EcSetup: Record "ecGeneral Setup";
    begin
        EcSetup.Get();
        if EcSetup."Use Custom Calc. Due Date" then
            if GenJournalLine."ecRef. Date For Calc. Due Date" <> 0D then
                PaymentPurchase."Due Date" := CalcDate(PaymentTermsLine."Due Date Calculation", GenJournalLine."ecRef. Date For Calc. Due Date");
    end;
    #endregion General Journal Lines

    #region Purchase Header

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnInitRecordOnAfterAssignDates, '', false, false)]
    local procedure "Purchase Header_OnInitRecordOnAfterAssignDates"(var PurchaseHeader: Record "Purchase Header")
    var
        EcSetup: Record "ecGeneral Setup";
    begin
        EcSetup.Get();
        if EcSetup."Use Custom Calc. Due Date" then
            if EcSetup."Use Document Date As Default" then
                PurchaseHeader.Validate("ecRef. Date For Calc. Due Date", PurchaseHeader."Document Date");
    end;

    #endregion Purchase Header

    #region Purchase Line
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterValidateNoPurchaseLine, '', false, false)]
    local procedure "Purchase Line_OnAfterValidateNoPurchaseLine"(var PurchaseLine: Record "Purchase Line"; var xPurchaseLine: Record "Purchase Line"; var TempPurchaseLine: Record "Purchase Line" temporary; PurchaseHeader: Record "Purchase Header")
    var
        Item: Record Item;
    begin
        //#376
        if PurchaseLine."Document Type" in [PurchaseLine."Document Type"::"Return Order", PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice, PurchaseLine."Document Type"::"Credit Memo"] then begin
            if PurchaseLine.Type = PurchaseLine.Type::Item then begin
                if Item.Get(PurchaseLine."No.") then begin
                    PurchaseLine.Validate("Job No.", Item."ecJob No.");
                    PurchaseLine.Validate("Job Task No.", Item."ecJob Task No.");
                end;
            end;
        end;
        //#376
    end;

    #endregion Purchase Line

    #endregion Table

    #region Codeunit

    #region Sales Post

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesDoc, '', false, false)]
    local procedure "Sales-Post_OnBeforePostSalesDoc"(var Sender: Codeunit "Sales-Post"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean; var CalledBy: Integer)
    var
        EcSetup: Record "ecGeneral Setup";
        EmptyRefDateForCalcDueDateErr: Label 'The Ref. Date For Calc. Due Date cannot be empty if the custom calculation setup is active.';
    begin
        EcSetup.Get();
        if EcSetup."Use Custom Calc. Due Date" then
            if SalesHeader."ecRef. Date For Calc. Due Date" = 0D then
                Error(EmptyRefDateForCalcDueDateErr);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterFinalizePosting, '', false, false)]
    local procedure "Sales-Post_OnAfterFinalizePosting"(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    begin
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Invoice:
                begin
                    SalesInvoiceHeader.Validate("ecRef. Date For Calc. Due Date", SalesHeader."ecRef. Date For Calc. Due Date");
                    SalesInvoiceHeader.Modify();
                end;

            SalesHeader."Document Type"::"Credit Memo":
                begin
                    SalesCrMemoHeader.Validate("ecRef. Date For Calc. Due Date", SalesHeader."ecRef. Date For Calc. Due Date");
                    SalesCrMemoHeader.Modify();
                end;

            SalesHeader."Document Type"::Order:
                begin
                    SalesShipmentHeader.Validate("ecRef. Date For Calc. Due Date", SalesHeader."ecRef. Date For Calc. Due Date");
                    SalesShipmentHeader.Modify();
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterPostSalesDoc, '', false, false)]
    local procedure "Sales-Post_OnAfterPostSalesDoc"(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean; PreviewMode: Boolean)
    var
        lecGeneralSetup: Record "ecGeneral Setup";
        CustPostGroup: Record "Customer Posting Group";
    begin
        if lecGeneralSetup.Get() and lecGeneralSetup."Use Custom Calc. Due Date" and (CustLedgerEntry."Entry No." <> 0) then begin
            CustLedgerEntry.Validate("ecRef. Date For Calc. Due Date", SalesHeader."ecRef. Date For Calc. Due Date");
            CustLedgerEntry.Modify();
        end;

        //#389
        if CustPostGroup.Get(CustLedgerEntry."Customer Posting Group") then
            if CustPostGroup."ecInclude Mgt. Insured" then begin
                CustLedgerEntry."ecCredit Insured" := true;
                CustLedgerEntry.Modify();
            end;
        //#389
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterInsertShipmentLine, '', false, false)]
    local procedure "Sales-Post_OnAfterInsertShipmentLine"(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var SalesShptLine: Record "Sales Shipment Line"; PreviewMode: Boolean; xSalesLine: Record "Sales Line")
    var
        PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
        PalletsMgt: Codeunit "ecPallets Management";
        ToActive: Boolean;
    begin
        //#229
        if PostedWhseShipmentHeader.Get(SalesShptLine."AltAWPPosted Whse Shipment No.") then
            if not PostedWhseShipmentHeader."ecAlready Checked" then begin
                PalletsMgt.ValidatecAllowAdjmtInShipReceipt(PostedWhseShipmentHeader, ToActive);
                if ToActive then begin
                    PostedWhseShipmentHeader."ecAllow Adjmt. In Ship/Receipt" := true;
                    PostedWhseShipmentHeader."ecPallet Status Mgt." := PostedWhseShipmentHeader."ecPallet Status Mgt."::Required;
                    PostedWhseShipmentHeader.Modify(true);
                end;
            end;
        //#229
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostItemLineOnBeforePostItemInvoiceLine', '', false, false)]
    local procedure SalesPost_OnPostItemLineOnBeforePostItemInvoiceLine(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var TempDropShptPostBuffer: Record "Drop Shpt. Post. Buffer" temporary; var TempPostedATOLink: Record "Posted Assemble-to-Order Link" temporary; var RemQtyToBeInvoiced: Decimal; var RemQtyToBeInvoicedBase: Decimal)
    var
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_VEN_036-s
        if SalesLine."ecExclude From Item Ledg.Entry" then begin
            lATSSessionDataStore.AddSessionSetting('ExcludeItemLedgEntryPosting', true);
            lATSSessionDataStore.AddSessionSetting('SalesLineQtyToInvStored', RemQtyToBeInvoiced);
            RemQtyToBeInvoiced := 0;
        end;
        //CS_VEN_036-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostItemLineOnBeforeMakeSalesLineToShip', '', false, false)]
    local procedure SalesPost_OnPostItemLineOnBeforeMakeSalesLineToShip(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var TempPostedATOLink: Record "Posted Assemble-to-Order Link" temporary; var ItemLedgShptEntryNo: Integer; var IsHandled: Boolean; var GenJnlLineDocNo: Code[20]; var GenJnlLineExtDocNo: Code[35]; ReturnReceiptHeader: Record "Return Receipt Header"; var TempHandlingSpecification: Record "Tracking Specification" temporary; var TempHandlingSpecificationInv: Record "Tracking Specification" temporary; var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_VEN_036-s
        if lATSSessionDataStore.GetSessionSettingBooleanValue('ExcludeItemLedgEntryPosting') then IsHandled := true;
        //CS_VEN_036-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostItemLine', '', false, false)]
    local procedure SalesPost_OnAfterPostItemLine(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; QtyToInvoice: Decimal; QtyToInvoiceBase: Decimal; CommitIsSuppressed: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line")
    var
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_VEN_036-s
        QtyToInvoice := lATSSessionDataStore.GetSessionSettingNumericValue('SalesLineQtyToInvStored');
        lATSSessionDataStore.RemoveSessionSetting('SalesLineQtyToInvStored');
        lATSSessionDataStore.RemoveSessionSetting('ExcludeItemLedgEntryPosting');
        //CS_VEN_036-e
    end;

    #endregion Sales Post

    #region Purch Post

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterPurchRcptLineInsert, '', false, false)]
    local procedure "Purch.-Post_OnAfterPurchRcptLineInsert"(PurchaseLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean; PurchInvHeader: Record "Purch. Inv. Header"; var TempTrackingSpecification: Record "Tracking Specification" temporary; PurchRcptHeader: Record "Purch. Rcpt. Header"; TempWhseRcptHeader: Record "Warehouse Receipt Header"; xPurchLine: Record "Purchase Line"; var TempPurchLineGlobal: Record "Purchase Line" temporary)
    var
        PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header";
        PalletsMgt: Codeunit "ecPallets Management";
        ToActive: Boolean;
    begin
        //#229
        if PostedWhseReceiptHeader.Get(PurchRcptLine."AltAWPPosted Whse Receipt No.") then
            if not PostedWhseReceiptHeader."ecAlready Checked" then begin
                PalletsMgt.ValidatecAllowAdjmtInShipReceipt(PostedWhseReceiptHeader, ToActive);
                if ToActive then begin
                    PostedWhseReceiptHeader."ecAllow Adjmt. In Ship/Receipt" := true;
                    PostedWhseReceiptHeader."ecPallet Status Mgt." := PostedWhseReceiptHeader."ecPallet Status Mgt."::Required;
                    PostedWhseReceiptHeader.Modify(true);
                end;
            end;
        //#229
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterFinalizePosting, '', false, false)]
    local procedure "Purch.-Post_OnAfterFinalizePosting"(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ReturnShptHeader: Record "Return Shipment Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        GeneralSetup: Record "ecGeneral Setup";
    begin
        GeneralSetup.Get();

        case PurchHeader."Document Type" of
            PurchHeader."Document Type"::Invoice:
                begin
                    PurchInvHeader.Validate("ecRef. Date For Calc. Due Date", PurchHeader."ecRef. Date For Calc. Due Date");
                    PurchInvHeader.Validate("ecNotes payment suspension", PurchHeader."ecNotes payment suspension");

                    // if GeneralSetup."Enable Customs Declarations" then
                    //     PurchInvHeader.Validate("ecNo. Invoice Cust. Decl.", PurchHeader."ecNo. Invoice Cust. Decl.");

                    PurchInvHeader.Modify();

                    VendorLedgerEntry.Reset();
                    VendorLedgerEntry.SetRange("Document No.", PurchInvHeader."No.");
                    if VendorLedgerEntry.FindSet() then
                        repeat
                            VendorLedgerEntry.Validate("ecRef. Date For Calc. Due Date", PurchInvHeader."ecRef. Date For Calc. Due Date");
                            VendorLedgerEntry.Validate("ecNotes payment suspension", PurchInvHeader."ecNotes payment suspension");

                            // if GeneralSetup."Enable Customs Declarations" then
                            //     VendorLedgerEntry.Validate("ecNo. Invoice Cust. Decl.", PurchInvHeader."ecNo. Invoice Cust. Decl.");

                            VendorLedgerEntry.Modify();
                        until VendorLedgerEntry.Next() = 0;
                end;

            PurchHeader."Document Type"::"Credit Memo":
                begin
                    PurchCrMemoHdr.Validate("ecRef. Date For Calc. Due Date", PurchHeader."ecRef. Date For Calc. Due Date");
                    PurchCrMemoHdr.Modify();

                    VendorLedgerEntry.Reset();
                    VendorLedgerEntry.SetRange("Document No.", PurchCrMemoHdr."No.");
                    if VendorLedgerEntry.FindSet() then
                        repeat
                            VendorLedgerEntry.Validate("ecRef. Date For Calc. Due Date", PurchCrMemoHdr."ecRef. Date For Calc. Due Date");
                            VendorLedgerEntry.Modify();
                        until VendorLedgerEntry.Next() = 0;
                end;

            PurchHeader."Document Type"::Order:
                begin
                    PurchRcptHeader.Validate("ecRef. Date For Calc. Due Date", PurchHeader."ecRef. Date For Calc. Due Date");
                    PurchRcptHeader.Modify();

                    VendorLedgerEntry.Reset();
                    VendorLedgerEntry.SetRange("Document No.", PurchRcptHeader."No.");
                    if VendorLedgerEntry.FindSet() then
                        repeat
                            VendorLedgerEntry.Validate("ecRef. Date For Calc. Due Date", PurchRcptHeader."ecRef. Date For Calc. Due Date");
                            VendorLedgerEntry.Modify();
                        until VendorLedgerEntry.Next() = 0;
                end;
        end;
    end;

    procedure Notespaymentsuspension(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        VendorLedgerEntry.Modify(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterUpdatePostingNos', '', false, false)]
    local procedure PurchPost_OnAfterUpdatePostingNos(var PurchaseHeader: Record "Purchase Header"; var NoSeriesMgt: Codeunit NoSeriesManagement;
                                                      CommitIsSupressed: Boolean; PreviewMode: Boolean; var ModifyHeader: Boolean)
    var
        lNoSeries: Record "No. Series";
        lPurchaseFunctions: Codeunit "ecPurchase Functions";
    begin
        //CS_AFC_018-s
        if PurchaseHeader.Invoice or (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) or
           (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo")
        then begin
            lNoSeries.Get(PurchaseHeader."Operation Type");
            if lNoSeries."ecNot Create Vat Entry" then lPurchaseFunctions.CkeckPurchReceipt(PurchaseHeader);
        end;
        //CS_AFC_018-e
    end;

#pragma warning disable AL0432
    //#TODO# Utilizzato evento della vecchia gestione della fatturazione per gestire il NO IVA. 
    //Ho inserito lo stesso codice anche nell'evento relativo alla nuova gestione: Codeunit "Purch. Post Invoice Events" Evento: 'OnPostLinesOnBeforeGenJnlLinePost'
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostInvPostBuffer', '', false, false)]
    local procedure PurchPost_OnBeforePostInvPostBuffer(var GenJnlLine: Record "Gen. Journal Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer"; var PurchHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var GenJnlLineDocNo: Code[20])
#pragma warning restore AL0432
    var
        lNoSeries: Record "No. Series";
    begin
        //CS_AFC_018-s
        if lNoSeries.Get(PurchHeader."Operation Type") then begin
            if lNoSeries."ecNot Create Vat Entry" then begin
                GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                GenJnlLine."Gen. Bus. Posting Group" := '';
                GenJnlLine."Gen. Prod. Posting Group" := '';
                GenJnlLine."VAT Bus. Posting Group" := '';
                GenJnlLine."VAT Prod. Posting Group" := '';
                GenJnlLine."Tax Area Code" := '';
                GenJnlLine."Tax Liable" := false;
                GenJnlLine."Tax Group Code" := '';
                GenJnlLine."Use Tax" := false;
                GenJnlLine."VAT Calculation Type" := GenJnlLine."VAT Calculation Type"::"Normal VAT";
                GenJnlLine."Deductible %" := 0;
                GenJnlLine."VAT Identifier" := '';
                GenJnlLine."VAT Base Amount" := 0;
                GenJnlLine."VAT Base Discount %" := 0;
                GenJnlLine."Source Curr. VAT Base Amount" := 0;
                GenJnlLine."VAT Amount" := 0;
                GenJnlLine."Source Curr. VAT Amount" := 0;
                GenJnlLine."VAT Difference" := 0;
                GenJnlLine."VAT Posting" := GenJnlLine."VAT Posting"::"Manual VAT Entry";
            end;
        end;
        //CS_AFC_018-e
    end;

    #endregion Purch Post

    #region Purch. Post Invoice Events

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", 'OnPostLinesOnBeforeGenJnlLinePost', '', false, false)]
    local procedure PurchPostInvoiceEvents_OnPostLinesOnBeforeGenJnlLinePost(var GenJnlLine: Record "Gen. Journal Line"; PurchHeader: Record "Purchase Header";
                                                                             TempInvoicePostingBuffer: Record "Invoice Posting Buffer";
                                                                             var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean;
                                                                             SuppressCommit: Boolean)
    var
        lNoSeries: Record "No. Series";
    begin
        //CS_AFC_018-s
        if lNoSeries.Get(PurchHeader."Operation Type") then begin
            if lNoSeries."ecNot Create Vat Entry" then begin
                GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                GenJnlLine."Gen. Bus. Posting Group" := '';
                GenJnlLine."Gen. Prod. Posting Group" := '';
                GenJnlLine."VAT Bus. Posting Group" := '';
                GenJnlLine."VAT Prod. Posting Group" := '';
                GenJnlLine."Tax Area Code" := '';
                GenJnlLine."Tax Liable" := false;
                GenJnlLine."Tax Group Code" := '';
                GenJnlLine."Use Tax" := false;
                GenJnlLine."VAT Calculation Type" := GenJnlLine."VAT Calculation Type"::"Normal VAT";
                GenJnlLine."Deductible %" := 0;
                GenJnlLine."VAT Identifier" := '';
                GenJnlLine."VAT Base Amount" := 0;
                GenJnlLine."VAT Base Discount %" := 0;
                GenJnlLine."Source Curr. VAT Base Amount" := 0;
                GenJnlLine."VAT Amount" := 0;
                GenJnlLine."Source Curr. VAT Amount" := 0;
                GenJnlLine."VAT Difference" := 0;
                GenJnlLine."VAT Posting" := GenJnlLine."VAT Posting"::"Manual VAT Entry";
            end;
        end;
        //CS_AFC_018-e
    end;

    #endregion Purch. Post Invoice Events

    #region Sales-Quote to Order

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeModifySalesOrderHeader', '', false, false)]
    local procedure SalesQuoteToOrder_OnBeforeModifySalesOrderHeader(var SalesOrderHeader: Record "Sales Header"; SalesQuoteHeader: Record "Sales Header")
    begin
        //CS_VEN_034-s
        SalesOrderHeader."ecProduct Segment No." := SalesQuoteHeader."ecProduct Segment No.";
        SalesOrderHeader."ecSales Manager Code" := SalesQuoteHeader."ecSales Manager Code";
        //CS_VEN_034-e
    end;

    #endregion Sales-Quote to Order

    #region GenJnlPostLine
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInitCustLedgEntry, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnAfterInitCustLedgEntry"(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; var GLRegister: Record "G/L Register")
    var
        CustPostGroup: Record "Customer Posting Group";
    begin
        //#389
        if CustPostGroup.Get(CustLedgerEntry."Customer Posting Group") then
            if CustPostGroup."ecInclude Mgt. Insured" then
                CustLedgerEntry."ecCredit Insured" := true;
        //#389
    end;
    #endregion GenJnlPostLine

    #region Release Sales Document
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnCodeOnAfterCheck', '', false, false)]
    local procedure ReleaseSalesDocument_OnCodeOnAfterCheck(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var LinesWereModified: Boolean)
    var
        lecSalesFunctions: Codeunit "ecSales Functions";
    begin
        //CS_VEN_032-VI-s
        lecSalesFunctions.SalesDocumentCheck(SalesHeader);
        //CS_VEN_032-VI-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnCodeOnBeforeSetStatusReleased', '', true, true)]
    local procedure AltOnCodeOnBeforeSetStatusReleased(var SalesHeader: Record "Sales Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        SalesFunctions: Codeunit "ecSales Functions";
    begin
        //#391
        if not ApprovalsMgmt.IsSalesHeaderPendingApproval(SalesHeader) then
            SalesFunctions.SetOMRQty(SalesHeader);
        //#391
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', true, true)]
    local procedure AltOnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; SkipCheckReleaseRestrictions: Boolean)
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        SalesFunctions: Codeunit "ecSales Functions";
    begin
        //#391
        if not ApprovalsMgmt.IsSalesHeaderPendingApproval(SalesHeader) then
            SalesFunctions.SetOMRQty(SalesHeader);
        //#391
    end;

    #endregion Release Sales Document

    #region Release Purchase Document

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnCodeOnAfterCheck', '', false, false)]
    local procedure ReleasePurchaseDocument_OnCodeOnAfterCheck(PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; var LinesWereModified: Boolean)
    var
        lPurchaseFunctions: Codeunit "ecPurchase Functions";
    begin
        //CS_AFC_018-s
        lPurchaseFunctions.PurchaseDocumentCheck(PurchaseHeader);
        //CS_AFC_018-e
    end;

    #endregion Release Purchase Document

    #region Shop Calendar Management

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shop Calendar Management", 'OnCalculateScheduleOnSetShopCalendarFilters', '', false, false)]
    local procedure ShopCalendarManagement_OnCalculateScheduleOnSetShopCalendarFilters(var ShopCalendarWorkingDays: Record "Shop Calendar Working Days"; PeriodDate: Date)
    var
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_018-s
        lProductionFunctions.CheckProdAlternativeCalendar(ShopCalendarWorkingDays, PeriodDate);
        //CS_PRO_018-e        
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shop Calendar Management", 'OnCalculateScheduleOnBeforeProcessShopCalendar', '', false, false)]
    local procedure ShopCalendarManagement_OnCalculateScheduleOnBeforeProcessShopCalendar(var ShopCalendarWorkingDays: Record "Shop Calendar Working Days"; PeriodDate: Date;
                                                                                              StartingDate: Date; EndingDate: Date; var IsHandled: Boolean)
    var
        lSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_PRO_018-s
        lSessionDataStore.AddSessionSetting('CalcScheduleAppliedCalendarCode', ShopCalendarWorkingDays."Shop Calendar Code");
        //CS_PRO_018-e
    end;
    #endregion Shop Calendar Management

    #region Calculate Prod. Order
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Prod. Order", 'OnAfterTransferBOMComponent', '', false, false)]
    local procedure CalculateProdOrder_OnAfterTransferBOMComponent(var ProdOrderLine: Record "Prod. Order Line"; var ProductionBOMLine: Record "Production BOM Line";
                                                                   var ProdOrderComponent: Record "Prod. Order Component"; LineQtyPerUOM: Decimal; ItemQtyPerUOM: Decimal)
    begin
        //GAP_PRO_003-s
        ProdOrderComponent."ecSource Qty. per" := ProductionBOMLine."Quantity per";
        //GAP_PRO_003-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Prod. Order", 'OnBeforeUpdateProdOrderDates', '', false, false)]
    local procedure CalculateProdOrder_OnBeforeUpdateProdOrderDates(var ProductionOrder: Record "Production Order"; var ProdOrderLine: Record "Prod. Order Line";
                                                                    var ProdOrderModify: Boolean)
    var
        lSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_PRO_044-s
        lSessionDataStore.AddSessionSetting('RecalcSendAheadAfterUpdateProdOrderDates', true);
        //CS_PRO_044-e
    end;

    #endregion Calculate Prod. Order

    #region Create Prod. Order Lines

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order Lines", 'OnAfterInitProdOrderLine', '', false, false)]
    local procedure CreateProdOrderLines_OnAfterInitProdOrderLine(var ProdOrderLine: Record "Prod. Order Line"; ProdOrder: Record "Production Order"; SalesLine: Record "Sales Line")
    begin
        //CS_PRO_039-s
        if (ProdOrderLine.Status = ProdOrderLine.Status::Released) then ProdOrderLine.Validate("ecProductive Status", ProdOrderLine."ecProductive Status"::Released);
        //CS_PRO_039-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order Lines", 'OnBeforeProdOrderLineInsert', '', false, false)]
    local procedure CreateProdOrderLines_OnBeforeProdOrderLineInsert(var ProdOrderLine: Record "Prod. Order Line"; var ProductionOrder: Record "Production Order";
                                                                     SalesLineIsSet: Boolean; var SalesLine: Record "Sales Line")
    var
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
        lNewRoutingNo: Code[20];
    begin
        //GAP_PRO_003-s
        if (ProdOrderLine."Planning Level Code" = 0) then begin
            lNewRoutingNo := lATSSessionDataStore.GetSessionSettingValue('OnUpdateRoutingOnProdOrder');
            if (lNewRoutingNo <> '') and (lNewRoutingNo <> ProdOrderLine."Routing No.") then begin
                ProdOrderLine.Validate("Routing No.", lNewRoutingNo);
            end;
        end;
        //GAP_PRO_003-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order Lines", 'OnBeforeInitProdOrderLine', '', false, false)]
    local procedure CreateProdOrderLines_OnBeforeInitProdOrderLine(ProductionOrder: Record "Production Order"; SalesLine: Record "Sales Line";
                                                                   var ItemNo: Code[20]; var VariantCode: Code[10]; var LocationCode: Code[10];
                                                                   var IsHandled: Boolean)
    var
        lItem: Record Item;
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_018-s
        if lItem.Get(ItemNo) then begin
            lProductionFunctions.CheckItemProductionPlanningParameters(lItem, LocationCode, VariantCode);
        end;
        //CS_PRO_018-e
    end;

    #endregion Create Prod. Order Lines

    #region Calculate Routing Line
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Routing Line", 'OnBeforeCalcExpectedCost', '', false, false)]
    local procedure CalculateRoutingLine_OnBeforeCalcExpectedCost(var ProdOrderRoutingLine: Record "Prod. Order Routing Line";
                                                              var ActualOperOutput: Decimal;
                                                              var MaxLotSize: Decimal;
                                                              var TotalQtyPerOperation: Decimal)
    var
        lProdOrderLine: Record "Prod. Order Line";
        lProdOrderQty: Decimal;
        lExpectedOperOutput: Decimal;
        lTotalScrap: Decimal;
    begin
        //CS_PRO_018-s
        // Ricalcolo capacità allocata su righe ciclo ODP in funzione della quantità di output residua per l'operazione
        if (ActualOperOutput > 0) then begin
            lProdOrderQty := 0;
            lTotalScrap := 0;

            lProdOrderLine.SetRange(Status, ProdOrderRoutingLine.Status);
            lProdOrderLine.SetRange("Prod. Order No.", ProdOrderRoutingLine."Prod. Order No.");
            lProdOrderLine.SetRange("Routing Reference No.", ProdOrderRoutingLine."Routing Reference No.");
            lProdOrderLine.SetRange("Routing No.", ProdOrderRoutingLine."Routing No.");
            lProdOrderLine.SetLoadFields("Quantity (Base)", "Scrap %", "Prod. Order No.", "Line No.", Status);
            if lProdOrderLine.FindSet() then begin
                lExpectedOperOutput := 0;
                repeat
                    lExpectedOperOutput += lProdOrderLine."Quantity (Base)";
                    lTotalScrap += lProdOrderLine."Scrap %";
                until lProdOrderLine.Next() = 0;

                lProdOrderQty := lExpectedOperOutput - ActualOperOutput;
                if lProdOrderQty < 0 then lProdOrderQty := 0;
            end;

            MaxLotSize := lProdOrderQty *
                          (1 + ProdOrderRoutingLine."Scrap Factor % (Accumulated)") *
                          (1 + lTotalScrap / 100) +
                          ProdOrderRoutingLine."Fixed Scrap Qty. (Accum.)";

            ProdOrderRoutingLine."Input Quantity" := MaxLotSize;
        end;
        //CS_PRO_018-e
    end;
    #endregion Calculate Routing Line

    #region Prod. Order Status Management

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnBeforeChangeStatusOnProdOrder', '', false, false)]
    local procedure ProdOrderStatusManagement_OnBeforeChangeStatusOnProdOrder(var ProductionOrder: Record "Production Order";
                                                                              NewStatus: Option Quote,Planned,"Firm Planned",Released,Finished;
                                                                              var IsHandled: Boolean; NewPostingDate: Date; NewUpdateUnitCost: Boolean)
    var
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_039-s
        lProductionFunctions.CheckProdOrderChangeStatus(ProductionOrder, NewStatus, true);
        //CS_PRO_039-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnAfterChangeStatusOnProdOrder', '', false, false)]
    local procedure ProdOrderStatusManagement_OnAfterChangeStatusOnProdOrder(var ProdOrder: Record "Production Order";
                                                                             var ToProdOrder: Record "Production Order"; NewStatus: Enum "Production Order Status";
                                                                                                                                        NewPostingDate: Date;
                                                                                                                                        NewUpdateUnitCost: Boolean; var SuppressCommit: Boolean)
    var
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_044-s
        if (NewStatus = NewStatus::Released) then begin
            lProductionFunctions.UpdateProductionOrderLines(ProdOrder, false);
        end;
        //CS_PRO_044-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnCopyFromProdOrderLine', '', false, false)]
    local procedure ProdOrderStatusManagement_OnCopyFromProdOrderLine(var ToProdOrderLine: Record "Prod. Order Line"; FromProdOrderLine: Record "Prod. Order Line")
    begin
        //CS_PRO_039-s
        if (ToProdOrderLine.Status = ToProdOrderLine.Status::Released) and
           (ToProdOrderLine."ecProductive Status".AsInteger() < ToProdOrderLine."ecProductive Status"::Released.AsInteger())
        then begin
            ToProdOrderLine.Validate("ecProductive Status", ToProdOrderLine."ecProductive Status"::Released);
        end;
        //CS_PRO_039-e
    end;

    #endregion Prod. Order Status Management

    #region Prod. Order Route Management

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Route Management", 'OnBeforeUpdateComponentsBin', '', false, false)]
    local procedure ProdOrderRouteManagement_OnBeforeUpdateComponentsBin(var ProdOrderRoutingLine: Record "Prod. Order Routing Line"; var SkipUpdate: Boolean;
                                                                         var ErrorOccured: Boolean; var AutoUpdateCompBinCode: Boolean)
    var
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_PRO_044-s
        if lATSSessionDataStore.GetSessionSettingBooleanValue('SetAutoUpdateBinCodeOnProdOrderRouteManagement') then begin
            AutoUpdateCompBinCode := true;
        end;
        //CS_PRO_044-e
    end;

    #endregion Prod. Order Route Management

    #region Production BOM-Check

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production BOM-Check", 'OnAfterCode', '', false, false)]
    local procedure ProductionBOMCheck_OnAfterCode(var ProductionBOMHeader: Record "Production BOM Header"; VersionCode: Code[20])
    var
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_041_BIS-s
        lProductionFunctions.CheckProdBOMLineByProductComp(ProductionBOMHeader, VersionCode);
        //CS_PRO_041_BIS-e
    end;

    #endregion Production BOM-Check

    #region Production Journal Mgt

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", 'OnBeforeSetTemplateAndBatchName', '', false, false)]
    local procedure ProductionJournalMgt_OnBeforeSetTemplateAndBatchName(var ToTemplateName: Code[10]; var ToBatchName: Code[10]; var IsHandled: Boolean)
    var
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
        lBatchName: Text;
        lTemplateName: Text;
    begin
        //CS_PRO_050-s
        lTemplateName := lATSSessionDataStore.GetSessionSettingValue('ProductionJournalMgt_SetTemplateName');
        lBatchName := lATSSessionDataStore.GetSessionSettingValue('ProductionJournalMgt_SetBatchName');
        if (lTemplateName <> '') and (lBatchName <> '') then begin
            ToBatchName := lBatchName;
            ToTemplateName := lTemplateName;
            IsHandled := true;
        end;
        //CS_PRO_050-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", 'OnBeforeInsertOutputJnlLine', '', false, false)]
    local procedure ProductionJournalMgt_OnInsertOutputItemJnlLineOnAfterCopyItemTracking(var ItemJournalLine: Record "Item Journal Line";
                                                                                          ProdOrderRtngLine: Record "Prod. Order Routing Line"; ProdOrderLine: Record "Prod. Order Line")
    begin
        //CS_PRO_035-s
        if (ProdOrderRtngLine."Next Operation No." = '') then begin
            if (ProdOrderLine."ecOutput Lot No." <> '') then begin
                ItemJournalLine.Validate("AltAWPLot No.", ProdOrderLine."ecOutput Lot No.");
                if (ProdOrderLine."ecOutput Lot Exp. Date" <> 0D) then ItemJournalLine.Validate("AltAWPExpiration Date", ProdOrderLine."ecOutput Lot Exp. Date");
            end;
        end;
        //CS_PRO_035-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", 'OnBeforeRunProductionJnl', '', false, false)]
    local procedure ProductionJournalMgt_OnBeforeRunProductionJnl(ToTemplateName: Code[10]; ToBatchName: Code[10]; ProdOrder: Record "Production Order";
                                                                  ActualLineNo: Integer; PostingDate: Date; var IsHandled: Boolean)
    var
        lItem: Record Item;
        lItemTrackingCode: Record "Item Tracking Code";
        lProdOrderLine: Record "Prod. Order Line";
        lItemJournalLine: Record "Item Journal Line";
        lLotNoInformation: Record "Lot No. Information";
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_039-s
        //Prima di aprire il batch di registrazioni di produzione controllo lo stato produttivo di riga
        Clear(lItemJournalLine);
        lItemJournalLine.SetRange("Journal Template Name", ToTemplateName);
        lItemJournalLine.SetRange("Journal Batch Name", ToBatchName);
        lItemJournalLine.SetRange("Order Type", lItemJournalLine."Order Type"::Production);
        lItemJournalLine.SetRange("Order No.", ProdOrder."No.");
        lItemJournalLine.SetRange("Order Line No.", ActualLineNo);
        if not lItemJournalLine.IsEmpty then begin
            lItemJournalLine.FindFirst();
            lProductionFunctions.CheckProductiveStatusBeforePostItemJnlLine(lItemJournalLine, true);
        end;
        //CS_PRO_039-e

        //CS_PRO_008-s
        //Prima di aprire il batch di registrazioni di produzione controllo la presenza del lotto e della scadenza sulla riga ODP
        if lProdOrderLine.Get(ProdOrder.Status, ProdOrder."No.", ActualLineNo) then begin
            if lItem.Get(lProdOrderLine."Item No.") and (lItem."Item Tracking Code" <> '') and lItemTrackingCode.Get(lItem."Item Tracking Code") and
               lItemTrackingCode."Lot Specific Tracking"
            then begin
                lProdOrderLine.TestField("ecOutput Lot No.");
                if lItemTrackingCode."Use Expiration Dates" then lProdOrderLine.TestField("ecOutput Lot Exp. Date");

                lLotNoInformation.Get(lProdOrderLine."Item No.", lProdOrderLine."Variant Code", lProdOrderLine."ecOutput Lot No.");
                lLotNoInformation.TestField("ecLot No. Information Status", lLotNoInformation."ecLot No. Information Status"::Released);
            end;
        end;
        //CS_PRO_008-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", 'OnAfterInsertConsumptionJnlLine', '', false, false)]
    local procedure ProductionJournalMgt_OnAfterInsertConsumptionJnlLine(var ItemJournalLine: Record "Item Journal Line")
    var
        lItem: Record Item;
        lProdOrderLine: Record "Prod. Order Line";
    begin
        //CS_PRO_041_BIS-s
        if (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Consumption) and lItem.Get(ItemJournalLine."Item No.") and lItem."ecBy Product Item" then begin
            lProdOrderLine.Get(lProdOrderLine.Status::Released, ItemJournalLine."Order No.", ItemJournalLine."Order Line No.");
            ItemJournalLine.Validate("AltAWPLot No.", lProdOrderLine."ecOutput Lot No.");
            ItemJournalLine.Validate("AltAWPExpiration Date", lProdOrderLine."ecOutput Lot Exp. Date");
            ItemJournalLine."Bin Code" := lProdOrderLine."Bin Code";
            ItemJournalLine.Modify(true);
        end;
        //CS_PRO_041_BIS-e
    end;

    #endregion Production Journal Mgt

    #region Planning Line Management

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Planning Line Management", 'OnBeforeInsertPlanningComponent', '', false, false)]
    local procedure PlanningLineManagement_OnBeforeInsertPlanningComponent(var ReqLine: Record "Requisition Line"; var ProductionBOMLine: Record "Production BOM Line";
                                                                           var PlanningComponent: Record "Planning Component"; LineQtyPerUOM: Decimal; ItemQtyPerUOM: Decimal)
    begin
        //GAP_PRO_003-s
        PlanningComponent."ecSource Qty. per" := ProductionBOMLine."Quantity per";
        //GAP_PRO_003-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Planning Line Management", 'OnAfterCalculate', '', false, false)]
    local procedure PlanningLineManagement_OnAfterCalculate(var CalcComponents: Boolean; var SKU: Record "Stockkeeping Unit"; var RequisitionLine: Record "Requisition Line")
    var
    //lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_039-s
        //lProductionFunctions.RefreshReqLinePrevalentOperation(RequisitionLine);
        //CS_PRO_039-e
    end;

    #endregion Planning Line Management

    #region Check Routing Lines

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Check Routing Lines", 'OnBeforeCalculate', '', false, false)]
    local procedure CheckRoutingLines_OnBeforeCalculate(RoutingHeader: Record "Routing Header"; VersionCode: Code[20])
    var
        lRoutingLine: Record "Routing Line";
        lRoutingLineNextOp: Record "Routing Line";

        lRoutingLineMissTimeErr: Label 'You need to specify "%1" or "%2" on routing line that contain a "%3" different from 0!';
        lRoutingLineMissTimeNextOpErr: Label 'You need to specify "%1" or "%2" on next operation of routing line that contain a "%3" different from 0!';
    begin
        //CS_PRO_039-s
        Clear(lRoutingLine);
        Clear(lRoutingLineNextOp);
        lRoutingLine.SetCurrentKey("Routing No.", "Version Code", "Sequence No. (Backward)");
        lRoutingLine.SetRange("Routing No.", RoutingHeader."No.");
        lRoutingLine.SetRange("Version Code", VersionCode);
        if lRoutingLine.IsEmpty() then exit;

        lRoutingLine.FindSet();
        repeat
            if (lRoutingLine."Send-Ahead Quantity" <> 0) then begin
                if (lRoutingLine."Setup Time" = 0) and (lRoutingLine."Run Time" = 0) then begin
                    Error(lRoutingLineMissTimeErr, lRoutingLine.FieldCaption("Setup Time"), lRoutingLine.FieldCaption("Run Time"),
                                                   lRoutingLine.FieldCaption("Send-Ahead Quantity"));
                end;
                if (lRoutingLine."Next Operation No." <> '') then begin
                    lRoutingLineNextOp.SetRange("Routing No.", lRoutingLine."Routing No.");
                    lRoutingLineNextOp.SetRange("Version Code", VersionCode);
                    lRoutingLineNextOp.SetFilter("Operation No.", lRoutingLine."Next Operation No.");
                    lRoutingLineNextOp.FindSet();
                    repeat
                        if (lRoutingLineNextOp."Setup Time" = 0) and (lRoutingLineNextOp."Run Time" = 0) then begin
                            Error(lRoutingLineMissTimeNextOpErr, lRoutingLine.FieldCaption("Setup Time"), lRoutingLine.FieldCaption("Run Time"),
                                                                 lRoutingLine.FieldCaption("Send-Ahead Quantity"));
                        end;
                    until (lRoutingLineNextOp.Next() = 0);
                end;
            end;
        until (lRoutingLine.Next() = 0)
        //CS_PRO_039-e
    end;

    #endregion Check Routing Lines

    #region Purchases Warehouse Mgt.

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purchases Warehouse Mgt.", 'OnPurchLine2ReceiptLineOnAfterInitNewLine', '', false, false)]
    local procedure PurchasesWarehouseMgt_OnPurchLine2ReceiptLineOnAfterInitNewLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line";
                                                                                    WarehouseReceiptHeader: Record "Warehouse Receipt Header";
                                                                                    PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin
        //CS_ACQ_018-s
        WarehouseReceiptLine."ecPackaging Type" := PurchaseLine."ecPackaging Type";
        //CS_ACQ_018-e

        //CS_ACQ_013-s
        WarehouseReceiptLine."ecContainer Type" := PurchaseLine."ecContainer Type";
        WarehouseReceiptLine."ecContainer No." := PurchaseLine."ecContainer No.";
        WarehouseReceiptLine."ecExpected Shipping Date" := PurchaseLine."ecExpected Shipping Date";
        WarehouseReceiptLine."ecDelay Reason Code" := PurchaseLine."ecDelay Reason Code";
        WarehouseReceiptLine."ecTransport Status" := PurchaseLine."ecTransport Status";
        WarehouseReceiptLine."ecShip. Documentation Status" := PurchaseLine."ecShip. Documentation Status";
        WarehouseReceiptLine."ecShiping Doc. Notes" := PurchaseLine."ecShiping Doc. Notes";
        //CS_ACQ_013-e
    end;

    #endregion Purchases Warehouse Mgt.

    #region Reservation-Check Date Confl.

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation-Check Date Confl.", 'OnProdOrderComponentCheckOnBeforeIssueError', '', false, false)]
    local procedure ReservationCheckDateConfl_OnProdOrderComponentCheckOnBeforeIssueError(var ReservationEntry: Record "Reservation Entry";
                                                                                          ProdOrderComponent: Record "Prod. Order Component"; var ForceRequest: Boolean;
                                                                                          var IsHandled: Boolean)
    var
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_PRO_044-s
        lATSSessionDataStore.AddSessionSetting('ForceErrorForDateConflict', true);
        //CS_PRO_044-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation-Check Date Confl.", 'OnBeforeCheckProdOrderLineDateConflict', '', false, false)]
    local procedure ReservationCheckDateConfl_OnBeforeCheckProdOrderLineDateConflict(DueDate: Date; var ForceRequest: Boolean;
                                                                                     var ReservationEntry: Record "Reservation Entry"; var IsHandled: Boolean)
    var
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_PRO_044-s
        lATSSessionDataStore.AddSessionSetting('ForceErrorForDateConflict', true);
        //CS_PRO_044-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation-Check Date Confl.", 'OnAfterDateConflict', '', false, false)]
    local procedure ReservationCheckDateConfl_OnAfterDateConflict(var ReservationEntry: Record "Reservation Entry"; var Date: Date;
                                                                  var IsConflict: Boolean; var ForceRequest: Boolean)
    var
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
        lReservationFunctions: Codeunit "ecReservation Functions";
        lReservQty: Decimal;

        lDateConflictError: Label 'The change leads to a date conflict with existing reservations.\Reserved quantity (Base): %1, Date %2 \Cancel or change reservations and try again.';
    begin
        //CS_PRO_044-s
        if lATSSessionDataStore.GetSessionSettingBooleanValue('ForceErrorForDateConflict') and IsConflict then begin
            lReservQty := lReservationFunctions.CalcReservQty(ReservationEntry, Date);
            lATSSessionDataStore.RemoveSessionSetting('ForceErrorForDateConflict');
            Error(lDateConflictError, lReservQty, Date);
        end;
        //CS_PRO_044-e
    end;

    #endregion Reservation-Check Date Confl.

    #region Item Jnl.-Post

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", 'OnBeforeCode', '', false, false)]
    local procedure ItemJnlPost_OnBeforeCode(var ItemJournalLine: Record "Item Journal Line"; var HideDialog: Boolean; var SuppressCommit: Boolean; var IsHandled: Boolean)
    var
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_PRO_050-s
        if lATSSessionDataStore.GetSessionSettingBooleanValue('ItemJnlPost_SuppressCommit') then SuppressCommit := true;

        if lATSSessionDataStore.GetSessionSettingBooleanValue('ItemJnlPost_HideDialog') then HideDialog := true;
        //CS_PRO_050-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnAfterInitItemLedgEntry, '', false, false)]
    local procedure "Item Jnl.-Post Line_OnAfterInitItemLedgEntry"(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    var
        Item: Record Item;
        MassBalanceEntry: Record "ecMass Balances Entry";
        MassBalanceGenFunctions: Codeunit "ecMass Balance Gen. Functions";
        PalletsMgt: Codeunit "ecPallets Management";
        Inserted: Boolean;
    begin
        //#271
        case ItemJournalLine."Entry Type" of
            ItemJournalLine."Entry Type"::Purchase:
                if Item.Get(ItemJournalLine."Item No.") then begin
                    if Item."ecItem Trk. Summary Mgt." then
                        MassBalanceGenFunctions.InsertMassBalanceEntryFromItemLedgerEntryPurchaseEntryType(NewItemLedgEntry);
                end;

            ItemJournalLine."Entry Type"::Sale:
                begin
                    MassBalanceEntry.Reset();
                    MassBalanceEntry.SetRange("Entry Type", MassBalanceEntry."Entry Type"::Output);
                    MassBalanceEntry.SetRange("Item No.", NewItemLedgEntry."Item No.");
                    MassBalanceEntry.SetRange("Item Lot No.", NewItemLedgEntry."Lot No.");
                    MassBalanceEntry.SetRange("Item UoM", NewItemLedgEntry."Unit of Measure Code");
                    if MassBalanceEntry.FindSet() then begin
                        repeat
                            if Item.Get(MassBalanceEntry."Item No.") then
                                if Item."ecItem Trk. Summary Mgt." then
                                    MassBalanceGenFunctions.InsertMassBalanceEntryFromItemLedgerEntrySaleEntryType(MassBalanceEntry, NewItemLedgEntry, false);
                        until MassBalanceEntry.Next() = 0;

                        Inserted := true;
                    end;

                    if not Inserted then
                        if Item.Get(NewItemLedgEntry."Item No.") then
                            if (Item."ecItem Trk. Summary Mgt.") and (Item."ecItem Type" = Item."ecItem Type"::"Raw Material") then
                                MassBalanceGenFunctions.InsertMassBalanceEntryFromItemLedgerEntrySaleEntryType(MassBalanceEntry, NewItemLedgEntry, true);
                end;
        //#271
        end;

        //#229Status
        PalletsMgt.SetCompletedStatusInWhseDoc(ItemJournalLine, NewItemLedgEntry);
        //#229Status
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnAfterInsertConsumpEntry, '', false, false)]
    local procedure "Item Jnl.-Post Line_OnAfterInsertConsumpEntry"(var WarehouseJournalLine: Record "Warehouse Journal Line"; var ProdOrderComponent: Record "Prod. Order Component"; QtyBase: Decimal; PostWhseJnlLine: Boolean; var ItemJnlLine: Record "Item Journal Line"; ItemLedgEntryNo: Integer)
    var
        Item: Record Item;
        MassBalanceGenFunctions: Codeunit "ecMass Balance Gen. Functions";
    begin
        //#271
        if ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Consumption then
            if Item.Get(ItemJnlLine."Item No.") and (Item."ecItem Trk. Summary Mgt.") then
                MassBalanceGenFunctions.InsertMassBalanceEntryFromConsumptionEntryType(ProdOrderComponent, ItemJnlLine, ItemLedgEntryNo);
        //#271
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnAfterPostOutput, '', false, false)]
    // local procedure "Item Jnl.-Post Line_OnAfterPostOutput"(var ItemLedgerEntry: Record "Item Ledger Entry"; var ProdOrderLine: Record "Prod. Order Line"; var ItemJournalLine: Record "Item Journal Line")
    // var
    //     ProdOrderComponent: Record "Prod. Order Component";
    //     Item: Record Item;
    //     MassBalanceGenFunctions: Codeunit "ecMass Balance Gen. Functions";
    // begin
    //     //#271
    //     if ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Output then
    //         if Item.Get(ItemJournalLine."Item No.") and (Item."ecItem Trk. Summary Mgt.") then begin
    //             ProdOrderComponent.Reset();
    //             ProdOrderComponent.SetRange(Status, ProdOrderLine.Status);
    //             ProdOrderComponent.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
    //             ProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
    //             if ProdOrderComponent.FindSet() then
    //                 repeat
    //                     if (Item.Get(ProdOrderComponent."Item No.")) and (Item."ecItem Trk. Summary Mgt.") then
    //                         MassBalanceGenFunctions.InsertMassBalanceEntriesFromOutputEntryType(ProdOrderComponent, ItemJournalLine, ItemLedgerEntry);
    //                 until ProdOrderComponent.Next() = 0;
    //         end;
    //     //#271
    // end;
    #endregion Item Jnl.-Post

    #region Item Jnl.-Post Batch

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Batch", 'OnBeforeCheckJnlLine', '', false, false)]
    local procedure ItemJnlPostLine_OnBeforeCheckJnlLine(var ItemJournalLine: Record "Item Journal Line")
    var
        lecRestrictionsMgt: Codeunit "ecRestrictions Mgt.";
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_011-VI-s
        lecRestrictionsMgt.TestRestrictionsOnInventoryPosting(ItemJournalLine, true);
        //CS_PRO_011-VI-e

        //CS_PRO_041_BIS-s
        lProductionFunctions.CheckByProductCompOnPostingItemJnlLine(ItemJournalLine);
        //CS_PRO_041_BIS-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Batch", 'OnAfterCheckJnlLine', '', false, false)]
    local procedure ItemJnlPostBatch_OnAfterCheckJnlLine(var ItemJournalLine: Record "Item Journal Line"; CommitIsSuppressed: Boolean)
    var
        lItem: Record Item;
        lItemTrackingCode: Record "Item Tracking Code";
        lProdOrderRoutingLine: Record "Prod. Order Routing Line";
        lLotNoInformation: Record "Lot No. Information";
        lIsHandled: Boolean;
    begin
        //CS_PRO_008-s
        //Check Lot No. and Lot Information Card for output operation of item that required tracking information before posting
        lIsHandled := false;
        OnBeforeCheckLotNoOnItemJnlPostBatch(lIsHandled);

        if not lIsHandled then begin
            if (ItemJournalLine."Output Quantity" > 0) and
               (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Output) and
               (ItemJournalLine."Order Type" = ItemJournalLine."Order Type"::Production)
            then begin
                if lProdOrderRoutingLine.Get(lProdOrderRoutingLine.Status::Released, ItemJournalLine."Order No.",
                                             ItemJournalLine."Routing Reference No.", ItemJournalLine."Routing No.", ItemJournalLine."Operation No.") and
                    (lProdOrderRoutingLine."Next Operation No." = '')
                then begin
                    if (ItemJournalLine."Item No." <> '') and lItem.Get(ItemJournalLine."Item No.") and (lItem."Item Tracking Code" <> '') and
                        lItemTrackingCode.Get(lItem."Item Tracking Code") and lItemTrackingCode."Lot Specific Tracking"
                    then begin
                        ItemJournalLine.TestField("AltAWPLot No.");
                        if lItemTrackingCode."Use Expiration Dates" then ItemJournalLine.TestField("AltAWPExpiration Date");

                        lLotNoInformation.Get(ItemJournalLine."Item No.", ItemJournalLine."Variant Code", ItemJournalLine."AltAWPLot No.");
                        lLotNoInformation.TestField("ecLot No. Information Status", lLotNoInformation."ecLot No. Information Status"::Released);
                    end;
                end;
                //CS_PRO_008-e
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckLotNoOnItemJnlPostBatch(var IsHandled: Boolean)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Batch", 'OnBeforeCode', '', false, false)]
    local procedure ItemJnlPostBatch_OnBeforeCode(var ItemJournalLine: Record "Item Journal Line")
    var
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_041_BIS-s
        lProductionFunctions.CreateByProdItemLotNoInfoCardOnItemJnlPost(ItemJournalLine);
        //CS_PRO_041_BIS-e
    end;

    #endregion Item Jnl.-Post Batch

    #region Item Jnl.-Post Line
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforePostItemJnlLine', '', false, false)]
    local procedure ItemJnlPostLine_OnBeforePostItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; CalledFromAdjustment: Boolean; CalledFromInvtPutawayPick: Boolean;
                                                            var ItemRegister: Record "Item Register"; var ItemLedgEntryNo: Integer; var ValueEntryNo: Integer; var ItemApplnEntryNo: Integer)
    var
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_039-s
        lProductionFunctions.CheckProductiveStatusBeforePostItemJnlLine(ItemJournalLine, true);
        //CS_PRO_039-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterPostOutput', '', false, false)]
    local procedure ItemJnlPostLine_OnAfterPostOutput(var ItemJournalLine: Record "Item Journal Line";
                                                      var ItemLedgerEntry: Record "Item Ledger Entry";
                                                      var ProdOrderLine: Record "Prod. Order Line")
    var
    //lProdOrderRoutingLine: Record "Prod. Order Routing Line";
    begin
        //CS_PRO_018-s
        //Commentato per test relativo a loop in fase di posting o modifica delle date
        //#TODO#-s
        /*
        lProdOrderRoutingLine.Get(lProdOrderRoutingLine.Status::Released,
                                  ItemJournalLine."Order No.",
                                  ItemJournalLine."Routing Reference No.",
                                  ItemJournalLine."Routing No.",
                                  ItemJournalLine."Operation No.");
        if (lProdOrderRoutingLine."Next Operation No." = '') then begin
            lProdOrderRoutingLine.Validate("Setup Time", 0);
            lProdOrderRoutingLine.Modify(false);

            Clear(lProdOrderRoutingLine);
            lProdOrderRoutingLine.SetRange(Status, lProdOrderRoutingLine.Status::Released);
            lProdOrderRoutingLine.SetRange("Prod. Order No.", ItemJournalLine."Order No.");
            lProdOrderRoutingLine.SetRange("Routing Reference No.", ItemJournalLine."Routing Reference No.");
            lProdOrderRoutingLine.SetRange("Routing No.", ItemJournalLine."Routing No.");
            lProdOrderRoutingLine.SetFilter("Operation No.", '<>%1', ItemJournalLine."Operation No.");
            if not lProdOrderRoutingLine.IsEmpty then begin
                lProdOrderRoutingLine.FindSet();
                repeat
                    lProdOrderRoutingLine.Validate("Setup Time", 0);
                    lProdOrderRoutingLine.Validate("Run Time", 0);
                    lProdOrderRoutingLine.Modify(false);
                until (lProdOrderRoutingLine.Next() = 0);
            end;
        end;
        */
        //#TODO#-e
        //CS_PRO_018-e
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnCheckItemTrackingOnAfterCheckRequiredTrackingNos', '', false, false)]
    local procedure ItemJnlPostLine_OnCheckItemTrackingOnAfterCheckRequiredTrackingNos(ItemJournalLine: Record "Item Journal Line"; ItemTrackingSetup: Record "Item Tracking Setup")
    var
        lLotNoInformation: Record "Lot No. Information";

        lMissingLotInfo: Label 'Missing Lot Information Card for Item No.: %1, Lot No.: %2!';
        lLotInfoNotReleased: Label 'Lot Information Card not released for Item No.: %1, Lot No.: %2!';
    begin
        //CS_PRO_008-s
        if ItemTrackingSetup."Lot No. Required" then begin
            if not lLotNoInformation.Get(ItemJournalLine."Item No.", ItemJournalLine."Variant Code", ItemJournalLine."Lot No.") then begin
                Error(lMissingLotInfo, ItemJournalLine."Item No.", ItemJournalLine."Lot No.");
            end else begin
                if (lLotNoInformation."ecLot No. Information Status" <> lLotNoInformation."ecLot No. Information Status"::Released) then begin
                    Error(lLotInfoNotReleased, ItemJournalLine."Item No.", ItemJournalLine."Lot No.");
                end;
            end;
        end;
        //CS_PRO_008-e
    end;

    #endregion Item Jnl.-Post Line

    #region Inventory Profile Offsetting
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Profile Offsetting", 'OnSetAcceptActionOnBeforeAcceptActionMsg', '', false, false)]
    local procedure InventoryProfileOffsetting_OnSetAcceptActionOnBeforeAcceptActionMsg(var RequisitionLine: Record "Requisition Line";
                                                                                        var AcceptActionMsg: Boolean)
    begin
        //CS_PRO_044-VI-s
        if (RequisitionLine."Planning Level" > 0) then begin
            AcceptActionMsg := false;
        end;
        //CS_PRO_044-VI-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Profile Offsetting", 'OnMaintainPlanningLineOnBeforeReqLineInsert', '', false, false)]
    local procedure InventoryProfileOffsetting_OnMaintainPlanningLineOnBeforeReqLineInsert(var RequisitionLine: Record "Requisition Line")
    begin
        //CS_PRO_044-VI-s
        if (RequisitionLine."Planning Level" > 0) then begin
            RequisitionLine."Accept Action Message" := false;
        end;
        //CS_PRO_044-VI-e
    end;

    #endregion Inventory Profile Offsetting

    #region Carry Out Action

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Carry Out Action", 'OnBeforeFinalizeOrderHeader', '', false, false)]
    local procedure CarryOutAction_OnBeforeFinalizeOrderHeader(ProdOrder: Record "Production Order")
    var
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_044-VI-s
        lProductionFunctions.FinalizeProdOrderHeaderByPlanningWksh(ProdOrder);
        //CS_PRO_044-VI-e

        //CS_PRO_039-s
        //lProductionFunctions.RefreshProdOrdLinePrevalentOperation(ProdOrder);
        //CS_PRO_039-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Carry Out Action", 'OnInsertProdOrderLineWithReqLine', '', false, false)]
    local procedure CarryOutAction_OnInsertProdOrderLineWithReqLine(var ProdOrderLine: Record "Prod. Order Line"; var RequisitionLine: Record "Requisition Line")
    var
        lItem: Record Item;
    begin
        //CS_PRO_018-s
        if lItem.Get(ProdOrderLine."Item No.") then begin
            ProdOrderLine.ecBand := lItem.ecBand;
        end;
        //CS_PRO_018-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Carry Out Action", 'OnAfterInsertProdOrderLine', '', false, false)]
    local procedure CarryOutAction_OnAfterInsertProdOrderLine(ReqLine: Record "Requisition Line"; ProdOrder: Record "Production Order"; var ProdOrderLine: Record "Prod. Order Line"; Item: Record Item)
    var
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_018-s
        lProductionFunctions.UpdateProdOrderLine(ProdOrderLine);
        //CS_PRO_018-e
    end;

    #endregion Carry Out Action

    #region ecProduction Functions

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ecProduction Functions", 'OnBeforeCheckProductiveStatusBeforePostItemJnlLine', '', false, false)]
    local procedure ecProductionFunctions_OnBeforeCheckProductiveStatusBeforePostItemJnlLine(var pItemJnlLine: Record "Item Journal Line"; var pIsHandled: Boolean)
    var
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_PRO_050-s
        if lATSSessionDataStore.GetSessionSettingBooleanValue('ConsumptionCorrection_SkipCheckProductiveStatus') then pIsHandled := true;
        //CS_PRO_050-e
    end;

    #endregion ecProduction Functions

    #region Whse.-Post Receipt

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnAfterCheckWhseRcptLine', '', false, false)]
    local procedure WhsePostReceipt_OnAfterCheckWhseRcptLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line")
    var
        lTrackingFunctions: Codeunit "ecTracking Functions";
    begin
        //CS_PRO_008-s
        lTrackingFunctions.CheckLotNoInfoForWhseRcptLinePosting(WarehouseReceiptLine);
        //CS_PRO_008-e
    end;

    #endregion Whse.-Post Receipt

    #region Whse.-Post Shipment
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnCreatePostedShptLineOnBeforePostedWhseShptLineInsert', '', false, false)]
    local procedure WhsePostShipment_OnCreatePostedShptLineOnBeforePostedWhseShptLineInsert(var PostedWhseShptLine: Record "Posted Whse. Shipment Line";
                                                                                            WhseShptLine: Record "Warehouse Shipment Line")
    begin
        //CS_VEN_014-VI-s
        PostedWhseShptLine.ecUpdateConsumerUMQuantity();
        //CS_VEN_014-VI-e
    end;
    #endregion Whse.-Post Shipment

    #region Whse.-Activity-Register 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", 'OnAfterCheckWhseActivLine', '', false, false)]
    local procedure WhseActivityRegister_OnAfterCheckWhseActivLine(var WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        lecRestrictionsMgt: Codeunit "ecRestrictions Mgt.";
    begin
        //CS_PRO-011-VI-s
        lecRestrictionsMgt.TestWarehousePickRestrictions(WarehouseActivityLine, WarehouseActivityLine."Lot No.", true);
        //CS_PRO-011-VI-e
    end;
    #endregion Whse.-Activity-Register

    #region Whse. Jnl.-Register Line
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnBeforeInsertWhseEntry', '', false, false)]
    local procedure WhseJnlRegisterLine_OnBeforeInsertWhseEntry(var WarehouseEntry: Record "Warehouse Entry"; var WarehouseJournalLine: Record "Warehouse Journal Line")
    var
        lTrackingFunctions: Codeunit "ecTracking Functions";
    begin
        //CS_PRO_039-s
        lTrackingFunctions.UpdateLotNoInfoFromWhseActivityLine(WarehouseEntry."Item No.", WarehouseEntry."Variant Code", WarehouseEntry."Lot No.",
                                                               WarehouseEntry."Location Code", WarehouseEntry."Bin Code");
        //CS_PRO_039-e                                                                 
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnBeforeInsertWhseEntryProcedure', '', false, false)]
    local procedure WhseJnlRegisterLine_OnBeforeInsertWhseEntryProcedure(var WarehouseEntry: Record "Warehouse Entry"; WarehouseJournalLine: Record "Warehouse Journal Line"; var IsHandled: Boolean)
    begin
        //CS_ACQ_013-s
        WarehouseEntry."ecNo. Of Parcels" := 0;
        WarehouseEntry."ecTotal Weight" := 0;
        WarehouseEntry."ecUnit Weight" := 0;
        //CS_ACQ_013-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", OnAfterInsertWhseEntry, '', false, false)]
    local procedure "Whse. Jnl.-Register Line_OnAfterInsertWhseEntry"(var WarehouseEntry: Record "Warehouse Entry"; var WarehouseJournalLine: Record "Warehouse Journal Line")
    var
        PalletMgt: Codeunit "ecPallets Management";
    begin
        //#229
        PalletMgt.GetPalletsValues(WarehouseEntry);
        //#229
    end;

    #endregion Whse. Jnl.-Register Line

    #region Approvals Mgmt.

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterCheckSalesApprovalPossible', '', true, true)]

    local procedure AltOnAfterCheckSalesApprovalPossible(var SalesHeader: Record "Sales Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        SalesFunctions: Codeunit "ecSales Functions";
    begin
        //#391
        if ApprovalsMgmt.IsSalesHeaderPendingApproval(SalesHeader) then
            SalesFunctions.SetOMRQty(SalesHeader);
        //#391
    end;
    #endregion Approvals Mgmt.

    #endregion Codeunit

    #region Report

    #region Refresh Production Order

    [EventSubscriber(ObjectType::Report, Report::"Refresh Production Order", 'OnBeforeCalcProdOrder', '', false, false)]
    local procedure RefreshProductionOrder_OnBeforeCalcProdOrder(var ProductionOrder: Record "Production Order"; Direction: Option)
    var
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_PRO_044-s
        lATSSessionDataStore.AddSessionSetting('CalledByRefreshProductionOrder', true);
        //CS_PRO_044-e
    end;

    [EventSubscriber(ObjectType::Report, Report::"Refresh Production Order", 'OnAfterRefreshProdOrder', '', false, false)]
    local procedure RefreshProductionOrder_OnAfterRefreshProdOrder(var ProductionOrder: Record "Production Order"; ErrorOccured: Boolean)
    var
        lProductionFunctions: Codeunit "ecProduction Functions";
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
        lNewRoutingNo: Code[20];
    begin
        //CS_PRO_039-s
        if not ErrorOccured then begin
            //lProductionFunctions.RefreshProdOrdLinePrevalentOperation(ProductionOrder);

            //CS_PRO_044-s
            if (ProductionOrder.Status = ProductionOrder.Status::Released) or (ProductionOrder.Status = ProductionOrder.Status::"Firm Planned") then begin
                lProductionFunctions.UpdateProductionOrderLines(ProductionOrder, false);
            end;
            //CS_PRO_044-e

            //GAP_PRO_003-s
            lNewRoutingNo := lATSSessionDataStore.GetSessionSettingValue('OnUpdateRoutingOnProdOrder');
            if (lNewRoutingNo <> '') then begin
                lProductionFunctions.UpdateProductiveAreaOnWarehouseActivityHeader(ProductionOrder);
            end;
            //GAP_PRO_003-e
        end;
        //CS_PRO_039-e

        lATSSessionDataStore.RemoveSessionSetting('CalledByRefreshProductionOrder');  //CS_PRO_044-n
    end;

    [EventSubscriber(ObjectType::Report, Report::"Refresh Production Order", 'OnAfterGetRoutingNo', '', false, false)]
    local procedure RefreshProductionOrder_OnAfterGetRoutingNo(var ProductionOrder: Record "Production Order"; var RoutingNo: Code[20])
    var
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
        lNewRoutingNo: Text;
    begin
        //GAP_PRO_003-s
        lNewRoutingNo := lATSSessionDataStore.GetSessionSettingValue('OnUpdateRoutingOnProdOrder');
        if (lNewRoutingNo <> '') then begin
            RoutingNo := lNewRoutingNo;
        end;
        //GAP_PRO_003-e
    end;

    #endregion Refresh Production Order

    #endregion Report

    #region Release Sales Doc.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnAfterReleaseSalesDoc, '', false, false)]
    local procedure ReleaseSalesDocument_OnAfterReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
        SalesLine: Record "Sales Line";
        DeliveryPointSetup: Codeunit "Delivery Point Setup Mgt";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then begin
            SalesLine.Reset();
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            if SalesLine.FindSet() then
                repeat
                    DeliveryPointSetup.InitOtherMgtDataDoc(SalesLine);
                until SalesLine.Next() = 0;
        end;
    end;
    #endregion Release Sales Doc.
    #region Calc Commission
    //runs on modify and release, single % commission
    //AFC_CS_005
    // ** old - not full working
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"APsSCM Doc. Commmission Mgt.", OnAfterSingleDocCommSetPercUpdatedOnBeforeModify, '', false, false)]
    // ** old

    //NEW - checked with Platform, 27/02/25
    //AFC_CS_005
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"APsSCM Doc. Commmission Mgt.", OnAfterSingleDocCommSetPercProcessed, '', true, true)]
    local procedure "APsSCM Doc. Commmission Mgt._OnAfterSingleDocCommSetPercProcessed"(var DocCommSet: Record "APsSCM Document Commission Set"; var Updated: Boolean)
    var
        ecAgentContrExceptSetup: Record "ecAgent Contr Except Setup";
        ecAgentContrExceptSetupSrc: Record "ecAgent Contr Except Setup";
        APsSCMCommissionMgtSetup: Record "APsSCM Commission Mgt. Setup";
        SalesPerson: Record "Salesperson/Purchaser";
        DocSalesHeader: Record "Sales Header";
        DocSalesLine: Record "Sales Line";
        CommCalc: Codeunit CommissionCalc;
        CatRegComm: Code[20];
        FindCustomer: Boolean;
        //FindCustomerSegment: Boolean;
        FindItem: Boolean;
        FindItemSegment: Boolean;

    begin
        if APsSCMCommissionMgtSetup.Get() then
            if APsSCMCommissionMgtSetup."Update Perc. Event" in
               [APsSCMCommissionMgtSetup."Update Perc. Event"::"On Modify", APsSCMCommissionMgtSetup."Update Perc. Event"::"On Release"] then begin //Not Manual
                FindCustomer := false;
                //FindCustomerSegment := false;
                FindItem := false;
                FindItemSegment := false;

                //Recover Document Info
                if DocSalesHeader.Get(DocCommSet."Document Type", DocCommSet."Document No.") then begin
                    //Recover Salesagent Category
                    CatRegComm := '';
                    if DocCommSet."Salesperson Code" <> '' then
                        if SalesPerson.Get(DocCommSet."Salesperson Code") then
                            CatRegComm := SalesPerson."APsSCM Comm. Posting Group";

                    //Search for the custom commission setup - Filter by catreg\role
                    ecAgentContrExceptSetup.Reset();
                    //ecAgentContrExceptSetup.SetCurrentKey("Commission Posting Group", "Customer Type", "Customer Type Code", "Role Code", "Item Type", "Item Type Code", "Salesperson Commission", Priority);
                    ecAgentContrExceptSetup.SetCurrentKey(Priority, "Commission Posting Group", "Role Code");
                    ecAgentContrExceptSetup.Ascending(false);
                    ecAgentContrExceptSetup.SetRange("Commission Posting Group", CatRegComm);
                    ecAgentContrExceptSetup.SetRange("Role Code", DocCommSet."Role Code");

                    if ecAgentContrExceptSetup.FindSet() then begin
                        repeat
                            //Reset
                            FindCustomer := false;
                            //FindCustomerSegment := false;
                            FindItem := false;
                            FindItemSegment := false;

                            //Search for catreg-commis-postin-group\role
                            ecAgentContrExceptSetupSrc.Reset();
                            ecAgentContrExceptSetupSrc.SetCurrentKey(Priority, "Commission Posting Group", "Role Code");
                            ecAgentContrExceptSetupSrc.Ascending(false);
                            ecAgentContrExceptSetupSrc.SetRange("Commission Posting Group", CatRegComm);
                            ecAgentContrExceptSetupSrc.SetRange("Role Code", DocCommSet."Role Code");

                            //#1 - Serch for Customer
                            FindCustomer := false;
                            FindCustomer := CommCalc.CheckCustomerComm(ecAgentContrExceptSetup, DocSalesHeader);
                            if FindCustomer then begin
                                ecAgentContrExceptSetupSrc.SetRange("Customer Type", ecAgentContrExceptSetupSrc."Customer Type"::Customer);
                                ecAgentContrExceptSetupSrc.SetRange("Customer Type Code", DocSalesHeader."Sell-to Customer No.");
                                if ecAgentContrExceptSetupSrc.FindFirst() then begin
                                    UpdateCommPercDocCommSet(DocCommSet, ecAgentContrExceptSetupSrc);
                                    exit;
                                end;
                            end;

                            //#2 - Serch for Customer in Segment
                            /*FindCustomerSegment := false;
                            if not FindCustomer then
                                FindCustomerSegment := CommCalc.CheckCustomerInSegment(ecAgentContrExceptSetup."Customer Type Code",
                                                       ecAgentContrExceptSetup."Customer Type Code", DocSalesHeader."Sell-to Customer No.");

                            if FindCustomerSegment then begin
                                ecAgentContrExceptSetupSrc.SetRange("Customer Type Code", ecAgentContrExceptSetup."Customer Type Code");
                                if ecAgentContrExceptSetupSrc.FindFirst() then begin
                                    UpdateCommPercDocCommSet(DocCommSet, ecAgentContrExceptSetupSrc);
                                    exit;
                                end;
                            end;*/

                            //  if (FindCustomer) Or (FindCustomerSegment) then begin

                            //#3 - Search for Item
                            FindItem := false;
                            if not FindCustomer then begin
                                FindItem := CommCalc.CheckItemComm(DocCommSet, ecAgentContrExceptSetup, DocSalesHeader);
                                if FindItem then begin
                                    if DocSalesLine.Get(DocCommSet."Document Type", DocCommSet."Document No.", DocCommSet."Document Line No.") then
                                        ecAgentContrExceptSetupSrc.SetRange("Item Type Code", DocSalesLine."No.");
                                    if ecAgentContrExceptSetupSrc.FindFirst() then begin
                                        UpdateCommPercDocCommSet(DocCommSet, ecAgentContrExceptSetupSrc);
                                        exit;
                                    end;
                                end;
                            end;

                            //#4 - Search for Item in segment
                            FindItemSegment := false;
                            if not FindItem then begin
                                FindItemSegment := CommCalc.CheckItemInSegment(DocCommSet, ecAgentContrExceptSetup, ecAgentContrExceptSetup."Item Type Code");
                                if FindItemSegment then begin
                                    ecAgentContrExceptSetupSrc.SetRange("Customer Type", ecAgentContrExceptSetup."Customer Type"::"Segment Customer Business");
                                    ecAgentContrExceptSetupSrc.SetRange("Item Type Code", ecAgentContrExceptSetup."Item Type Code");
                                    if ecAgentContrExceptSetupSrc.FindFirst() then begin
                                        UpdateCommPercDocCommSet(DocCommSet, ecAgentContrExceptSetupSrc);
                                        exit;
                                    end;
                                end;
                            end;

                        //Implement % comm change after search
                        /*if (FindItem) Or (FindItemSegment) then
                            if ecAgentContrExceptSetupSrc.FindFirst() then begin
                                //   DocCommSet.validate("Commission %", ecAgentContrExceptSetupSrc."Salesperson Commission");
                                //   DocCommSet.validate("Gross Commission %", ecAgentContrExceptSetupSrc."Salesperson Commission");
                                //   DocCommSet.Modify(false); //Checked if needed with Platform, 27/02/25
                            end;*/

                        until ecAgentContrExceptSetup.Next() = 0;
                    end;
                end;
            end;
    end;

    local procedure UpdateCommPercDocCommSet(var DocCommSet: Record "APsSCM Document Commission Set"; var ecAgentContrExceptSetupSrc: Record "ecAgent Contr Except Setup")
    begin
        DocCommSet.Validate("Commission %", ecAgentContrExceptSetupSrc."Salesperson Commission");
        DocCommSet.Validate("Gross Commission %", ecAgentContrExceptSetupSrc."Salesperson Commission");
        DocCommSet.Modify(false); //Checked if needed with Platform, 27/02/25
    end;
    //AFC_CS_005
    #endregion Calc Commission

    #region CS_AFC_020
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Customer Templ. Mgt.", 'OnAfterCreateCustomerFromTemplate', '', false, false)]
    local procedure OnAfterCreateCustomerFromTemplate(var Customer: Record Customer; CustomerTempl: Record "Customer Templ.");
    begin
#pragma warning disable AL0603
        Customer.Validate("AltAWPBilling Periodicity", CustomerTempl."eCBilling Periodicity");
#pragma warning restore AL0603
        Customer.Validate("AltAWPDefault Shipping Profile", CustomerTempl."eCDefault Shipping Profile");
        Customer.Validate("APsDFC Financial Category", CustomerTempl."eCDFC Financial Category");
        Customer.Validate(ecActivity, CustomerTempl.ecActivity);
        Customer.Validate("APsCustomer E-I Type", CustomerTempl."eCCustomer E-I Type");
        Customer.Validate("AltAWPGroup Inv. by Sell Code", CustomerTempl."eCGroup Inv. by Sell Code");
#pragma warning disable AL0603
        Customer.Validate("AltAWPS. Doc. Default Layout", CustomerTempl."eCPS. Doc. Default Layout");
#pragma warning restore AL0603
        Customer.Validate("AltAWPPrint Item Tracking", CustomerTempl."ecPrint Item Tracking");
        Customer.Validate("AltAWPPrint Tariff No.", CustomerTempl."eCPrint Tariff No.");
        Customer.Validate("AltAWPPrint Item Reference", CustomerTempl."eCPrint Item Reference");
        Customer.Validate("ecGroup Ship By Prod. Segment", CustomerTempl."ecGroup Ship By Prod. Segment");
        Customer.Validate("ecGroup Inv. By Prod. Segment", CustomerTempl."ecGroup Inv. By Prod. Segment");
        Customer.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Vendor Templ. Mgt.", 'OnAfterCreateVendorFromTemplate', '', false, false)]
    local procedure OnAfterCreateVendorFromTemplate(var Vendor: Record Vendor; VendorTempl: Record "Vendor Templ.")
    begin
        Vendor.Validate("APsElect. Company Type", VendorTempl."ecElect. Company Type");
        Vendor.Validate("ecVendor Classification", VendorTempl."ecVendor Classification");
        Vendor.Validate("APsDFC Financial Category", VendorTempl."ecDFC Financial Category");
        Vendor.Validate(Subcontractor, VendorTempl.Subcontractor);
        Vendor.Validate("AltAWPDefault Shipping Profile", VendorTempl."ecDefault Shipping Profile");
        Vendor.Modify();
    end;
    #endregion  CS_AFC_020
}
