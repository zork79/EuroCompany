namespace EuroCompany.BaseApp.Warehouse.Reports;

using EuroCompany.BaseApp.Inventory;
using Microsoft.Foundation.Shipping;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Tracking;
using Microsoft.Warehouse.Document;
using Microsoft.Warehouse.Structure;
using System.Utilities;

report 50023 "ecWarehouse Shipment"
{
    ApplicationArea = All;
    Caption = 'Warehouse Shipment';
    DefaultLayout = RDLC;
    Description = 'CS_REP_001';
    PreviewMode = PrintLayout;
    RDLCLayout = '.\src\EuroCompany\BaseApp\Warehouse\Reports\WarehouseShipment.Layout.rdlc';
    UsageCategory = None;

    dataset
    {
        dataitem(WarehouseShipmentHeader; "Warehouse Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
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
            column(lblAreaCode; lblAreaCode)
            {
            }
            column(lblBin; lblBin)
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
            column(lblItem; lblItem)
            {
            }
            column(lblLocation; lblLocation)
            {
            }
            column(lblLocationCode; lblLocationCode)
            {
            }
            column(lblName; lblName)
            {
            }
            column(lblPage; lblPage)
            {
            }
            column(lblPDCNotes; lblPDCNotes)
            {
            }
            column(lblQtyNotPicked; lblQtyNotPicked)
            {
            }
            column(lblQuantity; lblQuantity)
            {
            }
            column(lblShipmentDate; lblShipmentDate)
            {
            }
            column(lblShipmentNotes; lblShipmentNotes)
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
            column(lblTipoDocSpedizione; lblTipoDocSpedizione)
            {
            }
            column(lblTitle; lblTitle)
            {
            }
            column(lblTotalPallets; lblTotalPallets)
            {
            }
            column(lblUM; lblUM)
            {
            }
            column(lblVariant; lblVariant)
            {
            }
            column(PDCNotestText; PDCNotestText)
            {
            }
            column(ShippingAgent_Name; ShipAgentName)
            {
            }
            column(SubjectType_No; SubjectType_No)
            {
            }
            column(TextReprinted; TextReprinted)
            {
            }
            column(TipoDocSpedizione; TipoDocSpedizione)
            {
            }
            column(UserID; PrintFunctions.GetShortUserID(UserId, 50))
            {
            }
            column(WarehouseShipmentHeader_Barcode; ImageBase64String)
            {
            }
            column(WarehouseShipmentHeader_DeliveryAreaCode; NameDeliveryArea)
            {
            }
            column(WarehouseShipmentHeader_DepotCode; "AltAWPBranch Code")
            {
            }
            column(WarehouseShipmentHeader_LocationCode; LocationName)
            {
            }
            column(WarehouseShipmentHeader_No; "No.")
            {
            }
            column(WarehouseShipmentHeader_ShippingGroupNo; "AltAWPShipping Group No.")
            {
            }
            column(WarehouseShipmentHeader_ShippingWeek; ShippingWeek)
            {
            }
            column(WarehouseShipmentHeader_ShipToCity; "AltAWPShip-to City")
            {
            }
            column(WarehouseShipmentHeader_ShipToCounty; ShipToCountyText)
            {
            }
            column(WarehouseShipmentHeader_SourceDocumentType; "AltAWPSource Document Type")
            {
            }
            column(WarehouseShipmentHeader_SubjectName; "AltAWPShip-to Name")
            {
            }
            column(WarehouseShipmentHeader_SubjectNo; "AltAWPSubject No.")
            {
            }
            column(WarehouseShipmentHeader_SubjectType; "AltAWPSubject Type")
            {
            }
            column(WarehouseShipmentHeader_ShippingSequenceNo; WarehouseShipmentHeader."AltAWPShipping Sequence No.")
            {
            }
            column(AWPGeneralSetup_Printbarcodelogdocuments; AWPGeneralSetup."Print barcode log. documents")
            {
            }
            dataitem(WarehouseShipmentLine; "Warehouse Shipment Line")
            {
                DataItemLink = "No." = field("No.");
                DataItemTableView = sorting("No.", "Line No.")
                                    where("AltAWPElement Type" = filter(<> ' '));
                column(Barcode; WMSEntryNo_B64)
                {
                }
                column(Barcode2; Barcode)
                {
                }
                column(CustomerCrossReference; CustomerCrossReference)
                {
                }
                column(ItemBarcode; ItemBarcode_B64)
                {
                }
                column(ServiceText; ServiceText)
                {
                }
                column(WarehouseShipmentLine_Description; Description)
                {
                }
                column(WarehouseShipmentLine_Description2; "Description 2")
                {
                }
                column(WarehouseShipmentLine_ItemNo; "Item No.")
                {
                }
                column(WarehouseShipmentLine_LineNo; "Line No.")
                {
                }
                column(WarehouseShipmentLine_LocationCode; "Location Code")
                {
                }
                column(WarehouseShipmentLine_No; "No.")
                {
                }
                column(WarehouseShipmentLine_PalletNo; PalletNo)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(WarehouseShipmentLine_QtyNotPicked; Quantity - "Qty. Picked")
                {
                }
                column(WarehouseShipmentLine_Quantity; Quantity)
                {
                }
                column(WarehouseShipmentLine_SourceLineNo; "Source Line No.")
                {
                }
                column(WarehouseShipmentLine_SourceNo; "Source No.")
                {
                }
                column(WarehouseShipmentLine_UnitOfMeasureCode; "Unit of Measure Code")
                {
                }
                column(WarehouseShipmentLine_VariantCode; "Variant Code")
                {
                }
                column(ShipmentInformations; ShipmentInformations)
                {
                }
                dataitem(PrintTrackingInfo; Integer)
                {
                    DataItemTableView = sorting(Number)
                                        order(ascending);
                    column(TrkInfo; TrkInfo)
                    {
                    }
                    column(TrkInfo_EntryNo; Number)
                    {
                    }
                    column(TrkInfoPB; TrkInfoPB)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        lItem: Record Item;
                        lTxt001: Label 'Lot: %1 - %2 %3', Comment = 'Lotto: %1 - %2 %3';
                        lTxt002: Label 'SN: %1 - %2 %3', Comment = 'SN: %1 - %2 %3';
                        lTxt003: Label 'Lot: %1 SN: %2 - %3 %4', Comment = 'Lotto: %1 SN: %2 - %3 %4';
                    begin
                        if (Number > 1) then begin
                            Temp_TrackingSpecification.Next();
                            Barcode := '';
                            ServiceText := '';
                        end;

                        TrkInfo := '';
                        TrkInfoPB := '';

                        if not lItem.Get(WarehouseShipmentLine."AltAWPElement No.") then Clear(lItem);

                        case true of
                            (Temp_TrackingSpecification."Lot No." <> '') and (Temp_TrackingSpecification."Serial No." <> ''):
                                TrkInfo := StrSubstNo(lTxt003, Temp_TrackingSpecification."Lot No.", Temp_TrackingSpecification."Serial No.", lItem."Base Unit of Measure", Temp_TrackingSpecification."Quantity (Base)");
                            (Temp_TrackingSpecification."Lot No." <> '') and (Temp_TrackingSpecification."Serial No." = ''):
                                TrkInfo := StrSubstNo(lTxt001, Temp_TrackingSpecification."Lot No.", lItem."Base Unit of Measure", Temp_TrackingSpecification."Quantity (Base)");
                            (Temp_TrackingSpecification."Lot No." = '') and (Temp_TrackingSpecification."Serial No." <> ''):
                                TrkInfo := StrSubstNo(lTxt002, Temp_TrackingSpecification."Serial No.", lItem."Base Unit of Measure", Temp_TrackingSpecification."Quantity (Base)");
                        end;
                    end;

                    trigger OnPreDataItem()
                    var
                        lawpLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
                    begin
                        lawpLogisticUnitsMgt.FindPalletBoxToPickForWhseShipment(WarehouseShipmentLine, Temp_TrackingSpecification);

                        Clear(Temp_TrackingSpecification);
                        if Temp_TrackingSpecification.IsEmpty then begin
                            SetRange(Number, 1);
                        end else begin
                            SetRange(Number, 1, Temp_TrackingSpecification.Count);
                            Temp_TrackingSpecification.FindSet();
                        end
                    end;
                }
                dataitem(WarehouseShipmentLineTxt; "Warehouse Shipment Line")
                {
                    DataItemLink = "No." = field("No."),
                                   "Source Type" = field("Source Type"),
                                   "Source Subtype" = field("Source Subtype"),
                                   "Source No." = field("Source No."),
                                   "AltAWPAttached to Source Line" = field("Source Line No.");
                    DataItemTableView = sorting("No.", "Line No.")
                                        order(ascending)
                                        where("AltAWPElement Type" = filter(' '));
                    column(WarehouseShipmentLineTxt_Description; Description)
                    {
                    }
                    column(WarehouseShipmentLineTxt_Description2; "Description 2")
                    {
                    }
                    column(WarehouseShipmentLineTxt_LineNo; "Line No.")
                    {
                    }
                    column(WarehouseShipmentLineTxt_No; "No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        //AWP091-VI-s
                        if ("AltAWPElement Type" = "AltAWPElement Type"::" ") and ("AltAWPComment Reason Code" <> '') then begin
                            if not awpCommentsManagement.IsValidCommentReasonByReport("AltAWPComment Reason Code",
                                                                                      Report::"AltAWPWarehouse Shipment")
                            then begin
                                CurrReport.Skip();
                            end;
                        end;
                        //AWP091-VI-e                             
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    lLogistcFunctions: Codeunit "ecLogistc Functions";
                    lWhseDocumentsMgt: Codeunit "AltAWPWhse. Documents Mgt.";
                    lPrintBarcode: Boolean;
                begin
                    if not PrintAllRows then begin
                        if "AltAWPElement Type" <> "AltAWPElement Type"::Item then CurrReport.Skip();
                        if ("Qty. Outstanding" = 0) then CurrReport.Skip();
                        if "AltAWPWip Item" then CurrReport.Skip();
                    end;

                    if ShowOnlyQtyNotPicked then begin
                        if (Quantity - "Qty. Picked" = 0) then begin
                            CurrReport.Skip();
                        end;
                    end;

                    //AWP091-VI-s
                    if ("AltAWPElement Type" = "AltAWPElement Type"::" ") and ("AltAWPComment Reason Code" <> '') then begin
                        if not awpCommentsManagement.IsValidCommentReasonByReport("AltAWPComment Reason Code",
                                                                                  Report::"AltAWPWarehouse Shipment")
                        then begin
                            CurrReport.Skip();
                        end;
                    end;
                    //AWP091-VI-e                      

                    CustomerCrossReference := lWhseDocumentsMgt.FindWhseShipLineItemReference(WarehouseShipmentLine);

                    Clear(WMSEntryNo_B64);
                    Barcode := '';

                    Clear(ItemBarcode_B64);
                    ItemBarcode := '';

                    lPrintBarcode := ("AltAWPElement Type" = "AltAWPElement Type"::Item) and (not AltAWP_IsNonInventoriableItem()) and (not "AltAWPWip Item");
                    if lPrintBarcode then begin
                        awpWMSIntegrationMgt.AssignWMSEntryNo2WhseShipLine(WarehouseShipmentLine);
                        Barcode := BarcodeSetup."Document Line Barcode Prefix" + BarcodeSetup."Barcode Elements Separator" + Format("AltAWPWMS Entry No.", 10, '<Integer,10><Filler Character,0>');
                        if GenerateBarcode and AWPGeneralSetup."Print barcode log. documents" then begin
                            WMSEntryNo_B64 := BarcodeFunctions.MakeBarcode(Barcode, Enum::"AltATSBarcode Symbology"::"Code 128", 1, 20, false, 0);
                        end;


                        ItemBarcode := BarcodeSetup."Item Barcode Prefix" + BarcodeSetup."Barcode Elements Separator" + "Item No.";
                        if GenerateBarcode and AWPGeneralSetup."Print barcode log. documents" then begin
                            ItemBarcode_B64 := BarcodeFunctions.MakeBarcode(ItemBarcode, Enum::"AltATSBarcode Symbology"::"Code 128", 1, 20, false, 0);
                        end;
                    end;

                    ShipmentInformations := lLogistcFunctions.GetItemShipmentInfoText(WarehouseShipmentLine."Item No.",
                                                                                      WarehouseShipmentLine."Variant Code",
                                                                                      WarehouseShipmentHeader."AltAWPSubject Type",
                                                                                      WarehouseShipmentHeader."AltAWPSubject No.");
                end;
            }

            trigger OnAfterGetRecord()
            var
                lShippingGroup: Record "AltAWPShipping Group";
                lBin: Record Bin;
                lLocation: Record Location;
                lAdvancedTypeHelper: Codeunit "AltATSAdvanced Type Helper";
            begin
                ShipAgentName := '';

                if (WarehouseShipmentHeader."Shipping Agent Code" <> '') then begin
                    ShipAgent.Get(WarehouseShipmentHeader."Shipping Agent Code");
                    ShipAgentName := ShipAgent.Code + ' ' + ShipAgent.Name;
                end;

                HeaderBarcodeString := BarcodeSetup."Document Barcode Prefix" + BarcodeSetup."Barcode Elements Separator" + "No.";
                if GenerateBarcode then begin
                    ImageBase64String := BarcodeFunctions.MakeBarcode(HeaderBarcodeString, Enum::"AltATSBarcode Symbology"::"Code 128", 1, 20, false, 0);
                end;

                LocationName := '';
                if lLocation.Get("Location Code") then begin
                    LocationName := lLocation.Code;
                    if (lLocation.Name <> '') then begin
                        LocationName := LocationName + ' - ' + lLocation.Name;
                    end;
                end;

                NameDeliveryArea := "AltAWPDelivery Area Code";
                if ("AltAWPDelivery Area Code" <> '') then begin
                    CalcFields("AltAWPDelivery Area Name");
                    if ("AltAWPDelivery Area Name" <> '') then begin
                        NameDeliveryArea := NameDeliveryArea + ' - ' + "AltAWPDelivery Area Name";
                    end;
                end;

                BinDescription := '';
                if lBin.Get("Location Code", "Bin Code") then begin
                    BinDescription := lBin.Code;
                    if (lBin.Description <> '') then begin
                        BinDescription := BinDescription + ' - ' + lBin.Description;
                    end;
                end;

                ShipToCountyText := '';
                if ("AltAWPShip-to County" <> '') then begin
                    ShipToCountyText := ' (' + "AltAWPShip-to County" + ')';
                end;

                ShippingWeek := Format("Shipment Date");
                if ("Shipment Date" <> 0D) then begin
                    ShippingWeek += ' (WK ' + lAdvancedTypeHelper.DateToWeekText("Shipment Date") + ')';
                end;

                UpgNoPrintedCopies(WarehouseShipmentHeader);

                Clear(TipoDocSpedizione);
                if ShippingProfile.Get("AltAWPShipping Profile Code") then begin
                    TipoDocSpedizione := Format(ShippingProfile."Shipment Document Type");
                end;

                SubjectType_No := Format("AltAWPSubject Type");
                if ("AltAWPSubject Name" <> '') then begin
                    SubjectType_No := SubjectType_No + ' - ' + "AltAWPSubject No.";
                end;

                PDCNotestText := '';
                if ("AltAWPShipping Group No." <> '') and lShippingGroup.Get("AltAWPShipping Group No.") and (lShippingGroup.Note <> '') then begin
                    PDCNotestText := lShippingGroup.Note;
                end;


                Clear(HeaderCommentText);
                HeaderCommentText := PrintFunctions.GetDocumentCommentHeader(WarehouseShipmentHeader, Report::"AltAWPWarehouse Shipment");
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
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowOnlyQtyNotPicked_Field; ShowOnlyQtyNotPicked)
                    {
                        ApplicationArea = All;
                        Caption = 'Show unpicked quantities only', Comment = 'Mostra solo quantità non prelevate';
                    }
                    field(PrintAllRows_Field; PrintAllRows)
                    {
                        ApplicationArea = All;
                        Caption = 'Show all lines', Comment = 'Mostra tutte le righe';
                    }
                }
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
        AWPGeneralSetup.Get();
    end;

    local procedure UpgNoPrintedCopies(var pWarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        Clear(TextReprinted);
        if (pWarehouseShipmentHeader."AltAWPNo. Printed - Whse Ship." > 0) then begin
            TextReprinted := TxtReprinted;
        end;

        if (not CurrReport.Preview) then begin
            pWarehouseShipmentHeader."AltAWPNo. Printed - Whse Ship." := pWarehouseShipmentHeader."AltAWPNo. Printed - Whse Ship." + 1;
            pWarehouseShipmentHeader.Modify(false);
        end;
    end;

    var
        BarcodeSetup: Record "AltAWPBarcode Setup";
        ShippingProfile: Record "AltAWPShipping Profile";
        ShipAgent: Record "Shipping Agent";
        Temp_TrackingSpecification: Record "Tracking Specification" temporary;
        AWPGeneralSetup: Record "AltAWPGeneral Setup";
        BarcodeFunctions: Codeunit "AltAWPBarcode Functions";
        PrintFunctions: Codeunit "AltAWPPrint Functions";
        awpCommentsManagement: Codeunit "AltAWPComments Management";
        awpWMSIntegrationMgt: Codeunit "AltAWPWMS Integration Mgt.";
        ShipmentInformations: Text;
        GenerateBarcode: Boolean;
        PrintAllRows: Boolean;
        ShowOnlyQtyNotPicked: Boolean;
        PalletNo: Decimal;
        lblAreaCode: Label 'Area Code:';
        lblBin: Label 'Bin';
        lblCity: Label 'City:';
        lblDepotCode: Label 'Depot Code:';
        lblDescription: Label 'Description';
        lblDocumentDate: Label 'Document Date';
        lblDocumentNo: Label 'Document No.:';
        lblIDRow: Label 'ID Row';
        lblItem: Label 'Item';
        lblLocation: Label 'Location';
        lblLocationCode: Label 'Location Code:';
        lblName: Label 'Name:';
        lblPage: Label 'Page';
        lblPDCNotes: Label 'SHIPPING GROUP NOTES: ';
        lblQtyNotPicked: Label 'Q.ty not pick';
        lblQuantity: Label 'Quantity', Comment = 'Q.tà';
        lblShipmentDate: Label 'Shipment date:';
        lblShipmentNotes: Label 'SHIPMENT NOTES: ';
        lblShippingAgent: Label 'Shipping Agent:';
        lblShippingGroup: Label 'Shipping group';
        lblSourceDocument: Label 'Source Document:';
        lblSourceNo: Label 'Source No.:';
        lblSourceReference: Label 'Source Reference';
        lblSourceType: Label 'Source Type:';
        lblTipoDocSpedizione: Label 'Doc. spedizione:';
        lblTitle: Label 'WAREHOUSE SHIPMENT';
        lblTotalPallets: Label 'Total Pallets';
        lblUM: Label 'UM';
        lblVariant: Label 'Variant';
        TxtReprinted: Label '*REPRINT*', Comment = '*RISTAMPA*';
        Barcode: Text;
        BinDescription: Text;
        CustomerCrossReference: Text;
        HeaderBarcodeString: Text;
        HeaderCommentText: Text;
        ImageBase64String: Text;
        ItemBarcode: Text;
        ItemBarcode_B64: Text;
        LocationName: Text;
        NameDeliveryArea: Text;
        PDCNotestText: Text;
        ServiceText: Text;
        ShipAgentName: Text;
        ShippingWeek: Text;
        ShipToCountyText: Text;
        SubjectType_No: Text;
        TipoDocSpedizione: Text;
        TrkInfo: Text;
        TrkInfoPB: Text;
        WMSEntryNo_B64: Text;
        TextReprinted: Text[10];
}

