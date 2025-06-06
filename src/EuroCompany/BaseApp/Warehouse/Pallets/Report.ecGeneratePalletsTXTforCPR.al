namespace EuroCompany.BaseApp.Warehouse.Pallets;
using Microsoft.Inventory.Ledger;
using System.Utilities;
using EuroCompany.BaseApp.Setup;
report 50028 "ecGenerate Pallets TXT for CPR"
{
    Caption = 'Generate Pallets TXT for CPR';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            RequestFilterFields = "Document No.", "ecPallet Grouping Code";

            trigger OnAfterGetRecord()
            begin
                CalcFields("ecPallet Grouping Code");

                if "ecPallet Grouping Code" = GeneralSetup."CPR Pallets Identif. Code" then begin
                    ToDownload := true;

                    if not OnlyOneTime then
                        PalletsMgt.WriteCPRHeaderData(OutStr, LastProgressiveNo, GeneralSetup."CPR Counterparty Code", TxtType, CRLF, OnlyOneTime);

                    if PalletsMgt.WriteCPRBodyData(OutStr, "Item Ledger Entry", CRLF, TxtType) then begin
                        TempItemLedgerEntry := "Item Ledger Entry";
                        TempItemLedgerEntry.Insert();
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetCurrentKey("Document No.", "ecPallet Grouping Code");
                SetRange("ecExported For CPR", false);
            end;

            trigger OnPostDataItem()
            begin
                if ToDownload then
                    PalletsMgt.WriteCPRFooterData(OutStr);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(TxtTypeVar; TxtType)
                    {
                        Caption = 'TXT Type';
                        OptionCaption = 'New,Substitution,Elimination';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    var
        Day: Integer;
        Month: Integer;
        Year: Integer;
        MonthTxt: Text;
    begin
        Clear(FileNameToExport);
        Clear(CRLF);
        Clear(LastProgressiveNo);
        Clear(InStr);
        Clear(OutStr);
        Clear(Day);
        Clear(Month);
        Clear(Year);
        Clear(ToDownload);
        Clear(OnlyOneTime);

        GeneralSetup.Get();
        GeneralSetup.TestField("CPR Counterparty Code");
        GeneralSetup.TestField("CPR Pallets Identif. Code");
        GeneralSetup.TestField("CPR Download CSV Path");

        CRLF[1] := 13;
        CRLF[2] := 10;

        if CPRExtractedTXT.FindLast() then
            LastProgressiveNo := IncStr(CPRExtractedTXT."Progressive No.")
        else
            LastProgressiveNo := '0001';

        Day := Date2DMY(WorkDate(), 1);
        Month := Date2DMY(WorkDate(), 2);

        if Month < 10 then
            MonthTxt := '0' + Format(Month)
        else
            MonthTxt := Format(Month);

        Year := Date2DMY(WorkDate(), 3);

        FileNameToExport := 'MOV' + GeneralSetup."CPR Counterparty Code" + Format(Year) + MonthTxt + Format(Day) + Format(LastProgressiveNo) + '.txt';

        TempBlob.CreateOutStream(OutStr, TextEncoding::Windows);
    end;

    trigger OnPostReport()
    var
        ItemLegderEntry: Record "Item Ledger Entry";
        FileCreatedSuccesfullyMsg: Label 'The file %1 was successfully created in the folder of the following path %2.';
    begin
        if ToDownload then begin
            TempBlob.CreateInStream(InStr, TextEncoding::Windows);
            //if AdvFileManager.CreateServerFile(GeneralSetup."CPR Download CSV Path", InStr) then begin
            PalletsMgt.InsertCPRExtractedTXTRecord(LastProgressiveNo, FileNameToExport);

            if TempItemLedgerEntry.FindSet() then
                repeat
                    if ItemLegderEntry.Get(TempItemLedgerEntry."Entry No.") then begin
                        ItemLegderEntry.Validate("ecExported For CPR", true);
                        ItemLegderEntry.Modify();
                    end;
                until TempItemLedgerEntry.Next() = 0;

            DownloadFromStream(InStr, '', '', '', FileNameToExport);
            if GuiAllowed then
                Message(StrSubstNo(FileCreatedSuccesfullyMsg, FileNameToExport, GeneralSetup."CPR Download CSV Path"));
            //end;
        end else
            if GuiAllowed then
                Message(NothingToHandleMsg);
    end;

    var
        GeneralSetup: Record "ecGeneral Setup";
        CPRExtractedTXT: Record "ecCPR Extracted TXT";
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        TempBlob: Codeunit "Temp Blob";
        PalletsMgt: Codeunit "ecPallets Management";
        //AdvFileManager: Codeunit "AltATSAdvanced File Manager";
        TxtType: Option New,Substitution,Elimination;
        CRLF: Text[2];
        FileNameToExport: Text;
        OutStr: OutStream;
        InStr: InStream;
        ToDownload, OnlyOneTime : Boolean;
        LastProgressiveNo: Text;
        NothingToHandleMsg: Label 'Nothing to handle';
}