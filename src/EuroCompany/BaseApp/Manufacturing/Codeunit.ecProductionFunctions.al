namespace EuroCompany.BaseApp.Manufacturing;

using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Inventory.ItemCatalog;
using EuroCompany.BaseApp.Inventory.Reservation;
using EuroCompany.BaseApp.Inventory.Tracking;


using EuroCompany.BaseApp.Manufacturing;
using EuroCompany.BaseApp.Manufacturing.Capacity;
using EuroCompany.BaseApp.Manufacturing.Document;
using EuroCompany.BaseApp.Manufacturing.Journal;
using EuroCompany.BaseApp.Manufacturing.ProductionBOM;
using EuroCompany.BaseApp.Manufacturing.Routing;
using EuroCompany.BaseApp.Restrictions;
using EuroCompany.BaseApp.Setup;
using Microsoft.Foundation.Enums;
using Microsoft.Foundation.UOM;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Planning;

using Microsoft.Inventory.Requisition;
using Microsoft.Inventory.Tracking;
using Microsoft.Manufacturing.Capacity;
using Microsoft.Manufacturing.Document;
using Microsoft.Manufacturing.Journal;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.ProductionBOM;
using Microsoft.Manufacturing.Routing;
using Microsoft.Manufacturing.Setup;
using Microsoft.Manufacturing.WorkCenter;
using Microsoft.Warehouse.Activity;
using Microsoft.Warehouse.Structure;

