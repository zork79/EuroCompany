namespace EuroCompany.BaseApp.Manufacturing;

using EuroCompany.BaseApp.Manufacturing.Document;
using EuroCompany.BaseApp.Restrictions;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;
using Microsoft.Manufacturing.Document;


codeunit 50021 "ecComponent Availability Mgt."
{
    Description = 'CS_PRO_018';

    var
        AvailabilityCalcMethod: Option "Till to First Usage Date","Till to Last Usage Date","Custom Period Cut-Off Date";
        TargetAnalysisDate: Date;

    internal procedure CheckProdOrderLineToPlan(var pProdOrderLine: Record "Prod. Order Line")
    var
        lItem: Record Item;
        lProdOrderComponent: Record "Prod. Order Component";
        Temp_lAWPItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary;
        lAWPLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
        lRestrictionCode: Code[50];
        lCountryRegionOriginCode: Code[10];
        lAvailability: Decimal;
        lUsableQty: Decimal;
        lConstraintQty: Decimal;
        lNotConstraintQty: Decimal;
        lExpiredQty: Decimal;
        lTotalQty: Decimal;
        lSingleLotPicking: Boolean;
    begin
        //CS_PRO_018-s
        lAvailability := 0;
        pProdOrderLine.ecCheck := false;
        if not pProdOrderLine.ecSelected or (pProdOrderLine."ecParent Line No." <> 0) then exit;

        Clear(lProdOrderComponent);
        lProdOrderComponent.SetRange(Status, pProdOrderLine.Status);
        lProdOrderComponent.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        lProdOrderComponent.SetRange("Supplied-by Line No.", 0);
        if lProdOrderComponent.FindSet() then begin
            repeat
                //Controllo di presenza di restrizioni sui componenti degli ODP Confermati
                if not pProdOrderLine.ecCheck then begin
                    GetComponentRestrictionRules(lProdOrderComponent, lRestrictionCode, lCountryRegionOriginCode, lSingleLotPicking);
                    pProdOrderLine.ecCheck := (lRestrictionCode <> '') or lSingleLotPicking or (lCountryRegionOriginCode <> '');
                end;

                //Rimosso controllo
                /*
                //Controllo di presenza di restrizioni sui componenti degli ODP Rilasciati
                if not pProdOrderLine.ecCheck then begin
                    pProdOrderLine.ecCheck := ExistRelProdOrdCompWithRestriction(lProdOrderComponent."Item No.",
                                                                                 lProdOrderComponent."Variant Code",
                                                                                 lProdOrderComponent."Location Code");
                end;
                */

                //Analizzo le quanità e verifico se la quantità utilizzabile alla data di scadenza del componente sia > remaining Qty
                lUsableQty := 0;
                if not pProdOrderLine.ecCheck then begin
                    lAWPLogisticUnitsMgt.FindOpenWhseEntries(lProdOrderComponent."Item No.", lProdOrderComponent."Variant Code",
                                                             lProdOrderComponent."Location Code", '', '', '', '', '',
                                                             false, Temp_lAWPItemInventoryBuffer);

                    CalcAvailabilityFromItemInventoryBuffer(Temp_lAWPItemInventoryBuffer,
                                                            lConstraintQty,
                                                            lNotConstraintQty,
                                                            lUsableQty,
                                                            lExpiredQty,
                                                            lTotalQty,
                                                            lProdOrderComponent."Due Date");

                    pProdOrderLine.ecCheck := lUsableQty < lProdOrderComponent."Remaining Qty. (Base)";
                end;

                if not pProdOrderLine.ecCheck then begin
                    lItem.Get(lProdOrderComponent."Item No.");
                    lItem.SetFilter("Location Filter", pProdOrderLine."Location Code");
                    lItem.CalcFields(Inventory, "Qty. on Sales Order", "AltAWPQty.Rel. Component Lines", "Trans. Ord. Shipment (Qty.)");
                    lAvailability := lUsableQty - lItem."Qty. on Sales Order" - lItem."AltAWPQty.Rel. Component Lines" - lItem."Trans. Ord. Shipment (Qty.)";
                    //Controllo se la disponibilità < Remaining Qty. (Base)
                    if (lAvailability < lProdOrderComponent."Remaining Qty. (Base)") then begin
                        pProdOrderLine.ecCheck := true;
                    end;
                end;

                if pProdOrderLine.ecCheck then pProdOrderLine.Modify(false);
            until (lProdOrderComponent.Next() = 0) or pProdOrderLine.ecCheck;
        end;
        //CS_PRO_018-e
    end;

    internal procedure OpenAvailabBuffGroupedByCompCode(var pProdOrderLine: Record "Prod. Order Line"; pCalledByCheck: Boolean)
    var
        Temp_lComponentAvailabilityBuffer: Record "ecComponent Availability Buff." temporary;
        lCompAvailabGroupedCodePage: Page "ecComp. Availab. Grouped Code";
    begin
        //CS_PRO_018-s
        CreateGroupedAvailabilityBuff(pProdOrderLine, '', '', Temp_lComponentAvailabilityBuffer,
                                      Enum::"ecAvailability Buffer Grouping"::"Prod. Order Comp. Grouped Code", true);
        Clear(Temp_lComponentAvailabilityBuffer);
        if not Temp_lComponentAvailabilityBuffer.IsEmpty then begin
            Clear(lCompAvailabGroupedCodePage);
            if pCalledByCheck then begin
                pProdOrderLine.FindFirst();
                lCompAvailabGroupedCodePage.SetCalledByCheck(pProdOrderLine, true);
            end;
            lCompAvailabGroupedCodePage.InitComponentAvailability(Temp_lComponentAvailabilityBuffer);
            lCompAvailabGroupedCodePage.RunModal();
        end;
        //CS_PRO_018-e
    end;

    internal procedure OpenAvailabBuffGroupedByCompCodeReleased(var Temp_pProdOrderLine: Record "Prod. Order Line" temporary)
    var
        Temp_lComponentAvailabilityBuffer: Record "ecComponent Availability Buff." temporary;
        lCompAvailabGroupCodeRelPage: Page "ecComp.Availab.Group Code(Rel)";
    begin
        //CS_PRO_018-s
        CreateGroupedAvailabilityBuff(Temp_pProdOrderLine, '', '', Temp_lComponentAvailabilityBuffer,
                                      Enum::"ecAvailability Buffer Grouping"::"Prod. Order Comp. Grouped Code", true);
        Clear(Temp_lComponentAvailabilityBuffer);
        if not Temp_lComponentAvailabilityBuffer.IsEmpty then begin
            Clear(lCompAvailabGroupCodeRelPage);
            lCompAvailabGroupCodeRelPage.SetSelectedProdOrderLines(Temp_pProdOrderLine);
            lCompAvailabGroupCodeRelPage.InitComponentAvailability(Temp_lComponentAvailabilityBuffer);
            lCompAvailabGroupCodeRelPage.Run();
        end;
        //CS_PRO_018-e
    end;

    internal procedure CreateAndOpenAvailBuffGroupedByCompRestr(var pProdOrderLine: Record "Prod. Order Line")
    var
        Temp_lComponentAvailabilityBuffer: Record "ecComponent Availability Buff." temporary;
        lCompAvailGroupedRestrPage: Page "ecComp. Avail. Grouped Restr.";
    begin
        //CS_PRO_018-s
        CreateGroupedAvailabilityBuff(pProdOrderLine, '', '', Temp_lComponentAvailabilityBuffer,
                                      Enum::"ecAvailability Buffer Grouping"::"Prod. Order Comp. Grouped Restrictions", true);
        Clear(Temp_lComponentAvailabilityBuffer);
        if not Temp_lComponentAvailabilityBuffer.IsEmpty then begin
            Clear(lCompAvailGroupedRestrPage);
            lCompAvailGroupedRestrPage.InitComponentAvailability(Temp_lComponentAvailabilityBuffer);
            lCompAvailGroupedRestrPage.RunModal();
        end;
        //CS_PRO_018-e
    end;

    internal procedure OpenAvailabilityBuffGroupedByCompDetail(var pProdOrderLine: Record "Prod. Order Line";
                                                               var Temp_pComponentAvailabilityBuffer: Record "ecComponent Availability Buff." temporary;
                                                               pOnlyReadMode: Boolean)
    var
        Temp_lComponentAvailabilityBuffer2: Record "ecComponent Availability Buff." temporary;
        lCompAvailabDetailPage: Page "ecComp. Availab. Detail";
    begin
        //CS_PRO_018-s
        CreateGroupedAvailabilityBuff(pProdOrderLine, Temp_pComponentAvailabilityBuffer."Item No.",
                                      Temp_pComponentAvailabilityBuffer."Variant Code", Temp_lComponentAvailabilityBuffer2,
                                      Enum::"ecAvailability Buffer Grouping"::"Prod. Order Comp. Detail", true);
        Clear(Temp_lComponentAvailabilityBuffer2);
        if not Temp_lComponentAvailabilityBuffer2.IsEmpty then begin
            Clear(lCompAvailabDetailPage);
            if (Temp_pComponentAvailabilityBuffer."Entry Type" =
                Temp_pComponentAvailabilityBuffer."Entry Type"::"Prod. Order Comp. Grouped Restrictions")
            then begin
                Temp_lComponentAvailabilityBuffer2.FilterGroup(2);
                Temp_lComponentAvailabilityBuffer2.SetRange("Restriction Rule Code", Temp_pComponentAvailabilityBuffer."Restriction Rule Code");
                Temp_lComponentAvailabilityBuffer2.SetRange("Single Lot Pickings", Temp_pComponentAvailabilityBuffer."Single Lot Pickings");
                Temp_lComponentAvailabilityBuffer2.SetRange("Origin Country/Region Code", Temp_pComponentAvailabilityBuffer."Origin Country/Region Code");
                Temp_lComponentAvailabilityBuffer2.FilterGroup(0);
            end;

            lCompAvailabDetailPage.SetOnlyReadMode(pOnlyReadMode);
            lCompAvailabDetailPage.InitComponentAvailability(Temp_lComponentAvailabilityBuffer2);
            lCompAvailabDetailPage.RunModal();
        end;
        //CS_PRO_018-e
    end;

    internal procedure CreateGroupedAvailabilityBuff(var pProdOrderLine: Record "Prod. Order Line";
                                                     pItemNo: Code[20];
                                                     pVariantCode: Code[10];
                                                     var Temp_pComponentAvailabilityBuffer: Record "ecComponent Availability Buff." temporary;
                                                     pGroupingType: Enum "ecAvailability Buffer Grouping";
                                                     pShowDialog: Boolean)
    var
        lItem: Record Item;
        lProdOrderComponent: Record "Prod. Order Component";
        lRestrictionsMgt: Codeunit "ecRestrictions Mgt.";
        latsProgressDialogMgr: Codeunit "AltATSProgress Dialog Mgr.";
        lRestrictionCode: Code[50];
        lCountryRegionOriginCode: Code[10];
        lSingleLotPicking: Boolean;

        lDialogTxt: Label 'Prod. Order Calculation...\@1@@@@@@@@@@@@@\ \Component calculation...\@2@@@@@@@@@@@@@\';
    begin
        //CS_PRO_018-s
        Clear(Temp_pComponentAvailabilityBuffer);
        Temp_pComponentAvailabilityBuffer.DeleteAll();

        Clear(lProdOrderComponent);
        if not pProdOrderLine.IsEmpty then begin
            pProdOrderLine.FindSet();
            if pShowDialog then latsProgressDialogMgr.OpenProgressDialog(lDialogTxt, 1, pProdOrderLine.Count);
            if pShowDialog then latsProgressDialogMgr.SetProgress(2, 0);
            repeat
                if pShowDialog then latsProgressDialogMgr.UpdateProgress(1);
                lProdOrderComponent.SetRange(Status, pProdOrderLine.Status);
                lProdOrderComponent.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
                lProdOrderComponent.SetRange("Supplied-by Line No.", 0);

                if (pItemNo <> '') then begin
                    lProdOrderComponent.SetRange("Item No.", pItemNo);
                    lProdOrderComponent.SetRange("Variant Code", pVariantCode);
                end;
                if not lProdOrderComponent.IsEmpty then begin
                    lProdOrderComponent.FindSet();
                    if pShowDialog then latsProgressDialogMgr.InitProgressBar(2, lProdOrderComponent.Count);
                    repeat
                        if pShowDialog then latsProgressDialogMgr.UpdateProgress(2);
                        GetComponentRestrictionRules(lProdOrderComponent, lRestrictionCode, lCountryRegionOriginCode, lSingleLotPicking);
                        Temp_pComponentAvailabilityBuffer.SetRange("Item No.", lProdOrderComponent."Item No.");
                        Temp_pComponentAvailabilityBuffer.SetRange("Variant Code", lProdOrderComponent."Variant Code");
                        Temp_pComponentAvailabilityBuffer.SetRange("Location Code", lProdOrderComponent."Location Code");
                        case pGroupingType of
                            pGroupingType::"Prod. Order Comp. Grouped Code":
                                begin
                                    Temp_pComponentAvailabilityBuffer.SetRange("Entry Type",
                                                                               Temp_pComponentAvailabilityBuffer."Entry Type"::"Prod. Order Comp. Grouped Code");
                                end;
                            pGroupingType::"Prod. Order Comp. Grouped Restrictions":
                                begin
                                    Temp_pComponentAvailabilityBuffer.SetRange("Entry Type",
                                                                               Temp_pComponentAvailabilityBuffer."Entry Type"::"Prod. Order Comp. Grouped Restrictions");
                                    Temp_pComponentAvailabilityBuffer.SetRange("Restriction Rule Code", lRestrictionCode);
                                    Temp_pComponentAvailabilityBuffer.SetRange("Single Lot Pickings", lSingleLotPicking);
                                    Temp_pComponentAvailabilityBuffer.SetRange("Origin Country/Region Code", lCountryRegionOriginCode);
                                end;
                            pGroupingType::"Prod. Order Comp. Detail":
                                begin
                                    Temp_pComponentAvailabilityBuffer.SetRange("Entry Type",
                                                                               Temp_pComponentAvailabilityBuffer."Entry Type"::"Prod. Order Comp. Detail");
                                    Temp_pComponentAvailabilityBuffer.SetRange("Prod. Order Status", lProdOrderComponent.Status);
                                    Temp_pComponentAvailabilityBuffer.SetRange("Prod. Order No.", lProdOrderComponent."Prod. Order No.");
                                    Temp_pComponentAvailabilityBuffer.SetRange("Prod. Order Line No.", lProdOrderComponent."Prod. Order Line No.");
                                    Temp_pComponentAvailabilityBuffer.SetRange("Component Line No.", lProdOrderComponent."Line No.");
                                end;
                        end;
                        if Temp_pComponentAvailabilityBuffer.IsEmpty then begin
                            InsertAvailabilityBuffComponent(lProdOrderComponent, Temp_pComponentAvailabilityBuffer, lRestrictionCode, lCountryRegionOriginCode,
                                                            lSingleLotPicking, pGroupingType);
                        end else begin
                            lItem.Get(lProdOrderComponent."Item No.");
                            Temp_pComponentAvailabilityBuffer.FindLast();
                            Temp_pComponentAvailabilityBuffer.Quantity += lProdOrderComponent."Remaining Qty. (Base)";
                            if lRestrictionsMgt.RestrictionsAllowedForItem(lItem."No.") and (pGroupingType = pGroupingType::"Prod. Order Comp. Grouped Code") then begin
                                if (lRestrictionCode <> '') or (lCountryRegionOriginCode <> '') or lSingleLotPicking then begin
                                    Temp_pComponentAvailabilityBuffer."Exists Restrictions" := true;
                                end;
                            end;
                            if ((Temp_pComponentAvailabilityBuffer."Min Consumption Date" > lProdOrderComponent."Due Date") or
                               (Temp_pComponentAvailabilityBuffer."Min Consumption Date" = 0D)) and (lProdOrderComponent."Due Date" <> 0D)
                            then begin
                                Temp_pComponentAvailabilityBuffer."Min Consumption Date" := lProdOrderComponent."Due Date";
                            end;
                            if (Temp_pComponentAvailabilityBuffer."Max Consumption Date" < lProdOrderComponent."Due Date") then begin
                                Temp_pComponentAvailabilityBuffer."Max Consumption Date" := lProdOrderComponent."Due Date";
                            end;
                            Temp_pComponentAvailabilityBuffer.Modify(false);
                        end;
                    until (lProdOrderComponent.Next() = 0);
                end;
            until (pProdOrderLine.Next() = 0);

            if pShowDialog then latsProgressDialogMgr.CloseProgressDialog();
        end;
        //CS_PRO_018-e
    end;

    local procedure InsertAvailabilityBuffComponent(var pProdOrderComponent: Record "Prod. Order Component"; var Temp_pComponentAvailabilityBuffer: Record "ecComponent Availability Buff." temporary;
                                                    pRestrictionCode: Code[50]; pOriginCountryRegionCode: Code[10]; pSingleLotPicking: Boolean; pGroupingType: Enum "ecAvailability Buffer Grouping")
    var
        lItem: Record Item;
        lProductionOrder: Record "Production Order";
        Temp_lAvailabilityAnalysisBuffer2: Record "ecComponent Availability Buff." temporary;
        lRestrictionsMgt: Codeunit "ecRestrictions Mgt.";
        lNewEntryNo: Integer;
    begin
        //CS_PRO_018-s
        Temp_lAvailabilityAnalysisBuffer2.Copy(Temp_pComponentAvailabilityBuffer, true);
        Clear(Temp_lAvailabilityAnalysisBuffer2);
        Temp_lAvailabilityAnalysisBuffer2.SetRange("Entry Type", pGroupingType);
        lNewEntryNo := 1;
        if Temp_lAvailabilityAnalysisBuffer2.FindLast() then begin
            lNewEntryNo += Temp_lAvailabilityAnalysisBuffer2."Entry No.";
        end;
        Temp_pComponentAvailabilityBuffer.Init();
        Temp_pComponentAvailabilityBuffer."Entry Type" := pGroupingType;
        Temp_pComponentAvailabilityBuffer."Entry No." := lNewEntryNo;
        Temp_pComponentAvailabilityBuffer.Insert(false);

        if (pGroupingType = pGroupingType::"Prod. Order Comp. Detail") then begin
            lProductionOrder.Get(pProdOrderComponent.Status, pProdOrderComponent."Prod. Order No.");
            Temp_pComponentAvailabilityBuffer."Prod. Order Status" := pProdOrderComponent.Status;
            Temp_pComponentAvailabilityBuffer."Prod. Order No." := pProdOrderComponent."Prod. Order No.";
            Temp_pComponentAvailabilityBuffer."Prod. Order Line No." := pProdOrderComponent."Prod. Order Line No.";
            Temp_pComponentAvailabilityBuffer."Component Line No." := pProdOrderComponent."Line No.";
            Temp_pComponentAvailabilityBuffer."Parent Item No." := lProductionOrder."Source No.";
            Temp_pComponentAvailabilityBuffer."Bin Code" := pProdOrderComponent."Bin Code";
            Temp_pComponentAvailabilityBuffer."Reserved Cons. Bin" := pProdOrderComponent."AltAWPUse Reserved Cons. Bin";
        end;

        lItem.Get(pProdOrderComponent."Item No.");
        Temp_pComponentAvailabilityBuffer."Item No." := pProdOrderComponent."Item No.";
        Temp_pComponentAvailabilityBuffer."Variant Code" := pProdOrderComponent."Variant Code";
        Temp_pComponentAvailabilityBuffer.Description := pProdOrderComponent.Description;
        Temp_pComponentAvailabilityBuffer."Unit of Measure code" := lItem."Base Unit of Measure";
        Temp_pComponentAvailabilityBuffer.Quantity := pProdOrderComponent."Remaining Qty. (Base)";
        Temp_pComponentAvailabilityBuffer."Reorder Policy" := lItem."Reordering Policy";
        Temp_pComponentAvailabilityBuffer."Reorder Point" := lItem."Reorder Point";
        Temp_pComponentAvailabilityBuffer."Safety Stock Quantity" := lItem."Safety Stock Quantity";
        Temp_pComponentAvailabilityBuffer."Exists Restrictions" := false;
        if lRestrictionsMgt.RestrictionsAllowedForItem(lItem."No.") and
           ((pRestrictionCode <> '') or (pOriginCountryRegionCode <> '') or pSingleLotPicking)
        then begin
            Temp_pComponentAvailabilityBuffer."Exists Restrictions" := true;
            if (pGroupingType = pGroupingType::"Prod. Order Comp. Grouped Restrictions") or (pGroupingType = pGroupingType::"Prod. Order Comp. Detail") then begin
                Temp_pComponentAvailabilityBuffer."Restriction Rule Code" := pRestrictionCode;
                Temp_pComponentAvailabilityBuffer."Single Lot Pickings" := pSingleLotPicking;
                Temp_pComponentAvailabilityBuffer."Origin Country/Region Code" := pOriginCountryRegionCode;
            end;
        end;

        if lRestrictionsMgt.RestrictionsAllowedForItem(lItem."No.") and
           (pGroupingType = pGroupingType::"Prod. Order Comp. Grouped Code")
        then begin
            Temp_pComponentAvailabilityBuffer."Exists Restrictions 2" := ExistsRestrForReleasedProdOrdComp(Temp_pComponentAvailabilityBuffer."Item No.",
                                                                                                           Temp_pComponentAvailabilityBuffer."Variant Code");
        end;
        Temp_pComponentAvailabilityBuffer."Location Code" := pProdOrderComponent."Location Code";
        Temp_pComponentAvailabilityBuffer."Min Consumption Date" := pProdOrderComponent."Due Date";
        Temp_pComponentAvailabilityBuffer."Max Consumption Date" := pProdOrderComponent."Due Date";
        Temp_pComponentAvailabilityBuffer.Selected := true;
        Temp_pComponentAvailabilityBuffer.Modify(false);
        //CS_PRO_018-e
    end;

    local procedure ExistsRestrForReleasedProdOrdComp(pItemNo: Code[20]; pVariantCode: Code[20]): Boolean
    var
        lProdOrderComponent: Record "Prod. Order Component";
        lProductionFunctions: Codeunit "ecComponent Availability Mgt.";
        lRestrictionCode: Code[50];
        lOriginCountryRegionCode: Code[10];
        lSingleLotPicking: Boolean;
    begin
        //CS_PRO_018-s
        lSingleLotPicking := false;
        lRestrictionCode := '';

        Clear(lProdOrderComponent);
        lProdOrderComponent.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Due Date");
        lProdOrderComponent.SetRange("Item No.", pItemNo);
        lProdOrderComponent.SetRange("Variant Code", pVariantCode);
        lProdOrderComponent.SetRange(Status, lProdOrderComponent.Status::Released);
        lProdOrderComponent.SetFilter("Remaining Qty. (Base)", '<>%1', 0);
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindSet();
            repeat
                lProductionFunctions.GetComponentRestrictionRules(lProdOrderComponent, lRestrictionCode, lOriginCountryRegionCode, lSingleLotPicking);
            until (lProdOrderComponent.Next() = 0) or (lRestrictionCode <> '') or (lOriginCountryRegionCode <> '') or lSingleLotPicking;
        end;

        exit((lRestrictionCode <> '') or (lOriginCountryRegionCode <> '') or lSingleLotPicking);
        //CS_PRO_018-e
    end;

    internal procedure ExistsRestrForReleasedProdOrdCompByDate(pItemNo: Code[20]; pVariantCode: Code[20]; pDateFilter: Text): Boolean
    var
        lProdOrderComponent: Record "Prod. Order Component";
        lProductionFunctions: Codeunit "ecComponent Availability Mgt.";
        lRestrictionCode: Code[50];
        lOriginCountryRegionCode: Code[10];
        lSingleLotPicking: Boolean;
    begin
        //CS_PRO_018-s
        lSingleLotPicking := false;
        lRestrictionCode := '';

        Clear(lProdOrderComponent);
        lProdOrderComponent.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Due Date");
        lProdOrderComponent.SetRange("Item No.", pItemNo);
        lProdOrderComponent.SetRange("Variant Code", pVariantCode);
        lProdOrderComponent.SetRange(Status, lProdOrderComponent.Status::Released);
        lProdOrderComponent.SetFilter("Remaining Qty. (Base)", '<>%1', 0);
        if (pDateFilter <> '') then lProdOrderComponent.SetFilter("Due Date", pDateFilter);
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindSet();
            repeat
                lProductionFunctions.GetComponentRestrictionRules(lProdOrderComponent, lRestrictionCode, lOriginCountryRegionCode, lSingleLotPicking);
            until (lProdOrderComponent.Next() = 0) or (lRestrictionCode <> '') or (lOriginCountryRegionCode <> '') or lSingleLotPicking;
        end;

        exit((lRestrictionCode <> '') or (lOriginCountryRegionCode <> '') or lSingleLotPicking);
        //CS_PRO_018-e
    end;

    internal procedure CreateAvailabilityBuffGroupedByCompForPlanMonitor(var pFirmPlanProdOrderLine: Record "Prod. Order Line";
                                                                         var pReleasedProdOrderLine: Record "Prod. Order Line";
                                                                         var Temp_pTotalAvailabilityBuffer: Record "ecComponent Availability Buff." temporary;
                                                                         pItemNo: Code[20];
                                                                         pVariantCode: Code[10];
                                                                         pShowDialog: Boolean)
    var
        Temp_lFirmPlanCompAvailabilityBuffer: Record "ecComponent Availability Buff." temporary;
        Temp_lReleasedCompAvailabilityBuffer: Record "ecComponent Availability Buff." temporary;
    begin
        //CS_PRO_018-s
        //Calcolo il buffer dei componenti raggruppate per vincolo delle righe di ODP confermati selezionati
        Clear(Temp_lFirmPlanCompAvailabilityBuffer);
        Temp_lFirmPlanCompAvailabilityBuffer.DeleteAll();
        CreateGroupedAvailabilityBuff(pFirmPlanProdOrderLine, pItemNo, pVariantCode, Temp_lFirmPlanCompAvailabilityBuffer,
                                      Enum::"ecAvailability Buffer Grouping"::"Prod. Order Comp. Grouped Restrictions", pShowDialog);

        //Calcolo il buffer dei componenti raggruppate per vincolo di tutte le righe ODP rilasciati prendendo solo la riga padre
        Clear(Temp_lReleasedCompAvailabilityBuffer);
        Temp_lReleasedCompAvailabilityBuffer.DeleteAll();
        pReleasedProdOrderLine.SetFilter("Remaining Qty. (Base)", '<>%1', 0);
        pReleasedProdOrderLine.SetRange("ecParent Line No.", 0);
        if not pReleasedProdOrderLine.IsEmpty then begin
            CreateGroupedAvailabilityBuff(pReleasedProdOrderLine, pItemNo, pVariantCode, Temp_lReleasedCompAvailabilityBuffer,
                                          Enum::"ecAvailability Buffer Grouping"::"Prod. Order Comp. Grouped Restrictions", pShowDialog);
        end;

        //Unisco i risultati ottenuti per le righe di ODP Confermati e Rilasciati in un unico buffer        
        CreateTotalAvailabilityBuffer(Temp_lFirmPlanCompAvailabilityBuffer, Temp_lReleasedCompAvailabilityBuffer, Temp_pTotalAvailabilityBuffer, pShowDialog);
        //CS_PRO_018-e
    end;

    internal procedure CreateTotalAvailabilityBuffer(var Temp_pFirmPlanCompAvailabilityBuffer: Record "ecComponent Availability Buff." temporary;
                                                     var Temp_pReleasedCompAvailabilityBuffer: Record "ecComponent Availability Buff." temporary;
                                                     var Temp_pTotalAvailabilityBuffer: Record "ecComponent Availability Buff." temporary;
                                                     pShowDialog: Boolean)
    var
        latsProgressDialogMgr: Codeunit "AltATSProgress Dialog Mgr.";
        lEntryNo: Integer;

        lDialogText: Label 'Calculation of restriction details...\@1@@@@@@@@@@@@@';
    begin
        //CS_PRO_018-s
        Clear(Temp_pTotalAvailabilityBuffer);
        Temp_pTotalAvailabilityBuffer.DeleteAll();
        lEntryNo := 0;

        //Inserisco direttamente i record degli ODP confermati nel buffer di aggregazione         
        Clear(Temp_pFirmPlanCompAvailabilityBuffer);
        Clear(Temp_pReleasedCompAvailabilityBuffer);
        Temp_pReleasedCompAvailabilityBuffer.SetCurrentKey("Item No.", "Variant Code", "Location Code",
                                                           "Entry Type", "Restriction Rule Code", "Origin Country/Region Code", "Single Lot Pickings");
        Temp_pTotalAvailabilityBuffer.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Entry Type",
                                                    "Restriction Rule Code", "Origin Country/Region Code", "Single Lot Pickings");
        if not Temp_pFirmPlanCompAvailabilityBuffer.IsEmpty then begin
            Temp_pFirmPlanCompAvailabilityBuffer.FindSet();
            if pShowDialog then latsProgressDialogMgr.OpenProgressDialog(lDialogText, 1, Temp_pFirmPlanCompAvailabilityBuffer.Count);
            repeat
                if pShowDialog then latsProgressDialogMgr.UpdateProgress(1);
                lEntryNo += 1;
                Temp_pTotalAvailabilityBuffer := Temp_pFirmPlanCompAvailabilityBuffer;
                Temp_pTotalAvailabilityBuffer."Entry No." := lEntryNo;
                Temp_pTotalAvailabilityBuffer.Quantity := Temp_pFirmPlanCompAvailabilityBuffer.Quantity;
                Temp_pTotalAvailabilityBuffer."Qty. on Component Lines" := Temp_pTotalAvailabilityBuffer.Quantity;
                Temp_pTotalAvailabilityBuffer.Insert(false);

                Temp_pReleasedCompAvailabilityBuffer.SetRange("Item No.", Temp_pFirmPlanCompAvailabilityBuffer."Item No.");
                Temp_pReleasedCompAvailabilityBuffer.SetRange("Variant Code", Temp_pFirmPlanCompAvailabilityBuffer."Variant Code");
                Temp_pReleasedCompAvailabilityBuffer.SetRange("Location Code", Temp_pFirmPlanCompAvailabilityBuffer."Location Code");
                if not Temp_pReleasedCompAvailabilityBuffer.IsEmpty then begin
                    Temp_pReleasedCompAvailabilityBuffer.FindSet();
                    repeat
                        Temp_pTotalAvailabilityBuffer.SetRange("Item No.", Temp_pReleasedCompAvailabilityBuffer."Item No.");
                        Temp_pTotalAvailabilityBuffer.SetRange("Variant Code", Temp_pReleasedCompAvailabilityBuffer."Variant Code");
                        Temp_pTotalAvailabilityBuffer.SetRange("Location Code", Temp_pReleasedCompAvailabilityBuffer."Location Code");
                        Temp_pTotalAvailabilityBuffer.SetRange("Entry Type", Temp_pReleasedCompAvailabilityBuffer."Entry Type"::"Prod. Order Comp. Grouped Restrictions");
                        Temp_pTotalAvailabilityBuffer.SetRange("Restriction Rule Code", Temp_pReleasedCompAvailabilityBuffer."Restriction Rule Code");
                        Temp_pTotalAvailabilityBuffer.SetRange("Origin Country/Region Code", Temp_pReleasedCompAvailabilityBuffer."Origin Country/Region Code");
                        Temp_pTotalAvailabilityBuffer.SetRange("Single Lot Pickings", Temp_pReleasedCompAvailabilityBuffer."Single Lot Pickings");
                        if Temp_pTotalAvailabilityBuffer.IsEmpty then begin
                            lEntryNo += 1;
                            Temp_pTotalAvailabilityBuffer := Temp_pReleasedCompAvailabilityBuffer;
                            Temp_pTotalAvailabilityBuffer."Entry No." := lEntryNo;
                            Temp_pTotalAvailabilityBuffer."Qty.Rel. Component Lines" := Temp_pReleasedCompAvailabilityBuffer.Quantity;
                            Temp_pTotalAvailabilityBuffer."Qty. on Component Lines" := Temp_pTotalAvailabilityBuffer.Quantity;
                            Temp_pTotalAvailabilityBuffer.Quantity := 0;
                            Temp_pTotalAvailabilityBuffer.Insert(false);
                        end else begin
                            Temp_pTotalAvailabilityBuffer.FindFirst();
                            Temp_pTotalAvailabilityBuffer."Qty.Rel. Component Lines" += Temp_pReleasedCompAvailabilityBuffer.Quantity;
                            Temp_pTotalAvailabilityBuffer."Qty. on Component Lines" := Temp_pTotalAvailabilityBuffer.Quantity + Temp_pTotalAvailabilityBuffer."Qty.Rel. Component Lines";
                            if ((Temp_pTotalAvailabilityBuffer."Min Consumption Date" > Temp_pReleasedCompAvailabilityBuffer."Due Date") or
                               (Temp_pTotalAvailabilityBuffer."Min Consumption Date" = 0D)) and (Temp_pReleasedCompAvailabilityBuffer."Due Date" <> 0D)
                            then begin
                                Temp_pTotalAvailabilityBuffer."Min Consumption Date" := Temp_pReleasedCompAvailabilityBuffer."Due Date";
                            end;
                            if (Temp_pTotalAvailabilityBuffer."Max Consumption Date" < Temp_pReleasedCompAvailabilityBuffer."Due Date") then begin
                                Temp_pTotalAvailabilityBuffer."Max Consumption Date" := Temp_pReleasedCompAvailabilityBuffer."Due Date";
                            end;
                            Temp_pTotalAvailabilityBuffer.Modify(false);
                        end;
                    until (Temp_pReleasedCompAvailabilityBuffer.Next() = 0);
                end;
            until (Temp_pFirmPlanCompAvailabilityBuffer.Next() = 0);
            if pShowDialog then latsProgressDialogMgr.CloseProgressDialog();
        end;

        //Calcolo delle disponibilità relative ad ogni riga anche in funzione delle restrizioni presenti        
        CalcCompAvailabilityFromRestriction(Temp_pTotalAvailabilityBuffer, pShowDialog);
        //CS_PRO_018-e
    end;

    local procedure CalcCompAvailabilityFromRestriction(var Temp_pAvailabilityBuffer: Record "ecComponent Availability Buff." temporary; pShowDialog: Boolean)
    var
        Temp_lComponentDistinctBuffer: Record "ecComponent Availability Buff." temporary;
        Temp_lAWPItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary;
        lDialog: Dialog;
        lTargetDate: Date;

        lDialogText: Label 'Availability quantity calculation...';
    begin
        //CS_PRO_018-s
        if pShowDialog then lDialog.Open(lDialogText);

        //Creo un buffer schiacciando solo per componente/variante/ubicazione da utilizzarlo per ottenere l'analisi giacenze
        CreateComponentDistinctBuffer(Temp_pAvailabilityBuffer, Temp_lComponentDistinctBuffer);

        //Per ogni componente eseguo l'analisi delle giacenze e carico tutto in un buffer
        GetOpenWhseEntriesFromCompBuffer(Temp_lComponentDistinctBuffer, Temp_lAWPItemInventoryBuffer);

        //Per ogni riga di componente calcolo la sua disponibilità guardando il buffer di analisi giacenze considerando anche 
        //la compatibilità del lotto con l'eventuale restrizione presente
        Clear(Temp_pAvailabilityBuffer);
        if not Temp_pAvailabilityBuffer.IsEmpty then begin
            Temp_pAvailabilityBuffer.FindSet();
            repeat
                Temp_lAWPItemInventoryBuffer.SetRange("Item No.", Temp_pAvailabilityBuffer."Item No.");
                Temp_lAWPItemInventoryBuffer.SetRange("Variant Code", Temp_pAvailabilityBuffer."Variant Code");
                Temp_lAWPItemInventoryBuffer.SetRange("Location Code", Temp_pAvailabilityBuffer."Location Code");
                if not Temp_lAWPItemInventoryBuffer.IsEmpty then begin
                    Temp_lAWPItemInventoryBuffer.FindSet();
                    repeat
                        //Se passo i controlli di compatibilità della giacenza analizzata aggiorno le giacenze calcolate
                        if CheckInventoryCompatibilityForComponent(Temp_pAvailabilityBuffer, Temp_lAWPItemInventoryBuffer) then begin
                            //Calcolo giacenze scadute e utilizzabili in funzione del calcolo richiesto
                            case AvailabilityCalcMethod of
                                AvailabilityCalcMethod::"Till to First Usage Date":
                                    begin
                                        lTargetDate := Temp_pAvailabilityBuffer."Min Consumption Date";
                                    end;
                                AvailabilityCalcMethod::"Till to Last Usage Date":
                                    begin
                                        lTargetDate := Temp_pAvailabilityBuffer."Max Consumption Date";
                                    end;
                                AvailabilityCalcMethod::"Custom Period Cut-Off Date":
                                    begin
                                        lTargetDate := TargetAnalysisDate;
                                    end;
                            end;

                            //Calcolo il dettaglio delle quantità in analisi
                            CalcQuantitiesFromItemInvBufferRecord(Temp_lAWPItemInventoryBuffer,
                                                                  Temp_pAvailabilityBuffer."Inventory Constraint",
                                                                  Temp_pAvailabilityBuffer."Inventory Not Constraint",
                                                                  Temp_pAvailabilityBuffer."Usable Quantity",
                                                                  Temp_pAvailabilityBuffer."Expired Quantity",
                                                                  Temp_pAvailabilityBuffer."Inventory Total",
                                                                  lTargetDate);
                            Temp_pAvailabilityBuffer.Modify(true);
                        end;
                    until (Temp_lAWPItemInventoryBuffer.Next() = 0);
                end;
            until (Temp_pAvailabilityBuffer.Next() = 0);
        end;

        if pShowDialog then lDialog.Close();
        //CS_PRO_018-e
    end;

    local procedure CheckInventoryCompatibilityForComponent(var Temp_pAvailabilityBuffer: Record "ecComponent Availability Buff." temporary;
                                                            var Temp_pAWPItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary): Boolean
    var
        lLotNoInformation: Record "Lot No. Information";
        lRestrictionsMgt: Codeunit "ecRestrictions Mgt.";
        lUsableInventory: Boolean;
    begin
        lUsableInventory := true;

        //Controllo subito se esiste la scheda lotto per i componenti che hanno restrizioni su Paese Origine,Regole Restr. o Mono Lotto
        if (Temp_pAvailabilityBuffer."Origin Country/Region Code" <> '') or (Temp_pAvailabilityBuffer."Restriction Rule Code" <> '') or
           (Temp_pAvailabilityBuffer."Single Lot Pickings")
        then begin
            if (Temp_pAWPItemInventoryBuffer."Lot No." = '') or
                not lLotNoInformation.Get(Temp_pAvailabilityBuffer."Item No.", Temp_pAvailabilityBuffer."Variant Code",
                                          Temp_pAWPItemInventoryBuffer."Lot No.")
            then begin
                lUsableInventory := false;
            end;
        end;

        //Controllo che l'eventuale Paese di Origine o la restrizione sia compatibile con il lotto analizzato
        if lUsableInventory then begin
            if (Temp_pAvailabilityBuffer."Origin Country/Region Code" <> '') and
               (lLotNoInformation."ecOrigin Country Code" <> Temp_pAvailabilityBuffer."Origin Country/Region Code")
            then begin
                lUsableInventory := false;
            end;
            if (Temp_pAvailabilityBuffer."Restriction Rule Code" <> '') then begin
                if not lRestrictionsMgt.EvaluateLotNoRestrictionsRule(lLotNoInformation, Temp_pAvailabilityBuffer."Restriction Rule Code") then begin
                    lUsableInventory := false;
                end;
            end;
        end;

        exit(lUsableInventory);
    end;

    internal procedure CreateAvailabBuffGroupedByCompForSchedulingMonitor(var pReleasedProdOrderLine: Record "Prod. Order Line";
                                                                          var Temp_lReleasedCompAvailabilityBuffer: Record "ecComponent Availability Buff." temporary;
                                                                          pItemNo: Code[20];
                                                                          pVariantCode: Code[10];
                                                                          pShowDialog: Boolean)
    begin
        //CS_PRO_018-s
        //Calcolo il buffer dei componenti raggruppate per vincolo delle righe di ODP rilasciati selezionati
        Clear(Temp_lReleasedCompAvailabilityBuffer);
        Temp_lReleasedCompAvailabilityBuffer.DeleteAll();
        CreateGroupedAvailabilityBuff(pReleasedProdOrderLine, pItemNo, pVariantCode, Temp_lReleasedCompAvailabilityBuffer,
                                      Enum::"ecAvailability Buffer Grouping"::"Prod. Order Comp. Grouped Restrictions", pShowDialog);

        //Calcolo delle disponibilità relative ad ogni riga anche in funzione delle restrizioni presenti        
        CalcCompAvailabilityFromRestriction(Temp_lReleasedCompAvailabilityBuffer, pShowDialog);
        //CS_PRO_018-e
    end;

    internal procedure SetAvailabilityCalcMethod(pAvailabilityCalcMethod: Option "Till to First Usage Date","Till to Last Usage Date","Custom Period Cut-Off Date";
                                                 pAnalysisDate: Date);
    begin
        //CS_PRO_018-s
        AvailabilityCalcMethod := pAvailabilityCalcMethod;
        TargetAnalysisDate := pAnalysisDate;
        //CS_PRO_018-e
    end;

    internal procedure CalcAvailabilityFromItemInventoryBuffer(var Temp_pAWPItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary;
                                                               var pConstraintQty: Decimal;
                                                               var pNotConstraintQty: Decimal;
                                                               var pUsableQty: Decimal;
                                                               var pExpiredQty: Decimal;
                                                               var pTotalQty: Decimal;
                                                                   pTargetDate: Date)
    begin
        //CS_PRO_018-s
        pConstraintQty := 0;
        pNotConstraintQty := 0;
        pUsableQty := 0;
        pExpiredQty := 0;
        pTotalQty := 0;

        Clear(Temp_pAWPItemInventoryBuffer);
        if Temp_pAWPItemInventoryBuffer.IsEmpty then exit;
        Temp_pAWPItemInventoryBuffer.FindSet();
        repeat
            CalcQuantitiesFromItemInvBufferRecord(Temp_pAWPItemInventoryBuffer, pConstraintQty, pNotConstraintQty, pUsableQty,
                                                  pExpiredQty, pTotalQty, pTargetDate);
        until (Temp_pAWPItemInventoryBuffer.Next() = 0);
        //CS_PRO_018-e
    end;

    internal procedure CalcQuantitiesFromItemInvBufferRecord(var Temp_pAWPItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary;
                                                             var pConstraintQty: Decimal;
                                                             var pNotConstraintQty: Decimal;
                                                             var pUsableQty: Decimal;
                                                             var pExpiredQty: Decimal;
                                                             var pTotalQty: Decimal;
                                                                 pTargetDate: Date)
    begin
        //CS_PRO_018-s
        if (Temp_pAWPItemInventoryBuffer."Entry No." = 0) then exit;

        //Calcolo della quantità scaduta
        if (Temp_pAWPItemInventoryBuffer."ecMax Usable Date" < pTargetDate) and
           (Temp_pAWPItemInventoryBuffer."ecMax Usable Date" <> 0D)
        then begin
            pExpiredQty += Temp_pAWPItemInventoryBuffer."Quantity (Base)";
        end;

        //Calcolo giacenze vincolate e non vincolate e quantità utilizzabile
        if not Temp_pAWPItemInventoryBuffer.Constrained then begin
            pNotConstraintQty += Temp_pAWPItemInventoryBuffer."Quantity (Base)";

            if (Temp_pAWPItemInventoryBuffer."ecMax Usable Date" >= pTargetDate) or
               (Temp_pAWPItemInventoryBuffer."ecMax Usable Date" = 0D)
            then begin
                pUsableQty += Temp_pAWPItemInventoryBuffer."Quantity (Base)";
            end;
        end else begin
            pConstraintQty += Temp_pAWPItemInventoryBuffer."Quantity (Base)";
        end;

        pTotalQty += Temp_pAWPItemInventoryBuffer."Quantity (Base)";
        //CS_PRO_018-e
    end;

    local procedure CreateComponentDistinctBuffer(var Temp_pTotalAvailabilityBuffer: Record "ecComponent Availability Buff." temporary;
                                                  var Temp_pComponentDistinctBuffer: Record "ecComponent Availability Buff." temporary)
    begin
        //CS_PRO_018-s
        Clear(Temp_pComponentDistinctBuffer);
        Temp_pComponentDistinctBuffer.DeleteAll();

        Clear(Temp_pTotalAvailabilityBuffer);
        if not Temp_pTotalAvailabilityBuffer.IsEmpty then begin
            Temp_pTotalAvailabilityBuffer.FindSet();
            repeat
                Temp_pComponentDistinctBuffer.SetRange("Item No.", Temp_pTotalAvailabilityBuffer."Item No.");
                Temp_pComponentDistinctBuffer.SetRange("Variant Code", Temp_pTotalAvailabilityBuffer."Variant Code");
                Temp_pComponentDistinctBuffer.SetRange("Location Code", Temp_pTotalAvailabilityBuffer."Location Code");
                if Temp_pComponentDistinctBuffer.IsEmpty then begin
                    Temp_pComponentDistinctBuffer := Temp_pTotalAvailabilityBuffer;
                    Temp_pComponentDistinctBuffer.Insert(false);
                end;
            until (Temp_pTotalAvailabilityBuffer.Next() = 0);
        end;
        //CS_PRO_018-e
    end;

    local procedure GetOpenWhseEntriesFromCompBuffer(var Temp_pComponentBuffer: Record "ecComponent Availability Buff." temporary;
                                                     var Temp_pTotalCompInventoryBuf: Record "AltAWPItem Inventory Buffer" temporary)
    var
        Temp_lAWPItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary;
        lAWPLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
        lEntryNo: Integer;
    begin
        //CS_PRO_018-s
        Clear(Temp_pTotalCompInventoryBuf);
        Temp_pTotalCompInventoryBuf.DeleteAll();

        lEntryNo := 0;
        Clear(Temp_pComponentBuffer);
        if not Temp_pComponentBuffer.IsEmpty then begin
            Temp_pComponentBuffer.FindSet();
            repeat
                lAWPLogisticUnitsMgt.FindOpenWhseEntries(Temp_pComponentBuffer."Item No.", Temp_pComponentBuffer."Variant Code",
                                                         Temp_pComponentBuffer."Location Code", '', '', '', '', '', false, Temp_lAWPItemInventoryBuffer);
                if not Temp_lAWPItemInventoryBuffer.IsEmpty then begin
                    Temp_lAWPItemInventoryBuffer.FindSet();
                    repeat
                        lEntryNo += 1;
                        Temp_pTotalCompInventoryBuf := Temp_lAWPItemInventoryBuffer;
                        Temp_pTotalCompInventoryBuf."Entry No." := lEntryNo;
                        Temp_pTotalCompInventoryBuf.Insert(true);
                    until (Temp_lAWPItemInventoryBuffer.Next() = 0);
                end;
            until (Temp_pComponentBuffer.Next() = 0);
        end;
        //CS_PRO_018-e
    end;

    internal procedure CalcCompRemaningQtyInReleasedProdOrd(pItemNo: Code[20]; pVariantCode: Code[20]; pLocationCode: Code[10]): Decimal
    var
        lProdOrderComponent: Record "Prod. Order Component";
    begin
        //CS_PRO_018-s
        Clear(lProdOrderComponent);
        lProdOrderComponent.SetCurrentKey(Status, "Item No.", "Variant Code", "Location Code", "Due Date");
        lProdOrderComponent.SetRange(Status, lProdOrderComponent.Status::Released);
        lProdOrderComponent.SetRange("Item No.", pItemNo);
        lProdOrderComponent.SetRange("Variant Code", pVariantCode);
        lProdOrderComponent.SetRange("Location Code", pLocationCode);
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.CalcSums("Remaining Qty. (Base)");
            exit(lProdOrderComponent."Remaining Qty. (Base)");
        end;

        exit(0);
        //CS_PRO_018-e
    end;

    internal procedure ExistRelProdOrdCompWithRestriction(pItemNo: Code[20]; pVariantCode: Code[20]; pLocationCode: Code[10]): Boolean
    var
        lProdOrderLine: Record "Prod. Order Line";
        lProdOrderComponent: Record "Prod. Order Component";
        lComponentRestriction: Code[50];
        lOriginCountryRegionCode: Code[10];
        lExistRestriction: Boolean;
        lCompSingleLotPicking: Boolean;
    begin
        //CS_PRO_018-s
        Clear(lProdOrderComponent);
        lProdOrderComponent.SetCurrentKey(Status, "Item No.", "Variant Code", "Location Code", "Due Date");
        lProdOrderComponent.SetRange(Status, lProdOrderComponent.Status::Released);
        lProdOrderComponent.SetRange("Item No.", pItemNo);
        lProdOrderComponent.SetRange("Variant Code", pVariantCode);
        lProdOrderComponent.SetRange("Location Code", pLocationCode);
        if lProdOrderComponent.FindSet() then begin
            repeat
                lProdOrderLine.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.", lProdOrderComponent."Prod. Order Line No.");
                GetComponentRestrictionRules(lProdOrderComponent, lComponentRestriction, lOriginCountryRegionCode, lCompSingleLotPicking);
                if (lComponentRestriction <> '') or (lOriginCountryRegionCode <> '') or (lCompSingleLotPicking = true) then begin
                    lExistRestriction := true;
                end;
            until (lProdOrderComponent.Next() = 0) or lExistRestriction;

            exit(lExistRestriction);
        end;
        //CS_PRO_018-e
    end;

    internal procedure CalcCompRemaningQtyInRelProdOrdByRestriction(pItemNo: Code[20]; pVariantCode: Code[20]; pLocationCode: Code[10];
                                                                    pRestrictionCode: Code[50]; pOriginCountryRegionCode: Code[10];
                                                                    pSingleLotPicking: Boolean): Decimal
    var
        lProdOrderLine: Record "Prod. Order Line";
        lProdOrderComponent: Record "Prod. Order Component";
        lComponentRestriction: Code[50];
        lOriginCountryRegionCode: Code[10];
        lCompSingleLotPicking: Boolean;
        lRemainingQty: Decimal;
    begin
        //CS_PRO_018-s
        lRemainingQty := 0;
        Clear(lProdOrderComponent);
        lProdOrderComponent.SetCurrentKey(Status, "Item No.", "Variant Code", "Location Code", "Due Date");
        lProdOrderComponent.SetRange(Status, lProdOrderComponent.Status::Released);
        lProdOrderComponent.SetRange("Item No.", pItemNo);
        lProdOrderComponent.SetRange("Variant Code", pVariantCode);
        lProdOrderComponent.SetRange("Location Code", pLocationCode);
        if lProdOrderComponent.FindSet() then begin
            repeat
                lProdOrderLine.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.", lProdOrderComponent."Prod. Order Line No.");
                GetComponentRestrictionRules(lProdOrderComponent, lComponentRestriction, lOriginCountryRegionCode, lCompSingleLotPicking);
                if (lComponentRestriction = pRestrictionCode) and (lOriginCountryRegionCode = pOriginCountryRegionCode) and
                   (lCompSingleLotPicking = pSingleLotPicking)
                then begin
                    lRemainingQty += lProdOrderComponent."Remaining Qty. (Base)";
                end;
            until (lProdOrderComponent.Next() = 0);

            exit(lRemainingQty);
        end;
        //CS_PRO_018-e
    end;

    internal procedure GetComponentRestrictionRules(pProdOrderComponent: Record "Prod. Order Component";
                                                    var pRestrictionRuleCode: Code[50];
                                                    var pOriginCountryRegionCode: Code[10];
                                                    var pSingleLotPickings: Boolean)
    var
        lCommercialProductiveRestr: Record "ecCommercial/Productive Restr.";
        lRestrictionsMgt: Codeunit "ecRestrictions Mgt.";
    begin
        //CS_PRO_018-s
        pRestrictionRuleCode := '';
        pSingleLotPickings := false;
        pOriginCountryRegionCode := '';
        if lRestrictionsMgt.RestrictionsAllowedForItem(pProdOrderComponent."Item No.") then begin
            if lRestrictionsMgt.FindProdOrderComponentRestrictions(pProdOrderComponent, lCommercialProductiveRestr, pOriginCountryRegionCode) then begin
                pRestrictionRuleCode := lCommercialProductiveRestr."Restriction Rule Code";
                pSingleLotPickings := lCommercialProductiveRestr."Single Lot Pickings";
            end;
        end;
        //CS_PRO_018-e
    end;

    internal procedure GetProdOrdCompLinesByRestriction(var Temp_pProdOrderComponent: Record "Prod. Order Component" temporary;
                                                            pProdOrderStatus: Enum "Production Order Status";
                                                            pItemNo: Code[20];
                                                            pVariantCode: Code[10];
                                                            pLocationCode: Code[10];
                                                            pBinCode: Code[20];
                                                            pRestrictionCode: Code[50];
                                                            pSingleLotPicking: Boolean;
                                                            pOriginCountryRegionCode: Code[10])
    var
        lProdOrderComponent: Record "Prod. Order Component";
        lCommercialProductiveRestr: Record "ecCommercial/Productive Restr.";
        lRestrictionsMgt: Codeunit "ecRestrictions Mgt.";
        lRestrictionRuleCode: Code[50];
        lOriginCountryRegionCode: Code[10];
        lSingleLotPicking: Boolean;
    begin
        //CS_PRO_018-s
        Clear(Temp_pProdOrderComponent);
        Temp_pProdOrderComponent.DeleteAll();

        if (pItemNo = '') then exit;

        Clear(lProdOrderComponent);
        lProdOrderComponent.SetCurrentKey(Status, "Item No.", "Variant Code", "Location Code", "Due Date");
        lProdOrderComponent.SetRange(Status, pProdOrderStatus);
        lProdOrderComponent.SetRange("Item No.", pItemNo);
        lProdOrderComponent.SetRange("Variant Code", pVariantCode);
        lProdOrderComponent.SetRange("Location Code", pLocationCode);
        lProdOrderComponent.SetFilter("Bin Code", pBinCode);
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindSet();
            repeat
                if lRestrictionsMgt.FindProdOrderComponentRestrictions(lProdOrderComponent, lCommercialProductiveRestr, lOriginCountryRegionCode) then begin
                    lRestrictionRuleCode := lCommercialProductiveRestr."Restriction Rule Code";
                    lSingleLotPicking := lCommercialProductiveRestr."Single Lot Pickings";
                    if (lRestrictionRuleCode = pRestrictionCode) and
                       (lSingleLotPicking = pSingleLotPicking) and
                       (pOriginCountryRegionCode = lOriginCountryRegionCode)
                    then begin
                        Temp_pProdOrderComponent := lProdOrderComponent;
                        Temp_pProdOrderComponent.Insert();
                    end;
                end else begin
                    if (pRestrictionCode = '') and not pSingleLotPicking and (pOriginCountryRegionCode = '') then begin
                        Temp_pProdOrderComponent := lProdOrderComponent;
                        Temp_pProdOrderComponent.Insert();
                    end;
                end;
            until (lProdOrderComponent.Next() = 0);
        end;
        //CS_PRO_018-e
    end;

    internal procedure GetTotalInventoryAvailabFromComponentBuff(var Temp_pComponentBuffer: Record "ecComponent Availability Buff." temporary;
                                                                 var Temp_pItemInventoryAvailabBuffer: Record "AltAWPItem Inventory Buffer" temporary)
    var
        Temp_lAWPItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary;
        lAWPLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
    begin
        //CS_PRO_018-s
        Clear(Temp_pItemInventoryAvailabBuffer);
        Temp_pItemInventoryAvailabBuffer.DeleteAll();

        lAWPLogisticUnitsMgt.FindOpenWhseEntries(Temp_pComponentBuffer."Item No.", Temp_pComponentBuffer."Variant Code",
                                                 Temp_pComponentBuffer."Location Code", '', '', '', '', '', false, Temp_lAWPItemInventoryBuffer);
        if not Temp_lAWPItemInventoryBuffer.IsEmpty then begin
            Temp_lAWPItemInventoryBuffer.FindSet();
            repeat
                if CheckInventoryCompatibilityForComponent(Temp_pComponentBuffer, Temp_lAWPItemInventoryBuffer) then begin
                    Temp_pItemInventoryAvailabBuffer := Temp_lAWPItemInventoryBuffer;
                    Temp_pItemInventoryAvailabBuffer.Insert();
                end;
            until (Temp_lAWPItemInventoryBuffer.Next() = 0);
        end;
        //CS_PRO_018-e
    end;

    internal procedure GetMainProdOrdLinesFromSelected(var pSelectedProdOrdLines: Record "Prod. Order Line"; var Temp_pMainProdOrdLines: Record "Prod. Order Line" temporary)
    var
        lProdOrderLine: Record "Prod. Order Line";
    begin
        //Inserisco all'interno di un buffer la riga principale realtiva alla riga di ODP selezionata
        Clear(Temp_pMainProdOrdLines);
        Temp_pMainProdOrdLines.DeleteAll();

        if pSelectedProdOrdLines.IsEmpty then exit;
        pSelectedProdOrdLines.FindSet();
        repeat
            lProdOrderLine.SetRange(Status, pSelectedProdOrdLines.Status);
            lProdOrderLine.SetRange("Prod. Order No.", pSelectedProdOrdLines."Prod. Order No.");
            lProdOrderLine.SetRange("ecParent Line No.", 0);
            if not lProdOrderLine.IsEmpty then begin
                lProdOrderLine.FindFirst();
                if not Temp_pMainProdOrdLines.Get(lProdOrderLine.Status, lProdOrderLine."Prod. Order No.", lProdOrderLine."Line No.") then begin
                    Temp_pMainProdOrdLines := lProdOrderLine;
                    Temp_pMainProdOrdLines.Insert(false);
                end;
            end;
        until (pSelectedProdOrdLines.Next() = 0);
    end;
}
