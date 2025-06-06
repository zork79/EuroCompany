namespace EuroCompany.BaseApp.Sales.Reports;

using Microsoft.Bank.BankAccount;
using Microsoft.CRM.Contact;
using Microsoft.CRM.Segment;
using Microsoft.CRM.Team;
using Microsoft.Finance.Currency;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.VAT.Calculation;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Foundation.Address;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.Company;
using Microsoft.Foundation.PaymentTerms;
using Microsoft.Foundation.Shipping;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;
using Microsoft.Sales.Receivables;
using Microsoft.Warehouse.Ledger;
using System.Utilities;

report 50018 "ecShipping Invoice"
{
    ApplicationArea = All;
    Caption = 'Shipping Invoice';
    DefaultLayout = RDLC;
    Description = 'GAP_VEN_001';
    EnableHyperlinks = true;
    RDLCLayout = '.\src\EuroCompany\BaseApp\Sales\Reports\ShippingInvoice.Layout.rdlc';
    UsageCategory = None;

    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.")
                                order(ascending) where("AltAWPIs Shipping Invoice" = const(true));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            column(BankDescr; BankDescr)
            {
            }
            column(BillToCustomerNo; SalesHeader."Bill-to Customer No.")
            {
            }
            column(Company_Email; CompanyInfo."E-Mail")
            {
            }
            column(Company_FaxNo; CompanyInfo."Fax No.")
            {
            }
            column(Company_HomePage; CompanyInfo."Home Page")
            {
            }
            column(Company_Logo; CompanyInfo.Picture)
            {
            }
            column(Company_Logo4; GeneralSetup."Picture Footer Report")
            {
            }
            column(Company_Name; CompanyInfo.Name)
            {
            }
            column(Company_PhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(Company_URLSaleCondition; GeneralSetup."URL Sale Condition")
            {
            }
            column(Company_VATRegNo; PrintFunctions.PrintVatRegistrationNo(CompanyInfo."VAT Registration No.", CompanyInfo."Country/Region Code"))
            {
            }
            column(CompanyOfficeAddress1; CompanyOfficeAddress[1])
            {
            }
            column(CompanyOfficeAddress2; CompanyOfficeAddress[2])
            {
            }
            column(ConaiHide; ConaiHide)
            {
            }
            column(CreditBankAccountNo; CreditBankAccount)
            {
            }
            column(Currency; CurrencyDescr)
            {
            }
            column(CurrencyFactor; "Currency Factor")
            {
            }
            column(Cust_Addr1; CustAddr[1])
            {
            }
            column(Cust_Addr2; CustAddr[2])
            {
            }
            column(Cust_Addr3; CustAddr[3])
            {
            }
            column(Cust_Addr4; CustAddr[4])
            {
            }
            column(Cust_Addr5; CustAddr[5])
            {
            }
            column(Cust_Addr6; CustAddr[6])
            {
            }
            column(Cust_Addr7; CustAddr[7])
            {
            }
            column(Cust_Addr8; CustAddr[8])
            {
            }
            column(Cust_FiscalCode; Cust."Fiscal Code")
            {
            }
            column(Cust_PhoneNo; Cust."Phone No.")
            {
            }
            column(Cust_VatRegNo; PrintFunctions.PrintVatRegistrationNo(Cust."VAT Registration No.", Cust."Country/Region Code"))
            {
            }
            column(DocumentNo; "No.")
            {
            }
            column(FreightType; Format("AltAWPFreight Type"))
            {
            }
            column(Your_Reference; "Your Reference")
            {
            }
            column(GoodAspect; "AltAWPGoods Appearance")
            {
            }
            column(GrossWeight; "AltAWPGross Weight")
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
            column(lblBillToCustomer; lblBillToCustomer)
            {
            }
            column(lblChange; lblChange)
            {
            }
            column(lblCode; lblCode)
            {
            }
            column(lblConai; lblConai)
            {
            }
            column(lblCreditBankAccount; lblCreditBankAccount)
            {
            }
            column(lblCurrency; lblCurrency)
            {
            }
            column(lblCustomerNo; lblCustomerNo)
            {
            }
            column(lblCustSignature; lblCustSignature)
            {
            }
            column(lblDeliveryTerms; lblDeliveryTerms)
            {
            }
            column(lblDescription; lblDescription)
            {
            }
            column(lblDiscount; lblDiscount)
            {
            }
            column(lblDocumentDate; lblDocumentDate)
            {
            }
            column(lblDocumentNo; lblDocumentNo)
            {
            }
            column(lblDocumentTotal; lblDocumentTotal)
            {
            }
            column(lblDocumentType; lblDocumentType)
            {
            }
            column(lblDriverSignature; lblDriverSignature)
            {
            }
            column(lblExporterCode; lblExporterCode)
            {
            }
            column(lblFax; lblFax)
            {
            }
            column(lblFiscalCode; lblFiscalCode)
            {
            }
            column(lblGoodAspect; lblGoodAspect)
            {
            }
            column(lblGrossWeight; lblGrossWeight)
            {
            }
            column(lblHeadOffice; lblRegOffice)
            {
            }
            column(lblInvoiceDisc; lblInvoiceDisc)
            {
            }
            column(lblInvoiceDiscPerc; lblInvoiceDiscPerc)
            {
            }
            column(lblLineAmt; lblLineAmt)
            {
            }
            column(lblNetToPay; lblNetToPay)
            {
            }
            column(lblNetWeight; lblTotNetWeight)
            {
            }
            column(lblUMC; lblUMC)
            {
            }
            column(lblQuantityUMC; lblQuantityUMC)
            {
            }
            column(lblUMCPrice; lblUMCPrice)
            {
            }
            column(lblTotGrossWeight; lblTotGrossWeight)
            {
            }
            column(lblShipStartingTime; lblShipStartingTime)
            {
            }
            column(lblNoOfPalletPlaces; lblNoOfPalletPlaces)
            {
            }
            column(lblShippingCompanyData; lblShippingCompanyData)
            {
            }
            column(lblTotalParcels; lblTotalParcels)
            {
            }
            column(lblNote; lblNote)
            {
            }
            column(lblOffice; lblOffice)
            {
            }
            column(lblPalletNo; lblPalletNo)
            {
            }
            column(lblPackagesNo; lblPackagesNo)
            {
            }
            column(lblPageNo; lblPageNo)
            {
            }
            column(lblPaymentMethod; lblPaymentMethod)
            {
            }
            column(lblPaymentTerms; lblPaymentTerms)
            {
            }
            column(lblPhone; lblPhone)
            {
            }
            column(lblPmtExpiry; lblPmtExpiry)
            {
            }
            column(lblProject; lblProject)
            {
            }
            column(lblQuantity; lblQuantity)
            {
            }
            column(lblQuoteRef; lblQuoteRef)
            {
            }
            column(lblRev; lblRev)
            {
            }
            column(lblSaleCondition; lblSaleCondition)
            {
            }
            column(lblSalesperson; lblSalesperson)
            {
            }
            column(lblShipmentType; lblShipmentType)
            {
            }
            column(lblShippingAgent; lblShippingAgent)
            {
            }
            column(lblShippingType; lblShippingType)
            {
            }
            column(lblShipStartingDate; lblShipStartingDate)
            {
            }
            column(lblShipTo; lblShipTo)
            {
            }
            column(lblSpecialPaymentConditions; lblSpecialPaymentConditions)
            {
            }
            column(lblText001; lblText001)
            {
            }
            column(lblTitle; lblTitle)
            {
            }
            column(lblTotalAmt; lblTotalAmt)
            {
            }
            column(lblTotalAmtForDisc; lblTotalAmtForDisc)
            {
            }
            column(lblTotalDocument; lblTotalDocument)
            {
            }
            column(lblTotalGift; lblTotalGift)
            {
            }
            column(lblTransportReason; lblTransportReason)
            {
            }
            column(lblUM; lblUM)
            {
            }
            column(lblUnitPrice; lblUnitPrice)
            {
            }
            column(lblVariant; lblVariant)
            {
            }
            column(lblVAT; lblVAT)
            {
            }
            column(lblVATAmount; lblVATAmount)
            {
            }
            column(lblVATAmount2; lblVATAmount2)
            {
            }
            column(lblVATBaseAmt; lblVATBaseAmt)
            {
            }
            column(lblVATCode; lblVATCode)
            {
            }
            column(lblVATDescription; lblVATDescription)
            {
            }
            column(lblVatRegFiscalCode; lblVatRegFiscalCode)
            {
            }
            column(lblVatRegNo; lblVatRegNo)
            {
            }
            column(lblVATTaxable; lblVATTaxable)
            {
            }
            column(lblVATTotalAmount; lblVATTotalAmount)
            {
            }
            column(lblVATTotalBaseAmount; lblVATTotalBaseAmount)
            {
            }
            column(lblYourRef; lblYourRef)
            {
            }
            column(NetWeight; "AltAWPNet Weight")
            {
            }
            column(ParcelNo; "AltAWPParcel Units")
            {
            }
            column(NoPalletPlaces; "AltAWPNo. Pallet Places")
            {
            }
            column(PaymentTermsDescription; PayMethDescr)
            {
            }
            column(PaymentTermsText; PaymentTermsText)
            {
            }
            column(PostingDate; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(PrintTotals; PrintTotals)
            {
            }
            column(ReasonDescr; ReasonDescr)
            {
            }
            column(SalespersonCode; Salesperson_Code_Name)
            {
            }
            column(SellToCustomerNo; SalesHeader."Sell-to Customer No.")
            {
            }
            column(ShipmentMethodDescription; ShipMethDescr)
            {
            }
            column(ShippingAgent_Name; ShippingAgent.Name)
            {
            }
            column(ShippingAgentAddress; ShippingAgent.Address + ', ' + StrSubstNo(Text001, ShippingAgent."AltAWPPost Code", ShippingAgent.AltAWPCity, ShippingAgent.AltAWPCounty))
            {
            }
            column(ShippingAgentAlboTrasp; ShippingAgent."AltAWPRegistration No.")
            {
            }
            column(ShippingStartingDate; Format("AltAWPShipping Starting Date"))
            {
            }
            column(ShippingStartingTime; Format("AltAWPShipping Starting Time"))
            {
            }
            column(ShipTo_Addr1; ShipToAddr[1])
            {
            }
            column(ShipTo_Addr2; ShipToAddr[2])
            {
            }
            column(ShipTo_Addr3; ShipToAddr[3])
            {
            }
            column(ShipTo_Addr4; ShipToAddr[4])
            {
            }
            column(ShipTo_Addr5; ShipToAddr[5])
            {
            }
            column(ShipTo_Addr6; ShipToAddr[6])
            {
            }
            column(ShipTo_Addr7; ShipToAddr[7])
            {
            }
            column(ShipTo_Addr8; ShipToAddr[8])
            {
            }
            column(YourReference; "Your Reference")
            {
            }
            column(lblTrailerPlate; lblTrailerPlate)
            {
            }
            column(lblTruckerPlate; lblTruckerPlate)
            {
            }
            column(lblContainerNumber; lblContainerNumber)
            {
            }
            column(lblSeal1; lblSeal1)
            {
            }
            column(lblSeal2; lblSeal2)
            {
            }
            column(lblSeal3; lblSeal3)
            {
            }
            column(ContainerNumber; "AltAWPContainer Number")
            {
            }
            column(TrailerPlate; "AltAWPTrailer Plate")
            {
            }
            column(TruckerPlate; "AltAWPTrucker Plate")
            {
            }
            column(Seal1; "AltAWPSeal 1")
            {
            }
            column(Seal2; "AltAWPSeal 2")
            {
            }
            column(Seal3; "AltAWPSeal 3")
            {
            }
            column(OtherAccompData1; "AltAWPOther Accomp. Data 1")
            {
            }
            column(OtherAccompData2; "AltAWPOther Accomp. Data 2")
            {
            }
            column(OtherAccompData3; "AltAWPOther Accomp. Data 3")
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
                DataItemTableView = sorting(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = sorting(Number)
                                        where(Number = const(1));
                    column(OutputNo; OutputNo)
                    {
                    }
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = SalesInvoiceHeader;
                        DataItemTableView = sorting(Number)
                                            where(Number = filter(1 ..));
                        column(HeaderDimension_Number; DimensionLoop1.Number)
                        {
                        }
                        column(HeaderDimension_Text; DimText)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.Find('-') then
                                    CurrReport.Break();
                            end else
                                if not Continue then
                                    CurrReport.Break();

                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo(Text01, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText := StrSubstNo(Text02, DimText, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next() = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break();
                        end;
                    }
                    dataitem("Sales Invoice Line"; "Sales Invoice Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = SalesInvoiceHeader;
                        DataItemTableView = sorting("Document No.", "Line No.")
                                            order(ascending);
                        column(SalesInvLine_ComposedDiscount; ComposedDiscount)
                        {
                        }
                        column(SalesInvLine_Description; Temp_SalesInvLine_Print.Description)
                        {
                        }
                        column(SalesInvLine_Description2; Temp_SalesInvLine_Print."Description 2")
                        {
                        }
                        column(SalesInvLine_LineAmount; Temp_SalesInvLine_Print."Line Amount")
                        {
                            AutoFormatExpression = SalesHeader."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesInvLine_LineNo; "Line No.")
                        {
                        }
                        column(SalesInvLine_No; Temp_SalesInvLine_Print."No.")
                        {
                        }
                        column(SalesInvLine_Quantity; Temp_SalesInvLine_Print.Quantity)
                        {
                            DecimalPlaces = 0 : 2;
                        }
                        column(SalesInvLine_TariffNo; TariffNo)
                        {
                        }
                        column(SalesInvLine_TextRefCDep; TextRefCDep)
                        {
                        }
                        column(SalesInvLine_Type; Temp_SalesInvLine_Print.Type.AsInteger())
                        {
                        }
                        column(SalesInvLine_UM; Temp_SalesInvLine_Print."Unit of Measure Code")
                        {
                        }
                        column(SalesInvLine_UnitPrice; Temp_SalesInvLine_Print."Unit Price")
                        {
                            AutoFormatExpression = SalesInvoiceHeader."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(SalesInvLine_VariantCode; Temp_SalesInvLine_Print."Variant Code")
                        {
                        }
                        column(SalesInvLine_VATIdentifier; Temp_SalesInvLine_Print."VAT Identifier")
                        {
                        }
                        column(TrackingString; TrackingString)
                        {
                        }
                        column(SalesInvLine_TotalNetWeight; Temp_SalesInvLine_Print."AltAWPTotal Net Weight")
                        {
                            DecimalPlaces = 0 : 2;
                        }
                        column(SalesInvLine_ConsumerUnitofMeasure; Temp_SalesInvLine_Print."ecConsumer Unit of Measure")
                        {
                        }
                        column(SalesInvLine_QtyConsumerUM; Temp_SalesInvLine_Print."ecQuantity (Consumer UM)")
                        {
                            DecimalPlaces = 0 : 2;
                        }
                        column(SalesInvLine_UnitPriceConsumerUM; Temp_SalesInvLine_Print."ecUnit Price (Consumer UM)")
                        {
                            DecimalPlaces = 2 : 5;
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

                            trigger OnPreDataItem()
                            begin
                                if ShowTrackingInfoOpt = ShowTrackingInfoOpt::None then CurrReport.Break();

                                SetRange("Whse. Document No.", "Sales Invoice Line"."AltAWPPosted Whse Shipment No.");
                                SetRange("Whse. Document Line No.", "Sales Invoice Line"."AltAWPPosted Whse Ship. Line");
                                SetRange("Whse. Document Type", "Whse. Document Type"::Shipment);
                            end;
                        }

                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = sorting(Number)
                                                where(Number = filter(1 ..));
                            column(LineDimension_Number; DimensionLoop2.Number)
                            {
                            }
                            column(LineDimension_Text; DimText)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FindSet() then
                                        CurrReport.Break();
                                end else
                                    if not Continue then
                                        CurrReport.Break();

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo(Text01, DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText := StrSubstNo(Text02, DimText, DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next() = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                CurrReport.Break();

                                DimSetEntry2.SetRange("Dimension Set ID", "Sales Invoice Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            lUnitofMeasure: Record "Unit of Measure";
                            lSalesInvoiceLine: Record "Sales Invoice Line";
                            lAPsFOCPostingSetup: Record "APsFOC Posting Setup";
                            lAWPPrintFunctions: Codeunit "AltAWPPrint Functions";
                            lRecordVariant: Variant;
                        begin
                            Temp_SalesInvLine_Print := "Sales Invoice Line";

                            //AWP091-VI-s
                            if ("Sales Invoice Line".Type = "Sales Invoice Line".Type::" ") and
                               ("Sales Invoice Line"."AltAWPComment Reason Code" <> '')
                            then begin
                                if not awpCommentsManagement.IsValidCommentReasonByReport("Sales Invoice Line"."AltAWPComment Reason Code",
                                                                                          Report::"AltAWPShipping Invoice")
                                then begin
                                    CurrReport.Skip();
                                end;
                            end;
                            //AWP091-VI-e                               

                            if not SalesInvoiceHeader."Prices Including VAT" and
                               ("VAT Calculation Type" = "VAT Calculation Type"::"Full VAT")
                            then begin
                                "Line Amount" := 0;
                            end;

                            if (Temp_SalesInvLine_Print."ecConsumer Unit of Measure" = '') then begin
                                Temp_SalesInvLine_Print."ecConsumer Unit of Measure" := Temp_SalesInvLine_Print."Unit of Measure Code";
                                Temp_SalesInvLine_Print."ecQuantity (Consumer UM)" := Temp_SalesInvLine_Print.Quantity;
                                Temp_SalesInvLine_Print."ecUnit Price (Consumer UM)" := Temp_SalesInvLine_Print."Unit Price";
                            end;

                            if (Type <> Type::" ") and
                               (Quantity <> 0) and
                               ("Unit Price" <> 0)
                            then begin
                                Temp_VATAmountLine.Init();
                                Temp_VATAmountLine."VAT Identifier" := "VAT Identifier";
                                Temp_VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                                Temp_VATAmountLine."Tax Group Code" := "Tax Group Code";
                                Temp_VATAmountLine."VAT %" := "VAT %";
                                Temp_VATAmountLine."VAT Base" := Amount;
                                Temp_VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                                Temp_VATAmountLine."Line Amount" := "Line Amount";
                                if "Allow Invoice Disc." then
                                    Temp_VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                                Temp_VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                                Temp_VATAmountLine.InsertLine();
                            end;

                            if PaymentMethod.Get(SalesInvoiceHeader."Payment Method Code") then begin
                                case PaymentMethod."Free Type" of
                                    PaymentMethod."Free Type"::"Only VAT Amt.":
                                        begin
                                            FreeInvTxt := '';
                                        end;
                                end;
                            end;

                            DocumentGrossAmount += "Line Amount";

                            PrintCashVATFooter := PrintCashVATFooter or ("VAT Prod. Posting Group" = CashVATProdGrp);
                            TariffNo := '';
                            ItemReferenceNo := '';
                            if (Temp_SalesInvLine_Print.Type = Temp_SalesInvLine_Print.Type::Item) then begin
                                if (ShowTariffNoOpt = ShowTariffNoOpt::Yes) then begin
                                    if Item.Get(Temp_SalesInvLine_Print."No.") and (Item."Tariff No." <> '') then begin
                                        TariffNo := StrSubstNo(lblTariffNo, Item."Tariff No.");
                                    end;
                                end;
                                if (PrintItemCrossRefOpt = PrintItemCrossRefOpt::Yes) then begin
                                    if (Temp_SalesInvLine_Print."Item Reference No." <> '') then begin
                                        ItemReferenceNo := StrSubstNo(lblItemRefrenceNo, Temp_SalesInvLine_Print."Item Reference No.");
                                    end;
                                end;
                            end;
                            if (Temp_SalesInvLine_Print.Type = Temp_SalesInvLine_Print.Type::" ") then begin
                                Temp_SalesInvLine_Print."No." := '';
                            end;

                            ComposedDiscount := Temp_SalesInvLine_Print."APsComposed Discount";
                            lRecordVariant := Temp_SalesInvLine_Print;
                            lAWPPrintFunctions.ManageComposedDiscountValue(lRecordVariant, ComposedDiscount);

                            lAWPPrintFunctions.GetDocumentLayoutType(SalesInvoiceHeader, LayoutType);
                            case LayoutType of
                                LayoutType::"Net Price":
                                    begin
                                        ComposedDiscount := '';
                                        if (Temp_SalesInvLine_Print.Quantity <> 0) then begin
                                            if (Temp_SalesInvLine_Print."Line Discount %" <> 0) then begin
                                                Temp_SalesInvLine_Print."Unit Price" := Temp_SalesInvLine_Print."Line Amount" / Temp_SalesInvLine_Print.Quantity;
                                            end;
                                        end else begin
                                            Temp_SalesInvLine_Print."Unit Price" := 0;
                                        end;
                                    end;

                                LayoutType::"No Price":
                                    begin
                                        ComposedDiscount := '';
                                        Temp_SalesInvLine_Print."Unit Price" := 0;
                                        Temp_SalesInvLine_Print."Line Amount" := 0;
                                        Temp_SalesInvLine_Print."VAT Identifier" := '';
                                    end;
                            end;

                            OrderRef := "Order No.";
                            if "Order No." <> '' then begin
                                if SalesOrder.Get(SalesOrder."Document Type"::Order, "Order No.") then begin
                                    if SalesOrder."External Document No." <> '' then begin
                                        OrderRef := OrderRef + '\' + SalesOrder."External Document No.";
                                    end;
                                end;
                            end;

                            if "Prepayment Line" then begin
                                PrepmtLineExists := true;
                            end;

                            TrackingString := PrintFunctions.GetTrackingString("Sales Invoice Line");

                            if (Temp_SalesInvLine_Print."APsFOC Attach. to Line No." <> 0) then begin
                                if lSalesInvoiceLine.Get(Temp_SalesInvLine_Print."Document No.", Temp_SalesInvLine_Print."APsFOC Attach. to Line No.") then begin
                                    if (lSalesInvoiceLine."APsFOC Code" <> '') and
                                       lAPsFOCPostingSetup.Get(lSalesInvoiceLine."APsFOC Code") and
                                       (lAPsFOCPostingSetup.Type = Temp_SalesInvLine_Print.Type) and
                                       (lAPsFOCPostingSetup."No." = Temp_SalesInvLine_Print."No.") and
                                       (lAPsFOCPostingSetup."FOC Type" in [lAPsFOCPostingSetup."FOC Type"::"Without VAT Charge",
                                                                           lAPsFOCPostingSetup."FOC Type"::"VAT Charge"])
                                    then begin
                                        TotalGifts += Abs(Temp_SalesInvLine_Print."Amount Including VAT");
                                    end;
                                end;
                            end;

                            if (Temp_SalesInvLine_Print.Type = Temp_SalesInvLine_Print.Type::Item) and lUnitofMeasure.Get(Temp_SalesInvLine_Print."Unit of Measure Code") and
                               (lUnitofMeasure."AltAWPType Unit Of Measure" = lUnitofMeasure."AltAWPType Unit Of Measure"::Parcels)
                            then begin
                                if (Temp_SalesInvLine_Print."ecAttacch. Kit/Exhib. Line No." <> 0) then TotalParcels += Temp_SalesInvLine_Print.Quantity;
                            end;
                            TotalNetWeight += Temp_SalesInvLine_Print."AltAWPTotal Net Weight";
                            TotalGrossWeight += Temp_SalesInvLine_Print."AltAWPTotal Gross Weight";

                            IsNewLine := (not ExistsLinesAttachedAfter(Temp_SalesInvLine_Print)) and (not ExistsKitExhibitorLinesAttachedAfter(Temp_SalesInvLine_Print));
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(CompanyInfo.Picture);

                            Temp_VATAmountLine.DeleteAll();
                            Temp_SalesShipmentBuffer.Reset();
                            Temp_SalesShipmentBuffer.DeleteAll();

                            FirstValueEntryNo := 0;
                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do begin
                                MoreLines := Next(-1) <> 0;
                            end;

                            if not MoreLines then begin
                                CurrReport.Break();
                            end;

                            SetFilter("Line No.", '..%1', "Line No.");
                            PrepmtLineExists := false;
                        end;
                    }
                    dataitem(PrepaymentDocuments; Integer)
                    {
                        DataItemTableView = sorting(Number)
                                            order(ascending);
                        column(Number_PrepmtDocuments; Number)
                        {
                        }
                        column(PrepmtLineDescr_PrepmtDocuments; PrepmtLineDescr)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            lTxt001: Label 'Invoice %1 dated %2';
                            lTxt002: Label 'Credit memo %1 dated %2';
                        begin
                            PrepmtLineDescr := '';
                            if (Number = 1) then begin
                                PrepmtLineDescr := TxtPrepmt001;
                            end else begin
                                if (Number = 2) then begin
                                    Temp_EntrySummary.FindSet();
                                end else begin
                                    Temp_EntrySummary.Next();
                                end;

                                case Temp_EntrySummary."Source Subtype" of
                                    0:
                                        begin  // Fattura
                                            PrepmtLineDescr := StrSubstNo(lTxt001, Temp_EntrySummary."Serial No.", Temp_EntrySummary."Expiration Date");
                                        end;

                                    1:
                                        begin  // Nota credito
                                            PrepmtLineDescr := StrSubstNo(lTxt002, Temp_EntrySummary."Serial No.", Temp_EntrySummary."Expiration Date");
                                        end;
                                end;
                            end;
                        end;

                        trigger OnPreDataItem()
                        var
                            lSalesInvoiceHeader: Record "Sales Invoice Header";
                            lSalesCrMemoHeader: Record "Sales Cr.Memo Header";
                            lSalesInvoiceLine: Record "Sales Invoice Line";
                            lEntryNo: Integer;
                        begin
                            if not PrepmtLineExists then CurrReport.Break();

                            lSalesInvoiceLine.Reset();
                            lSalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
                            lSalesInvoiceLine.SetFilter(Type, '>%1', lSalesInvoiceLine.Type::" ");
                            lSalesInvoiceLine.SetFilter("Order No.", '<>%1', '');
                            if lSalesInvoiceLine.FindFirst() then begin
                                lSalesInvoiceHeader.Reset();
                                lSalesInvoiceHeader.SetCurrentKey("Prepayment Order No.");
                                lSalesCrMemoHeader.Reset();
                                lSalesCrMemoHeader.SetCurrentKey("Prepayment Order No.");

                                lEntryNo := 0;

                                lSalesInvoiceHeader.SetRange("Prepayment Order No.", lSalesInvoiceLine."Order No.");
                                if lSalesInvoiceHeader.FindSet() then begin
                                    repeat
                                        lEntryNo += 1;
                                        Clear(Temp_EntrySummary);
                                        Temp_EntrySummary."Entry No." := lEntryNo;
                                        Temp_EntrySummary."Serial No." := lSalesInvoiceHeader."No.";
                                        Temp_EntrySummary."Expiration Date" := lSalesInvoiceHeader."Posting Date";
                                        Temp_EntrySummary."Source Subtype" := 0;
                                        Temp_EntrySummary.Insert();
                                    until (lSalesInvoiceHeader.Next() = 0);
                                end;
                                lSalesCrMemoHeader.SetRange("Prepayment Order No.", lSalesInvoiceLine."Order No.");
                                if lSalesCrMemoHeader.FindSet() then begin
                                    repeat
                                        lEntryNo += 1;
                                        Clear(Temp_EntrySummary);
                                        Temp_EntrySummary."Entry No." := lEntryNo;
                                        Temp_EntrySummary."Serial No." := lSalesCrMemoHeader."No.";
                                        Temp_EntrySummary."Expiration Date" := lSalesCrMemoHeader."Posting Date";
                                        Temp_EntrySummary."Source Subtype" := 1;
                                        Temp_EntrySummary.Insert();
                                    until (lSalesCrMemoHeader.Next() = 0);
                                end;
                            end;

                            Temp_EntrySummary.Reset();
                            Temp_EntrySummary.SetCurrentKey("Expiration Date");
                            if (Temp_EntrySummary.Count = 0) then CurrReport.Break();

                            SetRange(Number, 1, Temp_EntrySummary.Count + 1);
                        end;
                    }
                    dataitem(CreditBankDetails; Integer)
                    {
                        DataItemTableView = sorting(Number)
                                            order(ascending);
                        column(CreditBankDetails_CommentNumber; Number)
                        {
                        }
                        column(CreditBankDetailsComm; LineComment)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            LineComment := '';
                            case Number of
                                1:
                                    LineComment := TextCreditBank1;

                                2:
                                    begin
                                        if (BankAccount.Name <> '') then begin
                                            LineComment := StrSubstNo(TextCreditBank2, BankAccount.Name);
                                        end;
                                    end;

                                3:
                                    begin
                                        if (BankAccount.Address <> '') then begin
                                            LineComment := StrSubstNo(TextCreditBank3, BankAccount.Address);
                                        end;
                                    end;

                                4:
                                    begin
                                        if (BankAccount."Address 2" <> '') then begin
                                            LineComment := BankAccount."Address 2";
                                        end;
                                        if (BankAccount."Post Code" <> '') then begin
                                            if (LineComment <> '') then LineComment := LineComment + ' ';
                                            LineComment := LineComment + BankAccount."Post Code";
                                        end;
                                        if (BankAccount.City <> '') then begin
                                            if (LineComment <> '') then LineComment := LineComment + ' ';
                                            LineComment := LineComment + BankAccount.City;
                                        end;
                                        if (BankAccount.County <> '') then begin
                                            if (LineComment <> '') then LineComment := LineComment + ' ';
                                            LineComment := LineComment + '(' + BankAccount.County + ')';
                                        end;
                                        if (BankAccount."Country/Region Code" <> '') then begin
                                            if (LineComment <> '') then LineComment := LineComment + ' ';
                                            LineComment := LineComment + BankAccount."Country/Region Code";
                                        end;

                                        if (LineComment <> '') then begin
                                            LineComment := StrSubstNo(TextCreditBank4, LineComment);
                                        end;
                                    end;

                                5:
                                    begin
                                        if (BankAccount."Bank Account No." <> '') then begin
                                            LineComment := StrSubstNo(TextCreditBank5, BankAccount."Bank Account No.");
                                        end;
                                    end;

                                6:
                                    begin
                                        if (BankAccount."SWIFT Code" <> '') then begin
                                            LineComment := StrSubstNo(TextCreditBank6, BankAccount."SWIFT Code");
                                        end;
                                    end;
                                7:
                                    begin
                                        if (BankAccount.IBAN <> '') then begin
                                            LineComment := StrSubstNo(TextCreditBank7, BankAccount.IBAN);
                                        end;
                                    end;
                            end;
                            if (LineComment = '') then CurrReport.Skip();
                        end;

                        trigger OnPreDataItem()
                        begin

                            CurrReport.Break();
                        end;
                    }
                    dataitem(DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = SalesInvoiceHeader;
                        DataItemTableView = sorting("Document No.", "Document Type", "Posting Date")
                                            order(ascending)
                                            where("Document Type" = const(Invoice),
                                                  "Entry Type" = const("Initial Entry"));

                        trigger OnAfterGetRecord()
                        var
                            lCustLedgerEntry: Record "Cust. Ledger Entry";
                        begin
                            Ind += 1;
                            PaymentsAmountArray[Ind] := Amount;
                            PaymentsDateArray[Ind] := "Initial Entry Due Date";
                            lCustLedgerEntry.Get(DetailedCustLedgEntry."Cust. Ledger Entry No.");
                            PaymentArray[Ind] := StrSubstNo(lblDeadlinesAmount, Ind,
                                                            lCustLedgerEntry."Payment Method Code",
                                                            "Currency Code",
                                                            Amount,
                                                            Format("Initial Entry Due Date", 0, '<Day,2>/<Month,2>/<Year4>'))
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(PaymentsAmountArray);
                            Clear(PaymentsDateArray);
                            Clear(PaymentArray);
                            Ind := 0;
                        end;
                    }
                    dataitem(VATCounter; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(VATAmountLineInvDiscBaseAmt; Temp_VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = SalesHeader."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineLineAmount; Temp_VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = SalesHeader."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT; Temp_VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmountLineVATAmount; Temp_VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = SalesHeader."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVATBase; Temp_VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = SalesHeader."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVATIdent; Temp_VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmtLineInvDiscAmt; Temp_VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = SalesHeader."Currency Code";
                            AutoFormatType = 1;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            Temp_VATAmountLine.GetLine(Number);

                            Temp_VATAmountLine.CalcFields("VAT Description");
                            VATCodeArray[Number] := Temp_VATAmountLine."VAT Identifier";
                            VATDescrArray[Number] := Temp_VATAmountLine."VAT Description";
                            BaseAmountArray[Number] := Temp_VATAmountLine."VAT Base";
                            VATAmountArray[Number] := Temp_VATAmountLine."VAT Amount";


                            TotalInvDiscBaseAmt += Temp_VATAmountLine."Inv. Disc. Base Amount";
                            TotalInvDiscAmt += Temp_VATAmountLine."Invoice Discount Amount";
                        end;

                        trigger OnPostDataItem()
                        begin
                            InvDiscPerc := 0;
                            if (TotalInvDiscBaseAmt <> 0) then begin
                                InvDiscPerc := Round(TotalInvDiscAmt / TotalInvDiscBaseAmt * 100, 0.01);
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, Temp_VATAmountLine.Count);

                            TotalBaseAmount := Temp_VATAmountLine.GetTotalVATBase();
                            TotalVATAmount := Temp_VATAmountLine.GetTotalVATAmount();
                        end;
                    }
                    dataitem(VatTotalLine; Integer)
                    {
                        DataItemTableView = sorting(Number)
                                            order(ascending)
                                            where(Number = const(1));
                        column(BaseAmount1; BaseAmountArray[1])
                        {
                        }
                        column(BaseAmount2; BaseAmountArray[2])
                        {
                        }
                        column(BaseAmount3; BaseAmountArray[3])
                        {
                        }
                        column(BaseAmount4; BaseAmountArray[4])
                        {
                        }
                        column(BaseAmount5; BaseAmountArray[5])
                        {
                        }
                        column(BaseAmount6; BaseAmountArray[6])
                        {
                        }
                        column(CashVATFooterText; CashVATFooterText)
                        {
                        }
                        column(ConaiText; ConaiText)
                        {
                        }
                        column(CurrencyPrint; CurrencyDescr)
                        {
                        }
                        column(DocumentGrossAmount; DocumentGrossAmount)
                        {
                        }
                        column(EuroPrint; EuroTxt)
                        {
                        }
                        column(InvDiscPerc; InvDiscPerc)
                        {
                        }
                        column(NetToPay; NetToPay)
                        {
                        }
                        column(PaymentArray1; PaymentArray[1])
                        {
                        }
                        column(PaymentArray2; PaymentArray[2])
                        {
                        }
                        column(PaymentArray3; PaymentArray[3])
                        {
                        }
                        column(PaymentArray4; PaymentArray[4])
                        {
                        }
                        column(PaymentArray5; PaymentArray[5])
                        {
                        }
                        column(PaymentArray6; PaymentArray[6])
                        {
                        }
                        column(PaymentsAmountArray1; PaymentsAmountArray[1])
                        {
                        }
                        column(PaymentsAmountArray2; PaymentsAmountArray[2])
                        {
                        }
                        column(PaymentsAmountArray3; PaymentsAmountArray[3])
                        {
                        }
                        column(PaymentsAmountArray4; PaymentsAmountArray[4])
                        {
                        }
                        column(PaymentsAmountArray5; PaymentsAmountArray[5])
                        {
                        }
                        column(PaymentsAmountArray6; PaymentsAmountArray[6])
                        {
                        }
                        column(PaymentsAmountArray7; PaymentsAmountArray[7])
                        {
                        }
                        column(PaymentsAmountArray8; PaymentsAmountArray[8])
                        {
                        }
                        column(PaymentsAmountArray9; PaymentsAmountArray[9])
                        {
                        }
                        column(PaymentsAmountArray10; PaymentsAmountArray[10])
                        {
                        }
                        column(PaymentsDateArray1; Format(PaymentsDateArray[1], 0, '<Day,2>/<Month,2>/<Year4>'))
                        {
                        }
                        column(PaymentsDateArray2; Format(PaymentsDateArray[2], 0, '<Day,2>/<Month,2>/<Year4>'))
                        {
                        }
                        column(PaymentsDateArray3; Format(PaymentsDateArray[3], 0, '<Day,2>/<Month,2>/<Year4>'))
                        {
                        }
                        column(PaymentsDateArray4; Format(PaymentsDateArray[4], 0, '<Day,2>/<Month,2>/<Year4>'))
                        {
                        }
                        column(PaymentsDateArray5; Format(PaymentsDateArray[5], 0, '<Day,2>/<Month,2>/<Year4>'))
                        {
                        }
                        column(PaymentsDateArray6; Format(PaymentsDateArray[6], 0, '<Day,2>/<Month,2>/<Year4>'))
                        {
                        }
                        column(PaymentsDateArray7; Format(PaymentsDateArray[7], 0, '<Day,2>/<Month,2>/<Year4>'))
                        {
                        }
                        column(PaymentsDateArray8; Format(PaymentsDateArray[8], 0, '<Day,2>/<Month,2>/<Year4>'))
                        {
                        }
                        column(PaymentsDateArray9; Format(PaymentsDateArray[9], 0, '<Day,2>/<Month,2>/<Year4>'))
                        {
                        }
                        column(PaymentsDateArray10; Format(PaymentsDateArray[10], 0, '<Day,2>/<Month,2>/<Year4>'))
                        {
                        }
                        column(TotalBase; TotalBaseAmount)
                        {
                        }
                        column(TotalDocAmount; TotalDocAmount)
                        {
                            AutoFormatExpression = SalesInvoiceHeader."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalEuroDocAmount; TotalEuroDocAmount)
                        {
                            AutoFormatExpression = SalesHeader."Currency Code";
                        }
                        column(TotalGifts; TotalGifts)
                        {
                        }
                        column(TotalInvDiscAmt; TotalInvDiscAmt)
                        {
                        }
                        column(TotalInvDiscBaseAmt; TotalInvDiscBaseAmt)
                        {
                        }
                        column(TotalVATAmount; TotalVATAmount)
                        {
                        }
                        column(VATAmount1; VATAmountArray[1])
                        {
                        }
                        column(VATAmount2; VATAmountArray[2])
                        {
                        }
                        column(VATAmount3; VATAmountArray[3])
                        {
                        }
                        column(VATAmount4; VATAmountArray[4])
                        {
                        }
                        column(VATAmount5; VATAmountArray[5])
                        {
                        }
                        column(VATAmount6; VATAmountArray[6])
                        {
                        }
                        column(VATCode1; VATCodeArray[1])
                        {
                        }
                        column(VATCode2; VATCodeArray[2])
                        {
                        }
                        column(VATCode3; VATCodeArray[3])
                        {
                        }
                        column(VATCode4; VATCodeArray[4])
                        {
                        }
                        column(VATCode5; VATCodeArray[5])
                        {
                        }
                        column(VATCode6; VATCodeArray[6])
                        {
                        }
                        column(VATDescr1; VATDescrArray[1])
                        {
                        }
                        column(VATDescr2; VATDescrArray[2])
                        {
                        }
                        column(VATDescr3; VATDescrArray[3])
                        {
                        }
                        column(VATDescr4; VATDescrArray[4])
                        {
                        }
                        column(VATDescr5; VATDescrArray[5])
                        {
                        }
                        column(VATDescr6; VATDescrArray[6])
                        {
                        }
                        column(TotalGrossWeight; TotalGrossWeight)
                        {
                        }
                        column(TotalNetWeight; TotalNetWeight)
                        {
                        }
                        column(TotalParcels; TotalParcels)
                        {
                        }
                        trigger OnAfterGetRecord()
                        var
                        begin
                            TotalDocAmount := TotalBaseAmount + TotalVATAmount;
                            NetToPay := TotalDocAmount - TotalGifts;

                            if (SalesInvoiceHeader."Currency Code" <> '') and (false) //Nascosta la stampa dell'importo in Euro nel caso di valuta estera
                            then begin
                                Currency.Get(SalesInvoiceHeader."Currency Code");
                                if SalesInvoiceHeader."Currency Factor" <> 0 then
                                    TotalEuroDocAmount := Round(TotalDocAmount / SalesInvoiceHeader."Currency Factor",
                                                                Currency."Amount Rounding Precision");
                                EuroTxt := 'EUR';
                            end else begin
                                Clear(Currency);
                                TotalEuroDocAmount := 0;
                                EuroTxt := '';
                            end;
                        end;

                        trigger OnPostDataItem()
                        begin
                            DocDataReset();
                        end;
                    }
                    dataitem(VATCounterLCY; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT1; Temp_VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmountLineVATIdent1; Temp_VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            Temp_VATAmountLine.GetLine(Number);

                            VALVATBaseLCY := Round(Temp_VATAmountLine."VAT Base" / SalesInvoiceHeader."Currency Factor");
                            VALVATAmountLCY := Round(Temp_VATAmountLine."VAT Amount" / SalesInvoiceHeader."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                              (SalesInvoiceHeader."Currency Code" = '') or
                              (PaymentMethod.Get(SalesInvoiceHeader."Payment Method Code") and
                              (PaymentMethod."Free Type" = PaymentMethod."Free Type"::"Total Amt."))
                            then begin
                                CurrReport.Break();
                            end;

                            SetRange(Number, 1, Temp_VATAmountLine.Count);
                        end;
                    }
                }


                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        OutputNo += 1;
                    end;

                    DocDataReset();
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then begin
                        SalesInvCountPrinted.Run(SalesInvoiceHeader);
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + Cust."Invoice Copies" + 1;
                    if NoOfLoops <= 0 then begin
                        NoOfLoops := 1;
                    end;

                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                lCustomer: Record Customer;
                lReasonCode: Record "Reason Code";
            begin
                TotalGifts := 0;
                TotalParcels := 0;
                TotalNetWeight := 0;
                TotalGrossWeight := 0;

                if not lCustomer.Get(SalesInvoiceHeader."Sell-to Customer No.") then Clear(lCustomer);
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

                Clear(LastHeaderInformationArrayText);
                OnBeforeSalesInvoiceHeaderOnAfterGetRecord(SalesInvoiceHeader, LastHeaderInformationArrayText);
                PrintFunctions.GetHeaderInformation(SalesInvoiceHeader."AltAWPBranch Code",
                                                    SalesInvoiceHeader."Location Code",
                                                    HeaderInformationArray,
                                                    LastHeaderInformationArrayText);

                if ("Bill-to Customer No." = '') or (not Cust.Get("Bill-to Customer No.")) then begin
                    CurrReport.Skip();
                end;

                CurrReport.Language := PrintFunctions.GetReportLanguageCode("Language Code");
                CompanyInfo.CalcFields(Picture);
                GeneralSetup.CalcFields("Picture Footer Report");

                FreeInvTxt := lblFreeInvoiceCaption;

                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else begin
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                end;

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                if not SalesPurchPerson.Get("Salesperson Code") then Clear(SalesPurchPerson);
                Salesperson_Code_Name := SalesPurchPerson.Code;
                if (SalesPurchPerson."AltAWPCommercial Docs. Alias" <> '') then Salesperson_Code_Name := SalesPurchPerson."AltAWPCommercial Docs. Alias";

                if ("Currency Code" = '') then begin
                    GLSetup.TestField("LCY Code");
                    CurrencyDescr := GLSetup."LCY Code";
                end else begin
                    CurrencyDescr := "Currency Code";
                end;

                FormatAddr.SalesInvBillTo(CustAddr, SalesInvoiceHeader);
                FormatAddr.SalesInvShipTo(ShipToAddr, CustAddr, SalesInvoiceHeader);

                ShipMethDescr := '';

                if ("Shipment Method Code" = '') then begin
                    ShipmentMethod.Init()
                end else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                    ShipMethDescr := ShipmentMethod.Description;
                end;

                PayMethDescr := '';

                if ("Payment Method Code" = '') then begin
                    PaymentMethod.Init();
                end else begin
                    PaymentMethod.Get("Payment Method Code");
                    PaymentMethod.TranslateDescription("Language Code");
                    PayMethDescr := PaymentMethod.Description;
                end;

                PayMethDescr := '';

                if ("Payment Method Code" = '') then begin
                    PaymentMethod.Init();
                end else begin
                    PaymentMethod.Get("Payment Method Code");
                    PaymentMethod.TranslateDescription("Language Code");
                    PayMethDescr := PaymentMethod.Description;
                end;

                PaymentTermsText := '';

                if ("Payment Terms Code" = '') then begin
                    PaymentTerms.Init()
                end else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                    PaymentTermsText := PaymentTerms.Description;
                end;

                CreditBankAccount := PrintFunctions.GetCreditBankText("Bill-to Customer No.", "Bank Account", SalesInvoiceHeader, "Payment Method Code", "Company Bank Account Code");

                if not ShippingAgent.Get("Shipping Agent Code") then Clear(ShippingAgent);

                if ConaiShow then begin
                    ConaiText := TextConai
                end else begin
                    ConaiText := '';
                end;

                if ("Currency Factor" = 0) then begin
                    "Currency Factor" := 1;
                end;

                if LogInteraction then begin
                    if not CurrReport.Preview then begin
                        if "Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, Database::Contact, "Bill-to Contact No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '')
                        else
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, Database::Customer, "Bill-to Customer No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '');
                    end;
                end;

                ReasonDescr := '';
                if lReasonCode.Get("Reason Code") then begin
                    ReasonDescr := lReasonCode.Description;
                end;

                SalesHeader.TransferFields(SalesInvoiceHeader);
                SalesHeader.FindVATExemption(VATExemption, VATExemptionCheck, true);

                Clear(HeaderCommentText);
                HeaderCommentText := PrintFunctions.GetDocumentCommentHeader(SalesInvoiceHeader, Report::"ecShipping Invoice");
                PrintFunctions.GetAccompData(SalesInvoiceHeader, AccompDataCaption_Text, AccompDataValue_Text);

            end;

            trigger OnPostDataItem()
            begin
            end;

            trigger OnPreDataItem()
            begin
                PrintTotals := true;
                Print := Print or not CurrReport.Preview;
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

                    field(LayoutType_Field; LayoutType)
                    {
                        ApplicationArea = All;
                        Caption = 'Layout Type', Comment = 'Tipo Layout';
                    }
                    field(PrintItemCrossRef_Field; PrintItemCrossRefOpt)
                    {
                        ApplicationArea = All;
                        Caption = 'Show item reference codes';
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
                    field(ConaiHide_Field; ConaiHide)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Conai Info';
                    }
                    field(LogInteraction_Field; LogInteraction)
                    {
                        ApplicationArea = All;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        Visible = false;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LayoutType := LayoutType::"Customer Default";
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        CompanyInfo.Get();
        GeneralSetup.Get();

        CashVATProdGrp := GLSetup."CashVAT Product Posting Group";
        if StrLen(CashVATProdGrp) > 0 then begin
            VATProdPostingGr.Get(CashVATProdGrp);
            CashVATFooterText := VATProdPostingGr.Description;
        end else begin
            CashVATFooterText := '';
        end;
    end;

    trigger OnPreReport()
    begin

        TotalGifts := 0;
    end;

    procedure InitializeRequest(NoOfCopiesFrom: Integer; PrintFrom: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        Print := PrintFrom;
    end;

    procedure DocDataReset()
    begin
        Clear(VATCodeArray);
        Clear(VATDescrArray);
        Clear(BaseAmountArray);
        Clear(VATAmountArray);
        Clear(AmountArray);
        Clear(PaymentsAmountArray);
        Clear(PaymentsDateArray);
        Clear(PaymentArray);

        TotalBaseAmount := 0;
        TotalDocAmount := 0;
        TotalVATAmount := 0;

        DocumentGrossAmount := 0;
        TotalInvDiscAmt := 0;
        TotalInvDiscBaseAmt := 0;
        InvDiscPerc := 0;

        TotalEuroDocAmount := 0;
        EuroTxt := '';

    end;

    procedure GenerateBufferFromShipment(SalesInvoiceLine: Record "Sales Invoice Line")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine2: Record "Sales Invoice Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := 0;
        SalesInvoiceHeader.SetCurrentKey("Order No.");
        SalesInvoiceHeader.SetFilter("No.", '..%1', SalesInvoiceHeader."No.");
        SalesInvoiceHeader.SetRange("Order No.", SalesInvoiceHeader."Order No.");
        if SalesInvoiceHeader.Find('-') then
            repeat
                SalesInvoiceLine2.SetRange("Document No.", SalesInvoiceHeader."No.");
                SalesInvoiceLine2.SetRange("Line No.", SalesInvoiceLine."Line No.");
                SalesInvoiceLine2.SetRange(Type, SalesInvoiceLine.Type);
                SalesInvoiceLine2.SetRange("No.", SalesInvoiceLine."No.");
                SalesInvoiceLine2.SetRange("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
                if SalesInvoiceLine2.Find('-') then
                    repeat
                        TotalQuantity := TotalQuantity + SalesInvoiceLine2.Quantity;
                    until SalesInvoiceLine2.Next() = 0;
            until SalesInvoiceHeader.Next() = 0;

        SalesShipmentLine.SetCurrentKey("Order No.", "Order Line No.");
        SalesShipmentLine.SetRange("Order No.", SalesInvoiceHeader."Order No.");
        SalesShipmentLine.SetRange("Order Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentLine.SetRange("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentLine.SetRange(Type, SalesInvoiceLine.Type);
        SalesShipmentLine.SetRange("No.", SalesInvoiceLine."No.");
        SalesShipmentLine.SetRange("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
        SalesShipmentLine.SetFilter(Quantity, '<>%1', 0);

        if SalesShipmentLine.Find('-') then
            repeat
                if SalesInvoiceHeader."Get Shipment Used" then
                    CorrectShipment(SalesShipmentLine);
                if Abs(SalesShipmentLine.Quantity) <= Abs(TotalQuantity - SalesInvoiceLine.Quantity) then
                    TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity
                else begin
                    if Abs(SalesShipmentLine.Quantity) > Abs(TotalQuantity) then
                        SalesShipmentLine.Quantity := TotalQuantity;
                    Quantity :=
                      SalesShipmentLine.Quantity - (TotalQuantity - SalesInvoiceLine.Quantity);

                    TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity;
                    SalesInvoiceLine.Quantity := SalesInvoiceLine.Quantity - Quantity;

                    if SalesShipmentHeader.Get(SalesShipmentLine."Document No.") then begin
                        AddBufferEntry(
                          SalesInvoiceLine,
                          Quantity,
                          SalesShipmentHeader."Posting Date");
                    end;
                end;
            until (SalesShipmentLine.Next() = 0) or (TotalQuantity = 0);
    end;

    procedure GenerateBufferFromValueEntry(SalesInvoiceLine2: Record "Sales Invoice Line")
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := SalesInvoiceLine2."Quantity (Base)";
        ValueEntry.SetCurrentKey("Document No.");
        ValueEntry.SetRange("Document No.", SalesInvoiceLine2."Document No.");
        ValueEntry.SetRange("Posting Date", SalesInvoiceHeader."Posting Date");
        ValueEntry.SetRange("Item Charge No.", '');
        ValueEntry.SetFilter("Entry No.", '%1..', FirstValueEntryNo);
        if ValueEntry.Find('-') then
            repeat
                if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                    if SalesInvoiceLine2."Qty. per Unit of Measure" <> 0 then
                        Quantity := ValueEntry."Invoiced Quantity" / SalesInvoiceLine2."Qty. per Unit of Measure"
                    else
                        Quantity := ValueEntry."Invoiced Quantity";
                    AddBufferEntry(
                      SalesInvoiceLine2,
                      -Quantity,
                      ItemLedgerEntry."Posting Date");
                    TotalQuantity := TotalQuantity + ValueEntry."Invoiced Quantity";
                end;
                FirstValueEntryNo := ValueEntry."Entry No." + 1;
            until (ValueEntry.Next() = 0) or (TotalQuantity = 0);
    end;

    procedure CorrectShipment(var SalesShipmentLine: Record "Sales Shipment Line")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.SetCurrentKey("Shipment No.", "Shipment Line No.");
        SalesInvoiceLine.SetRange("Shipment No.", SalesShipmentLine."Document No.");
        SalesInvoiceLine.SetRange("Shipment Line No.", SalesShipmentLine."Line No.");
        if SalesInvoiceLine.Find('-') then
            repeat
                SalesShipmentLine.Quantity := SalesShipmentLine.Quantity - SalesInvoiceLine.Quantity;
            until SalesInvoiceLine.Next() = 0;
    end;

    procedure AddBufferEntry(SalesInvoiceLine: Record "Sales Invoice Line"; QtyOnShipment: Decimal; PostingDate: Date)
    begin
        Temp_SalesShipmentBuffer.SetRange("Document No.", SalesInvoiceLine."Document No.");
        Temp_SalesShipmentBuffer.SetRange("Line No.", SalesInvoiceLine."Line No.");
        Temp_SalesShipmentBuffer.SetRange("Posting Date", PostingDate);
        if Temp_SalesShipmentBuffer.Find('-') then begin
            Temp_SalesShipmentBuffer.Quantity := Temp_SalesShipmentBuffer.Quantity + QtyOnShipment;
            Temp_SalesShipmentBuffer.Modify();
            exit;
        end;

        Temp_SalesShipmentBuffer."Document No." := SalesInvoiceLine."Document No.";
        Temp_SalesShipmentBuffer."Line No." := SalesInvoiceLine."Line No.";
        Temp_SalesShipmentBuffer."Entry No." := NextEntryNo;
        Temp_SalesShipmentBuffer.Type := SalesInvoiceLine.Type;
        Temp_SalesShipmentBuffer."No." := SalesInvoiceLine."No.";
        Temp_SalesShipmentBuffer.Quantity := QtyOnShipment;
        Temp_SalesShipmentBuffer."Posting Date" := PostingDate;
        Temp_SalesShipmentBuffer.Insert();
        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure ExistsLinesAttachedAfter(var pSalesInvoiceLine: Record "Sales Invoice Line"): Boolean
    var
        lSalesInvoiceLine2: Record "Sales Invoice Line";
    begin
        Clear(lSalesInvoiceLine2);
        if (pSalesInvoiceLine.Type <> pSalesInvoiceLine.Type::" ") or
           (pSalesInvoiceLine."Attached to Line No." <> 0)
        then begin
            lSalesInvoiceLine2.SetRange("Document No.", pSalesInvoiceLine."Document No.");
            lSalesInvoiceLine2.SetFilter("Line No.", '>%1', pSalesInvoiceLine."Line No.");
            if (pSalesInvoiceLine.Type = pSalesInvoiceLine.Type::" ") and (pSalesInvoiceLine."Attached to Line No." <> 0) then begin
                lSalesInvoiceLine2.SetRange("Attached to Line No.", pSalesInvoiceLine."Attached to Line No.");
            end else begin
                lSalesInvoiceLine2.SetRange("Attached to Line No.", pSalesInvoiceLine."Line No.");
            end;
            if not lSalesInvoiceLine2.IsEmpty then begin
                exit(true);
            end else begin
                if (pSalesInvoiceLine.Type = pSalesInvoiceLine.Type::" ") and (pSalesInvoiceLine."Attached to Line No." <> 0) then begin
                    lSalesInvoiceLine2.SetRange("Attached to Line No.");
                    lSalesInvoiceLine2.SetFilter("Line No.", '>%1 & =%2', pSalesInvoiceLine."Line No.", pSalesInvoiceLine."Attached to Line No.");
                    if not lSalesInvoiceLine2.IsEmpty then exit(true);
                end else begin
                    if (pSalesInvoiceLine.Type <> pSalesInvoiceLine.Type::" ") then begin
                        lSalesInvoiceLine2.SetRange("Attached to Line No.");
                        lSalesInvoiceLine2.SetFilter("Line No.", '>%1', pSalesInvoiceLine."Line No.");
                        lSalesInvoiceLine2.SetRange("APsFOC Attach. to Line No.", pSalesInvoiceLine."Line No.");
                        if not lSalesInvoiceLine2.IsEmpty then exit(true);
                    end;
                end;
            end;
        end else begin
            if (pSalesInvoiceLine.Type = pSalesInvoiceLine.Type::" ") then begin
                lSalesInvoiceLine2.SetRange("Document No.", pSalesInvoiceLine."Document No.");
                lSalesInvoiceLine2.SetFilter("Line No.", '>%1', pSalesInvoiceLine."Line No.");
                if not lSalesInvoiceLine2.IsEmpty then begin
                    lSalesInvoiceLine2.FindFirst();
                    if (lSalesInvoiceLine2.Type = lSalesInvoiceLine2.Type::" ") and
                       (lSalesInvoiceLine2."Attached to Line No." = 0)
                    then begin
                        exit(true);
                    end;
                end;
            end;
        end;

        exit(false);
    end;

    local procedure ExistsKitExhibitorLinesAttachedAfter(var pSalesInvoiceLine: Record "Sales Invoice Line"): Boolean
    var
        lSalesInvoiceLine2: Record "Sales Invoice Line";
    begin
        if (pSalesInvoiceLine."ecAttacch. Kit/Exhib. Line No." = 0) then begin
            Clear(lSalesInvoiceLine2);
            lSalesInvoiceLine2.SetRange("Document No.", pSalesInvoiceLine."Document No.");
            lSalesInvoiceLine2.SetFilter("Line No.", '>%1', pSalesInvoiceLine."Line No.");
            lSalesInvoiceLine2.SetRange("ecAttacch. Kit/Exhib. Line No.", pSalesInvoiceLine."Line No.");
            if not lSalesInvoiceLine2.IsEmpty then begin
                exit(true);
            end else begin
                exit(false);
            end;
        end else begin
            Clear(lSalesInvoiceLine2);
            lSalesInvoiceLine2.SetRange("Document No.", pSalesInvoiceLine."Document No.");
            lSalesInvoiceLine2.SetFilter("Line No.", '>%1', pSalesInvoiceLine."Line No.");
            lSalesInvoiceLine2.SetRange("ecAttacch. Kit/Exhib. Line No.", pSalesInvoiceLine."ecAttacch. Kit/Exhib. Line No.");
            if not lSalesInvoiceLine2.IsEmpty then begin
                exit(true);
            end else begin
                exit(false);
            end;
        end;
    end;

    var
        SalesHeader: Record "Sales Header";
        PaymentTerms: Record "Payment Terms";
        ShipmentMethod: Record "Shipment Method";
        ShippingAgent: Record "Shipping Agent";
        GLSetup: Record "General Ledger Setup";
        Temp_SalesInvLine_Print: Record "Sales Invoice Line" temporary;
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        Temp_VATAmountLine: Record "VAT Amount Line" temporary;
        RespCenter: Record "Responsibility Center";
        Cust: Record Customer;
        BankAccount: Record "Bank Account";
        SalesOrder: Record "Sales Header";
        Currency: Record Currency;
        VATExemption: Record "VAT Exemption";
        Temp_SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        VATProdPostingGr: Record "VAT Product Posting Group";
        PaymentMethod: Record "Payment Method";
        Item: Record Item;
        Temp_EntrySummary: Record "Entry Summary" temporary;
        GeneralSetup: Record "AltAWPGeneral Setup";
        SalesInvCountPrinted: Codeunit "Sales Inv.-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        PrintFunctions: Codeunit "AltAWPPrint Functions";
        awpCommentsManagement: Codeunit "AltAWPComments Management";
        PrintItemCrossRefOpt: Option "Customer Default",Yes,No;
        ShowTariffNoOpt: Option "Customer Default",Yes,No;
        ShowTrackingInfoOpt: Option "Customer Default",None,Standard,Extended;
        NoOfLoops: Integer;
        OutputNo: Integer;
        NoOfCopies: Integer;
        Ind: Integer;
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        AmountArray: array[10] of Decimal;
        BaseAmountArray: array[6] of Decimal;
        VATAmountArray: array[6] of Decimal;
        TotalBaseAmount: Decimal;
        TotalVATAmount: Decimal;
        TotalDocAmount: Decimal;
        TotalInvDiscBaseAmt: Decimal;
        TotalInvDiscAmt: Decimal;
        DocumentGrossAmount: Decimal;
        TotalParcels: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        InvDiscPerc: Decimal;
        TotalEuroDocAmount: Decimal;
        PaymentsAmountArray: array[10] of Decimal;
        NetToPay: Decimal;
        PaymentsDateArray: array[10] of Date;
        VATCodeArray: array[6] of Code[20];
        CashVATProdGrp: Code[10];
        CashVATFooterText: Text[50];
        TariffNo: Text;
        EuroTxt: Text[3];
        VATDescrArray: array[6] of Text[50];
        OrderRef: Text;
        CompanyOfficeAddress: array[5] of Text;
        HeaderInformationArray: array[10] of Text;
        CurrencyDescr: Text[30];
        BankDescr: Text;
        PayMethDescr: Text;
        ShipMethDescr: Text;
        Salesperson_Code_Name: Text;
        ItemReferenceNo: Text;
        DimText: Text[120];
        OldDimText: Text[75];
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        ConaiText: Text[100];
        FreeInvTxt: Text[30];
        LineComment: Text;
        PrepmtLineDescr: Text;
        ComposedDiscount: Text;
        CreditBankAccount: Text;
        SSCCInfo: Text;
        TrackingInfoLine: Text;
        CountryOrigin: Text;
        ReasonDescr: Text;
        PaymentArray: array[6] of Text;
        PaymentTermsText: Text;
        HeaderCommentText: Text;
        ImageBase64String: Text;
        LastHeaderInformationArrayText: Text;
        TrackingString: Text;
        ConaiShow: Boolean;
        MoreLines: Boolean;
        IsNewLine: Boolean;
        LogInteractionEnable: Boolean;
        Continue: Boolean;
        Print: Boolean;
        PrintTotals: Boolean;
        VATExemptionCheck: Boolean;
        LogInteraction: Boolean;
        PrintCashVATFooter: Boolean;
        PrepmtLineExists: Boolean;
        ConaiHide: Boolean;
        LayoutType: Enum "AltAWPDocument Default Layout";
        lblRev: Label 'Rev. 5';
        lblPmtExpiry: Label 'Expiry and amount';
        lblQuoteRef: Label 'Reference offer';
        lblFreeInvoiceCaption: Label 'FREE INVOICE';
        lblTariffNo: Label 'H.S. Code : %1';
        lblCreditBankAccount: Label 'Credit Bank Account';
        lblSalesperson: Label 'Salesperson';
        lblShipmentType: Label 'Shipment Type';
        lblVariant: Label 'Item variant';
        lblVATTaxable: Label 'VAT Base Amuont';
        lblVATAmount2: Label 'VAT amount';
        lblTotalDocument: Label 'Total document';
        lblTotalGift: Label 'Total Gift';
        lblNetToPay: Label 'Net to Pay';
        lblDriverSignature: Label 'Driver Signature';
        lblCustSignature: Label 'Customer Signature';
        lblPaymentMethod: Label 'Payment Method';
        lblPackagesNo: Label 'Packages No';
        lblPalletNo: Label 'Logistics units no.';
        lblTransportReason: Label 'Shipment Reason Code';
        lblShipStartingDate: Label 'Start Delivery Date';
        lblShipStartingTime: Label 'Start Delivery Time';
        lblGoodAspect: Label 'Good Aspect';
        lblShippingType: Label 'Shipping Type';
        lblSaleCondition: Label 'Sale conditions on ';
        lblDeadlinesAmount: Label '%1) %2 %3 %4 at %5';
        lblConai: Label 'Conai contribution - polieco paid where due', Comment = 'Contributo conai - polieco assolti ove dovuti';
        lblSpecialPaymentConditions: Label 'Special Payment Conditions';
        lblText001: Label 'Documento non valido ai fini fiscali (ai sensi dell’art. 21 Dpr 633/72), salvo per i soggetti non titolari di Partita Iva e/o non residenti per i quali costituisce copia analogica di fattura (art. 1. co. 909 L. 205/2017). La e-fattura è disponibile all’indirizzo telematico da Lei fornito oppure nella Sua area riservata dell’Agenzia delle Entrate.', Locked = true;
        Text01: Label '%1 %2', Locked = true;
        Text02: Label '%1 %2 %3', Locked = true;
        TextConai: Label '* Conai settlement payed if needed *';
        TextCreditBank1: Label 'Instruction for bank transfer:';
        TextCreditBank2: Label 'Bank Name: %1';
        TextCreditBank3: Label 'Branch: %1';
        TextCreditBank4: Label 'Address: %1';
        TextCreditBank5: Label 'A/C: %1';
        TextCreditBank6: Label 'SWIFT/BIC: %1';
        TextCreditBank7: Label 'IBAN: %1';
        TxtPrepmt001: Label 'Prepayment documents:';
        TextRefCDep: Label 'Returns on consignment';
        lblOffice: Label 'Head Office';
        lblPhone: Label 'Phone';
        lblFax: Label 'Fax';
        lblRegOffice: Label 'Registered Office';
        lblVatRegFiscalCode: Label 'Tax Code No.';
        lblExporterCode: Label 'Exporter code';
        lblBillToCustomer: Label 'Addressee';
        lblShipTo: Label 'Consignee';
        lblTitle: Label 'SHIPPING INVOICE';
        lblDocumentType: Label 'Document type';
        lblDocumentNo: Label 'Document No.';
        lblDocumentDate: Label 'Document date';
        lblPageNo: Label 'Page';
        lblCustomerNo: Label 'Customer';
        lblVatRegNo: Label 'VAT reg. no.';
        lblFiscalCode: Label 'Fiscal code';
        lblNote: Label 'Note';
        lblPaymentTerms: Label 'Payment terms';
        lblYourRef: Label 'Your Reference';
        lblProject: Label 'Project';
        lblCurrency: Label 'Currency';
        lblChange: Label 'Change';
        lblShippingAgent: Label 'Carrier';
        lblDeliveryTerms: Label 'Delivery terms';
        lblDescription: Label 'Description';
        lblCode: Label 'Code';
        lblUM: Label 'UM';
        lblQuantity: Label 'Q.ty';
        lblUnitPrice: Label 'Unit price';
        lblDiscount: Label 'Composed discount';
        lblLineAmt: Label 'Amount';
        lblVAT: Label 'VAT';
        lblTotalAmt: Label 'Total taxable amount';
        lblTotalAmtForDisc: Label 'Discountable taxable amount';
        lblInvoiceDiscPerc: Label 'Document discount %';
        lblInvoiceDisc: Label 'Document discount amount';
        lblVATTotalBaseAmount: Label 'Tax amount';
        lblVATTotalAmount: Label 'VAT total';
        lblDocumentTotal: Label 'Document total';
        lblVATCode: Label 'Code';
        lblTotGrossWeight: Label 'Gross Weight';
        lblTotNetWeight: Label 'Net weight';
        lblTotalParcels: Label 'Total parcels';
        lblVATDescription: Label 'Description';
        lblVATBaseAmt: Label 'Taxable amount';
        lblVATAmount: Label 'Tax';
        lblGrossWeight: Label 'Gross Weight';
        lblTruckerPlate: Label 'Trucker Plate:';
        lblTrailerPlate: Label 'Trailer Plate:';
        lblContainerNumber: Label 'Container number:';
        lblSeal1: Label 'Seal 1:';
        lblSeal2: Label 'Seal 2:';
        lblSeal3: Label 'Seal 3:';
        lblQuantityUMC: Label 'Q.ty UMC';
        lblUMC: Label 'UMC';
        lblUMCPrice: Label 'Price UMC';
        lblItemRefrenceNo: Label 'Item ref. no. : %1';
        lblMandatoryDeliveryDate: Label 'Mandatory delivery date:';
        lblOrigin: Label 'Origin: ';
        lblExpirationDate: Label 'Expiration date: %1';
        lblLotNo: Label ' Lot No.: %1';
        lblLotQty: Label ' Qty: %1';
        lblSSCC: Label 'SSCC: ';
        lblNoOfPalletPlaces: Label 'No. of pallet places';
        lblShippingCompanyData: Label 'Shipping company data';
        Text001: Label '%1, %2, %3', Locked = true;

    protected var
        AccompDataCaption_Text: Text;

    protected var
        AccompDataValue_Text: Text;

    protected var
        TotalGifts: Decimal;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesInvoiceHeaderOnAfterGetRecord(pSalesInvoiceHeader: Record "Sales Invoice Header"; var pLastHeaderInformationArrayText: Text)
    begin
    end;

}