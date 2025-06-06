namespace EuroCompany.BaseApp.Inventory.Ledger;
using Microsoft.Inventory.Ledger;
using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Journal;
using Microsoft.Manufacturing.Document;

codeunit 50018 "ecMass Balance Gen. Functions"
{
    #region Purchase
    procedure InsertMassBalanceEntryFromItemLedgerEntryPurchaseEntryType(ItemLedgerEntry: Record "Item Ledger Entry")
    var
        MassBalanceEntry: Record "ecMass Balances Entry";
    begin
        MassBalanceEntry.Init();
        MassBalanceEntry.Validate("Entry No.", 0);
        MassBalanceEntry.Insert(true);

        MassBalanceEntry.Validate("Entry Type", ItemLedgerEntry."Entry Type");
        MassBalanceEntry.Validate("Posting Date", ItemLedgerEntry."Posting Date");
        MassBalanceEntry.Validate("Origin Item No.", ItemLedgerEntry."Item No.");
        MassBalanceEntry.Validate("Origin Lot No.", ItemLedgerEntry."Lot No.");
        MassBalanceEntry.Validate("Tracking Entry Type", ItemLedgerEntry."Entry Type");
        MassBalanceEntry.Validate("Tracked Quantity", ItemLedgerEntry.Quantity);
        MassBalanceEntry.Validate("Origin UoM", ItemLedgerEntry."Unit of Measure Code");
        MassBalanceEntry.Validate("Item No.", ItemLedgerEntry."Item No.");
        MassBalanceEntry.Validate("Item Quantity", ItemLedgerEntry.Quantity);
        MassBalanceEntry.Validate("Item UoM", ItemLedgerEntry."Unit of Measure Code");
        MassBalanceEntry.Validate("Item Lot No.", ItemLedgerEntry."Lot No.");
        MassBalanceEntry.Validate("Source Type", ItemLedgerEntry."Source Type");
        MassBalanceEntry.Validate("Source No.", ItemLedgerEntry."Source No.");
        MassBalanceEntry.Validate("Document No.", ItemLedgerEntry."Document No.");
        MassBalanceEntry.Validate("Document Line No.", ItemLedgerEntry."Document Line No.");
        MassBalanceEntry.Validate("Document Date", ItemLedgerEntry."Document Date");
        MassBalanceEntry.Validate("Item ledger Entry Qty.", Abs(ItemLedgerEntry.Quantity));
        MassBalanceEntry.Validate("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");

        MassBalanceEntry.Modify(true);
    end;
    #endregion Purchase

    #region Sale
    procedure InsertMassBalanceEntryFromItemLedgerEntrySaleEntryType(var MassBalanceEntryParam: Record "ecMass Balances Entry"; ItemLedgerEntry: Record "Item Ledger Entry"; DirectSale: Boolean)
    var
        MassBalanceEntry: Record "ecMass Balances Entry";
        ProdOrderLine: Record "Prod. Order Line";
        TrackQty: Decimal;
    begin
        Clear(TrackQty);

        MassBalanceEntry.Init();
        MassBalanceEntry.Validate("Entry No.", 0);
        MassBalanceEntry.Insert(true);

        if not DirectSale then begin
            MassBalanceEntry.Validate("Entry Type", ItemLedgerEntry."Entry Type");
            MassBalanceEntry.Validate("Origin Item No.", MassBalanceEntryParam."Origin Item No.");
            MassBalanceEntry.Validate("Origin Lot No.", MassBalanceEntryParam."Origin Lot No.");
            MassBalanceEntry.Validate("Origin UoM", MassBalanceEntryParam."Origin UoM");
        end else begin
            MassBalanceEntry.Validate("Entry Type", ItemLedgerEntry."Entry Type"::"Direct Sale");
            MassBalanceEntry.Validate("Origin Item No.", ItemLedgerEntry."Item No.");
            MassBalanceEntry.Validate("Origin Lot No.", ItemLedgerEntry."Lot No.");
            MassBalanceEntry.Validate("Origin UoM", ItemLedgerEntry."Unit of Measure Code");
        end;

        MassBalanceEntry.Validate("Posting Date", ItemLedgerEntry."Posting Date");

        MassBalanceEntry.Validate("Tracking Entry Type", ItemLedgerEntry."Entry Type");

        if ProdOrderLine.Get(ProdOrderLine.Status::Released, MassBalanceEntryParam."Document No.", MassBalanceEntryParam."Document Line No.") then begin
            TrackQty := MassBalanceEntryParam."Tracked Quantity" * (ItemLedgerEntry.Quantity / ProdOrderLine."Finished Quantity");
            MassBalanceEntry.Validate("Tracked Quantity", TrackQty);
        end;

        MassBalanceEntry.Validate("Item No.", ItemLedgerEntry."Item No.");
        MassBalanceEntry.Validate("Item Quantity", Abs(ItemLedgerEntry.Quantity));
        MassBalanceEntry.Validate("Item UoM", ItemLedgerEntry."Unit of Measure Code");
        MassBalanceEntry.Validate("Item Lot No.", ItemLedgerEntry."Lot No.");
        MassBalanceEntry.Validate("Source Type", ItemLedgerEntry."Source Type");
        MassBalanceEntry.Validate("Source No.", ItemLedgerEntry."Source No.");
        MassBalanceEntry.Validate("Document No.", ItemLedgerEntry."Document No.");
        MassBalanceEntry.Validate("Document Line No.", ItemLedgerEntry."Document Line No.");
        MassBalanceEntry.Validate("Document Date", ItemLedgerEntry."Document Date");
        MassBalanceEntry.Validate("Item ledger Entry Qty.", Abs(ItemLedgerEntry.Quantity));
        MassBalanceEntry.Validate("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");

        MassBalanceEntry.Modify(true);
    end;
    #endregion Sale

    #region Consumption
    procedure InsertMassBalanceEntryFromConsumptionEntryType(ProdOrderComponent: Record "Prod. Order Component"; ItemJnlLine: Record "Item Journal Line"; ItemLedgerEntryNo: Integer)
    var
        MassBalanceEntry: Record "ecMass Balances Entry";
        ProdOrderLine, ProdOrderLineToFilter, ProdOrderLineForAdjust : Record "Prod. Order Line";
        ProdOrderComponentToFilter: Record "Prod. Order Component";
        ItemLedgerEntry: Record "Item Ledger Entry";
        MaxParentLineNo: Integer;
    begin
        MassBalanceEntry.Init();
        MassBalanceEntry.Validate("Entry No.", 0);
        MassBalanceEntry.Insert(true);

        MassBalanceEntry.Validate("Entry Type", ItemJnlLine."Entry Type");
        MassBalanceEntry.Validate("Posting Date", ItemJnlLine."Posting Date");

        //mi prendo il liverllo massimo delle righe di ordine di prod e mi prendo il suo componenete e poi faccio get origins
        MaxParentLineNo := 0;
        ProdOrderLine.Reset();
        ProdOrderLine.SetRange(Status, ProdOrderComponent.Status);
        ProdOrderLine.SetRange("Prod. Order No.", ProdOrderComponent."Prod. Order No.");
        if ProdOrderLine.FindSet() then begin
            repeat
                if ProdOrderLine."ecParent Line No." > MaxParentLineNo then
                    MaxParentLineNo := ProdOrderLine."ecParent Line No.";
            until ProdOrderLine.Next() = 0;

            ProdOrderLineToFilter.Reset();
            ProdOrderLineToFilter.SetRange(Status, ProdOrderLine.Status);
            ProdOrderLineToFilter.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
            ProdOrderLineToFilter.SetRange("ecParent Line No.", MaxParentLineNo);
            if ProdOrderLineToFilter.FindFirst() then begin
                ProdOrderComponentToFilter.Reset();
                ProdOrderComponentToFilter.SetRange(Status, ProdOrderLineToFilter.Status);
                ProdOrderComponentToFilter.SetRange("Prod. Order No.", ProdOrderLineToFilter."Prod. Order No.");
                ProdOrderComponentToFilter.SetRange("Prod. Order Line No.", ProdOrderLineToFilter."Line No.");
                if ProdOrderComponentToFilter.FindFirst() then begin
                    if MultipleComponents(ProdOrderComponentToFilter) then
                        GetOriginsFromSingleComponent(ProdOrderComponent, MassBalanceEntry)
                    else
                        GetOrigins(ProdOrderComponentToFilter, MassBalanceEntry);
                end;
            end;
        end;

        MassBalanceEntry.Validate("Tracking Entry Type", ItemJnlLine."Entry Type");

        if ItemLedgerEntry.Get(ItemLedgerEntryNo) then begin
            MassBalanceEntry."Tracked Quantity" := ItemLedgerEntry.Quantity * (1 - (ProdOrderComponent."Scrap %" / 100));
            MassBalanceEntry."Item Quantity" := MassBalanceEntry."Tracked Quantity" + ItemLedgerEntry.Quantity * (ProdOrderComponent."Scrap %" / 100);
        end;

        MassBalanceEntry.Validate("Srap %", ProdOrderComponent."Scrap %");
        MassBalanceEntry.Validate("Item ledger Entry Qty.", ItemJnlLine.Quantity);

        MassBalanceEntry.Validate("Item No.", ItemJnlLine."Item No.");

        MassBalanceEntry.Validate("Item UoM", ItemJnlLine."Unit of Measure Code");
        MassBalanceEntry.Validate("Item Lot No.", ItemJnlLine."Lot No.");
        MassBalanceEntry.Validate("Source Type", ItemJnlLine."Source Type");
        MassBalanceEntry.Validate("Source No.", ItemJnlLine."Source No.");

        MassBalanceEntry.Validate("Document No.", ProdOrderComponent."Prod. Order No.");
        MassBalanceEntry.Validate("Document Line No.", ProdOrderComponent."Prod. Order Line No.");

        MassBalanceEntry.Validate("Prod. Order Component Line No.", ProdOrderComponent."Line No.");

        MassBalanceEntry.Validate("Origin Prod. Order Line No.", ProdOrderComponent."Prod. Order Line No.");
        MassBalanceEntry.Validate("Orig. Prod. Order Comp.LineNo.", ProdOrderComponent."Line No.");

        MassBalanceEntry.Validate("Document Date", ItemJnlLine."Document Date");
        MassBalanceEntry.Validate("Item Ledger Entry No.", ItemLedgerEntryNo);
        MassBalanceEntry.Modify(true);

        if (ProdOrderComponent."Scrap %" <> 0) then
            InsertMassBalanceEntryFromItemLedgerEntryConsumptionEntryTypeWithScrap(MassBalanceEntry, ProdOrderComponent, ItemLedgerEntryNo);

        ClearLinkedConsOutputRecord(MassBalanceEntry);

        if ProdOrderLineForAdjust.Get(ProdOrderComponent.Status, MassBalanceEntry."Document No.", MassBalanceEntry."Document Line No.") then
            AdjustOutputQuantitesFromConsumptionsEntry(ProdOrderLineForAdjust);
    end;

    local procedure InsertMassBalanceEntryFromItemLedgerEntryConsumptionEntryTypeWithScrap(var MassBalanceEntryParam: Record "ecMass Balances Entry"; ProdOrderComponent: Record "Prod. Order Component"; ItemLedgerEntryNo: Integer)
    var
        MassBalanceEntry: Record "ecMass Balances Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        MassBalanceEntry.Init();
        MassBalanceEntry.TransferFields(MassBalanceEntryParam);
        MassBalanceEntry.Validate("Entry No.", 0);
        MassBalanceEntry.Insert(true);

        MassBalanceEntry.Validate("Tracking Entry Type", MassBalanceEntry."Tracking Entry Type"::Scrap);

        if ItemLedgerEntry.Get(ItemLedgerEntryNo) then
            MassBalanceEntry."Tracked Quantity" := ItemLedgerEntry.Quantity * (ProdOrderComponent."Scrap %" / 100);

        MassBalanceEntry.Validate("Item Quantity", 0);
        MassBalanceEntry.Validate("Item UoM", '');
        MassBalanceEntry.Modify(true);
    end;
    #endregion Consumption

    #region Generic Functions
    local procedure GetOrigins(ProdOrderComponent: Record "Prod. Order Component"; var MassBalanceEntryToChange: Record "ecMass Balances Entry")
    var
        OriginItem, RawMaterialOriginItem : Record Item;
        RawMaterialProdOrderComponent: Record "Prod. Order Component";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        if OriginItem.Get(ProdOrderComponent."Item No.") then
            if OriginItem."ecItem Type" = OriginItem."ecItem Type"::"Raw Material" then begin
                MassBalanceEntryToChange.Validate("Origin Item No.", OriginItem."No.");

                MassBalanceEntryToChange.Validate("Origin UoM", OriginItem."Base Unit of Measure");
                ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Consumption);
                ItemLedgerEntry.SetRange("Order No.", ProdOrderComponent."Prod. Order No.");
                ItemLedgerEntry.SetRange("Order Line No.", ProdOrderComponent."Prod. Order Line No.");
                if ItemLedgerEntry.FindFirst() then
                    MassBalanceEntryToChange.Validate("Origin Lot No.", ItemLedgerEntry."Lot No.");
            end else begin
                RawMaterialProdOrderComponent.Reset();
                RawMaterialProdOrderComponent.SetRange(Status, ProdOrderComponent.Status);
                RawMaterialProdOrderComponent.SetRange("Prod. Order No.", ProdOrderComponent."Prod. Order No.");
                RawMaterialProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderComponent."Prod. Order Line No.");
                if RawMaterialProdOrderComponent.FindSet() then
                    repeat
                        if (RawMaterialOriginItem.Get(RawMaterialProdOrderComponent."Item No.")) and (RawMaterialOriginItem."ecItem Type" = RawMaterialOriginItem."ecItem Type"::"Raw Material") then begin
                            MassBalanceEntryToChange.Validate("Origin Item No.", OriginItem."No.");

                            MassBalanceEntryToChange.Validate("Origin UoM", OriginItem."Base Unit of Measure");

                            //Origin Lot No.
                            ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Consumption);
                            ItemLedgerEntry.SetRange("Order No.", ProdOrderComponent."Prod. Order No.");
                            ItemLedgerEntry.SetRange("Order Line No.", ProdOrderComponent."Prod. Order Line No.");
                            if ItemLedgerEntry.FindFirst() then
                                MassBalanceEntryToChange.Validate("Origin Lot No.", ItemLedgerEntry."Lot No.");
                            //Origin Lot No.
                        end;
                    until RawMaterialProdOrderComponent.Next() = 0;
            end;
    end;

    local procedure GetOriginsFromSingleComponent(ProdOrderComponent: Record "Prod. Order Component"; var MassBalanceEntryToChange: Record "ecMass Balances Entry")
    var
        OriginItem, RawMaterialOriginItem : Record Item;
        RawMaterialProdOrderComponent: Record "Prod. Order Component";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        if OriginItem.Get(ProdOrderComponent."Item No.") then
            if OriginItem."ecItem Type" = OriginItem."ecItem Type"::"Raw Material" then begin
                MassBalanceEntryToChange.Validate("Origin Item No.", OriginItem."No.");
                MassBalanceEntryToChange.Validate("Origin UoM", OriginItem."Base Unit of Measure");

                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Consumption);
                ItemLedgerEntry.SetRange("Order No.", ProdOrderComponent."Prod. Order No.");
                ItemLedgerEntry.SetRange("Prod. Order Comp. Line No.", ProdOrderComponent."Line No.");
                if ItemLedgerEntry.FindFirst() then
                    MassBalanceEntryToChange.Validate("Origin Lot No.", ItemLedgerEntry."Lot No.");
            end else begin
                RawMaterialProdOrderComponent.Reset();
                RawMaterialProdOrderComponent.SetRange(Status, ProdOrderComponent.Status);
                RawMaterialProdOrderComponent.SetRange("Prod. Order No.", ProdOrderComponent."Prod. Order No.");
                RawMaterialProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderComponent."Prod. Order Line No.");
                if RawMaterialProdOrderComponent.FindSet() then
                    repeat
                        if (RawMaterialOriginItem.Get(RawMaterialProdOrderComponent."Item No.")) and (RawMaterialOriginItem."ecItem Type" = RawMaterialOriginItem."ecItem Type"::"Raw Material") then begin
                            MassBalanceEntryToChange.Validate("Origin Item No.", OriginItem."No.");
                            MassBalanceEntryToChange.Validate("Origin UoM", OriginItem."Base Unit of Measure");

                            ItemLedgerEntry.Reset();
                            ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Consumption);
                            ItemLedgerEntry.SetRange("Order No.", ProdOrderComponent."Prod. Order No.");
                            ItemLedgerEntry.SetRange("Prod. Order Comp. Line No.", ProdOrderComponent."Line No.");
                            if ItemLedgerEntry.FindFirst() then
                                MassBalanceEntryToChange.Validate("Origin Lot No.", ItemLedgerEntry."Lot No.");
                        end;
                    until RawMaterialProdOrderComponent.Next() = 0;
            end;
    end;

    local procedure MultipleComponents(ProdOrderComponentParam: Record "Prod. Order Component"): Boolean
    var
        ProdOrderComponent: Record "Prod. Order Component";
    begin
        ProdOrderComponent.Reset();
        ProdOrderComponent.SetRange(Status, ProdOrderComponentParam.Status);
        ProdOrderComponent.SetRange("Prod. Order No.", ProdOrderComponentParam."Prod. Order No.");
        ProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderComponentParam."Prod. Order Line No.");
        ProdOrderComponent.SetFilter("Item No.", '<>%1', ProdOrderComponentParam."Item No.");
        if not ProdOrderComponent.IsEmpty() then
            exit(true);

        exit(false);
    end;

    procedure AdjustOutputQuantitesFromConsumptionsEntry(ProdOrderLine: Record "Prod. Order Line")
    var
        ProdOrderComp: Record "Prod. Order Component";
    begin
        ProdOrderComp.Reset();
        ProdOrderComp.SetRange(Status, ProdOrderLine.Status);
        ProdOrderComp.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderComp.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
        if ProdOrderComp.FindSet() then
            repeat
                AdjustConsAndOutputQuantitesFromPOCConsumptionsEntry(ProdOrderComp);
            until ProdOrderComp.Next() = 0;
    end;

    local procedure AdjustConsAndOutputQuantitesFromPOCConsumptionsEntry(ProdOrderComp: Record "Prod. Order Component")
    var
        MassBalanceEntry, OriginMassBalanceEntry, MassBalanceEntryScrap, MassBalanceEntrySemiFinishedConsumption, MassBalanceEntrySemiFinishedOutuput : Record "ecMass Balances Entry";
        TempMassBalanceEntry, TempMassBalanceEntry2, TempMassBalanceEntryOutput, TempMassBalanceEntryConsumption : Record "ecMass Balances Entry" temporary;
        ItemLedgerEntry: Record "Item Ledger Entry";
        Item: Record Item;
        MassBalanceEntryCount: Integer;
        i: Integer;
        Factor: Decimal;
    begin
        TempMassBalanceEntry.Reset();
        TempMassBalanceEntry.DeleteAll();

        MassBalanceEntry.Reset();
        MassBalanceEntry.SetRange("Document No.", ProdOrderComp."Prod. Order No.");
        MassBalanceEntry.SetRange("Document Line No.", ProdOrderComp."Prod. Order Line No.");
        MassBalanceEntry.SetRange("Prod. Order Component Line No.", ProdOrderComp."Line No.");
        MassBalanceEntry.SetRange("Entry Type", MassBalanceEntry."Entry Type"::Consumption);
        MassBalanceEntry.SetRange("Tracking Entry Type", MassBalanceEntry."Tracking Entry Type"::Consumption);
        MassBalanceEntry.SetRange("Parent Entry No.", 0);
        if MassBalanceEntry.FindSet() then
            repeat
                if ItemLedgerEntry.Get(MassBalanceEntry."Item Ledger Entry No.") then begin
                    MassBalanceEntry.Validate("Origin Lot No.", ItemLedgerEntry."Lot No.");
                    MassBalanceEntry.Validate("Origin Item No.", ItemLedgerEntry."Item No.");
                    MassBalanceEntry.Validate("Origin UoM", ItemLedgerEntry."Unit of Measure Code");
                    MassBalanceEntry.Modify();

                    MassBalanceEntryScrap.Reset();
                    MassBalanceEntryScrap.SetRange("Item Ledger Entry No.", MassBalanceEntry."Item Ledger Entry No.");
                    if MassBalanceEntryScrap.FindSet() then
                        repeat
                            MassBalanceEntryScrap.Validate("Origin Lot No.", MassBalanceEntry."Origin Lot No.");
                            MassBalanceEntryScrap.Validate("Origin Item No.", MassBalanceEntry."Item No.");
                            MassBalanceEntryScrap.Validate("Origin UoM", MassBalanceEntry."Origin UoM");
                            MassBalanceEntryScrap.Modify();
                        until MassBalanceEntryScrap.Next() = 0;
                end;

                CreateTempMassBalanceEntry(MassBalanceEntry, MassBalanceEntry, TempMassBalanceEntry);
            until MassBalanceEntry.Next() = 0;

        //Create Output Entries
        TempMassBalanceEntry.Reset();
        if TempMassBalanceEntry.FindSet() then
            repeat
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Output);
                ItemLedgerEntry.SetRange("Order No.", MassBalanceEntry."Document No.");
                ItemLedgerEntry.SetRange("Order Line No.", MassBalanceEntry."Document Line No.");
                if ItemLedgerEntry.FindSet() then
                    repeat
                        //If consumption doesn't exist
                        MassBalanceEntry.Reset();
                        MassBalanceEntry.SetRange("Entry Type", MassBalanceEntry."Entry Type"::Consumption);
                        MassBalanceEntry.SetRange("Document No.", TempMassBalanceEntry."Document No.");
                        MassBalanceEntry.SetRange("Document Line No.", TempMassBalanceEntry."Document Line No.");
                        MassBalanceEntry.SetRange("Prod. Order Component Line No.", TempMassBalanceEntry."Prod. Order Component Line No.");
                        MassBalanceEntry.SetRange("Orig. Prod. Order Comp.LineNo.", TempMassBalanceEntry."Orig. Prod. Order Comp.LineNo.");
                        MassBalanceEntry.SetRange("Origin Prod. Order Line No.", TempMassBalanceEntry."Origin Prod. Order Line No.");
                        MassBalanceEntry.SetRange("Origin Item No.", TempMassBalanceEntry."Origin Item No.");
                        MassBalanceEntry.SetRange("Origin Lot No.", TempMassBalanceEntry."Origin Lot No.");
                        if MassBalanceEntry.IsEmpty() then begin
                            if not ((TempMassBalanceEntry."Document Line No." = TempMassBalanceEntry."Origin Prod. Order Line No.") and (TempMassBalanceEntry."Prod. Order Component Line No." = TempMassBalanceEntry."Orig. Prod. Order Comp.LineNo.")) then begin
                                OriginMassBalanceEntry.Reset();
                                OriginMassBalanceEntry.SetRange("Entry Type", OriginMassBalanceEntry."Entry Type"::Consumption);
                                OriginMassBalanceEntry.SetRange("Tracking Entry Type", OriginMassBalanceEntry."Tracking Entry Type"::Consumption);
                                OriginMassBalanceEntry.SetRange("Parent Entry No.", 0);
                                OriginMassBalanceEntry.SetRange("Document No.", TempMassBalanceEntry."Document No.");
                                OriginMassBalanceEntry.SetRange("Document Line No.", TempMassBalanceEntry."Document Line No.");
                                OriginMassBalanceEntry.SetRange("Prod. Order Component Line No.", TempMassBalanceEntry."Prod. Order Component Line No.");
                                OriginMassBalanceEntry.SetRange("Origin Prod. Order Line No.", TempMassBalanceEntry."Document Line No.");
                                OriginMassBalanceEntry.SetRange("Orig. Prod. Order Comp.LineNo.", TempMassBalanceEntry."Prod. Order Component Line No.");
                                if OriginMassBalanceEntry.FindFirst() then begin//TODO
                                    MassBalanceEntry.Init();
                                    MassBalanceEntry.Validate("Entry No.", 0);
                                    MassBalanceEntry.Insert(true);

                                    MassBalanceEntry.Validate("Entry Type", OriginMassBalanceEntry."Entry Type");
                                    MassBalanceEntry.Validate("Posting Date", OriginMassBalanceEntry."Posting Date");

                                    MassBalanceEntry.Validate("Tracking Entry Type", OriginMassBalanceEntry."Entry Type");
                                    MassBalanceEntry.Validate("Item No.", OriginMassBalanceEntry."Item No.");
                                    MassBalanceEntry.Validate("Item UoM", OriginMassBalanceEntry."Item UoM");
                                    MassBalanceEntry.Validate("Item Lot No.", OriginMassBalanceEntry."Item Lot No.");
                                    MassBalanceEntry.Validate("Source Type", OriginMassBalanceEntry."Source Type");
                                    MassBalanceEntry.Validate("Source No.", OriginMassBalanceEntry."Source No.");
                                    MassBalanceEntry.Validate("Document No.", OriginMassBalanceEntry."Document No.");
                                    MassBalanceEntry.Validate("Document Line No.", OriginMassBalanceEntry."Document Line No.");
                                    MassBalanceEntry.Validate("Document Date", OriginMassBalanceEntry."Document Date");
                                    MassBalanceEntry.Validate("Item Ledger Entry No.", OriginMassBalanceEntry."Item Ledger Entry No.");
                                    MassBalanceEntry.Validate("Prod. Order Component Line No.", OriginMassBalanceEntry."Prod. Order Component Line No.");
                                    MassBalanceEntry.Validate("Item ledger Entry Qty.", OriginMassBalanceEntry."Item ledger Entry Qty.");

                                    MassBalanceEntry.Validate("Origin Item No.", TempMassBalanceEntry."Origin Item No.");
                                    MassBalanceEntry.Validate("Origin Lot No.", TempMassBalanceEntry."Origin Lot No.");
                                    MassBalanceEntry.Validate("Origin UoM", TempMassBalanceEntry."Origin UoM");

                                    MassBalanceEntry.Validate("Origin Prod. Order Line No.", TempMassBalanceEntry."Origin Prod. Order Line No.");
                                    MassBalanceEntry.Validate("Orig. Prod. Order Comp.LineNo.", TempMassBalanceEntry."Orig. Prod. Order Comp.LineNo.");

                                    MassBalanceEntry.Validate("Parent Entry No.", OriginMassBalanceEntry."Entry No.");
                                    MassBalanceEntry.Modify(true);
                                end;
                            end;
                        end;
                        //If output doesn't exist
                        MassBalanceEntry.Reset();
                        MassBalanceEntry.SetRange("Entry Type", MassBalanceEntry."Entry Type"::Output);
                        MassBalanceEntry.SetRange("Document No.", TempMassBalanceEntry."Document No.");
                        MassBalanceEntry.SetRange("Document Line No.", TempMassBalanceEntry."Document Line No.");
                        MassBalanceEntry.SetRange("Prod. Order Component Line No.", TempMassBalanceEntry."Prod. Order Component Line No.");
                        MassBalanceEntry.SetRange("Orig. Prod. Order Comp.LineNo.", TempMassBalanceEntry."Orig. Prod. Order Comp.LineNo.");
                        MassBalanceEntry.SetRange("Origin Prod. Order Line No.", TempMassBalanceEntry."Origin Prod. Order Line No.");
                        MassBalanceEntry.SetRange("Origin Item No.", TempMassBalanceEntry."Origin Item No.");
                        MassBalanceEntry.SetRange("Origin Lot No.", TempMassBalanceEntry."Origin Lot No.");
                        if MassBalanceEntry.IsEmpty() then begin
                            MassBalanceEntry.Init();
                            MassBalanceEntry.Validate("Entry No.", 0);
                            MassBalanceEntry.Insert(true);

                            MassBalanceEntry.Validate("Entry Type", ItemLedgerEntry."Entry Type");
                            MassBalanceEntry.Validate("Posting Date", ItemLedgerEntry."Posting Date");

                            MassBalanceEntry.Validate("Tracking Entry Type", ItemLedgerEntry."Entry Type");
                            MassBalanceEntry.Validate("Item No.", ItemLedgerEntry."Item No.");
                            MassBalanceEntry.Validate("Item UoM", ItemLedgerEntry."Unit of Measure Code");
                            MassBalanceEntry.Validate("Item Lot No.", ItemLedgerEntry."Lot No.");
                            MassBalanceEntry.Validate("Source Type", ItemLedgerEntry."Source Type");
                            MassBalanceEntry.Validate("Source No.", ItemLedgerEntry."Source No.");
                            MassBalanceEntry.Validate("Document No.", ItemLedgerEntry."Order No.");
                            MassBalanceEntry.Validate("Document Line No.", ItemLedgerEntry."Order Line No.");
                            MassBalanceEntry.Validate("Document Date", ItemLedgerEntry."Document Date");
                            MassBalanceEntry.Validate("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                            MassBalanceEntry.Validate("Prod. Order Component Line No.", TempMassBalanceEntry."Prod. Order Component Line No.");
                            MassBalanceEntry.Validate("Item ledger Entry Qty.", ItemLedgerEntry.Quantity);

                            MassBalanceEntry.Validate("Origin Item No.", TempMassBalanceEntry."Origin Item No.");
                            MassBalanceEntry.Validate("Origin Lot No.", TempMassBalanceEntry."Origin Lot No.");
                            MassBalanceEntry.Validate("Origin UoM", TempMassBalanceEntry."Origin UoM");

                            MassBalanceEntry.Validate("Origin Prod. Order Line No.", TempMassBalanceEntry."Origin Prod. Order Line No.");
                            MassBalanceEntry.Validate("Orig. Prod. Order Comp.LineNo.", TempMassBalanceEntry."Orig. Prod. Order Comp.LineNo.");
                            MassBalanceEntry.Modify(true);
                        end;
                    until ItemLedgerEntry.Next() = 0;
            until TempMassBalanceEntry.Next() = 0;


        //Consumption
        TempMassBalanceEntry2.Reset();
        TempMassBalanceEntry2.DeleteAll();
        TempMassBalanceEntryConsumption.Reset();
        TempMassBalanceEntryConsumption.DeleteAll();

        MassBalanceEntry.Reset();
        MassBalanceEntry.SetRange("Document No.", ProdOrderComp."Prod. Order No.");
        MassBalanceEntry.SetRange("Document Line No.", ProdOrderComp."Prod. Order Line No.");
        MassBalanceEntry.SetRange("Prod. Order Component Line No.", ProdOrderComp."Line No.");
        MassBalanceEntry.SetFilter("Parent Entry No.", '<>%1', 0);
        MassBalanceEntry.SetRange("Entry Type", MassBalanceEntry."Entry Type"::Consumption);
        if MassBalanceEntry.FindSet() then
            repeat
                if not ((MassBalanceEntry."Document Line No." = MassBalanceEntry."Origin Prod. Order Line No.") and (MassBalanceEntry."Prod. Order Component Line No." = MassBalanceEntry."Orig. Prod. Order Comp.LineNo.")) then begin
                    TempMassBalanceEntryConsumption.Reset();
                    TempMassBalanceEntryConsumption.SetRange("Document No.", MassBalanceEntry."Document No.");
                    TempMassBalanceEntryConsumption.SetRange("Document Line No.", MassBalanceEntry."Document Line No.");
                    TempMassBalanceEntryConsumption.SetRange("Entry Type", MassBalanceEntry."Entry Type");
                    TempMassBalanceEntryConsumption.SetRange("Tracking Entry Type", MassBalanceEntry."Tracking Entry Type");
                    TempMassBalanceEntryConsumption.SetRange("Prod. Order Component Line No.", MassBalanceEntry."Prod. Order Component Line No.");
                    TempMassBalanceEntryConsumption.SetRange("Origin Lot No.", MassBalanceEntry."Origin Lot No.");
                    TempMassBalanceEntryConsumption.SetRange("Origin Item No.", MassBalanceEntry."Origin Item No.");
                    if TempMassBalanceEntryConsumption.FindFirst() then begin
                        TempMassBalanceEntryConsumption."Item ledger Entry Qty." += MassBalanceEntry."Item ledger Entry Qty.";
                        TempMassBalanceEntryConsumption.Modify();
                    end else begin
                        TempMassBalanceEntryConsumption := MassBalanceEntry;
                        if TempMassBalanceEntryConsumption.Insert() then;
                    end;
                end;
            until MassBalanceEntry.Next() = 0;


        TempMassBalanceEntryConsumption.Reset();
        if TempMassBalanceEntryConsumption.FindSet() then
            repeat
                MassBalanceEntry.Reset();
                MassBalanceEntry.SetRange("Document No.", TempMassBalanceEntryConsumption."Document No.");
                MassBalanceEntry.SetRange("Document Line No.", TempMassBalanceEntryConsumption."Document Line No.");
                MassBalanceEntry.SetRange("Entry Type", TempMassBalanceEntryConsumption."Entry Type");
                MassBalanceEntry.SetRange("Tracking Entry Type", TempMassBalanceEntryConsumption."Tracking Entry Type");
                MassBalanceEntry.SetRange("Prod. Order Component Line No.", TempMassBalanceEntryConsumption."Prod. Order Component Line No.");
                MassBalanceEntry.SetRange("Origin Lot No.", TempMassBalanceEntryConsumption."Origin Lot No.");
                MassBalanceEntry.SetRange("Origin Item No.", TempMassBalanceEntryConsumption."Origin Item No.");
                MassBalanceEntry.SetFilter("Parent Entry No.", '<>%1', 0);
                MassBalanceEntryCount := MassBalanceEntry.Count();

                if MassBalanceEntryCount > 0 then begin
                    if not ((MassBalanceEntry."Document Line No." = MassBalanceEntry."Origin Prod. Order Line No.") and (MassBalanceEntry."Prod. Order Component Line No." = MassBalanceEntry."Orig. Prod. Order Comp.LineNo.")) then begin
                        OriginMassBalanceEntry.Reset();
                        OriginMassBalanceEntry.SetRange("Entry Type", OriginMassBalanceEntry."Entry Type"::Consumption);
                        OriginMassBalanceEntry.SetRange("Tracking Entry Type", OriginMassBalanceEntry."Tracking Entry Type"::Consumption);
                        OriginMassBalanceEntry.SetRange("Parent Entry No.", 0);
                        OriginMassBalanceEntry.SetRange("Document No.", MassBalanceEntry."Document No.");
                        OriginMassBalanceEntry.SetRange("Document Line No.", MassBalanceEntry."Document Line No.");
                        OriginMassBalanceEntry.SetRange("Prod. Order Component Line No.", MassBalanceEntry."Prod. Order Component Line No.");
                        OriginMassBalanceEntry.SetRange("Origin Prod. Order Line No.", MassBalanceEntry."Document Line No.");
                        OriginMassBalanceEntry.SetRange("Orig. Prod. Order Comp.LineNo.", MassBalanceEntry."Prod. Order Component Line No.");
                        if not OriginMassBalanceEntry.IsEmpty() then
                            OriginMassBalanceEntry.ModifyAll("Has Split", true);
                    end;
                    for i := 1 to MassBalanceEntryCount do begin
                        if i = 1 then begin
                            MassBalanceEntry.FindSet();

                            TempMassBalanceEntry.Reset();
                            TempMassBalanceEntry.SetRange("Document No.", TempMassBalanceEntryConsumption."Document No.");
                            TempMassBalanceEntry.SetRange("Origin Prod. Order Line No.", TempMassBalanceEntryConsumption."Origin Prod. Order Line No.");
                            TempMassBalanceEntry.SetRange("Orig. Prod. Order Comp.LineNo.", TempMassBalanceEntryConsumption."Orig. Prod. Order Comp.LineNo.");
                            TempMassBalanceEntry.SetRange("Entry Type", TempMassBalanceEntry."Entry Type"::Consumption);
                            TempMassBalanceEntry.SetRange("Tracking Entry Type", TempMassBalanceEntryConsumption."Tracking Entry Type"::Consumption);
                            TempMassBalanceEntry.SetRange("Origin Lot No.", TempMassBalanceEntryConsumption."Origin Lot No.");
                            TempMassBalanceEntry.SetRange("Origin Item No.", TempMassBalanceEntryConsumption."Origin Item No.");
                            if not TempMassBalanceEntry.FindFirst() then//TODO
                                TempMassBalanceEntry.Init();
                            TempMassBalanceEntry2 := TempMassBalanceEntry;
                            if TempMassBalanceEntry2.Insert(true) then;
                        end else
                            MassBalanceEntry.Next();

                        if i = MassBalanceEntryCount then begin
                            MassBalanceEntry."Item Quantity" := TempMassBalanceEntry2."Item Quantity";
                            MassBalanceEntry."Tracked Quantity" := TempMassBalanceEntry2."Tracked Quantity";
                            MassBalanceEntry.Modify();
                        end else begin
                            factor := 0;
                            if TempMassBalanceEntryConsumption."Item ledger Entry Qty." <> 0 then
                                Factor := MassBalanceEntry."Item ledger Entry Qty." / TempMassBalanceEntryConsumption."Item ledger Entry Qty.";
                            MassBalanceEntry."Item Quantity" := TempMassBalanceEntry."Item Quantity" * Factor;
                            MassBalanceEntry."Tracked Quantity" := TempMassBalanceEntry."Tracked Quantity" * Factor;
                            MassBalanceEntry.Modify();

                            TempMassBalanceEntry2."Item Quantity" -= MassBalanceEntry."Item Quantity";
                            TempMassBalanceEntry2."Tracked Quantity" -= MassBalanceEntry."Tracked Quantity";
                            TempMassBalanceEntry2.Modify();
                        end;
                    end;
                end;
            until TempMassBalanceEntryConsumption.Next() = 0;

        //Output
        TempMassBalanceEntry2.Reset();
        TempMassBalanceEntry2.DeleteAll();
        TempMassBalanceEntryOutput.Reset();
        TempMassBalanceEntryOutput.DeleteAll();

        MassBalanceEntry.Reset();
        MassBalanceEntry.SetRange("Document No.", ProdOrderComp."Prod. Order No.");
        MassBalanceEntry.SetRange("Document Line No.", ProdOrderComp."Prod. Order Line No.");
        MassBalanceEntry.SetRange("Prod. Order Component Line No.", ProdOrderComp."Line No.");
        MassBalanceEntry.SetRange("Entry Type", MassBalanceEntry."Entry Type"::Output);
        if MassBalanceEntry.FindSet() then
            repeat
                TempMassBalanceEntryOutput.Reset();
                TempMassBalanceEntryOutput.SetRange("Document No.", MassBalanceEntry."Document No.");
                TempMassBalanceEntryOutput.SetRange("Document Line No.", MassBalanceEntry."Document Line No.");
                TempMassBalanceEntryOutput.SetRange("Entry Type", MassBalanceEntry."Entry Type");
                TempMassBalanceEntryOutput.SetRange("Tracking Entry Type", MassBalanceEntry."Tracking Entry Type");
                TempMassBalanceEntryOutput.SetRange("Prod. Order Component Line No.", MassBalanceEntry."Prod. Order Component Line No.");
                TempMassBalanceEntryOutput.SetRange("Origin Lot No.", MassBalanceEntry."Origin Lot No.");
                TempMassBalanceEntryOutput.SetRange("Origin Item No.", MassBalanceEntry."Origin Item No.");
                if TempMassBalanceEntryOutput.FindFirst() then begin
                    TempMassBalanceEntryOutput."Item ledger Entry Qty." += MassBalanceEntry."Item ledger Entry Qty.";
                    TempMassBalanceEntryOutput.Modify();
                end else begin
                    TempMassBalanceEntryOutput := MassBalanceEntry;
                    if TempMassBalanceEntryOutput.Insert() then;
                end;
            until MassBalanceEntry.Next() = 0;


        TempMassBalanceEntryOutput.Reset();
        if TempMassBalanceEntryOutput.FindSet() then
            repeat
                MassBalanceEntry.Reset();
                MassBalanceEntry.SetRange("Document No.", TempMassBalanceEntryOutput."Document No.");
                MassBalanceEntry.SetRange("Document Line No.", TempMassBalanceEntryOutput."Document Line No.");
                MassBalanceEntry.SetRange("Entry Type", TempMassBalanceEntryOutput."Entry Type");
                MassBalanceEntry.SetRange("Tracking Entry Type", TempMassBalanceEntryOutput."Tracking Entry Type");
                MassBalanceEntry.SetRange("Prod. Order Component Line No.", TempMassBalanceEntryOutput."Prod. Order Component Line No.");
                MassBalanceEntry.SetRange("Origin Lot No.", TempMassBalanceEntryOutput."Origin Lot No.");
                MassBalanceEntry.SetRange("Origin Item No.", TempMassBalanceEntryOutput."Origin Item No.");
                MassBalanceEntryCount := MassBalanceEntry.Count();

                if MassBalanceEntryCount > 0 then
                    for i := 1 to MassBalanceEntryCount do begin
                        if i = 1 then begin
                            MassBalanceEntry.FindSet();

                            TempMassBalanceEntry.Reset();
                            TempMassBalanceEntry.SetRange("Document No.", TempMassBalanceEntryOutput."Document No.");
                            TempMassBalanceEntry.SetRange("Origin Prod. Order Line No.", TempMassBalanceEntryOutput."Origin Prod. Order Line No.");
                            TempMassBalanceEntry.SetRange("Orig. Prod. Order Comp.LineNo.", TempMassBalanceEntryOutput."Orig. Prod. Order Comp.LineNo.");
                            TempMassBalanceEntry.SetRange("Entry Type", TempMassBalanceEntry."Entry Type"::Consumption);
                            TempMassBalanceEntry.SetRange("Tracking Entry Type", TempMassBalanceEntry."Tracking Entry Type"::Consumption);
                            TempMassBalanceEntry.SetRange("Origin Lot No.", TempMassBalanceEntryOutput."Origin Lot No.");
                            TempMassBalanceEntry.SetRange("Origin Item No.", TempMassBalanceEntryOutput."Origin Item No.");
                            if not TempMassBalanceEntry.FindFirst() then//TODO
                                TempMassBalanceEntry.Init();
                            TempMassBalanceEntry2 := TempMassBalanceEntry;
                            if TempMassBalanceEntry2.Insert() then;
                        end else
                            MassBalanceEntry.Next();

                        if i = MassBalanceEntryCount then begin
                            MassBalanceEntry."Item Quantity" := Abs(TempMassBalanceEntry2."Item Quantity");
                            MassBalanceEntry."Tracked Quantity" := Abs(TempMassBalanceEntry2."Tracked Quantity");
                            MassBalanceEntry.Modify();
                        end else begin
                            factor := 0;
                            if TempMassBalanceEntryOutput."Item ledger Entry Qty." <> 0 then
                                Factor := MassBalanceEntry."Item ledger Entry Qty." / TempMassBalanceEntryOutput."Item ledger Entry Qty.";
                            MassBalanceEntry."Item Quantity" := Abs(TempMassBalanceEntry."Item Quantity" * Factor);
                            MassBalanceEntry."Tracked Quantity" := Abs(TempMassBalanceEntry."Tracked Quantity" * Factor);
                            MassBalanceEntry.Modify();

                            TempMassBalanceEntry2."Item Quantity" -= MassBalanceEntry."Item Quantity";
                            TempMassBalanceEntry2."Tracked Quantity" -= MassBalanceEntry."Tracked Quantity";
                            TempMassBalanceEntry2.Modify();
                        end;
                    end;
            until TempMassBalanceEntryOutput.Next() = 0;
    end;

    local procedure ClearLinkedConsOutputRecord(MassBalanceEntryParam: Record "ecMass Balances Entry")
    var
        MassBalanceEntryOutput, MassBalanceEntryConsumption, MassBalanceEntryLocal : Record "ecMass Balances Entry";
    begin
        MassBalanceEntryOutput.Reset();
        MassBalanceEntryOutput.SetRange("Entry Type", MassBalanceEntryOutput."Entry Type"::Output);
        MassBalanceEntryOutput.SetRange("Document No.", MassBalanceEntryParam."Document No.");
        MassBalanceEntryOutput.SetRange("Document Line No.", MassBalanceEntryParam."Document Line No.");
        MassBalanceEntryOutput.SetRange("Prod. Order Component Line No.", MassBalanceEntryParam."Prod. Order Component Line No.");
        if not MassBalanceEntryOutput.IsEmpty then
            MassBalanceEntryOutput.DeleteAll();

        MassBalanceEntryConsumption.Reset();
        MassBalanceEntryConsumption.SetRange("Entry Type", MassBalanceEntryConsumption."Entry Type"::Consumption);
        MassBalanceEntryConsumption.SetRange("Document No.", MassBalanceEntryParam."Document No.");
        MassBalanceEntryConsumption.SetRange("Document Line No.", MassBalanceEntryParam."Document Line No.");
        MassBalanceEntryConsumption.SetRange("Prod. Order Component Line No.", MassBalanceEntryParam."Prod. Order Component Line No.");
        MassBalanceEntryConsumption.SetFilter("Parent Entry No.", '<>%1', 0);
        if not MassBalanceEntryConsumption.IsEmpty then
            MassBalanceEntryConsumption.DeleteAll();

        // qui
        MassBalanceEntryLocal.Reset();
        MassBalanceEntryLocal.SetRange("Document No.", MassBalanceEntryParam."Document No.");
        MassBalanceEntryLocal.SetRange("Document Line No.", MassBalanceEntryParam."Document Line No.");
        MassBalanceEntryLocal.SetRange("Prod. Order Component Line No.", MassBalanceEntryParam."Prod. Order Component Line No.");
        MassBalanceEntryLocal.SetFilter("Origin prod. order no.", '<>%1', '');
        if not MassBalanceEntryLocal.IsEmpty then
            MassBalanceEntryLocal.DeleteAll();
    end;

    procedure ClearLinkedConsOutputRecord(ProdOrderLine: Record "Prod. Order Line")
    var
        ProdOrderComp: Record "Prod. Order Component";
        MassBalanceEntry: Record "ecMass Balances Entry";
    begin
        ProdOrderComp.Reset();
        ProdOrderComp.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderComp.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
        if ProdOrderComp.FindSet() then
            repeat
                MassBalanceEntry.Reset();
                MassBalanceEntry.SetRange("Entry Type", MassBalanceEntry."Entry Type"::Consumption);
                MassBalanceEntry.SetRange("Document No.", ProdOrderComp."Prod. Order No.");
                MassBalanceEntry.SetRange("Document Line No.", ProdOrderComp."Prod. Order Line No.");
                MassBalanceEntry.SetRange("Prod. Order Component Line No.", ProdOrderComp."Line No.");
                MassBalanceEntry.SetFilter("Parent Entry No.", '%1', 0);
                if MassBalanceEntry.FindSet() then
                    repeat
                        ClearLinkedConsOutputRecord(MassBalanceEntry);
                    until MassBalanceEntry.Next() = 0;
            until ProdOrderComp.Next() = 0;
    end;

    local procedure CreateTempMassBalanceEntry(MassBalanceEntryParam: Record "ecMass Balances Entry"; SourceMassBalanceEntryParam: Record "ecMass Balances Entry"; var TempMassBalanceEntry: Record "ecMass Balances Entry" temporary)
    var
        ProdOrderLine: Record "Prod. Order Line";
        MassBalanceEntry: Record "ecMass Balances Entry";
    begin
        ProdOrderLine.Reset();
        ProdOrderLine.SetRange("Prod. Order No.", MassBalanceEntryParam."Document No.");
        ProdOrderLine.SetRange("ecParent Line No.", MassBalanceEntryParam."Document Line No.");
        if not ProdOrderLine.FindSet() then begin
            TempMassBalanceEntry.Reset();
            TempMassBalanceEntry.SetRange("Document No.", SourceMassBalanceEntryParam."Document No.");
            TempMassBalanceEntry.SetRange("Document Line No.", SourceMassBalanceEntryParam."Document Line No.");
            TempMassBalanceEntry.SetRange("Prod. Order Component Line No.", SourceMassBalanceEntryParam."Prod. Order Component Line No.");
            TempMassBalanceEntry.SetRange("Entry Type", MassBalanceEntryParam."Entry Type");
            TempMassBalanceEntry.SetRange("Origin Lot No.", MassBalanceEntryParam."Origin Lot No.");
            TempMassBalanceEntry.SetRange("Origin Prod. Order Line No.", MassBalanceEntryParam."Origin Prod. Order Line No.");
            TempMassBalanceEntry.SetRange("Orig. Prod. Order Comp.LineNo.", MassBalanceEntryParam."Orig. Prod. Order Comp.LineNo.");
            if TempMassBalanceEntry.FindFirst() then begin
                TempMassBalanceEntry."Item Quantity" += MassBalanceEntryParam."Item Quantity";
                TempMassBalanceEntry."Tracked Quantity" += MassBalanceEntryParam."Tracked Quantity";
                TempMassBalanceEntry.Modify();
            end else begin
                TempMassBalanceEntry := MassBalanceEntryParam;
                TempMassBalanceEntry."Document Line No." := SourceMassBalanceEntryParam."Document Line No.";
                TempMassBalanceEntry."Prod. Order Component Line No." := SourceMassBalanceEntryParam."Prod. Order Component Line No.";
                if TempMassBalanceEntry.Insert() then;
            end;
        end else
            repeat
                MassBalanceEntry.Reset();
                MassBalanceEntry.SetRange("Document No.", ProdOrderLine."Prod. Order No.");
                MassBalanceEntry.SetRange("Document Line No.", ProdOrderLine."Line No.");
                MassBalanceEntry.SetRange("Entry Type", MassBalanceEntry."Entry Type"::Consumption);
                MassBalanceEntry.SetRange("Tracking Entry Type", MassBalanceEntry."Tracking Entry Type"::Consumption);
                MassBalanceEntry.SetRange("Parent Entry No.", 0);
                if MassBalanceEntry.FindSet() then
                    repeat
                        CreateTempMassBalanceEntry(MassBalanceEntry, SourceMassBalanceEntryParam, TempMassBalanceEntry);
                    until MassBalanceEntry.Next() = 0;
            until ProdOrderLine.Next() = 0;
    end;
    #endregion Generic Functions
}