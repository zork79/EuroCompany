namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Inventory.Reservation;
using EuroCompany.BaseApp.Inventory.Tracking;
using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Transfer;
using Microsoft.Manufacturing.Capacity;
using Microsoft.Manufacturing.Document;
using Microsoft.Sales.Document;
using System.Utilities;

report 50010 "ecApply Prod. Order Line Seq."
{
    ApplicationArea = All;
    Caption = 'Apply Prod. Order Line Seq.';
    Description = 'CS_PRO_018';
    ProcessingOnly = true;
    UsageCategory = None;

    dataset
    {
        dataitem(ProdOrderLineLoop; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending);

            trigger OnPreDataItem()
            begin
                //Escludo dalla schedulazione le righe con stato produttivo = Completato
                Temp_ProdOrderLine.SetFilter("ecProductive Status", '<>%1', Temp_ProdOrderLine."ecProductive Status"::Completed);

                if Temp_ProdOrderLine.IsEmpty then CurrReport.Break();

                NewStartingDateTime := CreateDateTime(SchedulingStartingDate, SchedulingStartingTime);
                ProdOrderLineLoop.SetRange(Number, 1);
            end;

            trigger OnAfterGetRecord()
            var
                lProductionOrder: Record "Production Order";
                lNewProdOrderLine: Record "Prod. Order Line";
                lLinkedProdOrderLines: Record "Prod. Order Line";
                lLinkedProdOrderLine2: Record "Prod. Order Line";
                Temp_lParentCompReservBackup: Record "Reservation Entry" temporary;
                lProductionFunctions: Codeunit "ecProduction Functions";
                lReservationFunctions: Codeunit "ecReservation Functions";
                latsProgressDialogMgr: Codeunit "AltATSProgress Dialog Mgr.";
                lProdOrdLineTransRef: Text;
                lFirstLoop: Boolean;
                lRecalcStartingDate: Boolean;
                lRestoreProdOrdLineReserv: Boolean;
                lProdOrderHasComponentSupplied: Boolean;

                lDialogTxt: Label 'Prod. Order recalculation...\@1@@@@@@@@@@@@@';
            begin
                if GuiAllowed then latsProgressDialogMgr.OpenProgressDialog(lDialogTxt, 1, Temp_ProdOrderLine.Count);

                lFirstLoop := true;
                Temp_ProdOrderLine.SetCurrentKey("ecScheduling Sequence", "Starting Date-Time");
                Temp_ProdOrderLine.FindSet();
                repeat
                    if GuiAllowed then latsProgressDialogMgr.UpdateProgress(1);
                    lProductionOrder.Get(Temp_ProdOrderLine.Status, Temp_ProdOrderLine."Prod. Order No.");
                    lNewProdOrderLine.Get(Temp_ProdOrderLine.Status, Temp_ProdOrderLine."Prod. Order No.", Temp_ProdOrderLine."Line No.");

                    repeat
                        if (lNewProdOrderLine."Starting Date-Time" <> NewStartingDateTime) then begin
                            //Rimuovo il backup sulla riga principale di ODP e verifico se è possibile ripristinarlo al termine della schedulazione
                            ManageProdOrderLineReservation(lNewProdOrderLine, lProdOrdLineTransRef, lRestoreProdOrdLineReserv);

                            //Verifico se la riga di ODP ha un componente fornito da una seconda riga ODP
                            lProdOrderHasComponentSupplied := lProductionFunctions.ProdOrderLineHasComponentSuppliedByLine(lNewProdOrderLine, lLinkedProdOrderLines);

                            //Eseguo il backup dell'impegno dei componenti della riga principale di ODP e lo rimuovo
                            lReservationFunctions.BackupAndRemoveProdOrderCompReservations(lNewProdOrderLine, Temp_lParentCompReservBackup);

                            //Aggiorno la data/ora inizio della riga di ODP
                            lNewProdOrderLine.Validate("Starting Date-Time", NewStartingDateTime);
                            if (lNewProdOrderLine."ecProductive Status" <> lNewProdOrderLine."ecProductive Status"::Activated) then begin
                                lNewProdOrderLine.Validate("ecProductive Status", lNewProdOrderLine."ecProductive Status"::Scheduled);
                            end;
                            lNewProdOrderLine.Modify(true);

                            //Calcolo il Send-Ahead se dovesse esserci una riga componente fornito da una seconda riga ODP 
                            if lProdOrderHasComponentSupplied then begin
                                if not lLinkedProdOrderLines.IsEmpty then begin
                                    lLinkedProdOrderLines.FindSet();
                                    repeat
                                        if (lLinkedProdOrderLines."Remaining Quantity" <> 0) then begin
                                            //Calcolo Indietro
                                            if not lProductionFunctions.RecalcStartingDateTimeBySendAhead(lProductionOrder, lLinkedProdOrderLines."Line No.", 1) then begin
                                                //Se non riesco ad applicare il send-Ahead modifico la data fine della riga di SL
                                                ShiftSuppliedLineToParentLineNeedDate(lLinkedProdOrderLines);
                                            end;
                                        end;

                                        //Rileggo la Prod. Order Line aggiornata e gli assegno lo stato schedulato se "Stato produttivo <> Attivato" e "Stato produttivo <> Completato"
                                        lLinkedProdOrderLine2.Get(lLinkedProdOrderLines.Status, lLinkedProdOrderLines."Prod. Order No.", lLinkedProdOrderLines."Line No.");
                                        if (lLinkedProdOrderLine2."ecProductive Status" <> lLinkedProdOrderLine2."ecProductive Status"::Activated) and
                                           (lLinkedProdOrderLine2."ecProductive Status" <> lLinkedProdOrderLine2."ecProductive Status"::Completed)
                                        then begin
                                            lLinkedProdOrderLine2.Validate("ecProductive Status", lLinkedProdOrderLine2."ecProductive Status"::Scheduled);
                                            lLinkedProdOrderLine2.Modify(true);
                                        end;
                                    until (lLinkedProdOrderLines.Next() = 0);
                                end;
                            end;

                            //Provo a reinserire il bakup dell'impegno sui componenti
                            lReservationFunctions.TryToRestoreProdOrderCompReservation(lNewProdOrderLine, Temp_lParentCompReservBackup);

                            //Ripristino il backup dell'impegno sulla riga principale di ODP precedentemente rimosso
                            lReservationFunctions.RestoreProdOrderLineReservations(lNewProdOrderLine, lProdOrdLineTransRef, true);
                        end;

                        lNewProdOrderLine.Modify(false);

                        //Solo per il primo ODP eseguo un controllo per evitare che le righe di preparazione inizino nel passato, 
                        //nel caso sposto avanti la data di schedulazione della prima riga (confezionamento) per evitarlo                        
                        if lFirstLoop then begin
                            lRecalcStartingDate := false;
                            Clear(lLinkedProdOrderLine2);
                            lLinkedProdOrderLine2.SetRange(Status, lNewProdOrderLine.Status);
                            lLinkedProdOrderLine2.SetRange("Prod. Order No.", lNewProdOrderLine."Prod. Order No.");
                            lLinkedProdOrderLine2.SetFilter("ecParent Line No.", '<>%1', 0);
                            lLinkedProdOrderLine2.SetFilter("Starting Date-Time", '<%1', CurrentDateTime);
                            lLinkedProdOrderLine2.SetFilter("Remaining Qty. (Base)", '<>%1', 0);
                            if not lLinkedProdOrderLine2.IsEmpty then begin
                                lRecalcStartingDate := true;
                                NewStartingDateTime += 3600000;
                            end else begin
                                NewStartingDateTime := lNewProdOrderLine."Ending Date-Time";
                                lFirstLoop := false;
                            end;
                        end else begin
                            NewStartingDateTime := lNewProdOrderLine."Ending Date-Time";
                        end;
                    until (not lRecalcStartingDate);

                    Commit();
                until (Temp_ProdOrderLine.Next() = 0);

                //Azzero lo sequenza solo dopo il completamento della procedura di rischedulazione di tutti gli ODP 
                Temp_ProdOrderLine.FindSet();
                repeat
                    lNewProdOrderLine.Get(Temp_ProdOrderLine.Status, Temp_ProdOrderLine."Prod. Order No.", Temp_ProdOrderLine."Line No.");
                    lNewProdOrderLine."ecScheduling Sequence" := 0;
                    lNewProdOrderLine.Modify(false);
                until (Temp_ProdOrderLine.Next() = 0);
                Commit();

                if GuiAllowed then latsProgressDialogMgr.CloseProgressDialog();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(General)
                {
                    ShowCaption = false;

                    group(Informations)
                    {
                        Caption = 'Informations';

                        field(OperationTypeField; OperationType)
                        {
                            ApplicationArea = All;
                            Caption = 'Selected operation type';
                            Editable = false;
                        }
                        field(OperationNoField; OperationNo)
                        {
                            ApplicationArea = All;
                            Caption = 'Selected operation no.';
                            Editable = false;
                        }
                        field(LineToScheduleField; LineToSchedule)
                        {
                            ApplicationArea = All;
                            Caption = 'Lines to schedule';
                            Editable = false;
                            Style = Strong;
                        }
                    }
                    group(Parameters)
                    {
                        Caption = 'Parameters';

                        field(SchedulingStartingDateField; SchedulingStartingDate)
                        {
                            ApplicationArea = All;
                            Caption = 'Scheduling staring date';
                        }
                        field(SchedulingStartingTimeField; SchedulingStartingTime)
                        {
                            ApplicationArea = All;
                            Caption = 'Scheduling staring time';
                        }
                    }
                }
            }
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if (CloseAction = CloseAction::OK) then begin
                CheckAssignedStartingDateTime();
            end;
            if (CloseAction <> CloseAction::OK) then begin
                SequenceApplied := false;
            end;
        end;
    }

    var
        Temp_ProdOrderLine: Record "Prod. Order Line" temporary;
        OperationType: Enum "ecPrevalent Operation Type";
        OperationNo: Code[20];
        NewStartingDateTime: DateTime;
        SchedulingStartingDate: Date;
        SchedulingStartingTime: Time;
        LineToSchedule: Integer;
        SequenceApplied: Boolean;

    trigger OnInitReport()
    begin
        SequenceApplied := false;
    end;

    trigger OnPostReport()
    begin
        SequenceApplied := true;
    end;

    internal procedure SetProdOrderLines(var pProdOrderLine: Record "Prod. Order Line")
    var
        lProdOrderLine: Record "Prod. Order Line";
    begin
        lProdOrderLine.Copy(pProdOrderLine);

        LineToSchedule := lProdOrderLine.Count;
        lProdOrderLine.FindFirst();
        OperationType := lProdOrderLine."ecPrevalent Operation Type";
        OperationNo := lProdOrderLine."ecPrevalent Operation No.";

        Clear(Temp_ProdOrderLine);
        Temp_ProdOrderLine.DeleteAll();
        lProdOrderLine.FindSet();
        repeat
            Temp_ProdOrderLine := lProdOrderLine;
            Temp_ProdOrderLine.Insert(false);
        until (lProdOrderLine.Next() = 0);
    end;

    local procedure CheckAssignedStartingDateTime()
    var
        lCalendarEntry: Record "Calendar Entry";

        lStartDateErr: Label 'Scheduling starting date must have a value';
        lStartTimeErr: Label 'Scheduling starting time must have a value';
        lAssignedDateTimeErr: Label 'The entered start date/time: %1 cannot be less than the current date/time!';
        lDateTimeInvalidErr: Label 'Starting date: %1, Starting Time: %2 are invalid for calendar of %3 = %4!';
    begin
        if (SchedulingStartingDate = 0D) then begin
            Error(lStartDateErr);
        end;
        if (SchedulingStartingTime = 0T) then begin
            Error(lStartTimeErr);
        end;

        if (CurrentDateTime > CreateDateTime(SchedulingStartingDate, SchedulingStartingTime)) then begin
            Error(lAssignedDateTimeErr, CreateDateTime(SchedulingStartingDate, SchedulingStartingTime));
        end;

        Temp_ProdOrderLine.FindFirst();

        Clear(lCalendarEntry);
        if (Temp_ProdOrderLine."ecPrevalent Operation Type" = Temp_ProdOrderLine."ecPrevalent Operation Type"::"Machine Center") then begin
            lCalendarEntry.SetRange("Capacity Type", lCalendarEntry."Capacity Type"::"Machine Center");
        end;
        if (Temp_ProdOrderLine."ecPrevalent Operation Type" = Temp_ProdOrderLine."ecPrevalent Operation Type"::"Work Center") then begin
            lCalendarEntry.SetRange("Capacity Type", lCalendarEntry."Capacity Type"::"Work Center");
        end;

        lCalendarEntry.SetRange("No.", Temp_ProdOrderLine."ecPrevalent Operation No.");
        lCalendarEntry.SetRange(Date, SchedulingStartingDate);
        lCalendarEntry.SetFilter("Starting Time", '<=%1', SchedulingStartingTime);
        lCalendarEntry.SetFilter("Ending Time", '>=%1', SchedulingStartingTime);
        if lCalendarEntry.IsEmpty then begin
            Error(lDateTimeInvalidErr, SchedulingStartingDate, SchedulingStartingTime, Format(Temp_ProdOrderLine."ecPrevalent Operation Type"),
                                       Temp_ProdOrderLine."ecPrevalent Operation No.");
        end;
    end;

    internal procedure GetSequenceApplied(): Boolean
    begin
        exit(SequenceApplied);
    end;

    internal procedure ShiftSuppliedLineToParentLineNeedDate(var pProdOrderLineSupplied: Record "Prod. Order Line")
    var
        lParentProdOrderLine: Record "Prod. Order Line";
        lProdOrderComponent: Record "Prod. Order Component";
        lProdOrderRoutingLine: Record "Prod. Order Routing Line";
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        Clear(lProdOrderComponent);
        lProdOrderComponent.SetRange(Status, pProdOrderLineSupplied.Status);
        lProdOrderComponent.SetRange("Prod. Order No.", pProdOrderLineSupplied."Prod. Order No.");
        lProdOrderComponent.SetRange("Supplied-by Line No.", pProdOrderLineSupplied."Line No.");
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindFirst();
            lParentProdOrderLine.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.", lProdOrderComponent."Prod. Order Line No.");
            lProductionFunctions.GetProdOrderRoutingLineByRoutingLinkCode(lParentProdOrderLine, lProdOrderRoutingLine,
                                                                          lProdOrderComponent."Routing Link Code");
            pProdOrderLineSupplied.Validate("Ending Date-Time", lProdOrderRoutingLine."Starting Date-Time");
            pProdOrderLineSupplied.Modify(true);
        end;
    end;

    local procedure ManageProdOrderLineReservation(var pProdOrderLine: Record "Prod. Order Line"; var pTransactionRef: Text; var pRestoreReservation: Boolean)
    var
        lSalesLine: Record "Sales Line";
        lTransferLine: Record "Transfer Line";
        lReservationEntry: Record "Reservation Entry";
        Temp_lReservEntryBackup: Record "AltATSReserv. Entry Backup" temporary;
        Temp_lReservEntryBackup2: Record "AltATSReserv. Entry Backup" temporary;
        lReservationFunctions: Codeunit "ecReservation Functions";
        lProdOrderLineReserve: Codeunit "Prod. Order Line-Reserve";
        lSessionDataStore: Codeunit "AltATSSession Data Store";
        lProductionFunctions: Codeunit "ecProduction Functions";
        lDateTimeStart: DateTime;
        lDateTimeEnd: DateTime;
        lDueDate: Date;
    begin
        pTransactionRef := '';
        lProdOrderLineReserve.FindReservEntry(pProdOrderLine, lReservationEntry);
        lReservationEntry.SetRange("Reservation Status", lReservationEntry."Reservation Status"::Reservation);
        if not lReservationEntry.IsEmpty then begin
            //Se presente l'impegno su riga ODP lo rimuovo e lo salvo
            lReservationFunctions.BackupAndRemoveProdOrderLineReservations(pProdOrderLine, false, pTransactionRef);

            Clear(Temp_lReservEntryBackup);
            lSessionDataStore.CopyReservEntryBackupInstance(Temp_lReservEntryBackup);
            Temp_lReservEntryBackup2.Copy(Temp_lReservEntryBackup, true);

            //Analizzo l'impegno salvato e verifico se sarà possibile ripristinarlo in funzione delle nuove date si schedulazione
            Temp_lReservEntryBackup.Reset();
            Temp_lReservEntryBackup.ApplyMasterProdOrderLineFilters(pProdOrderLine);
            Temp_lReservEntryBackup.SetCurrentKey("Reservation Status", "Shipment Date", "Expected Receipt Date", "Serial No.", "Lot No.");
            Temp_lReservEntryBackup.SetRange("Reservation Status", Temp_lReservEntryBackup."Reservation Status"::Reservation);
            Temp_lReservEntryBackup.SetRange(Positive, false);
            if not Temp_lReservEntryBackup.IsEmpty then begin
                Temp_lReservEntryBackup.FindSet();
                repeat
                    pRestoreReservation := false;
                    if (Temp_lReservEntryBackup."Source Type" in [Database::"Sales Line", Database::"Transfer Line"]) then begin
                        lDateTimeStart := NewStartingDateTime;
                        lDateTimeEnd := 0DT;
                        lProductionFunctions.GetNewProdOrderLineRescheduledDates(pProdOrderLine, lDateTimeStart, lDateTimeEnd, lDueDate);
                        if (Temp_lReservEntryBackup."Source Type" = Database::"Sales Line") then begin
                            if lSalesLine.Get(Temp_lReservEntryBackup."Source Subtype", Temp_lReservEntryBackup."Source ID", Temp_lReservEntryBackup."Source Ref. No.") then begin
                                pRestoreReservation := (lSalesLine."Shipment Date" >= lDueDate);
                            end;
                        end;
                        if (Temp_lReservEntryBackup."Source Type" = Database::"Transfer Line") then begin
                            if lTransferLine.Get(Temp_lReservEntryBackup."Source ID", Temp_lReservEntryBackup."Source Ref. No.") then begin
                                pRestoreReservation := (lTransferLine."Shipment Date" >= lDueDate);
                            end;
                        end;
                    end;

                    // //Elimino gli impegni non ripristinabili
                    if not pRestoreReservation then begin
                        Temp_lReservEntryBackup2.SetRange("Entry No.", Temp_lReservEntryBackup."Entry No.");
                        Temp_lReservEntryBackup2.DeleteAll(false);
                    end;
                until (Temp_lReservEntryBackup.Next() = 0);
            end;
        end;
    end;

    /*
    local procedure CheckSchedulingStartDateTime(pProductionOrder: Record "Production Order"; pStartingDateTime: DateTime): DateTime
    var
        lSimProdOrderLine: Record "Prod. Order Line";
        lSimProductionOrder: Record "Production Order";
        lATSSessionDataStore: Codeunit "AltATSSession Data Store";
        lProductionFunctions: Codeunit "ecProduction Functions";
        lRefreshProductionOrder: Codeunit "ecRefresh Production Order";
        lNewProdOrderNo: Code[20];
        lNewDateTime: DateTime;
        lRecalculateProdOrder: Boolean;
    begin
        lNewProdOrderNo := lProductionFunctions.CreateTempProdOrderNo();
        lNewDateTime := pStartingDateTime;

        Clear(lSimProductionOrder);
        lSimProductionOrder.Status := lSimProductionOrder.Status::Simulated;
        lSimProductionOrder."No." := lNewProdOrderNo;
        lSimProductionOrder.Insert(true);
        lSimProductionOrder.Validate("Source Type", pProductionOrder."Source Type");
        lSimProductionOrder.Validate("Source No.", pProductionOrder."Source No.");
        lSimProductionOrder.Validate("Location Code", pProductionOrder."Location Code");
        lSimProductionOrder.Validate("Bin Code", pProductionOrder."Bin Code");
        lSimProductionOrder.Validate(Quantity, pProductionOrder.Quantity);

        repeat
            lATSSessionDataStore.AddSessionSetting('HideMultiLevelMessage', true);
            lSimProductionOrder.Validate("Starting Date-Time", lNewDateTime);
            lATSSessionDataStore.RemoveSessionSetting('HideMultiLevelMessage');

            lSimProductionOrder.Validate("Due Date", pProductionOrder."Due Date");
            lSimProductionOrder.Modify(true);

            lRecalculateProdOrder := false;
            lSimProductionOrder.SetRecFilter();

            //lATSSessionDataStore.AddSessionSetting('HideMultiLevelMessage', true);
            lRefreshProductionOrder.RecreateProductionOrder(lSimProductionOrder, 0);
            //lATSSessionDataStore.RemoveSessionSetting('HideMultiLevelMessage');

            //Aggiorno le info di riga e applico il send-ahead se presente
            lProductionFunctions.UpdateProductionOrderLines(lSimProductionOrder, false);

            Clear(lSimProdOrderLine);
            lSimProdOrderLine.SetRange(Status, lSimProdOrderLine.Status::Simulated);
            lSimProdOrderLine.SetRange("Prod. Order No.", lSimProductionOrder."No.");
            lSimProdOrderLine.SetFilter("ecParent Line No.", '<>%1', 0);
            lSimProdOrderLine.SetFilter("Starting Date-Time", '<%1', CurrentDateTime);
            if not lSimProdOrderLine.IsEmpty then begin
                lRecalculateProdOrder := true;
                lNewDateTime += 3600000;
            end;
        until (not lRecalculateProdOrder);

        lSimProductionOrder.Delete();

        exit(lNewDateTime);
    end;
    */
}