codeunit 50001 "ecProduction Functions"
{

    #region GAP_PRO_003 - Gestione alternative componenti/cicli

    internal procedure GetTempAlternativeRoutingBuffForItem(var Temp_pAlternativeRoutingforItem: Record "ecAlternative Routing for Item" temporary; pItemNo: Code[20])
    var
        lItem: Record Item;
        lAlternativeRoutingforItem: Record "ecAlternative Routing for Item";
    begin
        //GAP_PRO_003-s
        Clear(Temp_pAlternativeRoutingforItem);
        Temp_pAlternativeRoutingforItem.DeleteAll(false);

        if not lItem.Get(pItemNo) then exit;

        Clear(lAlternativeRoutingforItem);
        lAlternativeRoutingforItem.SetRange("Item No.", pItemNo);
        if not lAlternativeRoutingforItem.IsEmpty then begin
            lAlternativeRoutingforItem.FindSet();

            repeat
                Temp_pAlternativeRoutingforItem := lAlternativeRoutingforItem;
                Temp_pAlternativeRoutingforItem.Insert(false);
            until (lAlternativeRoutingforItem.Next() = 0);
        end;

        Temp_pAlternativeRoutingforItem.Init();
        Temp_pAlternativeRoutingforItem."Item No." := pItemNo;
        Temp_pAlternativeRoutingforItem."Routing No." := lItem."Routing No.";
        if Temp_pAlternativeRoutingforItem.Insert(false) then;
        //GAP_PRO_003-e
    end;

    internal procedure CheckRoutingNo(pItemNo: Code[20]; pRoutingNo: Code[20]; pWithError: Boolean): Boolean
    var
        Temp_lAlternativeRoutingforItem: Record "ecAlternative Routing for Item" temporary;

        lError001: Label 'Selected Routing No.: "%1" is not valid for Item No.: "%2"';
    begin
        //GAP_PRO_003-s
        GetTempAlternativeRoutingBuffForItem(Temp_lAlternativeRoutingforItem, pItemNo);
        if not Temp_lAlternativeRoutingforItem.Get(pItemNo, pRoutingNo) then begin
            if pWithError then Error(lError001, pRoutingNo, pItemNo);
            exit(false);
        end;

        exit(true);
        //GAP_PRO_003-e
    end;

    internal procedure LookupProdOrderAlternativeRouting(var pProductionOrder: Record "Production Order"; var pNewRoutingNo: Code[20]): Boolean
    var
        lItem: Record Item;
        Temp_lAlternativeRoutingforItem: Record "ecAlternative Routing for Item" temporary;
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
        lRoutingNo: Code[20];
    begin
        //GAP_PRO_003-s
        pNewRoutingNo := '';
        lItem.Get(pProductionOrder."Source No.");

        GetTempAlternativeRoutingBuffForItem(Temp_lAlternativeRoutingforItem, lItem."No.");
        Clear(Temp_lAlternativeRoutingforItem);
        if not Temp_lAlternativeRoutingforItem.IsEmpty then begin
            lATSSessionDataStore.AddSessionSetting('PageAlternativeRoutingItemsLookupTemp', true);
            if (Page.RunModal(Page::"ecAlternative Rtng for Items", Temp_lAlternativeRoutingforItem) = Action::LookupOK) then begin
                lRoutingNo := Temp_lAlternativeRoutingforItem."Routing No.";
                if (pProductionOrder."Routing No." <> lRoutingNo) then begin
                    pNewRoutingNo := lRoutingNo;
                    exit(true);
                end;
            end;
            lATSSessionDataStore.RemoveSessionSetting('PageAlternativeRoutingItemsLookupTemp');
        end;

        exit(false);
        //GAP_PRO_003-e   
    end;

    internal procedure LookupPlanWoksheetAlternativeRouting(var pRequisitionLine: Record "Requisition Line")
    var
        Temp_lAlternativeRoutingforItem: Record "ecAlternative Routing for Item" temporary;
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //GAP_PRO_003-s
        if not (pRequisitionLine."Ref. Order Type" = pRequisitionLine."Ref. Order Type"::"Prod. Order") then exit;
        GetTempAlternativeRoutingBuffForItem(Temp_lAlternativeRoutingforItem, pRequisitionLine."No.");
        Clear(Temp_lAlternativeRoutingforItem);
        if not Temp_lAlternativeRoutingforItem.IsEmpty then begin
            lATSSessionDataStore.AddSessionSetting('PageAlternativeRoutingItemsLookupTemp', true);
            if (Page.RunModal(Page::"ecAlternative Rtng for Items", Temp_lAlternativeRoutingforItem) = Action::LookupOK) then begin
                if (pRequisitionLine."Routing No." <> Temp_lAlternativeRoutingforItem."Routing No.") then begin
                    pRequisitionLine.Validate("Routing No.", Temp_lAlternativeRoutingforItem."Routing No.");
                end;
            end;
            lATSSessionDataStore.RemoveSessionSetting('PageAlternativeRoutingItemsLookupTemp');
        end;
        //GAP_PRO_003-e   
    end;

    internal procedure RecalculateReqLineRouting(pRequisitionLine: Record "Requisition Line")
    var
        lRefreshPlanningDemand: Report "Refresh Planning Demand";
    begin
        //GAP_PRO_003-s
        if (pRequisitionLine."No." <> '') and (pRequisitionLine."Ref. Order Type" = pRequisitionLine."Ref. Order Type"::"Prod. Order") then begin
            pRequisitionLine.SetRecFilter();
            lRefreshPlanningDemand.InitializeRequest(1, true, false);
            lRefreshPlanningDemand.SetTableView(pRequisitionLine);
            lRefreshPlanningDemand.UseRequestPage(false);
            lRefreshPlanningDemand.Run();
        end;
        //GAP_PRO_003-e
    end;

    internal procedure UpdateRoutingOnProdOrder(var pProductionOrder: Record "Production Order"): Boolean
    var
        lRefreshProductionOrder: Report "Refresh Production Order";
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
        lNewRoutingNo: Code[20];
    begin
        //GAP_PRO_003-s
        CheckProdOrderRoutingUpdatable(pProductionOrder);
        if LookupProdOrderAlternativeRouting(pProductionOrder, lNewRoutingNo) then begin
            lATSSessionDataStore.AddSessionSetting('OnUpdateRoutingOnProdOrder', lNewRoutingNo);
            pProductionOrder.SetRecFilter();
            lRefreshProductionOrder.InitializeRequest(1, true, true, true, false);
            lRefreshProductionOrder.SetTableView(pProductionOrder);
            lRefreshProductionOrder.UseRequestPage(false);
            lRefreshProductionOrder.Run();
            lATSSessionDataStore.RemoveSessionSetting('OnUpdateRoutingOnProdOrder');
        end;
        //GAP_PRO_003-e
    end;

    local procedure CheckProdOrderRoutingUpdatable(var pProductionOrder: Record "Production Order")
    var
        lProdOrderLine: Record "Prod. Order Line";
        lExistItemLedgEntry: Boolean;
        lExistCapacityLedgEntry: Boolean;

        lCheckStatusErr: Label 'Is not possible to change Routing No. on production order: %1 because it contains line in status %2!';
        lProdOrderEntryError: Label 'Is not possible to change Routing No. on production order: %1 because it contains posted entries!';
    begin
        //GAP_PRO_003-s
        pProductionOrder.TestField("Source Type", pProductionOrder."Source Type"::Item);

        //Controllo se ci sono righe in stato attivato o completato
        Clear(lProdOrderLine);
        lProdOrderLine.SetRange(Status, pProductionOrder.Status);
        lProdOrderLine.SetRange("Prod. Order No.", pProductionOrder."No.");
        lProdOrderLine.SetRange("Planning Level Code", 0);
        lProdOrderLine.SetRange("ecProductive Status", lProdOrderLine."ecProductive Status"::Activated);
        if not lProdOrderLine.IsEmpty then begin
            Error(lCheckStatusErr, pProductionOrder."No.", Format(lProdOrderLine."ecProductive Status"::Activated));
        end;

        //Controllo se sono presenti avanzamenti per le righe
        Clear(lProdOrderLine);
        lProdOrderLine.SetRange(Status, pProductionOrder.Status);
        lProdOrderLine.SetRange("Prod. Order No.", pProductionOrder."No.");
        if not lProdOrderLine.IsEmpty then begin
            lProdOrderLine.FindSet();
            repeat
                ExistsEntriesForProdOrderLine(lProdOrderLine, lExistItemLedgEntry, lExistCapacityLedgEntry);
                if lExistItemLedgEntry or lExistCapacityLedgEntry then begin
                    Error(lProdOrderEntryError, pProductionOrder."No.");
                end;
            until (lProdOrderLine.Next() = 0);
        end;
        //GAP_PRO_003-e
    end;

    internal procedure ExistsEntriesForProdOrderLine(var pProdOrderLine: Record "Prod. Order Line"; var pExistItemLedgEntry: Boolean; var pExistCapacityLedgEntry: Boolean)
    var
        lItemLedgerEntry: Record "Item Ledger Entry";
        lCapacityLedgerEntry: Record "Capacity Ledger Entry";
    begin
        //GAP_PRO_003-s
        pExistItemLedgEntry := false;
        pExistCapacityLedgEntry := false;

        Clear(lItemLedgerEntry);
        lItemLedgerEntry.SetCurrentKey("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.");
        lItemLedgerEntry.SetRange("Order Type", lItemLedgerEntry."Order Type"::Production);
        lItemLedgerEntry.SetRange("Order No.", pProdOrderLine."Prod. Order No.");
        lItemLedgerEntry.SetRange("Order Line No.", pProdOrderLine."Line No.");
        if not lItemLedgerEntry.IsEmpty then begin
            pExistItemLedgEntry := true;
        end;

        Clear(lCapacityLedgerEntry);
        lCapacityLedgerEntry.SetCurrentKey("Order Type", "Order No.", "Order Line No.", "Routing No.", "Routing Reference No.", "Operation No.", "Last Output Line");
        lCapacityLedgerEntry.SetRange("Order Type", lCapacityLedgerEntry."Order Type"::Production);
        lCapacityLedgerEntry.SetRange("Order No.", pProdOrderLine."Prod. Order No.");
        lCapacityLedgerEntry.SetRange("Order Line No.", pProdOrderLine."Line No.");
        if not lCapacityLedgerEntry.IsEmpty then begin
            pExistCapacityLedgEntry := true;
        end;
        //GAP_PRO_003-e
    end;

    internal procedure LookupAlternativeProdOrdComp(var pProdOrderComponent: Record "Prod. Order Component")
    var
        Temp_lBOMAlternativeComponent: Record "ecBOM Alternative Component" temporary;
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
        lSourceItemNo: Code[20];
        lSourceVariantCode: Code[20];
        lToUpdate: Boolean;

        lManagingAlternCompMsg: Label 'Is not possible to manage function of alternative component selection for "%1" different by "%2"|"%3"';
    begin
        //GAP_PRO_003-s
        if (pProdOrderComponent."Calculation Formula" <> pProdOrderComponent."Calculation Formula"::" ") and
           (pProdOrderComponent."Calculation Formula" <> pProdOrderComponent."Calculation Formula"::"Fixed Quantity")
        then begin
            Message(lManagingAlternCompMsg, pProdOrderComponent.FieldCaption("Calculation Formula"), pProdOrderComponent."Calculation Formula"::" ",
                                                                  pProdOrderComponent."Calculation Formula"::"Fixed Quantity");
            exit;
        end;

        lSourceItemNo := '';
        lSourceVariantCode := '';
        lToUpdate := false;

        GetTempAlternativeComponentBuff(Temp_lBOMAlternativeComponent,
                                        pProdOrderComponent."AltAWPSource Prod. BOM No.",
                                        pProdOrderComponent."AltAWPSource Prod. BOM Version",
                                        pProdOrderComponent."AltAWPSource Prod. BOM Line");

        Clear(Temp_lBOMAlternativeComponent);
        if not Temp_lBOMAlternativeComponent.IsEmpty then begin
            lATSSessionDataStore.AddSessionSetting('PageAlternativeProdBOMCompLookup', true);
            if (Page.RunModal(Page::"ecBOM Alternative Components", Temp_lBOMAlternativeComponent) = Action::LookupOK) then begin
                lSourceItemNo := pProdOrderComponent."Item No.";
                lSourceVariantCode := pProdOrderComponent."Variant Code";
                if (pProdOrderComponent."Item No." <> Temp_lBOMAlternativeComponent."Item No.") then begin
                    pProdOrderComponent."Item No." := Temp_lBOMAlternativeComponent."Item No.";
                    lToUpdate := true;
                end;
                if (pProdOrderComponent."Variant Code" <> Temp_lBOMAlternativeComponent."Variant Code") then begin
                    pProdOrderComponent.Validate("Variant Code", Temp_lBOMAlternativeComponent."Variant Code");
                    lToUpdate := true;
                end;
                if lToUpdate then UpdateManualProdOrdComp(pProdOrderComponent, lSourceItemNo, lSourceVariantCode);
            end;
            lATSSessionDataStore.RemoveSessionSetting('PageAlternativeProdBOMCompLookup');
        end;
        //GAP_PRO_003-e
    end;


    internal procedure UpdateManualProdOrdComp(var pProdOrderComponent: Record "Prod. Order Component"; pSourceComponentNo: Code[20]; pSourceVariantCode: Code[10]): Boolean
    var
        Temp_lBOMAlternativeComponent: Record "ecBOM Alternative Component" temporary;
    begin
        //GAP_PRO_003-s
        //Controllo il componente selezionato dalla lista di alternative collegate alla riga di distinta
        CheckComponentNo(pProdOrderComponent."Item No.",
                         pProdOrderComponent."Variant Code",
                         pProdOrderComponent."AltAWPSource Prod. BOM No.",
                         pProdOrderComponent."AltAWPSource Prod. BOM Version",
                         pProdOrderComponent."AltAWPSource Prod. BOM Line",
                         true);
        //Carico la tabella temporanea delle alternative e mi posiziono sul componente selezionato                  
        GetTempAlternativeComponentBuff(Temp_lBOMAlternativeComponent, pProdOrderComponent."AltAWPSource Prod. BOM No.", pProdOrderComponent."AltAWPSource Prod. BOM Version",
                                        pProdOrderComponent."AltAWPSource Prod. BOM Line");
        Temp_lBOMAlternativeComponent.Get(pProdOrderComponent."AltAWPSource Prod. BOM No.", pProdOrderComponent."AltAWPSource Prod. BOM Version",
                                          pProdOrderComponent."AltAWPSource Prod. BOM Line", pProdOrderComponent."Item No.", pProdOrderComponent."Variant Code");
        //Controllo se sono presenti consumi non ancora registrati per il componente da sostituire se stato ODP = Rilasciato
        if (pProdOrderComponent.Status = pProdOrderComponent.Status::Released) then begin
            CheckNotPostedConsumptionForComp(pProdOrderComponent, pSourceComponentNo, pSourceVariantCode);
        end;
        //Eseguo l'aggiornamento della prod. order component in funzione del componente alternativo selezionato
        exit(UpdateProdOrderComponent(pProdOrderComponent, Temp_lBOMAlternativeComponent));
        //GAP_PRO_003-e
    end;

    local procedure UpdateProdOrderComponent(var pProdOrderComponent: Record "Prod. Order Component";
                                             var Temp_pBOMAlternativeComponent: Record "ecBOM Alternative Component" temporary) rComponentModified: Boolean
    var
        lItem: Record Item;
        lProdOrderLine: Record "Prod. Order Line";
        lProdOrderComponentOriginal: Record "Prod. Order Component";
        lNewProdOrderComponent: Record "Prod. Order Component";
        Temp_lProdOrderComp: Record "Prod. Order Component" temporary;
        lProductionFunctions: Codeunit "ecProduction Functions";
        lConsumedQty: Decimal;

        lError001: Label '"%1" must be different from 0!';
    begin
        //GAP_PRO_003-s
        lProdOrderComponentOriginal.Get(pProdOrderComponent.Status, pProdOrderComponent."Prod. Order No.",
                                        pProdOrderComponent."Prod. Order Line No.", pProdOrderComponent."Line No.");
        if (pProdOrderComponent."Remaining Quantity" = 0) then begin
            Error(lError001, pProdOrderComponent.FieldCaption("Remaining Quantity"));
        end;

        if not (pProdOrderComponent."Calculation Formula" in [pProdOrderComponent."Calculation Formula"::" ",
                                                              pProdOrderComponent."Calculation Formula"::"Fixed Quantity"])
        then begin
            exit(false);
        end;

        Temp_lProdOrderComp := pProdOrderComponent;
        lItem.Get(Temp_pBOMAlternativeComponent."Item No.");
        if (pProdOrderComponent."Remaining Quantity" = pProdOrderComponent."Expected Quantity") then begin
            pProdOrderComponent.Validate("Item No.");
            if (Temp_lProdOrderComp."Calculation Formula" = Temp_lProdOrderComp."Calculation Formula"::" ") then begin
                pProdOrderComponent.Validate("Quantity per", Temp_pBOMAlternativeComponent."Quantity per");
            end else begin
                pProdOrderComponent.Validate("Calculation Formula", pProdOrderComponent."Calculation Formula"::"Fixed Quantity");
                pProdOrderComponent.Validate("Quantity per",
                                             Round(lProdOrderComponentOriginal."Remaining Quantity" / lProdOrderComponentOriginal."ecSource Qty. per" * Temp_pBOMAlternativeComponent."Quantity per",
                                             lItem."Rounding Precision", '='));
            end;
            if (Temp_pBOMAlternativeComponent."Unit of Measure Code" <> pProdOrderComponent."Unit of Measure Code") and
               (Temp_pBOMAlternativeComponent."Unit of Measure Code" <> '')
            then begin
                pProdOrderComponent.Validate("Unit of Measure Code", Temp_pBOMAlternativeComponent."Unit of Measure Code");
            end;
            pProdOrderComponent."Scrap %" := Temp_pBOMAlternativeComponent."Scrap %";
            pProdOrderComponent."ecSource Qty. per" := Temp_pBOMAlternativeComponent."Quantity per";
            pProdOrderComponent.Modify(true);
        end else begin
            //Chiudo la riga di componente originale con tipo calcolo = quantità fissa e con la quantità per = quantità consumata
            lConsumedQty := pProdOrderComponent."Expected Quantity" - pProdOrderComponent."Remaining Quantity";
            pProdOrderComponent."Item No." := lProdOrderComponentOriginal."Item No.";
            if (pProdOrderComponent."Calculation Formula" = pProdOrderComponent."Calculation Formula"::" ") then begin
                pProdOrderComponent.Validate("Calculation Formula", pProdOrderComponent."Calculation Formula"::"Fixed Quantity");
            end;
            pProdOrderComponent.Validate("Quantity per", lConsumedQty);
            pProdOrderComponent.Modify(true);

            Clear(lProdOrderComponentOriginal);
            lProdOrderComponentOriginal.SetRange(Status, pProdOrderComponent.Status);
            lProdOrderComponentOriginal.SetRange("Prod. Order No.", pProdOrderComponent."Prod. Order No.");
            lProdOrderComponentOriginal.SetRange("Prod. Order Line No.", pProdOrderComponent."Prod. Order Line No.");
            if not lProdOrderComponentOriginal.IsEmpty then begin
                lProdOrderComponentOriginal.FindLast();
            end;

            //Creo una nuova riga con il nuovo componente selezionato
            lNewProdOrderComponent.Init();
            lNewProdOrderComponent.Status := Temp_lProdOrderComp.Status;
            lNewProdOrderComponent."Prod. Order No." := Temp_lProdOrderComp."Prod. Order No.";
            lNewProdOrderComponent."Prod. Order Line No." := Temp_lProdOrderComp."Prod. Order Line No.";
            lNewProdOrderComponent."Line No." := lProdOrderComponentOriginal."Line No." + 10000;
            lNewProdOrderComponent.Validate("Item No.", Temp_pBOMAlternativeComponent."Item No.");
            lNewProdOrderComponent.Validate("Variant Code", Temp_pBOMAlternativeComponent."Variant Code");
            lNewProdOrderComponent.Validate("Unit of Measure Code", Temp_pBOMAlternativeComponent."Unit of Measure Code");
            lNewProdOrderComponent.Validate("Location Code", Temp_lProdOrderComp."Location Code");
            lNewProdOrderComponent.Validate("Bin Code", Temp_lProdOrderComp."Bin Code");
            lNewProdOrderComponent.Validate("Routing Link Code", Temp_lProdOrderComp."Routing Link Code");
            lNewProdOrderComponent.Validate("Quantity per",
                                            Round(Temp_lProdOrderComp."Remaining Quantity" / Temp_lProdOrderComp."ecSource Qty. per" * Temp_pBOMAlternativeComponent."Quantity per",
                                            lItem."Rounding Precision", '='));
            lNewProdOrderComponent.Validate("Calculation Formula", lNewProdOrderComponent."Calculation Formula"::"Fixed Quantity");
            lNewProdOrderComponent.Validate("Scrap %", Temp_pBOMAlternativeComponent."Scrap %");
            lNewProdOrderComponent."AltAWPSource Prod. BOM No." := Temp_lProdOrderComp."AltAWPSource Prod. BOM No.";
            lNewProdOrderComponent."AltAWPSource Prod. BOM Version" := Temp_lProdOrderComp."AltAWPSource Prod. BOM Version";
            lNewProdOrderComponent."AltAWPSource Prod. BOM Line" := Temp_lProdOrderComp."AltAWPSource Prod. BOM Line";
            lNewProdOrderComponent."ecSource Qty. per" := Temp_pBOMAlternativeComponent."Quantity per";
            lNewProdOrderComponent.Insert(true);

            rComponentModified := false;
        end;

        //CS_PRO_039-s
        if rComponentModified then begin
            if lProdOrderLine.Get(pProdOrderComponent.Status, pProdOrderComponent."Prod. Order No.", pProdOrderComponent."Prod. Order Line No.") then begin
                lProductionFunctions.UpdateProdOrdLinePackagingFields(lProdOrderLine);
            end;
        end;
        //CS_PRO_039-e

        exit(rComponentModified);
        //GAP_PRO_003-e
    end;

    local procedure GetTempAlternativeComponentBuff(var Temp_pBOMAlternativeComponent: Record "ecBOM Alternative Component" temporary;
                                                    pProdBOMNo: Code[20]; pProdBOMVersionCode: Code[20]; pProdBOMLineNo: Integer)
    var
        lProductionBOMLine: Record "Production BOM Line";
        lBOMAlternativeComponent: Record "ecBOM Alternative Component";
    begin
        //GAP_PRO_003-s
        Clear(Temp_pBOMAlternativeComponent);
        Temp_pBOMAlternativeComponent.DeleteAll();

        if lProductionBOMLine.Get(pProdBOMNo, pProdBOMVersionCode, pProdBOMLineNo) and (lProductionBOMLine.Type = lProductionBOMLine.Type::Item) then begin
            Clear(lBOMAlternativeComponent);
            lBOMAlternativeComponent.SetRange("Production BOM No.", lProductionBOMLine."Production BOM No.");
            lBOMAlternativeComponent.SetRange("Prod. BOM Version Code", lProductionBOMLine."Version Code");
            lBOMAlternativeComponent.SetRange("Prod. BOM Line No.", lProductionBOMLine."Line No.");

            if not lBOMAlternativeComponent.IsEmpty then begin
                lBOMAlternativeComponent.FindSet();
                repeat
                    Temp_pBOMAlternativeComponent := lBOMAlternativeComponent;
                    Temp_pBOMAlternativeComponent.Insert(false);
                until (lBOMAlternativeComponent.Next() = 0);
            end;

            Temp_pBOMAlternativeComponent.Init();
            Temp_pBOMAlternativeComponent."Production BOM No." := lProductionBOMLine."Production BOM No.";
            Temp_pBOMAlternativeComponent."Prod. BOM Version Code" := lProductionBOMLine."Version Code";
            Temp_pBOMAlternativeComponent."Prod. BOM Line No." := lProductionBOMLine."Line No.";
            Temp_pBOMAlternativeComponent."Item No." := lProductionBOMLine."No.";
            Temp_pBOMAlternativeComponent."Variant Code" := lProductionBOMLine."Variant Code";
            Temp_pBOMAlternativeComponent."Quantity per" := lProductionBOMLine."Quantity per";
            Temp_pBOMAlternativeComponent."Scrap %" := lProductionBOMLine."Scrap %";
            Temp_pBOMAlternativeComponent."Unit of Measure Code" := lProductionBOMLine."Unit of Measure Code";
            if Temp_pBOMAlternativeComponent.Insert() then;
        end;
        //GAP_PRO_003-e
    end;

    internal procedure CheckComponentNo(pNewComponentNo: Code[20]; pNewVariantCode: Code[10]; pProdBOMNo: Code[20]; pProdBOMVersionCode: Code[20];
                                        pProdBOMLineNo: Integer; pWithError: Boolean): Boolean
    var
        Temp_lBOMAlternativeComponent: Record "ecBOM Alternative Component" temporary;

        lError001: Label 'Selected Component No.: "%1" is not valid for Prod. BOM No.: "%2" - Line No. : %3';
    begin
        //GAP_PRO_003-s
        GetTempAlternativeComponentBuff(Temp_lBOMAlternativeComponent, pProdBOMNo, pProdBOMVersionCode, pProdBOMLineNo);
        if not Temp_lBOMAlternativeComponent.Get(pProdBOMNo, pProdBOMVersionCode, pProdBOMLineNo, pNewComponentNo, pNewVariantCode) and
           (pProdBOMNo <> '') and (pProdBOMLineNo <> 0)
        then begin
            if pWithError then Error(lError001, pNewComponentNo, pProdBOMNo, pProdBOMLineNo);
            exit(false);
        end;

        exit(true);
        //GAP_PRO_003-e
    end;

    internal procedure LookupAlternativePlanningComp(var pPlanningComponent: Record "Planning Component")
    var
        Temp_lBOMAlternativeComponent: Record "ecBOM Alternative Component" temporary;
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //GAP_PRO_003-s
        GetTempAlternativeComponentBuff(Temp_lBOMAlternativeComponent,
                                        pPlanningComponent."AltAWPSource Prod. BOM No.",
                                        pPlanningComponent."AltAWPSource Prod. BOM Version",
                                        pPlanningComponent."AltAWPSource Prod. BOM Line");

        Clear(Temp_lBOMAlternativeComponent);
        if not Temp_lBOMAlternativeComponent.IsEmpty then begin
            lATSSessionDataStore.AddSessionSetting('PageAlternativeProdBOMCompLookup', true);
            if (Page.RunModal(Page::"ecBOM Alternative Components", Temp_lBOMAlternativeComponent) = Action::LookupOK) then begin
                if (pPlanningComponent."Item No." <> Temp_lBOMAlternativeComponent."Item No.") then begin
                    pPlanningComponent."Item No." := Temp_lBOMAlternativeComponent."Item No.";
                end;
                if (pPlanningComponent."Variant Code" <> Temp_lBOMAlternativeComponent."Variant Code") then begin
                    pPlanningComponent.Validate("Variant Code", Temp_lBOMAlternativeComponent."Variant Code");
                end;
                UpdateManualPlanningComp(pPlanningComponent, pPlanningComponent."Item No.", pPlanningComponent."Variant Code");
            end;
            lATSSessionDataStore.RemoveSessionSetting('PageAlternativeProdBOMCompLookup');
        end;
        //GAP_PRO_003-e
    end;


    internal procedure UpdateManualPlanningComp(var pPlanningComponent: Record "Planning Component"; pNewComponentNo: Code[20]; pNewVariantCode: Code[10]): Boolean
    var
        Temp_lBOMAlternativeComponent: Record "ecBOM Alternative Component" temporary;
    begin
        //GAP_PRO_003-s
        //Controllo il componente selezionato dalla lista di alternative collegate alla riga di distinta
        CheckComponentNo(pNewComponentNo,
                         pNewVariantCode,
                         pPlanningComponent."AltAWPSource Prod. BOM No.",
                         pPlanningComponent."AltAWPSource Prod. BOM Version",
                         pPlanningComponent."AltAWPSource Prod. BOM Line",
                         true);

        //Carico la tabella temporanea delle alternative e mi posiziono sul componente selezionato                  
        GetTempAlternativeComponentBuff(Temp_lBOMAlternativeComponent,
                                        pPlanningComponent."AltAWPSource Prod. BOM No.",
                                        pPlanningComponent."AltAWPSource Prod. BOM Version",
                                        pPlanningComponent."AltAWPSource Prod. BOM Line");

        Temp_lBOMAlternativeComponent.Get(pPlanningComponent."AltAWPSource Prod. BOM No.",
                                          pPlanningComponent."AltAWPSource Prod. BOM Version",
                                          pPlanningComponent."AltAWPSource Prod. BOM Line",
                                          pNewComponentNo,
                                          pNewVariantCode);

        //Eseguo l'aggiornamento della planning component in funzione del componente alternativo selezionato
        exit(UpdatePlanningComponent(pPlanningComponent, Temp_lBOMAlternativeComponent));
        //GAP_PRO_003-e
    end;

    local procedure UpdatePlanningComponent(var pPlanningComponent: Record "Planning Component";
                                            var Temp_pBOMAlternativeComponent: Record "ecBOM Alternative Component" temporary): Boolean
    var
        lItem: Record Item;
        lPlanningComponentOriginal: Record "Planning Component";
    begin
        //GAP_PRO_003-s
        lPlanningComponentOriginal.Get(pPlanningComponent."Worksheet Template Name", pPlanningComponent."Worksheet Batch Name",
                                       pPlanningComponent."Worksheet Line No.", pPlanningComponent."Line No.");

        if not (pPlanningComponent."Calculation Formula" in [pPlanningComponent."Calculation Formula"::" ",
                                                             pPlanningComponent."Calculation Formula"::"Fixed Quantity"])
        then begin
            exit(false);
        end;

        lItem.Get(Temp_pBOMAlternativeComponent."Item No.");
        pPlanningComponent.Validate("Item No.");
        if (lPlanningComponentOriginal."Calculation Formula" = lPlanningComponentOriginal."Calculation Formula"::" ") then begin
            pPlanningComponent.Validate("Quantity per", Temp_pBOMAlternativeComponent."Quantity per");
        end else begin
            pPlanningComponent.Validate("Calculation Formula", pPlanningComponent."Calculation Formula"::"Fixed Quantity");
            pPlanningComponent.Validate("Quantity per",
                                         Round(pPlanningComponent."Expected Quantity" * (Temp_pBOMAlternativeComponent."Quantity per" / pPlanningComponent."ecSource Qty. per"),
                                         lItem."Rounding Precision", '='));
        end;
        if (Temp_pBOMAlternativeComponent."Unit of Measure Code" <> pPlanningComponent."Unit of Measure Code") and
           (Temp_pBOMAlternativeComponent."Unit of Measure Code" <> '')
        then begin
            pPlanningComponent.Validate("Unit of Measure Code", Temp_pBOMAlternativeComponent."Unit of Measure Code");
        end;
        pPlanningComponent."ecSource Qty. per" := Temp_pBOMAlternativeComponent."Quantity per";
        pPlanningComponent.Modify(true);

        exit(true);
        //GAP_PRO_003-e 
    end;

    local procedure CheckNotPostedConsumptionForComp(pProdOrderComponent: Record "Prod. Order Component"; pSourceItemNo: Code[20]; pSourceVariantCode: Code[10])
    var
        lItem: Record Item;
        lProductionOrder: Record "Production Order";
        lAWPGeneralSetup: Record "AltAWPGeneral Setup";
        lItemJournalLine: Record "Item Journal Line";
        lProductionJournalMgt: Codeunit "Production Journal Mgt";
        lawpItemJournalFunctions: Codeunit "AltAWPItem Journal Functions";
        lToTemplateName: Code[10];
        lToBatchName: Code[10];

        lNotComplConsumptionConf: Label 'Warning, there are some posted outputs for which the consumption of the component %1 - %2 has not been completed, are you sure you want to proceed with its replacement?';
        lOperationCancelErr: Label 'Operation canceled';
    begin
        //GAP_PRO_003-s
        lAWPGeneralSetup.Get();
        if lAWPGeneralSetup."Enable Ref. Prop. Manual Cons." then begin
            lProductionOrder.Get(pProdOrderComponent.Status, pProdOrderComponent."Prod. Order No.");

            Clear(lProductionJournalMgt);
            lProductionJournalMgt.SetTemplateAndBatchName();
            lProductionJournalMgt.GetJnlTemplateAndBatchName(lToTemplateName, lToBatchName);
            lProductionJournalMgt.InitSetupValues();
            lProductionJournalMgt.DeleteJnlLines(lToTemplateName, lToBatchName, pProdOrderComponent."Prod. Order No.", pProdOrderComponent."Prod. Order Line No.");
            lProductionJournalMgt.CreateJnlLines(lProductionOrder, pProdOrderComponent."Prod. Order Line No.");

            Clear(lItemJournalLine);
            lItemJournalLine.SetRange("Journal Template Name", lToTemplateName);
            lItemJournalLine.SetRange("Journal Batch Name", lToBatchName);
            lItemJournalLine.SetRange("Order Type", lItemJournalLine."Order Type"::Production);
            lItemJournalLine.SetRange("Entry Type", lItemJournalLine."Entry Type"::Output);
            lItemJournalLine.SetRange("Order No.", pProdOrderComponent."Prod. Order No.");
            lItemJournalLine.SetRange("Order Line No.", pProdOrderComponent."Prod. Order Line No.");
            if not lItemJournalLine.IsEmpty then begin
                lItemJournalLine.FindSet();
                repeat
                    lItemJournalLine."Output Quantity" := 0;
                    lItemJournalLine.Modify(true);
                    lawpItemJournalFunctions.ItemJnlLineAllignRunAndQuantity(lItemJournalLine, true, true);
                until (lItemJournalLine.Next() = 0);
            end;

            Clear(lItemJournalLine);
            lItemJournalLine.SetRange("Journal Template Name", lToTemplateName);
            lItemJournalLine.SetRange("Journal Batch Name", lToBatchName);
            lItemJournalLine.SetRange("Order Type", lItemJournalLine."Order Type"::Production);
            lItemJournalLine.SetRange("Entry Type", lItemJournalLine."Entry Type"::Consumption);
            lItemJournalLine.SetRange("Order No.", pProdOrderComponent."Prod. Order No.");
            lItemJournalLine.SetRange("Order Line No.", pProdOrderComponent."Prod. Order Line No.");
            lItemJournalLine.SetRange("Prod. Order Comp. Line No.", pProdOrderComponent."Line No.");
            lItemJournalLine.SetRange("Item No.", pSourceItemNo);
            lItemJournalLine.SetRange("Variant Code", pSourceVariantCode);
            if not lItemJournalLine.IsEmpty then begin
                lItemJournalLine.CalcSums(Quantity);
                if (lItemJournalLine.Quantity > 0) then begin
                    lItem.Get(pSourceItemNo);
                    if not Confirm(StrSubstNo(lNotComplConsumptionConf, lItem."No.", lItem.Description), false) then Error(lOperationCancelErr);
                end;
            end;

            lProductionJournalMgt.DeleteJnlLines(lToTemplateName, lToBatchName, lProductionOrder."No.", pProdOrderComponent."Prod. Order Line No.");
        end;
        //GAP_PRO_003-e
    end;

    internal procedure UpdateProductiveAreaOnWarehouseActivityHeader(pProductionOrder: Record "Production Order")
    var
        lProdOrderLine: Record "Prod. Order Line";
        lWarehouseActivityHeader: Record "Warehouse Activity Header";
    begin
        //GAP_PRO_003-s
        if (pProductionOrder.Status <> pProductionOrder.Status::Released) or (pProductionOrder."No." = '') then exit;

#pragma warning disable AA0210
        lWarehouseActivityHeader.SetCurrentKey("AltAWPProduction Order No.");
        lWarehouseActivityHeader.SetRange("AltAWPProduction Order No.", pProductionOrder."No.");
#pragma warning restore AA0210
        if lWarehouseActivityHeader.IsEmpty then exit;

        lWarehouseActivityHeader.FindSet();
        repeat
            if lProdOrderLine.Get(pProductionOrder.Status, pProductionOrder."No.", lWarehouseActivityHeader."AltAWPProd. Order Line No.") then begin
                if (lProdOrderLine."ecPrevalent Operation Type" = lProdOrderLine."ecPrevalent Operation Type"::"Machine Center") and
                   (lWarehouseActivityHeader."AltAWPProductive Area Type" <> lWarehouseActivityHeader."AltAWPProductive Area Type"::"Machine Center")
                then begin
                    lWarehouseActivityHeader."AltAWPProductive Area Type" := lWarehouseActivityHeader."AltAWPProductive Area Type"::"Machine Center";
                end;
                if (lProdOrderLine."ecPrevalent Operation Type" = lProdOrderLine."ecPrevalent Operation Type"::"Work Center") and
                   (lWarehouseActivityHeader."AltAWPProductive Area Type" <> lWarehouseActivityHeader."AltAWPProductive Area Type"::"Work Center")
                then begin
                    lWarehouseActivityHeader."AltAWPProductive Area Type" := lWarehouseActivityHeader."AltAWPProductive Area Type"::"Work Center";
                end;
                if (lProdOrderLine."ecPrevalent Operation Type" = lProdOrderLine."ecPrevalent Operation Type"::" ") and
                   (lWarehouseActivityHeader."AltAWPProductive Area Type" <> lWarehouseActivityHeader."AltAWPProductive Area Type"::" ")
                then begin
                    lWarehouseActivityHeader."AltAWPProductive Area Type" := lWarehouseActivityHeader."AltAWPProductive Area Type"::" ";
                end;
                lWarehouseActivityHeader."AltAWPProductive Area No." := lProdOrderLine."ecPrevalent Operation No.";
                lWarehouseActivityHeader.Modify(false);
            end;
        until (lWarehouseActivityHeader.Next() = 0);
        //GAP_PRO_003-e
    end;

    #endregion GAP_PRO_003 - Gestione alternative componenti/cicli

    #region CS_PRO_008 -  Gestione estesa del calcolo delle date scadenza e gestione della shelf-life per cliente + integrazione campi anagrafici su Informazioni Lotto

    internal procedure ReleaseLotNoInformation(var pLotNoInformation: Record "Lot No. Information"; pShowDialogs: Boolean)
    var
        lItem: Record Item;
        lItemTrackingCode: Record "Item Tracking Code";
        lecRestrictionsMgt: Codeunit "ecRestrictions Mgt.";
        lErrorMsg: Text;
        lRequredAttributes: Boolean;

        lStatusErr: Label 'Is not possible to release "Lot No. Information Card" when %1 = %2!';
        lFieldRequiredErr: Label 'Following fields are required:';
    begin
        //CS_PRO_008-s
        if not (pLotNoInformation."ecLot No. Information Status" in [pLotNoInformation."ecLot No. Information Status"::Open,
                                                                     pLotNoInformation."ecLot No. Information Status"::"Required Attributes"])
        then begin
            Error(lStatusErr, pLotNoInformation.FieldCaption("ecLot No. Information Status"), pLotNoInformation."ecLot No. Information Status");
        end;

        lErrorMsg := lFieldRequiredErr;
        lRequredAttributes := false;
        lItem.Get(pLotNoInformation."Item No.");
        if lItem."ecMandatory Origin Lot No." and (pLotNoInformation."ecOrigin Country Code" = '') then begin
            AddErrorMessage(lErrorMsg, pLotNoInformation.FieldCaption("ecOrigin Country Code"));
            lRequredAttributes := true;
        end;
        if (lItem."Country/Region of Origin Code" <> '') then begin
            pLotNoInformation.TestField("ecOrigin Country Code", lItem."Country/Region of Origin Code");
        end;
        if (lItem."Item Tracking Code" <> '') and lItemTrackingCode.Get(lItem."Item Tracking Code") and
           lItemTrackingCode."Use Expiration Dates" and (pLotNoInformation."ecExpiration Date" = 0D)
        then begin
            AddErrorMessage(lErrorMsg, pLotNoInformation.FieldCaption("ecExpiration Date"));
            lRequredAttributes := true;
        end;
        if (lItem.Type in [lItem."ecItem Type"::"Finished Product", lItem."ecItem Type"::"Semi-finished Product", lItem."ecItem Type"::"Raw Material"]) then begin
            if (pLotNoInformation.ecVariety = '') or (pLotNoInformation."ecManufacturer No." = '') or (pLotNoInformation.ecGauge = '') or
               (pLotNoInformation."ecCrop Vendor Year" = 0)
            then begin
                if (pLotNoInformation.ecVariety = '') then AddErrorMessage(lErrorMsg, pLotNoInformation.FieldCaption(ecVariety));
                if (pLotNoInformation."ecManufacturer No." = '') then AddErrorMessage(lErrorMsg, pLotNoInformation.FieldCaption("ecManufacturer No."));
                if (pLotNoInformation.ecGauge = '') then AddErrorMessage(lErrorMsg, pLotNoInformation.FieldCaption(ecGauge));
                if (pLotNoInformation."ecCrop Vendor Year" = 0) then AddErrorMessage(lErrorMsg, pLotNoInformation.FieldCaption("ecCrop Vendor Year"));
                lRequredAttributes := true;
            end;
        end;

        if ((pLotNoInformation."ecVendor No." = '') or (pLotNoInformation."ecVendor Lot No." = '')) and
           (pLotNoInformation."ecLot Creation Process" = pLotNoInformation."ecLot Creation Process"::"Purchase Receipt")
        then begin
            if (pLotNoInformation."ecVendor No." = '') then AddErrorMessage(lErrorMsg, pLotNoInformation.FieldCaption("ecVendor No."));
            if (pLotNoInformation."ecVendor Lot No." = '') then AddErrorMessage(lErrorMsg, pLotNoInformation.FieldCaption("ecVendor Lot No."));
            lRequredAttributes := true;
        end;

        if not lRequredAttributes then begin
            //CS_PRO_011-VI-s
            lecRestrictionsMgt.TestLotNoRestrictionOnRelease(pLotNoInformation, pShowDialogs);
            //CS_PRO_011-VI-e

            pLotNoInformation.Validate("ecLot No. Information Status", pLotNoInformation."ecLot No. Information Status"::Released);
        end else begin
            Message(lErrorMsg);
            pLotNoInformation.Validate("ecLot No. Information Status", pLotNoInformation."ecLot No. Information Status"::"Required Attributes");
        end;
        pLotNoInformation.Modify(true);
        //CS_PRO_008-e
    end;

    local procedure AddErrorMessage(var pErrorMsg: Text; pTextToAdd: Text)
    var
        lPoint: Label '•', Locked = true;
    begin
        if (pErrorMsg = '') then begin
            pErrorMsg := pTextToAdd;
        end else begin
            pErrorMsg += '\';
            pErrorMsg += lPoint + ' ' + pTextToAdd;
        end;
    end;

    internal procedure ReopenLotNoInformation(var pLotNoInformation: Record "Lot No. Information")
    var
        lStatusErr: Label 'Is not possible to reopen "Lot No. Information Card" when %1 = %2!';
        lLedgEntriesErr: Label 'It is not possible to reopen "Lot No. Information Card" if there are Item Ledger Entries!';
    begin
        //CS_PRO_008-s
        if (pLotNoInformation."ecLot No. Information Status" <> pLotNoInformation."ecLot No. Information Status"::Released) then begin
            Error(lStatusErr, pLotNoInformation.FieldCaption("ecLot No. Information Status"), pLotNoInformation."ecLot No. Information Status");
        end;

        pLotNoInformation.CalcFields("ecNo. Of Item Ledg. Entries");
        if (pLotNoInformation."ecNo. Of Item Ledg. Entries" > 0) then begin
            Error(lLedgEntriesErr);
        end;

        pLotNoInformation."ecLot No. Information Status" := pLotNoInformation."ecLot No. Information Status"::Open;
        pLotNoInformation.Modify(true);
        //CS_PRO_008-e
    end;

    internal procedure AssignNewLotNoToLotNoInfo(var pLotNoInformation: Record "Lot No. Information")
    var
        lTrackingFunctions: Codeunit "ecTracking Functions";
        lNewLotNo: Code[20];
    begin
        //CS_PRO_008-s
        pLotNoInformation.TestField("Item No.");
        pLotNoInformation.TestField("Lot No.", '');

        lNewLotNo := lTrackingFunctions.GetNewItemLotNo(pLotNoInformation."Item No.", pLotNoInformation."Variant Code", false, false);
        pLotNoInformation.Validate("Lot No.", lNewLotNo);
        //CS_PRO_008-e
    end;

    procedure CalcMaxUsableDateForItem(pItemNo: Code[20];
                                       pVariantCode: Code[10];
                                       pCustomerNo: Code[20];
                                       pExpirationDate: Date
                                      ) rMaxUsableDate: Date
    var
        lItem: Record Item;
        lItemCustomerDetails: Record "ecItem Customer Details";
        lCalcFormula: DateFormula;
    begin
        //CS_PRO_008-s
        rMaxUsableDate := pExpirationDate;

        if (pExpirationDate <> 0D) then begin
            if lItem.Get(pItemNo) then begin
                lCalcFormula := lItem."ecCalc. for Max Usable Date";

                if (pCustomerNo <> '') then begin
                    if lItemCustomerDetails.GetCustomerSettings(pItemNo, pVariantCode, pCustomerNo) then begin
                        lCalcFormula := lItemCustomerDetails."Calc. for Max Usable Date";
                    end;
                end;

                if (Format(lCalcFormula) <> '') then begin
                    rMaxUsableDate := CalcDate(lCalcFormula, pExpirationDate);
                end;
            end;
        end;

        exit(rMaxUsableDate);
        //CS_PRO_008-e
    end;
    #endregion CS_PRO_008 - Gestione estesa del calcolo delle date scadenza e gestione della shelf-life per cliente + integrazione campi anagrafici su Informazioni Lotto

    #region CS_PRO_009 - Gestione del KIT di fatturazione per espositori

    internal procedure IsKitProductExhibitorItem(pItemNo: Code[20]): Boolean
    var
        lItem: Record Item;
    begin
        //CS_PRO_009-s
        if not lItem.Get(pItemNo) then exit(false);

        exit(lItem."ecKit/Product Exhibitor");
        //CS_PRO_009-e
    end;

    #endregion CS_PRO_009 - Gestione del KIT di fatturazione per espositori

    #region CS_PRO_018 - Gestione dei Piani di Produzione e calendari sostitutivi per Aree e Centri

    internal procedure CheckProdAlternativeCalendar(var pShopCalendarWorkingDays: Record "Shop Calendar Working Days"; pPeriodDate: Date)
    var
        lProdAlternativeCalendar: Record "ecProd. Alternative Calendar";
        lSessionDataStore: Codeunit "AltATSSession Data Store";
        lCapacityType: Integer;
    begin
        //CS_PRO_018-s
        Clear(lProdAlternativeCalendar);
        lProdAlternativeCalendar.SetRange("Work Center No.", lSessionDataStore.GetSessionSettingValue('CalcScheduleWorkCenterNo'));
        lCapacityType := lSessionDataStore.GetSessionSettingNumericValue('CalcScheduleCapacityType');
        if (Enum::"Capacity Type".FromInteger(lCapacityType) = Enum::"Capacity Type"::"Machine Center") then begin
            lProdAlternativeCalendar.SetRange("Machine Center No.", lSessionDataStore.GetSessionSettingValue('CalcScheduleNo'));
        end;
        lProdAlternativeCalendar.SetFilter("Period Starting Date", '<=%1', pPeriodDate);
        lProdAlternativeCalendar.SetFilter("Period Ending Date", '>=%1', pPeriodDate);
        if not lProdAlternativeCalendar.IsEmpty then begin
            lProdAlternativeCalendar.FindFirst();
            lProdAlternativeCalendar.TestField("Alternative Shop Calendar Code");
            pShopCalendarWorkingDays.SetRange("Shop Calendar Code", lProdAlternativeCalendar."Alternative Shop Calendar Code");
        end else begin
            pShopCalendarWorkingDays.SetRange("Shop Calendar Code", lSessionDataStore.GetSessionSettingValue('DefaultWorkCenterCalendar'));
        end;
        //CS_PRO_018-e  
    end;

    internal procedure UpdateProdOrderLineInformations(var pProdOrderLine: Record "Prod. Order Line")
    var
        lItem: Record Item;
        lParentProdOrderLine: Record "Prod. Order Line";
        lProdOrderComponent: Record "Prod. Order Component";
        lProdOrderRoutingLine: Record "Prod. Order Routing Line";
        lWorkCenter: Record "Work Center";
        lMachineCenter: Record "Machine Center";
        lIsParentLine: Boolean;
    begin
        //CS_PRO_018-s
        lIsParentLine := true;
        pProdOrderLine."ecParent Line No." := 0;
        Clear(lProdOrderComponent);
        lProdOrderComponent.SetRange(Status, pProdOrderLine.Status);
        lProdOrderComponent.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        lProdOrderComponent.SetRange("Supplied-by Line No.", pProdOrderLine."Line No.");
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindLast();
            lIsParentLine := false;
            pProdOrderLine."ecParent Line No." := lProdOrderComponent."Prod. Order Line No.";
        end;

        if lItem.Get(pProdOrderLine."Item No.") then pProdOrderLine."ecSend-Ahead Quantity" := lItem."ecSend-Ahead Quantity";

        Clear(lProdOrderRoutingLine);
        lProdOrderRoutingLine.SetRange(Status, pProdOrderLine.Status);
        lProdOrderRoutingLine.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        lProdOrderRoutingLine.SetRange("Routing Reference No.", pProdOrderLine."Routing Reference No.");
        lProdOrderRoutingLine.SetRange("Routing No.", pProdOrderLine."Routing No.");
        lProdOrderRoutingLine.SetFilter("Routing Link Code", '<>%1', '');
        if not lProdOrderRoutingLine.IsEmpty then begin
            lProdOrderRoutingLine.FindLast();
            if (lProdOrderRoutingLine.Type = lProdOrderRoutingLine.Type::"Machine Center") then begin
                if lMachineCenter.Get(lProdOrderRoutingLine."No.") then begin
                    if not lWorkCenter.Get(lMachineCenter."Work Center No.") then Clear(lWorkCenter);
                end;
            end else begin
                if not lWorkCenter.Get(lMachineCenter."Work Center No.") then Clear(lWorkCenter);
            end;

            if lIsParentLine then begin
                if (pProdOrderLine."ecParent Routing No." <> pProdOrderLine."Routing No.") or (pProdOrderLine."ecWork Center No." <> lWorkCenter."No.") or
                   (pProdOrderLine."ecParent Work Center No." <> lWorkCenter."No.")
                then begin
                    pProdOrderLine."ecParent Routing No." := pProdOrderLine."Routing No.";
                    pProdOrderLine."ecWork Center No." := lWorkCenter."No.";
                    pProdOrderLine."ecParent Work Center No." := lWorkCenter."No.";
                end;
            end else begin
                lParentProdOrderLine.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.", lProdOrderComponent."Prod. Order Line No.");
                if (pProdOrderLine."ecWork Center No." <> lWorkCenter."No.") or (pProdOrderLine."ecParent Routing No." <> lParentProdOrderLine."Routing No.") or
                   (pProdOrderLine."ecParent Work Center No." <> lParentProdOrderLine."ecWork Center No.")
                then begin
                    pProdOrderLine."ecWork Center No." := lWorkCenter."No.";
                    pProdOrderLine."ecParent Routing No." := lParentProdOrderLine."Routing No.";
                    pProdOrderLine."ecParent Work Center No." := lParentProdOrderLine."ecWork Center No.";
                end;
            end;
        end else begin
            if lIsParentLine then begin
                if (pProdOrderLine."ecWork Center No." <> '') or (pProdOrderLine."ecParent Routing No." <> '') or
                   (pProdOrderLine."ecParent Work Center No." <> '')
                then begin
                    pProdOrderLine."ecWork Center No." := '';
                    pProdOrderLine."ecParent Routing No." := '';
                    pProdOrderLine."ecParent Work Center No." := '';
                end;
            end else begin
                lParentProdOrderLine.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.", lProdOrderComponent."Prod. Order Line No.");
                if (pProdOrderLine."ecWork Center No." <> '') or (pProdOrderLine."ecParent Routing No." <> lParentProdOrderLine."Routing No.") or
                   (pProdOrderLine."ecParent Work Center No." <> lParentProdOrderLine."ecWork Center No.")
                then begin
                    pProdOrderLine."ecWork Center No." := '';
                    pProdOrderLine."ecParent Routing No." := lParentProdOrderLine."Routing No.";
                    pProdOrderLine."ecParent Work Center No." := lParentProdOrderLine."ecWork Center No.";
                end;
            end;
        end;
        pProdOrderLine.Modify(false);
    end;

    internal procedure CalculatePlanningSequence(var pProdOrderLine: Record "Prod. Order Line"): Boolean
    var
        lCalcProdOrdLineSeq: Report "ecCalc. Prod. Ord. Line Seq.";
    begin
        //CS_PRO_018-s
        if pProdOrderLine.IsEmpty then exit(false);

        CheckSelectedPlanningLines(pProdOrderLine);
        ClearSelectedProdOrderLineSequence(pProdOrderLine);

        Commit();
        lCalcProdOrdLineSeq.SetProdOrderLines(pProdOrderLine);
        lCalcProdOrdLineSeq.RunModal();

        exit(true);
        //CS_PRO_018-e
    end;

    local procedure CheckSelectedPlanningLines(var pProdOrderLine: Record "Prod. Order Line")
    var
        lPrevalentOperationNo: Code[20];
        lPrevalentOperationType: Enum "ecPrevalent Operation Type";

        lPlanningLevelCodeErr: Label 'Scheduling is only allowed on master lines of production orders!';
        lOperationErr: Label 'Scheduling is only allowed on a set of lines belonging to the same "Work Center" or "Machine Center"!';
    begin
        //CS_PRO_018-s
        if pProdOrderLine.IsEmpty then exit;

        pProdOrderLine.FindSet();
        lPrevalentOperationType := pProdOrderLine."ecPrevalent Operation Type";
        lPrevalentOperationNo := pProdOrderLine."ecPrevalent Operation No.";
        repeat
            if (pProdOrderLine."ecParent Line No." <> 0) then begin
                Error(lPlanningLevelCodeErr);
            end;

            if (lPrevalentOperationType <> pProdOrderLine."ecPrevalent Operation Type") or
               (lPrevalentOperationNo <> pProdOrderLine."ecPrevalent Operation No.")
            then begin
                Error(lOperationErr);
            end;
        until (pProdOrderLine.Next() = 0);
        //CS_PRO_018-e
    end;

    local procedure ClearSelectedProdOrderLineSequence(var pProdOrderLine: Record "Prod. Order Line")
    begin
        //CS_PRO_018-s
        if pProdOrderLine.IsEmpty then exit;
        pProdOrderLine.FindSet();
        repeat
            pProdOrderLine."ecScheduling Sequence" := 0;
            pProdOrderLine.Modify(false);
        until (pProdOrderLine.Next() = 0);
        //CS_PRO_018-e
    end;

    internal procedure ApplyProdOrderLineSequence(var pProdOrderLine: Record "Prod. Order Line"): Boolean
    var
        lApplyProdOrderLineSeq: Report "ecApply Prod. Order Line Seq.";
    begin
        //CS_PRO_018-s
        if pProdOrderLine.IsEmpty then exit(false);

        CheckSelectedPlanningLines(pProdOrderLine);

        Commit();
        lApplyProdOrderLineSeq.SetProdOrderLines(pProdOrderLine);
        lApplyProdOrderLineSeq.RunModal();

        exit(lApplyProdOrderLineSeq.GetSequenceApplied());
        //CS_PRO_018-e
    end;

    internal procedure GetNewProdOrderLineRescheduledDates(var pProdOrderLine: Record "Prod. Order Line"; var pNewStartingDateTime: DateTime; var pNewEndingDateTime: DateTime; var pNewDueDate: Date)
    var
        lSourceProductionOrder: Record "Production Order";
        lNewProductionOrder: Record "Production Order";
        lNewProdOrderLine: Record "Prod. Order Line";
        lNewProdOrderNo: Code[20];
        lNewStartingDateTime: DateTime;
        lNewEndingDateTime: DateTime;
    begin
        //CS_PRO_018-s
        lNewStartingDateTime := pNewStartingDateTime;
        lNewEndingDateTime := pNewEndingDateTime;
        pNewStartingDateTime := 0DT;
        pNewEndingDateTime := 0DT;

        if (pProdOrderLine."Prod. Order No." = '') or (pProdOrderLine."Line No." = 0) then exit;
        if (pNewStartingDateTime <> 0DT) and (pNewEndingDateTime <> 0DT) then exit;
        lSourceProductionOrder.Get(pProdOrderLine.Status, pProdOrderLine."Prod. Order No.");
        lNewProdOrderNo := CreateTempProdOrderNo();
        if not CloneProductionOrder(lSourceProductionOrder, lNewProdOrderNo, Enum::"Production Order Status"::Simulated) then exit;
        lNewProductionOrder.Get(lNewProductionOrder.Status::Simulated, lNewProdOrderNo);
        lNewProdOrderLine.Get(lNewProductionOrder.Status, lNewProductionOrder."No.", pProdOrderLine."Line No.");
        //Se inserita la starting date calcolo la riga validando la nuova data inizio e ritorno la data fine calcolata        
        if (lNewStartingDateTime <> 0DT) then begin
            lNewProdOrderLine.Validate("Starting Date-Time", lNewStartingDateTime);
            pNewEndingDateTime := lNewProdOrderLine."Ending Date-Time";
        end else begin
            //Se inserita la ending date calcolo la riga validando la nuova data fine e ritorno la data inizio calcolata
            lNewProdOrderLine.Validate("Ending Date-Time", lNewEndingDateTime);
            pNewStartingDateTime := lNewProdOrderLine."Starting Date-Time";
        end;
        pNewDueDate := lNewProdOrderLine."Due Date";

        //Elimino l'odp temporaneo precedentemente creato
        lNewProductionOrder.Delete(true);
        //CS_PRO_018-e
    end;

    #endregion CS_PRO_018 - Gestione dei Piani di Produzione e calendari sostitutivi per Aree e Centri

    #region CS_PRO_035 - Registrazione consumi ODP per differenza tra quantità prelevata e resa

    internal procedure AutomaticConsumptionProposal(var pItemJournalLine: Record "Item Journal Line")
    var
        Temp_lItemJournalLine: Record "Item Journal Line" temporary;
    begin
        //CS_PRO_035-s
        if pItemJournalLine.IsEmpty then exit;

        pItemJournalLine.SetRange("Entry Type", pItemJournalLine."Entry Type"::Consumption);
        if pItemJournalLine.IsEmpty then exit;

        ClearLogUnitAttributesOnItemJnlLine(pItemJournalLine);
        GroupItemJnlLineForAutomConsumpProposal(pItemJournalLine, Temp_lItemJournalLine);

        pItemJournalLine.FindSet();
        repeat
            ManageAutomaticConsumpForItemJnlLine(pItemJournalLine, Temp_lItemJournalLine);
        until (pItemJournalLine.Next() = 0);
        //CS_PRO_035-e
    end;

    internal procedure ManageAutomaticConsumpForItemJnlLine(var pItemJournalLine: Record "Item Journal Line"; var Temp_pGroupedItemJnlLine: Record "Item Journal Line"): Boolean
    var
        lAWPItemInventoryBuffer: Record "AltAWPItem Inventory Buffer";
        lAWPLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
        lPalletNo: Code[50];
        lBoxNo: Code[50];
        lLotNo: Code[50];
        lExpirationDate: Date;
        lRecordModified: Boolean;
    begin
        //CS_PRO_035-s
        Clear(Temp_pGroupedItemJnlLine);
        Temp_pGroupedItemJnlLine.SetRange("Item No.", pItemJournalLine."Item No.");
        Temp_pGroupedItemJnlLine.SetRange("Variant Code", pItemJournalLine."Variant Code");
        Temp_pGroupedItemJnlLine.SetFilter("Location Code", '%1 & <>%2', pItemJournalLine."Location Code", '');
        Temp_pGroupedItemJnlLine.SetFilter("Bin Code", '%1 & <>%2', pItemJournalLine."Bin Code", '');
        if not Temp_pGroupedItemJnlLine.IsEmpty then begin
            Temp_pGroupedItemJnlLine.FindFirst();

            lPalletNo := '';
            lBoxNo := '';
            lLotNo := '';

            lAWPLogisticUnitsMgt.FindOpenWhseEntries(Temp_pGroupedItemJnlLine."Item No.", Temp_pGroupedItemJnlLine."Variant Code", Temp_pGroupedItemJnlLine."Location Code",
                                                     Temp_pGroupedItemJnlLine."Bin Code", '', '', '', '', false, lAWPItemInventoryBuffer);
            if lAWPItemInventoryBuffer.FindFirst() and (lAWPItemInventoryBuffer.Count = 1)
            // and (lAWPItemInventoryBuffer."Quantity (Base)" >= Temp_pGroupedItemJnlLine."Quantity (Base)")  //Propongo anche se la quantità è minore di quella necessaria
            then begin
                lPalletNo := lAWPItemInventoryBuffer."Pallet No.";
                lBoxNo := lAWPItemInventoryBuffer."Box No.";
                lLotNo := lAWPItemInventoryBuffer."Lot No.";
                lExpirationDate := lAWPItemInventoryBuffer."Expiration Date";
            end else begin
                if not lAWPItemInventoryBuffer.IsEmpty then begin
                    lAWPItemInventoryBuffer.CalcSums("Quantity (Base)");
                    //if (lAWPItemInventoryBuffer."Quantity (Base)" >= Temp_pGroupedItemJnlLine."Quantity (Base)") then begin  //Propongo anche se la quantità è minore di quella necessaria
                    GetUniqueLogisticAttributes(Temp_pGroupedItemJnlLine, lPalletNo, lBoxNo, lLotNo, lExpirationDate);
                    //end;
                end;
            end;

            lRecordModified := false;
            if (pItemJournalLine."AltAWPPallet No." <> lPalletNo) and (lPalletNo <> '') then begin
                pItemJournalLine.Validate("AltAWPPallet No.", lPalletNo);
                lRecordModified := true;
            end;
            if (pItemJournalLine."AltAWPBox No." <> lBoxNo) and (lBoxNo <> '') then begin
                pItemJournalLine.Validate("AltAWPBox No.", lBoxNo);
                lRecordModified := true;
            end;
            if (pItemJournalLine."AltAWPLot No." <> lLotNo) and (lLotNo <> '') then begin
                pItemJournalLine.Validate("AltAWPLot No.", lLotNo);
                if (lExpirationDate <> 0D) then pItemJournalLine.Validate("AltAWPExpiration Date", lExpirationDate);
                lRecordModified := true;
            end;
            if lRecordModified then pItemJournalLine.Modify(true);
        end;
        //CS_PRO_035-e
    end;

    internal procedure ClearLogUnitAttributesOnItemJnlLine(var pItemJournalLine: Record "Item Journal Line")
    var
        lProdOrderComponent: Record "Prod. Order Component";
        Temp_lATSReservEntryBackup: Record "AltATSReserv. Entry Backup" temporary;
        lReservationFunctions: Codeunit "ecReservation Functions";
        lTransactionRef: Text;
        lRecordModified: Boolean;
    begin
        //CS_PRO_035-s
        //Eseguo la pulizia dei Lotti/Seriali solo se non c'è un impegno sul componente
        if not pItemJournalLine.IsEmpty then begin
            pItemJournalLine.FindSet();
            repeat
                if (lProdOrderComponent.Get(lProdOrderComponent.Status::Released, pItemJournalLine."Prod. Order No.",
                                            pItemJournalLine."Prod. Order Line No.", pItemJournalLine."Prod. Order Comp. Line No."))
                then begin
                    lReservationFunctions.GetProdOrderCompReservations(lProdOrderComponent, Temp_lATSReservEntryBackup, false, lTransactionRef);
                    Clear(Temp_lATSReservEntryBackup);
                    if Temp_lATSReservEntryBackup.IsEmpty then begin
                        lRecordModified := false;
                        if (pItemJournalLine."AltAWPPallet No." <> '') then begin
                            pItemJournalLine.Validate("AltAWPPallet No.", '');
                            lRecordModified := true;
                        end;
                        if (pItemJournalLine."AltAWPBox No." <> '') then begin
                            pItemJournalLine.Validate("AltAWPBox No.", '');
                            lRecordModified := true;
                        end;
                        if (pItemJournalLine."AltAWPLot No." <> '') then begin
                            pItemJournalLine.Validate("AltAWPLot No.", '');
                            lRecordModified := true;
                        end;
                        if (pItemJournalLine."AltAWPSerial No." <> '') then begin
                            pItemJournalLine.Validate("AltAWPSerial No.", '');
                            lRecordModified := true;
                        end;
                        if lRecordModified then pItemJournalLine.Modify(true);
                    end;
                end;
            until (pItemJournalLine.Next() = 0);
        end;
        //CS_PRO_035-e
    end;

    internal procedure GroupItemJnlLineForAutomConsumpProposal(var pItemJournalLine: Record "Item Journal Line";
                                                               var Temp_pItemJournalLine: Record "Item Journal Line" temporary)
    var
        lItem: Record Item;
    begin
        //CS_PRO_035-s
        Clear(Temp_pItemJournalLine);
        Temp_pItemJournalLine.DeleteAll();

        if not pItemJournalLine.IsEmpty then begin
            pItemJournalLine.FindSet();
            repeat
                Temp_pItemJournalLine.SetRange("Item No.", pItemJournalLine."Item No.");
                Temp_pItemJournalLine.SetRange("Variant Code", pItemJournalLine."Variant Code");
                Temp_pItemJournalLine.SetRange("Location Code", pItemJournalLine."Location Code");
                Temp_pItemJournalLine.SetRange("Bin Code", pItemJournalLine."Bin Code");
                if not Temp_pItemJournalLine.IsEmpty then begin
                    Temp_pItemJournalLine.FindFirst();
                    Temp_pItemJournalLine.Validate(Quantity, Temp_pItemJournalLine.Quantity + pItemJournalLine."Quantity (Base)");
                    Temp_pItemJournalLine.Modify(true);
                end else begin
                    lItem.Get(pItemJournalLine."Item No.");
                    Temp_pItemJournalLine := pItemJournalLine;
                    Temp_pItemJournalLine.Validate("Unit of Measure Code", lItem."Base Unit of Measure");
                    Temp_pItemJournalLine.Validate(Quantity, pItemJournalLine."Quantity (Base)");
                    Temp_pItemJournalLine.Insert(true);
                end;
            until (pItemJournalLine.Next() = 0);
        end;
        //CS_PRO_035-e
    end;

    internal procedure GetUniqueLogisticAttributes(var Temp_pItemJournalLine: Record "Item Journal Line" temporary;
                                                   var pPalletNo: Code[50]; var pBoxNo: Code[50]; var pLotNo: Code[50];
                                                   var pExpirationDate: Date)
    var
        lFirstIteration: Boolean;
    begin
        //CS_PRO_035-s
        if Temp_pItemJournalLine.IsEmpty then exit;

        lFirstIteration := true;
        Temp_pItemJournalLine.FindSet();
        repeat
            if not lFirstIteration then begin
                if (pPalletNo <> Temp_pItemJournalLine."AltAWPPallet No.") then pPalletNo := '';
                if (pBoxNo <> Temp_pItemJournalLine."AltAWPBox No.") then pPalletNo := '';
                if (pLotNo <> Temp_pItemJournalLine."AltAWPLot No.") then begin
                    pLotNo := '';
                    pExpirationDate := 0D;
                end;
            end else begin
                pPalletNo := Temp_pItemJournalLine."AltAWPPallet No.";
                pBoxNo := Temp_pItemJournalLine."AltAWPBox No.";
                pLotNo := Temp_pItemJournalLine."AltAWPLot No.";
                pExpirationDate := Temp_pItemJournalLine."Expiration Date";
            end;
        until (Temp_pItemJournalLine.Next() = 0);
        //CS_PRO_035-e
    end;

    internal procedure CalcProdPickWorksheetQtyComponentLines(var Temp_ItemAvailabilityBuffer: Record "AltAWPItem Availability Buffer";
                                                              var pItem: Record Item): Decimal
    var
        lProdOrderLine: Record "Prod. Order Line";
        lProdOrderComponent: Record "Prod. Order Component";
        lQuantity: Decimal;
    begin
        lQuantity := 0;
        Clear(lProdOrderComponent);
        lProdOrderComponent.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Due Date");
        lProdOrderComponent.SetRange(Status, lProdOrderComponent.Status::Released);
        lProdOrderComponent.SetRange("Item No.", pItem."No.");
        lProdOrderComponent.SetFilter("Variant Code", pItem."Variant Filter");
        lProdOrderComponent.SetFilter("Location Code", pItem."Location Filter");
        lProdOrderComponent.SetFilter("Due Date", Format(pItem."Date Filter"));
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindSet();
            repeat
                lProdOrderLine.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.", lProdOrderComponent."Prod. Order Line No.");
                if (lProdOrderLine."ecProductive Status" in [lProdOrderLine."ecProductive Status"::Activated,
                                                             lProdOrderLine."ecProductive Status"::Scheduled])
                then begin
                    lQuantity += lProdOrderComponent."Remaining Qty. (Base)";
                end;
            until (lProdOrderComponent.Next() = 0);
        end;

        Temp_ItemAvailabilityBuffer."ecQty. on Component Lines" := lQuantity;
    end;

    #endregion CS_PRO_035 - Registrazione consumi ODP per differenza tra quantità prelevata e resa

    #region CS_PRO_039 - Avanzamenti di produzione

    internal procedure UpdateProdOrderLineProductiveStatus(var pProdOrderLine: Record "Prod. Order Line")
    var
        lChangeProdOrdLineStatus: Page "ecChange Prod.Ord. Line Status";
        lNewProductiveStatus: Enum "ecProductive Status";
    begin
        //CS_PRO_039-s
        lChangeProdOrdLineStatus.SetProdOrderLineStatus(pProdOrderLine);
        if (lChangeProdOrdLineStatus.RunModal() = Action::Yes) then begin
            lNewProductiveStatus := lChangeProdOrdLineStatus.GetNewStatus();
            if (lNewProductiveStatus <> pProdOrderLine."ecProductive Status") then begin
                pProdOrderLine.Validate("ecProductive Status", lNewProductiveStatus);
            end;
        end;
        //CS_PRO_039-e
    end;

    internal procedure ManageChangeOfProdStatusOnProdOrdLine(var pProdOrderLine: Record "Prod. Order Line"; pxProdOrderLine: Record "Prod. Order Line")
    var
        lExistItemLedgEntry: Boolean;
        lExistCapacityLedgEntry: Boolean;

        lPreviousStateErr2: Label 'It is not possible to switch to a state less than activated if there are posted entries!';
    begin
        //CS_PRO_039-s
        if (pProdOrderLine."ecProductive Status" = pxProdOrderLine."ecProductive Status") then exit;

        if (pProdOrderLine."ecProductive Status".AsInteger() < pxProdOrderLine."ecProductive Status".AsInteger()) and
           (pxProdOrderLine."ecProductive Status" = pxProdOrderLine."ecProductive Status"::Suspended) and
           (pProdOrderLine."ecProductive Status".AsInteger() < pProdOrderLine."ecProductive Status"::Activated.AsInteger())
        then begin
            ExistsEntriesForProdOrderLine(pProdOrderLine, lExistItemLedgEntry, lExistCapacityLedgEntry);
            if lExistItemLedgEntry or lExistCapacityLedgEntry then begin
                Error(lPreviousStateErr2);
            end;
        end;

        case pProdOrderLine."ecProductive Status" of
            pProdOrderLine."ecProductive Status"::Scheduled:
                begin
                end;
            pProdOrderLine."ecProductive Status"::Released:
                begin
                end;
            pProdOrderLine."ecProductive Status"::Activated:
                begin
                    ManageActivatedProductiveStatus(pProdOrderLine);
                end;
            pProdOrderLine."ecProductive Status"::Suspended:
                begin
                end;
            pProdOrderLine."ecProductive Status"::Completed:
                begin
                    ManageCompletedProductiveStatus(pProdOrderLine);
                end;
        end;
        //CS_PRO_039-e
    end;

    local procedure ManageActivatedProductiveStatus(var pProdOrderLine: Record "Prod. Order Line")
    var
        lGeneralSetup: Record "ecGeneral Setup";
        lTrackingFunctions: Codeunit "ecTracking Functions";
    begin
        //CS_PRO_039-s
        //Generazione automatica dei nr. lotto per la riga di ODP corrente se non presente
        if (pProdOrderLine."ecOutput Lot No." = '') then begin
            lTrackingFunctions.CreateAndUpdLotNoForProdOrderLine(pProdOrderLine, false);
        end;

        //Generazione automatica dei nr. lotto per tutte le altre righe ODP se non presente 
        AssignLotNoToOtherProdOrderLines(pProdOrderLine);

        //Generazione automatica dei prelievi
        lGeneralSetup.Get();
        if (lGeneralSetup."Pick On Reserved Bin" = lGeneralSetup."Pick On Reserved Bin"::"Automatic on activation") then begin
            CalcAndCreateWhsePickPutAwayActivity(pProdOrderLine, Enum::"AltAWPProd. Pick Wksh Activity"::Pick);
        end;
        //CS_PRO_039-e
    end;

    local procedure ManageCompletedProductiveStatus(var pProdOrderLine: Record "Prod. Order Line")
    var
        lECGeneralSetup: Record "ecGeneral Setup";
    begin
        //CS_PRO_039-s
        lECGeneralSetup.Get();
        CheckConsumptionAndTimeProportionateToOutput(pProdOrderLine, lECGeneralSetup."Min. Time Control Type", lECGeneralSetup."Check Setup Time",
                                                     lECGeneralSetup."Min. Consumption Control Type");
        //CS_PRO_039-e
    end;

    internal procedure CheckProductiveStatusBeforePostItemJnlLine(var pItemJnlLine: Record "Item Journal Line"; pWithError: Boolean): Boolean
    var
        lProdOrderLine: Record "Prod. Order Line";
        lIsHandled: Boolean;

        lError001: Label 'Is not possible to post consumption or output for Prod. Order: "%1" - Line No.: "%2" because its productive status is different from "%3"!';
    begin
        //CS_PRO_039-s
        OnBeforeCheckProductiveStatusBeforePostItemJnlLine(pItemJnlLine, lIsHandled);
        if lIsHandled then exit(true);

        exit(true);

        //#TODO#-s
        if not (pItemJnlLine."Entry Type" in [pItemJnlLine."Entry Type"::Consumption, pItemJnlLine."Entry Type"::Output]) or
               (pItemJnlLine."Order Type" <> pItemJnlLine."Order Type"::Production) then begin
            exit(true);
        end;

        if lProdOrderLine.Get(lProdOrderLine.Status::Released, pItemJnlLine."Order No.", pItemJnlLine."Order Line No.") then begin
            if (lProdOrderLine."ecProductive Status" <> lProdOrderLine."ecProductive Status"::Activated) then begin
                if not pWithError then exit(false);

                Error(lError001, lProdOrderLine."Prod. Order No.", lProdOrderLine."Line No.", Format(lProdOrderLine."ecProductive Status"::Activated));
            end;
        end;
        exit(true);
        //#TODO#-e
        //CS_PRO_039-e
    end;

    internal procedure CheckProdOrderChangeStatus(var pProductionOrder: Record "Production Order";
                                                  pNewStatus: Option Quote,Planned,"Firm Planned",Released,Finished; pWithError: Boolean): Boolean
    var
        lProdOrderLine: Record "Prod. Order Line";

        lError001: Label 'Is not possible to close Prod. Order: "%1" if there are lines with productve status different from "%2"!';
    begin
        //CS_PRO_039-s
        if (pProductionOrder.Status = pProductionOrder.Status::Released) and (pNewStatus = pNewStatus::Finished) then begin
            Clear(lProdOrderLine);
            lProdOrderLine.SetRange(Status, pProductionOrder.Status);
            lProdOrderLine.SetRange("Prod. Order No.", pProductionOrder."No.");
            lProdOrderLine.SetFilter("ecProductive Status", '<>%1', lProdOrderLine."ecProductive Status"::Completed);
            if not lProdOrderLine.IsEmpty then begin
                if not pWithError then exit(false);

                Error(lError001, pProductionOrder."No.", Format(lProdOrderLine."ecProductive Status"::Completed));
            end;
        end;
        //CS_PRO_039-e
    end;

    local procedure CheckConsumptionAndTimeProportionateToOutput(var pProdOrderLine: Record "Prod. Order Line"; pCheckTime: Enum "ecProd. Ord. Line Control Type"; pCheckSetupTime: Boolean;
                                                                 pCheckConsumption: Enum "ecProd. Ord. Line Control Type"): Boolean
    var
        lECGeneralSetup: Record "ecGeneral Setup";
        lProductionOrder: Record "Production Order";
        lItemJournalLine: Record "Item Journal Line";
        lItemJournalLine2: Record "Item Journal Line";
        lProdOrderComponent: Record "Prod. Order Component";
        lProdOrderRoutingLine: Record "Prod. Order Routing Line";
        Temp_lItemJournalLine: Record "Item Journal Line" temporary;
        lProductionJournalMgt: Codeunit "Production Journal Mgt";
        lErrorText: Text;
        lToBatchName: Code[10];
        lToTemplateName: Code[10];
        lTimePosted: Decimal;
        lTimeNotPosted: Decimal;
        lMinTimeDeclarable: Decimal;
        lExpectedQtyToConsume: Decimal;
        lMinQuantityToConsume: Decimal;
        lExistError: Boolean;
        lIsConsumption: Boolean;
        lOutputIncorrect: Boolean;
        lNotCompletedRunTimes: Boolean;
        lNotCompletedSetupTimes: Boolean;
        lNotCompletedConsumptions: Boolean;

        lProdOrderErrMsg: Label 'For Prod. Order: "%1" - Line No.: %2 the following errors were detected: ';
        lNotValidConsumpMsg: Label '\- Value of field "%1" is not valid --> Example: %2 = %3 - declared value (%4), minimum declarable value (%5) ';
        lMissingOutputMsg: Label '\- Missing output for %1 = %2 ';
    begin
        //CS_PRO_039-s
        lECGeneralSetup.Get();
        Clear(Temp_lItemJournalLine);
        Temp_lItemJournalLine.DeleteAll();

        Clear(lProductionJournalMgt);
        lProductionOrder.Get(pProdOrderLine.Status, pProdOrderLine."Prod. Order No.");
        lProductionJournalMgt.SetTemplateAndBatchName();
        lProductionJournalMgt.GetJnlTemplateAndBatchName(lToTemplateName, lToBatchName);
        lProductionJournalMgt.InitSetupValues();
        lProductionJournalMgt.DeleteJnlLines(lToTemplateName, lToBatchName, pProdOrderLine."Prod. Order No.", pProdOrderLine."Line No.");
        lProductionJournalMgt.CreateJnlLines(lProductionOrder, pProdOrderLine."Line No.");

        lOutputIncorrect := false;
        lNotCompletedRunTimes := false;
        lNotCompletedSetupTimes := false;
        lNotCompletedConsumptions := false;
        lErrorText := StrSubstNo(lProdOrderErrMsg, pProdOrderLine."Prod. Order No.", pProdOrderLine."Line No.");

        Clear(lItemJournalLine);
        lItemJournalLine.SetRange("Journal Template Name", lToTemplateName);
        lItemJournalLine.SetRange("Journal Batch Name", lToBatchName);
        lItemJournalLine.SetRange("Order Type", lItemJournalLine."Order Type"::Production);
        lItemJournalLine.SetRange("Order No.", pProdOrderLine."Prod. Order No.");
        lItemJournalLine.SetRange("Order Line No.", pProdOrderLine."Line No.");
        lItemJournalLine.SetRange("Entry Type", lItemJournalLine."Entry Type"::Output);
        if not lItemJournalLine.IsEmpty then begin
            lItemJournalLine.FindSet();
            repeat
                if lProdOrderRoutingLine.Get(lProdOrderRoutingLine.Status::Released,
                                             lItemJournalLine."Order No.",
                                             lItemJournalLine."Routing Reference No.",
                                             lItemJournalLine."Routing No.",
                                             lItemJournalLine."Operation No.") and
                   (lProdOrderRoutingLine."Routing Link Code" <> '')
                then begin
                    //Controllo dei tempi e output dichiarati sull'operazione
                    if (lItemJournalLine."AltAWPPosted Quantity" <> 0) then begin
                        lItemJournalLine.Validate("Output Quantity", 0);

                        //Controllo Run Time
                        GetPostedAndNotPostedTimeByProdOrderRtngLine(lProdOrderRoutingLine, Enum::"Routing Time Type"::"Run Time", lTimePosted, lTimeNotPosted);
                        lMinTimeDeclarable := lTimePosted + lTimeNotPosted - (((lTimePosted + lTimeNotPosted) / 100) * lECGeneralSetup."Min. Time Tolerance %");
                        if (lMinTimeDeclarable > lTimePosted) then begin
                            lNotCompletedRunTimes := true;
                            lErrorText += StrSubstNo(lNotValidConsumpMsg, lItemJournalLine.FieldCaption("Run Time"), Format(lItemJournalLine.Type), lItemJournalLine."No.", lTimePosted, lMinTimeDeclarable);
                        end;
                        //Controllo Setup Time
                        if pCheckSetupTime then begin
                            GetPostedAndNotPostedTimeByProdOrderRtngLine(lProdOrderRoutingLine, Enum::"Routing Time Type"::"Setup Time", lTimePosted, lTimeNotPosted);
                            lMinTimeDeclarable := lTimePosted + lTimeNotPosted - ((lTimePosted + lTimeNotPosted / 100) * lECGeneralSetup."Min. Time Tolerance %");
                            if (lMinTimeDeclarable > lTimePosted) then begin
                                lNotCompletedSetupTimes := true;
                                lErrorText += StrSubstNo(lNotValidConsumpMsg, lItemJournalLine.FieldCaption("Setup Time"), Format(lItemJournalLine.Type), lItemJournalLine."No.", lTimePosted, lMinTimeDeclarable);
                            end;
                        end;
                    end else begin
                        lOutputIncorrect := true;
                        lErrorText += StrSubstNo(lMissingOutputMsg, Format(lItemJournalLine.Type), lItemJournalLine.Description);
                    end;

                    lExistError := (lNotCompletedRunTimes or lNotCompletedSetupTimes or lOutputIncorrect);
                    if (pCheckTime <> pCheckConsumption) then begin
                        if (pCheckTime = pCheckTime::Error) and lExistError then Error(lErrorText);
                        if (pCheckTime = pCheckTime::Warning) and lExistError then begin
                            Message(lErrorText);
                            lErrorText := StrSubstNo(lProdOrderErrMsg, pProdOrderLine."Prod. Order No.", pProdOrderLine."Line No.");
                        end;
                    end;

                    if (lItemJournalLine."Output Quantity" <> 0) then begin
                        lItemJournalLine.Validate("Output Quantity", 0);
                        lItemJournalLine.Modify(true);
                    end;

                    //Controllo consumi dei componenti collegati alla riga di ciclo
                    Clear(lItemJournalLine2);
                    lItemJournalLine2.SetRange("Journal Template Name", lItemJournalLine."Journal Template Name");
                    lItemJournalLine2.SetRange("Journal Batch Name", lItemJournalLine."Journal Batch Name");
                    lItemJournalLine2.SetRange("Order Type", lItemJournalLine."Order Type");
                    lItemJournalLine2.SetRange("Order No.", lItemJournalLine."Order No.");
                    lItemJournalLine2.SetRange("Order Line No.", lItemJournalLine."Order Line No.");
                    lItemJournalLine2.SetFilter("Line No.", '>%1', lItemJournalLine."Line No.");
                    if not lItemJournalLine2.IsEmpty then begin
                        lItemJournalLine2.FindSet();
                        repeat
                            if (lItemJournalLine2."Entry Type" = lItemJournalLine2."Entry Type"::Consumption) and
                               (lItemJournalLine2."Flushing Method" = lItemJournalLine2."Flushing Method"::Manual) and
                                lProdOrderComponent.Get(lProdOrderComponent.Status::Released, lItemJournalLine2."Order No.",
                                                        lItemJournalLine2."Order Line No.", lItemJournalLine2."Prod. Order Comp. Line No.") and
                                (lProdOrderComponent."Routing Link Code" = lProdOrderRoutingLine."Routing Link Code")
                            then begin
                                if (lItemJournalLine2.Quantity <> 0) then begin
                                    lExpectedQtyToConsume := lItemJournalLine2.Quantity + lItemJournalLine2."AltAWPPosted Quantity";
                                    lMinQuantityToConsume := lExpectedQtyToConsume - ((lExpectedQtyToConsume / 100) * lECGeneralSetup."Min. Consumption Tolerance %");
                                    if (lMinQuantityToConsume > lItemJournalLine2."AltAWPPosted Quantity") then begin
                                        lNotCompletedConsumptions := true;
                                        lErrorText += StrSubstNo(lNotValidConsumpMsg, lItemJournalLine2.FieldCaption("AltAWPPosted Quantity"), lItemJournalLine2.FieldCaption("Item No."),
                                                                 lItemJournalLine2."Item No.", lItemJournalLine2."AltAWPPosted Quantity", lMinQuantityToConsume);
                                    end;
                                end;
                            end;

                            lIsConsumption := lItemJournalLine2."Entry Type" = lItemJournalLine2."Entry Type"::Consumption;
                        until (lItemJournalLine2.Next() = 0) or (not lIsConsumption) or (lNotCompletedConsumptions);
                    end;
                end;
            until (lItemJournalLine.Next() = 0);
        end;

        /*
        if lRoutingIncorrect then begin
            Message(lMessage001, pProdOrderLine."Prod. Order No.", pProdOrderLine."Line No.");
        end;
        */

        lExistError := lExistError or lNotCompletedConsumptions;
        if (pCheckConsumption <> pCheckConsumption::None) and (pCheckConsumption <> pCheckTime) then begin
            if (pCheckConsumption = pCheckTime::Error) and lNotCompletedConsumptions then Error(lErrorText);
            if (pCheckConsumption = pCheckTime::Warning) and lNotCompletedConsumptions then Message(lErrorText);
        end else begin
            if (pCheckConsumption <> pCheckConsumption::None) and (pCheckConsumption = pCheckTime) and lExistError then begin
                if (pCheckConsumption = pCheckTime::Error) then Error(lErrorText);
                if (pCheckConsumption = pCheckTime::Warning) then Message(lErrorText);
            end;
        end;

        lProductionJournalMgt.DeleteJnlLines(lToTemplateName, lToBatchName, pProdOrderLine."Prod. Order No.", pProdOrderLine."Line No.");
        exit(not lExistError);
        //CS_PRO_039-e
    end;

    local procedure GetPostedAndNotPostedTimeByProdOrderRtngLine(pProdOrderRoutingLine: Record "Prod. Order Routing Line"; pTimeType: Enum Microsoft.Manufacturing.Routing."Routing Time Type";
                                                                 var pPostedTime: Decimal; var pNotPostedTime: Decimal)
    var
        lProdOrderCapacityNeed: Record "Prod. Order Capacity Need";
    begin
        //CS_PRO_039-s
        pPostedTime := 0;
        pNotPostedTime := 0;
        Clear(lProdOrderCapacityNeed);
        lProdOrderCapacityNeed.SetCurrentKey(Type, "No.", "Starting Date-Time");
        lProdOrderCapacityNeed.SetRange(Type, pProdOrderRoutingLine.Type);
        lProdOrderCapacityNeed.SetRange("No.", pProdOrderRoutingLine."No.");
        lProdOrderCapacityNeed.SetRange(Date, pProdOrderRoutingLine."Starting Date", pProdOrderRoutingLine."Ending Date");
        lProdOrderCapacityNeed.SetRange("Prod. Order No.", pProdOrderRoutingLine."Prod. Order No.");
        lProdOrderCapacityNeed.SetRange(Status, pProdOrderRoutingLine.Status);
        lProdOrderCapacityNeed.SetRange("Routing Reference No.", pProdOrderRoutingLine."Routing Reference No.");
        lProdOrderCapacityNeed.SetRange("Operation No.", pProdOrderRoutingLine."Operation No.");
        lProdOrderCapacityNeed.SetRange("Time Type", pTimeType);
        if not lProdOrderCapacityNeed.IsEmpty then begin
            lProdOrderCapacityNeed.FindSet();
            repeat
                pPostedTime += lProdOrderCapacityNeed."Needed Time" - lProdOrderCapacityNeed."Allocated Time";
                pNotPostedTime += lProdOrderCapacityNeed."Allocated Time";
            until (lProdOrderCapacityNeed.Next() = 0);
        end;
        //CS_PRO_039-s
    end;

    internal procedure UpdateProdOrdLinePrevalentOperation(var pProdOrderLine: Record "Prod. Order Line")
    var
        lProdOrderRoutingLine: Record "Prod. Order Routing Line";
    begin
        //CS_PRO_039-s
        if (pProdOrderLine."Prod. Order No." = '') then exit;
        Clear(lProdOrderRoutingLine);
        lProdOrderRoutingLine.SetRange(Status, pProdOrderLine.Status);
        lProdOrderRoutingLine.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        lProdOrderRoutingLine.SetRange("Routing Reference No.", pProdOrderLine."Routing Reference No.");
        lProdOrderRoutingLine.SetRange("Routing No.", pProdOrderLine."Routing No.");
        if not lProdOrderRoutingLine.IsEmpty then begin
            lProdOrderRoutingLine.FindLast();
            if (pProdOrderLine."ecPrevalent Operation Type" <> lProdOrderRoutingLine.Type) or
               (pProdOrderLine."ecPrevalent Operation No." <> lProdOrderRoutingLine."No.")
            then begin
                pProdOrderLine."ecPrevalent Operation Type" := Enum::"ecPrevalent Operation Type".FromInteger(lProdOrderRoutingLine.Type.AsInteger() + 1);
                pProdOrderLine."ecPrevalent Operation No." := lProdOrderRoutingLine."No.";
                pProdOrderLine.Modify(false);
            end;
        end else begin
            pProdOrderLine."ecPrevalent Operation Type" := pProdOrderLine."ecPrevalent Operation Type"::" ";
            pProdOrderLine."ecPrevalent Operation No." := '';
            pProdOrderLine.Modify(false);
        end;
        //CS_PRO_039-e
    end;

    internal procedure UpdateProdOrdLinePackagingFields(var pProdOrderLine: Record "Prod. Order Line")
    var
        lItem: Record Item;
        lProdOrderComponent: Record "Prod. Order Component";
        lPackagingUpdated: Boolean;
    begin
        //CS_PRO_039-s
        if (pProdOrderLine."Prod. Order No." = '') then exit;

        lPackagingUpdated := false;
        Clear(lProdOrderComponent);
        lProdOrderComponent.SetRange(Status, pProdOrderLine.Status);
        lProdOrderComponent.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        lProdOrderComponent.SetRange("Prod. Order Line No.", pProdOrderLine."Line No.");
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindSet();
            repeat
                lItem.Get(lProdOrderComponent."Item No.");
                if (lItem."ecItem Type" = lItem."ecItem Type"::"Film Packaging") then begin
                    if (pProdOrderLine."ecFilm Packaging Code" <> lItem."No.") then begin
                        pProdOrderLine.Validate("ecFilm Packaging Code", lItem."No.");
                        lPackagingUpdated := true;
                    end;
                end;
                if (lItem."ecItem Type" = lItem."ecItem Type"::"Carton Packaging") then begin
                    if (pProdOrderLine."ecCartons Packaging Code" <> lItem."No.") then begin
                        pProdOrderLine.Validate("ecCartons Packaging Code", lItem."No.");
                        lPackagingUpdated := true;
                    end;
                end;
            until (lProdOrderComponent.Next() = 0);

            if lPackagingUpdated then pProdOrderLine.Modify(false);
        end;
        //CS_PRO_039-e
    end;

    internal procedure BackupProdOrderLine(pSourceProdOrder: Record "Production Order"; var Temp_pProdOrderLineBK: Record "Prod. Order Line")
    var
        lProdOrderLine: Record "Prod. Order Line";
    begin
        //CS_PRO_039-s
        if (pSourceProdOrder.Status = pSourceProdOrder.Status::Released) then begin
            Clear(Temp_pProdOrderLineBK);
            Temp_pProdOrderLineBK.DeleteAll();

            Clear(lProdOrderLine);
            lProdOrderLine.SetRange(Status, pSourceProdOrder.Status);
            lProdOrderLine.SetRange("Prod. Order No.", pSourceProdOrder."No.");
            if not lProdOrderLine.IsEmpty then begin
                lProdOrderLine.FindSet();
                repeat
                    Temp_pProdOrderLineBK := lProdOrderLine;
                    Temp_pProdOrderLineBK.Insert(false);
                until (lProdOrderLine.Next() = 0);
            end;
        end;
        //CS_PRO_039-e
    end;

    internal procedure RestoreFieldsFromProdOrderLineBK(pSourceProdOrder: Record "Production Order"; var Temp_pProdOrderLineBK: Record "Prod. Order Line")
    var
        lProdOrderLine: Record "Prod. Order Line";
    begin
        //CS_PRO_039-s
        Clear(lProdOrderLine);
        Clear(Temp_pProdOrderLineBK);
        if (pSourceProdOrder.Status = pSourceProdOrder.Status::Released) then begin
            lProdOrderLine.SetRange(Status, pSourceProdOrder.Status);
            lProdOrderLine.SetRange("Prod. Order No.", pSourceProdOrder."No.");
            if not Temp_pProdOrderLineBK.IsEmpty and not lProdOrderLine.IsEmpty then begin
                lProdOrderLine.FindSet();
                repeat
                    if Temp_pProdOrderLineBK.Get(lProdOrderLine.Status, lProdOrderLine."Prod. Order No.", lProdOrderLine."Line No.") then begin
                        if (Temp_pProdOrderLineBK."ecOutput Lot No." <> '') then begin
                            lProdOrderLine."ecOutput Lot No." := Temp_pProdOrderLineBK."ecOutput Lot No.";
                        end;
                        if (Temp_pProdOrderLineBK."ecOutput Lot Exp. Date" <> 0D) then begin
                            lProdOrderLine."ecOutput Lot Exp. Date" := Temp_pProdOrderLineBK."ecOutput Lot Exp. Date";
                        end;
                        if (Temp_pProdOrderLineBK."ecOutput Lot Ref. Date" <> 0D) then begin
                            lProdOrderLine."ecOutput Lot Ref. Date" := Temp_pProdOrderLineBK."ecOutput Lot Ref. Date";
                        end;
                        //GAP_PRO_013-s
                        if (Temp_pProdOrderLineBK."ecProduction Notes" <> '') then begin
                            lProdOrderLine."ecProduction Notes" := Temp_pProdOrderLineBK."ecProduction Notes";
                        end;
                        if (Temp_pProdOrderLineBK."ecPlanning Notes" <> '') then begin
                            lProdOrderLine."ecPlanning Notes" := Temp_pProdOrderLineBK."ecPlanning Notes";
                        end;
                        //GAP_PRO_013-e
                        lProdOrderLine."ecProductive Status" := Temp_pProdOrderLineBK."ecProductive Status";
                        lProdOrderLine.Modify(false);
                    end;
                until (lProdOrderLine.Next() = 0);
            end;
        end;
        //CS_PRO_039-e
    end;

    local procedure CalcAndCreateWhsePickPutAwayActivity(var pProdOrderLine: Record "Prod. Order Line"; pActivityType: Enum "AltAWPProd. Pick Wksh Activity")
    var
        lAWPGeneralSetup: Record "AltAWPGeneral Setup";
        lProductionPickingWksh: Record "AltAWPProduction Picking Wksh";
        lawpCarryOutProdPickWksh: Report "AltAWPCarryOut Prod. Pick Wksh";
        lAWPProductionFunctions: Codeunit "AltAWPProduction Functions";
        lBatchName: Code[50];

        lBatchDescriptionLbl: Label 'Production Order %1 Line %2';
    begin
        //CS_PRO_039-s
        // Creo il batch
        lBatchName := StrSubstNo('%1#%2', pProdOrderLine."Prod. Order No.", pProdOrderLine."Line No.");

        if not lProductionPickingWksh.Get(lBatchName, lProductionPickingWksh."Record Type"::Batch, 0) then begin
            lProductionPickingWksh.Init();
            lProductionPickingWksh."Batch Name" := lBatchName;
            lProductionPickingWksh."Record Type" := lProductionPickingWksh."Record Type"::Batch;
            lProductionPickingWksh."Line No." := 0;
            lProductionPickingWksh.Description := StrSubstNo(lBatchDescriptionLbl, pProdOrderLine."Prod. Order No.", pProdOrderLine."Line No.");
            lProductionPickingWksh."Single Prod. Order Batch" := true;
            lProductionPickingWksh.Insert(false);
        end;

        // Elimino le righe presenti
        lProductionPickingWksh.Reset();
        lProductionPickingWksh.SetRange("Batch Name", lBatchName);
        lProductionPickingWksh.SetRange("Record Type", lProductionPickingWksh."Record Type"::Line);
        if not lProductionPickingWksh.IsEmpty then begin
            lProductionPickingWksh.DeleteAll(true);
        end;

        // Calcolo proposte di prelievo/stoccaggio
        lAWPGeneralSetup.Get();
        if (lAWPGeneralSetup."Picking Wksh by Prod. Order" = lAWPGeneralSetup."Picking Wksh by Prod. Order"::"Only Reserved Bins") then begin
            lAWPProductionFunctions.CalculateProdOrderLinePickingWorksheet(pProdOrderLine, lBatchName, pActivityType, true, false);
        end else begin
            lAWPProductionFunctions.CalculateProdOrderLinePickingWorksheet(pProdOrderLine, lBatchName, pActivityType, false, false);
        end;

        lProductionPickingWksh.Reset();
        lProductionPickingWksh.SetRange("Batch Name", lBatchName);
        lProductionPickingWksh.SetRange("Record Type", lProductionPickingWksh."Record Type"::Line);
        if lProductionPickingWksh.IsEmpty then exit;
        lProductionPickingWksh.ModifyAll("Accept Action Message", true, true);
        Commit();

        // Eseguo i messaggi d'azione sulle righe generate        
        Clear(lawpCarryOutProdPickWksh);
        lawpCarryOutProdPickWksh.UseRequestPage(false);
        lawpCarryOutProdPickWksh.SetHideDialogs(true);
        lawpCarryOutProdPickWksh.SetWorksheetBatchName(lBatchName);
        lawpCarryOutProdPickWksh.SetPickingOptions(Enum::"AltAWPProd. Pick Wksh Pick Act"::"Create Warehouse Activity", '', '');
        lawpCarryOutProdPickWksh.RunModal();

        // Eliminazione del prospetto
        lProductionPickingWksh.Get(lBatchName, lProductionPickingWksh."Record Type"::Batch, 0);
        lProductionPickingWksh.Delete(true);
        //CS_PRO_039-e
    end;

    local procedure AssignLotNoToOtherProdOrderLines(var pProdOrderLine: Record "Prod. Order Line")
    var
        lProdOrderLine: Record "Prod. Order Line";
        lTrackingFunctions: Codeunit "ecTracking Functions";
    begin
        Clear(lProdOrderLine);
        lProdOrderLine.SetRange(Status, pProdOrderLine.Status);
        lProdOrderLine.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        lProdOrderLine.SetFilter("Line No.", '<>%1', pProdOrderLine."Line No.");
        if not lProdOrderLine.IsEmpty then begin
            lProdOrderLine.FindSet();
            repeat
                if (lProdOrderLine."ecOutput Lot No." = '') then begin
                    if lTrackingFunctions.CreateAndUpdLotNoForProdOrderLine(lProdOrderLine, false) then begin
                        lProdOrderLine.Modify(true);
                    end;
                end;
            until (lProdOrderLine.Next() = 0);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckProductiveStatusBeforePostItemJnlLine(var pItemJnlLine: Record "Item Journal Line"; var pIsHandled: Boolean)
    begin
    end;

    #endregion CS_PRO_039 - Avanzamenti di produzione

    #region CS_PRO_041_BIS - Gestione by product

    internal procedure CheckProdBOMLineByProductComp(pProductionBOMHeader: Record "Production BOM Header"; pVersionCode: Code[20])
    var
        lItem: Record Item;
        lProductionBOMLine: Record "Production BOM Line";
        lByProdItemNo: Code[20];

        lNotByProdItemErr: Label 'It is possible to insert lines with negative consumption only for components of type "%1"!';
        lManyByProdItemInBOMErr: Label 'In production BOM it is possible to define only one Item "By product"!';
    begin
        //CS_PRO_041_BIS-s
        lByProdItemNo := '';
        Clear(lProductionBOMLine);
        lProductionBOMLine.SetRange("Production BOM No.", pProductionBOMHeader."No.");
        lProductionBOMLine.SetRange("Version Code", pVersionCode);
        lProductionBOMLine.SetRange(Type, lProductionBOMLine.Type::Item);
        lProductionBOMLine.SetFilter("Quantity per", '< %1', 0);
        if not lProductionBOMLine.IsEmpty then begin
            lProductionBOMLine.FindSet();
            repeat
                if (lByProdItemNo = '') then lByProdItemNo := lProductionBOMLine."No.";
                if (lByProdItemNo <> lProductionBOMLine."No.") then Error(lManyByProdItemInBOMErr);

                lItem.Get(lProductionBOMLine."No.");
                if not lItem."ecBy Product Item" then begin
                    Error(lNotByProdItemErr, lItem.FieldCaption("ecBy Product Item"));
                end;

                CheckByProdRelationsProdBOMLine(pProductionBOMHeader, pVersionCode, lProductionBOMLine."No.", true);
            until (lProductionBOMLine.Next() = 0);
        end;
        //CS_PRO_041_BIS-e
    end;

    local procedure CheckByProdRelationsProdBOMLine(pProductionBOMHeader: Record "Production BOM Header"; pVersionCode: Code[20];
                                                    pByProductItem: Code[20]; pWithError: Boolean): Boolean
    var
        lItemByProd: Record Item;
        lProductionBOMLine: Record "Production BOM Line";
        lItemUnitofMeasure: Record "Item Unit of Measure";
        lByProductItemRelation: Record "ecBy Product Item Relation";
        lUnitofMeasureManagement: Codeunit "Unit of Measure Management";
        lTotalByProdQtyBase: Decimal;
        lTotalRelationCompQtyBase: Decimal;

        lMissingRelationErr: Label 'No relation defined for component by product = "%1"!';
        lQtyToPostNotCorrectErr: Label 'No match was found between the components related to the "Item by product" = "%1" and the components present in the BOM "%2"!';
        lQuantityErr: Label 'The quantity defined for the "Item by product" = "%1" exceeds the sum of the quantities of the related components present in the bill of materials "%2"!';
    begin
        //CS_PRO_041_BIS-s
        //Gestita corrispondenza basandoci sulla ricerca positiva anche di un solo componente senza considerare differenze tra legami di tipo "1 a 1" o "1 a N"        
        Clear(lProductionBOMLine);
        Clear(lByProductItemRelation);
        lByProductItemRelation.SetRange("By Product Item No.", pByProductItem);
        if lByProductItemRelation.IsEmpty then begin
            if pWithError then Error(lMissingRelationErr, pByProductItem);
            exit(false);
        end;

        lItemByProd.Get(pByProductItem);
        lTotalRelationCompQtyBase := 0;
        lByProductItemRelation.FindSet();
        repeat
            lProductionBOMLine.SetRange("Production BOM No.", pProductionBOMHeader."No.");
            lProductionBOMLine.SetRange("Version Code", pVersionCode);
            lProductionBOMLine.SetRange(Type, lProductionBOMLine.Type::Item);
#pragma warning disable AA0210
            lProductionBOMLine.SetFilter(Quantity, '> %1', 0);
#pragma warning restore AA0210
            lProductionBOMLine.SetRange("No.", lByProductItemRelation."Component No.");
            if lProductionBOMLine.FindSet() then begin
                repeat
                    if (lProductionBOMLine."Unit of Measure Code" <> lItemByProd."Base Unit of Measure") then begin
                        lItemUnitofMeasure.Get(lProductionBOMLine."No.", lProductionBOMLine."Unit of Measure Code");
                        lTotalRelationCompQtyBase += lUnitofMeasureManagement.CalcBaseQty(lProductionBOMLine.Quantity, lItemUnitofMeasure."Qty. per Unit of Measure");
                    end else begin
                        lTotalRelationCompQtyBase += lProductionBOMLine.Quantity;
                    end;
                until (lProductionBOMLine.Next() = 0);
            end;
        until (lByProductItemRelation.Next() = 0);

        if (lTotalRelationCompQtyBase = 0) then begin
            if pWithError then Error(lQtyToPostNotCorrectErr, pByProductItem, pProductionBOMHeader."No.");
            exit(false);
        end;

        lTotalByProdQtyBase := 0;
        Clear(lProductionBOMLine);
        lProductionBOMLine.SetRange("Production BOM No.", pProductionBOMHeader."No.");
        lProductionBOMLine.SetRange("Version Code", pVersionCode);
        lProductionBOMLine.SetRange(Type, lProductionBOMLine.Type::Item);
#pragma warning disable AA0210
        lProductionBOMLine.SetFilter("Quantity per", '< %1', 0);
#pragma warning restore AA0210
        lProductionBOMLine.SetRange("No.", pByProductItem);
        lProductionBOMLine.FindSet();
        repeat
            if (lProductionBOMLine."Unit of Measure Code" <> lItemByProd."Base Unit of Measure") then begin
                lItemUnitofMeasure.Get(lProductionBOMLine."No.", lProductionBOMLine."Unit of Measure Code");
                lTotalByProdQtyBase += lUnitofMeasureManagement.CalcBaseQty(lProductionBOMLine.Quantity, lItemUnitofMeasure."Qty. per Unit of Measure");
            end else begin
                lTotalByProdQtyBase += lProductionBOMLine.Quantity;
            end;
        until (lProductionBOMLine.Next() = 0);

        if (Abs(lTotalByProdQtyBase) > lTotalRelationCompQtyBase) then begin
            if pWithError then Error(lQuantityErr, pByProductItem, pProductionBOMHeader."No.");
            exit(false);
        end;

        exit(true);
        //CS_PRO_041_BIS-e
    end;

    internal procedure CheckByProductCompOnPostingItemJnlLine(var pItemJournalLine: Record "Item Journal Line")
    var
        lItem: Record Item;
    begin
        //CS_PRO_041_BIS-s
        if (pItemJournalLine."Entry Type" = pItemJournalLine."Entry Type"::Consumption) then begin
            if lItem.Get(pItemJournalLine."Item No.") and lItem."ecBy Product Item" then begin
                CheckByProdItemOnProdPosting(pItemJournalLine);
            end;
        end;
        //CS_PRO_041_BIS-e
    end;

    local procedure CheckByProdItemOnProdPosting(var pItemJournalLine: Record "Item Journal Line")
    var
        lItem: Record Item;
        lProdOrderLine: Record "Prod. Order Line";
        lItemLedgerEntry: Record "Item Ledger Entry";
        lItemJournalLine2: Record "Item Journal Line";
        lByProductItemRelation: Record "ecBy Product Item Relation";
        lAWPLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
        lQtyToPostLinkedComp: Decimal;
        lQtyPostedLinkedComp: Decimal;
        lQtyPostedByProduct: Decimal;
        lQtyToPostByProduct: Decimal;

        lLogisticUnitsMandatoryErr: Label 'Logistic units mandatory for production consumption postings.\Item No. = "%1 - %2"';
        lManyByProdItemsErr: Label 'It is possible to post consumption for only one item "By Product" in production order "%1 - %2"!';
        lMissingRelationErr: Label 'No relation defined for component by product = "%1"!';
        lQtyToPostNotCorrectErr: Label 'For component By Product = "%1" it is not possible to register quantity = "%2". The total consumption declared for the component exceeds that declared for its linked components:\';
        lQtyToPostNotCorrectErr2: Label '\-Qty to register comp. "By Product": %1';
        lQtyToPostNotCorrectErr3: Label '\-Qty registered comp. "By Product": %1';
        lQtyToPostNotCorrectErr4: Label '\-Qty to register comp. linked: %1';
        lQtyToPostNotCorrectErr5: Label '\-Qty registered comp. linked: %1';
        lQtyToPostNotCorrectErr6: Label '\\-Difference: %1';
    begin
        //CS_PRO_041_BIS-s
        Clear(lItemLedgerEntry);
        Clear(lItemJournalLine2);

        lQtyToPostLinkedComp := 0;
        lQtyPostedLinkedComp := 0;
        lQtyPostedByProduct := 0;
        lQtyToPostByProduct := 0;

        if (pItemJournalLine."Quantity (Base)" <> 0) then begin
            //Controllo la presenza di unità logistiche di destinazione
            if (pItemJournalLine."AltAWPPallet No." = '') and (pItemJournalLine."AltAWPBox No." = '') then begin
                if lAWPLogisticUnitsMgt.IsLogisticUnitsMandatoryOnOutput(pItemJournalLine."Location Code") then begin
                    Error(lLogisticUnitsMandatoryErr, pItemJournalLine."Item No.", pItemJournalLine.Description);
                end;
            end;

            //Controllo che nei movimenti da registrare sia presente solo un codice articolo By Product
            lItemJournalLine2.SetRange("Journal Template Name", pItemJournalLine."Journal Template Name");
            lItemJournalLine2.SetRange("Journal Batch Name", pItemJournalLine."Journal Batch Name");
            lItemJournalLine2.SetRange("Order Type", lItemJournalLine2."Order Type"::Production);
            lItemJournalLine2.SetRange("Order No.", pItemJournalLine."Order No.");
            lItemJournalLine2.SetRange("Order Line No.", pItemJournalLine."Order Line No.");
            lItemJournalLine2.SetRange("Entry Type", lItemJournalLine2."Entry Type"::Consumption);
            lItemJournalLine2.SetFilter("Item No.", '<>%1', pItemJournalLine."Item No.");
            if not lItemJournalLine2.IsEmpty then begin
                lItemJournalLine2.FindSet();
                repeat
                    lItem.Get(lItemJournalLine2."Item No.");
                    if lItem."ecBy Product Item" and (pItemJournalLine."Item No." <> lItem."No.") then begin
                        Error(lManyByProdItemsErr, lItemJournalLine2."Order No.", lItemJournalLine2."Order Line No.");
                    end;
                until (lItemJournalLine2.Next() = 0);
            end;

            //Controllo che nei movimenti registrati non sia presente un codice articolo By Product diverso da quello che voglio registrare
            lItemLedgerEntry.SetCurrentKey("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.");
            lItemLedgerEntry.SetRange("Order Type", lItemLedgerEntry."Order Type"::Production);
            lItemLedgerEntry.SetRange("Order No.", pItemJournalLine."Order No.");
            lItemLedgerEntry.SetRange("Order Line No.", pItemJournalLine."Order Line No.");
            lItemLedgerEntry.SetRange("Entry Type", lItemLedgerEntry."Entry Type"::Consumption);
            lItemLedgerEntry.SetFilter("Item No.", '<>%1', pItemJournalLine."Item No.");
            if not lItemLedgerEntry.IsEmpty then begin
                lItemLedgerEntry.FindSet();
                repeat
                    lItem.Get(lItemLedgerEntry."Item No.");
                    if lItem."ecBy Product Item" and (pItemJournalLine."Item No." <> lItem."No.") then begin
                        Error(lManyByProdItemsErr, lItemLedgerEntry."Order No.", lItemLedgerEntry."Order Line No.");
                    end;
                until (lItemLedgerEntry.Next() = 0);
            end;

            //Controllo che il lotto assegnato sia uguale a quello definito per il PF/SL relativo alla riga di ODP
            lProdOrderLine.Get(lProdOrderLine.Status::Released, pItemJournalLine."Order No.", pItemJournalLine."Order Line No.");
            pItemJournalLine.TestField("AltAWPLot No.", lProdOrderLine."ecOutput Lot No.");
            pItemJournalLine.TestField("AltAWPExpiration Date", lProdOrderLine."ecOutput Lot Exp. Date");

            Clear(lByProductItemRelation);
            lByProductItemRelation.SetRange("By Product Item No.", pItemJournalLine."Item No.");
            if lByProductItemRelation.IsEmpty then Error(lMissingRelationErr, pItemJournalLine."Item No.");
            lByProductItemRelation.FindSet();
            repeat
                //Calcolo la quantità di consumo da registrare dei componenti relazionati al By Product
                lItemJournalLine2.SetRange("Journal Template Name", pItemJournalLine."Journal Template Name");
                lItemJournalLine2.SetRange("Journal Batch Name", pItemJournalLine."Journal Batch Name");
                lItemJournalLine2.SetRange("Order Type", lItemJournalLine2."Order Type"::Production);
                lItemJournalLine2.SetRange("Order No.", pItemJournalLine."Order No.");
                lItemJournalLine2.SetRange("Order Line No.", pItemJournalLine."Order Line No.");
                lItemJournalLine2.SetRange("Entry Type", lItemJournalLine2."Entry Type"::Consumption);
                lItemJournalLine2.SetRange("Item No.", lByProductItemRelation."Component No.");
                if not lItemJournalLine2.IsEmpty then begin
                    lItemJournalLine2.FindLast();
                    lItemJournalLine2.CalcSums("Quantity (Base)");
                    lQtyToPostLinkedComp += lItemJournalLine2."Quantity (Base)";
                end;

                //Calcolo la quantità di consumo già registrata dei componenti relazionati al By Product
                lItemLedgerEntry.SetCurrentKey("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.");
                lItemLedgerEntry.SetRange("Order Type", lItemLedgerEntry."Order Type"::Production);
                lItemLedgerEntry.SetRange("Order No.", pItemJournalLine."Order No.");
                lItemLedgerEntry.SetRange("Order Line No.", pItemJournalLine."Order Line No.");
                lItemLedgerEntry.SetRange("Entry Type", lItemLedgerEntry."Entry Type"::Consumption);
                lItemLedgerEntry.SetRange("Item No.", lByProductItemRelation."Component No.");
                if not lItemLedgerEntry.IsEmpty then begin
                    lItemLedgerEntry.FindLast();
                    lItemLedgerEntry.CalcSums(Quantity);
                    lQtyPostedLinkedComp += lItemLedgerEntry.Quantity;
                end;
            until (lByProductItemRelation.Next() = 0);

            //Calcolo la quantità di consumo da registrare del componente By Product
            lItemJournalLine2.SetRange("Journal Template Name", pItemJournalLine."Journal Template Name");
            lItemJournalLine2.SetRange("Journal Batch Name", pItemJournalLine."Journal Batch Name");
            lItemJournalLine2.SetRange("Order Type", lItemJournalLine2."Order Type"::Production);
            lItemJournalLine2.SetRange("Order No.", pItemJournalLine."Order No.");
            lItemJournalLine2.SetRange("Order Line No.", pItemJournalLine."Order Line No.");
            lItemJournalLine2.SetRange("Entry Type", lItemJournalLine2."Entry Type"::Consumption);
            lItemJournalLine2.SetRange("Item No.", pItemJournalLine."Item No.");
            lItemJournalLine2.FindLast();
            lItemJournalLine2.CalcSums(lItemJournalLine2."Quantity (Base)");
            lQtyToPostByProduct := lItemJournalLine2."Quantity (Base)";

            //Calcolo la quantità di consumo già registrata del componente By Product
            lItemLedgerEntry.SetCurrentKey("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.");
            lItemLedgerEntry.SetRange("Order Type", lItemLedgerEntry."Order Type"::Production);
            lItemLedgerEntry.SetRange("Order No.", pItemJournalLine."Order No.");
            lItemLedgerEntry.SetRange("Order Line No.", pItemJournalLine."Order Line No.");
            lItemLedgerEntry.SetRange("Entry Type", lItemLedgerEntry."Entry Type"::Consumption);
            lItemLedgerEntry.SetRange("Item No.", pItemJournalLine."Item No.");
            if not lItemLedgerEntry.IsEmpty then begin
                lItemLedgerEntry.FindLast();
                lItemLedgerEntry.CalcSums(Quantity);
                lQtyPostedByProduct := lItemLedgerEntry.Quantity;
            end;

            if (Abs(lQtyPostedLinkedComp) + Abs(lQtyToPostLinkedComp) < Abs(lQtyPostedByProduct) + Abs(lQtyToPostByProduct)) then begin
                Error(StrSubstNo(lQtyToPostNotCorrectErr, pItemJournalLine."Item No.", lQtyToPostByProduct) +
                      StrSubstNo(lQtyToPostNotCorrectErr2, lQtyToPostByProduct) +
                      StrSubstNo(lQtyToPostNotCorrectErr3, lQtyPostedByProduct) +
                      StrSubstNo(lQtyToPostNotCorrectErr4, lQtyToPostLinkedComp) +
                      StrSubstNo(lQtyToPostNotCorrectErr5, lQtyPostedLinkedComp) +
                      StrSubstNo(lQtyToPostNotCorrectErr6, (Abs(lQtyPostedLinkedComp) + Abs(lQtyToPostLinkedComp)) -
                                                           (Abs(lQtyPostedByProduct) + Abs(lQtyToPostByProduct))));
            end;
        end;
        //CS_PRO_041_BIS-e
    end;

    internal procedure CreateByProdItemLotNoInfoCardOnItemJnlPost(var pItemJournalLine: Record "Item Journal Line")
    var
        lItem: Record Item;
        lProdOrderLine: Record "Prod. Order Line";
        lDestLotNoInfo: Record "Lot No. Information";
        lOriginLotNoInfo: Record "Lot No. Information";
        lItemJournalLine2: Record "Item Journal Line";
    begin
        //CS_PRO_041_BIS-s
        lItemJournalLine2.Copy(pItemJournalLine);
        lItemJournalLine2.SetRange("Entry Type", lItemJournalLine2."Entry Type"::Consumption);
        lItemJournalLine2.SetFilter(Quantity, '<%1', 0);
        if not lItemJournalLine2.IsEmpty then begin
            lItemJournalLine2.FindSet();
            repeat
                //Se registro un consumo negativo di un componente di tipo "By Product" creo la scheda lotto dal SL/PF di output 
                if lItem.Get(lItemJournalLine2."Item No.") and lItem."ecBy Product Item" then begin
                    if lProdOrderLine.Get(lProdOrderLine.Status::Released, lItemJournalLine2."Order No.", lItemJournalLine2."Order Line No.") and
                       lOriginLotNoInfo.Get(lProdOrderLine."Item No.", lProdOrderLine."Variant Code", lProdOrderLine."ecOutput Lot No.") and
                       (lOriginLotNoInfo."ecLot No. Information Status" = lOriginLotNoInfo."ecLot No. Information Status"::Released) and
                       not lDestLotNoInfo.Get(lItemJournalLine2."Item No.", lItemJournalLine2."Variant Code", lOriginLotNoInfo."Lot No.")
                    then begin
                        lDestLotNoInfo := lOriginLotNoInfo;
                        lDestLotNoInfo.Validate("Item No.", lItemJournalLine2."Item No.");
                        lDestLotNoInfo.Validate("Variant Code", lItemJournalLine2."Variant Code");
                        lDestLotNoInfo.Insert(true);
                    end;
                end;
            until (lItemJournalLine2.Next() = 0);
        end;
        //CS_PRO_041_BIS-e
    end;

    #endregion CS_PRO_041_BIS - Gestione by product

    #region CS_PRO_044 - Gestione della “Quantità Send-Ahead” su diverse righe dello stesso ODP
    internal procedure CheckItemProductionPlanningParameters(pItem: Record Item; pLocationCode: Code[10]; pVariantCode: Code[10])
    var
        lSku: Record "Stockkeeping Unit";
        lProductionBOMNo: Code[20];
        lRoutingNo: Code[20];
        lMissingProdBOMErr: Label 'Missing Production BOM for Item %1';
        lMissingRoutingErr: Label 'Missing Production Routing for Item %1';
    begin
        //CS_PRO_044-VI-s        
        lSku := pItem.GetSKU(pLocationCode, pVariantCode);

        lProductionBOMNo := pItem."Production BOM No.";
        if (lSku."Production BOM No." <> '') then begin
            lProductionBOMNo := lSku."Production BOM No.";
        end;

        if (lProductionBOMNo = '') then begin
            Error(lMissingProdBOMErr, pItem."No.");
        end;

        lRoutingNo := pItem."Routing No.";
        if (lSku."Routing No." <> '') then begin
            lRoutingNo := lSku."Routing No.";
        end;

        if (lRoutingNo = '') then begin
            Error(lMissingRoutingErr, pItem."No.");
        end;
        //CS_PRO_044-VI-e
    end;

    procedure UpdateProductionOrderLines(var pProductionOrder: Record "Production Order"; pWithConfirm: Boolean)
    var
        lProdOrderLine: Record "Prod. Order Line";
        lUpdProdOrderConf: Label 'Are you sure you want to update production order No.: %1?';
        lOperationCanceledErr: Label 'Operation canceled!';
    begin
        //CS_PRO_044-s
        if pWithConfirm then begin
            if not Confirm(StrSubstNo(lUpdProdOrderConf, pProductionOrder."No."), false) then Error(lOperationCanceledErr);
        end;

        //Sistemo le Ubicazioni/Collocazioni di output assegnate ad ogni riga ODP
        Clear(lProdOrderLine);
        lProdOrderLine.SetRange(Status, pProductionOrder.Status);
        lProdOrderLine.SetRange("Prod. Order No.", pProductionOrder."No.");
        if not lProdOrderLine.IsEmpty then begin
            lProdOrderLine.FindSet();
            repeat
                UpdateProdOrderLine(lProdOrderLine);
            until (lProdOrderLine.Next() = 0);
        end;

        //Controllo se l'ordine può subire una revisione
        //Rimosso controllo
        //if not CheckIfProdOrderIsAdjustable(pProductionOrder) then exit;

        //Ricalcolo la data di inizio in funzione del send-ahead degli articoli
        RecalcStartingDateTimeBySendAhead(pProductionOrder, 0, 1); //Calcolo Indietro
        //CS_PRO_044-e
    end;

    internal procedure UpdateProdOrderLine(var pProdOrderLine: Record "Prod. Order Line")
    begin
        //CS_PRO_044-s
        UpdateProdOrderLineInformations(pProdOrderLine);
        UpdateProdOrderLineLocation_BinCode(pProdOrderLine);
        UpdateProdOrdLinePrevalentOperation(pProdOrderLine);
        UpdateProdOrdLinePackagingFields(pProdOrderLine);
        //CS_PRO_044-e
    end;

    internal procedure CheckIfProdOrderIsAdjustable(var pProductionOrder: Record "Production Order"): Boolean
    var
        lProdOrderRoutingLine: Record "Prod. Order Routing Line";
    begin
        //CS_PRO_044-s
        Clear(lProdOrderRoutingLine);
        lProdOrderRoutingLine.SetCurrentKey("Starting Date", "Starting Time", "Routing Status");
        lProdOrderRoutingLine.SetRange(Status, pProductionOrder.Status);
        lProdOrderRoutingLine.SetRange("Prod. Order No.", pProductionOrder."No.");
        if lProdOrderRoutingLine.IsEmpty then exit(false);
        lProdOrderRoutingLine.FindFirst();
        if (lProdOrderRoutingLine."Starting Date" <= Today) then exit(false);

        exit(true);
        //CS_PRO_044-e
    end;

    internal procedure UpdateProdOrderLineLocation_BinCode(var pProdOrderLine: Record "Prod. Order Line")
    var
        lWorkCenter: Record "Work Center";
        lMachineCenter: Record "Machine Center";
        lProdOrderRoutingLine: Record "Prod. Order Routing Line";
        lProdOrderLineModified: Boolean;
    begin
        //CS_PRO_044-s
        if (pProdOrderLine."Planning Level Code" = 0) then exit;
        if (pProdOrderLine."Prod. Order No." = '') or (pProdOrderLine."Line No." = 0) then exit;

        lProdOrderLineModified := false;
        Clear(lProdOrderRoutingLine);
        lProdOrderRoutingLine.SetRange(Status, pProdOrderLine.Status);
        lProdOrderRoutingLine.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        lProdOrderRoutingLine.SetRange("Routing Reference No.", pProdOrderLine."Routing Reference No.");
        lProdOrderRoutingLine.SetRange("Routing No.", pProdOrderLine."Routing No.");
        if not lProdOrderRoutingLine.IsEmpty then begin
            lProdOrderRoutingLine.FindLast();

            case lProdOrderRoutingLine.Type of
                lProdOrderRoutingLine.Type::"Work Center":
                    begin
                        if lWorkCenter.Get(lProdOrderRoutingLine."No.") then begin
                            if (pProdOrderLine."Location Code" <> lWorkCenter."Location Code") then begin
                                pProdOrderLine.Validate("Location Code", lWorkCenter."Location Code");
                                lProdOrderLineModified := true;
                            end;
                            if (pProdOrderLine."Bin Code" <> lWorkCenter."From-Production Bin Code") then begin
                                pProdOrderLine.Validate("Bin Code", lWorkCenter."From-Production Bin Code");
                                lProdOrderLineModified := true;
                            end;
                        end;
                    end;
                lProdOrderRoutingLine.Type::"Machine Center":
                    begin
                        if lMachineCenter.Get(lProdOrderRoutingLine."No.") then begin
                            lWorkCenter.Get(lMachineCenter."Work Center No.");
                            if (pProdOrderLine."Location Code" <> lMachineCenter."Location Code") and (lMachineCenter."Location Code" <> '') then begin
                                pProdOrderLine.Validate("Location Code", lMachineCenter."Location Code");
                                lProdOrderLineModified := true;
                            end else begin
                                if (lMachineCenter."Location Code" = '') and (pProdOrderLine."Location Code" <> lWorkCenter."Location Code") then begin
                                    pProdOrderLine.Validate("Location Code", lWorkCenter."Location Code");
                                    lProdOrderLineModified := true;
                                end;
                            end;
                            if (pProdOrderLine."Bin Code" <> lMachineCenter."From-Production Bin Code") and (lMachineCenter."From-Production Bin Code" <> '') then begin
                                pProdOrderLine.Validate("Bin Code", lMachineCenter."From-Production Bin Code");
                                lProdOrderLineModified := true;
                            end else begin
                                if (lMachineCenter."From-Production Bin Code" = '') and (pProdOrderLine."Bin Code" <> lWorkCenter."From-Production Bin Code") then begin
                                    pProdOrderLine.Validate("Bin Code", lWorkCenter."From-Production Bin Code");
                                    lProdOrderLineModified := true;
                                end;
                            end;
                        end;
                    end;
            end;

            if lProdOrderLineModified then pProdOrderLine.Modify(true);
        end;
        //CS_PRO_044-e
    end;

    internal procedure RecalcStartingDateTimeBySendAhead(var pProductionOrder: Record "Production Order"; pProdOrderLineNo: Integer; pSchedulingDirection: Option Forward,Backward): Boolean
    var
        lItem: Record Item;
        lProdOrderLine: Record "Prod. Order Line";
        Temp_lProdOrderLine: Record "Prod. Order Line" temporary;
    begin
        //CS_PRO_044-s
        Clear(Temp_lProdOrderLine);
        Temp_lProdOrderLine.DeleteAll();

        //Creo record temporanei di prod. order line con i riferimenti alla riga del componente padre
        Clear(lProdOrderLine);
        lProdOrderLine.SetCurrentKey("ecParent Line No.");
        lProdOrderLine.SetFilter("ecParent Line No.", '<>%1', 0);
        lProdOrderLine.SetRange(Status, pProductionOrder.Status);
        lProdOrderLine.SetRange("Prod. Order No.", pProductionOrder."No.");
        if (pProdOrderLineNo <> 0) then lProdOrderLine.SetRange("Line No.", pProdOrderLineNo);
        if lProdOrderLine.FindSet() then begin
            repeat
                Temp_lProdOrderLine := lProdOrderLine;
                Temp_lProdOrderLine.Insert(false);
            until (lProdOrderLine.Next() = 0);
        end;

        //Calcolo sulla temporanea di prod order line la quantità di Send-Ahead per ogni semilavorato
        Clear(Temp_lProdOrderLine);
        if (Temp_lProdOrderLine.IsEmpty) then exit(false);

        Temp_lProdOrderLine.SetCurrentKey("ecParent Line No.");
        Temp_lProdOrderLine.FindSet();
        repeat
            lItem.Get(Temp_lProdOrderLine."Item No.");
            if (lItem."ecSend-Ahead Quantity" <> 0) then begin
                Temp_lProdOrderLine."ecSend-Ahead Quantity" := lItem."ecSend-Ahead Quantity";
                if (Temp_lProdOrderLine."ecSend-Ahead Quantity" > Temp_lProdOrderLine."Remaining Qty. (Base)") then begin
                    Temp_lProdOrderLine."ecSend-Ahead Quantity" := 0;
                end;
                Temp_lProdOrderLine.Modify(true);
            end;
        until (Temp_lProdOrderLine.Next() = 0);

        //Aggiorno le date sulle righe ODP
        if (pSchedulingDirection = pSchedulingDirection::Forward) then begin
            exit(UpdateProdOrderLinesDatesForward(Temp_lProdOrderLine));
        end else begin
            exit(UpdateProdOrderLinesDatesBackward(Temp_lProdOrderLine));
        end;
        //CS_PRO_044-e
    end;

    internal procedure UpdateProdOrderLinesDatesForward(var Temp_pProdOrderLine: Record "Prod. Order Line" temporary): Boolean
    var
        lCalendarEntry: Record "Calendar Entry";
        lProductionOrder: Record "Production Order";
        lProductionOrderSim: Record "Production Order";
        lProdOrderLineSim: Record "Prod. Order Line";
        lProdOrderLineParent: Record "Prod. Order Line";
        lProdOrderComponent: Record "Prod. Order Component";
        Temp_lProdOrderComponent: Record "Prod. Order Component" temporary;
        Temp_lParentCompReservBackup: Record "Reservation Entry" temporary;
        Temp_lProdOrderLine2: Record "Prod. Order Line" temporary;
        lProdOrderRoutingLine: Record "Prod. Order Routing Line";
        lReservationFunctions: Codeunit "ecReservation Functions";
        lTransactionRef: Text;
        lNewProdOrderNo: Code[20];
        lNewStartingDate: Date;
        lNewStartingTime: Time;
    begin
        //CS_PRO_044-s
        Clear(Temp_pProdOrderLine);
        Temp_pProdOrderLine.SetFilter("ecSend-Ahead Quantity", '>%1', 0);
        Temp_pProdOrderLine.SetFilter("Remaining Quantity", '<>%1', 0);
        if Temp_pProdOrderLine.IsEmpty then exit(false);

        Clear(Temp_pProdOrderLine);
        CopyTempProdOrderLine(Temp_pProdOrderLine, Temp_lProdOrderLine2);
        Temp_lProdOrderLine2.FindFirst();

        //Eseguo un backup dell'impegno sull'ODP e lo rimuovo        
        lProductionOrder.Get(Temp_lProdOrderLine2.Status, Temp_lProdOrderLine2."Prod. Order No.");

        lTransactionRef := 'UpdateProdOrderLinesDates';
        lReservationFunctions.BackupAndRemoveProdOrderReservations(lProductionOrder, true, lTransactionRef);

        //Clono l'ODP creandone temporaneamente uno simulato per eseguire i calcoli delle date
        lNewProdOrderNo := CreateTempProdOrderNo();
        CreateSimulatedProdOrderClone(lProductionOrder, lNewProdOrderNo, 0); //Avanti

        //Sistemo le date sull'ODP temporaneamente creato in base alla quantità di Send-Ahead
        lProductionOrderSim.Get(lProductionOrderSim.Status::Simulated, lNewProdOrderNo);
        AdjProdOrderLinesDateBySendAheadQtyForward(lProductionOrderSim, Temp_pProdOrderLine);

        //Scorro la temporanea al contrario per aggiornare dal basso verso l'alto i tempi basandomi sulle date ricalcolate nell'ODP simulato
        Temp_pProdOrderLine.SetCurrentKey("ecParent Line No.");
        Temp_pProdOrderLine.Find('+');
        repeat
            if lProdOrderLineParent.Get(Temp_pProdOrderLine.Status, Temp_pProdOrderLine."Prod. Order No.", Temp_pProdOrderLine."ecParent Line No.") then begin

                //Verifico la presenza di più righe collegate allo stesso padre, in caso positivo cerco quella che finisce più tardi di tutte
                Temp_lProdOrderLine2.SetRange("ecParent Line No.", Temp_pProdOrderLine."ecParent Line No.");
                if not Temp_lProdOrderLine2.IsEmpty then begin
                    lNewStartingDate := 0D;
                    lNewStartingTime := 0T;
                    Temp_lProdOrderLine2.FindSet();
                    repeat
                        if lProdOrderLineSim.Get(lProdOrderLineSim.Status::Simulated, lProductionOrderSim."No.", Temp_lProdOrderLine2."Line No.") then begin
                            if (lProdOrderLineSim."Ending Date" > lNewStartingDate) then begin
                                lNewStartingDate := lProdOrderLineSim."Ending Date";
                                lNewStartingTime := lProdOrderLineSim."Ending Time";
                            end else begin
                                if (lProdOrderLineSim."Ending Time" > lNewStartingTime) and (lProdOrderLineSim."Ending Date" = lNewStartingDate) then begin
                                    lNewStartingTime := lProdOrderLineSim."Ending Time";
                                end;
                            end;
                        end;
                    until (Temp_lProdOrderLine2.Next() = 0);
                end;

                //Aggiornamento data inizio in base al calendario dell'Area/Centro della prima operazione di ciclo della riga padre
                if (lNewStartingDate <> 0D) and (lNewStartingTime <> 0T) then begin
                    //Eseguo un backup delle date di scadenza dei componenti presenti sulla riga padre
                    BackupProdOrderCompSupplied(Temp_lProdOrderComponent, Temp_pProdOrderLine);

                    if GetProdOrderCompLinkedToProdOrdLine(lProdOrderComponent, Temp_pProdOrderLine) then begin

                        //Eseguo il backup dell'impegno dei componenti e lo rimuovo
                        lReservationFunctions.BackupAndRemoveProdOrderCompReservations(lProdOrderLineParent, Temp_lParentCompReservBackup);

                        GetProdOrderRoutingLineByRoutingLinkCode(lProdOrderLineParent, lProdOrderRoutingLine, Temp_lProdOrderComponent."Routing Link Code");
                        Clear(lCalendarEntry);
                        lCalendarEntry.SetRange("Capacity Type", lProdOrderRoutingLine.Type);
                        lCalendarEntry.SetRange("No.", lProdOrderRoutingLine."No.");
                        lCalendarEntry.SetRange(Date, lNewStartingDate);
                        lCalendarEntry.SetFilter("Starting Time", '<=%1', lNewStartingTime);
                        lCalendarEntry.SetFilter("Ending Time", '>=%1', lNewStartingTime);
                        if lCalendarEntry.IsEmpty then begin
                            lCalendarEntry.SetFilter(Date, '>%1', lNewStartingDate);
                            lCalendarEntry.SetRange("Starting Time");
                            lCalendarEntry.SetRange("Ending Time");
                            lCalendarEntry.FindFirst();
                            if (lProdOrderRoutingLine."Starting Date-Time" <> lCalendarEntry."Starting Date-Time") then begin
                                lProdOrderRoutingLine.Validate("Starting Date-Time", lCalendarEntry."Starting Date-Time");
                            end;
                        end else begin
                            if (lProdOrderRoutingLine."Starting Date-Time" <> CreateDateTime(lNewStartingDate, lNewStartingTime)) then begin
                                lProdOrderRoutingLine.Validate("Starting Date-Time", CreateDateTime(lNewStartingDate, lNewStartingTime));
                            end;
                        end;

                        //Reimposto le date di scadenza dei componenti come in precedenza per evitare riprogrammazioni da MRP
                        RestoreProdOrderCompDueDate(Temp_lProdOrderComponent);

                        //Provo a reinserire il bakup dell'impegno sui componenti
                        lReservationFunctions.TryToRestoreProdOrderCompReservation(lProdOrderLineParent, Temp_lParentCompReservBackup);
                    end;
                end;
            end;
        until (Temp_pProdOrderLine.Next(-1) = 0);

        //Imposto su tutte le righe di ODP flessibilità in pianificazione = Nessuna per evitare messaggi di annullamento da MRP dovuti ai cambi date
        Clear(lProdOrderLineParent);
        lProdOrderLineParent.SetRange(Status, Temp_pProdOrderLine.Status);
        lProdOrderLineParent.SetRange("Prod. Order No.", Temp_pProdOrderLine."Prod. Order No.");
        if not lProdOrderLineParent.IsEmpty then begin
            lProdOrderLineParent.FindSet();
            repeat
                if (lProdOrderLineParent."Planning Flexibility" <> lProdOrderLineParent."Planning Flexibility"::None) then begin
                    lProdOrderLineParent.Validate("Planning Flexibility", lProdOrderLineParent."Planning Flexibility"::None);
                    lProdOrderLineParent.Modify(true);
                end;
            until (lProdOrderLineParent.Next() = 0);
        end;

        //Ripristino il backup dell'impegno precedentemente rimosso dalle righe di ODP 
        lReservationFunctions.RestoreProdOrderReservations(lProductionOrder, lTransactionRef, false);

        //Elimino l'ODP simulato creato precedentemente
        lProductionOrderSim.Delete(true);

        exit(true);
        //CS_PRO_044-e
    end;

    internal procedure UpdateProdOrderLinesDatesBackward(var Temp_pProdOrderLine: Record "Prod. Order Line" temporary): Boolean
    var
        lProductionOrder: Record "Production Order";
        lProductionOrderSim: Record "Production Order";
        lProdOrderLineSim: Record "Prod. Order Line";
        lProdOrderLineOrigin: Record "Prod. Order Line";
        Temp_lProdOrderLine2: Record "Prod. Order Line" temporary;
        Temp_lProdOrderComponent: Record "Prod. Order Component" temporary;
        Temp_lParentCompReservBackup: Record "Reservation Entry" temporary;
        lReservationFunctions: Codeunit "ecReservation Functions";
        lTransactionRef: Text;
        lNewProdOrderNo: Code[20];
        lNewEndingDateTime: DateTime;
    begin
        //CS_PRO_044-s
        Clear(Temp_pProdOrderLine);
        Temp_pProdOrderLine.SetFilter("ecSend-Ahead Quantity", '>%1', 0);
        Temp_pProdOrderLine.SetFilter("Remaining Quantity", '<>%1', 0);
        if Temp_pProdOrderLine.IsEmpty then exit(false);

        Clear(Temp_pProdOrderLine);
        CopyTempProdOrderLine(Temp_pProdOrderLine, Temp_lProdOrderLine2);
        Temp_lProdOrderLine2.FindFirst();

        //Eseguo un backup dell'impegno sull'ODP e lo rimuovo        
        lProductionOrder.Get(Temp_lProdOrderLine2.Status, Temp_lProdOrderLine2."Prod. Order No.");

        lTransactionRef := 'UpdateProdOrderLinesDates';
        lReservationFunctions.BackupAndRemoveProdOrderReservations(lProductionOrder, true, lTransactionRef);

        //Clono l'ODP creandone temporaneamente uno simulato per eseguire i calcoli delle date
        lNewProdOrderNo := CreateTempProdOrderNo();
        CreateSimulatedProdOrderClone(lProductionOrder, lNewProdOrderNo, 1); //Indietro

        //Sistemo le date sull'ODP temporaneamente creato in base alla quantità di Send-Ahead
        lProductionOrderSim.Get(lProductionOrderSim.Status::Simulated, lNewProdOrderNo);
        AdjProdOrderLinesDateBySendAheadQtyBackward(lProductionOrderSim, Temp_pProdOrderLine);

        //Scorro la temporanea per aggiornare i tempi basandomi sulle date ricalcolate nell'ODP simulato
        Temp_pProdOrderLine.SetCurrentKey("ecParent Line No.");
        Temp_pProdOrderLine.FindSet();
        repeat
            if lProdOrderLineOrigin.Get(Temp_pProdOrderLine.Status, Temp_pProdOrderLine."Prod. Order No.", Temp_pProdOrderLine."Line No.") and
               lProdOrderLineSim.Get(lProductionOrderSim.Status, lProductionOrderSim."No.", Temp_pProdOrderLine."Line No.")
            then begin
                lNewEndingDateTime := lProdOrderLineSim."Ending Date-Time";

                //Aggiornamento data inizio in base al calendario dell'Area/Centro della prima operazione di ciclo della riga padre
                if (lNewEndingDateTime <> 0DT) then begin
                    //Eseguo un backup delle date di scadenza dei componenti presenti sulla riga padre
                    BackupProdOrderCompSupplied(Temp_lProdOrderComponent, Temp_pProdOrderLine);

                    //Eseguo il backup dell'impegno dei componenti e lo rimuovo
                    lReservationFunctions.BackupAndRemoveProdOrderCompReservations(lProdOrderLineOrigin, Temp_lParentCompReservBackup);

                    if (lProdOrderLineOrigin."Ending Date-Time" <> lNewEndingDateTime) then begin
                        lProdOrderLineOrigin.Validate("Ending Date-Time", lNewEndingDateTime);
                        lProdOrderLineOrigin.Modify(true);
                    end;

                    //Reimposto le date di scadenza dei componenti come in precedenza per evitare riprogrammazioni da MRP
                    RestoreProdOrderCompDueDate(Temp_lProdOrderComponent);

                    //Provo a reinserire il bakup dell'impegno sui componenti
                    lReservationFunctions.TryToRestoreProdOrderCompReservation(lProdOrderLineOrigin, Temp_lParentCompReservBackup);
                end;
            end;
        until (Temp_pProdOrderLine.Next() = 0);

        //Imposto su tutte le righe di ODP flessibilità in pianificazione = Nessuna per evitare messaggi di annullamento da MRP dovuti ai cambi date
        Clear(lProdOrderLineOrigin);
        lProdOrderLineOrigin.SetRange(Status, Temp_pProdOrderLine.Status);
        lProdOrderLineOrigin.SetRange("Prod. Order No.", Temp_pProdOrderLine."Prod. Order No.");
        if not lProdOrderLineOrigin.IsEmpty then begin
            lProdOrderLineOrigin.FindSet();
            repeat
                if (lProdOrderLineOrigin."Planning Flexibility" <> lProdOrderLineOrigin."Planning Flexibility"::None) then begin
                    lProdOrderLineOrigin.Validate("Planning Flexibility", lProdOrderLineOrigin."Planning Flexibility"::None);
                    lProdOrderLineOrigin.Modify(true);
                end;
            until (lProdOrderLineOrigin.Next() = 0);
        end;

        //Ripristino il backup dell'impegno precedentemente rimosso dalle righe di ODP 
        lReservationFunctions.RestoreProdOrderReservations(lProductionOrder, lTransactionRef, false);

        //Elimino l'ODP simulato creato precedentemente
        lProductionOrderSim.Delete(true);

        exit(true);
        //CS_PRO_044-e
    end;

    internal procedure CopyTempProdOrderLine(var Temp_pSourceProdOrderLine: Record "Prod. Order Line" temporary;
    var
        Temp_pDestProdOrderLine: Record "Prod. Order Line" temporary)
    begin
        //CS_PRO_044-s
        Clear(Temp_pSourceProdOrderLine);
        Clear(Temp_pDestProdOrderLine);
        Temp_pDestProdOrderLine.DeleteAll();
        if Temp_pSourceProdOrderLine.IsEmpty then exit;
        Temp_pSourceProdOrderLine.FindSet();
        repeat
            Temp_pDestProdOrderLine := Temp_pSourceProdOrderLine;
            Temp_pDestProdOrderLine.Insert(false);
        until (Temp_pSourceProdOrderLine.Next() = 0);
        //CS_PRO_044-e
    end;

    procedure GetFirstProdOrderRoutingLine(pProdOrderLine: Record "Prod. Order Line"; var pProdOrderRoutingLine: Record "Prod. Order Routing Line")
    begin
        //CS_PRO_044-s
        Clear(pProdOrderRoutingLine);
        pProdOrderRoutingLine.SetRange(Status, pProdOrderLine.Status);
        pProdOrderRoutingLine.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        pProdOrderRoutingLine.SetRange("Routing Reference No.", pProdOrderLine."Routing Reference No.");
        pProdOrderRoutingLine.SetRange("Routing No.", pProdOrderLine."Routing No.");
        pProdOrderRoutingLine.FindFirst();
        //CS_PRO_044-e
    end;

    procedure GetLastProdOrderRoutingLine(pProdOrderLine: Record "Prod. Order Line"; var pProdOrderRoutingLine: Record "Prod. Order Routing Line")
    begin
        //CS_PRO_044-s
        Clear(pProdOrderRoutingLine);
        pProdOrderRoutingLine.SetRange(Status, pProdOrderLine.Status);
        pProdOrderRoutingLine.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        pProdOrderRoutingLine.SetRange("Routing Reference No.", pProdOrderLine."Routing Reference No.");
        pProdOrderRoutingLine.SetRange("Routing No.", pProdOrderLine."Routing No.");
        pProdOrderRoutingLine.SetRange("Next Operation No.", '');
        pProdOrderRoutingLine.FindLast();
        //CS_PRO_044-e
    end;

    internal procedure GetProdOrderRoutingLineByRoutingLinkCode(pProdOrderLine: Record "Prod. Order Line"; var pProdOrderRoutingLine: Record "Prod. Order Routing Line"; pRoutingLinkCode: Code[10])
    begin
        //CS_PRO_044-s
        Clear(pProdOrderRoutingLine);
        pProdOrderRoutingLine.SetRange(Status, pProdOrderLine.Status);
        pProdOrderRoutingLine.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        pProdOrderRoutingLine.SetRange("Routing Reference No.", pProdOrderLine."Routing Reference No.");
        pProdOrderRoutingLine.SetRange("Routing No.", pProdOrderLine."Routing No.");
        pProdOrderRoutingLine.SetRange("Routing Link Code", pRoutingLinkCode);
        pProdOrderRoutingLine.FindLast();
        //CS_PRO_044-e
    end;

    local procedure BackupProdOrderCompSupplied(var Temp_pProdOrderComponent: Record "Prod. Order Component" temporary; var pProdOrderLine: Record "Prod. Order Line"): Boolean
    var
        lProdOrderComponent: Record "Prod. Order Component";
    begin
        //CS_PRO_044-s
        Clear(Temp_pProdOrderComponent);
        Temp_pProdOrderComponent.DeleteAll();

        Clear(lProdOrderComponent);
        lProdOrderComponent.SetRange(Status, pProdOrderLine.Status);
        lProdOrderComponent.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        lProdOrderComponent.SetRange("Supplied-by Line No.", pProdOrderLine."Line No.");
        if lProdOrderComponent.IsEmpty then exit(false);
        lProdOrderComponent.FindSet();
        repeat
            Temp_pProdOrderComponent := lProdOrderComponent;
            Temp_pProdOrderComponent.Insert(false);
        until (lProdOrderComponent.Next() = 0);
        exit(true);
        //CS_PRO_044-e
    end;

    local procedure RestoreProdOrderCompDueDate(var Temp_pProdOrderComponent: Record "Prod. Order Component" temporary)
    var
        lProdOrderLine: Record "Prod. Order Line";
        lProdOrderComponent: Record "Prod. Order Component";
    begin
        //CS_PRO_044-s
        Clear(Temp_pProdOrderComponent);
        if not Temp_pProdOrderComponent.IsEmpty then begin
            Temp_pProdOrderComponent.FindSet();
            repeat
                lProdOrderComponent.Get(Temp_pProdOrderComponent.Status, Temp_pProdOrderComponent."Prod. Order No.",
                                        Temp_pProdOrderComponent."Prod. Order Line No.", Temp_pProdOrderComponent."Line No.");
                lProdOrderLine.Get(Temp_pProdOrderComponent.Status, Temp_pProdOrderComponent."Prod. Order No.", Temp_pProdOrderComponent."Supplied-by Line No.");
                if (lProdOrderComponent."Due Date-Time" <> lProdOrderLine."Ending Date-Time") then begin
                    lProdOrderComponent.Validate("Due Date-Time", lProdOrderLine."Ending Date-Time" + 60000);
                    lProdOrderComponent.Modify(true);
                end;
            until (Temp_pProdOrderComponent.Next() = 0);
        end;
        //CS_PRO_044-e
    end;

    local procedure GetProdOrderCompLinkedToProdOrdLine(var pProdOrderComponent: Record "Prod. Order Component"; var pProdOrderLine: Record "Prod. Order Line"): Boolean
    begin
        //CS_PRO_044-s
        Clear(pProdOrderComponent);
        pProdOrderComponent.SetRange(Status, pProdOrderLine.Status);
        pProdOrderComponent.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        pProdOrderComponent.SetRange("Supplied-by Line No.", pProdOrderLine."Line No.");
        if pProdOrderComponent.IsEmpty then exit(false);
        pProdOrderComponent.FindFirst();
        exit(true);
        //CS_PRO_044-e
    end;

    local procedure CreateSimulatedProdOrderClone(var pOriginProductionOrder: Record "Production Order"; pNewProdOrderNo: Code[20]; pSchedulingDirection: Option Forward,Backward): Boolean
    var
        lProductionOrder: Record "Production Order";
        lProdOrderLine: Record "Prod. Order Line";
        lProdOrderComponent: Record "Prod. Order Component";
        lProdOrderRoutingLine: Record "Prod. Order Routing Line";
        lProdOrderCapacityNeed: Record "Prod. Order Capacity Need";
        lProductionFunctions: Codeunit "ecProduction Functions";
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
        lOperationNo: Code[10];
    begin
        //CS_PRO_044-s
        GetProdOrderInformations(pOriginProductionOrder, lProdOrderLine, lProdOrderComponent, lProdOrderRoutingLine, lProdOrderCapacityNeed);
        if lProdOrderLine.IsEmpty or lProdOrderComponent.IsEmpty or lProdOrderRoutingLine.IsEmpty or lProdOrderCapacityNeed.IsEmpty then exit(false);

        //Clono l'ODP creandone uno in stato Simulato
        if not CloneProductionOrder(pOriginProductionOrder, pNewProdOrderNo, Enum::"Production Order Status"::Simulated) then exit(false);

        lProductionOrder.Get(lProductionOrder.Status::Simulated, pNewProdOrderNo);
        GetProdOrderInformations(lProductionOrder, lProdOrderLine, lProdOrderComponent, lProdOrderRoutingLine, lProdOrderCapacityNeed);
        if lProdOrderLine.IsEmpty or lProdOrderComponent.IsEmpty or lProdOrderRoutingLine.IsEmpty or lProdOrderCapacityNeed.IsEmpty then exit(false);
        lProdOrderLine.FindSet();
        repeat
            //Rimuovo tutte le righe di ciclo tranne l'ultima
            lProductionFunctions.GetLastProdOrderRoutingLine(lProdOrderLine, lProdOrderRoutingLine);
            lOperationNo := lProdOrderRoutingLine."Operation No.";

            Clear(lProdOrderRoutingLine);
            lProdOrderRoutingLine.SetRange(Status, lProdOrderLine.Status);
            lProdOrderRoutingLine.SetRange("Prod. Order No.", lProdOrderLine."Prod. Order No.");
            lProdOrderRoutingLine.SetRange("Routing Reference No.", lProdOrderLine."Routing Reference No.");
            lProdOrderRoutingLine.SetRange("Routing No.", lProdOrderLine."Routing No.");
            lProdOrderRoutingLine.SetFilter("Operation No.", '<>%1', lOperationNo);
            lProdOrderRoutingLine.DeleteAll(true);

            //Rimuovo il legame tra righe ODP in caso di multi livello
            lProdOrderLine.Validate("Planning Level Code", 0);
            lProdOrderLine.Modify(true);
        until (lProdOrderLine.Next() = 0);

        //Rimuovo i legami tra componenti in caso di ODP multi livello
        //lProdOrderComponent.ModifyAll("Supplied-by Line No.", 0, false);

        //Azzero i tempi di attesa e spostamento perchè non necessari al calcolo
        lATSSessionDataStore.AddSessionSetting('SetAutoUpdateBinCodeOnProdOrderRouteManagement', true);

        Clear(lProdOrderRoutingLine);
        lProdOrderRoutingLine.SetRange(Status, lProductionOrder.Status);
        lProdOrderRoutingLine.SetRange("Prod. Order No.", lProductionOrder."No.");
        lProdOrderRoutingLine.FindSet();
        repeat
            lProdOrderRoutingLine.Validate("Previous Operation No.", '');
            lProdOrderRoutingLine.Validate("Next Operation No.", '');
            lProdOrderRoutingLine.Validate("Wait Time", 0);
            lProdOrderRoutingLine.Validate("Move Time", 0);
            if (pSchedulingDirection = pSchedulingDirection::Backward) then lProdOrderRoutingLine.Validate("Setup Time", 0);
            lProdOrderRoutingLine.Modify(true);
        until (lProdOrderRoutingLine.Next() = 0);

        lATSSessionDataStore.RemoveSessionSetting('SetAutoUpdateBinCodeOnProdOrderRouteManagement');

        exit(true);
        //CS_PRO_044-e
    end;

    internal procedure AdjProdOrderLinesDateBySendAheadQtyForward(var pProductionOrder: Record "Production Order"; var Temp_pPordOrderLine: Record "Prod. Order Line")
    var
        lProdOrderLine: Record "Prod. Order Line";
        lItemUnitofMeasure: Record "Item Unit of Measure";
        lUnitofMeasureManagement: Codeunit "Unit of Measure Management";
        lOriginalStartDateTime: DateTime;
        lNewQuantity: Decimal;
    begin
        //CS_PRO_044-s
        Clear(Temp_pPordOrderLine);
        Temp_pPordOrderLine.SetCurrentKey("ecParent Line No.");
        Temp_pPordOrderLine.SetFilter("ecSend-Ahead Quantity", '<>%1', 0);
        Temp_pPordOrderLine.Find('+');
        repeat
            lProdOrderLine.Get(pProductionOrder.Status, pProductionOrder."No.", Temp_pPordOrderLine."Line No.");
            lOriginalStartDateTime := lProdOrderLine."Starting Date-Time";
            if (lProdOrderLine.Quantity <> lProdOrderLine."Quantity (Base)") then begin
                lItemUnitofMeasure.Get(lProdOrderLine."Item No.", lProdOrderLine."Unit of Measure Code");
                lNewQuantity := lUnitofMeasureManagement.CalcBaseQty(lProdOrderLine."Item No.", lProdOrderLine."Variant Code",
                                                                     lProdOrderLine."Unit of Measure Code", Temp_pPordOrderLine."ecSend-Ahead Quantity",
                                                                     lProdOrderLine."Qty. per Unit of Measure",
                                                                     lItemUnitofMeasure."Qty. Rounding Precision");
            end else begin
                lNewQuantity := Temp_pPordOrderLine."ecSend-Ahead Quantity";
            end;
            //Verifico se la quantità di Send-Ahead è minore della quantità da produrre, in caso contrario non gestisco la riga e la elimino
            if (lNewQuantity < lProdOrderLine."Remaining Qty. (Base)") then begin
                lProdOrderLine.Validate(Quantity, lNewQuantity);
                lProdOrderLine.Validate("Starting Date-Time", lOriginalStartDateTime);
                lProdOrderLine.Modify(true);
            end else begin
                lProdOrderLine.Delete(true);
            end;
        until (Temp_pPordOrderLine.Next(-1) = 0);
        //CS_PRO_044-e
    end;

    internal procedure AdjProdOrderLinesDateBySendAheadQtyBackward(var pProductionOrder: Record "Production Order"; var Temp_pPordOrderLine: Record "Prod. Order Line")
    var
        lProdOrderLine: Record "Prod. Order Line";
        lProdOrderLineParent: Record "Prod. Order Line";
        lProdOrderComponent: Record "Prod. Order Component";
        lProdOrderRoutingLine: Record "Prod. Order Routing Line";
        lItemUnitofMeasure: Record "Item Unit of Measure";
        lUnitofMeasureManagement: Codeunit "Unit of Measure Management";
        lOriginalStartDateTime: DateTime;
        lNewQuantity: Decimal;
    begin
        //CS_PRO_044-s
        Clear(Temp_pPordOrderLine);
        Temp_pPordOrderLine.SetCurrentKey("ecParent Line No.");
        Temp_pPordOrderLine.SetFilter("ecSend-Ahead Quantity", '<>%1', 0);
        Temp_pPordOrderLine.FindSet();
        repeat
            lProdOrderLine.Get(pProductionOrder.Status, pProductionOrder."No.", Temp_pPordOrderLine."Line No.");
            if GetProdOrderCompLinkedToProdOrdLine(lProdOrderComponent, lProdOrderLine) then begin
                lProdOrderLineParent.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.", lProdOrderComponent."Prod. Order Line No.");
                GetProdOrderRoutingLineByRoutingLinkCode(lProdOrderLineParent, lProdOrderRoutingLine, lProdOrderComponent."Routing Link Code");
                lOriginalStartDateTime := lProdOrderRoutingLine."Starting Date-Time";
                lNewQuantity := 0;
                if (lProdOrderLine."Remaining Quantity" <> 0) then begin
                    if (lProdOrderLine.Quantity <> lProdOrderLine."Quantity (Base)") then begin
                        lItemUnitofMeasure.Get(lProdOrderLine."Item No.", lProdOrderLine."Unit of Measure Code");
                        lNewQuantity := lUnitofMeasureManagement.CalcBaseQty(lProdOrderLine."Item No.", lProdOrderLine."Variant Code",
                                                                             lProdOrderLine."Unit of Measure Code", Temp_pPordOrderLine."ecSend-Ahead Quantity",
                                                                             lProdOrderLine."Qty. per Unit of Measure",
                                                                             lItemUnitofMeasure."Qty. Rounding Precision") -
                                                                             lProdOrderLine."Remaining Quantity";
                    end else begin
                        lNewQuantity := lProdOrderLine."Remaining Quantity" - Temp_pPordOrderLine."ecSend-Ahead Quantity";
                    end;
                end;
                //Verifico se la quantità di Send-Ahead è minore della quantità da produrre, in caso contrario non gestisco la riga e la elimino
                if (lNewQuantity > 0) then begin
                    lProdOrderLine.Validate(Quantity, lNewQuantity);
                    lProdOrderLine.Validate("Starting Date-Time", lOriginalStartDateTime);
                    lProdOrderLine.Modify(true);
                end else begin
                    lProdOrderLine.Delete(true);
                end;
            end;
        until (Temp_pPordOrderLine.Next() = 0);
        //CS_PRO_044-e
    end;

    local procedure CloneProductionOrder(var pOriginProductionOrder: Record "Production Order"; pNewProdOrderNo: Code[20];
                                            pNewProdOrderStatus: Enum "Production Order Status"): Boolean
    var
        lProductionOrderDest: Record "Production Order";
        lProdOrderLineOrigin: Record "Prod. Order Line";
        lProdOrderLineDest: Record "Prod. Order Line";
        lProdOrderComponentOrigin: Record "Prod. Order Component";
        lProdOrderComponentDest: Record "Prod. Order Component";
        lProdOrderRoutingLineOrigin: Record "Prod. Order Routing Line";
        lProdOrderRoutingLineDest: Record "Prod. Order Routing Line";
        lProdOrderCapacityNeedOrigin: Record "Prod. Order Capacity Need";
        lProdOrderCapacityNeedDest: Record "Prod. Order Capacity Need";
    begin
        //CS_PRO_044-s
        Clear(lProductionOrderDest);
        lProductionOrderDest := pOriginProductionOrder;
        lProductionOrderDest.Status := pNewProdOrderStatus;
        lProductionOrderDest."No." := pNewProdOrderNo;
        lProductionOrderDest.Insert(false);

        GetProdOrderInformations(pOriginProductionOrder, lProdOrderLineOrigin, lProdOrderComponentOrigin, lProdOrderRoutingLineOrigin, lProdOrderCapacityNeedOrigin);

        if not lProdOrderLineOrigin.IsEmpty then begin
            lProdOrderLineOrigin.FindSet();
            repeat
                lProdOrderLineDest := lProdOrderLineOrigin;
                lProdOrderLineDest.Status := lProductionOrderDest.Status;
                lProdOrderLineDest."Prod. Order No." := lProductionOrderDest."No.";
                lProdOrderLineDest.Insert(false);
            until (lProdOrderLineOrigin.Next() = 0);
        end;

        if not lProdOrderComponentOrigin.IsEmpty then begin
            lProdOrderComponentOrigin.FindSet();
            repeat
                lProdOrderComponentDest := lProdOrderComponentOrigin;
                lProdOrderComponentDest.Status := lProductionOrderDest.Status;
                lProdOrderComponentDest."Prod. Order No." := lProductionOrderDest."No.";
                lProdOrderComponentDest.Insert(false);
            until (lProdOrderComponentOrigin.Next() = 0);
        end;

        if not lProdOrderRoutingLineOrigin.IsEmpty then begin
            lProdOrderRoutingLineOrigin.FindSet();
            repeat
                lProdOrderRoutingLineDest := lProdOrderRoutingLineOrigin;
                lProdOrderRoutingLineDest.Status := lProductionOrderDest.Status;
                lProdOrderRoutingLineDest."Prod. Order No." := lProductionOrderDest."No.";
                lProdOrderRoutingLineDest.Insert(false);
            until (lProdOrderRoutingLineOrigin.Next() = 0);
        end;

        if not lProdOrderCapacityNeedOrigin.IsEmpty then begin
            lProdOrderCapacityNeedOrigin.FindSet();
            repeat
                lProdOrderCapacityNeedDest := lProdOrderCapacityNeedOrigin;
                lProdOrderCapacityNeedDest.Status := lProductionOrderDest.Status;
                lProdOrderCapacityNeedDest."Prod. Order No." := lProductionOrderDest."No.";
                lProdOrderCapacityNeedDest.Insert(false);
            until (lProdOrderCapacityNeedOrigin.Next() = 0);
        end;

        exit(true);
        //CS_PRO_044-e
    end;

    local procedure GetProdOrderInformations(var pProductionOrder: Record "Production Order"; var pProdOrderLine: Record "Prod. Order Line";
                                             var pProdOrderComponent: Record "Prod. Order Component"; var pProdOrderRoutingLine: Record "Prod. Order Routing Line";
                                             var pProdOrderCapacityNeed: Record "Prod. Order Capacity Need")
    begin
        //CS_PRO_044-s
        Clear(pProdOrderLine);
        pProdOrderLine.SetRange(Status, pProductionOrder.Status);
        pProdOrderLine.SetRange("Prod. Order No.", pProductionOrder."No.");

        Clear(pProdOrderComponent);
        pProdOrderComponent.SetRange(Status, pProductionOrder.Status);
        pProdOrderComponent.SetRange("Prod. Order No.", pProductionOrder."No.");

        Clear(pProdOrderRoutingLine);
        pProdOrderRoutingLine.SetRange(Status, pProductionOrder.Status);
        pProdOrderRoutingLine.SetRange("Prod. Order No.", pProductionOrder."No.");

        Clear(pProdOrderCapacityNeed);
        pProdOrderCapacityNeed.SetRange(Status, pProductionOrder.Status);
        pProdOrderCapacityNeed.SetRange("Prod. Order No.", pProductionOrder."No.");
        //CS_PRO_044-e
    end;

    internal procedure CreateTempProdOrderNo(): Code[20]
    var
        lTempProdOrderNo: Code[20];
    begin
        //CS_PRO_044-s
        lTempProdOrderNo := Format(CurrentDateTime, 0, '<Day,2><Month,2><Year4><Hours24,2><Minutes,2><Seconds,2><Second dec>');
        lTempProdOrderNo := DelChr(lTempProdOrderNo, '=', ',');
        exit(lTempProdOrderNo);
        //CS_PRO_044-e
    end;

    internal procedure ProdOrderLineHasComponentSuppliedByLine(pProdOrderLine: Record "Prod. Order Line"; var pLinekdProdOrderLines: Record "Prod. Order Line"): Boolean
    var
        lProdOrderComponent: Record "Prod. Order Component";
    begin
        //CS_PRO_044-s
        Clear(pLinekdProdOrderLines);
        if (pProdOrderLine."Prod. Order No." = '') or (pProdOrderLine."Line No." = 0) then exit(false);

        Clear(lProdOrderComponent);
        lProdOrderComponent.SetRange(Status, pProdOrderLine.Status);
        lProdOrderComponent.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        lProdOrderComponent.SetRange("Prod. Order Line No.", pProdOrderLine."Line No.");
        lProdOrderComponent.SetFilter("Supplied-by Line No.", '<>%1', 0);
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindSet();
            repeat
                pLinekdProdOrderLines.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.", lProdOrderComponent."Supplied-by Line No.");
                pLinekdProdOrderLines.Mark(true);
            until (lProdOrderComponent.Next() = 0);

            pLinekdProdOrderLines.MarkedOnly(true);
            exit(true);
        end;

        exit(false);
        //CS_PRO_044-e
    end;

    internal procedure FinalizeProdOrderHeaderByPlanningWksh(pProductionOrder: Record "Production Order")
    var
        lProdOrderComponent: Record "Prod. Order Component";
        lProdOrderLine: Record "Prod. Order Line";
        lRequisitionLine: Record "Requisition Line";
        lItem: Record Item;
        lSku: Record "Stockkeeping Unit";
        Temp_lReservEntryBuffer: Record "AltATSReserv. Entry Backup" temporary;
        latsReservationMgt: Codeunit "AltATSReservation Mgt.";
        lecRefreshProductionOrder: Codeunit "ecRefresh Production Order";
    begin
        //CS_PRO_044-VI-s  
        // Aggiornamento ODP per generazione automatica righe secondarie
        lProdOrderLine.SetRange(Status, pProductionOrder.Status);
        lProdOrderLine.SetRange("Prod. Order No.", pProductionOrder."No.");
        if lProdOrderLine.FindFirst() then begin
            if lItem.Get(lProdOrderLine."Item No.") then begin
                lSku := lItem.GetSKU(lProdOrderLine."Location Code", lProdOrderLine."Variant Code");
                if (lSku."Manufacturing Policy" = lSku."Manufacturing Policy"::"Make-to-Order") then begin

                    // Eliminazione righe secondarie su prospetto di pianificazione
                    lProdOrderComponent.Reset();
                    lProdOrderComponent.SetRange(Status, pProductionOrder.Status);
                    lProdOrderComponent.SetRange("Prod. Order No.", pProductionOrder."No.");
                    if lProdOrderComponent.FindSet() then begin
                        repeat
                            lProdOrderComponent.CalcFields("Reserved Quantity");
                            if (lProdOrderComponent."Reserved Quantity" > 0) then begin
                                latsReservationMgt.FindProdOrderComponentReservations(lProdOrderComponent, Temp_lReservEntryBuffer);
                                Temp_lReservEntryBuffer.Reset();
                                Temp_lReservEntryBuffer.SetRange("Source Type", Database::"Requisition Line");
                                if Temp_lReservEntryBuffer.FindSet() then begin
                                    repeat
                                        if lRequisitionLine.Get(Temp_lReservEntryBuffer."Source ID",
                                                                Temp_lReservEntryBuffer."Source Batch Name",
                                                                Temp_lReservEntryBuffer."Source Ref. No.")
                                        then begin
                                            if (lRequisitionLine."Planning Level" > 0) then begin
                                                lRequisitionLine.Delete(true);
                                            end;
                                        end
                                    until (Temp_lReservEntryBuffer.Next() = 0);
                                end;
                            end;
                        until (lProdOrderComponent.Next() = 0);
                    end;

                    // Aggiornamento ODP
                    lecRefreshProductionOrder.RecreateProductionOrder(pProductionOrder, 1);
                end;
            end;
        end;
        //CS_PRO_044-VI-e
    end;

    #endregion CS_PRO_044 - Gestione della “Quantità Send-Ahead” su diverse righe dello stesso ODP

    #region CS_PRO_050 - Gestione delle discordanze quantitative

    internal procedure GetPalletBoxQuantity(pItemNo: Code[20]; pVariantCode: Code[10]; pLocationCode: Code[10]; pBinCode: Code[20]; pPalletNo: Code[50]; pBoxNo: Code[50]; pLotNo: Code[50]; pSerialNo: Code[50]): Decimal
    var
        Temp_lAWPItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary;
        lAWPLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
        lBoxNo: Code[50];
        lPalletNo: Code[50];
        lVariantCode: Code[10];
    begin
        //CS_PRO_050-s
        lVariantCode := pVariantCode;
        lPalletNo := pPalletNo;
        lBoxNo := pBoxNo;

        if (pItemNo <> '') and (pVariantCode = '') then lVariantCode := lAWPLogisticUnitsMgt.UnknownEntityIdentifier();
        if (pPalletNo = '') and (pBoxNo <> '') then lPalletNo := lAWPLogisticUnitsMgt.UnknownEntityIdentifier();
        if (pBoxNo = '') and (pPalletNo <> '') then lBoxNo := lAWPLogisticUnitsMgt.UnknownEntityIdentifier();

        lAWPLogisticUnitsMgt.FindOpenWhseEntries(pItemNo, lVariantCode, pLocationCode,
                                                 pBinCode, lPalletNo, lBoxNo, pLotNo,
                                                 pSerialNo, false, Temp_lAWPItemInventoryBuffer);

        if Temp_lAWPItemInventoryBuffer.IsEmpty then begin
            exit(0);
        end else begin
            Temp_lAWPItemInventoryBuffer.CalcSums(Quantity);
            exit(Temp_lAWPItemInventoryBuffer.Quantity);
        end;
        //CS_PRO_050-e
    end;

    internal procedure CalculateProdConsumptionCorrectionLines(var Temp_pProdConsCorrectionHeader: Record "ecProd.Cons. Correction Buffer" temporary;
                                                               var Temp_pProdConsCorrectionLines: Record "ecProd.Cons. Correction Buffer" temporary)
    var
        lProdOrderLine: Record "Prod. Order Line";
        lProdOrderComponent: Record "Prod. Order Component";
        lItemLedgerEntry: Record "Item Ledger Entry";
    begin
        //CS_PRO_050-s
        Clear(Temp_pProdConsCorrectionLines);
        Temp_pProdConsCorrectionLines.DeleteAll();

        if (Temp_pProdConsCorrectionHeader."Item No." = '') or
           (Temp_pProdConsCorrectionHeader."Qty. Delta" = 0) then begin
            exit;
        end;

        Clear(lProdOrderComponent);
        lProdOrderComponent.SetCurrentKey("Item No.", "Variant Code", "Location Code", Status, "Due Date");
        lProdOrderComponent.SetRange("Item No.", Temp_pProdConsCorrectionHeader."Item No.");
        lProdOrderComponent.SetRange("Variant Code", Temp_pProdConsCorrectionHeader."Variant Code");
        lProdOrderComponent.SetRange(Status, lProdOrderComponent.Status::Released);
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindSet();
            repeat
                if (lProdOrderComponent."Remaining Qty. (Base)" < lProdOrderComponent."Expected Qty. (Base)") then begin
                    if lProdOrderLine.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.", lProdOrderComponent."Prod. Order Line No.") and
                       (lProdOrderLine."ecProductive Status" = lProdOrderLine."ecProductive Status"::Completed)
                    then begin
                        Clear(lItemLedgerEntry);
                        lItemLedgerEntry.SetCurrentKey("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.");
                        lItemLedgerEntry.SetRange("Order Type", lItemLedgerEntry."Order Type"::Production);
                        lItemLedgerEntry.SetRange("Order No.", lProdOrderLine."Prod. Order No.");
                        lItemLedgerEntry.SetRange("Order Line No.", lProdOrderLine."Line No.");
                        lItemLedgerEntry.SetRange("Entry Type", lItemLedgerEntry."Entry Type"::Consumption);
                        lItemLedgerEntry.SetRange("Prod. Order Comp. Line No.", lProdOrderComponent."Line No.");
                        lItemLedgerEntry.SetRange("Lot No.", Temp_pProdConsCorrectionHeader."Lot No.");
                        lItemLedgerEntry.SetRange("Serial No.", Temp_pProdConsCorrectionHeader."Serial No.");
                        if not lItemLedgerEntry.IsEmpty then begin
                            lItemLedgerEntry.FindSet();
                            repeat
                                if not Temp_pProdConsCorrectionLines.Get('', lProdOrderLine.Status, lProdOrderLine."Prod. Order No.", lProdOrderLine."Line No.",
                                                                         lProdOrderComponent."Line No.")
                                then begin
                                    Temp_pProdConsCorrectionLines.Init();
                                    Temp_pProdConsCorrectionLines."Key" := '';
                                    Temp_pProdConsCorrectionLines."Prod. Order Status" := lProdOrderLine.Status;
                                    Temp_pProdConsCorrectionLines."Prod. Order No." := lProdOrderLine."Prod. Order No.";
                                    Temp_pProdConsCorrectionLines."Prod. Order Line No." := lProdOrderLine."Line No.";
                                    Temp_pProdConsCorrectionLines."Prod. Order Comp. Line No." := lProdOrderComponent."Line No.";
                                    Temp_pProdConsCorrectionLines.Insert();

                                    Temp_pProdConsCorrectionLines."Item No." := lProdOrderLine."Item No.";
                                    Temp_pProdConsCorrectionLines."Variant Code" := lProdOrderLine."Variant Code";
                                    Temp_pProdConsCorrectionLines."Qty. Consumed" := lItemLedgerEntry.Quantity * (-1);
                                    Temp_pProdConsCorrectionLines."Qty. Delta" := 0;
                                    Temp_pProdConsCorrectionLines."Qty. Adjusted" := 0;
                                    Temp_pProdConsCorrectionLines.Selected := true;
                                    Temp_pProdConsCorrectionLines.Modify();
                                end else begin
                                    Temp_pProdConsCorrectionLines."Qty. Consumed" += lItemLedgerEntry.Quantity * (-1);
                                    Temp_pProdConsCorrectionLines.Modify();
                                end;
                            until (lItemLedgerEntry.Next() = 0);
                        end;
                    end;
                end;
            until (lProdOrderComponent.Next() = 0);
        end;
        //CS_PRO_050-e
    end;

    internal procedure SplitAdjustedQtyOnConsCorrectionLines(var Temp_pProdConsCorrectionHeader: Record "ecProd.Cons. Correction Buffer" temporary;
                                                             var Temp_pProdConsCorrectionLines: Record "ecProd.Cons. Correction Buffer" temporary)
    var
        lItem: Record Item;
        Temp_lLast_ProdConsCorrectionBuffer: Record "ecProd.Cons. Correction Buffer" temporary;
        lTotalConsumedQty: Decimal;
        lDeltaProgressive: Decimal;
        lQtyToAdjust: Decimal;

        lError001: Label 'The %1 = %2 is greater than the total consumption (%3) of selected lines, it is not possible to proceed with the distribution!';
        lError002: Label 'There are no lines to perform the distribution!';
    begin
        //CS_PRO_050-s
        Clear(Temp_pProdConsCorrectionLines);
        Temp_pProdConsCorrectionLines.SetCurrentKey("Qty. Consumed");
        Temp_pProdConsCorrectionLines.SetRange(Selected, true);
        if not Temp_pProdConsCorrectionLines.IsEmpty then begin
            Temp_pProdConsCorrectionLines.FindLast();
            Temp_lLast_ProdConsCorrectionBuffer := Temp_pProdConsCorrectionLines;

            Temp_pProdConsCorrectionLines.CalcSums("Qty. Consumed");
            lTotalConsumedQty := Temp_pProdConsCorrectionLines."Qty. Consumed";
            lDeltaProgressive := Temp_pProdConsCorrectionHeader."Qty. Delta";
            if (lDeltaProgressive > 0) and (lDeltaProgressive > lTotalConsumedQty) then begin
                Error(lError001, Temp_pProdConsCorrectionHeader.FieldCaption("Qty. Delta"), Temp_pProdConsCorrectionHeader."Qty. Delta", lTotalConsumedQty);
            end;

            lItem.Get(Temp_pProdConsCorrectionHeader."Item No.");

            if not Temp_pProdConsCorrectionLines.IsEmpty then begin
                Temp_pProdConsCorrectionLines.FindSet();
                repeat
                    if not ((Temp_pProdConsCorrectionLines."Key" = Temp_lLast_ProdConsCorrectionBuffer."Key") and
                            (Temp_pProdConsCorrectionLines."Prod. Order Status" = Temp_lLast_ProdConsCorrectionBuffer."Prod. Order Status") and
                            (Temp_pProdConsCorrectionLines."Prod. Order No." = Temp_lLast_ProdConsCorrectionBuffer."Prod. Order No.") and
                            (Temp_pProdConsCorrectionLines."Prod. Order Line No." = Temp_lLast_ProdConsCorrectionBuffer."Prod. Order Line No.") and
                            (Temp_pProdConsCorrectionLines."Prod. Order Comp. Line No." = Temp_lLast_ProdConsCorrectionBuffer."Prod. Order Comp. Line No."))
                    then begin
                        lQtyToAdjust := Round(Temp_pProdConsCorrectionHeader."Qty. Delta" / 100 * (Temp_pProdConsCorrectionLines."Qty. Consumed" / lTotalConsumedQty * 100),
                                              lItem."Rounding Precision", '=');
                        lDeltaProgressive -= lQtyToAdjust;
                    end else begin
                        lQtyToAdjust := lDeltaProgressive;
                    end;
                    Temp_pProdConsCorrectionLines."Qty. Adjusted" := Temp_pProdConsCorrectionLines."Qty. Consumed" - lQtyToAdjust;
                    Temp_pProdConsCorrectionLines."Qty. Delta" := Temp_pProdConsCorrectionLines."Qty. Adjusted" - Temp_pProdConsCorrectionLines."Qty. Consumed";
                    Temp_pProdConsCorrectionLines.Modify();
                until (Temp_pProdConsCorrectionLines.Next() = 0);
            end else begin
                Error(lError002);
            end;
        end else begin
            Error(lError002);
        end;

        Clear(Temp_pProdConsCorrectionLines);
        Temp_pProdConsCorrectionLines.SetRange("Qty. Delta", 0);
        if not Temp_pProdConsCorrectionLines.IsEmpty then begin
            Temp_pProdConsCorrectionLines.ModifyAll(Selected, false);
        end;

        Temp_pProdConsCorrectionHeader."Recalculation Required" := false;
        Temp_pProdConsCorrectionHeader.Modify();
        //CS_PRO_050-e
    end;

    [CommitBehavior(CommitBehavior::Ignore)]
    internal procedure CreateAndPostProdConsCorrItemJournalLine(var Temp_pProdConsCorrectionHeader: Record "ecProd.Cons. Correction Buffer" temporary;
                                                                var Temp_pProdConsCorrectionLines: Record "ecProd.Cons. Correction Buffer" temporary;
                                                                var pTemplateName: Code[10]; var pBatchName: Code[10])
    var
        lGeneralSetup: Record "ecGeneral Setup";
        lProdOrderLine: Record "Prod. Order Line";
        lItemJournalLine: Record "Item Journal Line";
        lItemJournalBatch: Record "Item Journal Batch";
        lProdOrderComponent: Record "Prod. Order Component";
        lProductionJournalMgt: Codeunit "Production Journal Mgt";
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";

        lPostConsAdjConf: Label 'Are you sure you want to post consumption adjustments for the selected lines?';
        lError001: Label 'It is not possible to create correction lines, recalculation is required before proceeding!';
        lError002: Label 'Nothing to create!';
        lError003: Label 'Operation canceled!';
    begin
        //CS_PRO_050-s
        if not Confirm(lPostConsAdjConf) then Error(lError003);

        if Temp_pProdConsCorrectionHeader."Recalculation Required" then Error(lError001);
        Clear(Temp_pProdConsCorrectionLines);
        Temp_pProdConsCorrectionLines.SetRange(Selected, true);
        if Temp_pProdConsCorrectionLines.IsEmpty then Error(lError002);

        lGeneralSetup.Get();
        lGeneralSetup.TestField("Cons. Correction Reason Code");

        Clear(lProductionJournalMgt);
        if (pTemplateName = '') and (pBatchName = '') then begin
            pBatchName := DelChr(Format(Time), '=', ':') + '_' + Format(Random(999));
            GetTemplateAndBatch(pTemplateName, pBatchName);
        end;
        lProductionJournalMgt.InitSetupValues();

        lATSSessionDataStore.AddSessionSetting('ProductionJournalMgt_SetTemplateName', pTemplateName);
        lATSSessionDataStore.AddSessionSetting('ProductionJournalMgt_SetBatchName', pBatchName);
        lProductionJournalMgt.SetTemplateAndBatchName();
        lATSSessionDataStore.RemoveSessionSetting('ProductionJournalMgt_SetTemplateName');
        lATSSessionDataStore.RemoveSessionSetting('ProductionJournalMgt_SetBatchName');

        Temp_pProdConsCorrectionLines.FindSet();
        repeat
            lProductionJournalMgt.DeleteJnlLines(pTemplateName, pBatchName, Temp_pProdConsCorrectionLines."Prod. Order No.", Temp_pProdConsCorrectionLines."Prod. Order Line No.");
        until (Temp_pProdConsCorrectionLines.Next() = 0);

        Clear(lItemJournalLine);
        lProductionJournalMgt.SetNextLineNo(lItemJournalLine);
        Temp_pProdConsCorrectionLines.FindSet();
        repeat
            lProdOrderLine.Get(Temp_pProdConsCorrectionLines."Prod. Order Status", Temp_pProdConsCorrectionLines."Prod. Order No.",
                               Temp_pProdConsCorrectionLines."Prod. Order Line No.");
            lProdOrderComponent.Get(Temp_pProdConsCorrectionLines."Prod. Order Status", Temp_pProdConsCorrectionLines."Prod. Order No.",
                                    Temp_pProdConsCorrectionLines."Prod. Order Line No.", Temp_pProdConsCorrectionLines."Prod. Order Comp. Line No.");
            lProductionJournalMgt.InsertConsumptionItemJnlLine(lProdOrderComponent, lProdOrderLine, 0);

            lItemJournalLine.FindLast();
            if (lItemJournalLine."Location Code" <> Temp_pProdConsCorrectionHeader."Location Code") then begin
                lItemJournalLine.Validate("Location Code", Temp_pProdConsCorrectionHeader."Location Code");
            end;
            if (lItemJournalLine."Bin Code" <> Temp_pProdConsCorrectionHeader."Bin Code") then begin
                lItemJournalLine.Validate("Bin Code", Temp_pProdConsCorrectionHeader."Bin Code");
            end;
            if (Temp_pProdConsCorrectionHeader."Pallet No." <> '') then lItemJournalLine.Validate("AltAWPPallet No.", Temp_pProdConsCorrectionHeader."Pallet No.");
            if (Temp_pProdConsCorrectionHeader."Box No." <> '') then lItemJournalLine.Validate("AltAWPBox No.", Temp_pProdConsCorrectionHeader."Box No.");
            if (Temp_pProdConsCorrectionHeader."Lot No." <> '') then lItemJournalLine.Validate("AltAWPLot No.", Temp_pProdConsCorrectionHeader."Lot No.");
            if (Temp_pProdConsCorrectionHeader."Serial No." <> '') then lItemJournalLine.Validate("AltAWPSerial No.", Temp_pProdConsCorrectionHeader."Serial No.");
            if (lItemJournalLine."Unit of Measure Code" <> Temp_pProdConsCorrectionHeader."Unit of Measure Code") then begin
                lItemJournalLine.Validate("Unit of Measure Code", Temp_pProdConsCorrectionHeader."Unit of Measure Code");
            end;
            lItemJournalLine.Validate("Reason Code", lGeneralSetup."Cons. Correction Reason Code");
            lItemJournalLine.Validate(Quantity, Temp_pProdConsCorrectionLines."Qty. Delta");
            lItemJournalLine.Modify(true);
        until (Temp_pProdConsCorrectionLines.Next() = 0);

        //Registrazione righe Journal      
        Clear(lItemJournalLine);
        lItemJournalLine.SetRange("Journal Template Name", pTemplateName);
        lItemJournalLine.SetRange("Journal Batch Name", pBatchName);
        lItemJournalLine.FindFirst();
        lATSSessionDataStore.AddSessionSetting('ConsumptionCorrection_SkipCheckProductiveStatus', true);
        lATSSessionDataStore.AddSessionSetting('ItemJnlPost_HideDialog', true);
        lATSSessionDataStore.AddSessionSetting('ItemJnlPost_SuppressCommit', true);
        lItemJournalLine.PostingItemJnlFromProduction(false);
        lATSSessionDataStore.RemoveSessionSetting('ConsumptionCorrection_SkipCheckProductiveStatus');
        lATSSessionDataStore.RemoveSessionSetting('ItemJnlPost_HideDialog');
        lATSSessionDataStore.RemoveSessionSetting('ItemJnlPost_SuppressCommit');

        //Eliminazione batch temporaneo creato
        lItemJournalBatch.Get(pTemplateName, pBatchName);
        lItemJournalBatch.Delete(true);
        //CS_PRO_050-e
    end;

    local procedure GetTemplateAndBatch(var pItemJnlTemplateName: Code[10];
                                            pItemJnlBatchName: Code[10])
    var
        lItemJnlBatch: Record "Item Journal Batch";
        lItemJnlTemplate: Record "Item Journal Template";
        PageTemplate: Option Item,Transfer,"Phys. Inventory",Revaluation,Consumption,Output,Capacity,"Prod. Order";
        lText000: Label '%1 journal', Locked = true;
    begin
        //CS_PRO_050-s
        lItemJnlTemplate.Reset();
        lItemJnlTemplate.SetRange("Page ID", Page::"Production Journal");
        lItemJnlTemplate.SetRange(Recurring, false);
        lItemJnlTemplate.SetRange(Type, PageTemplate::"Prod. Order");
        if not lItemJnlTemplate.FindFirst() then begin
            lItemJnlTemplate.Init();
            lItemJnlTemplate.Recurring := false;
            lItemJnlTemplate.Validate(Type, PageTemplate::"Prod. Order");
            lItemJnlTemplate.Validate("Page ID");

            lItemJnlTemplate.Name := Format(lItemJnlTemplate.Type, MaxStrLen(lItemJnlTemplate.Name));
            lItemJnlTemplate.Description := StrSubstNo(lText000, lItemJnlTemplate.Type);
            lItemJnlTemplate.Insert();
        end;
        pItemJnlTemplateName := lItemJnlTemplate.Name;

        lItemJnlBatch.Init();
        lItemJnlBatch."Journal Template Name" := lItemJnlTemplate.Name;
        lItemJnlBatch.SetupNewBatch();
        lItemJnlBatch.Name := pItemJnlBatchName;
        lItemJnlBatch.Description := 'XXX';
        lItemJnlBatch.Insert(true);
        //CS_PRO_050-e
    end;

    #endregion CS_PRO_050 - Gestione delle discordanze quantitative
}
