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
using Microsoft.Warehouse.Journal;
using Microsoft.Warehouse.Ledger;
using System.Utilities;

report 50016 "ecSales Credit Memo"
{
    ApplicationArea = All;
    Caption = 'Sales Credit Memo';
    DefaultLayout = RDLC;
    Description = 'GAP_VEN_001';
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    RDLCLayout = '.\src\EuroCompany\BaseApp\Sales\Reports\SalesCreditMemo.Layout.rdlc';
    UsageCategory = None;

    dataset
    {
        dataitem(SalesCrMemoHeader; "Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("No.")
                                order(ascending);
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            column(BankDescr; BankDescr)
            {
            }
            column(BillToCustomerName; SalesHeader."Bill-to Name")
            {
            }
            column(BillToCustomerNo; SalesHeader."Bill-to Customer No.")
            {
            }
            column(CIGCUPText; CIGCUPText)
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
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(FreightType; FreightTypeTxt)
            {
            }
            column(Your_Reference; "Your Reference")
            {
            }
            column(HeaderCommentText; HeaderCommentText)
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
            column(lblExporterCode; lblExporterCode)
            {
            }
            column(lblFax; lblFax)
            {
            }
            column(lblFiscalCode; lblFiscalCode)
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
            column(lblNote; lblNote)
            {
            }
            column(lblOffice; lblOffice)
            {
            }
            column(lblPageNo; lblPageNo)
            {
            }
            column(lblPaymentTerms; lblPaymentTerms)
            {
            }
            column(lblPayMeth; lblPayMeth)
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
            column(lblShipTo; lblShipTo)
            {
            }
            column(lblText001; Text001)
            {
            }
            column(lblTextWord01; lblTextWord01)
            {
            }
            column(lblTextWord02; lblTextWord02)
            {
            }
            column(lblTitle; lblTitle)
            {
            }
            column(lblTotal; lblTotal)
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
            column(lblTotGrossWeight; lblTotGrossWeight)
            {
            }
            column(lblTotalParcels; lblTotalParcels)
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
            column(PaymentMethDescription; PayMethDescr)
            {
            }
            column(PaymentTermsText; PayTermDescr)
            {
            }
            column(PayTermDescr; PayTermDescr)
            {
            }
            column(PostingDate; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(PrintTotals; PrintTotals)
            {
            }
            column(SalespersonCode; SalespersonCode_Name)
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
                        DataItemLinkReference = SalesCrMemoHeader;
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
                                    DimText := StrSubstNo(Text002, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(Text003, DimText, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
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
                    dataitem(SalesCrMemoLine; "Sales Cr.Memo Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = SalesCrMemoHeader;
                        DataItemTableView = sorting("Document No.", "Line No.")
                                            order(ascending);
                        column(SalesCrMemoLine_ComposedDiscount; ComposedDiscount)
                        {
                        }
                        column(SalesCrMemoLine_Description; Temp_SalesCrMemoLine_Print.Description)
                        {
                        }
                        column(SalesCrMemoLine_Description2; Temp_SalesCrMemoLine_Print."Description 2")
                        {
                        }
                        column(SalesCrMemoLine_GroupLineIndex; GroupLineIndex)
                        {
                        }
                        column(SalesCrMemoLine_LineAmount; Temp_SalesCrMemoLine_Print."Line Amount")
                        {
                            AutoFormatExpression = SalesHeader."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesCrMemoLine_LineNo; "Line No.")
                        {
                        }
                        column(SalesCrMemoLine_No; Temp_SalesCrMemoLine_Print."No.")
                        {
                        }
                        column(SalesCrMemoLine_Quantity; Temp_SalesCrMemoLine_Print.Quantity)
                        {
                            DecimalPlaces = 0 : 2;
                        }
                        column(SalesCrMemoLine_TariffNo; TariffNo)
                        {
                        }
                        column(SalesCrMemoLine_Type; Temp_SalesCrMemoLine_Print.Type.AsInteger())
                        {
                        }
                        column(SalesCrMemoLine_UM; Temp_SalesCrMemoLine_Print."Unit of Measure Code")
                        {
                        }
                        column(SalesCrMemoLine_UnitPrice; Temp_SalesCrMemoLine_Print."Unit Price")
                        {
                            AutoFormatExpression = SalesCrMemoHeader."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(SalesCrMemoLine_VariantCode; Temp_SalesCrMemoLine_Print."Variant Code")
                        {
                        }
                        column(SalesCrMemoLine_VATIdentifier; Temp_SalesCrMemoLine_Print."VAT Identifier")
                        {
                        }
                        column(SalesCrMemoLine_TotalNetWeight; Temp_SalesCrMemoLine_Print."AltAWPTotal Net Weight")
                        {
                            DecimalPlaces = 0 : 2;
                        }
                        column(SalesCrMemoLine_ConsumerUnitofMeasure; Temp_SalesCrMemoLine_Print."ecConsumer Unit of Measure")
                        {
                        }
                        column(SalesCrMemoLine_QtyConsumerUM; Temp_SalesCrMemoLine_Print."ecQuantity (Consumer UM)")
                        {
                            DecimalPlaces = 0 : 2;
                        }
                        column(SalesCrMemoLine_UnitPriceConsumerUM; Temp_SalesCrMemoLine_Print."ecUnit Price (Consumer UM)")
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

                                SetRange("Whse. Document No.", SalesCrMemoLine."AltAWPPosted Whse Receipt No.");
                                SetRange("Whse. Document Line No.", SalesCrMemoLine."AltAWPPosted Whse Rcpt. Line");
                                SetRange("Whse. Document Type", "Whse. Document Type"::Receipt);
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
                                        DimText := StrSubstNo(Text002, DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(Text003, DimText, DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
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

                                DimSetEntry2.SetRange("Dimension Set ID", SalesCrMemoLine."Dimension Set ID");
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
                            Temp_SalesCrMemoLine_Print := SalesCrMemoLine;

                            //AWP091-VI-s
                            if (SalesCrMemoLine.Type = SalesCrMemoLine.Type::" ") and
                               (SalesCrMemoLine."AltAWPComment Reason Code" <> '')
                            then begin
                                if not awpCommentsManagement.IsValidCommentReasonByReport(SalesCrMemoLine."AltAWPComment Reason Code",
                                                                                          Report::"AltAWPSales Credit Memo")
                                then begin
                                    CurrReport.Skip();
                                end;
                            end;
                            //AWP091-VI-e

                            if not SalesCrMemoHeader."Prices Including VAT" and
                               ("VAT Calculation Type" = "VAT Calculation Type"::"Full VAT")
                            then begin
                                "Line Amount" := 0;
                            end;

                            if (Temp_SalesCrMemoLine_Print."ecConsumer Unit of Measure" = '') then begin
                                Temp_SalesCrMemoLine_Print."ecConsumer Unit of Measure" := Temp_SalesCrMemoLine_Print."Unit of Measure Code";
                                Temp_SalesCrMemoLine_Print."ecQuantity (Consumer UM)" := Temp_SalesCrMemoLine_Print.Quantity;
                                Temp_SalesCrMemoLine_Print."ecUnit Price (Consumer UM)" := Temp_SalesCrMemoLine_Print."Unit Price";
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

                            if PaymentMethod.Get(SalesCrMemoHeader."Payment Method Code") then begin
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
                            if (Temp_SalesCrMemoLine_Print.Type = Temp_SalesCrMemoLine_Print.Type::Item) then begin
                                if (ShowTariffNoOpt = ShowTariffNoOpt::Yes) then begin
                                    if Item.Get(Temp_SalesCrMemoLine_Print."No.") and (Item."Tariff No." <> '') then begin
                                        TariffNo := StrSubstNo(lblTariffNo, Item."Tariff No.");
                                    end;
                                end;
                                if (PrintItemCrossRefOpt = PrintItemCrossRefOpt::Yes) then begin
                                    if (Temp_SalesCrMemoLine_Print."Item Reference No." <> '') then begin
                                        ItemReferenceNo := StrSubstNo(lblItemRefrenceNo, Temp_SalesCrMemoLine_Print."Item Reference No.");
                                    end;
                                end;
                            end;
                            if (Temp_SalesCrMemoLine_Print.Type = Temp_SalesCrMemoLine_Print.Type::" ") then begin
                                Temp_SalesCrMemoLine_Print."No." := '';
                            end;
                            ComposedDiscount := Temp_SalesCrMemoLine_Print."APsComposed Discount";
                            lRecordVariant := Temp_SalesCrMemoLine_Print;
                            lAWPPrintFunctions.ManageComposedDiscountValue(lRecordVariant, ComposedDiscount);

                            lAWPPrintFunctions.GetDocumentLayoutType(SalesCrMemoHeader, LayoutType);
                            case LayoutType of
                                LayoutType::"Net Price":
                                    begin
                                        ComposedDiscount := '';
                                        if (Temp_SalesCrMemoLine_Print.Quantity <> 0) then begin
                                            if (Temp_SalesCrMemoLine_Print."Line Discount %" <> 0) then begin
                                                Temp_SalesCrMemoLine_Print."Unit Price" := Temp_SalesCrMemoLine_Print."Line Amount" / Temp_SalesCrMemoLine_Print.Quantity;
                                            end;
                                        end else begin
                                            Temp_SalesCrMemoLine_Print."Unit Price" := 0;
                                        end;
                                    end;

                                LayoutType::"No Price":
                                    begin
                                        ComposedDiscount := '';
                                        Temp_SalesCrMemoLine_Print."Unit Price" := 0;
                                        Temp_SalesCrMemoLine_Print."Line Amount" := 0;
                                        Temp_SalesCrMemoLine_Print."VAT Identifier" := '';
                                    end;
                            end;

                            if (Temp_SalesCrMemoLine_Print."APsFOC Attach. to Line No." <> 0) then begin
                                if lSalesInvoiceLine.Get(Temp_SalesCrMemoLine_Print."Document No.", Temp_SalesCrMemoLine_Print."APsFOC Attach. to Line No.") then begin
                                    if (lSalesInvoiceLine."APsFOC Code" <> '') and
                                       lAPsFOCPostingSetup.Get(lSalesInvoiceLine."APsFOC Code") and
                                       (lAPsFOCPostingSetup.Type = Temp_SalesCrMemoLine_Print.Type) and
                                       (lAPsFOCPostingSetup."No." = Temp_SalesCrMemoLine_Print."No.") and
                                       (lAPsFOCPostingSetup."FOC Type" in [lAPsFOCPostingSetup."FOC Type"::"Without VAT Charge",
                                                                           lAPsFOCPostingSetup."FOC Type"::"VAT Charge"])
                                    then begin
                                        TotalGifts += Abs(Temp_SalesCrMemoLine_Print."Amount Including VAT");
                                    end;
                                end;
                            end;

                            if (Temp_SalesCrMemoLine_Print.Type = Temp_SalesCrMemoLine_Print.Type::Item) and lUnitofMeasure.Get(Temp_SalesCrMemoLine_Print."Unit of Measure Code") and
                               (lUnitofMeasure."AltAWPType Unit Of Measure" = lUnitofMeasure."AltAWPType Unit Of Measure"::Parcels)
                            then begin
                                TotalParcels += Temp_SalesCrMemoLine_Print.Quantity;
                            end;
                            TotalNetWeight += Temp_SalesCrMemoLine_Print."AltAWPTotal Net Weight";
                            TotalGrossWeight += Temp_SalesCrMemoLine_Print."AltAWPTotal Gross Weight";

                            IsNewLine := not ExistsLinesAttachedAfter(Temp_SalesCrMemoLine_Print);
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(CompanyInfo.Picture);
                            Clear(GeneralSetup."Picture Footer Report");

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

                            SetRange("Line No.", 0, "Line No.");
                        end;
                    }
                    dataitem(DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = SalesCrMemoHeader;
                        DataItemTableView = sorting("Document No.", "Document Type", "Posting Date")
                                            order(ascending)
                                            where("Document Type" = const("Credit Memo"),
                                                  "Entry Type" = const("Initial Entry"));

                        trigger OnAfterGetRecord()
                        var
                            lCustLedgerEntry: Record "Cust. Ledger Entry";
                        begin
                            Ind += 1;
                            PaymentsAmountArray[Ind] := -Amount;
                            PaymentsDateArray[Ind] := "Initial Entry Due Date";
                            lCustLedgerEntry.Get(DetailedCustLedgEntry."Cust. Ledger Entry No.");
                            PaymentArray[Ind] := StrSubstNo(lblDeadlinesAmount, Ind,
                                                            lCustLedgerEntry."Payment Method Code",
                                                            "Currency Code",
                                                            Amount * -1,
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
                            ;
                            BaseAmountArray[Number] := Temp_VATAmountLine."VAT Base";
                            VATAmountArray[Number] := Temp_VATAmountLine."VAT Amount";

                            TotalBaseAmount += Temp_VATAmountLine."VAT Base";
                            TotalVATAmount += Temp_VATAmountLine."VAT Amount";

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
                            AutoFormatExpression = SalesCrMemoHeader."Currency Code";
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
                        begin
                            TotalDocAmount := TotalBaseAmount + TotalVATAmount;
                            NetToPay := TotalDocAmount - TotalGifts;

                            if (SalesCrMemoHeader."Currency Code" <> '') and (false) //Nascosta la stampa dell'importo in Euro nel caso di valuta estera
                            then begin
                                Currency.Get(SalesCrMemoHeader."Currency Code");
                                if SalesCrMemoHeader."Currency Factor" <> 0 then
                                    TotalEuroDocAmount := Round(TotalDocAmount / SalesCrMemoHeader."Currency Factor",
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

                            VALVATBaseLCY := Round(Temp_VATAmountLine."VAT Base" / SalesCrMemoHeader."Currency Factor");
                            VALVATAmountLCY := Round(Temp_VATAmountLine."VAT Amount" / SalesCrMemoHeader."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                              (SalesCrMemoHeader."Currency Code" = '') or
                              (PaymentMethod.Get(SalesCrMemoHeader."Payment Method Code") and
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
                        SalesCrMemoCountPrinted.Run(SalesCrMemoHeader);
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
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
            begin
                if not Customer.Get(SalesCrMemoHeader."Sell-to Customer No.") then Clear(Customer);

                TotalGifts := 0;
                TotalParcels := 0;
                TotalNetWeight := 0;
                TotalGrossWeight := 0;

                if not lCustomer.Get(SalesCrMemoHeader."Bill-to Customer No.") then Clear(lCustomer);
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
                OnBeforeSalesCrMemoHeaderOnAfterGetRecord(SalesCrMemoHeader, LastHeaderInformationArrayText);
                PrintFunctions.GetHeaderInformation(SalesCrMemoHeader."AltAWPBranch Code",
                                                    SalesCrMemoHeader."Location Code",
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

                CompanyOfficeAddress[1] := StrSubstNo(Txt001, CompanyInfo."Country/Region Code",
                                                             CompanyInfo."Post Code",
                                                             CompanyInfo.City,
                                                             CompanyInfo.County);
                CompanyOfficeAddress[2] := CompanyInfo.Address;

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                if not SalesPurchPerson.Get("Salesperson Code") then Clear(SalesPurchPerson);
                SalespersonCode_Name := SalesPurchPerson.Code;
                if (SalesPurchPerson."AltAWPCommercial Docs. Alias" <> '') then SalespersonCode_Name := SalesPurchPerson."AltAWPCommercial Docs. Alias";

                if ("Currency Code" = '') then begin
                    GLSetup.TestField("LCY Code");
                    CurrencyDescr := GLSetup."LCY Code";
                end else begin
                    CurrencyDescr := "Currency Code";
                end;

                FormatAddr.SalesCrMemoBillTo(CustAddr, SalesCrMemoHeader);
                FormatAddr.SalesCrMemoShipTo(ShipToAddr, CustAddr, SalesCrMemoHeader);

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

                PayTermDescr := '';
                if ("Payment Terms Code" = '') then begin
                    PaymentTerms.Init()
                end else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                    PayTermDescr := PaymentTerms.Description;
                end;

                CreditBankAccount := PrintFunctions.GetCreditBankText("Bill-to Customer No.", "Bank Account", SalesCrMemoHeader, "Payment Method Code", "Company Bank Account Code");

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

                SalesHeader.TransferFields(SalesCrMemoHeader);
                SalesHeader.FindVATExemption(VATExemption, VATExemptionCheck, true);

                CIGCUPText := '';
                if ("Fattura Tender Code" <> '') then begin
                    CIGCUPText := lblCIGNo + "Fattura Tender Code";
                end;

                if ("Fattura Project Code" <> '') then begin
                    if (CIGCUPText <> '') then begin
                        CIGCUPText := CIGCUPText + '    ' + lblCUPNo + "Fattura Project Code";
                    end else begin
                        CIGCUPText := lblCUPNo + "Fattura Project Code";
                    end;
                end;

                Text001 := '';
                if (Customer."Country/Region Code" = CompanyInfo."Country/Region Code") then begin
                    Text001 := lblText001;
                end;

                FreightTypeTxt := '';
                ShipMethDescr := '';
                Clear(HeaderCommentText);
                HeaderCommentText := PrintFunctions.GetDocumentCommentHeader(SalesCrMemoHeader, Report::"ecSales Credit Memo");
            end;

            trigger OnPreDataItem()
            begin
                Print := Print or not CurrReport.Preview;

                PrintTotals := true;
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
            ConaiHide := false;
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

        CashVATProdGrp := GLSetup."CashVAT Product Posting Group";
        if StrLen(CashVATProdGrp) > 0 then begin
            VATProdPostingGr.Get(CashVATProdGrp);
            CashVATFooterText := VATProdPostingGr.Description;
        end else begin
            CashVATFooterText := '';
        end;

        ConaiHide := false;
    end;

    trigger OnPreReport()
    begin
        TotalGifts := 0;
        GeneralSetup.Get();
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

    procedure FindPostedShipmentDate(): Date
    var
        ReturnReceiptHeader: Record "Return Receipt Header";
        Temp_lSalesShipmentBuffer2: Record "Sales Shipment Buffer" temporary;
    begin
        NextEntryNo := 1;
        if SalesCrMemoLine."Return Receipt No." <> '' then
            if ReturnReceiptHeader.Get(SalesCrMemoLine."Return Receipt No.") then
                exit(ReturnReceiptHeader."Posting Date");
        if SalesCrMemoHeader."Return Order No." = '' then
            exit(SalesCrMemoHeader."Posting Date");

        case SalesCrMemoLine.Type of
            SalesCrMemoLine.Type::Item:
                GenerateBufferFromValueEntry(SalesCrMemoLine);
            SalesCrMemoLine.Type::"G/L Account", SalesCrMemoLine.Type::Resource,
          SalesCrMemoLine.Type::"Charge (Item)", SalesCrMemoLine.Type::"Fixed Asset":
                GenerateBufferFromShipment(SalesCrMemoLine);
            SalesCrMemoLine.Type::" ":
                exit(0D);
        end;

        Temp_SalesShipmentBuffer.Reset();
        Temp_SalesShipmentBuffer.SetRange("Document No.", SalesCrMemoLine."Document No.");
        Temp_SalesShipmentBuffer.SetRange("Line No.", SalesCrMemoLine."Line No.");

        if Temp_SalesShipmentBuffer.Find('-') then begin
            Temp_lSalesShipmentBuffer2 := Temp_SalesShipmentBuffer;
            if Temp_SalesShipmentBuffer.Next() = 0 then begin
                Temp_SalesShipmentBuffer.Get(Temp_lSalesShipmentBuffer2."Document No.", Temp_lSalesShipmentBuffer2."Line No.", Temp_lSalesShipmentBuffer2."Entry No.");
                Temp_SalesShipmentBuffer.Delete();
                exit(Temp_lSalesShipmentBuffer2."Posting Date");
            end;
            Temp_SalesShipmentBuffer.CalcSums(Quantity);
            if Temp_SalesShipmentBuffer.Quantity <> SalesCrMemoLine.Quantity then begin
                Temp_SalesShipmentBuffer.DeleteAll();
                exit(SalesCrMemoHeader."Posting Date");
            end;
        end else
            exit(SalesCrMemoHeader."Posting Date");
    end;

    procedure GenerateBufferFromValueEntry(SalesCrMemoLine2: Record "Sales Cr.Memo Line")
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        Quantity: Decimal;
        TotalQuantity: Decimal;
    begin
        TotalQuantity := SalesCrMemoLine2."Quantity (Base)";
        ValueEntry.SetCurrentKey("Document No.");
        ValueEntry.SetRange("Document No.", SalesCrMemoLine2."Document No.");
        ValueEntry.SetRange("Posting Date", SalesCrMemoHeader."Posting Date");
        ValueEntry.SetRange("Item Charge No.", '');
        ValueEntry.SetFilter("Entry No.", '%1..', FirstValueEntryNo);
        if ValueEntry.Find('-') then
            repeat
                if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                    if SalesCrMemoLine2."Qty. per Unit of Measure" <> 0 then
                        Quantity := ValueEntry."Invoiced Quantity" / SalesCrMemoLine2."Qty. per Unit of Measure"
                    else
                        Quantity := ValueEntry."Invoiced Quantity";
                    AddBufferEntry(
                      SalesCrMemoLine2,
                      -Quantity,
                      ItemLedgerEntry."Posting Date");
                    TotalQuantity := TotalQuantity - ValueEntry."Invoiced Quantity";
                end;
                FirstValueEntryNo := ValueEntry."Entry No." + 1;
            until (ValueEntry.Next() = 0) or (TotalQuantity = 0);
    end;

    procedure GenerateBufferFromShipment(SalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        ReturnReceiptHeader: Record "Return Receipt Header";
        ReturnReceiptLine: Record "Return Receipt Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine2: Record "Sales Cr.Memo Line";
        Quantity: Decimal;
        TotalQuantity: Decimal;
    begin
        TotalQuantity := 0;
        SalesCrMemoHeader.SetCurrentKey("Return Order No.");
        SalesCrMemoHeader.SetFilter("No.", '..%1', SalesCrMemoHeader."No.");
        SalesCrMemoHeader.SetRange("Return Order No.", SalesCrMemoHeader."Return Order No.");
        if SalesCrMemoHeader.Find('-') then
            repeat
                SalesCrMemoLine2.SetRange("Document No.", SalesCrMemoHeader."No.");
                SalesCrMemoLine2.SetRange("Line No.", SalesCrMemoLine."Line No.");
                SalesCrMemoLine2.SetRange(Type, SalesCrMemoLine.Type);
                SalesCrMemoLine2.SetRange("No.", SalesCrMemoLine."No.");
                SalesCrMemoLine2.SetRange("Unit of Measure Code", SalesCrMemoLine."Unit of Measure Code");
                if SalesCrMemoLine2.Find('-') then
                    repeat
                        TotalQuantity := TotalQuantity + SalesCrMemoLine2.Quantity;
                    until SalesCrMemoLine2.Next() = 0;
            until SalesCrMemoHeader.Next() = 0;

        ReturnReceiptLine.SetCurrentKey("Return Order No.", "Return Order Line No.");
        ReturnReceiptLine.SetRange("Return Order No.", SalesCrMemoHeader."Return Order No.");
        ReturnReceiptLine.SetRange("Return Order Line No.", SalesCrMemoLine."Line No.");
        ReturnReceiptLine.SetRange("Line No.", SalesCrMemoLine."Line No.");
        ReturnReceiptLine.SetRange(Type, SalesCrMemoLine.Type);
        ReturnReceiptLine.SetRange("No.", SalesCrMemoLine."No.");
        ReturnReceiptLine.SetRange("Unit of Measure Code", SalesCrMemoLine."Unit of Measure Code");
        ReturnReceiptLine.SetFilter(Quantity, '<>%1', 0);

        if ReturnReceiptLine.Find('-') then
            repeat
                if SalesCrMemoHeader."Get Return Receipt Used" then
                    CorrectShipment(ReturnReceiptLine);
                if Abs(ReturnReceiptLine.Quantity) <= Abs(TotalQuantity - SalesCrMemoLine.Quantity) then
                    TotalQuantity := TotalQuantity - ReturnReceiptLine.Quantity
                else begin
                    if Abs(ReturnReceiptLine.Quantity) > Abs(TotalQuantity) then
                        ReturnReceiptLine.Quantity := TotalQuantity;
                    Quantity :=
                      ReturnReceiptLine.Quantity - (TotalQuantity - SalesCrMemoLine.Quantity);

                    SalesCrMemoLine.Quantity := SalesCrMemoLine.Quantity - Quantity;
                    TotalQuantity := TotalQuantity - ReturnReceiptLine.Quantity;

                    if ReturnReceiptHeader.Get(ReturnReceiptLine."Document No.") then begin
                        AddBufferEntry(
                          SalesCrMemoLine,
                          -Quantity,
                          ReturnReceiptHeader."Posting Date");
                    end;
                end;
            until (ReturnReceiptLine.Next() = 0) or (TotalQuantity = 0);
    end;

    procedure CorrectShipment(var ReturnReceiptLine: Record "Return Receipt Line")
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        SalesCrMemoLine.SetCurrentKey("Return Receipt No.", "Return Receipt Line No.");
        SalesCrMemoLine.SetRange("Return Receipt No.", ReturnReceiptLine."Document No.");
        SalesCrMemoLine.SetRange("Return Receipt Line No.", ReturnReceiptLine."Line No.");
        if SalesCrMemoLine.Find('-') then
            repeat
                ReturnReceiptLine.Quantity := ReturnReceiptLine.Quantity - SalesCrMemoLine.Quantity;
            until SalesCrMemoLine.Next() = 0;
    end;

    procedure AddBufferEntry(SalesCrMemoLine: Record "Sales Cr.Memo Line"; QtyOnShipment: Decimal; PostingDate: Date)
    begin
        Temp_SalesShipmentBuffer.SetRange("Document No.", SalesCrMemoLine."Document No.");
        Temp_SalesShipmentBuffer.SetRange("Line No.", SalesCrMemoLine."Line No.");
        Temp_SalesShipmentBuffer.SetRange("Posting Date", PostingDate);
        if Temp_SalesShipmentBuffer.Find('-') then begin
            Temp_SalesShipmentBuffer.Quantity := Temp_SalesShipmentBuffer.Quantity - QtyOnShipment;
            Temp_SalesShipmentBuffer.Modify();
            exit;
        end;

        Temp_SalesShipmentBuffer.Init();
        Temp_SalesShipmentBuffer."Document No." := SalesCrMemoLine."Document No.";
        Temp_SalesShipmentBuffer."Line No." := SalesCrMemoLine."Line No.";
        Temp_SalesShipmentBuffer."Entry No." := NextEntryNo;
        Temp_SalesShipmentBuffer.Type := SalesCrMemoLine.Type;
        Temp_SalesShipmentBuffer."No." := SalesCrMemoLine."No.";
        Temp_SalesShipmentBuffer.Quantity := -QtyOnShipment;
        Temp_SalesShipmentBuffer."Posting Date" := PostingDate;
        Temp_SalesShipmentBuffer.Insert();
        NextEntryNo := NextEntryNo + 1
    end;

    local procedure ExistsLinesAttachedAfter(var pSalesCrMemoLine: Record "Sales Cr.Memo Line"): Boolean
    var
        lSalesCrMemoLine2: Record "Sales Cr.Memo Line";
    begin
        Clear(lSalesCrMemoLine2);
        if (pSalesCrMemoLine.Type <> pSalesCrMemoLine.Type::" ") or
           (pSalesCrMemoLine."Attached to Line No." <> 0)
        then begin
            lSalesCrMemoLine2.SetRange("Document No.", pSalesCrMemoLine."Document No.");
            lSalesCrMemoLine2.SetFilter("Line No.", '>%1', pSalesCrMemoLine."Line No.");
            if (pSalesCrMemoLine.Type = pSalesCrMemoLine.Type::" ") and (pSalesCrMemoLine."Attached to Line No." <> 0) then begin
                lSalesCrMemoLine2.SetRange("Attached to Line No.", pSalesCrMemoLine."Attached to Line No.");
            end else begin
                lSalesCrMemoLine2.SetRange("Attached to Line No.", pSalesCrMemoLine."Line No.");
            end;
            if not lSalesCrMemoLine2.IsEmpty then begin
                exit(true);
            end else begin
                if (pSalesCrMemoLine.Type = pSalesCrMemoLine.Type::" ") and (pSalesCrMemoLine."Attached to Line No." <> 0) then begin
                    lSalesCrMemoLine2.SetRange("Attached to Line No.");
                    lSalesCrMemoLine2.SetFilter("Line No.", '>%1 & =%2', pSalesCrMemoLine."Line No.", pSalesCrMemoLine."Attached to Line No.");
                    if not lSalesCrMemoLine2.IsEmpty then exit(true);
                end else begin
                    if (pSalesCrMemoLine.Type <> pSalesCrMemoLine.Type::" ") then begin
                        lSalesCrMemoLine2.SetRange("Attached to Line No.");
                        lSalesCrMemoLine2.SetFilter("Line No.", '>%1', pSalesCrMemoLine."Line No.");
                        lSalesCrMemoLine2.SetRange("APsFOC Attach. to Line No.", pSalesCrMemoLine."Line No.");
                        if not lSalesCrMemoLine2.IsEmpty then exit(true);
                    end;
                end;
            end;
        end else begin
            if (pSalesCrMemoLine.Type = pSalesCrMemoLine.Type::" ") then begin
                lSalesCrMemoLine2.SetRange("Document No.", pSalesCrMemoLine."Document No.");
                lSalesCrMemoLine2.SetFilter("Line No.", '>%1', pSalesCrMemoLine."Line No.");
                if not lSalesCrMemoLine2.IsEmpty then begin
                    lSalesCrMemoLine2.FindFirst();
                    if (lSalesCrMemoLine2.Type = lSalesCrMemoLine2.Type::" ") and
                       (lSalesCrMemoLine2."Attached to Line No." = 0)
                    then begin
                        exit(true);
                    end;
                end;
            end;
        end;

        exit(false);
    end;

    var
        CompanyInfo: Record "Company Information";
        Currency: Record Currency;
        Cust: Record Customer;
        Customer: Record Customer;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";
        Item: Record Item;
        PaymentMethod: Record "Payment Method";
        PaymentTerms: Record "Payment Terms";
        RespCenter: Record "Responsibility Center";
        Temp_SalesCrMemoLine_Print: Record "Sales Cr.Memo Line" temporary;
        SalesHeader: Record "Sales Header";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        Temp_SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        ShipmentMethod: Record "Shipment Method";
        ShippingAgent: Record "Shipping Agent";
        Temp_VATAmountLine: Record "VAT Amount Line" temporary;
        VATExemption: Record "VAT Exemption";
        VATProdPostingGr: Record "VAT Product Posting Group";
        GeneralSetup: Record "AltAWPGeneral Setup";
        FormatAddr: Codeunit "Format Address";
        SalesCrMemoCountPrinted: Codeunit "Sales Cr. Memo-Printed";
        SegManagement: Codeunit SegManagement;
        PrintFunctions: Codeunit "AltAWPPrint Functions";
        awpCommentsManagement: Codeunit "AltAWPComments Management";
        LayoutType: Enum "AltAWPDocument Default Layout";
        PrintItemCrossRefOpt: Option "Customer Default",Yes,No;
        ShowTariffNoOpt: Option "Customer Default",Yes,No;
        ShowTrackingInfoOpt: Option "Customer Default",None,Standard,Extended;
        BankDescr: Text;
        CIGCUPText: Text;
        SSCCInfo: Text;
        TrackingInfoLine: Text;
        CountryOrigin: Text;
        SalespersonCode_Name: Text;
        CompanyOfficeAddress: array[5] of Text;
        ComposedDiscount: Text;
        CreditBankAccount: Text;
        ItemReferenceNo: Text;
        FreightTypeTxt: Text;
        HeaderInformationArray: array[10] of Text;
        PaymentArray: array[6] of Text;
        PayMethDescr: Text;
        PayTermDescr: Text;
        ShipMethDescr: Text;
        TariffNo: Text;
        Text001: Text;
        LastHeaderInformationArrayText: Text;
        EuroTxt: Text[3];
        CurrencyDescr: Text[30];
        FreeInvTxt: Text[30];
        CashVATFooterText: Text[50];
        CompanyAddr: array[8] of Text[50];
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        VATDescrArray: array[6] of Text[50];
        OldDimText: Text[75];
        ConaiText: Text[100];
        DimText: Text[120];
        HeaderCommentText: Text;
        ConaiHide: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        LogInteractionEnable: Boolean;
        MoreLines: Boolean;
        IsNewLine: Boolean;
        Print: Boolean;
        PrintCashVATFooter: Boolean;
        PrintTotals: Boolean;
        VATExemptionCheck: Boolean;
        CashVATProdGrp: Code[10];
        VATCodeArray: array[6] of Code[20];
        PaymentsDateArray: array[10] of Date;
        AmountArray: array[10] of Decimal;
        BaseAmountArray: array[6] of Decimal;
        DocumentGrossAmount: Decimal;
        InvDiscPerc: Decimal;
        NetToPay: Decimal;
        PaymentsAmountArray: array[10] of Decimal;
        TotalBaseAmount: Decimal;
        TotalDocAmount: Decimal;
        TotalEuroDocAmount: Decimal;
        TotalGifts: Decimal;
        TotalInvDiscAmt: Decimal;
        TotalInvDiscBaseAmt: Decimal;
        TotalVATAmount: Decimal;
        VALVATAmountLCY: Decimal;
        VALVATBaseLCY: Decimal;
        TotalParcels: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        VATAmountArray: array[6] of Decimal;
        FirstValueEntryNo: Integer;
        GroupLineIndex: Integer;
        Ind: Integer;
        NextEntryNo: Integer;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        lblBillToCustomer: Label 'Addressee';
        lblChange: Label 'Change';
        lblCIGNo: Label 'CIG: ';
        lblCode: Label 'Code';
        lblConai: Label 'Contributo conai - polieco assolti ove dovuti';
        lblCreditBankAccount: Label 'Credit Bank Account';
        lblCUPNo: Label 'CUP: ';
        lblCurrency: Label 'Currency';
        lblCustomerNo: Label 'Customer';
        lblDeadlinesAmount: Label '%1) %2 %3 %4 at %5';
        lblDeliveryTerms: Label 'Delivery terms';
        lblDescription: Label 'Description';
        lblDiscount: Label 'Composed discount';
        lblDocumentDate: Label 'Document date';
        lblDocumentNo: Label 'Document No.';
        lblDocumentTotal: Label 'Document total';
        lblDocumentType: Label 'Document type';
        lblExporterCode: Label 'Exporter code';
        lblFax: Label 'Fax';
        lblFiscalCode: Label 'Fiscal code';
        lblFreeInvoiceCaption: Label 'FREE INVOICE';
        lblInvoiceDisc: Label 'Document discount amount';
        lblInvoiceDiscPerc: Label 'Document discount %';
        lblLineAmt: Label 'Amount';
        lblNetToPay: Label 'Net to Pay';
        lblNote: Label 'Note';
        lblOffice: Label 'Head Office';
        lblPageNo: Label 'Page';
        lblPaymentTerms: Label 'Payment terms';
        lblPayMeth: Label 'Payment method';
        lblPhone: Label 'Phone';
        lblPmtExpiry: Label 'Expiry and amount';
        lblProject: Label 'Project';
        lblQuantity: Label 'Q.ty';
        lblQuoteRef: Label 'Reference offer';
        lblRegOffice: Label 'Registered Office';
        lblRev: Label 'Rev. 5';
        lblSaleCondition: Label 'Sale conditions on ';
        lblSalesperson: Label 'Salesperson';
        lblShipmentType: Label 'Shipment Type';
        lblShippingAgent: Label 'Carrier';
        lblShipTo: Label 'Consignee';
        lblTariffNo: Label 'H.S. Code : %1';
        lblText001: Label 'Documento non valido ai fini fiscali (ai sensi dell’art. 21 Dpr 633/72), salvo per i soggetti non titolari di Partita Iva e/o non residenti per i quali costituisce copia analogica di fattura (art. 1. co. 909 L. 205/2017). La e-fattura è disponibile all’indirizzo telematico da Lei fornito oppure nella Sua area riservata dell’Agenzia delle Entrate.';
        lblTextWord01: Label 'Dear';
        lblTextWord02: Label 'attached sale credit memo';
        lblTitle: Label 'CREDIT MEMO';
        lblTotal: Label 'TOTAL';
        lblTotalAmt: Label 'Total taxable amount';
        lblTotalAmtForDisc: Label 'Discountable taxable amount';
        lblTotalDocument: Label 'Total document';
        lblTotalGift: Label 'Value of gifts';
        lblUM: Label 'UM';
        lblUnitPrice: Label 'Unit price';
        lblVariant: Label 'Item variant';
        lblVAT: Label 'VAT';
        lblVATAmount: Label 'Tax';
        lblVATAmount2: Label 'VAT amount';
        lblVATBaseAmt: Label 'Taxable amount';
        lblVATCode: Label 'Code';
        lblVATDescription: Label 'Description';
        lblVatRegFiscalCode: Label 'Tax Code No.';
        lblVatRegNo: Label 'VAT reg. no.';
        lblVATTaxable: Label 'VAT Base Amuont';
        lblVATTotalAmount: Label 'VAT total';
        lblVATTotalBaseAmount: Label 'Tax amount';
        lblYourRef: Label 'Your Reference';
        lblTotGrossWeight: Label 'Gross weight';
        lblTotNetWeight: Label 'Net weight';
        lblTotalParcels: Label 'Total parcels';
        lblQuantityUMC: Label 'Q.ty UMC';
        lblOrigin: Label 'Origin: ';
        lblSSCC: Label 'SSCC: ';
        lblUMC: Label 'UMC';
        lblUMCPrice: Label 'Price UMC';
        lblItemRefrenceNo: Label 'Item ref. no. : %1';
        lblExpirationDate: Label 'Expiration date: %1';
        lblLotQty: Label ' Qty: %1';
        lblLotNo: Label ' Lot No.: %1';
        Txt001: Label '%1 - %2 %3 (%4)';
        Text002: Label '%1 %2', Locked = true;
        Text003: Label '%1 %2 %3', Locked = true;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesCrMemoHeaderOnAfterGetRecord(pSalesCrMemoHeader: Record "Sales Cr.Memo Header"; var pLastHeaderInformationArrayText: Text)
    begin
    end;
}


