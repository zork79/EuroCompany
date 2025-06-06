namespace EuroCompany.BaseApp.Warehouse.Reports;
using Microsoft.Foundation.Address;
using Microsoft.Foundation.Company;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;
using Microsoft.Warehouse.Activity;
using Microsoft.Warehouse.Document;
using Microsoft.Warehouse.History;
using System.Utilities;

report 50025 "ecPacking List"
{
    ApplicationArea = All;
    Caption = 'Packing List';
    Description = 'GAP_VEN_001';
    PreviewMode = PrintLayout;
    RDLCLayout = '.\src\EuroCompany\BaseApp\Warehouse\Reports\PackingList.Layout.rdlc';
    UsageCategory = None;

    dataset
    {
        dataitem(PrintPackingList; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending);

            column(PrintPackingList_Number; PrintPackingList.Number) { }

            dataitem(PrintMaster; Integer)
            {
                DataItemTableView = sorting(Number) order(ascending);

                column(Logo; CompanyInformation.Picture) { }
                column(Name; CompanyInformation.Name) { }
                column(PrintMaster_Number; Number) { }
                column(PrintMaster_WhseDocumentNo; Temp_LabelBuffer_Master."Whse. Document No.") { }
                column(PrintMaster_PostingDate; Temp_LabelBuffer_Master."Posting Date") { }
                column(PrintMaster_SubjectNo; Temp_LabelBuffer_Master."Subject No.") { }
                column(PrintMaster_SubjectDetailNo; Temp_LabelBuffer_Master."Subject Detail No.") { }
                column(ShipTo1; ShipTo[1]) { }
                column(ShipTo2; ShipTo[2]) { }
                column(ShipTo3; ShipTo[3]) { }
                column(ShipTo4; ShipTo[4]) { }
                column(SellTo1; SellTo[1]) { }
                column(SellTo2; SellTo[2]) { }
                column(SellTo3; SellTo[3]) { }
                column(SellTo4; SellTo[4]) { }
                column(HeaderInformationArray1; HeaderInformationArray[1]) { }
                column(HeaderInformationArray2; HeaderInformationArray[2]) { }
                column(HeaderInformationArray3; HeaderInformationArray[3]) { }
                column(HeaderInformationArray4; HeaderInformationArray[4]) { }
                column(HeaderInformationArray5; HeaderInformationArray[5]) { }
                column(HeaderInformationArray6; HeaderInformationArray[6]) { }
                column(HeaderInformationArray7; HeaderInformationArray[7]) { }
                column(HeaderInformationArray8; HeaderInformationArray[8]) { }
                column(HeaderInformationArray9; HeaderInformationArray[9]) { }
                column(HeaderInformationArray10; HeaderInformationArray[10]) { }
                column(HeaderInformationArray11; HeaderInformationArray[11]) { }
                column(PrintMaster_ParcelNo; Temp_LabelBuffer_Master."Parcel No.") { }
                column(PrintMaster_Type; Temp_LabelBuffer_Master.Type) { }
                column(PrintMaster_No; Temp_LabelBuffer_Master."No.") { }
                column(PrintMaster_SSCC; SSCC_Master) { }
                column(PrintMaster_LogUnitFormatDescr; LogUnitFormatDesc_Master) { }
                column(DocumentText; DocumentText) { }
                column(DestPhoneNo; DestPhoneNo) { }
                column(TotalVolume; TotalVolume) { }
                column(Page_Label; Page_Label) { }
                column(Box_Label; Box_Label) { }
                column(DocumentTitle; DocumentTitle) { }
                column(Parcel_Label; Parcel_Label) { }
                column(Type_Label; Type_Label) { }
                column(No_Label; No_Label) { }
                column(Variant_Label; Variant_Label) { }
                column(Description_Label; Description_Label) { }
                column(UM_Label; UM_Label) { }
                column(Qty_Label; Qty_Label) { }
                column(BoxNo_Label; BoxNo_Label) { }
                column(UnitNetWeight2_Label; UnitNetWeight2_Label) { }
                column(TotalNetWeight2_Label; TotalNetWeight2_Label) { }
                column(UnitGrossWeight2_Label; UnitGrossWeight2_Label) { }
                column(TotalGrossWeight2_Label; TotalGrossWeight2_Label) { }
                column(TotalVolume2_Label; TotalVolume2_Label) { }
                column(TotalParcel_Label; TotalParcel_Label) { }
                column(TotalNetWeight_Label; TotalNetWeight_Label) { }
                column(TotalGrossWeight_Label; TotalGrossWeight_Label) { }
                column(ShippingAddress_Label; ShippingAddress_Label) { }
                column(ManualNetWeight_Label; ManualNetWeight_Label) { }
                column(ManualGrossWeight_Label; ManualGrossWeight_Label) { }
                column(ManualVolume_Label; ManualVolume_Label) { }
                column(Company_Label; Company_Label) { }
                column(TariffNo_Label; TariffNo_Label) { }
                column(TotalGrossWeightItems_Label; TotalGrossWeightItems_Label) { }
                column(TotalExtraPackaging_Label; TotalExtraPackaging_Label) { }
                column(Title_Label; Title_Label) { }
                column(Tel_Label; Tel_Label) { }
                column(ItemRefrenceNo_Label; ItemRefrenceNo_Label) { }
                column(TotalVolume_Label; TotalVolume_Label) { }
                column(MandatoryDeliveryDate_Label; MandatoryDeliveryDate_Label) { }
                column(Packaging_Label; Packaging_Label) { }
                column(KgPerPack_Label; KgPerPack_Label) { }
                column(UnitPrice_Label; UnitPrice_Label) { }
                column(TotalAmount_Label; TotalAmount_Label) { }
                column(ProductionDate_Label; ProductionDate_Label) { }
                column(ExpDate_Label; ExpDate_Label) { }
                column(Origin_Label; Origin_Label) { }
                column(PrefOrigin_Label; PrefOrigin_Label) { }
                column(MandatoryDeliveryDate; MandatoryDeliveryDate) { }
                column(LotNo_Label; LotNo_Label) { }
                column(PalletNo_Label; PalletNo_Label) { }
                column(PalletPlacesNo_Label; PalletPlacesNo_Label) { }

                dataitem(PrintDetails; Integer)
                {
                    DataItemTableView = sorting(Number) order(ascending);

                    column(PrintDetails_Number; Number) { }
                    column(PrintDetails_ParcelNo; Temp_LabelBuffer_Details."Parcel No.") { }
                    column(PrintDetails_Type; Type) { }
                    column(PrintDetails_No; Temp_LabelBuffer_Details."No.") { }
                    column(PrintDetails_ItemNo; Temp_LabelBuffer_Details."Item No.") { }
                    column(PrintDetails_VariantCode; Temp_LabelBuffer_Details."Variant Code") { }
                    column(PrintDetails_Description; Temp_LabelBuffer_Details.Description) { }
                    column(PrintDetails_UnitOfMeasureCode; Temp_LabelBuffer_Details."Unit of Measure Code") { }
                    column(PrintDetails_Quantity; Temp_LabelBuffer_Details.Quantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(PrintDetails_DetailBoxNo; Temp_LabelBuffer_Details."Detail Box No.") { }
                    column(PrintDetails_UnitNetWeight; Temp_LabelBuffer_Details."Unit Net Weight") { }
                    column(PrintDetails_TotalNetWeight; Temp_LabelBuffer_Details."Total Net Weight")
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(PrintDetails_UnitGrossWeight; Temp_LabelBuffer_Details."Unit Gross Weight") { }
                    column(PrintDetails_TotalGrossWeight; Temp_LabelBuffer_Details."Total Gross Weight")
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(PrintDetails_UnitVolume; Temp_LabelBuffer_Details."Unit Volume") { }
                    column(PrintDetails_TotalVolume; Temp_LabelBuffer_Details."Total Volume")
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(PrintDetails_TariffNo; TariffNo) { }
                    column(PrintDetails_LotNo; Temp_LabelBuffer_Details."Lot No.") { }
                    column(PrintDetails_SerialNo; Temp_LabelBuffer_Details."Serial No.") { }
                    column(PrintDetails_ExpirationDate; Format(Temp_LabelBuffer_Details."Expiration Date", 10, '<Day,2>/<Month,2>/<Year4>')) { }
                    column(ItemReferenceNo; Temp_LabelBuffer_Details."Item Reference No.") { }
                    column(TrackingInfoLine; TrackingInfoLine) { }
                    column(LogUnitFormatDesc_Detail; LogUnitFormatDesc_Detail) { }
                    column(PrintDetails_SSCC; SSCC_Details) { }
                    column(PackagingText; PackagingText) { }
                    column(KgPerPack; KgPerPack)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(UnitLineAmount; UnitLineAmount)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(TotalLineAmount; TotalLineAmount)
                    {
                        DecimalPlaces = 0 : 2;
                    }
                    column(OriginCountryCode; OriginCountryRegion.Name) { }

                    trigger OnPreDataItem()
                    begin
                        Temp_LabelBuffer_Details.SetRange("Record Type", Temp_LabelBuffer_Master."Record Type"::Detail);
                        Temp_LabelBuffer_Details.SetRange("No.", Temp_LabelBuffer_Master."No.");
                        SetRange(Number, 1, Temp_LabelBuffer_Details.Count);
                    end;

                    trigger OnAfterGetRecord()
                    var
                        lItem: Record Item;
                        lSalesLine: Record "Sales Line";
                        lUnitofMeasure: Record "Unit of Measure";
                        lWarehouseShipmentLine: Record "Warehouse Shipment Line";
                        lPostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
                        lAWPLogisticUnitFormat: Record "AltAWPLogistic Unit Format";
                        lblItem: Label 'Item';
                    begin
                        if (Number = 1) then begin
                            Temp_LabelBuffer_Details.FindSet();
                        end else begin
                            Temp_LabelBuffer_Details.Next();
                        end;

                        Type := lblItem;
                        if (Temp_LabelBuffer_Details.Type = Temp_LabelBuffer_Details.Type::Box) then begin
                            Temp_LabelBuffer_Details."Detail Box No." := '';
                        end;

                        SerialBoxNo := Temp_LabelBuffer_Details."Detail Box No.";
                        if (Temp_LabelBuffer_Details."Serial No." <> '') then begin
                            if (SerialBoxNo <> '') then SerialBoxNo := SerialBoxNo + ' / ';
                            SerialBoxNo := SerialBoxNo + Temp_LabelBuffer_Details."Serial No.";
                        end;

                        if not lItem.Get(Temp_LabelBuffer_Details."Item No.") then Clear(lItem);
                        TariffNo := lItem."Tariff No.";

                        TrackingInfoLine := '';
                        if (Temp_LabelBuffer_Details."Lot No." <> '') then begin
                            TrackingInfoLine += LotNo_Label + ' ' + Temp_LabelBuffer_Details."Lot No.";
                        end;
                        if (Temp_LabelBuffer_Details."Serial No." <> '') then begin
                            if (TrackingInfoLine <> '') then TrackingInfoLine += ', ';
                            TrackingInfoLine += SN_Label + ' ' + Temp_LabelBuffer_Details."Serial No.";
                        end;
                        if (Temp_LabelBuffer_Details."Expiration Date" <> 0D) then begin
                            if (TrackingInfoLine <> '') then TrackingInfoLine += ', ';
                            TrackingInfoLine += ExpirationDate_Label + ' ' + Format(Temp_LabelBuffer_Details."Expiration Date", 10, '<Day,2>/<Month,2>/<Year4>');
                        end;

                        LogUnitFormatDesc_Detail := '';
                        if lAWPLogisticUnitFormat.Get(Temp_LabelBuffer_Details."Log. Unit Format Code") then begin
                            LogUnitFormatDesc_Detail := LogUnitFormat_Label + ' ' + lAWPLogisticUnitFormat.Description;
                        end;

                        SSCC_Details := '';
                        if (Temp_LabelBuffer_Details."GS1 SSCC Code" <> '') then SSCC_Details := SSCC_Label + ' ' + Temp_LabelBuffer_Details."GS1 SSCC Code";

                        KgPerPack := 0;
                        PackagingText := '';
                        if (lItem."ecNo. Consumer Units per Pkg." <> 0) and (lItem."ecWeight in Grams" <> 0) then begin
                            PackagingText := Format(lItem."ecNo. Consumer Units per Pkg.") + 'X' + Format(lItem."ecWeight in Grams");
                            KgPerPack := (lItem."ecNo. Consumer Units per Pkg." * lItem."ecWeight in Grams") / 1000;
                        end;

                        Clear(lSalesLine);
                        if (PostedWhseShipmentHeader."No." <> '') then begin
                            lPostedWhseShipmentLine.Get(Temp_LabelBuffer_Details."Whse. Document No.", Temp_LabelBuffer_Details."Whse. Document Line No.");
                            if (lPostedWhseShipmentLine."Source Document" = lPostedWhseShipmentLine."Source Document"::"Sales Order") then begin
                                lSalesLine.Get(lSalesLine."Document Type"::Order, lPostedWhseShipmentLine."Source No.", lPostedWhseShipmentLine."Source Line No.");
                            end;
                            if (lPostedWhseShipmentLine."AltAWPElement Type" = lPostedWhseShipmentLine."AltAWPElement Type"::Item) and
                                lUnitofMeasure.Get(lPostedWhseShipmentLine."Unit of Measure Code") and
                               (lUnitofMeasure."AltAWPType Unit Of Measure" = lUnitofMeasure."AltAWPType Unit Of Measure"::Parcels)
                            then begin
                                TotalParcels += Temp_LabelBuffer_Details.Quantity;
                            end;
                        end else begin
                            lWarehouseShipmentLine.Get(Temp_LabelBuffer_Details."Whse. Document No.", Temp_LabelBuffer_Details."Whse. Document Line No.");
                            if (lWarehouseShipmentLine."Source Document" = lWarehouseShipmentLine."Source Document"::"Sales Order") then begin
                                lSalesLine.Get(lSalesLine."Document Type"::Order, lWarehouseShipmentLine."Source No.", lWarehouseShipmentLine."Source Line No.");
                            end;
                            if (lWarehouseShipmentLine."AltAWPElement Type" = lWarehouseShipmentLine."AltAWPElement Type"::Item) and
                                lUnitofMeasure.Get(lWarehouseShipmentLine."Unit of Measure Code") and
                               (lUnitofMeasure."AltAWPType Unit Of Measure" = lUnitofMeasure."AltAWPType Unit Of Measure"::Parcels)
                            then begin
                                TotalParcels += Temp_LabelBuffer_Details.Quantity;
                            end;
                        end;

                        if (lSalesLine."Document No." <> '') then begin
                            UnitLineAmount := lSalesLine."Line Amount" / lSalesLine.Quantity;
                            TotalLineAmount := UnitLineAmount * Temp_LabelBuffer_Details.Quantity;
                            TotalDocumentAmount += TotalLineAmount;
                        end;

                        if not LotNoInformation.Get(Temp_LabelBuffer_Details."Item No.", Temp_LabelBuffer_Details."Variant Code", Temp_LabelBuffer_Details."Lot No.") then Clear(LotNoInformation);

                        Clear(OriginCountryRegion);
                        if (LotNoInformation."ecOrigin Country Code" <> '') then begin
                            OriginCountryRegion.Get(LotNoInformation."ecOrigin Country Code");
                        end;

                        TotalNetWeight_Details += Temp_LabelBuffer_Details."Total Net Weight";
                        TotalGrossWeight_Details += Temp_LabelBuffer_Details."Total Gross Weight";
                        TotalVolume_Details += Temp_LabelBuffer_Details."Total Volume";
                    end;
                }

                trigger OnPreDataItem()
                begin
                    Clear(CompanyInformation);
                    CompanyInformation.Get();
                    CompanyInformation.CalcFields(Picture);

                    Temp_LabelBuffer_Master.SetRange("Record Type", Temp_LabelBuffer_Master."Record Type"::Master);
                    SetRange(Number, 1, Temp_LabelBuffer_Master.Count);

                    TotalNetWeight_Details := 0;
                    TotalGrossWeight_Details := 0;
                    TotalVolume_Details := 0;
                    TotalParcels := 0;
                    TotalDocumentAmount := 0;
                end;

                trigger OnAfterGetRecord()
                var
                    lSalesInvoiceHeader: Record "Sales Invoice Header";
                    lAWPLogisticUnitFormat: Record "AltAWPLogistic Unit Format";
                    lATSSessionDataStore: Codeunit "AltATSSession Data Store";
                begin
                    if (Number = 1) then begin
                        Temp_LabelBuffer_Master.FindSet();
                    end else begin
                        Temp_LabelBuffer_Master.Next();
                    end;

                    Clear(PostedWhseShipmentHeader);
                    Clear(WarehouseShipmentHeader);
                    Clear(LogUnitsNo);
                    Clear(TotalNetWeight);
                    Clear(TotalGrossWeight);
                    Clear(TotalVolume);
                    Clear(ShipTo);
                    Clear(SellTo);

                    if PostedWhseShipmentHeader.Get(Temp_LabelBuffer_Master."Whse. Document No.") then begin
                        PrintFunctions.PostedWhseShipShipTo(ShipTo, PostedWhseShipmentHeader);
                        PrintFunctions.PostedWhseShipSellTo(SellTo, PostedWhseShipmentHeader);
                        LogUnitsNo := PostedWhseShipmentHeader."AltAWPParcel Units";
                        TotalNetWeight := PostedWhseShipmentHeader."AltAWPNet Weight";
                        TotalGrossWeight := PostedWhseShipmentHeader."AltAWPGross Weight";
                        TotalVolume := PostedWhseShipmentHeader."AltAWPTotal Volume";
                        PalletPlaces := PostedWhseShipmentHeader."AltAWPNo. Pallet Places";
                        MandatoryDeliveryDate := Format(PostedWhseShipmentHeader."AltAWPMandatory Delivery Date");
                    end else begin
                        WarehouseShipmentHeader.Get(Temp_LabelBuffer_Master."Whse. Document No.");
                        PrintFunctions.WhseShipShipTo(ShipTo, WarehouseShipmentHeader);
                        PrintFunctions.WhseShipSellTo(SellTo, WarehouseShipmentHeader);
                        LogUnitsNo := WarehouseShipmentHeader."AltAWPParcel Units";
                        TotalNetWeight := WarehouseShipmentHeader."AltAWPNet Weight";
                        TotalGrossWeight := WarehouseShipmentHeader."AltAWPGross Weight";
                        TotalVolume := WarehouseShipmentHeader."AltAWPTotal Volume";
                        PalletPlaces := WarehouseShipmentHeader."AltAWPNo. Pallet Places";
                        MandatoryDeliveryDate := Format(WarehouseShipmentHeader."AltAWPMandatory Delivery Date", 0, '<Day,2>/<Month,2>/<Year4>');
                    end;

                    DocumentTitle := ShippingDocumentNo_Label;
                    if (PostedWhseShipmentHeader."No." <> '') then begin
                        PrintFunctions.GetHeaderInformation(PostedWhseShipmentHeader."AltAWPBranch Code", PostedWhseShipmentHeader."Location Code", HeaderInformationArray, '');
                        DocumentText := StrSubstNo(lblDocumentNo, Temp_LabelBuffer_Master."Whse. Document No.", Temp_LabelBuffer_Master."Posting Date");
                    end else begin
                        PrintFunctions.GetHeaderInformation(WarehouseShipmentHeader."AltAWPBranch Code", WarehouseShipmentHeader."Location Code", HeaderInformationArray, '');
                        DocumentText := StrSubstNo(lblDocumentNo, Temp_LabelBuffer_Master."Whse. Document No.", WarehouseShipmentHeader."Posting Date");
                    end;

                    if (lATSSessionDataStore.GetSessionSettingValue('Print_PackingList_By_ShippingInvoiceNo') <> '') then begin
                        if lSalesInvoiceHeader.Get(lATSSessionDataStore.GetSessionSettingValue('Print_PackingList_By_ShippingInvoiceNo')) then begin
                            DocumentTitle := ShippingInvoiceNo_Label;
                            DocumentText := StrSubstNo(lblDocumentNo, lSalesInvoiceHeader."No.", lSalesInvoiceHeader."Posting Date");
                        end;
                    end;

                    LanguageCode := '';
                    DestPhoneNo := '';

                    case Temp_LabelBuffer_Master."Subject Type" of
                        Temp_LabelBuffer_Master."Subject Type"::Vendor:
                            begin
                                if Vendor.Get(Temp_LabelBuffer_Master."Subject No.") then begin
                                    DestPhoneNo := Vendor."Phone No.";
                                    LanguageCode := Vendor."Language Code";
                                end;
                            end;

                        Temp_LabelBuffer_Master."Subject Type"::Customer:
                            begin
                                if (Temp_LabelBuffer_Master."Subject Detail No." <> '') then begin
                                    if ShiptoAddress.Get(Temp_LabelBuffer_Master."Subject No.", Temp_LabelBuffer_Master."Subject Detail No.") then begin
                                        DestPhoneNo := ShiptoAddress."Phone No.";
                                    end;
                                end;
                                if Customer.Get(Temp_LabelBuffer_Master."Subject No.") and (DestPhoneNo = '') then begin
                                    DestPhoneNo := Customer."Phone No.";
                                    LanguageCode := Customer."Language Code";
                                end;
                            end;

                        Temp_LabelBuffer_Master."Subject Type"::Branch:
                            begin
                                Clear(Location);
                                if (Temp_LabelBuffer_Master."Subject Detail No." <> '') then begin
                                    if Location.Get(Temp_LabelBuffer_Master."Subject Detail No.") then;
                                end else begin
                                    if Location.Get(LogisticsFunctions.GetDefaultLocation(Temp_LabelBuffer_Master."Subject No.")) then;
                                end;

                                DestPhoneNo := Location."Phone No.";
                            end;
                    end;

                    LogUnitFormatDesc_Master := '';
                    if lAWPLogisticUnitFormat.Get(Temp_LabelBuffer_Master."Log. Unit Format Code") then begin
                        LogUnitFormatDesc_Master := LogUnitFormat_Label + ' ' + lAWPLogisticUnitFormat.Description;
                    end;

                    SSCC_Master := '';
                    if (Temp_LabelBuffer_Master."GS1 SSCC Code" <> '') then SSCC_Master := SSCC_Label + ' ' + Temp_LabelBuffer_Master."GS1 SSCC Code";

                    CurrReport.Language := PrintFunctions.GetReportLanguageCode(LanguageCode);
                end;
            }

            dataitem(GroupTotals; Integer)
            {
                DataItemTableView = sorting(Number) order(ascending);

                column(Correction_Number; Number) { }
                column(CorrWeightsVolumes_Label; CorrWeightsVolumes_Label) { }
                column(WeightAndVolumeAdj; WeightAndVolumeAdj) { }
                column(NetWeightDifference; NetWeightDifference)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(GrossWeightDifference; GrossWeightDifference)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(VolumeDifference; VolumeDifference)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(TotalParcel2; LogUnitsNo) { }
                column(TotalVolume_Details; TotalVolume_Details) { }
                column(TotalNetWeight; TotalNetWeight) { }
                column(TotalGrossWeight; TotalGrossWeight) { }
                column(HeaderCommentText; HeaderCommentText) { }
                column(PalletPlaces; PalletPlaces) { }
                column(TotalParcels; TotalParcels) { }
                column(TotalDocumentAmount; TotalDocumentAmount) { }
                column(AccompDataCaption_Text; AccompDataCaption_Text) { }
                column(AccompDataValue_Text; AccompDataValue_Text) { }

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1);
                end;

                trigger OnAfterGetRecord()
                var
                    lSalesInvoiceHeader: Record "Sales Invoice Header";
                    lATSSessionDataStore: Codeunit "AltATSSession Data Store";
                begin
                    WeightAndVolumeAdj := false;
                    NetWeightDifference := 0;
                    GrossWeightDifference := 0;
                    VolumeDifference := 0;

                    if (TotalNetWeight <> TotalNetWeight_Details) then begin
                        WeightAndVolumeAdj := true;
                        NetWeightDifference := TotalNetWeight - TotalNetWeight_Details;
                    end;
                    if (TotalGrossWeight <> TotalGrossWeight_Details) then begin
                        WeightAndVolumeAdj := true;
                        GrossWeightDifference := TotalGrossWeight - TotalGrossWeight_Details;
                    end;

                    Clear(HeaderCommentText);
                    if (lATSSessionDataStore.GetSessionSettingValue('Print_PackingList_By_ShippingInvoiceNo') <> '') then begin
                        if lSalesInvoiceHeader.Get(lATSSessionDataStore.GetSessionSettingValue('Print_PackingList_By_ShippingInvoiceNo')) then begin
                            HeaderCommentText := PrintFunctions.GetDocumentCommentHeader(lSalesInvoiceHeader, Report::"ecPacking List");
                        end;
                    end else begin
                        if (PostedWhseShipmentHeader."No." <> '') then begin
                            HeaderCommentText := PrintFunctions.GetDocumentCommentHeader(PostedWhseShipmentHeader, Report::"ecPacking List");
                        end else begin
                            HeaderCommentText := PrintFunctions.GetDocumentCommentHeader(WarehouseShipmentHeader, Report::"ecPacking List");
                        end;
                    end;

                    if (PostedWhseShipmentHeader."No." <> '') then begin
                        PrintFunctions.GetAccompData(PostedWhseShipmentHeader, AccompDataCaption_Text, AccompDataValue_Text);
                    end else begin
                        PrintFunctions.GetAccompData(WarehouseShipmentHeader, AccompDataCaption_Text, AccompDataValue_Text);
                    end;
                end;
            }

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1);
            end;
        }
    }

    trigger OnPreReport()
    begin
        DPSLoadLabelBuffer();
    end;

    var
        Temp_LabelBuffer_Master: Record "AltAWPLogistic Labels Buffer" temporary;
        Temp_LabelBuffer_Details: Record "AltAWPLogistic Labels Buffer" temporary;
        CompanyInformation: Record "Company Information";
        PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        Vendor: Record Vendor;
        Customer: Record Customer;
        Location: Record Location;
        ShiptoAddress: Record "Ship-to Address";
        LotNoInformation: Record "Lot No. Information";
        OriginCountryRegion: Record "Country/Region";
        LogisticsFunctions: Codeunit "AltAWPLogistics Functions";
        PrintFunctions: Codeunit "AltAWPPrint Functions";
        HeaderInformationArray: array[20] of Text;
        ShipTo: array[10] of Text;
        SellTo: array[10] of Text;
        DocumentTitle: Text;
        DocumentText: Text;
        DestPhoneNo: Text;
        SSCC_Master: Text;
        SSCC_Details: Text;
        TrackingInfoLine: Text;
        LogUnitFormatDesc_Master: Text;
        LogUnitFormatDesc_Detail: Text;
        Type: Text;
        SerialBoxNo: Text;
        MandatoryDeliveryDate: Text;
        HeaderCommentText: Text;
        AccompDataCaption_Text: Text;
        AccompDataValue_Text: Text;
        PackagingText: Text;
        TariffNo: Code[20];
        LanguageCode: Code[10];
        LogUnitsNo: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        KgPerPack: Decimal;
        TotalNetWeight_Details: Decimal;
        TotalGrossWeight_Details: Decimal;
        TotalVolume_Details: Decimal;
        NetWeightDifference: Decimal;
        GrossWeightDifference: Decimal;
        VolumeDifference: Decimal;
        UnitLineAmount: Decimal;
        TotalLineAmount: Decimal;
        TotalDocumentAmount: Decimal;
        PalletPlaces: Decimal;
        TotalParcels: Decimal;
        WeightAndVolumeAdj: Boolean;
        lblDocumentNo: Label '%1 of %2', Comment = '%1 del %2';
        Parcel_Label: Label 'HU No.', Comment = 'Collo';
        Type_Label: Label 'Type';
        No_Label: Label 'Item no.';
        Description_Label: Label 'Description';
        Packaging_Label: Label 'Packag.';
        KgPerPack_Label: Label 'Kg x Pack';
        UnitPrice_Label: Label 'Unit price';
        TotalAmount_Label: Label 'Total Amount';
        ProductionDate_Label: Label 'Prod. Date';
        ExpDate_Label: Label 'Exp. Date';
        Origin_Label: Label 'Origin';
        PrefOrigin_Label: Label 'Pref. Origin';
        UM_Label: Label 'UM';
        Qty_Label: Label 'Qty';
        BoxNo_Label: Label 'Box No.';
        UnitNetWeight2_Label: Label 'Unit Net Weight', Comment = 'Peso unit. netto';
        TotalNetWeight2_Label: Label 'Total Net Weight', Comment = 'Peso tot. netto';
        UnitGrossWeight2_Label: Label 'Unit Gross Weight', Comment = 'Peso unit. lordo';
        TotalGrossWeight2_Label: Label 'Total Gross Weight', Comment = 'Peso tot. lordo';
        Page_Label: Label 'Page';
        ShippingDocumentNo_Label: Label 'Shipping Document No.', Comment = 'Nr. Documento di Spedizione';
        ShippingInvoiceNo_Label: Label 'Shipping Invoice No.', Comment = 'Nr. Fattura Accompagnatoria';
        ShippingAddress_Label: Label 'Destination', Comment = 'Destinazione';
        Company_Label: Label 'Recipient', Comment = 'Spettabile';
        TotalParcel_Label: Label 'Parcel No.', Comment = 'Totale colli';
        PalletNo_Label: Label 'Logistics units no.';
        PalletPlacesNo_Label: Label 'No. of Pallet Places';
        TotalNetWeight_Label: Label 'Tot. Net Weight', Comment = 'Totale peso netto';
        TotalGrossWeight_Label: Label 'Tot. Gross Weight', Comment = 'Totale peso lordo';
        TariffNo_Label: Label 'Tariff No.', Comment = 'Nomenclatura combinata';
        TotalGrossWeightItems_Label: Label 'Total Gross Weight (Items)', Comment = 'Totale peso lordo (articoli)';
        TotalExtraPackaging_Label: Label 'Total Extra Packaging', Comment = 'Totale imagallaggio extra';
        Title_Label: Label 'PACKING LIST';
        Tel_Label: Label 'Phone:', Comment = 'Tel.';
        Box_Label: Label 'Box';
        SN_Label: Label 'SN:';
        LotNo_Label: Label 'Lot';
        SSCC_Label: Label 'SSCC:';
        LogUnitFormat_Label: Label 'Format:';
        TotalVolume_Label: Label 'Total Volume';
        TotalVolume2_Label: Label 'Total Volume';
        ManualNetWeight_Label: Label 'Manual Net Weight';
        ManualGrossWeight_Label: Label 'Manual Gross Weight';
        ManualVolume_Label: Label 'Manual Volume';
        Variant_Label: Label 'Item variant: ';
        ItemRefrenceNo_Label: Label 'Item ref. no.';
        ExpirationDate_Label: Label 'Expiration date:';
        CorrWeightsVolumes_Label: Label 'Correction of weights';
        MandatoryDeliveryDate_Label: Label 'Mandatory delivery date:';

    procedure SetLabelBuffer(var Temp_pLabelBuffer: Record "AltAWPLogistic Labels Buffer" temporary)
    begin
        Temp_LabelBuffer_Master.Copy(Temp_pLabelBuffer, true);
        Temp_LabelBuffer_Details.Copy(Temp_pLabelBuffer, true);
    end;

    local procedure DPSLoadLabelBuffer()
    var
        ldpsPrintRequest: Record "AltDPSPrint Request";
        ldpsDirectPrintService: Codeunit "AltDPSDirectPrint Service";
        lRecordRef: RecordRef;
    begin
        if Temp_LabelBuffer_Master.IsEmpty then begin
            if ldpsDirectPrintService.ReportCalledByDPS(Report::"AltAWPShipping Pallet Label") then begin
                if ldpsDirectPrintService.GetCurrentPrintRequest(ldpsPrintRequest) then begin
                    lRecordRef.GetTable(Temp_LabelBuffer_Master);
                    if ldpsPrintRequest.LoadReportData(lRecordRef) then begin
                        Temp_LabelBuffer_Details.Copy(Temp_LabelBuffer_Master, true);
                    end;
                end;
            end;
        end;
    end;
}