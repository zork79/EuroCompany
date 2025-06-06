namespace EuroCompany.BaseApp.Manufacturing;

using EuroCompany.BaseApp.Inventory.Reservation;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.Manufacturing.Document;
using Microsoft.Manufacturing.Family;
using Microsoft.Warehouse.Activity;

codeunit 50017 "ecRefresh Production Order"
{
    internal procedure RecreateProductionOrder(var pProductionOrder: Record "Production Order";
                                               pCalcDirection: Option Forward,Backward)
    var
        lProdOrderLine: Record "Prod. Order Line";
        lCreateProdOrderLines: Codeunit "Create Prod. Order Lines";
        lProdOrderStatusMgt: Codeunit "Prod. Order Status Management";
        lWhseProdRelease: Codeunit "Whse.-Production Release";
        lProductionFunctions: Codeunit "ecProduction Functions";
        lReservationFunctions: Codeunit "ecReservation Functions";

        lRoutingNo: Code[20];
        lTransactionRef: Text;

        lAlreadyPickedCompErr: Label 'Components for production order %1 have already been picked.';
        lWhsePickFoundErr: Label 'Cannot refresh production order %1 because picking activities were found.';
        lRefreshLinesErrorMsg: Label 'One or more of the lines on this %1 require special warehouse handling. The %2 for these lines has been set to blank.';
    begin
        // Verifica stato documento e attributi obbligatori
        if (pProductionOrder.Status = pProductionOrder.Status::Finished) then begin
            pProductionOrder.FieldError(Status);
        end;
        pProductionOrder.TestField("Due Date");

        // Verifica presenza e stato attività di prelievo
        if IsComponentPicked(pProductionOrder) then begin
            Error(lAlreadyPickedCompErr, pProductionOrder."No.");
        end;

        if ExistsWhseActivities(pProductionOrder) then begin
            Error(lWhsePickFoundErr, pProductionOrder."No.");
        end;

        lProdOrderLine.LockTable();

        // Backup ed eliminazione impegni presenti
        lTransactionRef := 'RecreateProductionOrder';
        lReservationFunctions.BackupAndRemoveProdOrderReservations(pProductionOrder, false, lTransactionRef);

        // Rigenerazione struttura ODP
        lRoutingNo := GetRoutingNo(pProductionOrder);
        UpdateRoutingNo(pProductionOrder, lRoutingNo);

        if not lCreateProdOrderLines.Copy(pProductionOrder, pCalcDirection, pProductionOrder."Variant Code", false) then begin
            Message(lRefreshLinesErrorMsg, pProductionOrder.TableCaption(), lProdOrderLine.FieldCaption("Bin Code"));
        end;

        if (pCalcDirection = pCalcDirection::Backward) and (pProductionOrder."Source Type" = pProductionOrder."Source Type"::Family) then begin
            pProductionOrder.SetUpdateEndDate();
            pProductionOrder.Validate("Due Date", pProductionOrder."Due Date");
        end;

        if (pProductionOrder.Status = pProductionOrder.Status::Released) then begin
            lProdOrderStatusMgt.FlushProdOrder(pProductionOrder, pProductionOrder.Status, WorkDate());
            lWhseProdRelease.Release(pProductionOrder);
        end;

        if (pProductionOrder.Status in [pProductionOrder.Status::"Firm Planned",
                                        pProductionOrder.Status::Released])
        then begin
            // Ricalcolo date per Send-Ahead e altri parametri custom
            lProductionFunctions.UpdateProductionOrderLines(pProductionOrder, false);
        end;

        // Ripristino impegni precedenti
        lReservationFunctions.RestoreProdOrderReservations(pProductionOrder, lTransactionRef, false);

        // Rilettura dati aggiornati
        pProductionOrder.Get(pProductionOrder.Status, pProductionOrder."No.");
    end;

    local procedure IsComponentPicked(pProductionOrder: Record "Production Order"): Boolean
    var
        lProdOrderComponent: Record "Prod. Order Component";
    begin
        if (pProductionOrder.Status <> pProductionOrder.Status::Released) then begin
            exit(false);
        end else begin
            lProdOrderComponent.SetRange(Status, pProductionOrder.Status);
            lProdOrderComponent.SetRange("Prod. Order No.", pProductionOrder."No.");
            lProdOrderComponent.SetFilter("Qty. Picked", '<>0');
            exit(not lProdOrderComponent.IsEmpty);
        end;
    end;

    local procedure ExistsWhseActivities(pProductionOrder: Record "Production Order"): Boolean
    var
        lWarehouseActivityHeader: Record "Warehouse Activity Header";
    begin
        if (pProductionOrder.Status <> pProductionOrder.Status::Released) then begin
            exit(false);
        end else begin
            lWarehouseActivityHeader.Reset();
            lWarehouseActivityHeader.SetCurrentKey("AltAWPProduction Order No.");
            lWarehouseActivityHeader.SetRange("AltAWPProduction Order No.", pProductionOrder."No.");
            lWarehouseActivityHeader.SetRange(Type, lWarehouseActivityHeader.Type::Pick);
            exit(not lWarehouseActivityHeader.IsEmpty);
        end;
    end;

    local procedure GetRoutingNo(pProductionOrder: Record "Production Order") rRoutingNo: Code[20]
    var
        lItem: Record Item;
        lStockkeepingUnit: Record "Stockkeeping Unit";
        lFamily: Record Family;
    begin
        rRoutingNo := pProductionOrder."Routing No.";

        case pProductionOrder."Source Type" of
            pProductionOrder."Source Type"::Item:
                begin
                    if lItem.Get(pProductionOrder."Source No.") then begin
                        rRoutingNo := lItem."Routing No.";
                    end;

                    if lStockkeepingUnit.Get(pProductionOrder."Location Code", pProductionOrder."Source No.", pProductionOrder."Variant Code") and
                        (lStockkeepingUnit."Routing No." <> '')
                    then begin
                        rRoutingNo := lStockkeepingUnit."Routing No.";
                    end;
                end;

            pProductionOrder."Source Type"::Family:
                begin
                    if lFamily.Get(pProductionOrder."Source No.") then begin
                        rRoutingNo := lFamily."Routing No.";
                    end;
                end;
        end;

        exit(rRoutingNo);
    end;

    local procedure UpdateRoutingNo(var pProductionOrder: Record "Production Order";
                                    pRoutingNo: Code[20])
    begin
        if (pRoutingNo <> pProductionOrder."Routing No.") then begin
            pProductionOrder."Routing No." := pRoutingNo;
            pProductionOrder.Modify();
        end;
    end;

}
