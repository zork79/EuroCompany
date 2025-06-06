namespace EuroCompany.BaseApp.Inventory.Reservation;

using Microsoft.Foundation.Enums;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Transfer;
using Microsoft.Manufacturing.Document;
using Microsoft.Purchases.Document;
using Microsoft.Sales.Document;

codeunit 50002 "ecReservation Functions"
{
    Permissions = tabledata "Reservation Entry" = rimd,
                  tabledata "Production Order" = rimd,
                  tabledata "Prod. Order Line" = rimd;

    var
        xReservTransactionRef: Text;
        xManualReservTransaction: Boolean;


    #region CS_PRO_044 - Gestione della "Quantitià Send-Ahead" su diverse righe dello stesso ODP

    internal procedure BackupAndRemoveProdOrderReservations(pProductionOrder: Record "Production Order";
                                                            pClearTrackingInfo: Boolean;
                                                            pTransactionRef: Text)
    var
        lProdOrderLine: Record "Prod. Order Line";
    begin
        //CS_PRO_044-s
        lProdOrderLine.Reset();
        lProdOrderLine.SetRange(Status, pProductionOrder.Status);
        lProdOrderLine.SetRange("Prod. Order No.", pProductionOrder."No.");
        if not lProdOrderLine.IsEmpty then begin
            lProdOrderLine.FindSet();
            repeat
                BackupAndRemoveProdOrderLineReservations(lProdOrderLine, pClearTrackingInfo, pTransactionRef);
            until (lProdOrderLine.Next() = 0);
        end;
        //CS_PRO_044-e
    end;

    internal procedure BackupAndRemoveProdOrderLineReservations(pProdOrderLine: Record "Prod. Order Line";
                                                                pClearTrackingInfo: Boolean;
                                                                pTransactionRef: Text)
    begin
        //CS_PRO_044-s
        BackupProdOrderLineReservations(pProdOrderLine, pClearTrackingInfo, pTransactionRef);
        RemoveProdOrderLineReservations(pProdOrderLine, pTransactionRef);
        //CS_PRO_044-e
    end;

    internal procedure BackupProdOrderLineReservations(pProdOrderLine: Record "Prod. Order Line";
                                                       pClearTrackingInfo: Boolean;
                                                       pTransactionRef: Text)
    var
        Temp_lReservEntryBackup: Record "AltATSReserv. Entry Backup" temporary;
        lSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_PRO_044-s
        Clear(Temp_lReservEntryBackup);
        Clear(lSessionDataStore);
        lSessionDataStore.CopyReservEntryBackupInstance(Temp_lReservEntryBackup);

        Temp_lReservEntryBackup.Reset();
        Temp_lReservEntryBackup.ApplyMasterProdOrderLineFilters(pProdOrderLine);

        GetProdOrderLineReservations(pProdOrderLine, Temp_lReservEntryBackup, pClearTrackingInfo, pTransactionRef);
        //CS_PRO_044-e
    end;

    internal procedure RemoveProdOrderLineReservations(pProdOrderLine: Record "Prod. Order Line"; pTransactionRef: Text)
    var
        lReservationEntry: Record "Reservation Entry";
        lReservationEntry2: Record "Reservation Entry";
        Temp_lTrackingSpecification: Record "Tracking Specification" temporary;
        lReservationEngineMgt: Codeunit "Reservation Engine Mgt.";
        lReservationManagement: Codeunit "Reservation Management";
    begin
        //CS_PRO_044-s
        if (pTransactionRef <> '') then SetReservTransactionRef(pTransactionRef, false);

        pProdOrderLine.SetReservationFilters(lReservationEntry);
        lReservationEntry.SetRange("Reservation Status", lReservationEntry."Reservation Status"::Reservation);
        if not lReservationEntry.IsEmpty then begin
            lReservationEntry.Find('-');
            repeat
                Clear(lReservationEngineMgt);
                lReservationEngineMgt.CancelReservation(lReservationEntry);
            until (lReservationEntry.Next() = 0);
        end;

        lReservationEntry.SetRange("Reservation Status");
        if not lReservationEntry.IsEmpty then begin
            lReservationEntry.FindSet();
            repeat
                lReservationEntry2 := lReservationEntry;
                lReservationEntry2.ClearItemTrackingFields();
                lReservationEntry2.Modify();
            until (lReservationEntry.Next() = 0);


            Temp_lTrackingSpecification.InitFromProdOrderLine(pProdOrderLine);

            Clear(lReservationManagement);
            lReservationManagement.SetCalcReservEntry(Temp_lTrackingSpecification, lReservationEntry2);
            lReservationManagement.DeleteReservEntries(true, 0);
        end;

        if (pTransactionRef <> '') then ResetReservTransactionRef();
        //CS_PRO_044-e
    end;

    internal procedure RestoreProdOrderReservations(pProductionOrder: Record "Production Order";
                                                    pTransactionRef: Text;
                                                    pRestoreAll: Boolean)
    var
        lProdOrderLine: Record "Prod. Order Line";
    begin
        //CS_PRO_044-s
        lProdOrderLine.Reset();
        lProdOrderLine.SetRange(Status, pProductionOrder.Status);
        lProdOrderLine.SetRange("Prod. Order No.", pProductionOrder."No.");
        if not lProdOrderLine.IsEmpty then begin
            lProdOrderLine.FindSet();
            repeat
                RestoreProdOrderLineReservations(lProdOrderLine, pTransactionRef, pRestoreAll);
            until (lProdOrderLine.Next() = 0);
        end;
        //CS_PRO_044-e
    end;

    internal procedure RestoreProdOrderLineReservations(pProdOrderLine: Record "Prod. Order Line";
                                                        pTransactionRef: Text;
                                                        pRestoreAll: Boolean)
    var
        Temp_lReservEntryBackup: Record "AltATSReserv. Entry Backup" temporary;
        lSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_PRO_044-s
        Clear(Temp_lReservEntryBackup);
        lSessionDataStore.CopyReservEntryBackupInstance(Temp_lReservEntryBackup);

        Temp_lReservEntryBackup.Reset();
        Temp_lReservEntryBackup.ApplyMasterProdOrderLineFilters(pProdOrderLine);
        if not pRestoreAll then Temp_lReservEntryBackup.SetRange("Transaction Ref.", pTransactionRef);

        Temp_lReservEntryBackup.ResetRestoredStatus();

        Temp_lReservEntryBackup.SetCurrentKey("Reservation Status", "Shipment Date", "Expected Receipt Date", "Serial No.", "Lot No.");

        // Impegni make-to-order
        Temp_lReservEntryBackup.SetRange("Reservation Status", Temp_lReservEntryBackup."Reservation Status"::Reservation);
        Temp_lReservEntryBackup.SetRange(Binding, Temp_lReservEntryBackup.Binding::"Order-to-Order");
        if not Temp_lReservEntryBackup.IsEmpty then begin
            ApplyReservOnProdOrderLine(pProdOrderLine, Temp_lReservEntryBackup, pTransactionRef);
        end;

        // Impegni
        Temp_lReservEntryBackup.SetRange(Binding);
        if not Temp_lReservEntryBackup.IsEmpty then begin
            ApplyReservOnProdOrderLine(pProdOrderLine, Temp_lReservEntryBackup, pTransactionRef);
        end;

        // Tracciabilità ordine
        Temp_lReservEntryBackup.SetRange("Reservation Status", Temp_lReservEntryBackup."Reservation Status"::Tracking);
        if not Temp_lReservEntryBackup.IsEmpty then begin
            ApplyReservOnProdOrderLine(pProdOrderLine, Temp_lReservEntryBackup, pTransactionRef);
        end;

        // Altro
        Temp_lReservEntryBackup.SetRange("Reservation Status");
        if not Temp_lReservEntryBackup.IsEmpty then begin
            ApplyReservOnProdOrderLine(pProdOrderLine, Temp_lReservEntryBackup, pTransactionRef);
        end;

        Temp_lReservEntryBackup.Reset();
        Temp_lReservEntryBackup.ApplyMasterProdOrderLineFilters(pProdOrderLine);
        if not pRestoreAll then Temp_lReservEntryBackup.SetRange("Transaction Ref.", pTransactionRef);
        if not Temp_lReservEntryBackup.IsEmpty then begin
            Temp_lReservEntryBackup.DeleteAll(false);
        end;
        //CS_PRO_044-e
    end;

    internal procedure GetProdOrderLineReservations(pProdOrderLine: Record "Prod. Order Line";
                                                    var Temp_pReservEntryBackup: Record "AltATSReserv. Entry Backup" temporary;
                                                    pClearTrackingInfo: Boolean;
                                                    pTransactionRef: Text): Boolean
    var
        lReservationEntry: Record "Reservation Entry";
        lReservationEntry2: Record "Reservation Entry";
        lProdOrderLineReserve: Codeunit "Prod. Order Line-Reserve";
        lContinue: Boolean;
    begin
        //CS_PRO_044-s
        Clear(lProdOrderLineReserve);
        lProdOrderLineReserve.FindReservEntry(pProdOrderLine, lReservationEntry);
        lReservationEntry.SetFilter("Reservation Status", '%1|%2', lReservationEntry."Reservation Status"::Reservation,
                                                                   lReservationEntry."Reservation Status"::Tracking);
        if not lReservationEntry.IsEmpty then begin
            lReservationEntry.FindSet();
            repeat
                if not Temp_pReservEntryBackup.Get(lReservationEntry."Entry No.") then begin
                    lContinue := true;
                    if (lReservationEntry."Reservation Status" = lReservationEntry."Reservation Status"::Tracking) then begin
                        lContinue := false;
                        if lReservationEntry2.Get(lReservationEntry."Entry No.", not lReservationEntry.Positive) then begin
                            lContinue := (lReservationEntry2."Source Type" in [Database::"Sales Line", Database::"Transfer Line"]);
                        end;
                    end;

                    if lContinue then begin
                        if lReservationEntry2.Get(lReservationEntry."Entry No.", not lReservationEntry.Positive) then begin
                            Temp_pReservEntryBackup.TransferFields(lReservationEntry2, true);

                            if pClearTrackingInfo then begin
                                Temp_pReservEntryBackup.ClearTrackingInfo();
                            end;

                            Temp_pReservEntryBackup.SetMasterProdOrderLineRef(pProdOrderLine);
                            Temp_pReservEntryBackup."Transaction Ref." := CopyStr(pTransactionRef, 1, MaxStrLen(Temp_pReservEntryBackup."Transaction Ref."));
                            Temp_pReservEntryBackup.Insert(false);
                        end;
                    end;
                end;
            until (lReservationEntry.Next() = 0);
        end;
        //CS_PRO_044-e
    end;

    internal procedure SetReservTransactionRef(pTransactionRef: Text; pManualReservTransaction: Boolean)
    var
        lawpReservRegisterMgt: Codeunit "AltAWPReserv.Register Mgt.";
    begin
        //CS_PRO_044-s
        xReservTransactionRef := lawpReservRegisterMgt.GetReservTransactionRef();
        xManualReservTransaction := lawpReservRegisterMgt.IsManualReservTransaction();

        if (pTransactionRef <> '') then lawpReservRegisterMgt.SetReservTransactionRef(pTransactionRef, pManualReservTransaction, true);
        //CS_PRO_044-e
    end;

    internal procedure ResetReservTransactionRef()
    var
        lawpReservRegisterMgt: Codeunit "AltAWPReserv.Register Mgt.";
    begin
        //CS_PRO_044-s
        lawpReservRegisterMgt.SetReservTransactionRef(xReservTransactionRef, xManualReservTransaction, true);
        //CS_PRO_044-e
    end;

    local procedure ApplyReservOnProdOrderLine(pProdOrderLine: Record "Prod. Order Line";
                                               var Temp_pReservEntryBackup: Record "AltATSReserv. Entry Backup" temporary;
                                               pTransactionRef: Text)
    var
        Temp_lReservEntryBackup2: Record "AltATSReserv. Entry Backup" temporary;
        lReservEntryTrkInfo: Record "Reservation Entry";
        lForTrackingSpec: Record "Tracking Specification";
        lFromTrackingSpec: Record "Tracking Specification";
        lUoMMgt: Codeunit "Unit of Measure Management";
        lCreateReservEntry: Codeunit "Create Reserv. Entry";
        lMaxQtyToReserve: Decimal;
        lCurrQtyBase: Decimal;
        lCurrQty: Decimal;
        lShipmentDate: Date;

    begin
        //CS_PRO_044-s
        if (pTransactionRef <> '') then SetReservTransactionRef(pTransactionRef, false);

        pProdOrderLine.CalcFields("Reserved Qty. (Base)");
        lMaxQtyToReserve := (pProdOrderLine."Quantity (Base)" - pProdOrderLine."Reserved Qty. (Base)");

        if (lMaxQtyToReserve <> 0) then begin
            Clear(Temp_lReservEntryBackup2);
            Temp_lReservEntryBackup2.Copy(Temp_pReservEntryBackup, true);

            Temp_lReservEntryBackup2.ApplyMasterProdOrderLineFilters(pProdOrderLine);
            Temp_lReservEntryBackup2.ResetRestoredStatus();
            Temp_lReservEntryBackup2.SetRange(Positive, false);
            if Temp_lReservEntryBackup2.FindSet() then begin
                repeat
                    lCurrQtyBase := Abs(Temp_lReservEntryBackup2."Quantity (Base)");
                    if (lCurrQtyBase > lMaxQtyToReserve) then begin
                        lCurrQtyBase := lMaxQtyToReserve;
                    end;

                    lCurrQty := lUoMMgt.CalcQtyFromBase(lCurrQtyBase, Temp_lReservEntryBackup2."Qty. per Unit of Measure");

                    if (lCurrQty <> 0) then begin
                        lShipmentDate := pProdOrderLine."Due Date";

                        Clear(lCreateReservEntry);
                        lCreateReservEntry.SetBinding(Temp_lReservEntryBackup2.Binding);
                        lCreateReservEntry.SetDates(Temp_lReservEntryBackup2."Warranty Date", Temp_lReservEntryBackup2."Expiration Date");
                        lCreateReservEntry.SetPlanningFlexibility(Temp_lReservEntryBackup2."Planning Flexibility");

                        Clear(lForTrackingSpec);
                        lForTrackingSpec."Serial No." := Temp_lReservEntryBackup2."Serial No.";
                        lForTrackingSpec."Lot No." := Temp_lReservEntryBackup2."Lot No.";
                        lForTrackingSpec."Warranty Date" := Temp_lReservEntryBackup2."Warranty Date";
                        lForTrackingSpec."Expiration Date" := Temp_lReservEntryBackup2."Expiration Date";

                        lForTrackingSpec."New Serial No." := Temp_lReservEntryBackup2."New Serial No.";
                        lForTrackingSpec."New Lot No." := Temp_lReservEntryBackup2."New Lot No.";
                        lCreateReservEntry.SetNewTrackingFromNewTrackingSpecification(lForTrackingSpec);

                        lReservEntryTrkInfo.CopyTrackingFromSpec(lForTrackingSpec);

                        lCreateReservEntry.CreateReservEntryFor(Temp_lReservEntryBackup2."Source Type", Temp_lReservEntryBackup2."Source Subtype",
                                                                Temp_lReservEntryBackup2."Source ID", Temp_lReservEntryBackup2."Source Batch Name",
                                                                Temp_lReservEntryBackup2."Source Prod. Order Line", Temp_lReservEntryBackup2."Source Ref. No.",
                                                                Temp_lReservEntryBackup2."Qty. per Unit of Measure", lCurrQty, lCurrQtyBase,
                                                                lReservEntryTrkInfo);

                        lFromTrackingSpec.InitFromProdOrderLine(pProdOrderLine);
                        lFromTrackingSpec.CopyTrackingFromTrackingSpec(lForTrackingSpec);
                        lCreateReservEntry.CreateReservEntryFrom(lFromTrackingSpec);

                        lCreateReservEntry.CreateReservEntry(pProdOrderLine."Item No.", pProdOrderLine."Variant Code", pProdOrderLine."Location Code",
                                                             pProdOrderLine.Description, pProdOrderLine."Due Date", lShipmentDate);

                        lMaxQtyToReserve -= lCurrQtyBase;

                        Temp_lReservEntryBackup2.Restored := true;
                        Temp_lReservEntryBackup2.Modify();
                    end;
                until (Temp_lReservEntryBackup2.Next() = 0) or (lMaxQtyToReserve = 0);
            end;
        end;

        Temp_lReservEntryBackup2.SetRange(Restored, true);
        if not Temp_lReservEntryBackup2.IsEmpty then begin
            Temp_lReservEntryBackup2.DeleteAll();
        end;
        Temp_lReservEntryBackup2.SetRange(Restored);

        if (pTransactionRef <> '') then ResetReservTransactionRef();
        //CS_PRO_044-e
    end;

    internal procedure CalcReservQty(var pReservationEntry: Record "Reservation Entry"; pNewDate: Date): Decimal
    var
        lReservationEntry2: Record "Reservation Entry";
        lCreateReservEntry: Codeunit "Create Reserv. Entry";
        lReservDueDate: Date;
        lReservExpectDate: Date;
        lSumValue: Decimal;
    begin
        //CS_PRO_044-s
        lReservationEntry2.Copy(pReservationEntry);
        lReservDueDate := pNewDate;
        lReservExpectDate := pNewDate;

        if not lReservationEntry2.Find('-') then
            exit(0);
        if lReservationEntry2."Quantity (Base)" < 0 then
            lReservExpectDate := 0D
        else
            lReservDueDate := DMY2Date(31, 12, 9999);

        repeat
            lSumValue += lReservationEntry2."Quantity (Base)";
            if lReservationEntry2."Quantity (Base)" < 0 then begin
                if lReservationEntry2."Expected Receipt Date" <> 0D then  // Item ledger entries will be 0D.
                    if (lReservationEntry2."Expected Receipt Date" > lReservExpectDate) and
                       (lReservationEntry2."Expected Receipt Date" > lReservDueDate)
                    then
                        lReservExpectDate := lReservationEntry2."Expected Receipt Date";
            end else
                if lReservationEntry2."Shipment Date" <> 0D then          // Item ledger entries will be 0D.
                    if (lReservationEntry2."Shipment Date" < lReservDueDate) and (lReservationEntry2."Shipment Date" < lReservExpectDate) then
                        lReservDueDate := lReservationEntry2."Shipment Date";
        until lReservationEntry2.Next() = 0;

        exit(lCreateReservEntry.SignFactor(lReservationEntry2) * lSumValue);
        //CS_PRO_044-e
    end;

    internal procedure GetProdOrderCompReservations(pProdOrderComponent: Record "Prod. Order Component";
                                                    var Temp_pReservEntryBackup: Record "AltATSReserv. Entry Backup" temporary;
                                                    pClearTrackingInfo: Boolean;
                                                    pTransactionRef: Text)
    var
        lReservationEntry: Record "Reservation Entry";
        lReservationEntry2: Record "Reservation Entry";
        lProdOrderCompReserve: Codeunit "Prod. Order Comp.-Reserve";
        lContinue: Boolean;
    begin
        //CS_PRO_044-s
        Clear(lProdOrderCompReserve);
        lProdOrderCompReserve.FindReservEntry(pProdOrderComponent, lReservationEntry);
        lReservationEntry.SetFilter("Reservation Status", '%1|%2', lReservationEntry."Reservation Status"::Reservation,
                                                                   lReservationEntry."Reservation Status"::Tracking);
        if not lReservationEntry.IsEmpty then begin
            lReservationEntry.FindSet();
            repeat
                if not Temp_pReservEntryBackup.Get(lReservationEntry."Entry No.") then begin
                    lContinue := true;
                    if (lReservationEntry."Reservation Status" = lReservationEntry."Reservation Status"::Tracking) then begin
                        lContinue := false;
                        if lReservationEntry2.Get(lReservationEntry."Entry No.", not lReservationEntry.Positive) then begin
                            lContinue := (lReservationEntry2."Source Type" in [Database::"Sales Line", Database::"Transfer Line"]);
                        end;
                    end;

                    if lContinue then begin
                        if lReservationEntry2.Get(lReservationEntry."Entry No.", not lReservationEntry.Positive) then begin
                            Temp_pReservEntryBackup.TransferFields(lReservationEntry2, true);

                            if pClearTrackingInfo then begin
                                Temp_pReservEntryBackup.ClearTrackingInfo();
                            end;

                            Temp_pReservEntryBackup."Transaction Ref." := CopyStr(pTransactionRef, 1, MaxStrLen(Temp_pReservEntryBackup."Transaction Ref."));
                            Temp_pReservEntryBackup.Insert(false);
                        end;
                    end;
                end;
            until (lReservationEntry.Next() = 0);
        end;
        //CS_PRO_044-e
    end;

    internal procedure BackupAndRemoveProdOrderCompReservations(pProdOrderLine: Record "Prod. Order Line";
                                                                var Temp_pComponentReservBackup: Record "Reservation Entry" temporary)
    begin
        //CS_PRO_044-s
        BackupProdOrderCompReservation(pProdOrderLine, Temp_pComponentReservBackup);
        RemoveProdOrderComponentReservations(Temp_pComponentReservBackup);
        //CS_PRO_044-e
    end;

    internal procedure BackupProdOrderCompReservation(var pProdOrderLine: Record "Prod. Order Line"; var Temp_pComponentReservBackup: Record "Reservation Entry" temporary)
    var
        lProdOrderComponent: Record "Prod. Order Component";
        lReservationEntry: Record "Reservation Entry";
        lReservationEntry2: Record "Reservation Entry";
        lProdOrderCompReserve: Codeunit "Prod. Order Comp.-Reserve";
    begin
        //CS_PRO_044-s
        Clear(Temp_pComponentReservBackup);
        Temp_pComponentReservBackup.DeleteAll();

        Clear(lProdOrderComponent);
        lProdOrderComponent.SetRange(Status, pProdOrderLine.Status);
        lProdOrderComponent.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        lProdOrderComponent.SetRange("Prod. Order Line No.", pProdOrderLine."Line No.");
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindSet();
            repeat
                lProdOrderCompReserve.FindReservEntry(lProdOrderComponent, lReservationEntry);
                lReservationEntry.SetRange("Reservation Status", lReservationEntry."Reservation Status"::Reservation);
                if not lReservationEntry.IsEmpty then begin
                    lReservationEntry.FindSet();
                    repeat
                        lReservationEntry2.Get(lReservationEntry."Entry No.", not lReservationEntry.Positive);
                        if (lReservationEntry2."Source Type" in [Database::"Purchase Line",
                                                                 Database::"Transfer Line",
                                                                 Database::"Prod. Order Line"])
                        then begin
                            Temp_pComponentReservBackup := lReservationEntry;
                            Temp_pComponentReservBackup.Insert(false);

                            Temp_pComponentReservBackup := lReservationEntry2;
                            Temp_pComponentReservBackup.Insert(false);
                        end;
                    until (lReservationEntry.Next() = 0);
                end;
            until (lProdOrderComponent.Next() = 0);
        end;
        //CS_PRO_044-e
    end;

    internal procedure RemoveProdOrderComponentReservations(var Temp_pComponentReservBackup: Record "Reservation Entry" temporary)
    var
        lReservationEntry: Record "Reservation Entry";
        lReservationEngineMgt: Codeunit "Reservation Engine Mgt.";
    begin
        //CS_PRO_044-s
        Clear(Temp_pComponentReservBackup);
        Temp_pComponentReservBackup.SetRange("Reservation Status", Temp_pComponentReservBackup."Reservation Status"::Reservation);
        if not Temp_pComponentReservBackup.IsEmpty then begin
            Temp_pComponentReservBackup.FindSet();
            repeat
                if lReservationEntry.Get(Temp_pComponentReservBackup."Entry No.", Temp_pComponentReservBackup.Positive) then begin
                    lReservationEngineMgt.CancelReservation(lReservationEntry);
                end;
            until (Temp_pComponentReservBackup.Next() = 0);
        end;
        //CS_PRO_044-e
    end;

    internal procedure TryToRestoreProdOrderCompReservation(pProdOrderLine: Record "Prod. Order Line";
                                                            var Temp_pComponentReservBackup: Record "Reservation Entry" temporary)
    var
        lPurchaseLine: Record "Purchase Line";
        lTransferLine: Record "Transfer Line";
        lProdOrderLine: Record "Prod. Order Line";
        lProdOrderComponent: Record "Prod. Order Component";
        Temp_lReservEntryBackup: Record "Reservation Entry" temporary;
        lRestoreReservation: Boolean;
    begin
        //CS_PRO_044-s
        CopyTempReservationEntry(Temp_pComponentReservBackup, Temp_lReservEntryBackup);

        Clear(Temp_pComponentReservBackup);
        Temp_pComponentReservBackup.SetRange("Source Type", Database::"Prod. Order Component");
        Temp_pComponentReservBackup.SetRange("Reservation Status", Temp_pComponentReservBackup."Reservation Status"::Reservation);
        if not Temp_pComponentReservBackup.IsEmpty then begin
            Temp_pComponentReservBackup.FindSet();
            repeat
                lRestoreReservation := false;
                Temp_lReservEntryBackup.Get(Temp_pComponentReservBackup."Entry No.", not Temp_pComponentReservBackup.Positive);
                if lProdOrderComponent.Get(Temp_pComponentReservBackup."Source Subtype", Temp_pComponentReservBackup."Source ID",
                                           Temp_pComponentReservBackup."Source Prod. Order Line", Temp_pComponentReservBackup."Source Ref. No.")
                then begin
                    case Temp_lReservEntryBackup."Source Type" of
                        Database::"Purchase Line":
                            begin
                                if lPurchaseLine.Get(Temp_lReservEntryBackup."Source Subtype", Temp_lReservEntryBackup."Source ID",
                                                     Temp_lReservEntryBackup."Source Ref. No.")
                                then begin
                                    lRestoreReservation := (lPurchaseLine."Expected Receipt Date" <= lProdOrderComponent."Due Date");
                                end;
                            end;
                        Database::"Transfer Line":
                            begin
                                if lTransferLine.Get(Temp_lReservEntryBackup."Source ID", Temp_lReservEntryBackup."Source Ref. No.") then begin
                                    lRestoreReservation := (lTransferLine."Receipt Date" <= lProdOrderComponent."Due Date");
                                end;
                            end;
                        Database::"Prod. Order Line":
                            begin
                                if lProdOrderLine.Get(Temp_lReservEntryBackup."Source Subtype", Temp_lReservEntryBackup."Source ID",
                                                      Temp_lReservEntryBackup."Source Prod. Order Line")
                                then begin
                                    lRestoreReservation := (lProdOrderLine."Due Date" <= lProdOrderComponent."Due Date");
                                end;
                            end;
                        else begin
                            lRestoreReservation := false;
                        end;
                    end;
                end else begin
                    lRestoreReservation := false;
                end;

                if lRestoreReservation then begin
                    ApplyReservOnProdOrderComponent(lProdOrderComponent, Temp_lReservEntryBackup);
                end;
            until (Temp_pComponentReservBackup.Next() = 0);
        end;
        //CS_PRO_044-e
    end;

    local procedure CopyTempReservationEntry(var Temp_pSourceComponentReservBackup: Record "Reservation Entry" temporary;
                                             var Temp_pNewComponentReservBackup: Record "Reservation Entry" temporary)
    var
        Temp_lComponentReservBackup2: Record "Reservation Entry" temporary;
    begin
        //CS_PRO_044-s
        Clear(Temp_pNewComponentReservBackup);
        Temp_pNewComponentReservBackup.DeleteAll();

        Temp_lComponentReservBackup2 := Temp_pSourceComponentReservBackup;
        Clear(Temp_pSourceComponentReservBackup);
        if not Temp_pSourceComponentReservBackup.IsEmpty then begin
            Temp_pSourceComponentReservBackup.FindSet();
            repeat
                Temp_pNewComponentReservBackup := Temp_pSourceComponentReservBackup;
                Temp_pNewComponentReservBackup.Insert(false);
            until (Temp_pSourceComponentReservBackup.Next() = 0);

            Temp_pSourceComponentReservBackup.Get(Temp_lComponentReservBackup2."Entry No.", Temp_lComponentReservBackup2.Positive);
        end;
        //CS_PRO_044-e
    end;

    local procedure ApplyReservOnProdOrderComponent(var pProdOrderComponent: Record "Prod. Order Component";
                                                    var Temp_pComponentReservBackup: Record "Reservation Entry" temporary)
    var
        lPurchaseLine: Record "Purchase Line";
        lTransferLine: Record "Transfer Line";
        lProdOrderLine: Record "Prod. Order Line";
        Temp_lComponentReservBackupCopy: Record "Reservation Entry" temporary;
        lReservEntryTrkInfo: Record "Reservation Entry";
        lFromTrackingSpec: Record "Tracking Specification";
        lUoMMgt: Codeunit "Unit of Measure Management";
        lCreateReservEntry: Codeunit "Create Reserv. Entry";
        lMaxQtyToReserve: Decimal;
        lCurrQtyBase: Decimal;
        lCurrQty: Decimal;
        lReceiptDate: Date;
    begin
        //CS_PRO_044-s        
        CopyTempReservationEntry(Temp_pComponentReservBackup, Temp_lComponentReservBackupCopy);

        case Temp_pComponentReservBackup."Source Type" of
            Database::"Purchase Line":
                begin
                    lPurchaseLine.Get(Temp_pComponentReservBackup."Source Subtype", Temp_pComponentReservBackup."Source ID",
                                      Temp_pComponentReservBackup."Source Ref. No.");
                    lPurchaseLine.CalcFields("Reserved Qty. (Base)");
                    lMaxQtyToReserve := (lPurchaseLine."Outstanding Qty. (Base)" - lPurchaseLine."Reserved Qty. (Base)");
                end;
            Database::"Transfer Line":
                begin
                    lTransferLine.Get(Temp_pComponentReservBackup."Source ID", Temp_pComponentReservBackup."Source Ref. No.");
                    lTransferLine.CalcFields("Reserved Qty. Inbnd. (Base)");
                    lMaxQtyToReserve := (lTransferLine."Outstanding Qty. (Base)" - lTransferLine."Reserved Qty. Inbnd. (Base)");
                end;
            Database::"Prod. Order Line":
                begin
                    lProdOrderLine.Get(Temp_pComponentReservBackup."Source Subtype", Temp_pComponentReservBackup."Source ID",
                                       Temp_pComponentReservBackup."Source Prod. Order Line");
                    lProdOrderLine.CalcFields("Reserved Qty. (Base)");
                    lMaxQtyToReserve := lProdOrderLine."Remaining Qty. (Base)" - lProdOrderLine."Reserved Qty. (Base)";
                end;
            else begin
                exit;
            end;
        end;

        if (lMaxQtyToReserve <> 0) then begin
            Temp_lComponentReservBackupCopy.Get(Temp_pComponentReservBackup."Entry No.", not Temp_pComponentReservBackup.Positive);

            lCurrQtyBase := Abs(Temp_pComponentReservBackup."Quantity (Base)");

            if (lCurrQtyBase > lMaxQtyToReserve) then begin
                lCurrQtyBase := lMaxQtyToReserve;
            end;

            lCurrQty := lUoMMgt.CalcQtyFromBase(lCurrQtyBase, Temp_lComponentReservBackupCopy."Qty. per Unit of Measure");
            if (lCurrQty <> 0) then begin
                Clear(lCreateReservEntry);
                lCreateReservEntry.SetBinding(Temp_lComponentReservBackupCopy.Binding);
                lCreateReservEntry.SetDates(Temp_lComponentReservBackupCopy."Warranty Date", Temp_lComponentReservBackupCopy."Expiration Date");
                lCreateReservEntry.SetPlanningFlexibility(Temp_lComponentReservBackupCopy."Planning Flexibility");

                lCreateReservEntry.CreateReservEntryFor(Temp_lComponentReservBackupCopy."Source Type", Temp_lComponentReservBackupCopy."Source Subtype",
                                                        Temp_lComponentReservBackupCopy."Source ID", Temp_lComponentReservBackupCopy."Source Batch Name",
                                                        Temp_lComponentReservBackupCopy."Source Prod. Order Line", Temp_lComponentReservBackupCopy."Source Ref. No.",
                                                        Temp_lComponentReservBackupCopy."Qty. per Unit of Measure", lCurrQty, lCurrQtyBase,
                                                        lReservEntryTrkInfo);
                case Temp_pComponentReservBackup."Source Type" of
                    Database::"Purchase Line":
                        begin
                            lFromTrackingSpec.InitFromPurchLine(lPurchaseLine);
                            lReceiptDate := lPurchaseLine."Expected Receipt Date";
                        end;
                    Database::"Transfer Line":
                        begin
                            lFromTrackingSpec.InitFromTransLine(lTransferLine, lTransferLine."Receipt Date", Enum::"Transfer Direction"::Inbound);
                            lReceiptDate := lTransferLine."Receipt Date";
                        end;
                    Database::"Prod. Order Line":
                        begin
                            lFromTrackingSpec.InitFromProdOrderLine(lProdOrderLine);
                            lReceiptDate := lProdOrderLine."Due Date";
                        end;
                end;
                lFromTrackingSpec.CopyTrackingFromTrackingSpec(lFromTrackingSpec);
                lCreateReservEntry.CreateReservEntryFrom(lFromTrackingSpec);
                lCreateReservEntry.CreateReservEntry(pProdOrderComponent."Item No.", pProdOrderComponent."Variant Code", pProdOrderComponent."Location Code",
                                                     pProdOrderComponent.Description, lReceiptDate, pProdOrderComponent."Due Date");
            end;
        end;
        //CS_PRO_044-e
    end;

    #endregion CS_PRO_044 - Gestione della "Quantitià Send-Ahead" su diverse righe dello stesso ODP
}