namespace EuroCompany.BaseApp.Warehouse.Reports;

using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Sales.Customer;
using EuroCompany.BaseApp.Warehouse.Pallets;
using Microsoft.Bank.BankAccount;
using Microsoft.Foundation.Address;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.Company;
using Microsoft.Foundation.ExtendedText;
using Microsoft.Foundation.PaymentTerms;
using Microsoft.Foundation.Shipping;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Warehouse.History;
using Microsoft.Warehouse.Journal;
using Microsoft.Warehouse.Ledger;
using System.Utilities;

report 50020 "ecShipping Document"
{
    ApplicationArea = All;
    Caption = 'Shipping Document';
    DefaultLayout = RDLC;
    Description = 'GAP_VEN_001';
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    RDLCLayout = '.\src\EuroCompany\BaseApp\Warehouse\Reports\ShippingDocument.Layout.rdlc';
    UsageCategory = None;

    dataset
    {
        dataitem(PostedWhseShipmentHeader; "Posted Whse. Shipment Header")
        {
            DataItemTableView = sorting("No.")
                                order(ascending);
            RequestFilterFields = "No.", "AltAWPDocument Canceled";
            RequestFilterHeading = 'Shipping Document Header';
            column(CanceledWatermarkPicture; GeneralSetup."Canceled Document Watermark")
            {
            }
            column(CashDeliveryExtText; CashDeliveryExtText)
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(CompanyBankName; CompanyInformation."Bank Name")
            {
            }
            column(CompanyHomePage; CompanyInformation."Home Page")
            {
            }
            column(CompanyIban; CompanyInformation.IBAN)
            {
            }
            column(CompanyVatRegNo; PrintFunctions.PrintVatRegistrationNo(CompanyInformation."VAT Registration No.", CompanyInformation."Country/Region Code"))
            {
            }
            column(DepotsList1; DepotsList[1])
            {
            }
            column(DepotsList2; DepotsList[2])
            {
            }
            column(DepotsList3; DepotsList[3])
            {
            }
            column(DepotsList4; DepotsList[4])
            {
            }
            column(DestFiscalCode; DestFiscalCode)
            {
            }
            column(DestinationPhone; DestinationPhone)
            {
            }
            column(DestPhoneNo; DestPhoneNo)
            {
            }
            column(DestVATRegNo; DestVATRegNo)
            {
            }
            column(DocumentDate; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(DocumentNo; "No.")
            {
            }
            column(DocumentNoWithDate; StrSubstNo(lblDocNoWithDate, "No.", Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')))
            {
            }
            column(FreightType; Format("AltAWPFreight Type"))
            {
            }
            column(GoodAspect; GoodsAspectDesc)
            {
            }
            column(GrossWeight; "AltAWPGross Weight")
            {
            }
            column(GrossWeightText; lblGrossWeight)
            {
            }
            column(AWPParcelUnits; "AltAWPParcel Units")
            {
            }
            column(HeaderCommentText; HeaderCommentText)
            {
            }
            column(AccompDataCaption_Text; AccompDataCaption_Text)
            {
            }
            column(AccompDataValue_Text; AccompDataValue_Text)
            {
            }
            column(HeaderInformationArray1; HeaderInformationArray[1])
            {
            }
            column(HeaderInformationArray2; HeaderInformationArray[2])
            {
            }
            column(HeaderInformationArray3; HeaderInformationArray[3])
            {
            }
            column(HeaderInformationArray4; HeaderInformationArray[4])
            {
            }
            column(HeaderInformationArray5; HeaderInformationArray[5])
            {
            }
            column(HeaderInformationArray6; HeaderInformationArray[6])
            {
            }
            column(HeaderInformationArray7; HeaderInformationArray[7])
            {
            }
            column(HeaderInformationArray8; HeaderInformationArray[8])
            {
            }
            column(HeaderInformationArray9; HeaderInformationArray[9])
            {
            }
            column(ImageBase64String; ImageBase64String)
            {
            }
            column(lblAlboTrasp; lblAlboTrasp)
            {
            }
            column(lblBank; lblBank)
            {
            }
            column(lblCarriage; lblCarriage)
            {
            }
            column(lblCarriers; lblCarriers)
            {
            }
            column(lblCompany; lblCompany)
            {
            }
            column(lblCompanyInfo; lblCompanyInfo)
            {
            }
            column(lblConai; lblConai)
            {
            }
            column(lblContinue; lblContinue)
            {
            }
            column(lblCustSignature; lblCustSignature)
            {
            }
            column(lblDestination; lblDestination)
            {
            }
            column(lblDocType; lblDocType)
            {
            }
            column(lblDocumentDate; lblDocumentDate)
            {
            }
            column(lblDocumentNo; lblDocumentNo)
            {
            }
            column(lblDocumentType; lblDocumentType)
            {
            }
            column(lblDocumentType2; lblDocumentType2)
            {
            }
            column(lblDocumentType3; lblDocumentType3)
            {
            }
            column(lblDriverSignature; lblDriverSignature)
            {
            }
            column(lblElectrSigned; lblElectrSigned)
            {
            }
            column(lblElectrSigneds; lblElectrSigned)
            {
            }
            column(lblFiscalCode; lblFiscalCode)
            {
            }
            column(lblFreightType; lblFreightType)
            {
            }
            column(lblGoodAspect; lblGoodAspect)
            {
            }
            column(lblGrossWeight; lblGrossWeight)
            {
            }
            column(lblHandlingCompany; lblHandlingCompany)
            {
            }
            column(lblIBAN; lblIBAN)
            {
            }
            column(lblNetWeight; lblNetWeight)
            {
            }
            column(lblNotes; lblNotes)
            {
            }
            column(lblPageNo; lblPageNo)
            {
            }
            column(lblParcelNo; lblParcelNo)
            {
            }
            column(lblPayMeth; lblPayMeth)
            {
            }
            column(lblPayTerm; lblPayTerm)
            {
            }
            column(lblPhoneNo; lblPhoneNo)
            {
            }
            column(lblPlateNo; lblPlateNo)
            {
            }
            column(lblRecipient; lblRecipient)
            {
            }
            column(lblResidence; lblResidence)
            {
            }
            column(lblSaleCondition; lblSaleCondition)
            {
            }
            column(lblShipMethod; lblShipMethod)
            {
            }
            column(lblShippingAddress; lblShippingAddress)
            {
            }
            column(lblShippingAgent; lblShippingAgent)
            {
            }
            column(lblShippingType; lblShippingType)
            {
            }
            column(lblShipStartDate; lblShipStartDate)
            {
            }
            column(lblShipStartingDate; lblShipStartingDate)
            {
            }
            column(lblSignature; lblSignature)
            {
            }
            column(lblSourceLocation; lblSourceLocation)
            {
            }
            column(lblSubjectNo; lblSubjectNo)
            {
            }
            column(lblTDDPreparedBy; lblTDDPreparedBy)
            {
            }
            column(lblTextWord01; lblTextWord01)
            {
            }
            column(lblTransportReason; lblTransportReason)
            {
            }
            column(lblVarRegNo; lblVarRegNo)
            {
            }
            column(lblVatRegNo2; lblVatRegNo2)
            {
            }
            column(lblPalletNo; lblPalletNo)
            {
            }
            column(lblNoOfPalletPlaces; lblNoOfPalletPlaces)
            {
            }
            column(Logo; CompanyInformation.Picture)
            {
            }
            column(Logo4; GeneralSetup."Picture Footer Report")
            {
            }
            column(NetWeight; "AltAWPNet Weight")
            {
            }
            column(Notes; "AltAWPShipping Notes")
            {
            }
            column(ParcelNo; TotalParcels)
            {
            }
            column(NoPalletPlaces; "AltAWPNo. Pallet Places")
            {
            }
            column(PayMethDescr; PayMethDescr)
            {
            }
            column(PayTermDescr; PayTermDescr)
            {
            }
            column(PhoneNo; CompanyInformation."Phone No.")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(PrintDocumentType; PrintDocumentType)
            {
            }
            column(ReasonDescr; ReasonDescr)
            {
            }
            column(SellToAddr1; SellToAddr[1])
            {
            }
            column(SellToAddr2; SellToAddr[2])
            {
            }
            column(SellToAddr3; SellToAddr[3])
            {
            }
            column(SellToAddr4; SellToAddr[4])
            {
            }
            column(ShipmentMethod; ShipmentMethod.Description)
            {
            }
            column(ShippingAgentAddress; ShippingAgent.Address + ' ' + StrSubstNo(Text001, ShippingAgent."AltAWPPost Code", ShippingAgent.AltAWPCity, ShippingAgent.AltAWPCounty))
            {
            }
            column(ShippingAgentAlboTrasp; ShippingAgent."AltAWPRegistration No.")
            {
            }
            column(ShippingAgentName; ShippingAgent.Name)
            {
            }
            column(ShippingStartingDate; Format("AltAWPShipping Starting Date"))
            {
            }
            column(ShippingStartingDate2; Format("AltAWPShipping Starting Date") + ' ' + Format("AltAWPShipping Starting Time"))
            {
            }
            column(ShippingStartingTime; '')
            {
            }
            column(ShipToAddr1; ShipToAddr[1])
            {
            }
            column(ShipToAddr2; ShipToAddr[2])
            {
            }
            column(ShipToAddr3; ShipToAddr[3])
            {
            }
            column(ShipToAddr4; ShipToAddr[4])
            {
            }
            column(BillToAddr1; BillToAddr[1])
            {
            }
            column(BillToAddr2; BillToAddr[2])
            {
            }
            column(BillToAddr3; BillToAddr[3])
            {
            }
            column(BillToAddr4; BillToAddr[4])
            {
            }
            column(SourceLocationAddress; StrSubstNo(Text002, Location.Address, Location."Post Code", Location.City, Location."Country/Region Code"))
            {
            }
            column(SourceLocationName; Location.Name)
            {
            }
            column(SpecialPaymentConditions; SpecialPaymentConditions)
            {
            }
            column(SubjectName; "AltAWPSubject Name")
            {
            }
            column(SubjectNo; "AltAWPSubject No.")
            {
            }
            column(TransportReason; ShipmentProfile.Description)
            {
            }
            column(TxtCancelledDoc; TxtCancelledDoc)
            {
            }
            column(URL_Sale_Condition; GeneralSetup."URL Sale Condition")
            {
            }
            column(lblMandatoryDeliveryDate; lblMandatoryDeliveryDate)
            {
            }
            column(MandatoryDeliveryDate; "AltAWPMandatory Delivery Date")
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = sorting(Number)
                                    order(ascending);
                column(OutputNo; Number)
                {
                }
                dataitem(PostedWhseShipmentLine; "Posted Whse. Shipment Line")
                {
                    DataItemLink = "No." = field("No.");
                    DataItemLinkReference = PostedWhseShipmentHeader;
                    DataItemTableView = sorting("No.", "Line No.")
                                        order(ascending);
                    column(Description; Description)
                    {
                    }
                    column(Description2; "Description 2")
                    {
                    }
                    column(DocumentDescr; DocumentDescr)
                    {
                    }
                    column(DocumentLineNo; "Line No.")
                    {
                    }
                    column(ElementNo; PrintElementNo)
                    {
                    }
                    column(ElementType; "AltAWPElement Type".AsInteger())
                    {
                    }
                    column(lblDescription; lblDescription)
                    {
                    }
                    column(lblItemNo; lblItemNo)
                    {
                    }
                    column(lblQuantity; lblQuantity)
                    {
                    }
                    column(lblUM; lblUM)
                    {
                    }
                    column(lblVariant; lblVariant)
                    {
                    }
                    column(lblNetKG; lblNetKG)
                    {
                    }
                    column(lblUMC; lblUMC)
                    {
                    }
                    column(lblQuantityUMC; lblQuantityUMC)
                    {
                    }
                    column(PrintDesignCardExternalRef; PrintDesignCardExternalRef)
                    {
                    }
                    column(Quantity; Quantity)
                    {
                    }
                    column(SalePriceText; SalePriceText)
                    {
                    }
                    column(UM; "Unit of Measure Code")
                    {
                    }
                    column(VariantCode; "Variant Code")
                    {
                    }
                    column(TotNetWeight; "AltAWPTotal Net Weight")
                    {
                        DecimalPlaces = 0 : 2;
                    }
                    column(ConsumerUnitofMeasure; "ecConsumer Unit of Measure")
                    {
                    }
                    column(QtyConsumerUM; "ecQuantity (Consumer UM)")
                    {
                    }
                    column(TariffNo; TariffNo)
                    {
                    }
                    column(ItemReferenceNo; ItemReferenceNo)
                    {
                    }
                    column(IsNewLine; IsNewLine)
                    {
                    }
                    dataitem(WarehouseEntry; "Warehouse Entry")
                    {
                        DataItemTableView = sorting("Whse. Document No.", "Whse. Document Line No.", "Whse. Document Type") order(ascending);
                        column(lblOrigin; lblOrigin)
                        {
                        }
                        column(lblSSCC; lblSSCC)
                        {
                        }
                        column(WhseEntryNo; "Entry No.")
                        {
                        }
                        column(CountryOrigin; CountryOrigin)
                        {
                        }
                        column(TrackingInfoLine; TrackingInfoLine)
                        {
                        }
                        column(SSCCInfo; SSCCInfo)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            lAWPLogisticUnitInfo: Record "AltAWPLogistic Unit Info";
                            lLotNoInformation: Record "Lot No. Information";
                        begin
                            Quantity := -Quantity;
                            SSCCInfo := '';
                            TrackingInfoLine := '';
                            CountryOrigin := '';

                            case PostedWhseShipmentHeader."AltAWPSubject Type" of
                                PostedWhseShipmentHeader."AltAWPSubject Type"::Customer:
                                    begin
                                        if ShowTrackingInfoOpt in [ShowTrackingInfoOpt::Standard, ShowTrackingInfoOpt::Extended] then begin
                                            if ("Expiration Date" <> 0D) then begin
                                                TrackingInfoLine := StrSubstNo(lblExpirationDate, "Expiration Date") + ' - ';
                                            end;
                                            if ("Lot No." <> '') then begin
                                                TrackingInfoLine += StrSubstNo(lblLotNo, "Lot No.") + ' - ' + StrSubstNo(lblLotQty, Quantity);
                                            end;
                                        end;

                                        if (ShowTrackingInfoOpt = ShowTrackingInfoOpt::Extended) then begin
                                            if lLotNoInformation.Get("Item No.", "Variant Code", "Lot No.") then begin
                                                if (lLotNoInformation."ecOrigin Country Code" <> '') then CountryOrigin := lLotNoInformation."ecOrigin Country Code";
                                            end;
                                            if ("AltAWPPallet No." <> '') then begin
                                                if not lAWPLogisticUnitInfo.Get(lAWPLogisticUnitInfo.Type::Pallet, "AltAWPPallet No.") then Clear(lAWPLogisticUnitInfo);
                                            end;
                                            if ("AltAWPBox No." <> '') and ("AltAWPPallet No." = '') then begin
                                                if not lAWPLogisticUnitInfo.Get(lAWPLogisticUnitInfo.Type::Box, "AltAWPBox No.") then Clear(lAWPLogisticUnitInfo);
                                            end;
                                            SSCCInfo := lAWPLogisticUnitInfo."GS1 SSCC Code";
                                        end;
                                    end;
                                PostedWhseShipmentHeader."AltAWPSubject Type"::Vendor, PostedWhseShipmentHeader."AltAWPSubject Type"::Branch:
                                    begin
                                        if ("Expiration Date" <> 0D) then begin
                                            TrackingInfoLine := StrSubstNo(lblExpirationDate, "Expiration Date") + ' - ';
                                        end;
                                        if ("Lot No." <> '') then begin
                                            TrackingInfoLine += StrSubstNo(lblLotNo, "Lot No.") + ' - ' + StrSubstNo(lblLotQty, Quantity);
                                        end;
                                        if lLotNoInformation.Get("Item No.", "Variant Code", "Lot No.") then begin
                                            if (lLotNoInformation."ecOrigin Country Code" <> '') then CountryOrigin := lLotNoInformation."ecOrigin Country Code";
                                        end;
                                        if ("AltAWPPallet No." <> '') then begin
                                            if not lAWPLogisticUnitInfo.Get(lAWPLogisticUnitInfo.Type::Pallet, "AltAWPPallet No.") then Clear(lAWPLogisticUnitInfo);
                                        end;
                                        if ("AltAWPBox No." <> '') and ("AltAWPPallet No." = '') then begin
                                            if not lAWPLogisticUnitInfo.Get(lAWPLogisticUnitInfo.Type::Box, "AltAWPBox No.") then Clear(lAWPLogisticUnitInfo);
                                        end;
                                        SSCCInfo := lAWPLogisticUnitInfo."GS1 SSCC Code";
                                    end;
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if ShowTrackingInfoOpt = ShowTrackingInfoOpt::None then CurrReport.Break();

                            SetRange("Whse. Document No.", PostedWhseShipmentLine."No.");
                            SetRange("Whse. Document Line No.", PostedWhseShipmentLine."Line No.");
                            SetRange("Whse. Document Type", "Whse. Document Type"::Shipment);
                        end;
                    }
                    dataitem(KitProdExhibitorItemBOM; "ecKit/Prod. Exhibitor Item BOM")
                    {
                        DataItemTableView = sorting("Entry No.", "Line No.") order(ascending);

                        column(lblComposedBy; CompositionText)
                        {
                        }
                        column(KitProdExhibitor_EntryNo; "Entry No.")
                        {
                        }
                        column(KitProdExhibitor_LineNo; "Line No.")
                        {
                        }
                        column(KitProdExhibitor_ItemNo; "Item No.")
                        {
                        }
                        column(KitProdExhibitor_Description; Description)
                        {
                        }
                        column(KitProdExhibitor_UnitOfMeasureCode; "Unit Of Measure Code")
                        {
                        }
                        column(KitProdExhibitor_Quantity; KitProdExhibitor_Quantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(KitProdExhibitor_UMC; KitProdExhibitor_UMC)
                        {
                        }
                        column(KitProdExhibitor_QuantityUMC; KitProdExhibitor_QuantityUMC)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(KitProdExhibitor_NetWeight; KitProdExhibitor_NetWeight)
                        {
                            DecimalPlaces = 2 : 2;
                        }

                        trigger OnAfterGetRecord()
                        var
                            lItem: Record Item;
                            lawpLogisticsFunctions: Codeunit "AltAWPLogistics Functions";
                        begin
                            lItem.Get(KitProdExhibitorItemBOM."Item No.");
                            KitProdExhibitor_UMC := lItem."ecConsumer Unit of Measure";
                            KitProdExhibitor_Quantity := KitProdExhibitorItemBOM."Prod. BOM Quantity" * PostedWhseShipmentLine.Quantity;

                            KitProdExhibitor_QuantityUMC := lawpLogisticsFunctions.ConvertItemQtyInUM("Item No.", KitProdExhibitor_Quantity,
                                                                                                      "Unit Of Measure Code",
                                                                                                      KitProdExhibitor_UMC);
                            KitProdExhibitor_NetWeight := 0;
                            if ("Unit Of Measure Code" = lItem."Base Unit of Measure") then begin
                                KitProdExhibitor_NetWeight := lItem."Net Weight" * "Prod. BOM Quantity" * PostedWhseShipmentLine.Quantity;
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (PostedWhseShipmentLine."ecKit/Exhibitor BOM Entry No." = 0) then CurrReport.Break();

                            SetRange("Entry No.", PostedWhseShipmentLine."ecKit/Exhibitor BOM Entry No.");
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        lItem: Record Item;
                        lSalesLine: Record "Sales Line";
                        lPurchaseLine: Record "Purchase Line";
                    begin
                        if not PostedWhseShipmentHeader."AltAWPDocument Canceled" then begin
                            if AltAWPCorrection then begin
                                CurrReport.Skip();
                            end;
                        end;

                        if "AltAWPReversal Line" then begin
                            CurrReport.Skip();
                        end;

                        //AWP091-VI-s
                        if ("AltAWPElement Type" = "AltAWPElement Type"::" ") and ("AltAWPComment Reason Code" <> '') then begin
                            if not awpCommentsManagement.IsValidCommentReasonByReport("AltAWPComment Reason Code",
                                                                                      Report::"AltAWPShipping Document")
                            then begin
                                CurrReport.Skip();
                            end;
                        end;
                        //AWP091-VI-e   

                        PrintElementNo := "AltAWPElement No.";

                        if ClearLogo then begin
                            Clear(CompanyInformation.Picture);
                            Clear(GeneralSetup."Picture Footer Report");
                            Clear(GeneralSetup."Canceled Document Watermark");
                        end;
                        ClearLogo := true;

                        TariffNo := '';
                        ItemReferenceNo := '';
                        case "AltAWPSubject Type" of
                            "AltAWPSubject Type"::Customer:
                                begin
                                    if ("AltAWPElement Type" = "AltAWPElement Type"::Item) then begin
                                        if (ShowTariffNoOpt = ShowTariffNoOpt::Yes) then begin
                                            if lItem.Get("AltAWPElement No.") and (lItem."Tariff No." <> '') then begin
                                                TariffNo := StrSubstNo(lblTariffNo, lItem."Tariff No.");
                                            end;
                                        end;

                                        if (PrintItemCrossRefOpt = PrintItemCrossRefOpt::Yes) then begin
                                            if ("Source Type" = Database::"Sales Line") then begin
                                                if lSalesLine.Get("Source Subtype", "Source No.", "Source Line No.") then begin
                                                    if (lSalesLine."Item Reference No." <> '') then begin
                                                        ItemReferenceNo := StrSubstNo(lblItemRefrenceNo, lSalesLine."Item Reference No.");
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            "AltAWPSubject Type"::Vendor:
                                begin
                                    if lItem.Get("AltAWPElement No.") and (lItem."Tariff No." <> '') then begin
                                        TariffNo := StrSubstNo(lblTariffNo, lItem."Tariff No.");
                                    end;
                                    if lPurchaseLine.Get("Source Subtype", "Source No.", "Source Line No.") then begin
                                        if (lPurchaseLine."Item Reference No." <> '') then begin
                                            ItemReferenceNo := StrSubstNo(lblItemRefrenceNo, lPurchaseLine."Item Reference No.");
                                        end;
                                    end;
                                end;
                        end;

                        Clear(Temp_TrackingSpecification);
                        Temp_TrackingSpecification.DeleteAll(false);

                        CompositionText := '';
                        if (PostedWhseShipmentLine."ecKit/Exhibitor BOM Entry No." <> 0) then begin
                            CompositionText := StrSubstNo(lblComposedBy, PostedWhseShipmentLine."AltAWPElement No.");
                        end;

                        IsNewLine := not ExistsLinesAttachedAfter(PostedWhseShipmentLine);
                    end;

                    trigger OnPreDataItem()
                    begin
                        ClearLogo := false;
                    end;
                }
                // dataitem("Item Ledger Entry"; "Item Ledger Entry")
                // {
                //     DataItemLink = "Document No." = field("No.");
                //     DataItemLinkReference = PostedWhseShipmentHeader;
                //     column(NoField; NoField)
                //     {
                //     }
                //     column(ecUnit_Logistcs_Code; "ecUnit Logistcs Code")
                //     {
                //     }
                //     column(LogisticDescription; LogisticDescription)
                //     {
                //     }
                //     column(Quantity_; Abs(Quantity))
                //     {
                //     }
                //     trigger OnAfterGetRecord()
                //     var
                //         LogUnitFormat: Record "AltAWPLogistic Unit Format";
                //     begin
                //         Clear(LogisticDescription);

                //         Counter += 1;
                //         NoField := lblNo + ' ' + Format(Counter);

                //         if LogUnitFormat.Get("ecUnit Logistcs Code") then
                //             LogisticDescription := LogUnitFormat.Description;
                //     end;

                //     trigger OnPreDataItem()
                //     begin
                //         Clear(LogisticDescription);
                //     end;
                // }
                trigger OnAfterGetRecord()
                begin
                    DocumentDescr := lblDescrDocDefault;
                    case Number of
                        1:
                            DocumentDescr := lblDescrDoc001;
                        2:
                            DocumentDescr := lblDescrDoc002;
                        3:
                            DocumentDescr := lblDescrDoc003;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, NoOfCopies + 1);
                end;
            }

            trigger OnAfterGetRecord()
            var
                lGoodsAppearance: Record "Goods Appearance";
                lCustomer: Record Customer;
                lReasonCode: Record "Reason Code";
                lVendor: Record Vendor;
                lUnitofMeasure: Record "Unit of Measure";
                lPostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
                lLogisticsFunctions: Codeunit "AltAWPLogistics Functions";
                lLanguageCode: Code[10];
            begin
                PrintDocumentType := lblDocType;
                if ("AltAWPShipment Document Type" <> "AltAWPShipment Document Type"::"Shipping Document") then begin
                    PrintDocumentType := lblDocType2;
                end;

                if GeneralSetup."Active Watermark Ship. Doc." then begin
                    Clear(GeneralSetup."Canceled Document Watermark");
                    if "AltAWPDocument Canceled" then begin
                        GeneralSetup.CalcFields("Canceled Document Watermark");
                    end;
                end;

                Clear(LastHeaderInformationArrayText);
                OnBeforePostedWhseShipmentHeaderOnAfterGetRecord(PostedWhseShipmentHeader, LastHeaderInformationArrayText);
                PrintFunctions.GetHeaderInformation(PostedWhseShipmentHeader."AltAWPBranch Code", PostedWhseShipmentHeader."Location Code", HeaderInformationArray, LastHeaderInformationArrayText);

                FormatAddress.Company(CompanyAddr, CompanyInformation);
                PrintFunctions.PostedWhseShipSellTo(SellToAddr, PostedWhseShipmentHeader);
                PrintFunctions.PostedWhseShipShipTo(ShipToAddr, PostedWhseShipmentHeader);
                PrintFunctions.PostedWhseShipBillTo(BillToAddr, PostedWhseShipmentHeader);

                DestVATRegNo := '';
                DestFiscalCode := '';
                LanguageCode := '';
                DestPhoneNo := '';
                DestinationPhone := '';
                case "AltAWPSubject Type" of
                    "AltAWPSubject Type"::Vendor:
                        begin
                            if Vendor.Get("AltAWPSubject No.") then begin
                                DestVATRegNo := PrintFunctions.PrintVatRegistrationNo(Vendor."VAT Registration No.", Vendor."Country/Region Code");
                                DestFiscalCode := Vendor."Fiscal Code";
                                LanguageCode := Vendor."Language Code";
                                DestPhoneNo := Vendor."Phone No.";
                                DestinationPhone := DestPhoneNo;
                            end;
                        end;

                    "AltAWPSubject Type"::Customer:

                        begin
                            if ("AltAWPSubject Detail No." <> '') then begin
                                if ShiptoAddress.Get("AltAWPSubject No.", "AltAWPSubject Detail No.") then begin
                                    DestinationPhone := ShiptoAddress."Phone No.";
                                end;
                            end;

                            if Customer.Get("AltAWPSubject No.") then begin
                                DestVATRegNo := PrintFunctions.PrintVatRegistrationNo(Customer."VAT Registration No.", Customer."Country/Region Code");
                                DestFiscalCode := Customer."Fiscal Code";
                                DestPhoneNo := Customer."Phone No.";
                                LanguageCode := Customer."Language Code";
                                if (DestinationPhone = '') then begin
                                    DestinationPhone := DestPhoneNo;
                                end;
                            end;
                        end;


                    "AltAWPSubject Type"::Branch:
                        begin
                            Clear(Location);
                            if Location.Get(lLogisticsFunctions.GetDefaultLocation("AltAWPSubject No.")) then;
                            DestPhoneNo := Location."Phone No.";
                            if ("AltAWPSubject Detail No." <> '') then begin
                                Clear(Location);
                                if Location.Get("AltAWPSubject Detail No.") then;
                                DestinationPhone := Location."Phone No.";
                            end;
                        end;
                end;

                CurrReport.Language := PrintFunctions.GetReportLanguageCode(LanguageCode);


                if not ShipmentMethod.Get("Shipment Method Code") then begin
                    Clear(ShipmentMethod);
                end;
                ShipmentMethod.TranslateDescription(ShipmentMethod, LanguageCode);

                if not ShippingAgent.Get("Shipping Agent Code") then begin
                    Clear(ShippingAgent);
                end;

                if not ShipmentProfile.Get("AltAWPShipping Profile Code") then begin
                    Clear(ShipmentProfile);
                end;

                TxtCancelledDoc := '';
                if "AltAWPDocument Canceled" then begin
                    TxtCancelledDoc := lblCancelledDoc;
                end;

                lLanguageCode := '';
                case PostedWhseShipmentHeader."AltAWPSubject Type" of
                    "AltAWPSubject Type"::Customer:
                        begin
                            if lCustomer.Get(PostedWhseShipmentHeader."AltAWPSubject No.") then begin
                                lLanguageCode := lCustomer."Language Code";
                            end;
                        end;
                    "AltAWPSubject Type"::Vendor:
                        begin
                            if lVendor.Get(PostedWhseShipmentHeader."AltAWPSubject No.") then begin
                                lLanguageCode := lVendor."Language Code";
                            end;
                        end;
                end;

                PayMethDescr := '';
                PayTermDescr := '';

                if ("AltAWPPayment Method Code" = '') then begin
                    PaymentMethod.Init();
                end else begin
                    PaymentMethod.Get("AltAWPPayment Method Code");
                    PaymentMethod.TranslateDescription(lLanguageCode);
                    PayMethDescr := PaymentMethod.Description;
                end;

                if ("AltAWPPayment Terms Code" = '') then begin
                    PaymentTerms.Init()
                end else begin
                    PaymentTerms.Get("AltAWPPayment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, lLanguageCode);
                    PayTermDescr := PaymentTerms.Description;
                end;

                if lReasonCode.Get("AltAWPReason Code") then begin
                    ReasonDescr := lReasonCode.Description;
                end;

                GoodsAspectDesc := '';
                if lGoodsAppearance.Get("AltAWPGoods Appearance") then begin
                    GoodsAspectDesc := lGoodsAppearance.Description;
                end;

                Clear(HeaderCommentText);
                HeaderCommentText := PrintFunctions.GetDocumentCommentHeader(PostedWhseShipmentHeader, Report::"AltAWPShipping Document");
                PrintFunctions.GetAccompData(PostedWhseShipmentHeader, AccompDataCaption_Text, AccompDataValue_Text);

                GetCashDeliveryExtText();

                ReportTitle := lblDocType;
                if (PostedWhseShipmentHeader."AltAWPShipment Document Type" <> PostedWhseShipmentHeader."AltAWPShipment Document Type"::"Shipping Document") then begin
                    ReportTitle := lblShipment;
                end;

                Clear(lPostedWhseShipmentLine);
                lPostedWhseShipmentLine.SetRange("No.", "No.");
                if not lPostedWhseShipmentLine.IsEmpty then begin
                    lPostedWhseShipmentLine.FindSet();
                    repeat
                        if lUnitofMeasure.Get(lPostedWhseShipmentLine."Unit of Measure Code") and
                           (lUnitofMeasure."AltAWPType Unit Of Measure" = lUnitofMeasure."AltAWPType Unit Of Measure"::Parcels)
                        then begin
                            TotalParcels += lPostedWhseShipmentLine.Quantity;
                        end;
                    until (lPostedWhseShipmentLine.Next() = 0);
                end;

                Clear(lCustomer);
                if (PostedWhseShipmentHeader."AltAWPSubject Type" = PostedWhseShipmentHeader."AltAWPSubject Type"::Customer) then begin
                    lCustomer.Get(PostedWhseShipmentHeader."AltAWPSubject No.");
                end;

                if (ShowTariffNoOpt = ShowTariffNoOpt::"Customer Default") then begin
                    if lCustomer."AltAWPPrint Tariff No." then begin
                        ShowTariffNoOpt := ShowTariffNoOpt::Yes;
                    end else begin
                        ShowTariffNoOpt := ShowTariffNoOpt::No;
                    end;
                end;

                if (PrintItemCrossRefOpt = PrintItemCrossRefOpt::"Customer Default") then begin
                    if lCustomer."AltAWPPrint Item Reference" then begin
                        PrintItemCrossRefOpt := PrintItemCrossRefOpt::Yes;
                    end else begin
                        PrintItemCrossRefOpt := PrintItemCrossRefOpt::No;
                    end;
                end;

                if (ShowTrackingInfoOpt = ShowTrackingInfoOpt::"Customer Default") then begin
                    case lCustomer."AltAWPPrint Item Tracking" of
                        lCustomer."AltAWPPrint Item Tracking"::None:
                            ShowTrackingInfoOpt := ShowTrackingInfoOpt::None;
                        lCustomer."AltAWPPrint Item Tracking"::Standard:
                            ShowTrackingInfoOpt := ShowTrackingInfoOpt::Standard;
                        lCustomer."AltAWPPrint Item Tracking"::Extended:
                            ShowTrackingInfoOpt := ShowTrackingInfoOpt::Extended;
                    end;
                end;
            end;

            trigger OnPreDataItem()
            var
                lPostedWhseShipmentHeader2: Record "Posted Whse. Shipment Header";
                lCanceled: Boolean;
                lError01: Label 'It is not possible to print canceled and uncancelled packing slips at the same time!', Comment = 'Non è possibile stampare Documenti di trasporto annullati e non annullati contemporaneamente!';
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(Picture);
                GeneralSetup.CalcFields("Picture Footer Report");

                GeneralSetup.Get();
                if GeneralSetup."Active Watermark Ship. Doc." then begin
                    lPostedWhseShipmentHeader2.CopyFilters(PostedWhseShipmentHeader);
                    if lPostedWhseShipmentHeader2.FindFirst() then begin
                        lCanceled := lPostedWhseShipmentHeader2."AltAWPDocument Canceled";
                        if lPostedWhseShipmentHeader2.FindSet() then begin
                            repeat
                                if (lCanceled <> lPostedWhseShipmentHeader2."AltAWPDocument Canceled") then begin
                                    Error(lError01);
                                end;
                            until (lPostedWhseShipmentHeader2.Next() = 0);
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
                field(NoOfCopies_Field; NoOfCopies)
                {
                    ApplicationArea = All;
                    Caption = 'Nr. copie';
                }
                field(PrintItemCrossRef_Field; PrintItemCrossRefOpt)
                {
                    ApplicationArea = All;
                    Caption = 'Show item references', Comment = 'Codici da Cross Reference';
                    OptionCaption = 'Customer Default,Yes,No';
                }
                field(ShowTariffNo_Field; ShowTariffNoOpt)
                {
                    ApplicationArea = All;
                    Caption = 'Show Tariff No.', Comment = 'Mostra Nomenclatura Combinata';
                    OptionCaption = 'Customer Default,Yes,No';
                }
                field(ShowTrackingInfo_Field; ShowTrackingInfoOpt)
                {
                    ApplicationArea = All;
                    Caption = 'Show tracking info';
                    OptionCaption = 'Customer Default,None,Standard,Extended';
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    var
        latsSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        NoOfCopies := 0;

        if latsSessionDataStore.ExistsSessionSetting('AWP_PRINTCOPIESNO') then begin
            SetNoOfCopies(latsSessionDataStore.GetSessionSettingNumericValue('AWP_PRINTCOPIESNO'));
        end;
    end;

    procedure SetNoOfCopies(pNoOfCopies: Integer)
    begin
        NoOfCopies := pNoOfCopies;
    end;

    procedure GetCashDeliveryExtText()
    var
        lPaymentMethod: Record "Payment Method";
        lExtendedTextHeader: Record "Extended Text Header";
        lExtendedTextLine: Record "Extended Text Line";
        lExtendedTextLineText: Text;
        lCR: Char;
        lLF: Char;
        lText01: Label 'Importo contrassegno/Cash on delivery: %1', Locked = true;
    begin
        Clear(CashDeliveryExtText);

        if not lPaymentMethod.Get(PostedWhseShipmentHeader."AltAWPPayment Method Code") or (lPaymentMethod."AltAWPCash On Del. Ext. Text" = '') then begin
            exit;
        end;

        lCR := 13;
        lLF := 10;

        lExtendedTextHeader.SetRange("Table Name", lExtendedTextHeader."Table Name"::"Standard Text");
        lExtendedTextHeader.SetRange("No.", lPaymentMethod."AltAWPCash On Del. Ext. Text");
        lExtendedTextHeader.SetRange("Language Code", LanguageCode);
        if lExtendedTextHeader.IsEmpty then begin
            lExtendedTextHeader.SetRange("Language Code");
            lExtendedTextHeader.SetRange("All Language Codes", true);
        end;
        if lExtendedTextHeader.FindLast() then begin
            lExtendedTextLine.SetRange("Table Name", lExtendedTextHeader."Table Name");
            lExtendedTextLine.SetRange("No.", lExtendedTextHeader."No.");
            lExtendedTextLine.SetRange("Language Code", lExtendedTextHeader."Language Code");
            lExtendedTextLine.SetRange("Text No.", lExtendedTextHeader."Text No.");
            if lExtendedTextLine.FindSet() then begin
                repeat
                    lExtendedTextLineText := lExtendedTextLine.Text;
                    if (StrPos(lExtendedTextLineText, '%1') > 0) then begin
                        lExtendedTextLineText := StrSubstNo(lExtendedTextLineText, Format(PostedWhseShipmentHeader."AltAWPCash On Delivery Value", 0, '<Precision,2:2><Standard Format,0>'));
                    end;

                    if (CashDeliveryExtText = '') then begin
                        CashDeliveryExtText := lExtendedTextLineText;
                    end else begin
                        CashDeliveryExtText := CashDeliveryExtText + Format(lCR) + Format(lLF) + lExtendedTextLineText;
                    end;
                until (lExtendedTextLine.Next() = 0);
            end;
        end;

        if (CashDeliveryExtText = '') then begin
            CashDeliveryExtText := StrSubstNo(lText01, Format(PostedWhseShipmentHeader."AltAWPCash On Delivery Value", 0, '<Precision,2:2><Standard Format,0>'));
        end;
    end;

    local procedure ExistsLinesAttachedAfter(var pPostedWhseShipmentLine: Record "Posted Whse. Shipment Line"): Boolean
    var
        lPostedWhseShipmentLine2: Record "Posted Whse. Shipment Line";
    begin
        Clear(lPostedWhseShipmentLine2);
        if (pPostedWhseShipmentLine."AltAWPElement Type" <> pPostedWhseShipmentLine."AltAWPElement Type"::" ") or
           (pPostedWhseShipmentLine."AltAWPAttached to Source Line" <> 0)
        then begin
            lPostedWhseShipmentLine2.SetRange("No.", pPostedWhseShipmentLine."No.");
            lPostedWhseShipmentLine2.SetFilter("Line No.", '>%1', pPostedWhseShipmentLine."Line No.");
            if (pPostedWhseShipmentLine."AltAWPElement Type" = pPostedWhseShipmentLine."AltAWPElement Type"::" ") and
               (pPostedWhseShipmentLine."AltAWPAttached to Source Line" <> 0)
            then begin
                lPostedWhseShipmentLine2.SetRange("AltAWPAttached to Source Line", pPostedWhseShipmentLine."AltAWPAttached to Source Line");
            end else begin
                lPostedWhseShipmentLine2.SetRange("AltAWPAttached to Source Line", pPostedWhseShipmentLine."Source Line No.");
            end;
            if not lPostedWhseShipmentLine2.IsEmpty then begin
                exit(true)
            end else begin
                if (pPostedWhseShipmentLine."AltAWPElement Type" = pPostedWhseShipmentLine."AltAWPElement Type"::" ") and
                   (pPostedWhseShipmentLine."AltAWPAttached to Source Line" <> 0)
                then begin
                    lPostedWhseShipmentLine2.SetRange("AltAWPAttached to Source Line");
                    lPostedWhseShipmentLine2.SetFilter("Source Line No.", '>%1 & =%2', pPostedWhseShipmentLine."Source Line No.", pPostedWhseShipmentLine."AltAWPAttached to Source Line");
                    if not lPostedWhseShipmentLine2.IsEmpty then exit(true);
                end;
            end;
        end else begin
            if (pPostedWhseShipmentLine."AltAWPElement Type" = pPostedWhseShipmentLine."AltAWPElement Type"::" ") then begin
                lPostedWhseShipmentLine2.SetRange("No.", pPostedWhseShipmentLine."No.");
                lPostedWhseShipmentLine2.SetFilter("Line No.", '>%1', pPostedWhseShipmentLine."Line No.");
                if not lPostedWhseShipmentLine2.IsEmpty then begin
                    lPostedWhseShipmentLine2.FindFirst();
                    if (lPostedWhseShipmentLine2."AltAWPElement Type" = lPostedWhseShipmentLine2."AltAWPElement Type"::" ") and
                       (lPostedWhseShipmentLine2."AltAWPAttached to Source Line" = 0)
                    then begin
                        exit(true);
                    end;
                end;
            end;
        end;

        exit(false);
    end;

    var
        GeneralSetup: Record "AltAWPGeneral Setup";
        ShipmentProfile: Record "AltAWPShipping Profile";
        CompanyInformation: Record "Company Information";
        Customer: Record Customer;
        Location: Record Location;
        PaymentMethod: Record "Payment Method";
        PaymentTerms: Record "Payment Terms";
        ShiptoAddress: Record "Ship-to Address";
        ShipmentMethod: Record "Shipment Method";
        ShippingAgent: Record "Shipping Agent";
        Temp_TrackingSpecification: Record "Tracking Specification" temporary;
        Vendor: Record Vendor;
        PrintFunctions: Codeunit "AltAWPPrint Functions";
        FormatAddress: Codeunit "Format Address";
        awpCommentsManagement: Codeunit "AltAWPComments Management";
        DepotsList: array[8] of Text;
        DestinationPhone: Text;
        DocumentDescr: Text;
        GoodsAspectDesc: Text;
        HeaderInformationArray: array[10] of Text;
        ImageBase64String: Text;
        PayMethDescr: Text;
        CompositionText: Text;
        PayTermDescr: Text;
        PrintDocumentType: Text;
        PrintElementNo: Text;
        ReasonDescr: Text;
        SalePriceText: Text;
        SpecialPaymentConditions: Text;
        TxtCancelledDoc: Text;
        HeaderCommentText: Text;
        ReportTitle: Text;
        LastHeaderInformationArrayText: Text;
        DestPhoneNo: Text[30];
        TariffNo: Text;
        ItemReferenceNo: Text;
        TrackingInfoLine: Text;
        CountryOrigin: Text;
        SSCCInfo: Text;
        CompanyAddr: array[8] of Text[50];
        SellToAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        BillToAddr: array[8] of Text[50];
        CashDeliveryExtText: Text;
        LanguageCode: Code[10];
        DestFiscalCode: Code[30];
        DestVATRegNo: Code[30];
        KitProdExhibitor_UMC: Code[10];
        TotalParcels: Decimal;
        KitProdExhibitor_Quantity: Decimal;
        KitProdExhibitor_QuantityUMC: Decimal;
        KitProdExhibitor_NetWeight: Decimal;
        NoOfCopies: Integer;
        ClearLogo: Boolean;
        PrintDesignCardExternalRef: Boolean;
        PrintItemCrossRefOpt: Option "Customer Default",Yes,No;
        ShowTariffNoOpt: Option "Customer Default",Yes,No;
        ShowTrackingInfoOpt: Option "Customer Default",None,Standard,Extended;
        IsNewLine: Boolean;
        //NoField: Text;
        //Counter: Integer;
        //LogisticDescription: Text;
        lblAlboTrasp: Label 'N. Iscrizione Albo';
        lblBank: Label 'Bank';
        lblCancelledDoc: Label '*CANCELED DOCUMENT*';
        lblCarriage: Label 'Carriage';
        lblCarriers: Label 'CARRIERS';
        lblCompany: Label 'Company';
        lblCompanyInfo: Label 'CLIENT/OWNER DATA', Comment = 'DATI COMMITTENTE/PROPRIETARIO';
        lblConai: Label 'Conai - Polieco contribution paid where due';
        lblContinue: Label 'Continue ->';
        lblCustSignature: Label 'Customer Signature';
        lblDescrDoc001: Label 'ORIGINAL FOR THE SENDER', Comment = 'ORIGINALE PER IL MITTENTE';
        lblDescrDoc002: Label 'ORIGINAL FOR THE RECIPIENT', Comment = 'ORIGINALE PER IL DESTINATARIO';
        lblDescrDoc003: Label 'COPY FOR VECTOR', Comment = 'COPIA PER IL VETTORE';
        lblDescrDocDefault: Label 'COPY', Comment = 'COPIA';
        lblDescription: Label 'Description';
        lblDestination: Label 'DESTINATION';
        lblDocNoWithDate: Label '%1 of %2';
        lblDocType: Label 'Shipping Document DPR 472 of 14/8/96';
        lblDocType2: Label 'Shipping Document';
        lblDocumentDate: Label 'Document Date';
        lblDocumentNo: Label 'Shipping Doc. No.';
        lblDocumentType: Label 'SHIPPING DOCUMENT';
        lblDocumentType2: Label '(D.P.R. 14 Agosto 1996 n.472)';
        lblDocumentType3: Label 'DDT con scheda di Trasporto Integrata (D.lgs.286/2005)';
        lblDriverSignature: Label 'Driver Signature';
        lblElectrSigned: Label 'ELECTRONIC SIGNED';
        lblFiscalCode: Label 'Fiscal Code';
        lblFreightType: Label 'Handling liable to';
        lblGoodAspect: Label 'Good Aspect';
        lblGrossWeight: Label 'Gross Weight';
        lblHandlingCompany: Label 'Handling Company';
        lblIBAN: Label 'IBAN';
        lblItemNo: Label 'Part No.';
        lblNetWeight: Label 'Net Weight';
        lblQuantityUMC: Label 'Q.ty UMC';
        lblNetKG: Label 'Net KG';
        lblUMC: Label 'UMC';
        lblNotes: Label 'Notes:';
        lblPageNo: Label 'Page';
        lblParcelNo: Label 'Parcels No.';
        lblPayMeth: Label 'Payment method';
        lblPayTerm: Label 'Term conditions';
        lblPhoneNo: Label 'Phone', Comment = 'Telefono';
        lblPlateNo: Label 'Plate No.';
        lblQuantity: Label 'Qty UM';
        lblRecipient: Label 'RECIPIENT';
        lblResidence: Label 'Residence';
        lblSaleCondition: Label 'Sale conditions on ';
        lblShipMethod: Label 'Shipment Method Code';
        lblShippingAddress: Label 'Shipping Address';
        lblShippingAgent: Label 'Shipping Agent (Name,Address,City)';
        lblShippingType: Label 'Shipping Type';
        lblShipStartDate: Label 'Date and Time';
        lblShipStartingDate: Label 'Start Delivery Date';
        lblSignature: Label 'Signature';
        lblSourceLocation: Label 'Warehouse';
        lblComposedBy: Label 'Composition detail of item no. %1:';
        lblSubjectNo: Label 'Subject No.';
        lblTDDPreparedBy: Label 'Document prepared by';
        lblTextWord01: Label 'Dear';
        lblTransportReason: Label 'Shipment Reason Code';
        lblUM: Label 'UM';
        lblVariant: Label 'Item variant: ';
        lblVarRegNo: Label 'VAT Registration No.';
        lblVatRegNo2: Label 'VAT Reg. No.';
        lblShipment: Label 'SHIPMENT';
        lblOrigin: Label 'Origin: ';
        lblExpirationDate: Label 'Expiration date: %1';
        lblLotNo: Label ' Lot No.: %1';
        lblLotQty: Label ' Qty: %1';
        lblSSCC: Label 'SSCC: ';
        lblPalletNo: Label 'Logistics units no.';
        lblMandatoryDeliveryDate: Label 'Mandatory delivery date:';
        lblTariffNo: Label 'H.S. Code : %1';
        lblItemRefrenceNo: Label 'Item ref. no. : %1';
        Text001: Label '%1 %2 %3', Locked = true;
        Text002: Label '%1 %2 %3 %4', Locked = true;
        lblNoOfPalletPlaces: Label 'No. of pallet places';
    //lblNo: Label '-No.';

    protected var
        AccompDataCaption_Text: Text;

    protected var
        AccompDataValue_Text: Text;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostedWhseShipmentHeaderOnAfterGetRecord(pPostedWhseShipmentHeader: Record "Posted Whse. Shipment Header"; var pLastHeaderInformationArrayText: Text)
    begin
    end;
}