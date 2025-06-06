namespace EuroCompany.BaseApp.Purchases.Reports;

using EuroCompany.BaseApp.Purchases.Document;
using Microsoft.Bank.BankAccount;
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
using Microsoft.Manufacturing.Routing;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Posting;
using Microsoft.Purchases.Vendor;
using Microsoft.Utilities;
using System.Utilities;

report 50007 "ecPurchases Order"
{
    ApplicationArea = All;
    Caption = 'Purchase Order';
    DefaultLayout = RDLC;
    Description = 'GAP_ACQ_002';
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    RDLCLayout = './src/EuroCompany/BaseApp/Purchases/Reports/PurchasesOrder.Layout.rdlc';
    UsageCategory = None;
    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed", Status;
            column(AdditionalNotes; "Additional Notes")
            {
            }
            column(BuyFromVendorName; "Buy-from Vendor Name")
            {
            }
            column(BuyFromVendorNo; "Buy-from Vendor No.")
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
            column(DocRevNo; DocRevNo)
            {
            }
            column(DocumentDate; Format(DateValue, 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(DocumentNo; "No.")
            {
            }
            column(DocumentType; "Document Type")
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
            column(lblChange; lblChange)
            {
            }
            column(lblCode; lblCode)
            {
            }
            column(lblCreditBankAccount; lblCreditBankAccount)
            {
            }
            column(lblCrossRefNo; lblCrossRefNo)
            {
            }
            column(lblCurrency; lblCurrency)
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
            column(lblDocumentDate; DateText)
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
            column(lblPaymentMeth; lblPaymentMeth)
            {
            }
            column(lblPaymentTerms; lblPaymentTerms)
            {
            }
            column(lblPayToVendor; lblPayToVendor)
            {
            }
            column(lblPhone; lblPhone)
            {
            }
            column(lblPmtExpiry; lblPmtExpiry)
            {
            }
            column(lblPurchaserCode; lblPurchaserCode)
            {
            }
            column(lblQuantity; lblQuantity)
            {
            }
            column(lblReceiptDate; lblReceiptDate)
            {
            }
            column(lblRev; lblRev)
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
            column(lblTextWord01; lblTextWord01)
            {
            }
            column(lblTextWord02; lblTextWord02)
            {
            }
            column(lblTitle; Title)
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
            column(lblVendorNo; lblVendorNo)
            {
            }
            column(lblYourRef; lblYourRef)
            {
            }
            column(PaymentTermsDescription; PayMethDescr)
            {
            }
            column(PayTermDescr; PayTermDescr)
            {
            }
            column(PayToVendorNo; "Pay-to Vendor No.")
            {
            }
            column(PurchaserCode; SalesPurchPerson.Name)
            {
            }
            column(RequesteddReceiptDate; Format("Requested Receipt Date"))
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
            column(Status; StatusNumber)
            {
            }
            column(Vendor_Addr1; VendorAddr[1])
            {
            }
            column(Vendor_Addr2; VendorAddr[2])
            {
            }
            column(Vendor_Addr3; VendorAddr[3])
            {
            }
            column(Vendor_Addr4; VendorAddr[4])
            {
            }
            column(Vendor_Addr5; VendorAddr[5])
            {
            }
            column(Vendor_Addr6; VendorAddr[6])
            {
            }
            column(Vendor_Addr7; VendorAddr[7])
            {
            }
            column(Vendor_Addr8; VendorAddr[8])
            {
            }
            column(Vendor_FiscalCode; Vendor."Fiscal Code")
            {
            }
            column(Vendor_PhoneNo; Vendor."Phone No.")
            {
            }
            column(Vendor_VatRegNo; PrintFunctions.PrintVatRegistrationNo(Vendor."VAT Registration No.", Vendor."Country/Region Code"))
            {
            }
            column(YourReference; "Your Reference")
            {
            }
            column(FooterNotes; FooterNotes)
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
                        DataItemLinkReference = PurchaseHeader;
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
                    dataitem(PurchaseLine; "Purchase Line")
                    {
                        DataItemLink = "Document Type" = field("Document Type"),
                                       "Document No." = field("No.");
                        DataItemLinkReference = PurchaseHeader;
                        DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                        trigger OnPreDataItem()
                        begin
                            Clear(CompanyInfo.Picture);
                            Clear(GeneralSetup."Picture Footer Report");
                            CurrReport.Break();
                        end;
                    }
                    dataitem(RoundLoop; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(BlanketOrderNoText; BlanketOrderNoText)
                        {
                        }
                        column(IsRoutingInstructionLine; IsRoutingInstructionLine)
                        {
                        }
                        column(LineComments; LineComments)
                        {
                        }
                        column(PurchaseLine_ComposedDiscount; ComposedDiscount)
                        {
                        }
                        column(PurchaseLine_Description; PurchaseLine.Description)
                        {
                        }
                        column(PurchaseLine_Description2; PurchaseLine."Description 2")
                        {
                        }
                        column(PurchaseLine_ExpectedReceiptDate; Format(ReceiptDate, 0, '<Day,2>/<Month,2>/<Year4>'))
                        {
                        }
                        column(PurchaseLine_ItemCrossRefNo; ItemCrossRefNo)
                        {
                        }
                        column(PurchaseLine_LineAmount; PurchaseLine."Line Amount")
                        {
                            AutoFormatExpression = PurchaseLine."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PurchaseLine_LineNo; PurchaseLine."Line No.")
                        {
                        }
                        column(PurchaseLine_No; PurchaseLine."No.")
                        {
                        }
                        column(PurchaseLine_Quantity; PurchaseLine.Quantity)
                        {
                        }
                        column(PurchaseLine_RequestedReceiptDate; Format(PurchaseLine."Requested Receipt Date", 0, '<Day,2>/<Month,2>/<Year4>'))
                        {
                        }
                        column(PurchaseLine_Type; PurchaseLine.Type.AsInteger())
                        {
                        }
                        column(PurchaseLine_UM; PurchaseLine."Unit of Measure Code")
                        {
                        }
                        column(PurchaseLine_UnitPrice; PurchaseLine."Direct Unit Cost")
                        {
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(PurchaseLine_VariantCode; PurchaseLine."Variant Code")
                        {
                        }
                        column(PurchaseLine_VATIdentifier; PurchaseLine."VAT Identifier")
                        {
                        }
                        column(PurchasePriceText; PurchasePriceText)
                        {
                        }
                        column(RoutingInstructionDescription; RoutingInstructionDescription)
                        {
                        }
                        column(TaskText; TaskText)
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

                                DimSetEntry2.SetRange("Dimension Set ID", PurchaseLine."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            lAWPPrintFunctions: Codeunit "AltAWPPrint Functions";
                            lRecordVariant: Variant;
                        begin
                            if Number = 1 then
                                Temp_PurchaseLine.Find('-')
                            else
                                Temp_PurchaseLine.Next();

                            PurchaseLine := Temp_PurchaseLine;

                            ReceiptDate := PurchaseLine."Requested Receipt Date";
                            if (ReceiptDate = 0D) then begin
                                ReceiptDate := PurchaseLine."Planned Receipt Date";
                            end;

                            //AWP091-VI-s
                            if (Temp_PurchaseLine.Type = Temp_PurchaseLine.Type::" ") and
                               (Temp_PurchaseLine."AltAWPComment Reason Code" <> '')
                            then begin
                                if not awpCommentsManagement.IsValidCommentReasonByReport(Temp_PurchaseLine."AltAWPComment Reason Code",
                                                                                          Report::"ecPurchases Order")
                                then begin
                                    CurrReport.Skip();
                                end;
                            end;
                            //AWP091-VI-e

                            if not PurchaseHeader."Prices Including VAT" and
                               (PurchaseLine."VAT Calculation Type" = PurchaseLine."VAT Calculation Type"::"Full VAT")
                            then begin
                                PurchaseLine."Line Amount" := 0;
                            end;

                            if (PurchaseLine.Type = PurchaseLine.Type::Item) then begin
                                Item.Get(PurchaseLine."No.");

                                if PrintItemCrossRef and (PurchaseLine."Item Reference No." <> '') then begin
                                    PurchaseLine."No." := PurchaseLine."Item Reference No.";
                                end;

                                if PrintItemCrossRef and (PurchaseLine."Item Reference No." = '') then begin
                                    if (Item."Vendor No." = PurchaseHeader."Buy-from Vendor No.") and (Item."Vendor Item No." <> '') then begin
                                        PurchaseLine."No." := Item."Vendor Item No.";
                                    end;
                                end;
                            end;

                            if (PurchaseLine.Type = PurchaseLine.Type::" ") or
                               (PurchaseLine.Type = PurchaseLine.Type::"G/L Account")
                            then begin
                                PurchaseLine."No." := '';
                            end;

                            DocumentGrossAmount += PurchaseLine."Line Amount";
                            ComposedDiscount := Format(PurchaseLine."Line Discount %");
                            if (PurchaseLine."Line Discount %" = 0) then ComposedDiscount := '';
                            lRecordVariant := PurchaseLine;
                            lAWPPrintFunctions.ManageComposedDiscountValue(lRecordVariant, ComposedDiscount);

                            Clear(BlanketOrderNoText);
                            if (PurchaseLine."Blanket Order No." <> '') then begin
                                BlanketOrderNoText := PurchaseLine.FieldCaption("Blanket Order No.") + ': ' + PurchaseLine."Blanket Order No.";
                            end;

                            GetStandardTaskText(PurchaseLine);

                        end;

                        trigger OnPostDataItem()
                        begin
                            Temp_PurchaseLine.DeleteAll();
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(CompanyInfo.Picture);

                            Clear(GeneralSetup."Not Released Doc. Watermark");

                            MoreLines := Temp_PurchaseLine.Find('+');
                            while MoreLines and (Temp_PurchaseLine.Description = '') and (Temp_PurchaseLine."Description 2" = '') and
                                  (Temp_PurchaseLine."No." = '') and (Temp_PurchaseLine.Quantity = 0) and
                                  (Temp_PurchaseLine.Amount = 0)
                            do begin
                                MoreLines := Temp_PurchaseLine.Next(-1) <> 0;
                            end;

                            if not MoreLines then
                                CurrReport.Break();

                            Temp_PurchaseLine.SetRange("Line No.", 0, Temp_PurchaseLine."Line No.");
                            SetRange(Number, 1, Temp_PurchaseLine.Count);

                            ComposedDiscount := '';
                        end;
                    }
                    dataitem(VATCounter; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(VATAmountLineInvDiscBaseAmt; Temp_VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineLineAmount; Temp_VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT; Temp_VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmountLineVATAmount; Temp_VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVATBase; Temp_VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = PurchaseLine."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVATIdent; Temp_VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmtLineInvDiscAmt; Temp_VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = PurchaseHeader."Currency Code";
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
                            if (PurchaseHeader."Invoice Discount Calculation" = PurchaseHeader."Invoice Discount Calculation"::"%") then begin
                                InvDiscPerc := PurchaseHeader."Invoice Discount Value";
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
                        column(PaymentsDateArray1; Format(PaymentsDateArray[1]))
                        {
                        }
                        column(PaymentsDateArray2; Format(PaymentsDateArray[2]))
                        {
                        }
                        column(PaymentsDateArray3; Format(PaymentsDateArray[3]))
                        {
                        }
                        column(PaymentsDateArray4; Format(PaymentsDateArray[4]))
                        {
                        }
                        column(PaymentsDateArray5; Format(PaymentsDateArray[5]))
                        {
                        }
                        column(PaymentsDateArray6; Format(PaymentsDateArray[6]))
                        {
                        }
                        column(PaymentsDateArray7; Format(PaymentsDateArray[7]))
                        {
                        }
                        column(PaymentsDateArray8; Format(PaymentsDateArray[8]))
                        {
                        }
                        column(PaymentsDateArray9; Format(PaymentsDateArray[9]))
                        {
                        }
                        column(PaymentsDateArray10; Format(PaymentsDateArray[10]))
                        {
                        }
                        column(TotalBase; TotalBaseAmount)
                        {
                        }
                        column(TotalDocAmount; TotalDocAmount)
                        {
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalEuroDocAmount; TotalEuroDocAmount)
                        {
                            AutoFormatExpression = PurchaseHeader."Currency Code";
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

                            if (PurchaseHeader."Currency Code" <> '') and (false) //Nascosta la stampa dell'importo in Euro nel caso di valuta estera
                            then begin
                                Currency.Get(PurchaseHeader."Currency Code");
                                if PurchaseHeader."Currency Factor" <> 0 then
                                    TotalEuroDocAmount := Round(TotalDocAmount / PurchaseHeader."Currency Factor",
                                                                Currency."Amount Rounding Precision");
                                EuroTxt := 'EUR';
                            end else begin
                                Clear(Currency);
                                TotalEuroDocAmount := 0;
                                EuroTxt := '';
                            end;

                            Clear(PaymentsAmountArray);
                            Clear(PaymentsDateArray);
                            Ind := 0;

                            PaymentLines.Reset();
                            PaymentLines.SetRange("Sales/Purchase", PaymentLines."Sales/Purchase"::Purchase);
                            PaymentLines.SetRange(Type, PurchaseHeader."Document Type");
                            PaymentLines.SetRange(Code, PurchaseHeader."No.");
                            if not PaymentLines.IsEmpty then begin
                                PaymentLines.FindSet();
                                repeat
                                    Ind += 1;
                                    PaymentsAmountArray[Ind] := PaymentLines.Amount;
                                    PaymentsDateArray[Ind] := PaymentLines."Due Date";
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
                                               PurchaseHeader."Posting Date", PurchaseHeader."Currency Code",
                                               Temp_VATAmountLine."VAT Base", PurchaseHeader."Currency Factor"));
                            VALVATAmountLCY := Round(CurrExchRate.ExchangeAmtFCYToLCY(
                                                 PurchaseHeader."Posting Date", PurchaseHeader."Currency Code",
                                                 Temp_VATAmountLine."VAT Amount", PurchaseHeader."Currency Factor"));
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               (PurchaseHeader."Currency Code" = '') or
                               (Temp_VATAmountLine.GetTotalVATAmount() = 0) then
                                CurrReport.Break();

                            SetRange(Number, 1, Temp_VATAmountLine.Count);

                            CurrExchRate.FindCurrency(PurchaseHeader."Posting Date", PurchaseHeader."Currency Code", 1);
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    DocDataReset();

                    Clear(Temp_PurchaseLine);
                    Clear(PurchPost);
                    Temp_PurchaseLine.DeleteAll();
                    Temp_VATAmountLine.DeleteAll();
                    PurchPost.GetPurchLines(PurchaseHeader, Temp_PurchaseLine, 0);
                    Temp_PurchaseLine.CalcVATAmountLines(0, PurchaseHeader, Temp_PurchaseLine, Temp_VATAmountLine);
                    Temp_PurchaseLine.UpdateVATOnLines(0, PurchaseHeader, Temp_PurchaseLine, Temp_VATAmountLine);
                    VATDiscountAmount :=
                      Temp_VATAmountLine.GetTotalVATDiscount(PurchaseHeader."Currency Code", PurchaseHeader."Prices Including VAT");

                    if Number > 1 then begin
                        OutputNo += 1;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                        PurchCountPrinted.Run(PurchaseHeader);
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
                lVendorBankAccount: Record "Vendor Bank Account";
                lecIncotermsPlace: Record "ecIncoterms Place";
            begin
                Clear(LastHeaderInformationArrayText);
                OnBeforePurchaseHeaderOnAfterGetRecord(PurchaseHeader, LastHeaderInformationArrayText);
                PrintFunctions.GetHeaderInformation(PurchaseHeader."AltAWPBranch Code",
                                                    PurchaseHeader."Location Code",
                                                    HeaderInformationArray,
                                                    LastHeaderInformationArrayText);

                if ("Pay-to Vendor No." = '') or (not Vendor.Get("Pay-to Vendor No.")) then begin
                    CurrReport.Skip();
                end;

                CurrReport.Language := PrintFunctions.GetReportLanguageCode("Language Code");

                Title := lblTitle;
                DateText := lblOrderDate;
                DateValue := "Order Date";
                if ("Document Type" = "Document Type"::"Blanket Order") then begin
                    Title := lblTitle2;
                    DateText := lblDocumentDate;
                    DateValue := "Document Date";
                end else begin
                    CalcFields("Subcontracting Order");
                    if "Subcontracting Order" then Title := lblTitle3;
                end;

                VendorPhoneNo := Vendor."Phone No.";

                CompanyInfo.CalcFields(Picture);
                GeneralSetup.CalcFields("Picture Footer Report");

                StatusNumber := Status.AsInteger();

                if GeneralSetup."Active Watermark Purc. Doc." then begin
                    Clear(GeneralSetup."Not Released Doc. Watermark");
                    if (Status <> Status::Released) then begin
                        GeneralSetup.CalcFields("Not Released Doc. Watermark");
                    end;
                end;

                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else begin
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                end;

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                if not SalesPurchPerson.Get("Purchaser Code") then Clear(SalesPurchPerson);

                if ("Currency Code" = '') then begin
                    GLSetup.TestField("LCY Code");
                    CurrencyDescr := GLSetup."LCY Code";
                end else begin
                    CurrencyDescr := "Currency Code";
                end;

                FormatAddr.PurchHeaderPayTo(VendorAddr, PurchaseHeader);
                FormatAddr.PurchHeaderShipTo(ShipToAddr, PurchaseHeader);

                if not CurrReport.Preview then begin
                    if ArchiveDocument then
                        ArchiveManagement.StorePurchDocument(PurchaseHeader, LogInteraction);

                    if LogInteraction then begin
                        CalcFields("No. of Archived Versions");
                        SegManagement.LogDocument(
                          13, "No.", "Doc. No. Occurrence", "No. of Archived Versions", Database::Vendor, "Buy-from Vendor No.",
                          "Purchaser Code", '', "Posting Description", '');
                    end;
                end;
                Mark(true);

                ShipMethDescr := '';
                if ("Shipment Method Code" = '') then begin
                    ShipmentMethod.Init()
                end else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    if (ShipmentMethod."Intra Shipping Code" <> '') then begin
                        ShipMethDescr := ShipmentMethod."Intra Shipping Code" + ' - ';
                    end else begin
                        ShipMethDescr := ShipmentMethod.Code + ' - ';
                    end;
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                    ShipMethDescr += ShipmentMethod.Description;

                    if ("ecIncoterms Place" <> '') then begin
                        lecIncotermsPlace.Get("ecIncoterms Place");
                        ShipMethDescr += ' ' + lecIncotermsPlace.Description;
                    end;
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

                CreditBankAccount := '';
                if lVendorBankAccount.Get("Pay-to Vendor No.", "Bank Account") then begin
                    CreditBankAccount := lVendorBankAccount.IBAN;
                end;

                if not ShippingAgent.Get("Shipping Agent Code") then Clear(ShippingAgent);

                if ("Currency Factor" = 0) then begin
                    "Currency Factor" := 1;
                end;

                DocRevNo := '';
                CalcFields("No. of Archived Versions");
                if ("No. of Archived Versions" > 0) then begin
                    DocRevNo := StrSubstNo(Txt005, "No. of Archived Versions");
                end;

                Clear(HeaderCommentText);
                HeaderCommentText := PrintFunctions.GetDocumentCommentHeader(PurchaseHeader, Report::"ecPurchases Order");

                OnAfterPurchaseHeaderOnAfterGetRecord(PurchaseHeader, FooterNotes);
            end;

            trigger OnPostDataItem()
            begin
                MarkedOnly := true;
                Commit();
                CurrReport.Language := GlobalLanguage;
            end;

            trigger OnPreDataItem()
            var
                lPurchaseHeader2: Record "Purchase Header";
                lStatus: Integer;
                lError01: Label 'It is not possible to print documents in different states at the same time!', Comment = 'Non è possibile stampare contemporaneamente documenti in stati differenti!';
            begin
                Print := Print or not CurrReport.Preview;

                GeneralSetup.Get();
                if GeneralSetup."Active Watermark Purc. Doc." then begin
                    lPurchaseHeader2.CopyFilters(PurchaseHeader);
                    if lPurchaseHeader2.FindFirst() then begin
                        lStatus := lPurchaseHeader2.Status.AsInteger();
                        if lPurchaseHeader2.FindSet() then begin
                            repeat
                                if (lStatus = lPurchaseHeader2.Status::Released.AsInteger()) then begin
                                    if (lPurchaseHeader2.Status <> lPurchaseHeader2.Status::Released) then begin
                                        Error(lError01);
                                    end;
                                end else begin
                                    if (lPurchaseHeader2.Status = lPurchaseHeader2.Status::Released) then begin
                                        Error(lError01);
                                    end;
                                end;
                            until (lPurchaseHeader2.Next() = 0)
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
                    field(PrintItemCrossRef_Field; PrintItemCrossRef)
                    {
                        ApplicationArea = All;
                        Caption = 'Item reference codes', Comment = 'Codici da Cross Reference';
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
            PrintItemCrossRef := true;

            ArchiveDocument := ArchiveManagement.SalesDocArchiveGranule();
            LogInteraction := SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Purch. Ord.") <> '';

            ArchiveDocumentEnable := ArchiveDocument;
            LogInteractionEnable := LogInteraction;
            ArchiveDocument := false;
            LogInteraction := false;
            GeneralSetup.Get();
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
        Clear(PaymentsAmountArray);
        Clear(PaymentsDateArray);

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

    procedure GetStandardTaskText(pPurchaseLine: Record "Purchase Line")
    var
        lStandardTask: Record "Standard Task";
        lStandardTaskCode: Code[10];
    begin
        Clear(TaskText);
        lStandardTaskCode := PurchaseLine.awpGetStandardTaskCode();

        if (lStandardTaskCode <> '') and lStandardTask.Get(lStandardTaskCode) then begin
            TaskText := StrSubstNo(lblTask, lStandardTask.Code, lStandardTask.Description, PurchaseLine."Prod. Order No.");
        end;

    end;

    var
        CompanyInfo: Record "Company Information";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";
        Item: Record Item;
        PaymentLines: Record "Payment Lines";
        PaymentMethod: Record "Payment Method";
        PaymentTerms: Record "Payment Terms";
        Temp_PurchaseLine: Record "Purchase Line" temporary;
        RespCenter: Record "Responsibility Center";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        ShipmentMethod: Record "Shipment Method";
        ShippingAgent: Record "Shipping Agent";
        Temp_VATAmountLine: Record "VAT Amount Line" temporary;
        Vendor: Record Vendor;
        GeneralSetup: Record "AltAWPGeneral Setup";
        ArchiveManagement: Codeunit ArchiveManagement;
        FormatAddr: Codeunit "Format Address";
        PurchPost: Codeunit "Purch.-Post";
        PurchCountPrinted: Codeunit "Purch.Header-Printed";
        SegManagement: Codeunit SegManagement;
        PrintFunctions: Codeunit "AltAWPPrint Functions";
        awpCommentsManagement: Codeunit "AltAWPComments Management";
        DateValue: Date;
        ReceiptDate: Date;
        ComposedDiscount: Text;
        CreditBankAccount: Text;
        DocRevNo: Text;
        HeaderInformationArray: array[10] of Text;
        LineComments: Text;
        PayMethDescr: Text;
        PayTermDescr: Text;
        PurchasePriceText: Text;
        RoutingInstructionDescription: Text;
        ShipMethDescr: Text;
        VendorPhoneNo: Text;
        LastHeaderInformationArrayText: Text;
        EuroTxt: Text[3];
        CurrencyDescr: Text[30];
        Title: Text;
        CompanyAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        VATDescrArray: array[6] of Text[50];
        VendorAddr: array[8] of Text[50];
        OldDimText: Text[75];
        DimText: Text[120];
        HeaderCommentText: Text;
        BlanketOrderNoText: Text;
        DateText: Text;
        TaskText: Text;
        FooterNotes: Text;
        ArchiveDocument: Boolean;
        ArchiveDocumentEnable: Boolean;
        Continue: Boolean;
        IsRoutingInstructionLine: Boolean;
        LogInteraction: Boolean;
        LogInteractionEnable: Boolean;
        MoreLines: Boolean;
        Print: Boolean;
        PrintItemCrossRef: Boolean;
        VATCodeArray: array[6] of Code[20];
        ItemCrossRefNo: Code[20];
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
        VATAmountArray: array[6] of Decimal;
        VATDiscountAmount: Decimal;
        Ind: Integer;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        StatusNumber: Integer;
        lblChange: Label 'Change';
        lblCode: Label 'Code';
        lblCreditBankAccount: Label 'Credit Bank Account';
        lblCrossRefNo: Label 'Technical ref.';
        lblCurrency: Label 'Currency';
        lblDeliveryTerms: Label 'Delivery terms';
        lblDescription: Label 'Description of the goods (nature and quality)';
        lblDiscount: Label 'Discount';
        lblDiscount2: Label '% Discount';
        lblDocumentDate: Label 'Document Date';
        lblOrderDate: Label 'Order Date', Comment = 'Data Ordine';
        lblDocumentNo: Label 'Document No.';
        lblDocumentTotal: Label 'Document Total';
        lblDocumentType: Label 'Document type';
        lblExporterCode: Label 'Exporter code';
        lblFax: Label 'Fax';
        lblFiscalCode: Label 'Fiscal code';
        lblInvoiceDisc: Label 'Doc. discount amount';
        lblInvoiceDiscPerc: Label 'Document discount %';
        lblLineAmt: Label 'Amount';
        lblNetToPay: Label 'Net to pay';
        lblNote: Label 'Note';
        lblOffice: Label 'Head Office';
        lblPageNo: Label 'Page';
        lblPaymentMeth: Label 'Payment Method';
        lblPaymentTerms: Label 'Payment terms';
        lblPayToVendor: Label 'Addressee';
        lblPhone: Label 'Phone';
        lblPmtExpiry: Label 'Expiry and amount';
        lblPurchaserCode: Label 'Purchaser Code';
        lblQuantity: Label 'Quantity';
        lblReceiptDate: Label 'ETA';
        lblRegOffice: Label 'Registered Office';
        lblRev: Label 'Rev. 5';
        lblShipmentType: Label 'Shipment Type';
        lblShippingAgent: Label 'Carrier';
        lblShipTo: Label 'Consignee';
        lblSignature: Label 'Sign for authorization';
        lblTextWord01: Label 'Dear';
        lblTextWord02: Label 'attached purchase order';
        lblTitle: Label 'PURCHASE ORDER';
        lblTitle2: Label 'BLANKET PURCHASE ORDER', Comment = 'ORDINE ACQUISTO PROGRAMMATO';
        lblTitle3: Label 'SUBCONTRACTOR ORDER', Comment = 'ORDINE ACQUISTO C/LAVORO';
        lblTotalAmt: Label 'Amount';
        lblTotalAmtForDisc: Label 'Amount to discount';
        lblTotalGifts: Label 'Totale Omaggi';
        lblUM: Label 'UM';
        lblUnitPrice: Label 'Unit price';
        lblVariant: Label 'Variant';
        lblVAT: Label 'VAT';
        lblVATAmount: Label 'Tax';
        lblVATBaseAmt: Label 'Amount';
        lblVATCode: Label 'Code';
        lblVATDescription: Label 'Description';
        lblVatRegFiscalCode: Label 'Tax Code No.';
        lblVatRegNo: Label 'VAT Number';
        lblVATTotalAmount: Label 'VAT total';
        lblVATTotalBaseAmount: Label 'Tax amount';
        lblVendorNo: Label 'Vendor';
        lblYourRef: Label 'Your Reference';
        Txt005: Label 'R. %1';
        lblTask: Label 'Task: %1 - %2     ODP: %3', Locked = true;
        Text002: Label '%1 %2', Locked = true;
        Text003: Label '%1 %2 %3', Locked = true;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePurchaseHeaderOnAfterGetRecord(pPurchaseHeader: Record "Purchase Header"; var LastHeaderInformationArrayText: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPurchaseHeaderOnAfterGetRecord(pPurchaseHeader: Record "Purchase Header"; var pFooterNotes: Text)
    begin
    end;


}

