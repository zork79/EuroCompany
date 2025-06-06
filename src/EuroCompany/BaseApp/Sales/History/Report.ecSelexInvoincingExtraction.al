namespace EuroCompany.BaseApp.Sales.History;

using EuroCompany.BaseApp.Setup;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Catalog;
using Microsoft.Sales.Customer;
using Microsoft.Sales.History;
using System.Utilities;

report 50004 "ecSelex Invoincing Extraction"
{
    ApplicationArea = All;
    Caption = 'Selex Invoincing Extraction';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("APsTRD Business Segment Detail"; "APsTRD Business Segment Detail")
        {
            trigger OnAfterGetRecord()
            var
                ProductSegmentDetail: Record "APsTRD Product Segment Detail";
                Customer: Record Customer;
                SalesInvoiceLine: Record "Sales Invoice Line";
                SalesCrMemoLine: Record "Sales Cr.Memo Line";
            begin
                if Customer.Get("Element No.") then begin
                    //sales invoice lines extraction
                    SalesInvoiceLine.Reset();
                    SalesInvoiceLine.SetFilter(Type, '<>%1', SalesInvoiceLine.Type::" ");
                    SalesInvoiceLine.SetRange("Bill-to Customer No.", Customer."No.");
                    SalesInvoiceLine.SetRange("Posting Date", StartingDateVar, EndingDateVar);
                    if SalesInvoiceLine.FindSet() then begin
                        repeat
                            if SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item then begin
                                ProductSegmentDetail.Reset();
                                ProductSegmentDetail.SetCurrentKey("Segment No.", "Element Type", "Element No.");
                                ProductSegmentDetail.SetRange("Segment No.", EcSetup."Product Segment Selex");
                                ProductSegmentDetail.SetRange("Element Type", ProductSegmentDetail."Element Type"::Item);
                                ProductSegmentDetail.SetRange("Element No.", SalesInvoiceLine."No.");
                                if not ProductSegmentDetail.IsEmpty then
                                    ExportSalesInvoiceLinesInTxt(Customer, SalesInvoiceLine);
                            end else
                                ExportSalesInvoiceLinesInTxt(Customer, SalesInvoiceLine);
                        until SalesInvoiceLine.Next() = 0;
                    end;

                    //sales cr memo lines extraction
                    SalesCrMemoLine.Reset();
                    SalesCrMemoLine.SetFilter(Type, '<>%1', SalesCrMemoLine.Type::" ");
                    SalesCrMemoLine.SetRange("Bill-to Customer No.", Customer."No.");
                    SalesCrMemoLine.SetRange("Posting Date", StartingDateVar, EndingDateVar);
                    if SalesCrMemoLine.FindSet() then begin
                        repeat
                            if SalesCrMemoLine.Type = SalesCrMemoLine.Type::Item then begin
                                ProductSegmentDetail.Reset();
                                ProductSegmentDetail.SetCurrentKey("Segment No.", "Element Type", "Element No.");
                                ProductSegmentDetail.SetRange("Segment No.", EcSetup."Product Segment Selex");
                                ProductSegmentDetail.SetRange("Element Type", ProductSegmentDetail."Element Type"::Item);
                                ProductSegmentDetail.SetRange("Element No.", SalesCrMemoLine."No.");
                                if not ProductSegmentDetail.IsEmpty then
                                    ExportSalesCrMemoLinesInTxt(Customer, SalesCrMemoLine);
                            end else
                                ExportSalesCrMemoLinesInTxt(Customer, SalesCrMemoLine);
                        until SalesCrMemoLine.Next() = 0;
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetCurrentKey("Segment No.", "Element Type", "Element No.");
                SetRange("Segment No.", EcSetup."Business Segment Selex");
                SetRange("Element Type", "Element Type"::Customer);
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

                    field(StartingDate; StartingDateVar)
                    {
                        ApplicationArea = All;
                        Caption = 'Starting Date';
                    }
                    field(EndingDate; EndingDateVar)
                    {
                        ApplicationArea = All;
                        Caption = 'Ending Date';
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        StartingDateVar := WorkDate();
        EndingDateVar := WorkDate();

        CRLF[1] := 13;
        CRLF[2] := 10;

        FileName := SelexInvoicingExtractionLbl + '.txt';

        TempBlob.CreateOutStream(OutStr, TextEncoding::Windows);

        EcSetup.Get();
        EcSetup.TestField("Internal Code");
        EcSetup.TestField("Business Segment Selex");
        EcSetup.TestField("Product Segment Selex");
    end;

    trigger OnPostReport()
    begin
        if ToDownload then begin
            TempBlob.CreateInStream(InStr, TextEncoding::Windows);
            DownloadFromStream(InStr, '', '', '', FileName);
        end else
            Message(NothingToHandleMsg);
    end;

    local procedure ExportSalesInvoiceLinesInTxt(Customer: Record Customer; SalesInvoiceLine: Record "Sales Invoice Line")
    var
        Item: Record Item;
        ItemReference: Record "Item Reference";
        VarQuantity, VarQuantityWithoutComma, VarUnitPricePerQuantity, VarUnitPricePerQuantityWithoutComma, VarDocumentNoWithoutDash, VarDocumentNo, VarPostingDate : Text;
        VarQuantityCounted, VarQuantityLenght, VarUnitPricePerQuantityCounted, VarUnitPricePerQuantityLenght, VarDocumentNoCounted, VarDocumentNoLenght : Integer;
    begin
        OutStr.WriteText(Customer."VAT Registration No.");
        OutStr.WriteText(EcSetup."Internal Code");

        //gestione QUANTITY con 15 caratteri
        VarQuantity := '000000000000000';
        if SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item then begin
            if SalesInvoiceLine."Unit of Measure Code" = EcSetup."UoM To Convert" then begin
                if Item.Get(SalesInvoiceLine."No.") then begin
                    VarQuantityWithoutComma := DelChr(Format(SalesInvoiceLine.Quantity * Item."ecNo. Consumer Units per Pkg."), '=', ',');

                    if VarQuantityWithoutComma.Contains('.') then
                        VarQuantityWithoutComma := DelChr(Format(SalesInvoiceLine.Quantity), '=', '.');
                end;
            end else begin
                VarQuantityWithoutComma := DelChr(Format(SalesInvoiceLine.Quantity), '=', ',');

                if VarQuantityWithoutComma.Contains('.') then
                    VarQuantityWithoutComma := DelChr(Format(SalesInvoiceLine.Quantity), '=', '.');
            end;

            VarQuantityCounted := StrLen(VarQuantityWithoutComma);
            VarQuantityLenght := StrLen(VarQuantity);
            VarQuantity := DelStr(VarQuantity, VarQuantityLenght - VarQuantityCounted + 1, VarQuantityCounted);
            VarQuantity += VarQuantityWithoutComma;
            OutStr.WriteText(VarQuantity);
        end;
        //gestione QUANTITY con 15 caratteri

        if SalesInvoiceLine."Unit of Measure Code" = EcSetup."Allowed UoM KG" then
            OutStr.WriteText(SalesInvoiceLine."Unit of Measure Code");
        if SalesInvoiceLine."Unit of Measure Code" = EcSetup."Allowed UoM LT" then
            OutStr.WriteText(SalesInvoiceLine."Unit of Measure Code");
        if (SalesInvoiceLine."Unit of Measure Code" <> EcSetup."Allowed UoM KG") and (SalesInvoiceLine."Unit of Measure Code" <> EcSetup."Allowed UoM LT") then
            OutStr.WriteText('PZ');

        //gestione UNIT PRICE PER QUANTITY con 15 caratteri
        VarUnitPricePerQuantity := '000000000000000';
        VarUnitPricePerQuantityWithoutComma := DelChr(Format(SalesInvoiceLine.Amount), '=', ',');
        VarUnitPricePerQuantityWithoutComma := DelChr(VarUnitPricePerQuantityWithoutComma, '=', '.');
        VarUnitPricePerQuantityCounted := StrLen(VarUnitPricePerQuantityWithoutComma);
        VarUnitPricePerQuantityLenght := StrLen(VarUnitPricePerQuantity);
        VarUnitPricePerQuantity := DelStr(VarUnitPricePerQuantity, VarUnitPricePerQuantityLenght - VarUnitPricePerQuantityCounted + 1, VarUnitPricePerQuantityCounted);
        VarUnitPricePerQuantity += VarUnitPricePerQuantityWithoutComma;
        OutStr.WriteText(VarUnitPricePerQuantity);
        //gestione UNIT PRICE PER QUANTITY con 15 caratteri

        ItemReference.Reset();
        ItemReference.SetRange("Item No.", SalesInvoiceLine."No.");

        if SalesInvoiceLine."Unit of Measure Code" = EcSetup."UoM To Convert" then
            ItemReference.SetRange("Unit of Measure", EcSetup."Allowed UoM CONF")
        else
            ItemReference.SetRange("Unit of Measure", SalesInvoiceLine."Unit of Measure");

        ItemReference.SetRange("AltAWPBarcode Type", ItemReference."AltAWPBarcode Type"::"EAN-13");
        if ItemReference.FindFirst() then
            OutStr.WriteText(ItemReference."Reference No.")
        else
            OutStr.WriteText('9999999999999');

        //gestione DOCUMENT NO. con 15 caratteri
        VarDocumentNo := '000000000000000';
        VarDocumentNoWithoutDash := DelChr(Format(SalesInvoiceLine."Document No."), '=', '-');
        VarDocumentNoCounted := StrLen(VarDocumentNoWithoutDash);
        VarDocumentNoLenght := StrLen(VarDocumentNo);
        VarDocumentNo := DelStr(VarDocumentNo, VarDocumentNoLenght - VarDocumentNoCounted + 1, VarDocumentNoCounted);
        VarDocumentNo += VarDocumentNoWithoutDash;
        OutStr.WriteText(VarDocumentNo);
        //gestione DOCUMENT NO. con 15 caratteri

        VarPostingDate := Format(SalesInvoiceLine."Posting Date", 0, '<Year4><Month,2><Day,2>');
        OutStr.WriteText(VarPostingDate);

        if SalesInvoiceLine.Quantity = 0 then
            OutStr.WriteText('V')
        else
            OutStr.WriteText(' ');

        OutStr.WriteText('F');

        if SalesInvoiceLine."Line Discount %" <> 0 then
            OutStr.WriteText('S' + CRLF)
        else
            OutStr.WriteText('N' + CRLF);

        ToDownload := true;
    end;

    local procedure ExportSalesCrMemoLinesInTxt(Customer: Record Customer; SalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        Item: Record Item;
        ItemReference: Record "Item Reference";
        VarQuantity, VarQuantityWithoutComma, VarUnitPricePerQuantity, VarUnitPricePerQuantityWithoutComma, VarDocumentNoWithoutDash, VarDocumentNo, VarPostingDate : Text;
        VarQuantityCounted, VarQuantityLenght, VarUnitPricePerQuantityCounted, VarUnitPricePerQuantityLenght, VarDocumentNoCounted, VarDocumentNoLenght : Integer;
    begin
        OutStr.WriteText(Customer."VAT Registration No.");
        OutStr.WriteText(EcSetup."Internal Code");

        //gestione QUANTITY con 15 caratteri
        VarQuantity := '000000000000000';
        if SalesCrMemoLine.Type = SalesCrMemoLine.Type::Item then begin
            if SalesCrMemoLine."Unit of Measure Code" = EcSetup."UoM To Convert" then begin
                if Item.Get(SalesCrMemoLine."No.") then begin
                    VarQuantityWithoutComma := DelChr(Format(SalesCrMemoLine.Quantity * Item."ecNo. Consumer Units per Pkg."), '=', ',');

                    if VarQuantityWithoutComma.Contains('.') then
                        VarQuantityWithoutComma := DelChr(Format(SalesCrMemoLine.Quantity), '=', '.');
                end;
            end else begin
                VarQuantityWithoutComma := DelChr(Format(SalesCrMemoLine.Quantity), '=', ',');

                if VarQuantityWithoutComma.Contains('.') then
                    VarQuantityWithoutComma := DelChr(Format(SalesCrMemoLine.Quantity), '=', '.');
            end;

            VarQuantityCounted := StrLen(VarQuantityWithoutComma);
            VarQuantityLenght := StrLen(VarQuantity);
            VarQuantity := DelStr(VarQuantity, VarQuantityLenght - VarQuantityCounted + 1, VarQuantityCounted);
            VarQuantity += VarQuantityWithoutComma;
            OutStr.WriteText(VarQuantity);
        end;
        //gestione QUANTITY con 15 caratteri

        if SalesCrMemoLine."Unit of Measure Code" = EcSetup."Allowed UoM KG" then
            OutStr.WriteText(SalesCrMemoLine."Unit of Measure Code");
        if SalesCrMemoLine."Unit of Measure Code" = EcSetup."Allowed UoM LT" then
            OutStr.WriteText(SalesCrMemoLine."Unit of Measure Code");
        if (SalesCrMemoLine."Unit of Measure Code" <> EcSetup."Allowed UoM KG") and (SalesCrMemoLine."Unit of Measure Code" <> EcSetup."Allowed UoM LT") then
            OutStr.WriteText('PZ');

        //gestione UNIT PRICE PER QUANTITY con 15 caratteri
        VarUnitPricePerQuantity := '000000000000000';
        VarUnitPricePerQuantityWithoutComma := DelChr(Format(SalesCrMemoLine.Amount), '=', ',');
        VarUnitPricePerQuantityWithoutComma := DelChr(VarUnitPricePerQuantityWithoutComma, '=', '.');
        VarUnitPricePerQuantityCounted := StrLen(VarUnitPricePerQuantityWithoutComma);
        VarUnitPricePerQuantityLenght := StrLen(VarUnitPricePerQuantity);
        VarUnitPricePerQuantity := DelStr(VarUnitPricePerQuantity, VarUnitPricePerQuantityLenght - VarUnitPricePerQuantityCounted + 1, VarUnitPricePerQuantityCounted);
        VarUnitPricePerQuantity += VarUnitPricePerQuantityWithoutComma;
        OutStr.WriteText(VarUnitPricePerQuantity);
        //gestione UNIT PRICE PER QUANTITY con 15 caratteri

        ItemReference.Reset();
        ItemReference.SetRange("Item No.", SalesCrMemoLine."No.");

        if SalesCrMemoLine."Unit of Measure Code" = EcSetup."UoM To Convert" then
            ItemReference.SetRange("Unit of Measure", EcSetup."Allowed UoM CONF")
        else
            ItemReference.SetRange("Unit of Measure", SalesCrMemoLine."Unit of Measure");

        ItemReference.SetRange("AltAWPBarcode Type", ItemReference."AltAWPBarcode Type"::"EAN-13");
        if ItemReference.FindFirst() then
            OutStr.WriteText(ItemReference."Reference No.")
        else
            OutStr.WriteText('9999999999999');

        //gestione DOCUMENT NO. con 15 caratteri
        VarDocumentNo := '000000000000000';
        VarDocumentNoWithoutDash := DelChr(Format(SalesCrMemoLine."Document No."), '=', '-');
        VarDocumentNoCounted := StrLen(VarDocumentNoWithoutDash);
        VarDocumentNoLenght := StrLen(VarDocumentNo);
        VarDocumentNo := DelStr(VarDocumentNo, VarDocumentNoLenght - VarDocumentNoCounted + 1, VarDocumentNoCounted);
        VarDocumentNo += VarDocumentNoWithoutDash;
        OutStr.WriteText(VarDocumentNo);
        //gestione DOCUMENT NO. con 15 caratteri

        VarPostingDate := Format(SalesCrMemoLine."Posting Date", 0, '<Year4><Month,2><Day,2>');
        OutStr.WriteText(VarPostingDate);

        if SalesCrMemoLine.Quantity = 0 then
            OutStr.WriteText('V')
        else
            OutStr.WriteText(' ');

        OutStr.WriteText('N');

        if SalesCrMemoLine."Line Discount %" <> 0 then
            OutStr.WriteText('S' + CRLF)
        else
            OutStr.WriteText('N' + CRLF);

        ToDownload := true;
    end;

    var
        EcSetup: Record "ecGeneral Setup";
        TempBlob: Codeunit "Temp Blob";
        StartingDateVar: Date;
        EndingDateVar: Date;
        CRLF: Text[2];
        FileName: Text;
        OutStr: OutStream;
        InStr: InStream;
        ToDownload: Boolean;
        SelexInvoicingExtractionLbl: Label 'Selex Invoicing Extraction';
        NothingToHandleMsg: Label 'Nothing to handle';
}