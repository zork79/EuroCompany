namespace EuroCompany.BaseApp.Inventory;

using EuroCompany.BaseApp.Inventory.ItemCatalog;
using EuroCompany.BaseApp.Inventory.Reports;
using EuroCompany.BaseApp.Warehouse.Ledger;
using Microsoft.Foundation.Shipping;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Journal;
using Microsoft.Manufacturing.Capacity;
using Microsoft.Manufacturing.Document;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Sales.Document;
using Microsoft.Warehouse.Activity;
using Microsoft.Warehouse.Document;
using Microsoft.Warehouse.Journal;
using Microsoft.Warehouse.Ledger;

codeunit 50014 "ecLogistc Functions"
{
    #region CS_ACQ_004 - Stampa etichette Pallet/Box
    procedure FillInventoryLabelsBuffer(pWhseDocumentType: Enum "Warehouse Journal Document Type";
                                        pWhseDocumentNo: Code[20];
                                        pWhseDocumentLineNo: Integer;
                                        var Temp_pLabelsBuffer: Record "AltAWPLogistic Labels Buffer" temporary
                                       ): Boolean
    var
        lWarehouseEntry: Record "Warehouse Entry";
        lItem: Record Item;
        lLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
        lAllowedEntry: Boolean;
    begin
        Clear(Temp_pLabelsBuffer);
        Temp_pLabelsBuffer.DeleteAll();

        lWarehouseEntry.Reset();
        if (pWhseDocumentType = pWhseDocumentType::Production) then begin
            lWarehouseEntry.SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.");
            lWarehouseEntry.SetFilter("Source Type", '%1|%2|%3', Database::"Item Journal Line",
                                                                 Database::"Prod. Order Line",
                                                                 Database::"Prod. Order Component");

            lWarehouseEntry.SetFilter("Source Subtype", '%1|%2|%3', lWarehouseEntry."Source Subtype"::"3",
                                                                    lWarehouseEntry."Source Subtype"::"4",
                                                                    lWarehouseEntry."Source Subtype"::"5");
            lWarehouseEntry.SetRange("Source No.", pWhseDocumentNo);
            if (pWhseDocumentLineNo <> 0) then begin
                lWarehouseEntry.SetRange("Source Line No.", pWhseDocumentLineNo);
            end;
        end else begin
            lWarehouseEntry.SetCurrentKey("Whse. Document No.", "Whse. Document Line No.", "Whse. Document Type");
            lWarehouseEntry.SetRange("Whse. Document No.", pWhseDocumentNo);
            if (pWhseDocumentLineNo <> 0) then begin
                lWarehouseEntry.SetRange("Whse. Document Line No.", pWhseDocumentLineNo);
            end;

            lWarehouseEntry.SetRange("Whse. Document Type", pWhseDocumentType);
        end;

        lWarehouseEntry.SetRange(AltAWPCorrection, false);
        lWarehouseEntry.SetFilter(Quantity, '>%1', 0);
        if lWarehouseEntry.FindSet() then begin
            repeat
                lAllowedEntry := true;
                if (lWarehouseEntry."Source Document" in [lWarehouseEntry."Source Document"::"Consumption Jnl.",
                                                          lWarehouseEntry."Source Document"::"Prod. Consumption"])
                then begin
                    lAllowedEntry := false;
                    if lItem.Get(lWarehouseEntry."Item No.") then begin
                        lAllowedEntry := lItem."ecBy Product Item";
                    end;
                end;

                if lAllowedEntry then begin
                    if (lWarehouseEntry."AltAWPPallet No." <> '') then begin
                        lLogisticUnitsMgt.FillHistoricalInvPalletLabelBuff(lWarehouseEntry."Whse. Document Type", lWarehouseEntry."Whse. Document No.",
                                                                           lWarehouseEntry."AltAWPPallet No.", Temp_pLabelsBuffer);
                    end;

                    if (lWarehouseEntry."AltAWPBox No." <> '') then begin
                        lLogisticUnitsMgt.FillHistoricalInvBoxLabelBuffer(lWarehouseEntry."Whse. Document Type", lWarehouseEntry."Whse. Document No.",
                                                                          lWarehouseEntry."AltAWPPallet No.", lWarehouseEntry."AltAWPBox No.",
                                                                          Temp_pLabelsBuffer);
                    end;
                end;
            until (lWarehouseEntry.Next() = 0);
        end;

        Temp_pLabelsBuffer.Reset();
        if (pWhseDocumentType = pWhseDocumentType::Production) then begin
            if not Temp_pLabelsBuffer.IsEmpty then begin
                Temp_pLabelsBuffer.ModifyAll("Whse. Document Line No.", pWhseDocumentLineNo);
            end;
        end;

        exit(not Temp_pLabelsBuffer.IsEmpty);
    end;

    internal procedure PrintInventoryLabelsByPostedWhseRcpt(pPostedWhseRcptNo: Code[20])
    var
        Temp_lLabelsBuffer: Record "AltAWPLogistic Labels Buffer" temporary;
        lInventoryBoxLabel: Report "ecInventory Box Label";
    begin
        //CS_ACQ_004-s
        if FillInventoryLabelsBuffer(Enum::"Warehouse Journal Document Type"::Receipt,
                                     pPostedWhseRcptNo, 0, Temp_lLabelsBuffer)
        then begin
            Temp_lLabelsBuffer.SetRange("Record Type", Temp_lLabelsBuffer."Record Type"::Master);
            if not Temp_lLabelsBuffer.IsEmpty then begin
                Clear(lInventoryBoxLabel);
                lInventoryBoxLabel.SetLabelBuffer(Temp_lLabelsBuffer);
                lInventoryBoxLabel.UseRequestPage(true);
                lInventoryBoxLabel.RunModal();
            end;
        end;
        //CS_ACQ_004-e
    end;

    procedure PrintInventoryLabelsByProductionOrderLine(pProdOrderLine: Record "Prod. Order Line"; pSelectTransactionsToPrint: Boolean)
    begin
        //CS_ACQ_004-s
        if not pSelectTransactionsToPrint then begin
            PrintInventoryLabelsByProdOrderLine(pProdOrderLine);
        end else begin
            SelectProdOrderLineEntriesToPrint(pProdOrderLine);
        end;
        //CS_ACQ_004-e
    end;

    local procedure PrintInventoryLabelsByProdOrderLine(pProdOrderLine: Record "Prod. Order Line")
    var
        Temp_lLabelsBuffer: Record "AltAWPLogistic Labels Buffer" temporary;
        lecProdPalletBoxLabel: Report "ecProd. Pallet/Box Label";
    begin
        //CS_ACQ_004-s
        if FillInventoryLabelsBuffer(Enum::"Warehouse Journal Document Type"::Production,
                                    pProdOrderLine."Prod. Order No.",
                                    pProdOrderLine."Line No.",
                                    Temp_lLabelsBuffer)
        then begin
            Temp_lLabelsBuffer.SetRange("Record Type", Temp_lLabelsBuffer."Record Type"::Master);
            if not Temp_lLabelsBuffer.IsEmpty then begin
                Clear(lecProdPalletBoxLabel);
                lecProdPalletBoxLabel.SetLabelBuffer(Temp_lLabelsBuffer);
                lecProdPalletBoxLabel.UseRequestPage(true);
                lecProdPalletBoxLabel.RunModal();
            end;
            //CS_ACQ_004-e
        end;
    end;

    local procedure SelectProdOrderLineEntriesToPrint(pProdOrderLine: Record "Prod. Order Line")
    var
        Temp_lLabelsBuffer: Record "AltAWPLogistic Labels Buffer" temporary;
        lWarehouseEntry: Record "Warehouse Entry";
        Temp_lWarehouseEntry2: Record "Warehouse Entry" temporary;
        lecProdPalletBoxLabel: Report "ecProd. Pallet/Box Label";
        lLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
        lWarehouseEntriestoPrint: Page "ecWarehouse Entries to Print";
        lPrevTransactionID: Guid;
        lIntegerTransID: Integer;
    begin
        //CS_ACQ_004-s
        Clear(lPrevTransactionID);
        Clear(Temp_lLabelsBuffer);
        Temp_lLabelsBuffer.DeleteAll();

        Clear(Temp_lWarehouseEntry2);
        Temp_lWarehouseEntry2.DeleteAll();

        lWarehouseEntry.Reset();
        lWarehouseEntry.SetCurrentKey("AltAWPWhse. Transaction ID");
        lWarehouseEntry.SetRange("Whse. Document No.", pProdOrderLine."Prod. Order No.");
        lWarehouseEntry.SetRange("Whse. Document Line No.", pProdOrderLine."Line No.");
        lWarehouseEntry.SetRange("Whse. Document Type", lWarehouseEntry."Whse. Document Type"::Production);
        lWarehouseEntry.SetRange("Source Document", lWarehouseEntry."Source Document"::"Output Jnl.");
        lWarehouseEntry.SetRange(AltAWPCorrection, false);
        lWarehouseEntry.SetFilter(Quantity, '>%1', 0);
        if lWarehouseEntry.FindSet() then begin
            repeat
                if (lWarehouseEntry."AltAWPPallet No." <> '') or (lWarehouseEntry."AltAWPBox No." <> '') then begin
                    if (lPrevTransactionID <> lWarehouseEntry."AltAWPWhse. Transaction ID") then begin
                        lIntegerTransID := lWarehouseEntry."Entry No.";
                        lPrevTransactionID := lWarehouseEntry."AltAWPWhse. Transaction ID";
                    end;

                    Temp_lWarehouseEntry2 := lWarehouseEntry;
                    Temp_lWarehouseEntry2."ecTransaction ID" := lIntegerTransID;
                    Temp_lWarehouseEntry2.Insert();
                end;
            until (lWarehouseEntry.Next() = 0);
        end;

        Clear(Temp_lWarehouseEntry2);
        Temp_lWarehouseEntry2.SetCurrentKey("ecTransaction ID");
        if not Temp_lWarehouseEntry2.IsEmpty then begin
            Temp_lWarehouseEntry2.FindLast();
            SelectAllWhseEntriesOfIntTransID(Temp_lWarehouseEntry2);

            Clear(Temp_lWarehouseEntry2);
            Clear(lWarehouseEntriestoPrint);
            lWarehouseEntriestoPrint.SetWhseEntriesRecords(Temp_lWarehouseEntry2);
            lWarehouseEntriestoPrint.RunModal();
            if not lWarehouseEntriestoPrint.LineConfirmed() then exit;
        end;

        Clear(Temp_lWarehouseEntry2);
        Temp_lWarehouseEntry2.SetRange("ecTransaction ID");
        Temp_lWarehouseEntry2.SetRange(ecSelected, true);
        if not Temp_lWarehouseEntry2.IsEmpty then begin
            Temp_lWarehouseEntry2.FindSet();
            repeat
                if (Temp_lWarehouseEntry2."AltAWPPallet No." <> '') then begin
                    lLogisticUnitsMgt.FillHistoricalInvPalletLabelBuff(Temp_lWarehouseEntry2."Whse. Document Type", Temp_lWarehouseEntry2."Whse. Document No.",
                                                                       Temp_lWarehouseEntry2."AltAWPPallet No.", Temp_lLabelsBuffer);
                end;

                if (Temp_lWarehouseEntry2."AltAWPBox No." <> '') then begin
                    lLogisticUnitsMgt.FillHistoricalInvBoxLabelBuffer(Temp_lWarehouseEntry2."Whse. Document Type", Temp_lWarehouseEntry2."Whse. Document No.",
                                                                      Temp_lWarehouseEntry2."AltAWPPallet No.", Temp_lWarehouseEntry2."AltAWPBox No.",
                                                                      Temp_lLabelsBuffer);
                end;
            until (Temp_lWarehouseEntry2.Next() = 0);
        end;

        if not Temp_lLabelsBuffer.IsEmpty then begin
            Temp_lLabelsBuffer.ModifyAll("Whse. Document Line No.", pProdOrderLine."Line No.");
        end;

        Temp_lLabelsBuffer.Reset();
        Temp_lLabelsBuffer.SetRange("Record Type", Temp_lLabelsBuffer."Record Type"::Master);
        if not Temp_lLabelsBuffer.IsEmpty then begin
            Clear(lecProdPalletBoxLabel);
            lecProdPalletBoxLabel.SetLabelBuffer(Temp_lLabelsBuffer);
            lecProdPalletBoxLabel.UseRequestPage(true);
            lecProdPalletBoxLabel.RunModal();
        end;
        //CS_ACQ_004-e
    end;

    internal procedure SelectAllWhseEntriesOfIntTransID(var Temp_pWarehouseEntry: Record "Warehouse Entry" temporary)
    var
        Temp_lWarehouseEntry2: Record "Warehouse Entry" temporary;
    begin
        //CS_ACQ_004-s
        Temp_lWarehouseEntry2 := Temp_pWarehouseEntry;

        if (Temp_pWarehouseEntry."Entry No." = 0) then exit;
        Temp_pWarehouseEntry.SetRange("ecTransaction ID", Temp_pWarehouseEntry."ecTransaction ID");
        if not Temp_pWarehouseEntry.IsEmpty then begin
            Temp_pWarehouseEntry.ModifyAll(ecSelected, true, false);
        end;
        if Temp_pWarehouseEntry.Get(Temp_lWarehouseEntry2."Entry No.") then;
        //CS_ACQ_004-e
    end;
    #endregion CS_ACQ_004 - Stampa etichette Pallet/Box

    #region CS_REP_001 - Livello di dettaglio delle stampe determinate da setup in anagrafica cliente

    procedure GetItemShipmentInfoText(pItemNo: Code[20];
                                      pVariantCode: Code[10];
                                      pSubjectType: Enum "AltAWPWhse Ship Subject Type";
                                      pSubjectNo: Code[20]): Text
    var
        lShipmentInfoText: Text;
        lPalletType: Code[20];
        lNoOfUnitsPerLayer: Decimal;
        lNoOfLayersPerPallet: Decimal;
        lStackable: Boolean;

        lLogisticInfo: Label 'Logistic informations:';
        lNoOfUnitsPerLayerText: Label 'No. of units per layer: %1';
        lNoOfLayersPerPalletText: Label 'No. of layers per pallet: %1';
        lStackableText: Label 'Stackable';
    begin
        GetItemLogisticsParameters(pItemNo, pVariantCode,
                                   pSubjectType, pSubjectNo,
                                   lPalletType, lNoOfUnitsPerLayer,
                                   lNoOfLayersPerPallet, lStackable);

        lShipmentInfoText := '';
        if (lNoOfLayersPerPallet <> 0) then lShipmentInfoText := StrSubstNo(lNoOfLayersPerPalletText, lNoOfLayersPerPallet);
        if (lNoOfUnitsPerLayer <> 0) then begin
            if (lShipmentInfoText <> '') then lShipmentInfoText += ', ';
            lShipmentInfoText += StrSubstNo(lNoOfUnitsPerLayerText, lNoOfUnitsPerLayer);
        end;
        if lStackable then begin
            if (lShipmentInfoText <> '') then lShipmentInfoText += ', ';
            lShipmentInfoText += lStackableText;
        end;
        if (lShipmentInfoText <> '') then begin
            lShipmentInfoText := lLogisticInfo + ' ' + lShipmentInfoText;
        end;

        exit(lShipmentInfoText);
    end;

    internal procedure GetItemLogisticsParameters(pItemNo: Code[20];
                                                  pVariantCode: Code[10];
                                                  pSubjectType: Enum "AltAWPWhse Ship Subject Type";
                                                  pSubjectNo: Code[20];
                                                  var pPalletType: Code[20];
                                                  var pNoOfUnitsPerLayer: Decimal;
                                                  var pNoOfLayersPerPallet: Decimal;
                                                  var pStackable: Boolean)
    var
        lItem: Record Item;
        lItemCustomerDetails: Record "ecItem Customer Details";
    begin
        pPalletType := '';
        pStackable := false;
        pNoOfUnitsPerLayer := 0;
        pNoOfLayersPerPallet := 0;

        if not lItem.Get(pItemNo) then exit;
        pNoOfLayersPerPallet := lItem."ecNo. of Layers per Pallet";
        pNoOfUnitsPerLayer := lItem."ecNo. Of Units per Layer";
        pStackable := lItem.ecStackable;
        pPalletType := lItem."ecPallet Type";

        if (pSubjectType = pSubjectType::Customer) then begin
            if (pSubjectNo <> '') then begin
                if lItemCustomerDetails.GetCustomerSettings(pItemNo, pVariantCode, pSubjectNo) then begin
                    if (lItemCustomerDetails."Pallet Type" <> '') then begin
                        pPalletType := lItemCustomerDetails."Pallet Type";
                    end;

                    if (lItemCustomerDetails."No. of Layers per Pallet" > 0) then begin
                        pNoOfLayersPerPallet := lItemCustomerDetails."No. of Layers per Pallet";
                    end;

                    if (lItemCustomerDetails."No. Of Units per Layer" > 0) then begin
                        pNoOfUnitsPerLayer := lItemCustomerDetails."No. Of Units per Layer";
                    end;
                end;
            end;
        end;
    end;
    #endregion CS_REP_001 - Livello di dettaglio delle stampe determinate da setup in anagrafica cliente

    #region CS_LOG_001 - Procedura di spedizione e picking

    internal procedure CalcWhseShipmentTotalParcels(pWhseShipmentHeader: Record "Warehouse Shipment Header"): Integer
    var
        lUnitofMeasure: Record "Unit of Measure";
        lWarehouseShipmentLine: Record "Warehouse Shipment Line";
        lTotalParcels: Integer;
    begin
        //CS_LOG_001-s
        lTotalParcels := 0;
        Clear(lWarehouseShipmentLine);
        lWarehouseShipmentLine.SetRange("No.", pWhseShipmentHeader."No.");
        if not lWarehouseShipmentLine.IsEmpty then begin
            lWarehouseShipmentLine.FindSet();
            repeat
                if lUnitofMeasure.Get(lWarehouseShipmentLine."Unit of Measure Code") and
                   (lUnitofMeasure."AltAWPType Unit Of Measure" = lUnitofMeasure."AltAWPType Unit Of Measure"::Parcels)
                then begin
                    lTotalParcels += Round(lWarehouseShipmentLine.Quantity, 1, '>');
                end;
            until (lWarehouseShipmentLine.Next() = 0);
        end;

        exit(lTotalParcels);
        //CS_LOG_001-e
    end;

    internal procedure CalcSalesDocumentTotalParcels(pSalesHeader: Record "Sales Header"): Integer
    var
        lSalesLine: Record "Sales Line";
        lUnitofMeasure: Record "Unit of Measure";
        lTotalParcels: Integer;
    begin
        //CS_LOG_001-s
        lTotalParcels := 0;
        Clear(lSalesLine);
        lSalesLine.SetRange("Document Type", pSalesHeader."Document Type");
        lSalesLine.SetRange("Document No.", pSalesHeader."No.");
        if not lSalesLine.IsEmpty then begin
            lSalesLine.FindSet();
            repeat
                if lUnitofMeasure.Get(lSalesLine."Unit of Measure Code") and
                   (lUnitofMeasure."AltAWPType Unit Of Measure" = lUnitofMeasure."AltAWPType Unit Of Measure"::Parcels)
                then begin
                    lTotalParcels += Round(lSalesLine.Quantity, 1, '>');
                end;
            until (lSalesLine.Next() = 0);
        end;

        exit(lTotalParcels);
        //CS_LOG_001-e
    end;

    internal procedure CalcTheoreticalPalletsNo(pShippingAgentCode: Code[10]; pShippingAgentServiceCode: Code[10]; pTotalVolume: Decimal): Decimal
    var
        lShippingAgent: Record "Shipping Agent";
        lShippingAgentServices: Record "Shipping Agent Services";
        lPalletPlaceVolume: Decimal;
    begin
        //CS_LOG_001-s        
        Clear(lShippingAgentServices);
        if not lShippingAgent.Get(pShippingAgentCode) then exit(0);
        if (pShippingAgentServiceCode <> '') then begin
            if not lShippingAgentServices.Get(pShippingAgentCode, pShippingAgentServiceCode) then exit(0);
        end;

        lPalletPlaceVolume := lShippingAgent."ecPallet Place Volume";
        if (lShippingAgentServices."ecPallet Place Volume" <> 0) then lPalletPlaceVolume := lShippingAgentServices."ecPallet Place Volume";
        if (lPalletPlaceVolume = 0) then exit(0);

        exit(Round(pTotalVolume / lPalletPlaceVolume, 0.5, '>'));
        //CS_LOG_001-e
    end;

    #endregion CS_LOG_001 - Procedura di spedizione e picking

    #region GAP_VEN_001 - Stampe di Vendita

    internal procedure FillPackingListBuffer(pWhseDocumentType: Enum "Warehouse Journal Document Type";
                                             pWhseDocumentNo: Code[20];
                                             pAlreadyPostedShipment: Boolean;
                                             pGroupByItemTracking: Boolean;
                                             var Temp_pLabelBuffer: Record "AltAWPLogistic Labels Buffer" temporary)
    var
        lawpGeneralSetup: Record "AltAWPGeneral Setup";
        lWarehouseEntry: Record "Warehouse Entry";
        lEntryNo: Integer;
    begin
        //GAP_VEN_001-s
        lawpGeneralSetup.Get();

        Clear(Temp_pLabelBuffer);
        Temp_pLabelBuffer.DeleteAll();

        lWarehouseEntry.Reset();
        lWarehouseEntry.SetCurrentKey("Whse. Document No.", "Whse. Document Line No.", "Whse. Document Type");
        lWarehouseEntry.SetRange("Whse. Document No.", pWhseDocumentNo);
        lWarehouseEntry.SetRange("Whse. Document Type", pWhseDocumentType);

        if pAlreadyPostedShipment then begin
            // Ricerca movimenti di spedizione
            lWarehouseEntry.SetFilter(Quantity, '<%1', 0);
        end else begin
            // Ricerca movimenti di prelievo
            lWarehouseEntry.SetRange("AltAWPWhse. Activity Type", lWarehouseEntry."AltAWPWhse. Activity Type"::Pick);
            lWarehouseEntry.SetFilter(Quantity, '>%1', 0);
        end;

        lWarehouseEntry.SetRange(AltAWPCorrection, false);
        if not lWarehouseEntry.IsEmpty then begin
            lWarehouseEntry.FindSet();
            repeat
                Temp_pLabelBuffer.SetRange("Record Type", Temp_pLabelBuffer."Record Type"::Master);
                Temp_pLabelBuffer.SetRange(Type, Temp_pLabelBuffer.Type::Pallet);
                Temp_pLabelBuffer.SetRange("Item No.", lWarehouseEntry."Item No.");
                Temp_pLabelBuffer.SetRange("Variant Code", lWarehouseEntry."Variant Code");
                Temp_pLabelBuffer.SetRange("Lot No.", lWarehouseEntry."Lot No.");
                Temp_pLabelBuffer.SetRange("Serial No.", lWarehouseEntry."Serial No.");
                Temp_pLabelBuffer.SetRange("Whse. Document Type", lWarehouseEntry."Whse. Document Type");
                Temp_pLabelBuffer.SetRange("Whse. Document No.", lWarehouseEntry."Whse. Document No.");
                Temp_pLabelBuffer.SetRange("Whse. Document Line No.", lWarehouseEntry."Whse. Document Line No.");
                if Temp_pLabelBuffer.IsEmpty then begin
                    lEntryNo += 1;

                    Temp_pLabelBuffer.Init();
                    Temp_pLabelBuffer."Entry No." := lEntryNo;
                    Temp_pLabelBuffer."Record Type" := Temp_pLabelBuffer."Record Type"::Master;
                    Temp_pLabelBuffer.Type := Temp_pLabelBuffer.Type::Pallet;
                    Temp_pLabelBuffer."No." := Format(lEntryNo);
                    Temp_pLabelBuffer."Label Type" := Temp_pLabelBuffer."Label Type"::Shipment;
                    Temp_pLabelBuffer."Whse. Document Type" := Temp_pLabelBuffer."Whse. Document Type"::Shipment;
                    Temp_pLabelBuffer."Whse. Document No." := lWarehouseEntry."Whse. Document No.";
                    Temp_pLabelBuffer."Whse. Document Line No." := lWarehouseEntry."Whse. Document Line No.";
                    Temp_pLabelBuffer."Item No." := lWarehouseEntry."Item No.";
                    Temp_pLabelBuffer."Variant Code" := lWarehouseEntry."Variant Code";
                    Temp_pLabelBuffer."Lot No." := lWarehouseEntry."Lot No.";
                    Temp_pLabelBuffer."Serial No." := lWarehouseEntry."Serial No.";

                    Temp_pLabelBuffer.CopyWhseShipmentHeaderInfo(Temp_pLabelBuffer."Whse. Document No.");
                    Temp_pLabelBuffer.UpdateSubjectInfo();
                    Temp_pLabelBuffer.Insert();
                end;

                InsertShippingLabelDetailBuffer(Temp_pLabelBuffer, lWarehouseEntry, pGroupByItemTracking, lEntryNo);
            until (lWarehouseEntry.Next() = 0);
        end;
        //GAP_VEN_001-e
    end;

    local procedure InsertShippingLabelDetailBuffer(var Temp_pLabelBuffer: Record "AltAWPLogistic Labels Buffer" temporary;
                                                    pWarehouseEntry: Record "Warehouse Entry";
                                                    pGroupByItemTracking: Boolean;
                                                    var pLastEntryNo: Integer)
    var
        Temp_lLabelBuffer_Master: Record "AltAWPLogistic Labels Buffer" temporary;
    begin
        //GAP_VEN_001-s
        Temp_lLabelBuffer_Master := Temp_pLabelBuffer;

        // Ricerca/Inserimento riga DETTAGLIO
        Temp_pLabelBuffer.SetRange("Record Type", Temp_pLabelBuffer."Record Type"::Detail);
        Temp_pLabelBuffer.SetRange(Type, Temp_lLabelBuffer_Master.Type);
        Temp_pLabelBuffer.SetRange("Item No.", pWarehouseEntry."Item No.");
        Temp_pLabelBuffer.SetRange("Variant Code", pWarehouseEntry."Variant Code");
        Temp_pLabelBuffer.SetRange("Whse. Document Type", pWarehouseEntry."Whse. Document Type");
        Temp_pLabelBuffer.SetRange("Whse. Document No.", pWarehouseEntry."Whse. Document No.");
        Temp_pLabelBuffer.SetRange("Whse. Document Line No.", pWarehouseEntry."Whse. Document Line No.");

        Temp_pLabelBuffer.SetRange("Lot No.");
        Temp_pLabelBuffer.SetRange("Serial No.");
        if pGroupByItemTracking then begin
            Temp_pLabelBuffer.SetRange("Lot No.", pWarehouseEntry."Lot No.");
            Temp_pLabelBuffer.SetRange("Serial No.", pWarehouseEntry."Serial No.");
        end;
        if not Temp_pLabelBuffer.FindFirst() then begin
            pLastEntryNo += 1;

            Temp_pLabelBuffer := Temp_lLabelBuffer_Master;
            Temp_pLabelBuffer."Record Type" := Temp_pLabelBuffer."Record Type"::Detail;
            Temp_pLabelBuffer."Entry No." := pLastEntryNo;
            Temp_pLabelBuffer."No." := Temp_lLabelBuffer_Master."No.";

            Temp_pLabelBuffer."Whse. Document Type" := Temp_pLabelBuffer."Whse. Document Type"::Shipment;
            Temp_pLabelBuffer."Whse. Document No." := pWarehouseEntry."Whse. Document No.";
            Temp_pLabelBuffer."Whse. Document Line No." := pWarehouseEntry."Whse. Document Line No.";

            Temp_pLabelBuffer."Item No." := pWarehouseEntry."Item No.";
            Temp_pLabelBuffer."Variant Code" := pWarehouseEntry."Variant Code";

            if pGroupByItemTracking then begin
                Temp_pLabelBuffer."Lot No." := pWarehouseEntry."Lot No.";
                Temp_pLabelBuffer."Serial No." := pWarehouseEntry."Serial No.";
                Temp_pLabelBuffer."Expiration Date" := pWarehouseEntry."Expiration Date";
            end;

            Temp_pLabelBuffer."Unit of Measure Code" := pWarehouseEntry."Unit of Measure Code";
            Temp_pLabelBuffer.Quantity := Abs(pWarehouseEntry.Quantity);

            // Ricerca descrizioni articolo
            Temp_pLabelBuffer.UpdateItemInfo();
            Temp_pLabelBuffer.Insert();
        end else begin
            Temp_pLabelBuffer.Quantity += Abs(pWarehouseEntry.Quantity);
            Temp_pLabelBuffer."Total Net Weight" := (Temp_pLabelBuffer.Quantity * Temp_pLabelBuffer."Unit Net Weight");
            Temp_pLabelBuffer."Total Gross Weight" := (Temp_pLabelBuffer.Quantity * Temp_pLabelBuffer."Unit Gross Weight");
            Temp_pLabelBuffer."Total Volume" := (Temp_pLabelBuffer.Quantity * Temp_pLabelBuffer."Unit Volume");
            Temp_pLabelBuffer.Modify();
        end;

        Temp_pLabelBuffer.SetRange("Pallet No.");
        Temp_pLabelBuffer.SetRange("Detail Box No.");
        Temp_pLabelBuffer.SetRange("Item No.");
        Temp_pLabelBuffer.SetRange("Variant Code");
        Temp_pLabelBuffer.SetRange("Lot No.");
        Temp_pLabelBuffer.SetRange("Serial No.");
        Temp_pLabelBuffer.SetRange("Whse. Document Type");
        Temp_pLabelBuffer.SetRange("Whse. Document No.");
        Temp_pLabelBuffer.SetRange("Whse. Document Line No.");
        //GAP_VEN_001-e
    end;

    #endregion GAP_VEN_001 - Stampe di Vendita

    #region Warehouse Pick Functions
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AltAWPLogistic Units Mgt.", 'OnKeepLogisticUnitsRefOnWhsePick', '', false, false)]
    local procedure AltAWPLogisticUnitsMgt_OnKeepLogisticUnitsRefOnWhsePick(WhseActivityLine_Take: Record "Warehouse Activity Line"; var KeepLogUnitsRef: Boolean)
    var
        lItemToPick: Record Item;
        lItemToProduce: Record Item;
        lWhseActivityLine_Place: Record "Warehouse Activity Line";
        lProdOrderLine: Record "Prod. Order Line";
        lProdOrderRoutingLine: Record "Prod. Order Routing Line";
        lMachineCenter: Record "Machine Center";
        lawpProductionFunctions: Codeunit "AltAWPProduction Functions";
    begin
        if (WhseActivityLine_Take."Whse. Document Type" in [WhseActivityLine_Take."Whse. Document Type"::" ",
                                                            WhseActivityLine_Take."Whse. Document Type"::Production])
        then begin
            if KeepLogUnitsRef then begin
                if lItemToPick.Get(WhseActivityLine_Take."Item No.") then begin
                    if (lItemToPick."ecItem Type" in [lItemToPick."ecItem Type"::"Raw Material",
                                                      lItemToPick."ecItem Type"::"Semi-finished Product"])
                    then begin
                        if WhseActivityLine_Take.AltAWP_GetLinkedActionLine(lWhseActivityLine_Place) then begin
                            if lawpProductionFunctions.GetProdOrderLineByConsumptionReservedBin(lWhseActivityLine_Place."Location Code",
                                                                                                lWhseActivityLine_Place."Bin Code",
                                                                                                lProdOrderLine)
                            then begin
                                if lItemToProduce.Get(lProdOrderLine."Item No.") then begin
                                    // CASO A: Produzione per prodotto finito
                                    if (lItemToProduce."ecItem Type" = lItemToProduce."ecItem Type"::"Finished Product") then begin
                                        KeepLogUnitsRef := false;
                                    end else begin
                                        // CASO B: Produzione di semilavorato su centri di lavoro particolari (es. tostatura)
                                        lProdOrderRoutingLine.Reset();
                                        lProdOrderRoutingLine.SetRange(Status, lProdOrderLine.Status);
                                        lProdOrderRoutingLine.SetRange("Prod. Order No.", lProdOrderLine."Prod. Order No.");
                                        lProdOrderRoutingLine.SetRange("Routing Reference No.", lProdOrderLine."Routing Reference No.");
                                        lProdOrderRoutingLine.SetRange("Routing No.", lProdOrderLine."Routing No.");

                                        lProdOrderRoutingLine.SetLoadFields(Type, "No.");
                                        if lProdOrderRoutingLine.FindLast() then begin
                                            if (lProdOrderRoutingLine.Type = lProdOrderRoutingLine.Type::"Machine Center") then begin
                                                if lMachineCenter.Get(lProdOrderRoutingLine."No.") and
                                                   lMachineCenter."ecRemove Log. Units on Pick"
                                                then begin
                                                    KeepLogUnitsRef := false;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    #endregion Warehouse Pick Functions
}
