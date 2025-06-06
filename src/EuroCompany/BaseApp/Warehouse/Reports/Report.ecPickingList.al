namespace EuroCompany.BaseApp.Warehouse.Reports;
using EuroCompany.BaseApp.Inventory;
using Microsoft.Foundation.Shipping;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Transfer;
using Microsoft.Purchases.Document;
using Microsoft.Sales.Document;
using Microsoft.Warehouse.Activity;
using Microsoft.Warehouse.Document;

report 50024 "ecPicking - List"
{
    ApplicationArea = All;
    Caption = 'Picking List';
    DefaultLayout = RDLC;
    Description = 'CS_REP_001';
    PreviewMode = PrintLayout;
    RDLCLayout = '.\src\EuroCompany\BaseApp\Warehouse\Reports\PickingList.Layout.rdlc';
    UsageCategory = None;
    dataset
    {
        dataitem(WarehouseActivityHeader; "Warehouse Activity Header")
        {
            DataItemTableView = sorting(Type, "No.")
                                where(Type = filter(Pick | "Invt. Pick"));
            RequestFilterFields = "No.", "No. Printed";
            column("Filter"; WarehouseActivityHeader.TableCaption + ': ' + PickFilter)
            {
            }
            column(CompanyName; CompanyName)
            {
            }
            column(Date; Format(Today, 0, 4))
            {
            }
            column(HeaderBarcode; ImageBase64String)
            {
            }
            column(HeaderBarcodeString; HeaderBarcodeString)
            {
            }
            column(HeaderCommentText; HeaderCommentText)
            {
            }
            column(InvtPick; InvtPick)
            {
            }
            column(IsProductionPick; IsProductionPick)
            {
            }
            column(lblActivityWhseNo; lblActivityWhseNo)
            {
            }
            column(lblAreaCode; lblAreaCode)
            {
            }
            column(lblBinCode; lblBinCode)
            {
            }
            column(lblCity; lblCity)
            {
            }
            column(lblDepotCode; lblDepotCode)
            {
            }
            column(lblDescription; lblDescription)
            {
            }
            column(lblDocumentDate; lblDocumentDate)
            {
            }
            column(lblDocumentNo; lblDocumentNo)
            {
            }
            column(lblIDRow; lblIDRow)
            {
            }
            column(lblItemNo; lblItemNo)
            {
            }
            column(lblLocationCode; lblLocationCode)
            {
            }
            column(lblLotNo; lblLotNo)
            {
            }
            column(lblManagedQty; lblManagedQty)
            {
            }
            column(lblName; lblName)
            {
            }
            column(lblPage; lblPage)
            {
            }
            column(lblPickingBins; lblPickingBins)
            {
            }
            column(lblQuantity; lblQuantity)
            {
            }
            column(lblSerialNo; lblSerialNo)
            {
            }
            column(lblShippingAgent; lblShippingAgent)
            {
            }
            column(lblShippingGroup; lblShippingGroup)
            {
            }
            column(lblSourceDocument; lblSourceDocument)
            {
            }
            column(lblSourceNo; lblSourceNo)
            {
            }
            column(lblSourceReference; lblSourceReference)
            {
            }
            column(lblSourceType; lblSourceType)
            {
            }
            column(lblTitle; lblTitle)
            {
            }
            column(lblUM; lblUM)
            {
            }
            column(lblVariant; lblVariant)
            {
            }
            column(lblWhseShipNo; lblWhseShipNo)
            {
            }
            column(PickFilter; PickFilter)
            {
            }
            column(ShippingAgent_Name; ShipAgentName)
            {
            }
            column(TextHeaderArray1_1; TextHeaderArray[1] [1])
            {
            }
            column(TextHeaderArray1_2; TextHeaderArray[1] [2])
            {
            }
            column(TextHeaderArray2_1; TextHeaderArray[2] [1])
            {
            }
            column(TextHeaderArray2_2; TextHeaderArray[2] [2])
            {
            }
            column(TextHeaderArray3_1; TextHeaderArray[3] [1])
            {
            }
            column(TextHeaderArray3_2; TextHeaderArray[3] [2])
            {
            }
            column(TextHeaderArray4_1; TextHeaderArray[4] [1])
            {
            }
            column(TextHeaderArray4_2; TextHeaderArray[4] [2])
            {
            }
            column(TextHeaderArray5_1; TextHeaderArray[5] [1])
            {
            }
            column(TextHeaderArray5_2; TextHeaderArray[5] [2])
            {
            }
            column(TextHeaderArray6_1; TextHeaderArray[6] [1])
            {
            }
            column(TextHeaderArray6_2; TextHeaderArray[6] [2])
            {
            }
            column(TextHeaderArray7_1; TextHeaderArray[7] [1])
            {
            }
            column(TextHeaderArray7_2; TextHeaderArray[7] [2])
            {
            }
            column(TextHeaderArray8_1; TextHeaderArray[8] [1])
            {
            }
            column(TextHeaderArray8_2; TextHeaderArray[8] [2])
            {
            }
            column(TextHeaderArray9_1; TextHeaderArray[9] [1])
            {
            }
            column(TextHeaderArray9_2; TextHeaderArray[9] [2])
            {
            }
            column(TextHeaderArray10_1; TextHeaderArray[10] [1])
            {
            }
            column(TextHeaderArray10_2; TextHeaderArray[10] [2])
            {
            }
            column(TextHeaderArray11_1; TextHeaderArray[11] [1])
            {
            }
            column(TextHeaderArray11_2; TextHeaderArray[11] [2])
            {
            }
            column(TextHeaderArray12_1; TextHeaderArray[12] [1])
            {
            }
            column(TextHeaderArray12_2; TextHeaderArray[12] [2])
            {
            }
            column(TitleText; TitleText)
            {
            }
            column(TitleText02; TitleText02)
            {
            }
            column(UserID; PrintFunctions.GetShortUserID(UserId, 50))
            {
            }
            column(WarehouseActivityHeader_DepotCode; "AltAWPBranch Code")
            {
            }
            column(WarehouseActivityHeader_LocationCode; LocationName)
            {
            }
            column(WarehouseActivityHeader_No; "No.")
            {
            }
            column(WarehouseActivityHeader_Type; Type)
            {
            }
            column(WarehouseShipmentHeader_City; WarehouseShipmentHeader."AltAWPShip-to City")
            {
            }
            column(WarehouseShipmentHeader_County; ShipToCountyText)
            {
            }
            column(WarehouseShipmentHeader_DeliveryAreaCode; NameDeliveryArea)
            {
            }
            column(WarehouseShipmentHeader_No; WarehouseShipmentHeader."No.")
            {
            }
            column(WarehouseShipmentHeader_ShippingGroupNo; WarehouseShipmentHeader."AltAWPShipping Group No.")
            {
            }
            column(WarehouseShipmentHeader_SourceDocumentType; SourceDocumentText)
            {
            }
            column(WarehouseShipmentHeader_SubjectName; WarehouseShipmentHeader."AltAWPShip-to Name")
            {
            }
            column(WarehouseShipmentHeader_SubjectNo; WarehouseShipmentHeader."AltAWPSubject No.")
            {
            }
            column(WarehouseShipmentHeader_SubjectType; SubjectTypeText)
            {
            }
            column(AWPGeneralSetup_Printbarcodelogdocuments; AWPGeneralSetup."Print barcode log. documents")
            {
            }
            dataitem(WarehouseActivityLine; "Warehouse Activity Line")
            {
                DataItemLink = "Activity Type" = field(Type),
                               "No." = field("No.");
                DataItemTableView = sorting("Bin Code", "Location Code", "Action Type", "Breakbulk No.")
                                      where("Action Type" = const(Take));
                column(ActionTypeInt; ActionTypeInt)
                {
                }
                column(Barcode; WMSEntryNo_B64)
                {
                }
                column(Barcode2; Barcode)
                {
                }
                column(ItemBarcode; ItemBarcode_B64)
                {
                }
                column(PickingBins; PickingBins)
                {
                }
                column(WarehouseActivityLine_BinCode; "Bin Code")
                {
                }
                column(WarehouseActivityLine_Description; Description + ' ' + "Description 2")
                {
                }
                column(WarehouseActivityLine_DocDate; Format(DocDate, 0, '<Day,2>/<Month,2>/<Year4>'))
                {
                }
                column(WarehouseActivityLine_ItemNo; "Item No.")
                {
                }
                column(WarehouseActivityLine_LineNo; "Line No.")
                {
                }
                column(WarehouseActivityLine_LotNo; "Lot No.")
                {
                }
                column(WarehouseActivityLine_No; "No.")
                {
                }
                column(WarehouseActivityLine_Quantity; Quantity)
                {
                }
                column(WarehouseActivityLine_SerialNo; "Serial No.")
                {
                }
                column(WarehouseActivityLine_SourceLineNo; "Source Line No.")
                {
                }
                column(WarehouseActivityLine_SourceNo; "Source No.")
                {
                }
                column(WarehouseActivityLine_Type; "Activity Type")
                {
                }
                column(WarehouseActivityLine_UnitOfMeasureCode; "Unit of Measure Code")
                {
                }
                column(WarehouseActivityLine_VariantCode; "Variant Code")
                {
                }
                column(ShipmentInformations; ShipmentInformations)
                {
                }
                column(WarehouseActivityLine_WhseDocumentNo; "Whse. Document No.")
                {
                }
                trigger OnAfterGetRecord()
                var
                    lLogistcFunctions: Codeunit "ecLogistc Functions";
                begin
                    ActionTypeInt := WarehouseActivityLine."Action Type".AsInteger();

                    Clear(DocDate);
                    if ("Source Document" = "Source Document"::"Sales Order") or
                       ("Source Document" = "Source Document"::"Sales Return Order") then begin

                        case ("Source Document") of
                            "Source Document"::"Sales Order":
                                SalesHeader.Get(SalesHeader."Document Type"::Order, "Source No.");
                            "Source Document"::"Sales Return Order":
                                SalesHeader.Get(SalesHeader."Document Type"::"Return Order", "Source No.");
                        end;

                        DocDate := SalesHeader."Order Date";
                    end;

                    if ("Source Document" = "Source Document"::"Purchase Order") or
                       ("Source Document" = "Source Document"::"Purchase Return Order") then begin

                        case ("Source Document") of
                            "Source Document"::"Purchase Order":
                                PurchaseHeader.Get(SalesHeader."Document Type"::Order, "Source No.");
                            "Source Document"::"Purchase Return Order":
                                PurchaseHeader.Get(SalesHeader."Document Type"::"Return Order", "Source No.");
                        end;

                        DocDate := PurchaseHeader."Order Date";
                    end;

                    if ("Source Document" = "Source Document"::"Outbound Transfer") then begin
                        TransferHeader.Get(WarehouseActivityLine."Source No.");
                        DocDate := TransferHeader."Shipment Date";
                    end;


                    Clear(WMSEntryNo_B64);
                    Barcode := '';
                    awpWMSIntegrationMgt.AssignWMSEntryNo2WhseActivitytLine(WarehouseActivityLine);
                    Barcode := BarcodeSetup."Document Line Barcode Prefix" + BarcodeSetup."Barcode Elements Separator" + Format("AltAWPWMS Entry No.", 10, '<Integer,10><Filler Character,0>');
                    if GenerateBarcode and AWPGeneralSetup."Print barcode log. documents" then begin
                        WMSEntryNo_B64 := BarcodeFunctions.MakeBarcode(Barcode, Enum::"AltATSBarcode Symbology"::"Code 128", 1, 20, false, 0);
                    end;

                    Clear(ItemBarcode_B64);
                    ItemBarcode := '';
                    awpWMSIntegrationMgt.AssignWMSEntryNo2WhseActivitytLine(WarehouseActivityLine);
                    ItemBarcode := BarcodeSetup."Item Barcode Prefix" + BarcodeSetup."Barcode Elements Separator" + WarehouseActivityLine."Item No.";
                    if GenerateBarcode and AWPGeneralSetup."Print barcode log. documents" then begin
                        ItemBarcode_B64 := BarcodeFunctions.MakeBarcode(ItemBarcode, Enum::"AltATSBarcode Symbology"::"Code 128", 1, 20, false, 0);
                    end;

                    ShipmentInformations := lLogistcFunctions.GetItemShipmentInfoText(WarehouseActivityLine."Item No.",
                                                                                      WarehouseActivityLine."Variant Code",
                                                                                      WarehouseShipmentHeader."AltAWPSubject Type",
                                                                                      WarehouseShipmentHeader."AltAWPSubject No.");

                    FindPickingBins();
                end;
            }

            trigger OnAfterGetRecord()
            var
                lLocation: Record Location;
                lShipAgent: Record "Shipping Agent";
                lWarehouseActivityLine: Record "Warehouse Activity Line";
            begin
                InvtPick := Type = Type::"Invt. Pick";

                if not CurrReport.Preview then
                    WhseCountPrinted.Run(WarehouseActivityHeader);

                HeaderBarcodeString := BarcodeSetup."Document Barcode Prefix" + BarcodeSetup."Barcode Elements Separator" + "No.";
                if GenerateBarcode then begin
                    ImageBase64String := BarcodeFunctions.MakeBarcode(HeaderBarcodeString, Enum::"AltATSBarcode Symbology"::"Code 128", 1, 20, false, 0);
                end;


                ShipAgentName := '';
                NameDeliveryArea := '';

                Clear(lWarehouseActivityLine);
                lWarehouseActivityLine.SetRange("Activity Type", lWarehouseActivityLine."Activity Type"::Pick);
                lWarehouseActivityLine.SetRange("No.", WarehouseActivityHeader."No.");
                if lWarehouseActivityLine.FindFirst() then begin
                    if WarehouseShipmentHeader.Get(lWarehouseActivityLine."Whse. Document No.") then begin
                        if (WarehouseShipmentHeader."Shipping Agent Code" <> '') then begin
                            if lShipAgent.Get(WarehouseShipmentHeader."Shipping Agent Code") then begin
                                ShipAgentName := lShipAgent.Code;
                                if (lShipAgent.Name <> '') then begin
                                    ShipAgentName := lShipAgent.Code + ' - ' + lShipAgent.Name;
                                end;
                            end;
                        end;

                        NameDeliveryArea := WarehouseShipmentHeader."AltAWPDelivery Area Code";
                        if (WarehouseShipmentHeader."AltAWPDelivery Area Code" <> '') then begin
                            WarehouseShipmentHeader.CalcFields("AltAWPDelivery Area Name");
                            if (WarehouseShipmentHeader."AltAWPDelivery Area Name" <> '') then begin
                                NameDeliveryArea := NameDeliveryArea + ' - ' + WarehouseShipmentHeader."AltAWPDelivery Area Name";
                            end;
                        end;
                    end else begin
                        Clear(WarehouseShipmentHeader);
                    end;
                end;

                if lLocation.Get("Location Code") then begin
                    LocationName := lLocation.Code;
                    if (lLocation.Name <> '') then begin
                        LocationName := LocationName + ' - ' + lLocation.Name;
                    end;
                end;

                ShipToCountyText := '';
                if (WarehouseShipmentHeader."AltAWPShip-to County" <> '') then begin
                    ShipToCountyText := ' (' + WarehouseShipmentHeader."AltAWPShip-to County" + ')';
                end;

                SourceDocumentText := Format(WarehouseShipmentHeader."AltAWPSource Document Type");
                SubjectTypeText := Format(WarehouseShipmentHeader."AltAWPSubject Type");

                GetHeaderLabel();


                Clear(HeaderCommentText);
                HeaderCommentText := PrintFunctions.GetDocumentCommentHeader(WarehouseActivityHeader, Report::"AltAWPPicking - List");
            end;

            trigger OnPreDataItem()
            begin
                BarcodeSetup.GetGeneralSetup();
                BarcodeSetup.TestField("Document Barcode Prefix");
                BarcodeSetup.TestField("Document Line Barcode Prefix");
                BarcodeSetup.TestField("Barcode Elements Separator");

                GenerateBarcode := PrintFunctions.CheckGenerateBarcode();
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        PickFilter := WarehouseActivityHeader.GetFilters;
        AWPGeneralSetup.Get();
    end;

    local procedure GetHeaderLabel()
    var
        lIndex: Integer;
    begin
        Clear(TextHeaderArray);
        Clear(lIndex);
        TitleText := lblTitle;
        if not IsProductionPick then begin
            for lIndex := 1 to 12 do begin
                case lIndex of
                    1:
                        begin
                            TextHeaderArray[lIndex] [1] := lblActivityWhseNo;
                            TextHeaderArray[lIndex] [2] := WarehouseActivityHeader."No.";
                        end;
                    2:
                        begin
                            TextHeaderArray[lIndex] [1] := lblWhseShipNo;
                            TextHeaderArray[lIndex] [2] := WarehouseShipmentHeader."No.";
                        end;
                    3:
                        begin
                            TextHeaderArray[lIndex] [1] := lblDepotCode;
                            TextHeaderArray[lIndex] [2] := WarehouseActivityHeader."AltAWPBranch Code";
                        end;
                    4:
                        begin
                            TextHeaderArray[lIndex] [1] := lblLocationCode;
                            TextHeaderArray[lIndex] [2] := LocationName;
                        end;
                    5:
                        begin
                            TextHeaderArray[lIndex] [1] := lblSourceDocument;
                            TextHeaderArray[lIndex] [2] := SourceDocumentText;
                        end;
                    6:
                        begin
                            TextHeaderArray[lIndex] [1] := lblSourceType;
                            TextHeaderArray[lIndex] [2] := SubjectTypeText;
                        end;
                    7:
                        begin
                            TextHeaderArray[lIndex] [1] := lblSourceNo;
                            TextHeaderArray[lIndex] [2] := WarehouseShipmentHeader."AltAWPSubject No.";
                        end;
                    8:
                        begin
                            TextHeaderArray[lIndex] [1] := lblName;
                            TextHeaderArray[lIndex] [2] := WarehouseShipmentHeader."AltAWPShip-to Name";
                        end;
                    9:
                        begin
                            TextHeaderArray[lIndex] [1] := lblShippingGroup;
                            TextHeaderArray[lIndex] [2] := WarehouseShipmentHeader."AltAWPShipping Group No.";
                        end;
                    10:
                        begin
                            TextHeaderArray[lIndex] [1] := lblCity;
                            TextHeaderArray[lIndex] [2] := WarehouseShipmentHeader."AltAWPShip-to City" + ' ' + WarehouseShipmentHeader."AltAWPShip-to County";
                        end;
                    11:
                        begin
                            TextHeaderArray[lIndex] [1] := lblAreaCode;
                            TextHeaderArray[lIndex] [2] := NameDeliveryArea;
                        end;
                    12:
                        begin
                            TextHeaderArray[lIndex] [1] := lblShippingAgent;
                            TextHeaderArray[lIndex] [2] := ShipAgentName;
                        end;
                end;
            end;
            TitleText02 := WarehouseShipmentHeader."AltAWPShip-to Name";

        end else begin
            TitleText := lblTitle2;
            for lIndex := 1 to 7 do begin
                case lIndex of
                    1:
                        begin
                            TextHeaderArray[lIndex] [1] := lblActivityWhseNo;
                            TextHeaderArray[lIndex] [2] := WarehouseActivityHeader."No.";
                        end;
                    2:
                        begin
                            TextHeaderArray[lIndex] [1] := lblDepotCode;
                            TextHeaderArray[lIndex] [2] := WarehouseActivityHeader."AltAWPBranch Code";
                        end;
                    3:
                        begin
                            TextHeaderArray[lIndex] [1] := lblLocationCode;
                            TextHeaderArray[lIndex] [2] := LocationName;
                        end;

                    4:
                        begin
                        end;

                    5:
                        begin
                            TextHeaderArray[lIndex] [1] := lblSourceDocType;
                            TextHeaderArray[lIndex] [2] := SourceDocumentText;
                        end;
                    6:
                        begin
                            if (WarehouseActivityHeader."AltAWPWhse. Document No." <> '') then begin
                                TextHeaderArray[lIndex] [1] := lblSourceDocumentNo;
                                TextHeaderArray[lIndex] [2] := WarehouseActivityHeader."AltAWPWhse. Document No.";
                            end else begin

                                TextHeaderArray[lIndex] [1] := lblProductionBin;
                            end;
                        end;
                end;
            end;
        end;
    end;

    local procedure FindPickingBins()
    var
        lawpWhseDocumentsMgt: Codeunit "AltAWPWhse. Documents Mgt.";
    begin
        PickingBins := lawpWhseDocumentsMgt.GetWhseActivityLinePickingBinsString(WarehouseActivityLine, 3);
    end;

    var
        PurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        TransferHeader: Record "Transfer Header";
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        BarcodeSetup: Record "AltAWPBarcode Setup";
        AWPGeneralSetup: Record "AltAWPGeneral Setup";
        BarcodeFunctions: Codeunit "AltAWPBarcode Functions";
        WhseCountPrinted: Codeunit "Whse.-Printed";
        PrintFunctions: Codeunit "AltAWPPrint Functions";
        awpWMSIntegrationMgt: Codeunit "AltAWPWMS Integration Mgt.";
        ActionTypeInt: Integer;
        Barcode: Text;
        HeaderBarcodeString: Text;
        ImageBase64String: Text;
        ItemBarcode: Text;
        LocationName: Text;
        NameDeliveryArea: Text;
        ShipmentInformations: Text;
        PickFilter: Text;
        PickingBins: Text;
        ShipToCountyText: Text;
        SourceDocumentText: Text;
        SubjectTypeText: Text;
        TextHeaderArray: array[12, 12] of Text;
        TitleText: Text;
        TitleText02: Text;
        ShipAgentName: Text[50];
        HeaderCommentText: Text;
        WMSEntryNo_B64: Text;
        ItemBarcode_B64: Text;
        DocDate: Date;
        GenerateBarcode: Boolean;
        InvtPick: Boolean;
        IsProductionPick: Boolean;
        lblActivityWhseNo: Label 'Activity Whse. No.';
        lblAreaCode: Label 'Area Code:';
        lblBinCode: Label 'Bin Code';
        lblCity: Label 'City:';
        lblDepotCode: Label 'Depot Code';
        lblDescription: Label 'Description';
        lblDocumentDate: Label 'Document Date';
        lblDocumentNo: Label 'Document No.';
        lblIDRow: Label 'ID Row';
        lblItemNo: Label 'Item No.';
        lblLocationCode: Label 'Location Code';
        lblLotNo: Label 'Lot no.';
        lblManagedQty: Label 'Managed Q.ty';
        lblName: Label 'Name:';
        lblPage: Label 'Page';
        lblPickingBins: Label 'Bins:', Comment = 'Collocazioni:';
        lblProductionBin: Label 'Bin:', Comment = 'Collocazione:';
        lblQuantity: Label 'Quantity';
        lblSerialNo: Label 'Serial no.';
        lblShippingAgent: Label 'Shipping Agent:';
        lblShippingGroup: Label 'Shipping group:';
        lblSourceDocType: Label 'Source Doc. Type:';
        lblSourceDocument: Label 'Source Document:';
        lblSourceDocumentNo: Label 'Source Doc. No.:';
        lblSourceNo: Label 'Source No.:';
        lblSourceReference: Label 'Source Reference';
        lblSourceType: Label 'Source Type';
        lblTitle: Label 'PICKING LIST';
        lblTitle2: Label 'PICKING FOR PRODUCTION', Comment = 'PRELIEVO PER PRODUZIONE';
        lblUM: Label 'UM';
        lblVariant: Label 'Variant';
        lblWhseShipNo: Label 'Whse. Shipment No:';
}

