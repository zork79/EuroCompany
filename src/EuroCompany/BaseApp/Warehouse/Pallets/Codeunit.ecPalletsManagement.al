namespace EuroCompany.BaseApp.Warehouse.Pallets;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using EuroCompany.BaseApp.Setup;
using Microsoft.Warehouse.History;
using Microsoft.Foundation.Enums;
using Microsoft.Inventory.Location;
using Microsoft.Purchases.Document;
using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Ledger;
using Microsoft.Warehouse.Ledger;
using Microsoft.Warehouse.Document;

codeunit 50026 "ecPallets Management"
{
    Permissions = tabledata "Posted Whse. Shipment Header" = rimd,
                tabledata "Posted Whse. Receipt Header" = rimd;

    procedure GeneralChecksGeneralSetup(GeneralPalletSetup: Record "ecGeneral Pallet Setup")
    var
        SourceDocTypeReceiptOrShipmentErr: Label 'If the document is %1 the allowed value for the %2 field are: %3, %4, %5.';
        AdjmtErr: Label 'If the document is %1 the only allowed value for the %2 field is blank.';
    begin
        case GeneralPalletSetup.Document of
            GeneralPalletSetup.Document::"Warehouse Receipt":
                begin
                    if (GeneralPalletSetup."Source Document Type" <> GeneralPalletSetup."Source Document Type"::"Purchase Order") and (GeneralPalletSetup."Source Document Type" <> GeneralPalletSetup."Source Document Type"::"Transfer Order") and
                                    (GeneralPalletSetup."Source Document Type" <> GeneralPalletSetup."Source Document Type"::"Sales Return Order") then
                        Error(SourceDocTypeReceiptOrShipmentErr, GeneralPalletSetup.Document::"Warehouse Receipt", GeneralPalletSetup.FieldCaption("Source Document Type"), GeneralPalletSetup."Source Document Type"::"Purchase Order",
                                    GeneralPalletSetup."Source Document Type"::"Transfer Order", GeneralPalletSetup."Source Document Type"::"Sales Return Order");
                end;

            GeneralPalletSetup.Document::"Warehouse Shipment":
                begin
                    if (GeneralPalletSetup."Source Document Type" <> GeneralPalletSetup."Source Document Type"::"Sales Order") and (GeneralPalletSetup."Source Document Type" <> GeneralPalletSetup."Source Document Type"::"Transfer Order") and
                                    (GeneralPalletSetup."Source Document Type" <> GeneralPalletSetup."Source Document Type"::"Purchase Return Order") then
                        Error(SourceDocTypeReceiptOrShipmentErr, GeneralPalletSetup.Document::"Warehouse Shipment", GeneralPalletSetup.FieldCaption("Source Document Type"), GeneralPalletSetup."Source Document Type"::"Sales Order",
                                    GeneralPalletSetup."Source Document Type"::"Transfer Order", GeneralPalletSetup."Source Document Type"::"Purchase Return Order");
                end;

            GeneralPalletSetup.Document::"Positive Adjmt.":
                begin
                    if GeneralPalletSetup."Source Document Type" <> GeneralPalletSetup."Source Document Type"::" " then
                        Error(AdjmtErr, GeneralPalletSetup.Document::"Positive Adjmt.", GeneralPalletSetup.FieldCaption("Source Document Type"));
                end;

            GeneralPalletSetup.Document::"Negative Adjmt.":
                begin
                    if GeneralPalletSetup."Source Document Type" <> GeneralPalletSetup."Source Document Type"::" " then
                        Error(AdjmtErr, GeneralPalletSetup.Document::"Negative Adjmt.", GeneralPalletSetup.FieldCaption("Source Document Type"));
                end;
        end;
    end;

    procedure SetAllowAdjmtInShipReceiptEditability(GeneralPalletSetup: Record "ecGeneral Pallet Setup"; var AllowAdjmtInShipReceiptEditability: Boolean)
    begin
        AllowAdjmtInShipReceiptEditability := true;

        if (GeneralPalletSetup.Document = GeneralPalletSetup.Document::"Negative Adjmt.") or (GeneralPalletSetup.Document = GeneralPalletSetup.Document::"Positive Adjmt.") then
            AllowAdjmtInShipReceiptEditability := false;
    end;

    procedure GetPalletsValues(var WarehouseEntry: Record "Warehouse Entry")
    begin
        case WarehouseEntry."Source Document" of
            WarehouseEntry."Source Document"::"S. Order":
                begin
                    GetMembersCPRCode(WarehouseEntry);
                    GetShipPalletMovReasonCode(WarehouseEntry);
                end;

            WarehouseEntry."Source Document"::"P. Order":
                begin
                    GetReceiptPalletMovReasonCode(WarehouseEntry);
                end;

            WarehouseEntry."Source Document"::"P. Return Order":
                begin
                    GetMembersCPRCode(WarehouseEntry);
                    GetShipPalletMovReasonCode(WarehouseEntry);
                end;

            WarehouseEntry."Source Document"::"S. Return Order":
                begin
                    GetReceiptPalletMovReasonCode(WarehouseEntry);
                end;

            WarehouseEntry."Source Document"::"Inb. Transfer":
                begin
                    GetReceiptPalletMovReasonCode(WarehouseEntry);
                end;

            WarehouseEntry."Source Document"::"Outb. Transfer":
                begin
                    GetShipPalletMovReasonCode(WarehouseEntry);
                end;
        end;
    end;

    local procedure GetMembersCPRCode(var WarehouseEntry: Record "Warehouse Entry")
    var
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
    begin
        case WarehouseEntry."Source Document" of
            WarehouseEntry."Source Document"::"S. Order":
                if SalesHeader.Get(SalesHeader."Document Type"::Order, WarehouseEntry."Source No.") then
                    if Customer.Get(SalesHeader."Sell-to Customer No.") then begin
                        WarehouseEntry.Validate("ecMember's CPR Code", Customer."ecMember's CPR Code");
                        WarehouseEntry.Modify();
                    end;

            WarehouseEntry."Source Document"::"P. Return Order":
                if SalesHeader.Get(SalesHeader."Document Type"::"Return Order", WarehouseEntry."Source No.") then
                    if Customer.Get(SalesHeader."Sell-to Customer No.") then begin
                        WarehouseEntry.Validate("ecMember's CPR Code", Customer."ecMember's CPR Code");
                        WarehouseEntry.Modify();
                    end;
        end;
    end;

    local procedure GetShipPalletMovReasonCode(var WarehouseEntry: Record "Warehouse Entry")
    var
        ecGeneralPalletSetup: Record "ecGeneral Pallet Setup";
    begin
        case WarehouseEntry."Source Document" of
            WarehouseEntry."Source Document"::"S. Order":
                begin
                    ecGeneralPalletSetup.Reset();
                    ecGeneralPalletSetup.SetRange(Document, ecGeneralPalletSetup.Document::"Warehouse Shipment");
                    ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Sales Order");
                    ecGeneralPalletSetup.SetRange("BC Reason Code", WarehouseEntry."AltAWPReason Code");
                    if not ecGeneralPalletSetup.IsEmpty() then
                        CheckAWPLogUnitFormatAndGetValues(ecGeneralPalletSetup, WarehouseEntry);
                end;

            WarehouseEntry."Source Document"::"P. Return Order":
                begin
                    ecGeneralPalletSetup.Reset();
                    ecGeneralPalletSetup.SetRange(Document, ecGeneralPalletSetup.Document::"Warehouse Shipment");
                    ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Purchase Return Order");
                    ecGeneralPalletSetup.SetRange("BC Reason Code", WarehouseEntry."AltAWPReason Code");
                    if not ecGeneralPalletSetup.IsEmpty() then
                        CheckAWPLogUnitFormatAndGetValues(ecGeneralPalletSetup, WarehouseEntry);
                end;

            WarehouseEntry."Source Document"::"Outb. Transfer":
                begin
                    ecGeneralPalletSetup.Reset();
                    ecGeneralPalletSetup.SetRange(Document, ecGeneralPalletSetup.Document::"Warehouse Shipment");
                    ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Transfer Order");
                    ecGeneralPalletSetup.SetRange("BC Reason Code", WarehouseEntry."AltAWPReason Code");
                    if not ecGeneralPalletSetup.IsEmpty() then
                        CheckAWPLogUnitFormatAndGetValues(ecGeneralPalletSetup, WarehouseEntry);
                end;
        end;
    end;

    local procedure GetReceiptPalletMovReasonCode(var WarehouseEntry: Record "Warehouse Entry")
    var
        ecGeneralPalletSetup: Record "ecGeneral Pallet Setup";
    begin
        case WarehouseEntry."Source Document" of
            WarehouseEntry."Source Document"::"P. Order":
                begin
                    ecGeneralPalletSetup.Reset();
                    ecGeneralPalletSetup.SetRange(Document, ecGeneralPalletSetup.Document::"Warehouse Receipt");
                    ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Purchase Order");
                    ecGeneralPalletSetup.SetRange("BC Reason Code", WarehouseEntry."AltAWPReason Code");
                    if not ecGeneralPalletSetup.IsEmpty() then
                        CheckAWPLogUnitFormatAndGetValues(ecGeneralPalletSetup, WarehouseEntry);
                end;

            WarehouseEntry."Source Document"::"S. Return Order":
                begin
                    ecGeneralPalletSetup.Reset();
                    ecGeneralPalletSetup.SetRange(Document, ecGeneralPalletSetup.Document::"Warehouse Receipt");
                    ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Sales Return Order");
                    ecGeneralPalletSetup.SetRange("BC Reason Code", WarehouseEntry."AltAWPReason Code");
                    if not ecGeneralPalletSetup.IsEmpty() then
                        CheckAWPLogUnitFormatAndGetValues(ecGeneralPalletSetup, WarehouseEntry);
                end;

            WarehouseEntry."Source Document"::"Inb. Transfer":
                begin
                    ecGeneralPalletSetup.Reset();
                    ecGeneralPalletSetup.SetRange(Document, ecGeneralPalletSetup.Document::"Warehouse Receipt");
                    ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Transfer Order");
                    ecGeneralPalletSetup.SetRange("BC Reason Code", WarehouseEntry."AltAWPReason Code");
                    if not ecGeneralPalletSetup.IsEmpty() then
                        CheckAWPLogUnitFormatAndGetValues(ecGeneralPalletSetup, WarehouseEntry);
                end;
        end;
    end;

    local procedure CheckAWPLogUnitFormatAndGetValues(var GeneralPalletSetup: Record "ecGeneral Pallet Setup"; var WarehouseEntry: Record "Warehouse Entry")
    var
        AwpLogUnitFormat: Record "AltAWPLogistic Unit Format";
    begin
        AwpLogUnitFormat.Reset();
        AwpLogUnitFormat.SetLoadFields("ecPallet/Box Grouping Code", "ecCHEP Gtin");

        if WarehouseEntry."AltAWPPallet Format Code" <> '' then
            AwpLogUnitFormat.SetRange(Code, WarehouseEntry."AltAWPPallet Format Code")
        else
            AwpLogUnitFormat.SetRange("Inventory Register Item No.", WarehouseEntry."Item No.");

        AwpLogUnitFormat.SetRange("Enable Inventory Register", true);
        if AwpLogUnitFormat.FindFirst() then begin
            GeneralPalletSetup.SetRange("Pallet Grouping Code", AwpLogUnitFormat."ecPallet/Box Grouping Code");
            if GeneralPalletSetup.FindFirst() then begin
                WarehouseEntry.Validate("ecPallet Movement Reason Code", GeneralPalletSetup."Pallet Movement Reason");
                WarehouseEntry.Validate("ecPallet Grouping Code", GeneralPalletSetup."Pallet Grouping Code");
                WarehouseEntry.Validate("ecCHEP Gtin", AwpLogUnitFormat."ecCHEP Gtin");
                WarehouseEntry.Modify();
            end;
        end;

        AwpLogUnitFormat.Reset();
        AwpLogUnitFormat.SetLoadFields("ecPallet/Box Grouping Code", "ecCHEP Gtin");

        if WarehouseEntry."AltAWPBox Format Code" <> '' then
            AwpLogUnitFormat.SetRange(Code, WarehouseEntry."AltAWPBox Format Code")
        else
            AwpLogUnitFormat.SetRange("Inventory Register Item No.", WarehouseEntry."Item No.");

        AwpLogUnitFormat.SetRange("Enable Inventory Register", true);
        if AwpLogUnitFormat.FindFirst() then begin
            GeneralPalletSetup.SetRange("Pallet Grouping Code", AwpLogUnitFormat."ecPallet/Box Grouping Code");
            if GeneralPalletSetup.FindFirst() then begin
                WarehouseEntry.Validate("ecBox Movement Reason Code", GeneralPalletSetup."Pallet Movement Reason");
                WarehouseEntry.Validate("ecBox Grouping Code", GeneralPalletSetup."Pallet Grouping Code");
                WarehouseEntry.Validate("ecCHEP Gtin", AwpLogUnitFormat."ecCHEP Gtin");
                WarehouseEntry.Modify();
            end;
        end;
    end;

    procedure GenerateItemJournalLines(RecordVariant: Variant)
    var
        PostedWhseRecHeader: Record "Posted Whse. Receipt Header";
        PostedWhseShipHeader: Record "Posted Whse. Shipment Header";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(RecordVariant);

        case RecRef.Number of
            DataBase::"Posted Whse. Receipt Header":
                begin
                    RecRef.SetTable(PostedWhseRecHeader);
                    PostedWhseRecHeader.TestField("ecAllow Adjmt. In Ship/Receipt", true);
                    PostedWhseRecHeader.TestField("ecPallet Status Mgt.", PostedWhseRecHeader."ecPallet Status Mgt."::Required);
                    GetCorrectWarehouseEntryLines(PostedWhseRecHeader."No.");
                end;

            Database::"Posted Whse. Shipment Header":
                begin
                    RecRef.SetTable(PostedWhseShipHeader);
                    PostedWhseShipHeader.TestField("ecAllow Adjmt. In Ship/Receipt", true);
                    PostedWhseShipHeader.TestField("ecPallet Status Mgt.", PostedWhseShipHeader."ecPallet Status Mgt."::Required);
                    GetCorrectWarehouseEntryLines(PostedWhseShipHeader."No.");
                end;
        end;
    end;

    local procedure GetCorrectWarehouseEntryLines(WhseDocumentNo: Code[20])
    var
        GeneralSetup: Record "ecGeneral Setup";
        JnlBatchName: Code[10];
        JnlTemplateName: Code[10];
    begin
        GeneralSetup.Get();
        GeneralSetup.TestField("Journal Batch Name");
        GeneralSetup.TestField("Journal Template Name");

        JnlBatchName := GeneralSetup."Journal Batch Name";
        JnlTemplateName := GeneralSetup."Journal Template Name";

        GetCorrectWarehousePalletBoxLines(WhseDocumentNo, JnlBatchName, JnlTemplateName);
    end;

    local procedure GetCorrectWarehousePalletBoxLines(WhseDocumentNo: Code[20]; JnlBatchName: Code[10]; JnlTemplateName: Code[10])
    var
        WarehouseEntry: Record "Warehouse Entry";
        PalletFormatCode, BoxFormatCode, ItemNo : Code[20];
        Quantity: Integer;
        BatchInserted: Boolean;
        PalletBox: Option Pallet,Box;
    begin
        Clear(PalletFormatCode);
        Clear(BoxFormatCode);
        Clear(Quantity);
        Clear(ItemNo);

        WarehouseEntry.Reset();
        WarehouseEntry.SetRange("Whse. Document No.", WhseDocumentNo);
        WarehouseEntry.SetFilter("AltAWPPallet Format Code", '<>%1', '');
        if not WarehouseEntry.IsEmpty() then
            if WarehouseEntry.FindSet() then begin
                repeat
                    if PalletFormatCode <> WarehouseEntry."AltAWPPallet Format Code" then begin
                        Clear(Quantity);

                        PalletFormatCode := WarehouseEntry."AltAWPPallet Format Code";

                        if UnitFormatLogisticEnable(PalletFormatCode, ItemNo) then begin
                            CountDifferentPalletsORBoxesForEachFormat(PalletFormatCode, WhseDocumentNo, PalletBox::Pallet, Quantity);

                            InsertItemJournalLineFromWhseEntry(WarehouseEntry, Quantity, ItemNo, BatchInserted, JnlBatchName, JnlTemplateName);
                        end;
                    end;
                until WarehouseEntry.Next() = 0;
            end;

        WarehouseEntry.Reset();
        WarehouseEntry.SetRange("Whse. Document No.", WhseDocumentNo);
        WarehouseEntry.SetFilter("AltAWPBox Format Code", '<>%1', '');
        if not WarehouseEntry.IsEmpty() then
            if WarehouseEntry.FindSet() then begin
                repeat
                    if BoxFormatCode <> WarehouseEntry."AltAWPBox Format Code" then begin
                        Clear(Quantity);

                        BoxFormatCode := WarehouseEntry."AltAWPBox Format Code";

                        if UnitFormatLogisticEnable(BoxFormatCode, ItemNo) then begin
                            CountDifferentPalletsORBoxesForEachFormat(BoxFormatCode, WhseDocumentNo, PalletBox::Box, Quantity);

                            InsertItemJournalLineFromWhseEntry(WarehouseEntry, Quantity, ItemNo, BatchInserted, JnlBatchName, JnlTemplateName);
                        end;
                    end;
                until WarehouseEntry.Next() = 0;
            end;

        RunItemJournal(WhseDocumentNo, BatchInserted, JnlBatchName, JnlTemplateName);
    end;

    local procedure CountDifferentPalletsORBoxesForEachFormat(GenericFormatCode: Code[20]; WhseDocumentNo: Code[20]; PalletBox: Option Pallet,Box; var Quantity: Integer)
    var
        WarehouseEntry: Record "Warehouse Entry";
        PalletNo, BoxNo : Code[50];
    begin
        Clear(PalletNo);
        Clear(BoxNo);

        WarehouseEntry.Reset();
        WarehouseEntry.SetLoadFields("AltAWPPallet No.", "AltAWPBox No.");
        WarehouseEntry.SetRange("Whse. Document No.", WhseDocumentNo);

        case PalletBox of
            PalletBox::Pallet:
                begin
                    WarehouseEntry.SetRange("AltAWPPallet Format Code", GenericFormatCode);
                end;

            PalletBox::Box:
                begin
                    WarehouseEntry.SetRange("AltAWPBox Format Code", GenericFormatCode);
                end;
        end;

        if not WarehouseEntry.IsEmpty() then begin
            if WarehouseEntry.FindSet() then
                repeat
                    case PalletBox of
                        PalletBox::Pallet:
                            if PalletNo <> WarehouseEntry."AltAWPPallet No." then begin
                                PalletNo := WarehouseEntry."AltAWPPallet No.";
                                Quantity += 1;
                            end;

                        PalletBox::Box:
                            if BoxNo <> WarehouseEntry."AltAWPBox No." then begin
                                BoxNo := WarehouseEntry."AltAWPBox No.";
                                Quantity += 1;
                            end;
                    end;
                until WarehouseEntry.Next() = 0;
        end;
    end;

    local procedure UnitFormatLogisticEnable(GenericFormatCode: Code[20]; var ItemNo: Code[20]): Boolean
    var
        AWPLogisticUnitFormat: Record "AltAWPLogistic Unit Format";
    begin
        Clear(ItemNo);

        if AWPLogisticUnitFormat.Get(GenericFormatCode) then
            if AWPLogisticUnitFormat."Enable Inventory Register" then begin
                ItemNo := AWPLogisticUnitFormat."Inventory Register Item No.";
                exit(true);
            end;

        exit(false);
    end;

    local procedure RunItemJournal(WhseDocumentNo: Code[20]; BatchInserted: Boolean; JnlBatchName: Code[10]; JnlTemplateName: Code[10])
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJournal: Page "Item Journal";
        NoBoxOrPalletFoundToBeRectifiedErr: Label 'No boxes or pallets found to be rectified!';
        ItemJournalLinesCreatedSuccessfullyLbl: Label 'Item journal lines created successfully, open batch?';
    begin
        if not BatchInserted then
            Error(NoBoxOrPalletFoundToBeRectifiedErr)
        else
            if Confirm(ItemJournalLinesCreatedSuccessfullyLbl) then begin
                ItemJournalLine.Reset();
                ItemJournalLine.SetRange("Journal Batch Name", JnlBatchName);
                ItemJournalLine.SetRange("Journal Template Name", JnlTemplateName);
                ItemJournalLine.SetRange("Document No.", WhseDocumentNo);
                if ItemJournalLine.FindSet() then begin
                    ItemJournal.SetTableView(ItemJournalLine);
                    ItemJournal.SetRecord(ItemJournalLine);
                    Commit();
                    ItemJournal.RunModal();
                end;
            end;
    end;

    procedure RunItemJournal(WhseDocumentNo: Code[20])
    var
        ItemJournalLine: Record "Item Journal Line";
        GeneralSetup: Record "ecGeneral Setup";
        ItemJournal: Page "Item Journal";
        NoBatchLineMsg: Label 'No batch lines present for this document.';
    begin
        GeneralSetup.Get();
        GeneralSetup.TestField("Journal Batch Name");
        GeneralSetup.TestField("Journal Template Name");

        ItemJournalLine.Reset();
        ItemJournalLine.SetRange("Journal Batch Name", GeneralSetup."Journal Batch Name");
        ItemJournalLine.SetRange("Journal Template Name", GeneralSetup."Journal Template Name");
        ItemJournalLine.SetRange("Document No.", WhseDocumentNo);
        if ItemJournalLine.FindSet() then begin
            ItemJournal.SetTableView(ItemJournalLine);
            ItemJournal.SetRecord(ItemJournalLine);
            ItemJournal.RunModal();
        end else
            Message(NoBatchLineMsg);
    end;

    local procedure InsertItemJournalLineFromWhseEntry(WhseEntry: Record "Warehouse Entry"; Quantity: Integer; ItemNo: Code[20]; var BatchInserted: Boolean; JnlBatchName: Code[10]; JnlTemplateName: Code[10])
    var
        ItemJnlLine, LastItemJnlLine : Record "Item Journal Line";
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        AwpLogUnitFormat: Record "AltAWPLogistic Unit Format";
        Location: Record Location;
        BinCode: Code[20];
        Document: Enum "ecPallets Document Type";
        SourceDocType: Enum "ecPallet Source Doc. Type";
    begin
        ItemJnlLine.Init();
        ItemJnlLine.Validate("Journal Template Name", JnlTemplateName);
        ItemJnlLine.Validate("Journal Batch Name", JnlBatchName);

        LastItemJnlLine.Reset();
        LastItemJnlLine.SetRange("Journal Template Name", JnlTemplateName);
        LastItemJnlLine.SetRange("Journal Batch Name", JnlBatchName);
        if LastItemJnlLine.FindLast() then
            ItemJnlLine."Line No." := LastItemJnlLine."Line No." + 10000
        else
            ItemJnlLine."Line No." := 10000;

        ItemJnlLine.Validate("Posting Date", WhseEntry."Registering Date");
        ItemJnlLine.Validate("Item No.", ItemNo);

        case WhseEntry."Whse. Document Type" of
            WhseEntry."Whse. Document Type"::Shipment:
                begin
                    ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::"Negative Adjmt.");
                    ItemJnlLine.Validate("AltAWPPosted Document Type", ItemJnlLine."AltAWPPosted Document Type"::"Warehouse Shipment");

                    case WhseEntry."Source Document" of
                        WhseEntry."Source Document"::"S. Order":
                            if SalesHeader.Get(SalesHeader."Document Type"::Order, WhseEntry."Source No.") then begin
                                ItemJnlLine.Validate("Source Type", ItemJnlLine."Source Type"::Customer);
                                ItemJnlLine.Validate("Source No.", SalesHeader."Sell-to Customer No.");
                                ItemJnlLine.Validate("ecSource Description", SalesHeader."Sell-to Customer Name");

                                GetCausalPalletEntryForItemJnlLine(Document::"Warehouse Shipment", SourceDocType::"Sales Order", WhseEntry, ItemJnlLine);
                            end;

                        WhseEntry."Source Document"::"P. Return Order":
                            if PurchaseHeader.Get(PurchaseHeader."Document Type"::"Return Order", WhseEntry."Source No.") then begin
                                ItemJnlLine.Validate("Source Type", ItemJnlLine."Source Type"::Vendor);
                                ItemJnlLine.Validate("Source No.", PurchaseHeader."Buy-from Vendor No.");
                                ItemJnlLine.Validate("ecSource Description", PurchaseHeader."Buy-from Vendor Name");

                                GetCausalPalletEntryForItemJnlLine(Document::"Warehouse Shipment", SourceDocType::"Purchase Return Order", WhseEntry, ItemJnlLine);
                            end;

                        WhseEntry."Source Document"::"Outb. Transfer":
                            begin
                                ItemJnlLine.Validate("Source Type", ItemJnlLine."Source Type"::" ");
                                ItemJnlLine.Validate("Source No.", WhseEntry."Location Code");

                                if Location.Get(WhseEntry."Location Code") then begin
                                    Location.TestField("ecPallets Bin Code");
                                    ItemJnlLine.Validate("ecSource Description", Location.Name);
                                    BinCode := Location."ecPallets Bin Code";
                                end;

                                GetCausalPalletEntryForItemJnlLine(Document::"Warehouse Shipment", SourceDocType::"Transfer Order", WhseEntry, ItemJnlLine);
                            end;
                    end;
                end;

            WhseEntry."Whse. Document Type"::Receipt:
                begin
                    ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::"Positive Adjmt.");
                    ItemJnlLine.Validate("AltAWPPosted Document Type", ItemJnlLine."AltAWPPosted Document Type"::"Warehouse Receipt");

                    case WhseEntry."Source Document" of
                        WhseEntry."Source Document"::"P. Order":
                            if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, WhseEntry."Source No.") then begin
                                ItemJnlLine.Validate("Source Type", ItemJnlLine."Source Type"::Vendor);
                                ItemJnlLine.Validate("Source No.", PurchaseHeader."Buy-from Vendor No.");
                                ItemJnlLine.Validate("ecSource Description", PurchaseHeader."Buy-from Vendor Name");

                                GetCausalPalletEntryForItemJnlLine(Document::"Warehouse Receipt", SourceDocType::"Purchase Order", WhseEntry, ItemJnlLine);
                            end;

                        WhseEntry."Source Document"::"S. Return Order":
                            if SalesHeader.Get(PurchaseHeader."Document Type"::"Return Order", WhseEntry."Source No.") then begin
                                ItemJnlLine.Validate("Source Type", ItemJnlLine."Source Type"::Customer);
                                ItemJnlLine.Validate("Source No.", SalesHeader."Sell-to Customer No.");
                                ItemJnlLine.Validate("ecSource Description", SalesHeader."Sell-to Customer Name");

                                GetCausalPalletEntryForItemJnlLine(Document::"Warehouse Receipt", SourceDocType::"Sales Return Order", WhseEntry, ItemJnlLine);
                            end;

                        WhseEntry."Source Document"::"Inb. Transfer":
                            begin
                                ItemJnlLine.Validate("Source Type", ItemJnlLine."Source Type"::" ");
                                ItemJnlLine.Validate("Source No.", WhseEntry."Location Code");

                                if Location.Get(WhseEntry."Location Code") then begin
                                    Location.TestField("ecPallets Bin Code");
                                    ItemJnlLine.Validate("ecSource Description", Location.Name);
                                    BinCode := Location."ecPallets Bin Code";
                                end;

                                GetCausalPalletEntryForItemJnlLine(Document::"Warehouse Receipt", SourceDocType::"Transfer Order", WhseEntry, ItemJnlLine);
                            end;
                    end;
                end;
        end;

        ItemJnlLine.Validate("Document No.", WhseEntry."Whse. Document No.");
        ItemJnlLine.Validate("Location Code", WhseEntry."Location Code");

        if BinCode = '' then
            if Location.Get(WhseEntry."Location Code") then begin
                Location.TestField("ecPallets Bin Code");
                ItemJnlLine.Validate("Bin Code", Location."ecPallets Bin Code");
            end;

        Evaluate(ItemJnlLine.Quantity, Format(Quantity));
        ItemJnlLine.Validate(Quantity);

        ItemJnlLine.Validate("Reason Code", WhseEntry."AltAWPReason Code");
        ItemJnlLine.Validate("External Document No.", WhseEntry."AltAWPExternal Document No.");
        ItemJnlLine.Validate("ecSource Doc. No.", WhseEntry."Source No.");
        ItemJnlLine.Validate("AltAWPPosted Document No.", WhseEntry."Whse. Document No.");
        ItemJnlLine.Validate("AltAWPPosted Doc. Line No.", 0);

        if AwpLogUnitFormat.Get(ItemJnlLine."Item No.") then
            if AwpLogUnitFormat."ecCHEP Gtin" <> '' then
                ItemJnlLine.Validate("ecCHEP Gtin", AwpLogUnitFormat."ecCHEP Gtin");

        ItemJnlLine.Insert(true);

        BatchInserted := true;

        //#229Status
        SetInProgressStatusInWhseDoc(WhseEntry);
        //#229Status
    end;

    local procedure GetCausalPalletEntryForItemJnlLine(Document: Enum "ecPallets Document Type"; SourceDocType: Enum "ecPallet Source Doc. Type"; WhseEntry: Record "Warehouse Entry"; var ItemJnlLine: Record "Item Journal Line")
    var
        ecGeneralPalletSetup: Record "ecGeneral Pallet Setup";
        AwpLogUnitFormat: Record "AltAWPLogistic Unit Format";
    begin
        ecGeneralPalletSetup.Reset();
        ecGeneralPalletSetup.SetRange(Document, Document);
        ecGeneralPalletSetup.SetRange("Source Document Type", SourceDocType);
        ecGeneralPalletSetup.SetRange("BC Reason Code", WhseEntry."AltAWPReason Code");
        if not ecGeneralPalletSetup.IsEmpty() then
            if AwpLogUnitFormat.Get(ItemJnlLine."Item No.") then begin
                ecGeneralPalletSetup.SetRange("Pallet Grouping Code", AwpLogUnitFormat."ecPallet/Box Grouping Code");
                if ecGeneralPalletSetup.FindFirst() then
                    ItemJnlLine.Validate("ecCausal Pallet Entry", ecGeneralPalletSetup."Pallet Movement Reason");
            end;
    end;

    //#229Status
    local procedure SetInProgressStatusInWhseDoc(WhseEntry: Record "Warehouse Entry")
    var
        PostedWhseRecHeader: Record "Posted Whse. Receipt Header";
        PostedWhseShipHeader: Record "Posted Whse. Shipment Header";
    begin
        case WhseEntry."Whse. Document Type" of
            WhseEntry."Whse. Document Type"::Receipt:
                if PostedWhseRecHeader.Get(WhseEntry."Whse. Document No.") then
                    if (PostedWhseRecHeader."ecPallet Status Mgt." <> PostedWhseRecHeader."ecPallet Status Mgt."::Completed) and (PostedWhseRecHeader."ecPallet Status Mgt." <> PostedWhseRecHeader."ecPallet Status Mgt."::"Not required") then begin
                        PostedWhseRecHeader.Validate("ecPallet Status Mgt.", PostedWhseRecHeader."ecPallet Status Mgt."::"In progress");
                        PostedWhseRecHeader.Modify();
                    end;

            WhseEntry."Whse. Document Type"::Shipment:
                if PostedWhseShipHeader.Get(WhseEntry."Whse. Document No.") then
                    if (PostedWhseShipHeader."ecPallet Status Mgt." <> PostedWhseShipHeader."ecPallet Status Mgt."::Completed) and (PostedWhseShipHeader."ecPallet Status Mgt." <> PostedWhseShipHeader."ecPallet Status Mgt."::"Not required") then begin
                        PostedWhseShipHeader.Validate("ecPallet Status Mgt.", PostedWhseShipHeader."ecPallet Status Mgt."::"In progress");
                        PostedWhseShipHeader.Modify();
                    end;
        end;
    end;

    procedure SetRequiredStatusInWhseDoc(ItemJnlLine: Record "Item Journal Line")
    var
        LocalItemJournalLine: Record "Item Journal Line";
        PostedWhseRecHeader: Record "Posted Whse. Receipt Header";
        PostedWhseShipHeader: Record "Posted Whse. Shipment Header";
    begin
        case ItemJnlLine."Entry Type" of
            ItemJnlLine."Entry Type"::"Negative Adjmt.":
                begin
                    LocalItemJournalLine.Reset();
                    LocalItemJournalLine.SetRange("Journal Template Name", ItemJnlLine."Journal Template Name");
                    LocalItemJournalLine.SetRange("Journal Batch Name", ItemJnlLine."Journal Batch Name");
                    LocalItemJournalLine.SetRange("Document No.", ItemJnlLine."Document No.");
                    LocalItemJournalLine.SetRange("ecCausal Pallet Entry", ItemJnlLine."ecCausal Pallet Entry");
                    LocalItemJournalLine.SetFilter("Line No.", '<>%1', ItemJnlLine."Line No.");
                    if LocalItemJournalLine.IsEmpty then
                        if PostedWhseShipHeader.Get(ItemJnlLine."Document No.") then
                            if PostedWhseShipHeader."ecAllow Adjmt. In Ship/Receipt" then
                                if PostedWhseShipHeader."ecPallet Status Mgt." <> PostedWhseShipHeader."ecPallet Status Mgt."::Completed then begin
                                    PostedWhseShipHeader.Validate("ecPallet Status Mgt.", PostedWhseShipHeader."ecPallet Status Mgt."::Required);
                                    PostedWhseShipHeader.Modify();
                                end;
                end;

            ItemJnlLine."Entry Type"::"Positive Adjmt.":
                begin
                    LocalItemJournalLine.Reset();
                    LocalItemJournalLine.SetRange("Journal Template Name", ItemJnlLine."Journal Template Name");
                    LocalItemJournalLine.SetRange("Journal Batch Name", ItemJnlLine."Journal Batch Name");
                    LocalItemJournalLine.SetRange("Document No.", ItemJnlLine."Document No.");
                    LocalItemJournalLine.SetRange("ecCausal Pallet Entry", ItemJnlLine."ecCausal Pallet Entry");
                    LocalItemJournalLine.SetFilter("Line No.", '<>%1', ItemJnlLine."Line No.");
                    if LocalItemJournalLine.IsEmpty then
                        if PostedWhseRecHeader.Get(ItemJnlLine."Document No.") then
                            if PostedWhseRecHeader."ecAllow Adjmt. In Ship/Receipt" then
                                if PostedWhseRecHeader."ecPallet Status Mgt." <> PostedWhseRecHeader."ecPallet Status Mgt."::Completed then begin
                                    PostedWhseRecHeader.Validate("ecPallet Status Mgt.", PostedWhseRecHeader."ecPallet Status Mgt."::Required);
                                    PostedWhseRecHeader.Modify();
                                end;
                end;
        end;
    end;

    procedure SetCompletedStatusInWhseDoc(ItemJnlLine: Record "Item Journal Line"; var NewItemLedgerEntry: Record "Item Ledger Entry")
    var
        PostedWhseRecHeader: Record "Posted Whse. Receipt Header";
        PostedWhseShipHeader: Record "Posted Whse. Shipment Header";
    begin
        //#229Status
        case ItemJnlLine."Entry Type" of
            ItemJnlLine."Entry Type"::"Negative Adjmt.":
                if PostedWhseShipHeader.Get(ItemJnlLine."Document No.") then
                    if PostedWhseShipHeader."ecAllow Adjmt. In Ship/Receipt" then
                        if PostedWhseShipHeader."ecPallet Status Mgt." <> PostedWhseShipHeader."ecPallet Status Mgt."::"Not required" then begin
                            PostedWhseShipHeader.Validate("ecPallet Status Mgt.", PostedWhseShipHeader."ecPallet Status Mgt."::Completed);
                            PostedWhseShipHeader.Modify();
                        end;

            ItemJnlLine."Entry Type"::"Positive Adjmt.":
                if PostedWhseRecHeader.Get(ItemJnlLine."Document No.") then
                    if PostedWhseRecHeader."ecAllow Adjmt. In Ship/Receipt" then
                        if PostedWhseRecHeader."ecPallet Status Mgt." <> PostedWhseRecHeader."ecPallet Status Mgt."::"Not required" then begin
                            PostedWhseRecHeader.Validate("ecPallet Status Mgt.", PostedWhseRecHeader."ecPallet Status Mgt."::Completed);
                            PostedWhseRecHeader.Modify();
                        end;
        end;

        NewItemLedgerEntry.Validate("ecSource Description", ItemJnlLine."ecSource Description");
        NewItemLedgerEntry.Validate("ecSource Doc. No.", ItemJnlLine."ecSource Doc. No.");
        NewItemLedgerEntry.Validate("ecCausal Pallet Entry", ItemJnlLine."ecCausal Pallet Entry");
        //#229Status
    end;

    procedure ValidatecAllowAdjmtInShipReceipt(RecordVariant: Variant; var ToActive: Boolean)
    var
        AwpLogUnitFormat: Record "AltAWPLogistic Unit Format";
        PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header";
        PostedWhseReceiptLine: Record "Posted Whse. Receipt Line";
        PostedWhseShptHeader: Record "Posted Whse. Shipment Header";
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        ecGeneralPalletSetup: Record "ecGeneral Pallet Setup";
        RecRef: RecordRef;
        CheckSetup: Boolean;
    begin
        RecRef.GetTable(RecordVariant);

        CheckSetup := true;

        case RecRef.Number of
            DataBase::"Posted Whse. Receipt Header":
                begin
                    RecRef.SetTable(PostedWhseReceiptHeader);

                    PostedWhseReceiptLine.Reset();
                    PostedWhseReceiptLine.SetRange("No.", PostedWhseReceiptHeader."No.");
                    if PostedWhseReceiptLine.FindSet() then
                        repeat
                            AwpLogUnitFormat.Reset();
                            AwpLogUnitFormat.SetRange("Inventory Register Item No.", PostedWhseReceiptLine."Item No.");
                            if not AwpLogUnitFormat.IsEmpty() then
                                CheckSetup := false;
                        until (PostedWhseReceiptLine.Next() = 0) or (not CheckSetup);

                    if CheckSetup then begin
                        ecGeneralPalletSetup.Reset();
                        ecGeneralPalletSetup.SetLoadFields("Allow Adjmt. In Ship/Receipt");
                        ecGeneralPalletSetup.SetRange(Document, ecGeneralPalletSetup.Document::"Warehouse Receipt");
                        case PostedWhseReceiptHeader."AltAWPSource Document Type" of
                            PostedWhseReceiptHeader."AltAWPSource Document Type"::"Sales Return Order":
                                ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Sales Return Order");

                            PostedWhseReceiptHeader."AltAWPSource Document Type"::"Purchase Order":
                                ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Purchase Order");

                            PostedWhseReceiptHeader."AltAWPSource Document Type"::"Transfer Order":
                                ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Transfer Order");
                        end;
                        ecGeneralPalletSetup.SetRange("BC Reason Code", PostedWhseReceiptHeader."AltAWPReason Code");
                        if ecGeneralPalletSetup.FindFirst() then
                            if ecGeneralPalletSetup."Allow Adjmt. In Ship/Receipt" then
                                ToActive := true;
                    end;

                    PostedWhseReceiptHeader.Validate("ecAlready Checked", true);
                    PostedWhseReceiptHeader.Modify(true);
                end;

            Database::"Posted Whse. Shipment Header":
                begin
                    RecRef.SetTable(PostedWhseShptHeader);

                    PostedWhseShptLine.Reset();
                    PostedWhseShptLine.SetRange("No.", PostedWhseReceiptHeader."No.");
                    if PostedWhseShptLine.FindSet() then
                        repeat
                            AwpLogUnitFormat.Reset();
                            AwpLogUnitFormat.SetRange("Inventory Register Item No.", PostedWhseShptLine."Item No.");
                            if not AwpLogUnitFormat.IsEmpty() then
                                CheckSetup := false;
                        until (PostedWhseShptLine.Next() = 0) or (not CheckSetup);

                    if CheckSetup then begin
                        ecGeneralPalletSetup.Reset();
                        ecGeneralPalletSetup.SetLoadFields("Allow Adjmt. In Ship/Receipt");
                        ecGeneralPalletSetup.SetRange(Document, ecGeneralPalletSetup.Document::"Warehouse Shipment");
                        case PostedWhseShptHeader."AltAWPSource Document Type" of
                            PostedWhseShptHeader."AltAWPSource Document Type"::"Purch. Return Order":
                                ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Purchase Return Order");

                            PostedWhseShptHeader."AltAWPSource Document Type"::"Sales Order":
                                ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Sales Order");

                            PostedWhseShptHeader."AltAWPSource Document Type"::"Transfer Order":
                                ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Transfer Order");
                        end;
                        ecGeneralPalletSetup.SetRange("BC Reason Code", PostedWhseShptHeader."AltAWPReason Code");
                        if ecGeneralPalletSetup.FindFirst() then
                            if ecGeneralPalletSetup."Allow Adjmt. In Ship/Receipt" then
                                ToActive := true;
                    end;

                    PostedWhseShptHeader.Validate("ecAlready Checked", true);
                    PostedWhseShptHeader.Modify(true);
                end;
        end;
    end;
    //#229Status

    procedure CheckAllowAdjmtInShipReceipt(RecordVariant: Variant; var Active: Boolean)
    var
        PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header";
        PostedWhseShptHeader: Record "Posted Whse. Shipment Header";
        ecGeneralPalletSetup: Record "ecGeneral Pallet Setup";
        RecRef: RecordRef;
        DocNotMgtWithPallets: Label 'Document not subject to pallet movement!';
    begin
        RecRef.GetTable(RecordVariant);

        case RecRef.Number of
            DataBase::"Posted Whse. Receipt Header":
                begin
                    RecRef.SetTable(PostedWhseReceiptHeader);
                    ecGeneralPalletSetup.Reset();
                    ecGeneralPalletSetup.SetLoadFields("Allow Adjmt. In Ship/Receipt");
                    ecGeneralPalletSetup.SetRange(Document, ecGeneralPalletSetup.Document::"Warehouse Receipt");
                    case PostedWhseReceiptHeader."AltAWPSource Document Type" of
                        PostedWhseReceiptHeader."AltAWPSource Document Type"::"Sales Return Order":
                            ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Sales Return Order");

                        PostedWhseReceiptHeader."AltAWPSource Document Type"::"Purchase Order":
                            ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Purchase Order");

                        PostedWhseReceiptHeader."AltAWPSource Document Type"::"Transfer Order":
                            ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Transfer Order");
                    end;
                    ecGeneralPalletSetup.SetRange("BC Reason Code", PostedWhseReceiptHeader."AltAWPReason Code");
                    if ecGeneralPalletSetup.FindFirst() then begin
                        if not (ecGeneralPalletSetup."Allow Adjmt. In Ship/Receipt") then
                            Error(DocNotMgtWithPallets)
                        else
                            Active := true;
                    end;
                end;

            Database::"Posted Whse. Shipment Header":
                begin
                    RecRef.SetTable(PostedWhseShptHeader);
                    ecGeneralPalletSetup.Reset();
                    ecGeneralPalletSetup.SetLoadFields("Allow Adjmt. In Ship/Receipt");
                    ecGeneralPalletSetup.SetRange(Document, ecGeneralPalletSetup.Document::"Warehouse Shipment");
                    case PostedWhseShptHeader."AltAWPSource Document Type" of
                        PostedWhseShptHeader."AltAWPSource Document Type"::"Purch. Return Order":
                            ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Purchase Return Order");

                        PostedWhseShptHeader."AltAWPSource Document Type"::"Sales Order":
                            ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Sales Order");

                        PostedWhseShptHeader."AltAWPSource Document Type"::"Transfer Order":
                            ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Transfer Order");
                    end;
                    ecGeneralPalletSetup.SetRange("BC Reason Code", PostedWhseShptHeader."AltAWPReason Code");
                    if ecGeneralPalletSetup.FindFirst() then begin
                        if not (ecGeneralPalletSetup."Allow Adjmt. In Ship/Receipt") then
                            Error(DocNotMgtWithPallets)
                        else
                            Active := true;
                    end;
                end;
        end;
    end;

    procedure ValidatePalletsLinkedFields(var NewItemLedgEntry: Record "Item Ledger Entry")
    var
        WhseEntry: Record "Warehouse Entry";
    begin
        WhseEntry.Reset();
        WhseEntry.SetRange("Whse. Document No.", NewItemLedgEntry."AltAWPPosted Document No.");
        WhseEntry.SetRange("Whse. Document Line No.", NewItemLedgEntry."AltAWPPosted Doc. Line No.");
        if not WhseEntry.IsEmpty() then
            if WhseEntry.FindFirst() then
                GetValues(NewItemLedgEntry, WhseEntry);
    end;

    local procedure GetValues(var NewItemLedgEntry: Record "Item Ledger Entry"; WhseEntry: Record "Warehouse Entry")
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        Location: Record Location;
        Document: Enum "ecPallets Document Type";
        SourceDocType: Enum "ecPallet Source Doc. Type";
    begin
        NewItemLedgEntry.Validate("ecSource Doc. No.", WhseEntry."Source No.");

        case WhseEntry."Whse. Document Type" of
            WhseEntry."Whse. Document Type"::Receipt:
                case WhseEntry."Source Document" of
                    WhseEntry."Source Document"::"P. Order":
                        begin
                            if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, WhseEntry."Source No.") then
                                NewItemLedgEntry.Validate("ecSource Description", PurchaseHeader."Buy-from Vendor Name");

                            ValidateCausalPalletEntry(Document::"Warehouse Receipt", SourceDocType::"Purchase Order", WhseEntry, NewItemLedgEntry);
                        end;
                    WhseEntry."Source Document"::"S. Return Order":
                        begin
                            if SalesHeader.Get(SalesHeader."Document Type"::"Return Order", WhseEntry."Source No.") then
                                NewItemLedgEntry.Validate("ecSource Description", SalesHeader."Sell-to Customer No.");

                            ValidateCausalPalletEntry(Document::"Warehouse Receipt", SourceDocType::"Sales Return Order", WhseEntry, NewItemLedgEntry);
                        end;
                    WhseEntry."Source Document"::"Inb. Transfer":
                        begin
                            if Location.Get(WhseEntry."Location Code") then
                                NewItemLedgEntry.Validate("ecSource Description", Location.Name);

                            ValidateCausalPalletEntry(Document::"Warehouse Receipt", SourceDocType::"Transfer Order", WhseEntry, NewItemLedgEntry);
                        end;
                end;
            WhseEntry."Whse. Document Type"::Shipment:
                begin
                    case WhseEntry."Source Document" of
                        WhseEntry."Source Document"::"S. Order":
                            begin
                                if SalesHeader.Get(SalesHeader."Document Type"::Order, WhseEntry."Source No.") then
                                    NewItemLedgEntry.Validate("ecSource Description", SalesHeader."Sell-to Customer Name");

                                ValidateCausalPalletEntry(Document::"Warehouse Shipment", SourceDocType::"Sales Order", WhseEntry, NewItemLedgEntry);
                            end;
                        WhseEntry."Source Document"::"P. Return Order":
                            begin
                                if PurchaseHeader.Get(PurchaseHeader."Document Type"::"Return Order", WhseEntry."Source No.") then
                                    NewItemLedgEntry.Validate("ecSource Description", PurchaseHeader."Buy-from Vendor No.");

                                ValidateCausalPalletEntry(Document::"Warehouse Shipment", SourceDocType::"Purchase Return Order", WhseEntry, NewItemLedgEntry);
                            end;
                        WhseEntry."Source Document"::"Outb. Transfer":
                            begin
                                if Location.Get(WhseEntry."Location Code") then
                                    NewItemLedgEntry.Validate("ecSource Description", Location.Name);

                                ValidateCausalPalletEntry(Document::"Warehouse Shipment", SourceDocType::"Transfer Order", WhseEntry, NewItemLedgEntry);
                            end;
                    end;
                end;
        end;
        NewItemLedgEntry.Modify();
    end;

    local procedure ValidateCausalPalletEntry(Document: Enum "ecPallets Document Type"; SourceDocType: Enum "ecPallet Source Doc. Type"; WhseEntry: Record "Warehouse Entry"; var NewItemLedgEntry: Record "Item Ledger Entry")
    var
        ecGeneralPalletSetup: Record "ecGeneral Pallet Setup";
        AwpLogUnitFormat: Record "AltAWPLogistic Unit Format";
    begin
        ecGeneralPalletSetup.Reset();
        ecGeneralPalletSetup.SetRange(Document, Document);
        ecGeneralPalletSetup.SetRange("Source Document Type", SourceDocType);
        ecGeneralPalletSetup.SetRange("BC Reason Code", WhseEntry."AltAWPReason Code");
        ecGeneralPalletSetup.SetRange("Allow Adjmt. In Ship/Receipt", true);
        if not ecGeneralPalletSetup.IsEmpty() then
            if AwpLogUnitFormat.Get(NewItemLedgEntry."Item No.") then begin
                ecGeneralPalletSetup.SetRange("Pallet Grouping Code", AwpLogUnitFormat."ecPallet/Box Grouping Code");
                if ecGeneralPalletSetup.FindFirst() then
                    NewItemLedgEntry.Validate("ecCausal Pallet Entry", ecGeneralPalletSetup."Pallet Movement Reason");
            end else begin
                if WhseEntry."ecBox Grouping Code" <> '' then
                    ecGeneralPalletSetup.SetRange("Pallet Grouping Code", WhseEntry."ecBox Grouping Code");
                if WhseEntry."ecPallet Grouping Code" <> '' then
                    ecGeneralPalletSetup.SetRange("Pallet Grouping Code", WhseEntry."ecPallet Grouping Code");

                if (WhseEntry."ecBox Grouping Code" <> '') or (WhseEntry."ecPallet Grouping Code" <> '') then
                    if ecGeneralPalletSetup.FindFirst() then
                        NewItemLedgEntry.Validate("ecCausal Pallet Entry", ecGeneralPalletSetup."Pallet Movement Reason");
            end;
    end;

    procedure GetDefaultPalletBinCode(var WarehouseReceiptLine: Record "Warehouse Receipt Line")
    var
        AwpLogUnitFormat: Record "AltAWPLogistic Unit Format";
        ecGeneralPalletSetup: Record "ecGeneral Pallet Setup";
        Location: Record Location;
    begin
        AwpLogUnitFormat.Reset();
        AwpLogUnitFormat.SetRange("Inventory Register Item No.", WarehouseReceiptLine."Item No.");
        AwpLogUnitFormat.SetRange("Enable Inventory Register", true);
        if not AwpLogUnitFormat.IsEmpty() then begin
            ecGeneralPalletSetup.Reset();
            ecGeneralPalletSetup.SetRange(Document, ecGeneralPalletSetup.Document::"Warehouse Receipt");

            case WarehouseReceiptLine."Source Type" of
                36:
                    ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Sales Return Order");
                39:
                    ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Purchase Order");
                5740:
                    ecGeneralPalletSetup.SetRange("Source Document Type", ecGeneralPalletSetup."Source Document Type"::"Transfer Order");
            end;

            ecGeneralPalletSetup.SetRange("Allow Adjmt. In Ship/Receipt", false);
            if not ecGeneralPalletSetup.IsEmpty() then
                if Location.Get(WarehouseReceiptLine."Location Code") then
                    WarehouseReceiptLine.Validate("Bin Code", Location."ecPallets Bin Code");
        end;
    end;

    #region CPR
    procedure WriteCPRHeaderData(var OutStr: OutStream; LastProgressivNo: Text; CounterPartCode: Text; TxtType: Integer; CRLF: Text[2]; var OnlyOneTime: Boolean)
    var
        WorkDateText: Text;
    begin
        OutStr.WriteText('T;');
        OutStr.WriteText(LastProgressivNo + ';');
        OutStr.WriteText(CounterPartCode + ';');

        WorkDateText := Format(WorkDate(), 0, '<Day,2>/<Month,2>/<Year4>');
        OutStr.WriteText(WorkDateText + ';;');

        case TxtType of
            0:
                OutStr.WriteText('N' + ';');
            1:
                OutStr.WriteText('S' + ';');
            2:
                OutStr.WriteText('C' + ';');
        end;

        OutStr.WriteText('04' + CRLF);

        OnlyOneTime := true;
    end;

    procedure WriteCPRBodyData(var OutStr: OutStream; ItemLedgerEntry: Record "Item Ledger Entry"; CRLF: Text[2]; TxtType: Integer): Boolean
    var
        Customer: Record Customer;
        LogUnitFormat: Record "AltAWPLogistic Unit Format";
        PostingDate: Text;
        VarQuantity, VarQuantityWithoutZero, VarEntryNo, VarEntryNoWithoutZero : Text;
        VarQuantityCounted, VarQuantityLenght, VarEntryNoCounted, VarEntryNoLenght : Integer;
        CustomerNotFoundLbl: Label 'Customer with %1 member code not founded';
        FormatUnitLogNotFounded: Label 'Format unit log. with code %1 not founded';
    begin
        OutStr.WriteText('D;');
        ItemLedgerEntry.CalcFields(ItemLedgerEntry."ecMember's CPR Code");
        OutStr.WriteText(ItemLedgerEntry."ecMember's CPR Code" + ';');
        ItemLedgerEntry.CalcFields("ecUnit Logistcs Code");
        OutStr.WriteText(ItemLedgerEntry."ecUnit Logistcs Code" + ';');

        PostingDate := Format(ItemLedgerEntry."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
        OutStr.WriteText(PostingDate + ';');

        //gestione Numero colli consegnati con 9 caratteri
        VarQuantity := '000000000';
        VarQuantityWithoutZero := DelChr(Format(Abs(ItemLedgerEntry.Quantity)), '=', '0');
        VarQuantityCounted := StrLen(VarQuantityWithoutZero);
        VarQuantityLenght := StrLen(VarQuantity);
        VarQuantity := DelStr(VarQuantity, VarQuantityLenght - VarQuantityCounted + 1, VarQuantityCounted);
        VarQuantity += VarQuantityWithoutZero;
        OutStr.WriteText(VarQuantity + ';');
        //gestione Numero colli consegnati con 9 caratteri

        OutStr.WriteText('000000000' + ';'); //Numero colli ricevuti
        OutStr.WriteText(ItemLedgerEntry."Document No." + ';');

        OutStr.WriteText(PostingDate + ';');

        //gestione Entry No con 35 caratteri
        VarEntryNo := '00000000000000000000000000000000000';
        VarEntryNoWithoutZero := DelChr(Format(ItemLedgerEntry."Entry No."), '=', '0');
        VarEntryNoCounted := StrLen(VarEntryNoWithoutZero);
        VarEntryNoLenght := StrLen(VarEntryNo);
        VarEntryNo := DelStr(VarEntryNo, VarEntryNoLenght - VarEntryNoCounted + 1, VarEntryNoCounted);
        VarEntryNo += VarEntryNoWithoutZero;
        OutStr.WriteText(VarEntryNo + ';');
        //gestione Entry No con 35 caratteri

        OutStr.WriteText(ItemLedgerEntry."ecCausal Pallet Entry" + ';');

        case TxtType of
            0:
                OutStr.WriteText('N' + ';');
            1:
                OutStr.WriteText('S' + ';');
            2:
                OutStr.WriteText('C' + ';');
        end;

        OutStr.WriteText(ItemLedgerEntry."ecSource Description" + ';');

        Customer.Reset();
        Customer.SetRange("ecMember's CPR Code", ItemLedgerEntry."ecMember's CPR Code");
        if Customer.FindFirst() then begin
            OutStr.WriteText(Customer.Address + ' ' + Customer.City + ';')
        end else
            OutStr.WriteText(StrSubstNo(CustomerNotFoundLbl, ItemLedgerEntry."ecMember's CPR Code") + ';');

        if LogUnitFormat.Get(ItemLedgerEntry."ecUnit Logistcs Code") then
            OutStr.WriteText(LogUnitFormat.Description + ';')
        else
            OutStr.WriteText(StrSubstNo(FormatUnitLogNotFounded, ItemLedgerEntry."ecUnit Logistcs Code") + ';');

        OutStr.WriteText(' ' + CRLF);

        exit(true);
    end;

    procedure WriteCPRFooterData(var OutStr: OutStream)
    begin
        OutStr.WriteText('F' + ';;')
    end;

    procedure InsertCPRExtractedTXTRecord(LastProgressiveNo: Text; FileName: Text)
    var
        CPRExtractedTXT: Record "ecCPR Extracted TXT";
    begin
        CPRExtractedTXT.Init();
        CPRExtractedTXT.Validate("Progressive No.", LastProgressiveNo);
        CPRExtractedTXT.Validate("TXT File Name", FileName);
        CPRExtractedTXT.Insert();
    end;
    #endregion
}