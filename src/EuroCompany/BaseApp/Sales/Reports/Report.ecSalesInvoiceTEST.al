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
using System.Utilities;

report 50015 "ecSales Invoice TEST"
{
    ApplicationArea = All;
    Caption = 'Sales Invoice TEST';
    DefaultLayout = RDLC;
    Description = 'GAP_VEN_001';
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    RDLCLayout = '.\src\EuroCompany\BaseApp\Sales\Reports\SalesInvoiceTEST.Layout.rdlc';
    UsageCategory = None;

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.")
                                where("Document Type" = const(Invoice), "AltAWPIs Shipping Invoice" = const(false));
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
            column(DocumentDate; Format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(DocumentNo; "No.")
            {
            }
            column(DocumentTitle; DocumentTitle)
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
            column(lblOffice; lblOffice)
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
            column(lblPrepmtAmt; lblPrepmtAmt)
            {
            }
            column(lblPrepmtDocList; lblPrepmtDocList)
            {
            }
            column(lblPrepmtTotAmt; lblPrepmtTotAmt)
            {
            }
            column(lblProject; lblProject)
            {
            }
            column(lblQta; lblQta)
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
            column(lblSpecialPaymentConditions; lblSpecialPaymentConditions)
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
            column(PrintDocumentType; PrintDocumentType)
            {
            }
            column(PrintPrepmtFooterInfo; PrintPrepmtFooterInfo)
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
            column(SpecialPaymentConditions; SpecialPaymentConditions)
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
                            DecimalPlaces = 0 : 2;
                        }
                        column(SalesLine_TariffNo; TariffNo)
                        {
                        }
                        column(SalesLine_TextRefCDep; TextRefCDep)
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
                                                                                          Report::"AltAWPSales Invoice TEST")
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
                            PrepmtAmtToDeduct += Temp_SalesLine."Prepmt Amt to Deduct";

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
                                if (Temp_SalesLine_Print."ecAttacch. Kit/Exhib. Line No." <> 0) then TotalParcels += Temp_SalesLine_Print.Quantity;
                            end;
                            TotalNetWeight += Temp_SalesLine_Print."AltAWPTotal Net Weight";
                            TotalGrossWeight += Temp_SalesLine_Print."AltAWPTotal Gross Weight";

                            IsNewLine := (not ExistsLinesAttachedAfter(Temp_SalesLine_Print)) and (not ExistsKitExhibitorLinesAttachedAfter(Temp_SalesLine_Print));
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
                        column(PrepmtAmtToDeduct; PrepmtAmtToDeduct)
                        {
                        }
                        column(PrepmtDocList; PrepmtDocList)
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
                                                                        Format(PaymentLines."Due Date", 0, '<Day,2>/<Month,2>/<Year4>'))
                                    end;
                                until (PaymentLines.Next() = 0) or (Ind = ArrayLen(PaymentsAmountArray));
                            end;
                        end;

                        trigger OnPostDataItem()
                        begin
                            DocDataReset();
                        end;

                        trigger OnPreDataItem()
                        begin
                            GetPrepmtDocList();
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

                if GeneralSetup."Active Watermark Sale Doc." then begin
                    Clear(GeneralSetup."Not Released Doc. Watermark");
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

                FreightTypeTxt := Format("AltAWPFreight Type");
                if not "AltAWPIs Shipping Invoice" then begin
                    FreightTypeTxt := '';
                    ShipMethDescr := '';
                end;

                Clear(HeaderCommentText);
                HeaderCommentText := PrintFunctions.GetDocumentCommentHeader(SalesHeader, Report::"ecSales Invoice TEST");

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

                DocumentTitle := lblTitle;
                PrintPrepmtFooterInfo := true;
                if (PrintDocumentType = PrintDocumentType::"Pro-Forma Invoice") then begin
                    DocumentTitle := lblTitle2;
                    PrintPrepmtFooterInfo := false;
                end;

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

                    field(PrintDocumentType_Field; PrintDocumentType)
                    {
                        ApplicationArea = All;
                        Caption = 'Document Type', Comment = 'Tipo documento';
                        Editable = DocumentTypeEdit;
                        OptionCaption = 'Fattura Test,Fattura Pro-Forma';
                    }
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
        var
            latsSessionDataStore: Codeunit "AltATSSession Data Store";
            lDocumentTypeNumericValue: Decimal;
        begin
            LogInteractionEnable := true;
            ArchiveDocumentEnable := true;

            ArchiveDocument := ArchiveManagement.SalesDocArchiveGranule();
            LogInteraction := SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Sales Inv.") <> '';

            ArchiveDocumentEnable := ArchiveDocument;
            LogInteractionEnable := LogInteraction;
            ArchiveDocument := false;
            LogInteraction := false;

            LayoutType := LayoutType::"Customer Default";
            ConaiHide := false;

            DocumentTypeEdit := true;
            if latsSessionDataStore.ExistsSessionSetting('AWPSalesOrderREp_SetPrintDocType') then begin
                lDocumentTypeNumericValue := latsSessionDataStore.GetSessionSettingNumericValue('AWPSalesOrderREp_SetPrintDocType');
                latsSessionDataStore.RemoveSessionSetting('AWPSalesOrderREp_SetPrintDocType');
                if (lDocumentTypeNumericValue <> 0) then begin
                    PrintDocumentType := lDocumentTypeNumericValue;
                    DocumentTypeEdit := false;
                end;
            end;
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

        PrepmtAmtToDeduct := 0;

        DocumentGrossAmount := 0;
        TotalInvDiscAmt := 0;
        TotalInvDiscBaseAmt := 0;
        InvDiscPerc := 0;

        TotalEuroDocAmount := 0;
        EuroTxt := '';
    end;

    procedure GetPrepmtDocList()
    var
        Temp_lEntrySummary: Record "Entry Summary" temporary;
        lSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        lSalesInvoiceHeader: Record "Sales Invoice Header";
        lSalesLine: Record "Sales Line";
        lEntryNo: Integer;
        lTxt001: Label 'Invoice %1 dated %2';
        lTxt002: Label 'Credit memo %1 dated %2';
        lTxtSep: Label ' | ';
    begin
        Temp_lEntrySummary.Reset();
        Temp_lEntrySummary.DeleteAll();

        Clear(PrepmtDocList);
        if (PrepmtAmtToDeduct > 0) then begin
            lSalesInvoiceHeader.Reset();
            lSalesInvoiceHeader.SetCurrentKey("Prepayment Order No.");
            lSalesCrMemoHeader.Reset();
            lSalesCrMemoHeader.SetCurrentKey("Prepayment Order No.");

            lSalesLine.Reset();
            lSalesLine.SetRange("Document Type", SalesHeader."Document Type");
            lSalesLine.SetRange("Document No.", SalesHeader."No.");
            lSalesLine.SetFilter(Type, '>%1', lSalesLine.Type::" ");
            if lSalesLine.FindFirst() then begin
                lSalesInvoiceHeader.SetRange("Prepayment Order No.", lSalesLine."AltAWPOrder No.");
                if lSalesInvoiceHeader.FindSet() then begin
                    repeat
                        lEntryNo += 1;
                        Clear(Temp_lEntrySummary);
                        Temp_lEntrySummary."Entry No." := lEntryNo;
                        Temp_lEntrySummary."Serial No." := lSalesInvoiceHeader."No.";
                        Temp_lEntrySummary."Expiration Date" := lSalesInvoiceHeader."Posting Date";
                        Temp_lEntrySummary."Source Subtype" := 0;
                        Temp_lEntrySummary.Insert();
                    until (lSalesInvoiceHeader.Next() = 0);
                end;
                lSalesCrMemoHeader.SetRange("Prepayment Order No.", lSalesLine."AltAWPOrder No.");
                if lSalesCrMemoHeader.FindSet() then begin
                    repeat
                        lEntryNo += 1;
                        Clear(Temp_lEntrySummary);
                        Temp_lEntrySummary."Entry No." := lEntryNo;
                        Temp_lEntrySummary."Serial No." := lSalesCrMemoHeader."No.";
                        Temp_lEntrySummary."Expiration Date" := lSalesCrMemoHeader."Posting Date";
                        Temp_lEntrySummary."Source Subtype" := 1;
                        Temp_lEntrySummary.Insert();
                    until (lSalesCrMemoHeader.Next() = 0);
                end;
            end;

            Temp_lEntrySummary.Reset();
            Temp_lEntrySummary.SetCurrentKey("Expiration Date");
            if Temp_lEntrySummary.FindSet() then begin
                repeat
                    case Temp_lEntrySummary."Source Subtype" of
                        0:
                            begin  // Fattura
                                if (PrepmtDocList <> '') then PrepmtDocList := PrepmtDocList + lTxtSep;
                                PrepmtDocList := PrepmtDocList + StrSubstNo(lTxt001, Temp_lEntrySummary."Serial No.", Temp_lEntrySummary."Expiration Date");
                            end;

                        1:
                            begin  // Nota credito
                                if (PrepmtDocList <> '') then PrepmtDocList := PrepmtDocList + lTxtSep;
                                PrepmtDocList := PrepmtDocList + StrSubstNo(lTxt002, Temp_lEntrySummary."Serial No.", Temp_lEntrySummary."Expiration Date");
                            end;
                    end;
                until (Temp_lEntrySummary.Next() = 0);
            end;
        end;
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

    local procedure ExistsKitExhibitorLinesAttachedAfter(var pSalesLine: Record "Sales Line"): Boolean
    var
        lSalesLine2: Record "Sales Line";
    begin
        if (pSalesLine."ecAttacch. Kit/Exhib. Line No." = 0) then begin
            Clear(lSalesLine2);
            lSalesLine2.SetRange("Document Type", pSalesLine."Document Type");
            lSalesLine2.SetRange("Document No.", pSalesLine."Document No.");
            lSalesLine2.SetFilter("Line No.", '>%1', pSalesLine."Line No.");
            lSalesLine2.SetRange("ecAttacch. Kit/Exhib. Line No.", pSalesLine."Line No.");
            if not lSalesLine2.IsEmpty then begin
                exit(true);
            end else begin
                exit(false);
            end;
        end else begin
            Clear(lSalesLine2);
            lSalesLine2.SetRange("Document Type", pSalesLine."Document Type");
            lSalesLine2.SetRange("Document No.", pSalesLine."Document No.");
            lSalesLine2.SetFilter("Line No.", '>%1', pSalesLine."Line No.");
            lSalesLine2.SetRange("ecAttacch. Kit/Exhib. Line No.", pSalesLine."ecAttacch. Kit/Exhib. Line No.");
            if not lSalesLine2.IsEmpty then begin
                exit(true);
            end else begin
                exit(false);
            end;
        end;
    end;

    var
        PaymentMethod: Record "Payment Method";
        PaymentTerms: Record "Payment Terms";
        ShipmentMethod: Record "Shipment Method";
        ShippingAgent: Record "Shipping Agent";
        GLSetup: Record "General Ledger Setup";
        Temp_SalesLine: Record "Sales Line" temporary;
        Temp_SalesLine_Print: Record "Sales Line" temporary;
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        Temp_VATAmountLine: Record "VAT Amount Line" temporary;
        RespCenter: Record "Responsibility Center";
        CurrExchRate: Record "Currency Exchange Rate";
        Cust: Record Customer;
        Currency: Record Currency;
        PaymentLines: Record "Payment Lines";
        Item: Record Item;
        GeneralSetup: Record "AltAWPGeneral Setup";
        Customer: Record Customer;
        SegManagement: Codeunit SegManagement;
        SalesCountPrinted: Codeunit "Sales-Printed";
        FormatAddr: Codeunit "Format Address";
        ArchiveManagement: Codeunit ArchiveManagement;
        PrintFunctions: Codeunit "AltAWPPrint Functions";
        awpCommentsManagement: Codeunit "AltAWPComments Management";
        LayoutType: Enum "AltAWPDocument Default Layout";
        PrintItemCrossRefOpt: Option "Customer Default",Yes,No;
        ShowTariffNoOpt: Option "Customer Default",Yes,No;
        NoOfLoops: Integer;
        OutputNo: Integer;
        NoOfCopies: Integer;
        Ind: Integer;
        GroupLineIndex: Integer;
        VATDiscountAmount: Decimal;
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
        InvDiscPerc: Decimal;
        TotalEuroDocAmount: Decimal;
        TotalParcels: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        PaymentsAmountArray: array[10] of Decimal;
        PrepmtAmtToDeduct: Decimal;
        TotalGifts: Decimal;
        NetToPay: Decimal;
        VATCodeArray: array[6] of Code[20];
        ComposedDiscount: Text;
        EuroTxt: Text[3];
        VATDescrArray: array[6] of Text[50];
        HeaderInformationArray: array[10] of Text;
        CompanyOfficeAddress: array[5] of Text;
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
        TariffNo: Text;
        PrepmtDocList: Text;
        DocumentTitle: Text;
        CreditBankAccount: Text;
        PaymentArray: array[6] of Text;
        PayTermDescr: Text;
        Text001: Text;
        SpecialPaymentConditions: Text;
        CIGCUPText: Text;
        FreightTypeTxt: Text;
        PaymentsDateArray: array[10] of Date;
        HeaderCommentText: Text;
        LastHeaderInformationArrayText: Text;
        MoreLines: Boolean;
        LogInteractionEnable: Boolean;
        Continue: Boolean;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        Print: Boolean;
        IsNewLine: Boolean;
        DocumentTypeEdit: Boolean;
        ArchiveDocumentEnable: Boolean;
        PrintDesignCardExternalRef: Boolean;
        ConaiHide: Boolean;
        PrintPrepmtFooterInfo: Boolean;
        TextRefCDep: Label 'Returns on consignment';
        lblOffice: Label 'Head Office';
        lblPhone: Label 'Phone';
        lblFax: Label 'Fax';
        lblRegOffice: Label 'Registered Office';
        lblVatRegFiscalCode: Label 'C.F./P.IVA';
        lblExporterCode: Label 'Exporter code';
        lblBillToCustomer: Label 'Addressee';
        lblShipTo: Label 'Consignee';
        lblTitle: Label 'Test Invoice';
        lblTitle2: Label 'Proforma Invoice';
        lblDocumentType: Label 'Document type';
        lblDocumentNo: Label 'Document No.';
        lblDocumentDate: Label 'Document date';
        lblPageNo: Label 'Page';
        lblCustomerNo: Label 'Customer';
        lblVatRegNo: Label 'VAT reg. no.';
        lblFiscalCode: Label 'Fiscal code';
        lblNote: Label 'Note';
        lblPaymentTerms: Label 'Payment terms';
        lblPaymentMethod: Label 'Payment Method';
        lblYourRef: Label 'Your Reference';
        lblProject: Label 'Project';
        lblCurrency: Label 'Currency';
        lblChange: Label 'Change';
        lblShippingAgent: Label 'Carrier';
        lblDeliveryTerms: Label 'Delivery terms';
        lblCode: Label 'Code';
        lblDescription: Label 'Description';
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
        lblVATDescription: Label 'Description';
        lblVATBaseAmt: Label 'Taxable amount';
        lblVATAmount: Label 'Tax';
        PrintTotals: Boolean;
        lblRev: Label 'Rev. 5';
        lblTotGrossWeight: Label 'Gross weight';
        lblTotNetWeight: Label 'Net weight';
        lblTotalParcels: Label 'Total parcels';
        lblPmtExpiry: Label 'Expiry and amount';
        lblQuoteRef: Label 'Reference offer';
        lblTariffNo: Label 'H.S. Code : %1';
        lblPrepmtAmt: Label 'Prepayment amount to deduct';
        lblPrepmtTotAmt: Label 'Total document amount';
        lblPrepmtDocList: Label 'Prepayment documents';
        PrintDocumentType: Option "Invoice Test","Pro-Forma Invoice";
        lblCreditBankAccount: Label 'Credit Bank Account';
        lblSalesperson: Label 'Salesperson';
        lblShipmentType: Label 'Shipment Type';
        lblVariant: Label 'Item variant';
        lblVATTaxable: Label 'VAT Base Amuont';
        lblVATAmount2: Label 'VAT amount';
        lblTotalDocument: Label 'Total document';
        lblTotalGift: Label 'Value of gifts';
        lblNetToPay: Label 'Net to Pay';
        lblTextWord01: Label 'Dear';
        lblTextWord02: Label 'attached sale invoice test';
        lblDeadlinesAmount: Label '%1) %2 %3 at %4';
        lblSaleCondition: Label 'Sale conditions on ';
        lblConai: Label 'Contributo conai - polieco assolti ove dovuti';
        lblTotal: Label 'TOTAL';
        lblText001: Label 'Documento non valido ai fini fiscali (ai sensi dell’art. 21 Dpr 633/72), salvo per i soggetti non titolari di Partita Iva e/o non residenti per i quali costituisce copia analogica di fattura (art. 1. co. 909 L. 205/2017). La e-fattura è disponibile all’indirizzo telematico da Lei fornito oppure nella Sua area riservata dell’Agenzia delle Entrate.';
        lblCIGNo: Label 'CIG: ';
        lblCUPNo: Label 'CUP: ';
        lblQta: Label 'Qtà';
        lblQuantityUMC: Label 'Q.ty UMC';
        lblUMC: Label 'UMC';
        lblUMCPrice: Label 'Price UMC';
        lblItemRefrenceNo: Label 'Item ref. no. : %1';
        lblSpecialPaymentConditions: Label 'Special Payment Conditions';
        Txt001: Label '%1 - %2 %3 (%4)', Locked = true;
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

