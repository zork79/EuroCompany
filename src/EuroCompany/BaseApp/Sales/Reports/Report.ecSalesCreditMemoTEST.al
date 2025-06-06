namespace EuroCompany.BaseApp.Sales.Reports;

using Microsoft.Bank.BankAccount;
using Microsoft.CRM.Contact;
using Microsoft.CRM.Interaction;
using Microsoft.CRM.Segment;
using Microsoft.CRM.Team;
using Microsoft.Finance.Currency;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.VAT.Calculation;
using Microsoft.Foundation.Address;
using Microsoft.Foundation.Company;
using Microsoft.Foundation.PaymentTerms;
using Microsoft.Foundation.Shipping;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;
using Microsoft.Sales.Posting;
using Microsoft.Utilities;
using Microsoft.Warehouse.Journal;
using Microsoft.Warehouse.Ledger;
using System.Utilities;

report 50017 "ecSales Credit Memo TEST"
{
    ApplicationArea = All;
    Caption = 'Sales Credit Memo TEST';
    DefaultLayout = RDLC;
    Description = 'GAP_VEN_001';
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    RDLCLayout = '.\src\EuroCompany\BaseApp\Sales\Reports\SalesCreditMemoTEST.Layout.rdlc';
    UsageCategory = None;

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.")
                                where("Document Type" = const("Credit Memo"));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed", Status;
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
            column(Company_WatermarkLogo; GeneralSetup."Not Released Doc. Watermark")
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
            column(Your_Reference; "Your Reference")
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
            column(Cust_Addr8r; CustAddr[8])
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
            column(DocumentDate; Format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(DocumentNo; "No.")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(FreightType; FreightTypeTxt)
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
            column(PaymentTermsDescription; PayMethDescr)
            {
            }
            column(PayTermDescr; PayTermDescr)
            {
            }
            column(PrintTotals; PrintTotals)
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
                        DataItemLinkReference = SalesHeader;
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
                    dataitem(SalesLine; "Sales Line")
                    {
                        DataItemLink = "Document Type" = field("Document Type"),
                                       "Document No." = field("No.");
                        DataItemLinkReference = SalesHeader;
                        DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break();
                        end;
                    }
                    dataitem(RoundLoop; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(PrintDesignCardExternalRef; PrintDesignCardExternalRef)
                        {
                        }
                        column(SalesLine_ComposedDiscount; ComposedDiscount)
                        {
                        }
                        column(SalesLine_Description; Temp_SalesLine_Print.Description)
                        {
                        }
                        column(SalesLine_Description2; Temp_SalesLine_Print."Description 2")
                        {
                        }
                        column(SalesLine_GroupLineIndex; GroupLineIndex)
                        {
                        }
                        column(SalesLine_LineAmount; Temp_SalesLine_Print."Line Amount")
                        {
                            AutoFormatExpression = SalesHeader."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLine_LineNo; SalesLine."Line No.")
                        {
                        }
                        column(SalesLine_No; Temp_SalesLine_Print."No.")
                        {
                        }
                        column(SalesLine_Quantity; Temp_SalesLine_Print.Quantity)
                        {
                        }
                        column(SalesLine_TariffNo; TariffNo)
                        {
                        }
                        column(SalesLine_Type; Temp_SalesLine_Print.Type.AsInteger())
                        {
                        }
                        column(SalesLine_UM; Temp_SalesLine_Print."Unit of Measure Code")
                        {
                        }
                        column(SalesLine_UnitPrice; Temp_SalesLine_Print."Unit Price")
                        {
                            AutoFormatExpression = SalesHeader."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(SalesLine_VariantCode; Temp_SalesLine_Print."Variant Code")
                        {
                        }
                        column(SalesLine_VATIdentifier; Temp_SalesLine_Print."VAT Identifier")
                        {
                        }
                        column(SalesLine_TotalNetWeight; Temp_SalesLine_Print."AltAWPTotal Net Weight")
                        {
                            DecimalPlaces = 0 : 2;
                        }
                        column(SalesLine_ConsumerUnitofMeasure; Temp_SalesLine_Print."ecConsumer Unit of Measure")
                        {
                        }
                        column(SalesLine_QtyConsumerUM; Temp_SalesLine_Print."ecQuantity (Consumer UM)")
                        {
                            DecimalPlaces = 0 : 2;
                        }
                        column(SalesLine_UnitPriceConsumerUM; Temp_SalesLine_Print."ecUnit Price (Consumer UM)")
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
                            var
                                lReturnReceiptLine: Record "Return Receipt Line";
                            begin
                                if (ShowTrackingInfoOpt = ShowTrackingInfoOpt::None) then CurrReport.Break();
                                if not lReturnReceiptLine.Get(Temp_SalesLine."Return Receipt No.", Temp_SalesLine."Return Receipt Line No.") then CurrReport.Break();
                                SetRange("Whse. Document No.", lReturnReceiptLine."AltAWPPosted Whse Receipt No.");
                                SetRange("Whse. Document Line No.", lReturnReceiptLine."AltAWPPosted Whse Rcpt Line");
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

                                DimSetEntry2.SetRange("Dimension Set ID", SalesLine."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            lUnitofMeasure: Record "Unit of Measure";
                            lSalesLine: Record "Sales Line";
                            lAPsFOCPostingSetup: Record "APsFOC Posting Setup";
                            lAWPPrintFunctions: Codeunit "AltAWPPrint Functions";
                            lRecordVariant: Variant;
                        begin
                            if Number = 1 then
                                Temp_SalesLine.Find('-')
                            else
                                Temp_SalesLine.Next();
                            SalesLine := Temp_SalesLine;
                            Temp_SalesLine_Print := Temp_SalesLine;

                            //AWP091-VI-s
                            if (Temp_SalesLine.Type = Temp_SalesLine.Type::" ") and
                               (Temp_SalesLine."AltAWPComment Reason Code" <> '')
                            then begin
                                if not awpCommentsManagement.IsValidCommentReasonByReport(Temp_SalesLine."AltAWPComment Reason Code",
                                                                                          Report::"AltAWPSales Credit Memo TEST")
                                then begin
                                    CurrReport.Skip();
                                end;
                            end;
                            //AWP091-VI-e

                            if not SalesHeader."Prices Including VAT" and
                               (Temp_SalesLine."VAT Calculation Type" = Temp_SalesLine."VAT Calculation Type"::"Full VAT")
                            then begin
                                Temp_SalesLine."Line Amount" := 0;
                            end;

                            if (Temp_SalesLine_Print."ecConsumer Unit of Measure" = '') then begin
                                Temp_SalesLine_Print."ecConsumer Unit of Measure" := Temp_SalesLine_Print."Unit of Measure Code";
                                Temp_SalesLine_Print."ecQuantity (Consumer UM)" := Temp_SalesLine_Print.Quantity;
                                Temp_SalesLine_Print."ecUnit Price (Consumer UM)" := Temp_SalesLine_Print."Unit Price";
                            end;

                            TariffNo := '';
                            ItemReferenceNo := '';
                            if (Temp_SalesLine_Print.Type = Temp_SalesLine_Print.Type::Item) then begin
                                if (ShowTariffNoOpt = ShowTariffNoOpt::Yes) then begin
                                    if Item.Get(Temp_SalesLine_Print."No.") and (Item."Tariff No." <> '') then begin
                                        TariffNo := StrSubstNo(lblTariffNo, Item."Tariff No.");
                                    end;
                                end;
                                if (PrintItemCrossRefOpt = PrintItemCrossRefOpt::Yes) then begin
                                    if (Temp_SalesLine_Print."Item Reference No." <> '') then begin
                                        ItemReferenceNo := StrSubstNo(lblItemRefrenceNo, Temp_SalesLine_Print."Item Reference No.");
                                    end;
                                end;
                            end;
                            if (Temp_SalesLine.Type = Temp_SalesLine.Type::" ") then begin
                                Temp_SalesLine_Print."No." := '';
                            end;

                            DocumentGrossAmount += Temp_SalesLine."Line Amount";

                            ComposedDiscount := Temp_SalesLine_Print."APsComposed Discount";
                            lRecordVariant := Temp_SalesLine_Print;
                            lAWPPrintFunctions.ManageComposedDiscountValue(lRecordVariant, ComposedDiscount);

                            lAWPPrintFunctions.GetDocumentLayoutType(SalesHeader, LayoutType);
                            case LayoutType of
                                LayoutType::"Net Price":
                                    begin
                                        ComposedDiscount := '';
                                        if (Temp_SalesLine_Print.Quantity <> 0) then begin
                                            if (Temp_SalesLine_Print."Line Discount %" <> 0) then begin
                                                Temp_SalesLine_Print."Unit Price" := Temp_SalesLine_Print."Line Amount" / Temp_SalesLine_Print.Quantity;
                                            end;
                                        end else begin
                                            Temp_SalesLine_Print."Unit Price" := 0;
                                        end;
                                    end;

                                LayoutType::"No Price":
                                    begin
                                        ComposedDiscount := '';
                                        Temp_SalesLine_Print."Unit Price" := 0;
                                        Temp_SalesLine_Print."Line Amount" := 0;
                                        Temp_SalesLine_Print."VAT Identifier" := '';
                                    end;
                            end;

                            OrderRef := Temp_SalesLine."AltAWPOrder No.";
                            if Temp_SalesLine."AltAWPOrder No." <> '' then
                                if SalesOrder.Get(SalesOrder."Document Type"::Order, Temp_SalesLine."AltAWPOrder No.") then begin
                                    if SalesOrder."External Document No." <> '' then
                                        OrderRef := OrderRef + '\' + SalesOrder."External Document No.";
                                end;

                            if (Temp_SalesLine_Print."APsFOC Attach. to Line No." <> 0) then begin
                                if lSalesLine.Get(Temp_SalesLine_Print."Document Type",
                                                  Temp_SalesLine_Print."Document No.",
                                                  Temp_SalesLine_Print."APsFOC Attach. to Line No.")
                                then begin
                                    if (lSalesLine."APsFOC Code" <> '') and
                                       lAPsFOCPostingSetup.Get(lSalesLine."APsFOC Code") and
                                       (lAPsFOCPostingSetup.Type = Temp_SalesLine_Print.Type) and
                                       (lAPsFOCPostingSetup."No." = Temp_SalesLine_Print."No.") and
                                       (lAPsFOCPostingSetup."FOC Type" in [lAPsFOCPostingSetup."FOC Type"::"Without VAT Charge",
                                                                           lAPsFOCPostingSetup."FOC Type"::"VAT Charge"])
                                    then begin
                                        TotalGifts += Abs(Temp_SalesLine_Print."Amount Including VAT");
                                    end;
                                end;
                            end;

                            if (Temp_SalesLine_Print.Type = Temp_SalesLine_Print.Type::Item) and lUnitofMeasure.Get(Temp_SalesLine_Print."Unit of Measure Code") and
                               (lUnitofMeasure."AltAWPType Unit Of Measure" = lUnitofMeasure."AltAWPType Unit Of Measure"::Parcels)
                            then begin
                                TotalParcels += Temp_SalesLine_Print.Quantity;
                            end;
                            TotalNetWeight += Temp_SalesLine_Print."AltAWPTotal Net Weight";
                            TotalGrossWeight += Temp_SalesLine_Print."AltAWPTotal Gross Weight";

                            IsNewLine := not ExistsLinesAttachedAfter(Temp_SalesLine_Print);
                        end;

                        trigger OnPostDataItem()
                        begin
                            Temp_SalesLine.DeleteAll();
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(CompanyInfo.Picture);
                            Clear(GeneralSetup."Picture Footer Report");
                            Clear(GeneralSetup."Not Released Doc. Watermark");

                            MoreLines := Temp_SalesLine.Find('+');
                            while MoreLines and (Temp_SalesLine.Description = '') and (Temp_SalesLine."Description 2" = '') and
                                  (Temp_SalesLine."No." = '') and (Temp_SalesLine.Quantity = 0) and
                                  (Temp_SalesLine.Amount = 0)
                            do
                                MoreLines := Temp_SalesLine.Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            Temp_SalesLine.SetRange("Line No.", 0, Temp_SalesLine."Line No.");
                            SetRange(Number, 1, Temp_SalesLine.Count);
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

                            TotalBaseAmount += Temp_VATAmountLine."VAT Base";
                            TotalVATAmount += Temp_VATAmountLine."VAT Amount";

                            TotalInvDiscBaseAmt += Temp_VATAmountLine."Inv. Disc. Base Amount";
                            TotalInvDiscAmt += Temp_VATAmountLine."Invoice Discount Amount";
                        end;

                        trigger OnPostDataItem()
                        begin
                            InvDiscPerc := 0;
                            if (SalesHeader."Invoice Discount Calculation" = SalesHeader."Invoice Discount Calculation"::"%") then begin
                                InvDiscPerc := SalesHeader."Invoice Discount Value";
                            end else begin
                                if (TotalInvDiscBaseAmt <> 0) then begin
                                    InvDiscPerc := Round(TotalInvDiscAmt / TotalInvDiscBaseAmt * 100, 0.01);
                                end;
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
                            AutoFormatExpression = SalesHeader."Currency Code";
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
                        column(VATDiscountAmount; VATDiscountAmount)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            lIsHandled: Boolean;
                        begin
                            TotalDocAmount := TotalBaseAmount + TotalVATAmount;
                            NetToPay := TotalDocAmount - TotalGifts;

                            if (SalesHeader."Currency Code" <> '') and (false) //Nascosta la stampa dell'importo in Euro nel caso di valuta estera
                            then begin
                                Currency.Get(SalesHeader."Currency Code");
                                if SalesHeader."Currency Factor" <> 0 then
                                    TotalEuroDocAmount := Round(TotalDocAmount / SalesHeader."Currency Factor",
                                                                Currency."Amount Rounding Precision");
                                EuroTxt := 'EUR';
                            end else begin
                                Clear(Currency);
                                TotalEuroDocAmount := 0;
                                EuroTxt := '';
                            end;

                            Clear(PaymentsAmountArray);
                            Clear(PaymentsDateArray);
                            Clear(PaymentArray);
                            Ind := 0;

                            PaymentLines.Reset();
                            PaymentLines.SetRange("Sales/Purchase", PaymentLines."Sales/Purchase"::Sales);
                            PaymentLines.SetRange(Type, SalesHeader."Document Type");
                            PaymentLines.SetRange(Code, SalesHeader."No.");
                            if not PaymentLines.IsEmpty then begin
                                PaymentLines.FindSet();
                                repeat
                                    Ind += 1;
                                    PaymentsAmountArray[Ind] := PaymentLines.Amount;
                                    PaymentsDateArray[Ind] := PaymentLines."Due Date";
                                    lIsHandled := false;
                                    OnBeforeAssignPaymentArrayValue(PaymentLines, PaymentArray[Ind], Ind, lIsHandled);
                                    if not lIsHandled then begin
                                        PaymentArray[Ind] := StrSubstNo(lblDeadlinesAmount, Ind,
                                                                        SalesHeader."Payment Method Code",
                                                                        PaymentLines.Amount,
                                                                        Format(PaymentLines."Due Date", 0, '<Day,2>/<Month,2>/<Year4>'));
                                    end;
                                until (PaymentLines.Next() = 0) or (Ind = ArrayLen(PaymentsAmountArray));
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

                            VALVATBaseLCY := Round(CurrExchRate.ExchangeAmtFCYToLCY(
                                               SalesHeader."Posting Date", SalesHeader."Currency Code",
                                               Temp_VATAmountLine."VAT Base", SalesHeader."Currency Factor"));
                            VALVATAmountLCY := Round(CurrExchRate.ExchangeAmtFCYToLCY(
                                                 SalesHeader."Posting Date", SalesHeader."Currency Code",
                                                 Temp_VATAmountLine."VAT Amount", SalesHeader."Currency Factor"));
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               (SalesHeader."Currency Code" = '') or
                               (Temp_VATAmountLine.GetTotalVATAmount() = 0) then
                                CurrReport.Break();

                            SetRange(Number, 1, Temp_VATAmountLine.Count);

                            CurrExchRate.FindCurrency(SalesHeader."Posting Date", SalesHeader."Currency Code", 1);
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                var
                    SalesPost: Codeunit "Sales-Post";
                begin
                    DocDataReset();

                    Clear(Temp_SalesLine);
                    Clear(SalesPost);
                    Temp_VATAmountLine.DeleteAll();
                    Temp_SalesLine.DeleteAll();
                    SalesPost.GetSalesLines(SalesHeader, Temp_SalesLine, 0);
                    Temp_SalesLine.CalcVATAmountLines(0, SalesHeader, Temp_SalesLine, Temp_VATAmountLine);
                    Temp_SalesLine.UpdateVATOnLines(0, SalesHeader, Temp_SalesLine, Temp_VATAmountLine);
                    VATDiscountAmount :=
                      Temp_VATAmountLine.GetTotalVATDiscount(SalesHeader."Currency Code", SalesHeader."Prices Including VAT");

                    if Number > 1 then begin
                        OutputNo += 1;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if Print then begin
                        SalesCountPrinted.Run(SalesHeader);
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                lCustomer: Record Customer;
            begin
                if not Customer.Get(SalesHeader."Sell-to Customer No.") then Clear(Customer);

                TotalGifts := 0;
                TotalParcels := 0;
                TotalNetWeight := 0;
                TotalGrossWeight := 0;

                if not lCustomer.Get(SalesHeader."Bill-to Customer No.") then Clear(lCustomer);
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

                if GeneralSetup."Active Watermark Sale Doc." then begin
                    Clear(GeneralSetup."Not Released Doc. Watermark");
                    Clear(GeneralSetup."Picture Footer Report");
                    if (Status <> Status::Released) then begin
                        GeneralSetup.CalcFields("Not Released Doc. Watermark");
                    end;
                end;

                Clear(LastHeaderInformationArrayText);
                OnBeforeSalesHeaderOnAfterGetRecord(SalesHeader, LastHeaderInformationArrayText);
                PrintFunctions.GetHeaderInformation(SalesHeader."AltAWPBranch Code",
                                                    SalesHeader."Location Code",
                                                    HeaderInformationArray,
                                                    LastHeaderInformationArrayText);

                if ("Bill-to Customer No." = '') or (not Cust.Get("Bill-to Customer No.")) then begin
                    CurrReport.Skip();
                end;

                CurrReport.Language := PrintFunctions.GetReportLanguageCode("Language Code");
                CompanyInfo.CalcFields(Picture);
                GeneralSetup.CalcFields("Picture Footer Report");

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
                Salesperson_Code_Name := SalesPurchPerson.Code;
                if (SalesPurchPerson."AltAWPCommercial Docs. Alias" <> '') then Salesperson_Code_Name := SalesPurchPerson."AltAWPCommercial Docs. Alias";

                if ("Currency Code" = '') then begin
                    GLSetup.TestField("LCY Code");
                    CurrencyDescr := GLSetup."LCY Code";
                end else begin
                    CurrencyDescr := "Currency Code";
                end;

                FormatAddr.SalesHeaderBillTo(CustAddr, SalesHeader);
                FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, SalesHeader);

                if Print then begin
                    if ArchiveDocument then begin
                        ArchiveManagement.StoreSalesDocument(SalesHeader, LogInteraction);
                    end;

                    if LogInteraction then begin
                        CalcFields("No. of Archived Versions");
                        if ("Bill-to Contact No." <> '') then begin
                            SegManagement.LogDocument(
                              1, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", Database::Contact, "Bill-to Contact No."
                              , "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.")
                        end else begin
                            SegManagement.LogDocument(
                              1, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", Database::Customer, "Bill-to Customer No.",
                              "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.");
                        end;
                    end;
                end;
                Mark(true);

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

                CreditBankAccount := PrintFunctions.GetCreditBankText("Bill-to Customer No.", "Bank Account", SalesHeader, "Payment Method Code", "Company Bank Account Code");

                if not ShippingAgent.Get("Shipping Agent Code") then Clear(ShippingAgent);

                if ("Currency Factor" = 0) then begin
                    "Currency Factor" := 1;
                end;

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
                HeaderCommentText := PrintFunctions.GetDocumentCommentHeader(SalesHeader, Report::"ecSales Credit Memo TEST");

                Clear(PrintFunctions);
                PrintFunctions.UpdateSalesPaymentLinesAmount(SalesHeader);
            end;

            trigger OnPostDataItem()
            begin
                MarkedOnly := true;
                Commit();
                CurrReport.Language := GlobalLanguage;
            end;

            trigger OnPreDataItem()
            var
                lSalesHeader2: Record "Sales Header";
                lStatus: Integer;
                lError01: Label 'It is not possible to print documents in different states at the same time!', Comment = 'Non è possibile stampare contemporaneamente documenti in stati differenti!';
            begin
                Print := Print or not CurrReport.Preview;

                PrintTotals := true;

                GeneralSetup.Get();
                if GeneralSetup."Active Watermark Sale Doc." then begin
                    lSalesHeader2.CopyFilters(SalesHeader);
                    if lSalesHeader2.FindFirst() then begin
                        lStatus := lSalesHeader2.Status.AsInteger();
                        if lSalesHeader2.FindSet() then begin
                            repeat
                                if (lStatus = lSalesHeader2.Status::Released.AsInteger()) then begin
                                    if (lSalesHeader2.Status <> lSalesHeader2.Status::Released) then begin
                                        Error(lError01);
                                    end;
                                end else begin
                                    if (lSalesHeader2.Status = lSalesHeader2.Status::Released) then begin
                                        Error(lError01);
                                    end;
                                end;
                            until (lSalesHeader2.Next() = 0)
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
                    field(ArchiveDocument_Field; ArchiveDocument)
                    {
                        ApplicationArea = All;
                        Caption = 'Archive Document';
                        Enabled = ArchiveDocumentEnable;

                        trigger OnValidate()
                        begin
                            if not ArchiveDocument then
                                LogInteraction := false;
                        end;
                    }
                    field(LogInteraction_Field; LogInteraction)
                    {
                        ApplicationArea = All;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        Visible = false;

                        trigger OnValidate()
                        begin
                            if LogInteraction then
                                ArchiveDocument := ArchiveDocumentEnable;
                        end;
                    }
                    field(ConaiHide_Field; ConaiHide)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Conai Info';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
            ArchiveDocumentEnable := true;

            ArchiveDocument := ArchiveManagement.SalesDocArchiveGranule();
            LogInteraction := SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Sales Cr. Memo") <> '';

            ArchiveDocumentEnable := ArchiveDocument;
            LogInteractionEnable := LogInteraction;
            ArchiveDocument := false;
            LogInteraction := false;

            LayoutType := LayoutType::"Customer Default";
            ConaiHide := false;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        CompanyInfo.Get();
        ConaiHide := false;
    end;

    trigger OnPreReport()
    begin
        TotalGifts := 0;
    end;

    procedure InitializeRequest(NoOfCopiesFrom: Integer; ArchiveDocumentFrom: Boolean; LogInteractionFrom: Boolean; PrintFrom: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        ArchiveDocument := ArchiveDocumentFrom;
        LogInteraction := LogInteractionFrom;
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

    local procedure ExistsLinesAttachedAfter(var pSalesLine: Record "Sales Line"): Boolean
    var
        lSalesLine2: Record "Sales Line";
    begin
        Clear(lSalesLine2);
        if (pSalesLine.Type <> pSalesLine.Type::" ") or
           (pSalesLine."Attached to Line No." <> 0)
        then begin
            lSalesLine2.SetRange("Document Type", pSalesLine."Document Type");
            lSalesLine2.SetRange("Document No.", pSalesLine."Document No.");
            lSalesLine2.SetFilter("Line No.", '>%1', pSalesLine."Line No.");
            if (pSalesLine.Type = pSalesLine.Type::" ") and (pSalesLine."Attached to Line No." <> 0) then begin
                lSalesLine2.SetRange("Attached to Line No.", pSalesLine."Attached to Line No.");
            end else begin
                lSalesLine2.SetRange("Attached to Line No.", pSalesLine."Line No.");
            end;
            if not lSalesLine2.IsEmpty then begin
                exit(true);
            end else begin
                if (pSalesLine.Type = pSalesLine.Type::" ") and (pSalesLine."Attached to Line No." <> 0) then begin
                    lSalesLine2.SetRange("Attached to Line No.");
                    lSalesLine2.SetFilter("Line No.", '>%1 & =%2', pSalesLine."Line No.", pSalesLine."Attached to Line No.");
                    if not lSalesLine2.IsEmpty then exit(true);
                end else begin
                    if (pSalesLine.Type <> pSalesLine.Type::" ") then begin
                        lSalesLine2.SetRange("Attached to Line No.");
                        lSalesLine2.SetFilter("Line No.", '>%1', pSalesLine."Line No.");
                        lSalesLine2.SetRange("APsFOC Attach. to Line No.", pSalesLine."Line No.");
                        if not lSalesLine2.IsEmpty then exit(true);
                    end;
                end;
            end;
        end else begin
            if (pSalesLine.Type = pSalesLine.Type::" ") then begin
                lSalesLine2.SetRange("Document Type", pSalesLine."Document Type");
                lSalesLine2.SetRange("Document No.", pSalesLine."Document No.");
                lSalesLine2.SetFilter("Line No.", '>%1', pSalesLine."Line No.");
                if not lSalesLine2.IsEmpty then begin
                    lSalesLine2.FindFirst();
                    if (lSalesLine2.Type = lSalesLine2.Type::" ") and
                       (lSalesLine2."Attached to Line No." = 0)
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
        CompanyInfo: Record "Company Information";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        Cust: Record Customer;
        Customer: Record Customer;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";
        Item: Record Item;
        PaymentLines: Record "Payment Lines";
        PaymentMethod: Record "Payment Method";
        PaymentTerms: Record "Payment Terms";
        RespCenter: Record "Responsibility Center";
        SalesOrder: Record "Sales Header";
        Temp_SalesLine_Print: Record "Sales Line" temporary;
        Temp_SalesLine: Record "Sales Line" temporary;
        SalesPurchPerson: Record "Salesperson/Purchaser";
        ShipmentMethod: Record "Shipment Method";
        ShippingAgent: Record "Shipping Agent";
        Temp_VATAmountLine: Record "VAT Amount Line" temporary;
        PrintFunctions: Codeunit "AltAWPPrint Functions";
        ArchiveManagement: Codeunit ArchiveManagement;
        FormatAddr: Codeunit "Format Address";
        SalesCountPrinted: Codeunit "Sales-Printed";
        SegManagement: Codeunit SegManagement;
        awpCommentsManagement: Codeunit "AltAWPComments Management";
        PrintItemCrossRefOpt: Option "Customer Default",Yes,No;
        ShowTariffNoOpt: Option "Customer Default",Yes,No;
        ShowTrackingInfoOpt: Option "Customer Default",None,Standard,Extended;
        ArchiveDocument: Boolean;
        ArchiveDocumentEnable: Boolean;
        ConaiHide: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        LogInteractionEnable: Boolean;
        MoreLines: Boolean;
        Print: Boolean;
        PrintDesignCardExternalRef: Boolean;
        PrintTotals: Boolean;
        IsNewLine: Boolean;
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
        VATDiscountAmount: Decimal;
        GroupLineIndex: Integer;
        Ind: Integer;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        LayoutType: Enum "AltAWPDocument Default Layout";
        BankDescr: Text;
        CIGCUPText: Text;
        Salesperson_Code_Name: Text;
        CompanyOfficeAddress: array[5] of Text;
        ComposedDiscount: Text;
        CreditBankAccount: Text;
        FreightTypeTxt: Text;
        HeaderInformationArray: array[10] of Text;
        OrderRef: Text;
        PaymentArray: array[6] of Text;
        PayMethDescr: Text;
        PayTermDescr: Text;
        ShipMethDescr: Text;
        ItemReferenceNo: Text;
        SSCCInfo: Text;
        TrackingInfoLine: Text;
        CountryOrigin: Text;
        TariffNo: Text;
        Text001: Text;
        EuroTxt: Text[3];
        CurrencyDescr: Text[30];
        CompanyAddr: array[8] of Text[50];
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        VATDescrArray: array[6] of Text[50];
        OldDimText: Text[75];
        ConaiText: Text[100];
        DimText: Text[120];
        HeaderCommentText: Text;
        LastHeaderInformationArrayText: Text;
        lblBillToCustomer: Label 'Addressee ';
        lblChange: Label 'Change';
        lblCIGNo: Label 'CIG: ';
        lblCode: Label 'Code';
        lblConai: Label 'Contributo conai - polieco assolti ove dovuti';
        lblCreditBankAccount: Label 'Credit Bank Account';
        lblCUPNo: Label 'CUP: ';
        lblCurrency: Label 'Currency';
        lblCustomerNo: Label 'Customer';
        lblDeadlinesAmount: Label '%1) %2 %3 at %4';
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
        lblInvoiceDisc: Label 'Document discount amount';
        lblInvoiceDiscPerc: Label 'Document discount %';
        lblLineAmt: Label 'Amount';
        lblNetToPay: Label 'Net to Pay';
        lblNote: Label 'Note';
        lblPageNo: Label 'Page';
        lblPaymentTerms: Label 'Payment terms';
        lblPayMeth: Label 'Payment Method';
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
        lblShipTo: Label 'Consignee ';
        lblTariffNo: Label 'H.S. Code : %1';
        lblText001: Label 'Documento non valido ai fini fiscali (ai sensi dell’art. 21 Dpr 633/72), salvo per i soggetti non titolari di Partita Iva e/o non residenti per i quali costituisce copia analogica di fattura (art. 1. co. 909 L. 205/2017). La e-fattura è disponibile all’indirizzo telematico da Lei fornito oppure nella Sua area riservata dell’Agenzia delle Entrate.';
        lblTextWord01: Label 'Dear';
        lblTextWord02: Label 'attached sale credit memo test';
        lblTitle: Label 'CREDIT MEMO TEST';
        lblTotal: Label 'TOTAL';
        lblTotalAmt: Label 'Total taxable amount';
        lblTotalAmtForDisc: Label 'Discountable taxable amount';
        lblTotalDocument: Label 'Total document';
        lblTotGrossWeight: Label 'Gross weight';
        lblTotNetWeight: Label 'Net weight';
        lblTotalParcels: Label 'Total parcels';
        lblTotalGift: Label 'Value of gifts';
        lblQuantityUMC: Label 'Q.ty UMC';
        lblUMC: Label 'UMC';
        lblUMCPrice: Label 'Price UMC';
        lblItemRefrenceNo: Label 'Item ref. no. : %1';
        lblExpirationDate: Label 'Expiration date: %1';
        lblLotNo: Label ' Lot No.: %1';
        lblLotQty: Label ' Qty: %1';
        lblUM: Label 'UM';
        lblUnitPrice: Label 'Unit price';
        lblVariant: Label 'Item variant';
        lblVAT: Label 'VAT';
        lblVATAmount: Label 'VAT amount';
        lblVATAmount2: Label 'VAT Amount';
        lblVATBaseAmt: Label 'Taxable amount';
        lblVATCode: Label 'Code';
        lblVATDescription: Label 'Description';
        lblVatRegFiscalCode: Label 'Tax Code No.';
        lblVatRegNo: Label 'VAT reg. no.';
        lblVATTaxable: Label 'VAT Base Amuont';
        lblVATTotalAmount: Label 'VAT total';
        lblVATTotalBaseAmount: Label 'Tax amount';
        lblYourRef: Label 'Your Reference';
        lblOrigin: Label 'Origin: ';
        lblSSCC: Label 'SSCC: ';
        Txt001: Label '%1 - %2 %3 (%4)';
        Text002: Label '%1 %2', Locked = true;
        Text003: Label '%1 %2 %3', Locked = true;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesHeaderOnAfterGetRecord(pSalesCrMemoHeader: Record "Sales Header"; var pLastHeaderInformationArrayText: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAssignPaymentArrayValue(var pPaymentLines: Record "Payment Lines"; var pPaymentArray: Text; pInd: Integer; var pIsHandled: Boolean)
    begin
    end;
}