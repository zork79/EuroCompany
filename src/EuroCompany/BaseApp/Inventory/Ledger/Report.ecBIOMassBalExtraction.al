namespace EuroCompany.BaseApp.Inventory.Ledger;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Purchases.Vendor;
using Microsoft.Foundation.Company;
using System.Text;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Tracking;
using Microsoft.Finance.GeneralLedger.Account;
using System.Utilities;

report 50031 "ecBIO Mass. Bal. Extraction"
{
    Caption = 'BIO Mass. Bal. Extraction';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/EuroCompany/BaseApp/Inventory/Ledger/BIOMassBalanceExtract.Layout.rdl';

    dataset
    {
        dataitem("ecMass Balances Entry"; "ecMass Balances Entry")
        {
            DataItemTableView = sorting("Posting Date");

            trigger OnPreDataItem()
            begin
                SetFilter("Origin Item No.", ItemNo);

                if LotNo <> '' then
                    SetFilter("Origin Lot No.", LotNo);

                SetFilter("Posting Date", PostingDateFilter);

                CompInfo.Get();
            end;

            trigger OnAfterGetRecord()
            var
                Item: Record Item;
            begin
                if Item.Get("Origin Item No.") then
                    if Item."ecItem Type" <> Item."ecItem Type"::"Raw Material" then
                        CurrReport.Skip();

                InsertTempMassBalanceEntry();
            end;

            trigger OnPostDataItem()
            begin
                TempMassBalanceEntryToCycle.Copy(TempGlobalMassBalanceEntry, true);
                TempMassBalanceEntryToCycle.Reset();
                TempMassBalanceEntryToCycle.SetCurrentKey("Origin Item No.", "Origin Lot No.");
                if TempMassBalanceEntryToCycle.FindSet() then
                    repeat
                        if (DifferentLotNo <> TempMassBalanceEntryToCycle."Origin Lot No.") or (DifferentItemNo <> TempMassBalanceEntryToCycle."Origin Item No.") then begin
                            DifferentLotNo := TempMassBalanceEntryToCycle."Origin Lot No.";
                            DifferentItemNo := TempMassBalanceEntryToCycle."Origin Item No.";

                            InsertFirstTempMassBalanceEntryLine();
                            InsertPurchTempMassBalanceEntryLine();
                            InsertTotalDirectSaleAndDirectSalesTempMassBalanceEntryLines();
                            InsertOutputAndSalesTempMassBalanceEntryLines();

                            if TempMassBalanceEntryToCycle.Next() > 0 then begin
                                //Spazio bianco
                                TempMassBalanceEntry.Init();
                                if GlobalEntryNo = 0 then begin
                                    if TempMassBalanceEntry.FindLast() then
                                        GlobalEntryNo := TempMassBalanceEntry."Entry No." + 1
                                    else
                                        GlobalEntryNo := 1;
                                end else
                                    GlobalEntryNo := GlobalEntryNo + 1;
                                TempMassBalanceEntry."Entry Type" := TempMassBalanceEntry."Entry Type"::" ";

                                TempMassBalanceEntry."Entry No." := GlobalEntryNo;
                                TempMassBalanceEntry.Insert();
                            end;
                        end;
                    until TempMassBalanceEntryToCycle.Next() = 0;

            end;
        }
        dataitem(Integer; Integer)
        {
            column(Posting_Date_Lbl; TempMassBalanceEntry.FieldCaption("Posting Date"))
            {
            }
            column(Entry_Type_Lbl; TempMassBalanceEntry.FieldCaption("Entry Type"))
            {
            }
            column(Item_No_Lbl; TempMassBalanceEntry.FieldCaption("Item No."))
            {
            }
            column(Description_Lbl; TempMassBalanceEntry.FieldCaption("Item Description"))
            {
            }
            column(Lot_No_Lbl; TempMassBalanceEntry.FieldCaption("Item Lot No."))
            {
            }
            column(Source_Doc_No_Lbl; TempMassBalanceEntry.FieldCaption("Document No."))
            {
            }
            column(Vendor_DDT_No_Lbl; VendorDDTNoLbl)
            {
            }
            column(Source_No_Lbl; TempMassBalanceEntry.FieldCaption("Source No."))
            {
            }
            column(Source_Descr_Lbl; SourceDescrLbl)
            {
            }
            column(DDT_No_Lbl; DDTNoLbl)
            {
            }
            column(Purch_Qty_Lbl; PurchQtyLbl)
            {
            }
            column(Qty_In_Direct_Sale_Lbl; QtyInDirectSaleLbl)
            {
            }
            column(Qty_In_Sale_Lbl; QtyInSaleLbl)
            {
            }
            column(Net_Consumed_Qty_Lbl; NetConsumedQtyLbl)
            {
            }
            column(Effective_ConsumedQty_Lbl; EffectiveConsumedQtyLbl)
            {
            }
            column(Remaining_Qty_Lbl; RemainingQtyLbl)
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
            column(Posting_Date; TempMassBalanceEntry."Posting Date")
            {
            }
            column(Entry_Type; Format(TempMassBalanceEntry."Entry Type", 0))
            {
            }
            column(Item_No; TempMassBalanceEntry."Item No.")
            {
            }
            column(Description; TempMassBalanceEntry.ItemDescription)
            {
            }
            column(Lot_No; TempMassBalanceEntry."Item Lot No.")
            {
            }
            column(Source_Doc_No; TempMassBalanceEntry."Document No.")
            {
            }
            column(Vendor_DDT_No; TempMassBalanceEntry.VendorDDTNo)
            {
            }
            column(Source_No; TempMassBalanceEntry."Source No.")
            {
            }
            column(Source_Descr; TempMassBalanceEntry.SourceDescr)
            {
            }
            column(DDT_No; TempMassBalanceEntry.DDTNo)
            {
            }
            column(Purch_Qty; TempMassBalanceEntry.PurchQtyGlobal)
            {
            }
            column(Qty_In_Direct_Sale; TempMassBalanceEntry.QtyInDirectSaleGlobal)
            {
            }
            column(Qty_In_Sale; TempMassBalanceEntry.QtyInSaleGlobal)
            {
            }
            column(Net_Consumed_Qty; TempMassBalanceEntry.NetConsumedQtyGlobal)
            {
            }
            column(Effective_Consumed_Qty; TempMassBalanceEntry.EffectiveConsumedQtyGlobal)
            {
            }
            column(Remaining_Qty; TempMassBalanceEntry.RemainingQtyGlobal)
            {
            }
            column(IsBold; TempMassBalanceEntry.IsBold)
            {
            }
            column(IsBoldDirectSale; TempMassBalanceEntry.IsBoldDirectSale)
            {
            }
            column(IsBoldOutput; TempMassBalanceEntry.IsBoldOutput)
            {
            }
            trigger OnPreDataItem()
            begin
                TempMassBalanceEntry.Reset();
                SetRange(Number, 1, TempMassBalanceEntry.Count());
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    TempMassBalanceEntry.FindSet()
                else
                    TempMassBalanceEntry.Next();
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

    local procedure InsertTempMassBalanceEntry()
    begin
        TempGlobalMassBalanceEntry.Init();
        TempGlobalMassBalanceEntry.TransferFields("ecMass Balances Entry");
        TempGlobalMassBalanceEntry.Insert();
    end;

    local procedure InsertFirstTempMassBalanceEntryLine()
    begin
        TempMassBalanceEntry.Init();

        TempMassBalanceEntry.TransferFields(TempMassBalanceEntryToCycle);

        if GlobalEntryNo = 0 then begin
            if TempMassBalanceEntry.FindLast() then
                GlobalEntryNo := TempMassBalanceEntry."Entry No." + 1
            else
                GlobalEntryNo := 1;
        end else
            GlobalEntryNo := GlobalEntryNo + 1;

        TempMassBalanceEntry."Entry No." := GlobalEntryNo;

        TempMassBalanceEntry.PurchQtyGlobal := CalcPurchQty();
        TempMassBalanceEntry.QtyInDirectSaleGlobal := CalcQtyInDirectSale();
        TempMassBalanceEntry.QtyInSaleGlobal := CalcQtyInSale();

        CalcNetAndEffectiveConsumedQty(TempMassBalanceEntry.NetConsumedQtyGlobal, TempMassBalanceEntry.EffectiveConsumedQtyGlobal);

        TempMassBalanceEntry.RemainingQtyGlobal := TempMassBalanceEntry.PurchQtyGlobal - TempMassBalanceEntry.QtyInDirectSaleGlobal - TempMassBalanceEntry.EffectiveConsumedQtyGlobal;
        TempMassBalanceEntry."Entry Type" := TempMassBalanceEntry."Entry Type"::" ";
        TempMassBalanceEntry.IsBold := true;
        TempMassBalanceEntry.Insert();
    end;

    local procedure InsertPurchTempMassBalanceEntryLine()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        Vendor: Record Vendor;
    begin
        TempGlobalMassBalanceEntry.Reset();
        TempGlobalMassBalanceEntry.SetRange("Entry Type", TempGlobalMassBalanceEntry."Entry Type"::Purchase);
        TempGlobalMassBalanceEntry.SetRange("Origin Item No.", TempMassBalanceEntryToCycle."Origin Item No.");
        TempGlobalMassBalanceEntry.SetRange("Origin Lot No.", TempMassBalanceEntryToCycle."Origin Lot No.");
        if TempGlobalMassBalanceEntry.FindSet() then
            repeat
                TempMassBalanceEntry.Init();
                TempMassBalanceEntry.TransferFields(TempGlobalMassBalanceEntry);

                TempMassBalanceEntry.CalcFields("Item Description");
                TempMassBalanceEntry.ItemDescription := TempMassBalanceEntry."Item Description";

                if GlobalEntryNo = 0 then begin
                    if TempMassBalanceEntry.FindLast() then
                        GlobalEntryNo := TempMassBalanceEntry."Entry No." + 1
                    else
                        GlobalEntryNo := 1;
                end else
                    GlobalEntryNo := GlobalEntryNo + 1;

                TempMassBalanceEntry."Entry No." := GlobalEntryNo;

                TempMassBalanceEntry.PurchQtyGlobal := TempMassBalanceEntry."Item Quantity";

                if ItemLedgerEntry.Get(TempMassBalanceEntry."Item Ledger Entry No.") then
                    TempMassBalanceEntry.VendorDDTNo := ItemLedgerEntry."External Document No.";

                if Vendor.Get(TempMassBalanceEntry."Source No.") then
                    TempMassBalanceEntry.SourceDescr := Vendor.Name;

                TempMassBalanceEntry.Insert();
            until TempGlobalMassBalanceEntry.Next() = 0;
    end;

    local procedure InsertTotalDirectSaleAndDirectSalesTempMassBalanceEntryLines()
    var
        Customer: Record Customer;
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        TempMassBalanceEntry.Init();

        TempMassBalanceEntry."Entry Type" := TempMassBalanceEntry."Entry Type"::"Direct Sale";

        TempMassBalanceEntry."Item No." := TempMassBalanceEntryToCycle."Origin Item No.";
        TempMassBalanceEntry.CalcFields("Item Description");
        TempMassBalanceEntry.ItemDescription := TempMassBalanceEntry."Item Description";

        TempMassBalanceEntry."Item Lot No." := TempMassBalanceEntryToCycle."Item Lot No.";

        TempMassBalanceEntry.QtyInDirectSaleGlobal := CalcQtyInDirectSale();

        if GlobalEntryNo = 0 then begin
            if TempMassBalanceEntry.FindLast() then
                GlobalEntryNo := TempMassBalanceEntry."Entry No." + 1
            else
                GlobalEntryNo := 1;
        end else
            GlobalEntryNo := GlobalEntryNo + 1;

        TempMassBalanceEntry."Entry No." := GlobalEntryNo;
        TempMassBalanceEntry.IsBoldDirectSale := true;

        if TempMassBalanceEntry.QtyInDirectSaleGlobal <> 0 then
            TempMassBalanceEntry.Insert();

        TempGlobalMassBalanceEntry.Reset();
        TempGlobalMassBalanceEntry.SetRange("Entry Type", TempGlobalMassBalanceEntry."Entry Type"::"Direct Sale");
        TempGlobalMassBalanceEntry.SetRange("Origin Item No.", TempMassBalanceEntryToCycle."Origin Item No.");
        TempGlobalMassBalanceEntry.SetRange("Origin Lot No.", TempMassBalanceEntryToCycle."Origin Lot No.");
        if TempGlobalMassBalanceEntry.FindSet() then
            repeat
                TempMassBalanceEntry.Init();
                TempMassBalanceEntry.TransferFields(TempGlobalMassBalanceEntry);

                if GlobalEntryNo = 0 then begin
                    if TempMassBalanceEntry.FindLast() then
                        GlobalEntryNo := TempMassBalanceEntry."Entry No." + 1
                    else
                        GlobalEntryNo := 1;
                end else
                    GlobalEntryNo := GlobalEntryNo + 1;

                TempMassBalanceEntry."Entry No." := GlobalEntryNo;

                TempMassBalanceEntry.QtyInDirectSaleGlobal := TempMassBalanceEntry."Item Quantity";
                TempMassBalanceEntry.CalcFields("Item Description");
                TempMassBalanceEntry.ItemDescription := TempMassBalanceEntry."Item Description";

                if Customer.Get(TempMassBalanceEntry."Source No.") then
                    TempMassBalanceEntry.SourceDescr := Customer.Name;

                if ItemLedgerEntry.Get(TempMassBalanceEntry."Item Ledger Entry No.") then
                    TempMassBalanceEntry.DDTNo := ItemLedgerEntry."AltAWPPosted Document No.";

                TempMassBalanceEntry.Insert();
            until TempGlobalMassBalanceEntry.Next() = 0;
    end;

    local procedure InsertOutputAndSalesTempMassBalanceEntryLines()
    var
        SaleMassBalanceEntry: Record "ecMass Balances Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Customer: Record Customer;
    begin
        TempGlobalMassBalanceEntry.Reset();
        TempGlobalMassBalanceEntry.SetRange("Entry Type", TempGlobalMassBalanceEntry."Entry Type"::Output);
        TempGlobalMassBalanceEntry.SetRange("Origin Item No.", TempMassBalanceEntryToCycle."Origin Item No.");
        TempGlobalMassBalanceEntry.SetRange("Origin Lot No.", TempMassBalanceEntryToCycle."Origin Lot No.");
        TempGlobalMassBalanceEntry.SetRange("Planning Level Code", 0);
        if TempGlobalMassBalanceEntry.FindSet() then
            repeat
                TempMassBalanceEntry.Init();
                TempMassBalanceEntry."Posting Date" := TempGlobalMassBalanceEntry."Posting Date";
                TempMassBalanceEntry."Entry Type" := TempGlobalMassBalanceEntry."Entry Type";
                TempMassBalanceEntry."Tracking Entry Type" := TempGlobalMassBalanceEntry."Tracking Entry Type";
                TempMassBalanceEntry."Item No." := TempGlobalMassBalanceEntry."Item No.";
                TempMassBalanceEntry.CalcFields("Item Description");
                TempMassBalanceEntry.ItemDescription := TempMassBalanceEntry."Item Description";
                TempMassBalanceEntry."Item Lot No." := TempGlobalMassBalanceEntry."Item Lot No.";
                TempMassBalanceEntry."Document No." := TempGlobalMassBalanceEntry."Document No.";

                if GlobalEntryNo = 0 then begin
                    if TempMassBalanceEntry.FindLast() then
                        GlobalEntryNo := TempMassBalanceEntry."Entry No." + 1
                    else
                        GlobalEntryNo := 1;
                end else
                    GlobalEntryNo := GlobalEntryNo + 1;

                TempMassBalanceEntry."Entry No." := GlobalEntryNo;

                SaleMassBalanceEntry.Reset();
                SaleMassBalanceEntry.SetRange("Entry Type", SaleMassBalanceEntry."Entry Type"::Sale);
                SaleMassBalanceEntry.SetRange("Item No.", TempMassBalanceEntry."Item No.");
                SaleMassBalanceEntry.SetRange("Item Lot No.", TempMassBalanceEntry."Item Lot No.");
                SaleMassBalanceEntry.SetFilter("Posting Date", PostingDateFilter);
                SaleMassBalanceEntry.CalcSums("Tracked Quantity");

                TempMassBalanceEntry.QtyInSaleGlobal := SaleMassBalanceEntry."Tracked Quantity";
                TempMassBalanceEntry.NetConsumedQtyGlobal := TempGlobalMassBalanceEntry."Tracked Quantity";
                TempMassBalanceEntry.EffectiveConsumedQtyGlobal := TempGlobalMassBalanceEntry."Item Quantity";
                TempMassBalanceEntry.IsBoldOutput := true;
                TempMassBalanceEntry.Insert();

                SaleMassBalanceEntry.Reset();
                SaleMassBalanceEntry.SetRange("Entry Type", SaleMassBalanceEntry."Entry Type"::Sale);
                SaleMassBalanceEntry.SetRange("Item No.", TempMassBalanceEntry."Item No.");
                SaleMassBalanceEntry.SetRange("Item Lot No.", TempMassBalanceEntry."Item Lot No.");
                SaleMassBalanceEntry.SetFilter("Posting Date", PostingDateFilter);
                if SaleMassBalanceEntry.FindSet() then
                    repeat
                        TempMassBalanceEntry.Init();
                        TempMassBalanceEntry.TransferFields(SaleMassBalanceEntry);

                        TempMassBalanceEntry."Item No." := TempMassBalanceEntryToCycle."Origin Item No.";
                        TempMassBalanceEntry."Item Lot No." := TempMassBalanceEntryToCycle."Origin Lot No.";

                        if GlobalEntryNo = 0 then begin
                            if TempMassBalanceEntry.FindLast() then
                                GlobalEntryNo := TempMassBalanceEntry."Entry No." + 1
                            else
                                GlobalEntryNo := 1;
                        end else
                            GlobalEntryNo := GlobalEntryNo + 1;

                        TempMassBalanceEntry."Entry No." := GlobalEntryNo;

                        TempMassBalanceEntry.QtyInSaleGlobal := TempMassBalanceEntry."Tracked Quantity";

                        TempMassBalanceEntry."Entry Type" := TempMassBalanceEntry."Entry Type"::Sale;

                        TempMassBalanceEntry.CalcFields("Item Description");
                        TempMassBalanceEntry.ItemDescription := TempMassBalanceEntry."Item Description";

                        if Customer.Get(TempMassBalanceEntry."Source No.") then
                            TempMassBalanceEntry.SourceDescr := Customer.Name;

                        if ItemLedgerEntry.Get(TempMassBalanceEntry."Item Ledger Entry No.") then
                            TempMassBalanceEntry.DDTNo := ItemLedgerEntry."AltAWPPosted Document No.";

                        TempMassBalanceEntry.Insert();
                    until SaleMassBalanceEntry.Next() = 0;
            until TempGlobalMassBalanceEntry.Next() = 0;
    end;

    local procedure CalcPurchQty(): Decimal
    var
        PurchQty: Decimal;
    begin
        TempGlobalMassBalanceEntry.Reset();
        TempGlobalMassBalanceEntry.SetRange("Entry Type", TempGlobalMassBalanceEntry."Entry Type"::Purchase);
        TempGlobalMassBalanceEntry.SetRange("Origin Item No.", TempMassBalanceEntryToCycle."Origin Item No.");
        TempGlobalMassBalanceEntry.SetRange("Origin Lot No.", TempMassBalanceEntryToCycle."Origin Lot No.");
        TempGlobalMassBalanceEntry.CalcSums("Item Quantity");

        PurchQty := TempGlobalMassBalanceEntry."Item Quantity";
        exit(PurchQty);
    end;

    local procedure CalcQtyInDirectSale(): Decimal
    var
        QtyInDirectSale: Decimal;
    begin
        TempGlobalMassBalanceEntry.Reset();
        TempGlobalMassBalanceEntry.SetRange("Entry Type", TempGlobalMassBalanceEntry."Entry Type"::"Direct Sale");
        TempGlobalMassBalanceEntry.SetRange("Origin Item No.", TempMassBalanceEntryToCycle."Origin Item No.");
        TempGlobalMassBalanceEntry.SetRange("Origin Lot No.", TempMassBalanceEntryToCycle."Origin Lot No.");
        TempGlobalMassBalanceEntry.CalcSums("Item Quantity");

        QtyInDirectSale := TempGlobalMassBalanceEntry."Item Quantity";
        exit(QtyInDirectSale);
    end;

    local procedure CalcQtyInSale(): Decimal
    var
        QtyInSale: Decimal;
    begin
        TempGlobalMassBalanceEntry.Reset();
        TempGlobalMassBalanceEntry.SetRange("Entry Type", TempGlobalMassBalanceEntry."Entry Type"::Sale);
        TempGlobalMassBalanceEntry.SetRange("Origin Item No.", TempMassBalanceEntryToCycle."Origin Item No.");
        TempGlobalMassBalanceEntry.SetRange("Origin Lot No.", TempMassBalanceEntryToCycle."Origin Lot No.");
        TempGlobalMassBalanceEntry.CalcSums("Tracked Quantity");

        QtyInSale := TempGlobalMassBalanceEntry."Tracked Quantity";
        exit(QtyInSale);
    end;

    local procedure CalcNetAndEffectiveConsumedQty(var NetConsumedQty: Decimal; var EffectiveConsumedQty: Decimal): Decimal
    var
    begin
        TempGlobalMassBalanceEntry.Reset();
        TempGlobalMassBalanceEntry.SetRange("Entry Type", TempGlobalMassBalanceEntry."Entry Type"::Output);
        TempGlobalMassBalanceEntry.SetRange("Planning Level Code", 0);
        TempGlobalMassBalanceEntry.SetRange("Origin Item No.", ItemNo);
        TempGlobalMassBalanceEntry.SetRange("Origin Item No.", TempMassBalanceEntryToCycle."Origin Item No.");
        TempGlobalMassBalanceEntry.SetRange("Origin Lot No.", TempMassBalanceEntryToCycle."Origin Lot No.");
        TempGlobalMassBalanceEntry.CalcSums("Tracked Quantity");
        TempGlobalMassBalanceEntry.CalcSums("Item Quantity");

        NetConsumedQty := TempGlobalMassBalanceEntry."Tracked Quantity";
        EffectiveConsumedQty := TempGlobalMassBalanceEntry."Item Quantity";
    end;

    var
        CompInfo: Record "Company Information";
        TempGlobalMassBalanceEntry, TempMassBalanceEntry, TempMassBalanceEntryToCycle : Record "ecMass Balances Entry" temporary;
        ItemNo: Code[20];
        LotNo: Code[50];
        GlobalEntryNo: Integer;
        PostingDateFilter: Text;
        DifferentLotNo: Code[50];
        DifferentItemNo: Code[20];
        VendorDDTNoLbl: Label 'Vendor DDT No.';
        SourceDescrLbl: Label 'Source description';
        DDTNoLbl: Label 'DDT no.';
        PurchQtyLbl: Label 'Purchased qty.';
        QtyInDirectSaleLbl: Label 'Qty. in direct sale';
        QtyInSaleLbl: Label 'Qty. in sale';
        NetConsumedQtyLbl: Label 'Net consumed qty.';
        EffectiveConsumedQtyLbl: Label 'Effective consumed qty.';
        RemainingQtyLbl: Label 'Remaining qty.';
        TitleLbl: Label 'Mass balance BIO';
}