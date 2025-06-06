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
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Sales.Posting;
using Microsoft.Utilities;
using System.Utilities;

report 50013 "ecSales Quote"
{
    ApplicationArea = All;
    Caption = 'Sales Quote';
    DefaultLayout = RDLC;
    Description = 'GAP_VEN_001';
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    RDLCLayout = '.\src\EuroCompany\BaseApp\Sales\Reports\SalesQuote.Layout.rdlc';
    UsageCategory = None;
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.")
                                where("Document Type" = const(Quote));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed", Status;
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
            column(Company_WatermarkLogo; GeneralSetup."Not Released Doc. Watermark")
            {
            }
            column(CreditBankAccount; CreditBankAccount)
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
            column(DocRevNo; DocRevNo)
            {
            }
            column(DocumentDate; Format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(QuoteValidUntilDate; Format(SalesHeader."Quote Valid Until Date", 0, '<Day,2>/<Month,2>/<Year4>'))
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
            column(FreightType; "AltAWPFreight Type")
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
            column(IsNonBinding; IsNonBinding)
            {
            }
            column(lblAcceptance; lblAcceptance)
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
            column(lblDiscount2; lblDiscount2)
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
            column(lblDocumentTotal; lblDocumentTotal)
            {
            }
            column(lblDocumentType; lblDocumentType)
            {
            }
            column(lblExpirationDate; lblExpirationDate)
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
            column(lblPaymentMeth; lblPaymentMeth)
            {
            }
            column(lblPaymentTerms; lblPaymentTerms)
            {
            }
            column(lblPhone; lblPhone)
            {
            }
            column(lblProject; lblProject)
            {
            }
            column(lblQuantity; lblQuantity)
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
            column(lblShipmentDate; lblShipmentDate)
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
            column(lblSignature; lblSignature)
            {
            }
            column(lblSpecialPaymentConditions; lblSpecialPaymentConditions)
            {
            }
            column(lblTextWord01; lblTextWord01)
            {
            }
            column(lblTextWord02; lblTextWord02)
            {
            }
            column(lblTotalAmt; lblTotalAmt)
            {
            }
            column(lblTotalAmtForDisc; lblTotalAmtForDisc)
            {
            }
            column(lblTotalGifts; lblTotalGifts)
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
            column(lblVatAmount2; lblVatAmount2)
            {
            }
            column(lblVATBaseAmount; lblVATBaseAmount)
            {
            }
            column(lblVatBaseAmount2; lblVatBaseAmount2)
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
            column(lblVATTotalAmount; lblVATTotalAmount)
            {
            }
            column(lblVATTotalBaseAmount; lblVATTotalBaseAmount)
            {
            }
            column(lblYourRef; lblYourRef)
            {
            }
            column(PayMethDescr; PayMethDescr)
            {
            }
            column(PayTermDescr; PayTermDescr)
            {
            }
            column(PrintDocumentType; PrintDocumentType)
            {
            }
            column(PrintTotals; PrintTotals)
            {
            }
            column(SalespersonCode; Salesperson_Code_Name)
            {
            }
            column(SellToCustomerName; SalesHeader."Sell-to Customer Name")
            {
            }
            column(SellToCustomerNo; SalesHeader."Sell-to Customer No.")
            {
            }
            column(ShipmentMethodDescription; ShipMethDescr)
            {
            }
            column(ShipmentText; ShipmentText)
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
            column(YourReference; "Your Reference")
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
                        column(LineComments; LineComments)
                        {
                        }
                        column(MultipleQtyText; MultipleQtyText)
                        {
                        }
                        column(SalePriceText; SalePriceText)
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
                        column(SalesLine_ShipmentDate; ShipmentDateText)
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
                        dataitem(PrintGroupTotal; Integer)
                        {
                            DataItemTableView = sorting(Number)
                                                order(ascending)
                                                where(Number = const(1));
                            column(GroupTotalDescr; GroupTotalDescr)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                GroupTotalDescr := Temp_SalesLine_Print.Description;
                                if (Temp_SalesLine_Print.Type <> Temp_SalesLine_Print.Type::" ") or (GroupTotalDescr = '') then begin
                                    GroupTotalDescr := lblGroupTotal;
                                end;
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
                                                                                          Report::"AltAWPSales Quote")
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

                            TariffNo := '';
                            if (Temp_SalesLine.Type = Temp_SalesLine.Type::Item) then begin
                                if ShowTariffNo then begin
                                    if Item.Get(Temp_SalesLine."No.") and (Item."Tariff No." <> '') then begin
                                        TariffNo := StrSubstNo(lblTariffNo, Item."Tariff No.");
                                    end;
                                end;

                                if PrintItemCrossRef then begin
                                    if (Temp_SalesLine_Print."Item Reference No." <> '') then begin
                                        Temp_SalesLine_Print."No." := Temp_SalesLine_Print."Item Reference No.";
                                    end;

                                end;
                            end;
                            if (Temp_SalesLine.Type = Temp_SalesLine.Type::" ") or
                               (Temp_SalesLine.Type = Temp_SalesLine.Type::"G/L Account")
                            then begin
                                Temp_SalesLine_Print."No." := '';
                            end;

                            DocumentGrossAmount += Temp_SalesLine."Line Amount";

                            ComposedDiscount := Format(Temp_SalesLine_Print."Line Discount %");
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
                            if Temp_SalesLine."AltAWPOrder No." <> '' then begin
                                if SalesOrder.Get(SalesOrder."Document Type"::Order, Temp_SalesLine."AltAWPOrder No.") then begin
                                    if SalesOrder."External Document No." <> '' then
                                        OrderRef := OrderRef + '\' + SalesOrder."External Document No.";
                                end;
                            end;

                            ShipmentDateText := Format(Temp_SalesLine_Print."Planned Shipment Date", 0, '<Day,2>/<Month,2>/<Year4>');
                        end;

                        trigger OnPostDataItem()
                        begin
                            Temp_SalesLine.DeleteAll();
                        end;

                        trigger OnPreDataItem()
                        begin
                            ComposedDiscount := '';

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
                        column(Temp_VATAmountLineInvDiscBaseAmt; Temp_VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = SalesHeader."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Temp_VATAmountLineLineAmount; Temp_VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = SalesHeader."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Temp_VATAmountLineVAT; Temp_VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(Temp_VATAmountLineVATAmount; Temp_VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = SalesHeader."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Temp_VATAmountLineVATBase; Temp_VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = SalesHeader."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Temp_VATAmountLineVATIdent; Temp_VATAmountLine."VAT Identifier")
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
                        column(VATDiscountAmount; VATDiscountAmount)
                        {
                        }

                        trigger OnAfterGetRecord()
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
                        end;

                        trigger OnPostDataItem()
                        begin
                            DocDataReset();
                        end;
                    }
                    dataitem(VATCounterLCY; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(Temp_VATAmountLineVAT1; Temp_VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(Temp_VATAmountLineVATIdent1; Temp_VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
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
            begin

                if not Customer.Get(SalesHeader."Sell-to Customer No.") then Clear(Customer);

                Clear(GeneralSetup."Not Released Doc. Watermark");
                if GeneralSetup."Active Watermark Sale Doc." then begin
                    if (Status <> Status::Released)
                    then begin
                        GeneralSetup.CalcFields("Not Released Doc. Watermark");
                    end;
                end;

                Clear(LastHeaderInformationArrayText);
                OnBeforeSalesHeaderOnAfterGetRecord(SalesHeader, LastHeaderInformationArrayText);
                PrintFunctions.GetHeaderInformation(SalesHeader."AltAWPBranch Code",
                                                    SalesHeader."Location Code",
                                                    HeaderInformationArray,
                                                    LastHeaderInformationArrayText);

                if (("Bill-to Customer No." = '') or (not Cust.Get("Bill-to Customer No."))) and
                   (("Bill-to Contact No." = '') and (SalesHeader."Bill-to Customer Templ. Code" = ''))
                then begin
                    CurrReport.Skip();
                end;

                CurrReport.Language := PrintFunctions.GetReportLanguageCode("Language Code");
                CompanyInfo.CalcFields(Picture);
                GeneralSetup.CalcFields("Picture Footer Report");

                PrintDocumentType := lblTitle;
                if (DocumentType = DocumentType::"Pro Forma Invoice") then begin
                    PrintDocumentType := lblTitle2;
                end;

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

                DocRevNo := '';
                CalcFields("No. of Archived Versions");
                if ("No. of Archived Versions" > 0) then begin
                    DocRevNo := StrSubstNo(Txt005, "No. of Archived Versions");
                end;

                ShipmentText := lblShipmentDate;

                Clear(HeaderCommentText);
                HeaderCommentText := PrintFunctions.GetDocumentCommentHeader(SalesHeader, Report::"AltAWPSales Quote");
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
                    field(DocumentType_Field; DocumentType)
                    {
                        ApplicationArea = All;
                        Caption = 'Document Type', Comment = 'Tipo Documento';
                        OptionCaption = 'Offerta,Fattura Pro Forma';
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
                    field(ShowTariffNo_Field; ShowTariffNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Tariff No.', Comment = 'Mostra Nomenclatura Combinata';
                    }
                    field(PrintItemCrossRef_Field; PrintItemCrossRef)
                    {
                        ApplicationArea = All;
                        Caption = 'Item reference codes', Comment = 'Codici da Cross Reference';
                    }
                    field(LayoutType_Field; LayoutType)
                    {
                        ApplicationArea = All;
                        Caption = 'Layout Type', Comment = 'Tipo Layout';
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
            LogInteraction := SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Sales Qte.") <> '';

            LogInteractionEnable := LogInteraction;
            ArchiveDocumentEnable := ArchiveDocument;
            ArchiveDocument := false;
            LogInteraction := false;

            LayoutType := LayoutType::"Customer Default";

            PrintItemCrossRef := true;
            DocumentType := DocumentType::Quote;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        CompanyInfo.Get();
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

        TotalBaseAmount := 0;
        TotalDocAmount := 0;
        TotalVATAmount := 0;
        NetToPay := 0;

        DocumentGrossAmount := 0;
        TotalInvDiscAmt := 0;
        TotalInvDiscBaseAmt := 0;
        InvDiscPerc := 0;

        TotalEuroDocAmount := 0;
        EuroTxt := '';
    end;

    var
        SalesPurchPerson: Record "Salesperson/Purchaser";
        Customer: Record Customer;
        CurrExchRate: Record "Currency Exchange Rate";
        CompanyInfo: Record "Company Information";
        Currency: Record Currency;
        Cust: Record Customer;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";
        Item: Record Item;
        PaymentMethod: Record "Payment Method";
        PaymentTerms: Record "Payment Terms";
        RespCenter: Record "Responsibility Center";
        SalesOrder: Record "Sales Header";
        Temp_SalesLine_Print: Record "Sales Line" temporary;
        Temp_SalesLine: Record "Sales Line" temporary;
        ShipmentMethod: Record "Shipment Method";
        ShippingAgent: Record "Shipping Agent";
        Temp_VATAmountLine: Record "VAT Amount Line" temporary;
        GeneralSetup: Record "AltAWPGeneral Setup";
        SalesCountPrinted: Codeunit "Sales-Printed";
        ArchiveManagement: Codeunit ArchiveManagement;
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        PrintFunctions: Codeunit "AltAWPPrint Functions";
        awpCommentsManagement: Codeunit "AltAWPComments Management";
        LayoutType: Enum "AltAWPDocument Default Layout";
        DocumentType: Option Quote,"Pro Forma Invoice";
        BankDescr: Text;
        ComposedDiscount: Text;
        CreditBankAccount: Text;
        DocRevNo: Text;
        GroupTotalDescr: Text;
        Salesperson_Code_Name: Text;
        HeaderInformationArray: array[10] of Text;
        LineComments: Text;
        MultipleQtyText: Text;
        OrderRef: Text;
        PayMethDescr: Text;
        PayTermDescr: Text;
        PrintDocumentType: Text;
        SalePriceText: Text;
        ShipmentDateText: Text;
        ShipmentText: Text;
        ShipMethDescr: Text;
        SpecialPaymentConditions: Text;
        TariffNo: Text;
        EuroTxt: Text[3];
        CurrencyDescr: Text[30];
        CompanyAddr: array[8] of Text[50];
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        VATDescrArray: array[6] of Text[50];
        OldDimText: Text[75];
        DimText: Text[120];
        HeaderCommentText: Text;
        LastHeaderInformationArrayText: Text;
        ArchiveDocument: Boolean;
        ArchiveDocumentEnable: Boolean;
        Continue: Boolean;
        IsNonBinding: Boolean;
        LogInteraction: Boolean;
        LogInteractionEnable: Boolean;
        MoreLines: Boolean;
        Print: Boolean;
        PrintItemCrossRef: Boolean;
        PrintTotals: Boolean;
        ShowTariffNo: Boolean;
        VATCodeArray: array[6] of Code[20];
        AmountArray: array[10] of Decimal;
        BaseAmountArray: array[6] of Decimal;
        DocumentGrossAmount: Decimal;
        InvDiscPerc: Decimal;
        NetToPay: Decimal;
        TotalBaseAmount: Decimal;
        TotalDocAmount: Decimal;
        TotalEuroDocAmount: Decimal;
        TotalGifts: Decimal;
        TotalInvDiscAmt: Decimal;
        TotalInvDiscBaseAmt: Decimal;
        TotalVATAmount: Decimal;
        VALVATAmountLCY: Decimal;
        VALVATBaseLCY: Decimal;
        VATAmountArray: array[6] of Decimal;
        VATDiscountAmount: Decimal;
        GroupLineIndex: Integer;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        lblAcceptance: Label 'For acceptance';
        lblBillToCustomer: Label 'Addressee';
        lblChange: Label 'Change';
        lblCode: Label 'Code';
        lblCreditBankAccount: Label 'Credit Bank Account';
        lblCurrency: Label 'Currency';
        lblCustomerNo: Label 'Customer';
        lblDeliveryTerms: Label 'Delivery terms';
        lblDescription: Label 'Description';
        lblDiscount: Label 'Discount';
        lblDiscount2: Label '% Discount';
        lblDocType: Label 'Customer Quote Confirmation';
        lblDocumentDate: Label 'Document date';
        lblDocumentNo: Label 'Document No.';
        lblDocumentTotal: Label 'Document Total';
        lblDocumentType: Label 'Document type';
        lblExpirationDate: Label 'Expiration Date';
        lblExporterCode: Label 'Exporter code';
        lblFax: Label 'Fax';
        lblFiscalCode: Label 'Fiscal code';
        lblGroupTotal: Label 'SUBTOTAL';
        lblInvoiceDisc: Label 'Document discount amount';
        lblInvoiceDiscPerc: Label 'Document discount %';
        lblLineAmt: Label 'Amount';
        lblNetToPay: Label 'Net To Pay';
        lblNote: Label 'Note';
        lblOffice: Label 'Head Office';
        lblPageNo: Label 'Page';
        lblPaymentMeth: Label 'Payment method';
        lblPaymentTerms: Label 'Payment terms';
        lblPhone: Label 'Phone';
        lblProject: Label 'Project';
        lblQuantity: Label 'Q.ty';
        lblRegOffice: Label 'Registered Office';
        lblRev: Label 'Rev. 5';
        lblSaleCondition: Label 'Sale conditions on ';
        lblSalesperson: Label 'Salesperson';
        lblShipmentDate: Label 'Shipment Date';
        lblShipmentType: Label 'Shipment Type';
        lblShippingAgent: Label 'Carrier';
        lblShipTo: Label 'Consignee';
        lblSignature: Label 'Signature for acceptance';
        lblSpecialPaymentConditions: Label 'Special Payment Conditions';
        lblTariffNo: Label 'H.S. Code : %1';
        lblTextWord01: Label 'Dear';
        lblTextWord02: Label 'attached sale quote';
        lblTitle: Label 'Sale Quote';
        lblTitle2: Label 'Proforma Invoice';
        lblTotalAmt: Label 'Amount';
        lblTotalAmtForDisc: Label 'Amount to discount';
        lblTotalGifts: Label 'Total Gifts';
        lblUM: Label 'UM';
        lblUnitPrice: Label 'Unit price';
        lblVariant: Label 'Variant';
        lblVAT: Label 'VAT';
        lblVATAmount: Label 'Tax';
        lblVatAmount2: Label 'VAT Amount';
        lblVATBaseAmount: Label 'VAT Base Amuont';
        lblVatBaseAmount2: Label 'VAT Base Amount';
        lblVATBaseAmt: Label 'Amount';
        lblVATCode: Label 'Code';
        lblVATDescription: Label 'Description';
        lblVatRegFiscalCode: Label 'Tax Code No.';
        lblVatRegNo: Label 'VAT Number';
        lblVATTotalAmount: Label 'VAT total';
        lblVATTotalBaseAmount: Label 'Tax amount';
        lblYourRef: Label 'Your Reference';
        Txt005: Label 'R. %1';
        Text002: Label '%1 %2', Locked = true;
        Text003: Label '%1 %2 %3', Locked = true;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesHeaderOnAfterGetRecord(pSalesCrMemoHeader: Record "Sales Header"; var pLastHeaderInformationArrayText: Text)
    begin
    end;
}

