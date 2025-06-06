namespace EuroCompany.BaseApp.Inventory.Ledger;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.Company;
using System.Text;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Ledger;
using Microsoft.Finance.GeneralLedger.Account;
using System.Utilities;
using EuroCompany.BaseApp.Inventory.Item;

report 50030 "ecBIO Raw Material Extraction"
{
    Caption = 'BIO Raw Material Extraction';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/EuroCompany/BaseApp/Inventory/Ledger/BIORawMaterialExtract.Layout.rdl';

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Posting Date", "Item No.", "Lot No.") where("Entry Type" = filter(Purchase | Consumption | Sale));

            trigger OnPreDataItem()
            begin
                TempItemLedgerEntry.Reset();
                TempItemLedgerEntry.DeleteAll();

                SetFilter("Item No.", ItemNo);

                if LotNo <> '' then
                    SetFilter("Lot No.", LotNo);

                SetFilter("Posting Date", PostingDateFilter);

                CompInfo.Get();
            end;

            trigger OnAfterGetRecord()
            var
                Item: Record Item;
            begin
                Clear(BioCertified);
                Clear(IsBold);

                CalcFields("ecMass Balance Mgt. BIO");

                if "ecMass Balance Mgt. BIO" then begin
                    if Item.Get("Item No.") then
                        if Item."ecItem Type" <> Item."ecItem Type"::"Raw Material" then
                            CurrReport.Skip();

                    InsertTempLedgerEntryGlobal();
                end else
                    CurrReport.Skip();
            end;

            trigger OnPostDataItem()
            var
                ItemLedgEntry, EndOfMonthItemLedgerEntry : Record "Item Ledger Entry";
                Counting, CountingIntervalDate : Integer;
            begin
                TempItemLedgerEntryToCycle.Copy(TempItemLedgerEntryGlobal, true);
                TempItemLedgerEntryToCycle.Reset();
                TempItemLedgerEntryToCycle.SetCurrentKey("Item No.", "Lot No.");
                if TempItemLedgerEntryToCycle.FindSet() then
                    repeat
                        if (DifferentLotNo <> TempItemLedgerEntryToCycle."Lot No.") or (DifferentItemNo <> TempItemLedgerEntryToCycle."Item No.") then begin
                            DifferentLotNo := TempItemLedgerEntryToCycle."Lot No.";
                            DifferentItemNo := TempItemLedgerEntryToCycle."Item No.";

                            if not ExistPurchaseEntry() then
                                InsertBalanceLineAfterPurchaseEntryCheck();

                            ItemLedgEntry.Reset();
                            ItemLedgEntry.SetCurrentKey("Posting Date", "Item No.", "Lot No.");
                            ItemLedgEntry.SetRange("Item No.", DifferentItemNo);
                            ItemLedgEntry.SetRange("Lot No.", DifferentLotNo);
                            ItemLedgEntry.SetFilter("Posting Date", PostingDateFilter);
                            ItemLedgEntry.SetFilter("Entry Type", '%1|%2|%3', ItemLedgEntry."Entry Type"::Purchase, ItemLedgEntry."Entry Type"::Consumption, ItemLedgEntry."Entry Type"::Sale);
                            if ItemLedgEntry.FindSet() then
                                repeat
                                    InsertTempLedgerEntry(ItemLedgEntry);

                                    if ItemLedgEntry."Posting Date" = CalcDate('<CM>', ItemLedgEntry."Posting Date") then begin
                                        CountingIntervalDate := 0;
                                        if Counting = 0 then begin
                                            EndOfMonthItemLedgerEntry.Reset();
                                            EndOfMonthItemLedgerEntry.SetRange("Item No.", DifferentItemNo);
                                            EndOfMonthItemLedgerEntry.SetRange("Lot No.", DifferentLotNo);
                                            EndOfMonthItemLedgerEntry.SetFilter("Entry Type", '%1|%2|%3', EndOfMonthItemLedgerEntry."Entry Type"::Purchase, EndOfMonthItemLedgerEntry."Entry Type"::Consumption, EndOfMonthItemLedgerEntry."Entry Type"::Sale);
                                            EndOfMonthItemLedgerEntry.SetRange("Posting Date", CalcDate('<CM>', ItemLedgEntry."Posting Date"));
                                            Counting := EndOfMonthItemLedgerEntry.Count();
                                        end;

                                        Counting -= 1;

                                        if Counting = 0 then
                                            InsertBalanceLine(CalcDate('<CM>', ItemLedgEntry."Posting Date"));
                                    end else begin
                                        Counting := 0;
                                        if CountingIntervalDate = 0 then begin
                                            EndOfMonthItemLedgerEntry.Reset();
                                            EndOfMonthItemLedgerEntry.SetRange("Item No.", DifferentItemNo);
                                            EndOfMonthItemLedgerEntry.SetRange("Lot No.", DifferentLotNo);
                                            EndOfMonthItemLedgerEntry.SetFilter("Entry Type", '%1|%2|%3', EndOfMonthItemLedgerEntry."Entry Type"::Purchase, EndOfMonthItemLedgerEntry."Entry Type"::Consumption, EndOfMonthItemLedgerEntry."Entry Type"::Sale);
                                            EndOfMonthItemLedgerEntry.SetFilter("Posting Date", '%1..%2', ItemLedgEntry."Posting Date", CalcDate('<CM>', ItemLedgEntry."Posting Date"));
                                            CountingIntervalDate := EndOfMonthItemLedgerEntry.Count();
                                        end;

                                        CountingIntervalDate -= 1;

                                        if CountingIntervalDate = 0 then
                                            InsertBalanceLine(CalcDate('<CM>', ItemLedgEntry."Posting Date"));
                                    end;
                                until ItemLedgEntry.Next() = 0;
                        end;
                    until TempItemLedgerEntryToCycle.Next() = 0;
            end;
        }
        dataitem(Integer;
        Integer)
        {
            column(Posting_Date_Lbl;
            TempItemLedgerEntry.FieldCaption("Posting Date"))
            {
            }
            column(Entry_Type_Lbl; TempItemLedgerEntry.FieldCaption("Entry Type"))
            {
            }
            column(Document_Type_Lbl; TempItemLedgerEntry.FieldCaption("Document Type"))
            {
            }
            column(Item_No_Lbl; TempItemLedgerEntry.FieldCaption("Item No."))
            {
            }
            column(Description_Lbl; TempItemLedgerEntry.FieldCaption(Description))
            {
            }
            column(Lot_No_Lbl; TempItemLedgerEntry.FieldCaption("Lot No."))
            {
            }
            column(QuantityKGLbl; QuantityKGLbl)
            {
            }
            column(BioCertifiedLbl; BioCertifiedLbl)
            {
            }
            column(AltAWPReason_Code_Lbl; TempItemLedgerEntry.FieldCaption("AltAWPReason Code"))
            {
            }
            column(Document_No_Lbl; TempItemLedgerEntry.FieldCaption("Document No."))
            {
            }
            column(Remaining_Quantity_Lbl; TempItemLedgerEntry.FieldCaption("Remaining Quantity"))
            {
            }
            column(QuantityInStockLbl; QuantityInStockLbl)
            {
            }
            column(TitleLbl; TitleLbl)
            {
            }
            column(CompInfoName; CompInfo.Name)
            {
            }
            column(WorkDate; WorkDate())
            {
            }
            column(Posting_Date; TempItemLedgerEntry."Posting Date")
            {
            }
            column(Entry_Type; Format(TempItemLedgerEntry."Entry Type", 0))
            {
            }
            column(Document_Type; Format(TempItemLedgerEntry."Document Type", 0))
            {
            }
            column(Item_No; TempItemLedgerEntry."Item No.")
            {
            }
            column(Description; TempItemLedgerEntry.Description)
            {
            }
            column(Lot_No; TempItemLedgerEntry."Lot No.")
            {
            }
            column(Quantity; TempItemLedgerEntry.Quantity)
            {
            }
            column(BioCertified; BioCertified)
            {
            }
            column(AltAWPReason_Code; TempItemLedgerEntry."AltAWPReason Code")
            {
            }
            column(Document_No_; TempItemLedgerEntry."Document No.")
            {
            }
            column(Remaining_Quantity; TempItemLedgerEntry."Remaining Quantity")
            {
            }
            column(QuantityInStock; QuantityInStock)
            {
            }
            column(IsBold; IsBold)
            {
            }
            trigger OnPreDataItem()
            begin
                TempItemLedgerEntry.Reset();
                SetRange(Number, 1, TempItemLedgerEntry.Count());
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    TempItemLedgerEntry.FindSet()
                else
                    TempItemLedgerEntry.Next();

                Clear(BioCertified);
                Clear(IsBold);

                if (TempItemLedgerEntry."Entry Type" = TempItemLedgerEntry."Entry Type"::Purchase) or (TempItemLedgerEntry."Document No." = BalanceLbl) or (TempItemLedgerEntry."Document No." = BalanceLotNotPurchasedInPeriodLbl) then begin
                    IsBold := true;

                    if (TempItemLedgerEntry."Entry Type" = TempItemLedgerEntry."Entry Type"::Purchase) or (TempItemLedgerEntry."Document No." = BalanceLotNotPurchasedInPeriodLbl) then
                        QuantityInStock := 0;
                end;

                if LotNoInfoGlobal.Get(TempItemLedgerEntry."Item No.", TempItemLedgerEntry."Variant Code", TempItemLedgerEntry."Lot No.") then
                    BioCertified := LotNoInfoGlobal."ecVendor Lot No.";

                QuantityInStock += TempItemLedgerEntry.Quantity;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    Caption = 'Options';

                    field(ItemNoVar; ItemNo)
                    {
                        Caption = 'Item No.';
                        ApplicationArea = All;
                        ShowMandatory = true;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            Item: Record Item;
                            ItemList: Page "Item List";
                        begin
                            Item.Reset();
                            Item.SetRange("ecItem Trk. Summary Mgt.", true);
                            Item.SetRange("ecItem Type", Item."ecItem Type"::"Raw Material");
                            ItemList.SetTableView(Item);
                            ItemList.SetRecord(Item);
                            ItemList.LookupMode(true);
                            if ItemList.RunModal() = Action::LookupOK then begin
                                ItemList.GetRecord(Item);
                                ItemNo := Item."No.";
                            end;
                        end;
                    }
                    field(LotNoVar; LotNo)
                    {
                        Caption = 'Lot No.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            LotNoInfo: Record "Lot No. Information";
                            SelectionFilterManagementCU: Codeunit SelectionFilterManagement;
                            LotNoInfoList: Page "Lot No. Information List";
                            ChooseFirstItemErr: Label 'The lot filter is enabled only if there is a reference item, filter by item first!';
                        begin
                            if ItemNo = '' then
                                Error(ChooseFirstItemErr);

                            LotNoInfo.Reset();
                            LotNoInfo.SetFilter("Item No.", ItemNo);
                            LotNoInfoList.SetTableView(LotNoInfo);
                            LotNoInfoList.LookupMode(true);
                            if LotNoInfoList.RunModal() = Action::LookupOK then begin
                                LotNoInfoList.SetSelectionFilter(LotNoInfo);
                                Text := SelectionFilterManagementCU.GetSelectionFilterForLotNoInformation(LotNoInfo);
                                exit(true);
                            end;
                        end;
                    }
                    field(DocDate; PostingDateFilter)
                    {
                        Caption = 'Posting Date';
                        ApplicationArea = All;
                        ToolTip = 'Indicate a period..';
                        ShowMandatory = true;

                        trigger OnValidate()
                        var
                            GlAccount: Record "G/L Account";
                        begin
                            GlAccount.SetFilter("Date Filter", PostingDateFilter);
                            PostingDateFilter := GlAccount.GetFilter("Date Filter");
                        end;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    var
        ItemNoAndPostingDateMantatoryErr: Label 'Item no. and Posting date filters must have a value!';
    begin
        if (ItemNo = '') or (PostingDateFilter = '') then
            Error(ItemNoAndPostingDateMantatoryErr);
    end;

    local procedure ExistPurchaseEntry(): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.Reset();
        ItemLedgEntry.SetCurrentKey("Posting Date", "Item No.", "Lot No.");
        ItemLedgEntry.SetRange("Item No.", DifferentItemNo);
        ItemLedgEntry.SetRange("Lot No.", DifferentLotNo);
        ItemLedgEntry.SetFilter("Posting Date", PostingDateFilter);
        ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::Purchase);
        exit(not ItemLedgEntry.IsEmpty());
    end;

    local procedure InsertBalanceLineAfterPurchaseEntryCheck()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        FirstDate: Date;
    begin
        FirstDate := GetFirstDateFromFilter(PostingDateFilter);

        ItemLedgEntry.Reset();
        ItemLedgEntry.SetCurrentKey("Posting Date", "Item No.", "Lot No.");
        ItemLedgEntry.SetRange("Item No.", DifferentItemNo);
        ItemLedgEntry.SetRange("Lot No.", DifferentLotNo);
        ItemLedgEntry.SetFilter("Posting Date", '..%1', FirstDate);
        ItemLedgEntry.CalcSums(Quantity);

        TempItemLedgerEntry.Init();
        TempItemLedgerEntry."Posting Date" := FirstDate;

        if EntryNo = 0 then begin
            TempItemLedgerEntry.Reset();
            if TempItemLedgerEntry.FindLast() then
                EntryNo := TempItemLedgerEntry."Entry No." + 1
            else
                EntryNo := 1;
        end else
            EntryNo := EntryNo + 1;

        TempItemLedgerEntry."Entry No." := EntryNo;
        TempItemLedgerEntry."Entry Type" := TempItemLedgerEntry."Entry Type"::" ";
        TempItemLedgerEntry."Document No." := BalanceLotNotPurchasedInPeriodLbl;
        TempItemLedgerEntry.Quantity := ItemLedgEntry.Quantity;
        TempItemLedgerEntry."Remaining Quantity" := 0;
        TempItemLedgerEntry.Insert();
        BioCertified := '';
    end;

    local procedure GetFirstDateFromFilter(FilterText: Text): Date
    var
        DateText: Text;
        FirstDate: Date;
    begin
        if StrPos(FilterText, '..') > 0 then begin
            DateText := CopyStr(FilterText, 1, StrPos(FilterText, '..') - 1);
        end else
            if StrPos(FilterText, '|') > 0 then begin
                DateText := CopyStr(FilterText, 1, StrPos(FilterText, '|') - 1);
            end else
                DateText := FilterText;

        if DateText <> '' then
            Evaluate(FirstDate, DateText);

        exit(FirstDate);
    end;

    local procedure InsertTempLedgerEntryGlobal()
    begin
        TempItemLedgerEntryGlobal.Init();
        TempItemLedgerEntryGlobal."Entry Type" := "Item Ledger Entry"."Entry Type";
        TempItemLedgerEntryGlobal."Posting Date" := "Item Ledger Entry"."Posting Date";
        TempItemLedgerEntryGlobal."Document Type" := "Item Ledger Entry"."Document Type";
        TempItemLedgerEntryGlobal."Document No." := "Item Ledger Entry"."Document No.";
        TempItemLedgerEntryGlobal."Item No." := "Item Ledger Entry"."Item No.";
        TempItemLedgerEntryGlobal."Lot No." := "Item Ledger Entry"."Lot No.";
        TempItemLedgerEntryGlobal.Description := "Item Ledger Entry".Description;
        TempItemLedgerEntryGlobal.Quantity := "Item Ledger Entry".Quantity;
        TempItemLedgerEntryGlobal."AltAWPReason Code" := "Item Ledger Entry"."AltAWPReason Code";
        TempItemLedgerEntryGlobal."Remaining Quantity" := "Item Ledger Entry"."Remaining Quantity";

        if EntryNo = 0 then begin
            if TempItemLedgerEntryGlobal.FindLast() then
                EntryNo := TempItemLedgerEntryGlobal."Entry No." + 1
            else
                EntryNo := 1;
        end else
            EntryNo := EntryNo + 1;

        TempItemLedgerEntryGlobal."Entry No." := EntryNo;
        TempItemLedgerEntryGlobal.Insert();
    end;

    local procedure InsertTempLedgerEntry(ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        TempItemLedgerEntry.Init();
        TempItemLedgerEntry."Entry Type" := ItemLedgerEntry."Entry Type";
        TempItemLedgerEntry."Posting Date" := ItemLedgerEntry."Posting Date";
        TempItemLedgerEntry."Document Type" := ItemLedgerEntry."Document Type";
        TempItemLedgerEntry."Document No." := ItemLedgerEntry."Document No.";
        TempItemLedgerEntry."Item No." := ItemLedgerEntry."Item No.";
        TempItemLedgerEntry."Lot No." := ItemLedgerEntry."Lot No.";
        TempItemLedgerEntry.Description := ItemLedgerEntry.Description;
        TempItemLedgerEntry.Quantity := ItemLedgerEntry.Quantity;
        TempItemLedgerEntry."AltAWPReason Code" := ItemLedgerEntry."AltAWPReason Code";
        TempItemLedgerEntry."Remaining Quantity" := ItemLedgerEntry."Remaining Quantity";

        if EntryNo = 0 then begin
            if TempItemLedgerEntry.FindLast() then
                EntryNo := TempItemLedgerEntry."Entry No." + 1
            else
                EntryNo := 1;
        end else
            EntryNo := EntryNo + 1;

        TempItemLedgerEntry."Entry No." := EntryNo;
        TempItemLedgerEntry.Insert();
    end;

    local procedure InsertBalanceLine(PostingDate: Date)
    begin
        TempItemLedgerEntry.Init();
        TempItemLedgerEntry."Posting Date" := PostingDate;

        if EntryNo = 0 then begin
            TempItemLedgerEntry.Reset();
            if TempItemLedgerEntry.FindLast() then
                EntryNo := TempItemLedgerEntry."Entry No." + 1
            else
                EntryNo := 1;
        end else
            EntryNo := EntryNo + 1;

        TempItemLedgerEntry."Entry No." := EntryNo;
        TempItemLedgerEntry."Entry Type" := TempItemLedgerEntry."Entry Type"::" ";
        TempItemLedgerEntry."Document No." := BalanceLbl;
        TempItemLedgerEntry."Remaining Quantity" := 0;
        TempItemLedgerEntry.Insert();
        BioCertified := '';
    end;

    var
        LotNoInfoGlobal: Record "Lot No. Information";
        CompInfo: Record "Company Information";
        TempItemLedgerEntry, TempItemLedgerEntryGlobal, TempItemLedgerEntryToCycle : Record "Item Ledger Entry" temporary;
        ItemNo: Code[20];
        DifferentLotNo: Code[50];
        DifferentItemNo: Code[20];
        LotNo, BioCertified : Code[50];
        IsBold: Boolean;
        QuantityInStock: Decimal;
        PostingDateFilter: Text;
        EntryNo: Integer;
        QuantityKGLbl: Label 'Quantity KG';
        BioCertifiedLbl: Label 'BIO Certified Label';
        QuantityInStockLbl: Label 'Quantity in stock';
        TitleLbl: Label 'Raw Material BIO';
        BalanceLbl: Label 'BALANCE';
        BalanceLotNotPurchasedInPeriodLbl: Label 'BALANCE LOT NOT PURCH. IN THE PERIOD';
}