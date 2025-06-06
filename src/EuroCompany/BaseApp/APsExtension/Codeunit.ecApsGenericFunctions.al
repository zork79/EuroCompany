namespace EuroCompany.BaseApp.APsExtension;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item.Catalog;
using Microsoft.Sales.History;

codeunit 50013 "ecApsGeneric Functions"
{
    #region 219
    procedure GenerateShipmentAndLotConcatenatedFilters(IntrastatJournalLine: Record "APsIntrastat Decl. Jnl. Line"; var ShipmentFilter: Text; var LotFilter: Text)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        SalesInvoiceLine.SetLoadFields("Shipment No.", "AltAWPPosted Whse Shipment No.", "AltAWPPosted Whse Ship. Line");
        if SalesInvoiceLine.Get(IntrastatJournalLine."Document No.", IntrastatJournalLine."Document Line No.") then begin
            if SalesInvoiceLine."Shipment No." <> '' then
                ShipmentFilter := SalesInvoiceLine."Shipment No.";

            if SalesInvoiceLine."AltAWPPosted Whse Shipment No." <> '' then begin
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetLoadFields("Lot No.");
                ItemLedgerEntry.SetRange("AltAWPPosted Document Type", ItemLedgerEntry."AltAWPPosted Document Type"::"Warehouse Shipment");
                ItemLedgerEntry.SetRange("AltAWPPosted Document No.", SalesInvoiceLine."AltAWPPosted Whse Shipment No.");
                ItemLedgerEntry.SetRange("AltAWPPosted Doc. Line No.", SalesInvoiceLine."AltAWPPosted Whse Ship. Line");
                if ItemLedgerEntry.FindSet() then begin
                    repeat
                        LotFilter := LotFilter + ItemLedgerEntry."Lot No." + '|';
                    until ItemLedgerEntry.Next() = 0;
                end;
            end;
        end;
    end;
    #endregion 219

    #region 379
    procedure ItemChargesAssignment(var IntraDeclJnlLine: Record "APsIntrastat Decl. Jnl. Line")
    var
        ValueEntry: Record "Value Entry";
        ValueEntry2: Record "Value Entry";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ItemLedgEntryNoFilter: Text;
        TotActualCostAmount: Decimal;
        TotActualSalesAmount: Decimal;
    begin
        if IntraDeclJnlLine.FindSet() then
            repeat
                case IntraDeclJnlLine.Type of
                    IntraDeclJnlLine.Type::Receipt:
                        begin
                            Clear(TotActualCostAmount);
                            Clear(ItemLedgEntryNoFilter);

                            TempItemLedgEntry.Reset();
                            TempItemLedgEntry.DeleteAll();

                            ValueEntry.Reset();
                            ValueEntry.SetRange("Document No.", IntraDeclJnlLine."Document No.");
                            ValueEntry.SetRange("Document Line No.", IntraDeclJnlLine."Document Line No.");
                            if ValueEntry.FindSet() then
                                repeat
                                    if not TempItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                                        TempItemLedgEntry.Init();
                                        TempItemLedgEntry."Entry No." := ValueEntry."Item Ledger Entry No.";
                                        TempItemLedgEntry.Insert();
                                    end;
                                until ValueEntry.Next() = 0;

                            TempItemLedgEntry.Reset();
                            if TempItemLedgEntry.FindSet() then
                                repeat
                                    if ItemLedgEntryNoFilter <> '' then
                                        ItemLedgEntryNoFilter := ItemLedgEntryNoFilter + '|';
                                    ItemLedgEntryNoFilter := ItemLedgEntryNoFilter + Format(TempItemLedgEntry."Entry No.");
                                until TempItemLedgEntry.Next() = 0;

                            if ItemLedgEntryNoFilter <> '' then begin
                                ValueEntry2.Reset();
                                ValueEntry2.SetFilter("Item Ledger Entry No.", ItemLedgEntryNoFilter);
                                if ValueEntry2.FindSet() then
                                    repeat
                                        TotActualCostAmount += ValueEntry2."Cost Amount (Actual)";
                                    until ValueEntry2.Next() = 0;

                                IntraDeclJnlLine.Validate(Amount, TotActualCostAmount);
                                IntraDeclJnlLine.Modify();
                            end;
                        end;

                    IntraDeclJnlLine.Type::Shipment:
                        begin
                            Clear(TotActualSalesAmount);
                            Clear(ItemLedgEntryNoFilter);

                            TempItemLedgEntry.Reset();
                            TempItemLedgEntry.DeleteAll();

                            ValueEntry.Reset();
                            ValueEntry.SetRange("Document No.", IntraDeclJnlLine."Document No.");
                            ValueEntry.SetRange("Document Line No.", IntraDeclJnlLine."Document Line No.");
                            if ValueEntry.FindSet() then
                                repeat
                                    if not TempItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                                        TempItemLedgEntry.Init();
                                        TempItemLedgEntry."Entry No." := ValueEntry."Item Ledger Entry No.";
                                        TempItemLedgEntry.Insert();
                                    end;
                                until ValueEntry.Next() = 0;

                            TempItemLedgEntry.Reset();
                            if TempItemLedgEntry.FindSet() then
                                repeat
                                    if ItemLedgEntryNoFilter <> '' then
                                        ItemLedgEntryNoFilter := ItemLedgEntryNoFilter + '|';
                                    ItemLedgEntryNoFilter := ItemLedgEntryNoFilter + Format(TempItemLedgEntry."Entry No.");
                                until TempItemLedgEntry.Next() = 0;

                            if ItemLedgEntryNoFilter <> '' then begin
                                ValueEntry2.Reset();
                                ValueEntry2.SetFilter("Item Ledger Entry No.", ItemLedgEntryNoFilter);
                                if ValueEntry2.FindSet() then
                                    repeat
                                        TotActualSalesAmount += ValueEntry2."Sales Amount (Actual)";
                                    until ValueEntry2.Next() = 0;

                                IntraDeclJnlLine.Validate(Amount, TotActualSalesAmount);
                                IntraDeclJnlLine.Modify();
                            end;
                        end;
                end;
            until IntraDeclJnlLine.Next() = 0;
    end;
    #endregion 379

    #region 398
    procedure GetReferenceNoEAN13(var TRDPriceDetail: Record "APsTRD Price Detail")
    var
        ItemReference: Record "Item Reference";
    begin
        ItemReference.Reset();
        ItemReference.SetRange("Item No.", TRDPriceDetail."Product No.");
        ItemReference.SetRange("Variant Code", TRDPriceDetail."Variant Code");
        ItemReference.SetRange("Unit of Measure", TRDPriceDetail."Unit of Measure Code");
        ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::"Bar Code");
        ItemReference.SetRange("AltAWPBarcode Type", ItemReference."AltAWPBarcode Type"::"EAN-13");
        if ItemReference.FindFirst() then
            TRDPriceDetail.Validate("ecReference No. EAN-13", ItemReference."Reference No.");
    end;

    procedure DrillDownItemReference(TRDPriceDetail: Record "APsTRD Price Detail")
    var
        ItemReference: Record "Item Reference";
        ItemReferenceEntries: Page "Item Reference Entries";
    begin
        ItemReference.Reset();
        ItemReference.SetRange("Item No.", TRDPriceDetail."Product No.");
        ItemReference.SetRange("Variant Code", TRDPriceDetail."Variant Code");
        ItemReference.SetRange("Unit of Measure", TRDPriceDetail."Unit of Measure Code");
        ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::"Bar Code");
        ItemReference.SetRange("AltAWPBarcode Type", ItemReference."AltAWPBarcode Type"::"EAN-13");
        if ItemReference.FindFirst() then begin
            ItemReferenceEntries.SetTableView(ItemReference);
            ItemReferenceEntries.Run();
        end;
    end;
    #endregion 398
}