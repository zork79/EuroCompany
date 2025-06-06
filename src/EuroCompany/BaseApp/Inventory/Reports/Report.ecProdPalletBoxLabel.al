namespace EuroCompany.BaseApp.Inventory.Reports;
using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Foundation.Address;
using Microsoft.Inventory.Tracking;
using Microsoft.Manufacturing.Document;
using Microsoft.Warehouse.Journal;
using Microsoft.Warehouse.Ledger;
using System.Utilities;

report 50006 "ecProd. Pallet/Box Label"
{
    ApplicationArea = All;
    Caption = 'Production Pallet/Box Label';
    Description = 'CS_ACQ_004';
    PreviewMode = PrintLayout;
    RDLCLayout = '.\src\EuroCompany\BaseApp\Inventory\Reports\ProdPalletBoxLabel.Layout.rdlc';
    UsageCategory = None;

    dataset
    {
        dataitem(PrintLabel; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending);

            dataitem(PageNumber; Integer)
            {
                column(lblQty; lblQty) { }
                column(lblCode; lblCode) { }
                column(lblVendorLot; lblVendorLot) { }
                column(lblOrigin; lblOrigin) { }
                column(LabelNo; Temp_LabelBuffer_Master."Entry No.") { }
                column(lblGauge; lblGauge) { }
                column(lblReceiptRef; lblReceiptRef) { }
                column(lblWorkCenterMachineCenter; lblWorkCenterMachineCenter) { }
                column(BoxNo; Temp_LabelBuffer_Master."No.") { }
                column(LotNo; Temp_LabelBuffer_Master."Lot No.") { }
                column(BarcodeString; Temp_LabelBuffer_Master."Barcode String") { }
                column(Barcode; BarcodeB64) { }
                column(ItemNo_Big; ItemNo_Big) { }
                column(VariantCode; Temp_LabelBuffer_Master."Variant Code") { }
                column(ItemDescription; Temp_LabelBuffer_Master.Description) { }
                column(ItemDescription2; Temp_LabelBuffer_Master."Description 2") { }
                column(ProdOrderRef; Temp_LabelBuffer_Master."Whse. Document No." + ' - ' + Format(Temp_LabelBuffer_Master."Whse. Document Line No.")) { }
                column(DocumentText; DocumentInfoText) { }
                column(ExternalDocumentLabelText; ExternalDocLabelText) { }
                column(ExternalDocumentText; ExternalDocInfoText) { }
                column(GaugeTxt; GaugeTxt) { }
                column(VendorLotNoTxt; VendorLotNoTxt) { }
                column(OriginTxt; OriginTxt) { }
                column(TotalLogUnits; PrintLabel.Number) { }
                column(BarcodeImagePaddingLeft; BarcodeImagePaddingLeft) { }
                column(BarcodeImagePaddingTop; BarcodeImagePaddingTop) { }
                column(Quantity; Temp_LabelBuffer_Details.Quantity) { }
                column(UnitOfMeasureCode; Temp_LabelBuffer_Details."Unit of Measure Code") { }
                column(ParentItemNo; ParentProdOrderLine."Item No.") { }
                column(ParentWorkMachineCenter; ParentWorkMachineCenter) { }
                column(PageNo; Number) { }

                trigger OnPreDataItem()
                begin
                    PageNumber.SetRange(Number, 1, NumberOfCopies);
                end;
            }

            trigger OnPreDataItem()
            begin
                Temp_LabelBuffer_Master.SetCurrentKey(Type, "Pallet No.", "No.");
                Temp_LabelBuffer_Master.SetRange("Record Type", Temp_LabelBuffer_Master."Record Type"::Master);
                Temp_LabelBuffer_Master.SetFilter(Type, '%1|%2', Temp_LabelBuffer_Master.Type::Box, Temp_LabelBuffer_Master.Type::Pallet);
                Temp_LabelBuffer_Master.SetRange("Label Type", Temp_LabelBuffer_Master."Label Type"::Inventory);

                SetRange(Number, 1, Temp_LabelBuffer_Master.Count);
            end;

            trigger OnAfterGetRecord()
            var
                lGauge: Record ecGauge;
                lProdOrderLine: Record "Prod. Order Line";
                lCountryRegion: Record "Country/Region";
                lLotNoInformation: Record "Lot No. Information";
                lProdOrderComponent: Record "Prod. Order Component";
                lProdOrderRoutingLine: Record "Prod. Order Routing Line";
                latsImageHelper: Codeunit "AltATSImage Helper";
            begin
                if (Number = 1) then begin
                    Temp_LabelBuffer_Master.FindSet();
                end else begin
                    Temp_LabelBuffer_Master.Next();
                end;

                BarcodeB64 := awpBarcodeFunctions.MakeBarcode(Temp_LabelBuffer_Master."Barcode String", Enum::"AltATSBarcode Symbology"::"Code 128", 1, 26, false, 0);
                latsImageHelper.CalculateImagePadding(BarcodeB64, 64, 15, BarcodeImagePaddingLeft, BarcodeImagePaddingTop);

                ItemNo_Big := '';
                GaugeTxt := '';
                VendorLotNoTxt := '';
                OriginTxt := '';

                // Ricerca prima riga di dettaglio
                Temp_LabelBuffer_Details.SetRange("Record Type", Temp_LabelBuffer_Details."Record Type"::Detail);
                Temp_LabelBuffer_Details.SetRange(Type, Temp_LabelBuffer_Master.Type);
                Temp_LabelBuffer_Details.SetRange("No.", Temp_LabelBuffer_Master."No.");
                Temp_LabelBuffer_Details.SetRange("Pallet No.", Temp_LabelBuffer_Master."Pallet No.");
                Temp_LabelBuffer_Details.SetRange("Label Type", Temp_LabelBuffer_Details."Label Type"::Inventory);

                if Temp_LabelBuffer_Details.FindFirst() then begin
                    Temp_LabelBuffer_Master."Item No." := Temp_LabelBuffer_Details."Item No.";
                    Temp_LabelBuffer_Master."Variant Code" := Temp_LabelBuffer_Details."Variant Code";
                    Temp_LabelBuffer_Master."Lot No." := Temp_LabelBuffer_Details."Lot No.";
                    Temp_LabelBuffer_Master.Description := Temp_LabelBuffer_Details.Description;
                    Temp_LabelBuffer_Master."Description 2" := Temp_LabelBuffer_Details."Description 2";

                    if lLotNoInformation.Get(Temp_LabelBuffer_Details."Item No.", Temp_LabelBuffer_Details."Variant Code", Temp_LabelBuffer_Details."Lot No.") then begin
                        if (lLotNoInformation.ecGauge <> '') and lGauge.Get(lLotNoInformation.ecGauge) then begin
                            GaugeTxt := lGauge.Description;
                        end;
                        if (lLotNoInformation."ecVendor Lot No." <> '') then begin
                            VendorLotNoTxt := lLotNoInformation."ecVendor Lot No.";
                        end;
                        if (lLotNoInformation."ecOrigin Country Code" <> '') then begin
                            if not lCountryRegion.Get(lLotNoInformation."ecOrigin Country Code") then Clear(lCountryRegion);
                            OriginTxt := lCountryRegion.Code + ' (' + lCountryRegion.Name + ')';
                        end;
                    end;

                    ItemNo_Big := Temp_LabelBuffer_Master."Item No.";
                end;

                if lProdOrderLine.Get(lProdOrderLine.Status::Released, Temp_LabelBuffer_Master."Whse. Document No.", Temp_LabelBuffer_Master."Whse. Document Line No.") then begin
                    if (lProdOrderLine."ecParent Line No." <> 0) then begin

                        Clear(lProdOrderComponent);
                        lProdOrderComponent.SetRange(Status, lProdOrderLine.Status);
                        lProdOrderComponent.SetRange("Prod. Order No.", lProdOrderLine."Prod. Order No.");
                        lProdOrderComponent.SetRange("Item No.", lProdOrderLine."Item No.");
                        lProdOrderComponent.SetRange("Supplied-by Line No.", lProdOrderLine."Line No.");
                        lProdOrderComponent.FindFirst();
                        ParentProdOrderLine.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.", lProdOrderComponent."Prod. Order Line No.");

                        ParentWorkMachineCenter := '';
                        Clear(lProdOrderRoutingLine);
                        lProdOrderRoutingLine.SetRange(Status, ParentProdOrderLine.Status);
                        lProdOrderRoutingLine.SetRange("Prod. Order No.", ParentProdOrderLine."Prod. Order No.");
                        lProdOrderRoutingLine.SetRange("Routing Reference No.", ParentProdOrderLine."Routing Reference No.");
                        lProdOrderRoutingLine.SetRange("Routing No.", ParentProdOrderLine."Routing No.");
                        lProdOrderRoutingLine.SetRange("Routing Link Code", lProdOrderComponent."Routing Link Code");
                        if not lProdOrderRoutingLine.IsEmpty then begin
                            lProdOrderRoutingLine.FindLast();
                            ParentWorkMachineCenter := lProdOrderRoutingLine."No.";
                        end;
                    end;
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Parameters)
                {
                    Caption = 'Parameters';

                    field(NumberOfCopiesField; NumberOfCopies)
                    {
                        ApplicationArea = All;
                        Caption = 'No. of copies';
                        MinValue = 1;
                    }
                }
            }
        }
    }

    var
        awpBarcodeSetup: Record "AltAWPBarcode Setup";
        Temp_LabelBuffer_Master: Record "AltAWPLogistic Labels Buffer" temporary;
        Temp_LabelBuffer_Details: Record "AltAWPLogistic Labels Buffer" temporary;
        ParentProdOrderLine: Record "Prod. Order Line";
        awpBarcodeFunctions: Codeunit "AltAWPBarcode Functions";

        GaugeTxt: Text;
        BarcodeB64: Text;
        ItemNo_Big: Text;
        OriginTxt: Text;
        DocumentInfoText: Text;
        ExternalDocLabelText: Text;
        ExternalDocInfoText: Text;
        VendorLotNoTxt: Text;
        ParentWorkMachineCenter: Text;
        BarcodeImagePaddingLeft: Text;
        BarcodeImagePaddingTop: Text;
        NumberOfCopies: Integer;

        lblQty: Label 'Qty';
        lblCode: Label 'FP Code:';
        lblGauge: Label 'Gauge:';
        lblVendorLot: Label 'Vendor lot:';
        lblReceiptRef: Label 'Prod. order ref.:';
        lblOrigin: Label 'Origin:';
        lblWorkCenterMachineCenter: Label 'Work/Machine:';

    trigger OnInitReport()
    begin
        NumberOfCopies := 1;
    end;

    trigger OnPreReport()
    begin
        awpBarcodeSetup.GetGeneralSetup();
        awpBarcodeSetup.TestField("Bin Barcode Prefix");
        awpBarcodeSetup.TestField("Barcode Elements Separator");
    end;

    procedure SetLabelBuffer(var Temp_pLabelBuffer: Record "AltAWPLogistic Labels Buffer" temporary)
    begin
        Temp_LabelBuffer_Master.Copy(Temp_pLabelBuffer, true);
        Temp_LabelBuffer_Details.Copy(Temp_pLabelBuffer, true);
    end;
}
