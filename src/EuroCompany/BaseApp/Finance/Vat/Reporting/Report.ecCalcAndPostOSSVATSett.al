namespace EuroCompany.BaseApp.Finance.VAT.Reporting;

using EuroCompany.BaseApp.Finance.VAT.Ledger;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.SalesTax;
using Microsoft.Finance.VAT.Ledger;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.Enums;
using Microsoft.Foundation.NoSeries;
using Microsoft.Sales.Document;
using Microsoft.Utilities;
using System.Utilities;

report 50002 "ecCalc And Post OSS VAT Sett."
{
    ApplicationArea = All;
    Caption = 'Calc. and Post OSS VAT Sett.';
    DefaultLayout = RDLC;
    Permissions = tabledata "VAT Entry" = rimd,
                  tabledata "ecPeriodic OSS Sett. VAT Entry" = rimd;
    RDLCLayout = 'src/EuroCompany/BaseApp/Finance/Vat/Reporting/Report.ecCalcAndPostOSSVATSett.rdl';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("VAT Posting Setup"; "VAT Posting Setup")
        {
            DataItemTableView = sorting("VAT Bus. Posting Group", "VAT Prod. Posting Group")
                                where("ecInclude in OSS VAT Sett." = const(true));
            column(PostSettlement; PostSettlement)
            {
            }
            column(Reprint; ReprintFlag)
            {
            }
            column(PeriodVATDateFilter; StrSubstNo(PeriodTxt, VATDateFilter))
            {
            }
            column(CompanyName; CompanyProperty.DisplayName())
            {
            }
            column(PostingDate; Format(PostingDate))
            {
            }
            column(DocNo; DocNo)
            {
            }
            column(GLAccSettleNo; GLAccSettle."No.")
            {
            }
            column(UseAmtsInAddCurr; UseAmtsInAddCurr)
            {
            }
            column(PrintVATEntries; PrintVATEntries)
            {
            }
            column(VATPostingSetupCptnFilter; "VAT Posting Setup".TableCaption() + ': ' + VATPostingSetupFilter)
            {
            }
            column(VATPostingSetupFilter; VATPostingSetupFilter)
            {
            }
            column(HeaderText; HeaderText)
            {
            }
            column(TotalSaleAmtTotalPurchAmt; -(TotalSaleAmount + TotalPurchaseAmount))
            {
                AutoFormatType = 1;
            }
            column(TotalSaleAmount; TotalSaleAmount)
            {
                AutoFormatExpression = GetCurrency();
                AutoFormatType = 1;
            }
            column(PeriodOutputVATYearOutputVATAdvAmt; PeriodOutputVATYearOutputVATAdvAmt)
            {
                AutoFormatExpression = GetCurrency();
                AutoFormatType = 1;
            }
            column(VatComp; VatComp)
            {
                AutoFormatExpression = GetCurrency();
                AutoFormatType = 1;
            }
            column(PriorPeriodVATEntry_CreditVATCompensation; PriorPeriodVATEntry."Credit VAT Compensation")
            {
            }
            column(TotalPurchaseAmount; TotalPurchaseAmount)
            {
                AutoFormatExpression = GetCurrency();
                AutoFormatType = 1;
            }
            column(PeriodInputVATYearInputVAT; PeriodInputVATYearInputVAT)
            {
                AutoFormatExpression = GetCurrency();
                AutoFormatType = 1;
            }
            column(FinalUndVATAmnt; FinalUndVATAmnt)
            {
                AutoFormatExpression = GetCurrency();
                AutoFormatType = 1;
            }
            column(TotalSaleRounded; TotalSaleRounded)
            {
                AutoFormatExpression = GetCurrency();
                AutoFormatType = 1;
            }
            column(TotalPurchRounded; TotalPurchRounded)
            {
                AutoFormatExpression = GetCurrency();
                AutoFormatType = 1;
            }
            column(VATToPay; VATToPay)
            {
                AutoFormatExpression = GetCurrency();
                AutoFormatType = 1;
            }
            column(VATBusPostGr_VATPostingSetup; "VAT Bus. Posting Group")
            {
            }
            column(VATProdPostGr_VATPostingSetup; "VAT Prod. Posting Group")
            {
            }
            column(CreditVATCompensationCaption; CreditVATCompensationCaptionLbl)
            {
            }
            column(TestReportnotpostedCaption; TestReportnotpostedCaptionLbl)
            {
            }
            column(CalcandPostVATSettlementCaption; CalcandPostVATSettlementCaptionLbl)
            {
            }
            column(DocNoCaption; DocNoCaptionLbl)
            {
            }
            column(GLAccSettleNoCaption; GLAccSettleNoCaptionLbl)
            {
            }
            column(VATEntryPostingDateCaption; VATEntryPostingDateCaptionLbl)
            {
            }
            column(VATEntryDocumentTypeCaption; VATEntryDocumentTypeCaptionLbl)
            {
            }
            column(TotalSaleAmountTotalPurchaseAmountCaption; TotalSaleAmountTotalPurchaseAmountCaptionLbl)
            {
            }
            column(TotalSaleAmountCaption; TotalSaleAmountCaptionLbl)
            {
            }
            column(TotalPurchaseAmountCaption; TotalPurchaseAmountCaptionLbl)
            {
            }
            column(PriorPeriodOutputVATCaption; PriorPeriodVATEntryPriorPeriodOutputVATPriorPeriodVATEntryPriorYearOutputVATPriorPeriodVATEntryAdvancedAmountCaptionLbl)
            {
            }
            column(PriorPeriodInputVATCaption; PriorPeriodVATEntryPriorPeriodInputVATPriorPeriodVATEntryPriorYearInputVATCaptionLbl)
            {
            }
            column(FinalUndVATAmntCaption; FinalUndVATAmntCaptionLbl)
            {
            }
            column(TotalSaleRoundedCaption; TotalSaleRoundedCaptionLbl)
            {
            }
            column(TotalPurchRoundedCaption; TotalPurchRoundedCaptionLbl)
            {
            }
            column(VATToPayCaption; VATToPayCaptionLbl)
            {
            }
            column(VATEntryDocumentNoCaption; "VAT Entry".FieldCaption("Document No."))
            {
            }
            column(VATEntryTypeCaption; "VAT Entry".FieldCaption(Type))
            {
            }
            column(VATEntryBaseCaption; "VAT Entry".FieldCaption(Base))
            {
            }
            column(VATEntryAmountCaption; "VAT Entry".FieldCaption(Amount))
            {
            }
            column(VATEntryEntryNoCaption; "VAT Entry".FieldCaption("Entry No."))
            {
            }
            column(VATEntryNondeductibleAmountCaption; VATEntryNondeductibleAmountCaptionLbl)
            {
            }
            column(VATEntryNondeductibleBaseCaption; VATEntryNondeductibleBaseCaptionLbl)
            {
            }
            column(VATEntryRemainingUnrealizedBaseCaption; VATEntryRemainingUnrealizedBaseCaptionLbl)
            {
            }
            column(VATEntryRemainingUnrealizedAmountCaption; VATEntryRemainingUnrealizedAmountCaptionLbl)
            {
            }
            column(VatPostSetupLayoutVisibility; VatPostSetupLayoutVisibility)
            {
            }
            dataitem("Activity Code Loop"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                dataitem("Closing G/L and VAT Entry"; Integer)
                {
                    DataItemTableView = sorting(Number);
                    column(VATBusPostGr1_VATPostingSetup; "VAT Posting Setup"."VAT Bus. Posting Group")
                    {
                    }
                    column(VATProdPostGr1_VATPostingSetup; "VAT Posting Setup"."VAT Prod. Posting Group")
                    {
                    }
                    column(VATEntryGetFilterType; VATEntry.GetFilter(Type))
                    {
                    }
                    column(VATEntryGetFilterTaxJurisdictionCode; VATEntry.GetFilter("Tax Jurisdiction Code"))
                    {
                    }
                    column(VATEntryGetFilterUseTax; VATEntry.GetFilter("Use Tax"))
                    {
                    }
                    column(Number_IntegerLine; Number)
                    {
                    }
                    dataitem("VAT Entry"; "VAT Entry")
                    {
                        DataItemTableView = sorting(Type, Closed) where(Type = filter(Purchase | Sale));
                        column(PostingDate_VATEntry; Format("Posting Date"))
                        {
                        }
                        column(DocumentNo_VATEntry; "Document No.")
                        {
                            IncludeCaption = false;
                        }
                        column(DocumentType_VATEntry; "Document Type")
                        {
                        }
                        column(Type_VATEntry; Type)
                        {
                            IncludeCaption = false;
                        }
                        column(Base_VATEntry; Base)
                        {
                            AutoFormatExpression = GetCurrency();
                            AutoFormatType = 1;
                            IncludeCaption = false;
                        }
                        column(Amount_VATEntry; Amount)
                        {
                            AutoFormatExpression = GetCurrency();
                            AutoFormatType = 1;
                            IncludeCaption = false;
                        }
                        column(EntryNo_VATEntry; "Entry No.")
                        {
                            IncludeCaption = false;
                        }
                        column(NondeductibleAmount_VATEntry; "Nondeductible Amount")
                        {
                            IncludeCaption = false;
                        }
                        column(NondeductibleBase_VATEntry; "Nondeductible Base")
                        {
                            IncludeCaption = false;
                        }
                        column(RemUnrealizedAmt_VATEntry; "Remaining Unrealized Amount")
                        {
                            IncludeCaption = false;
                        }
                        column(RemUnrealizedBase_VATEntry; "Remaining Unrealized Base")
                        {
                            IncludeCaption = false;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            TotalVATNondeducAmnt += "Nondeductible Amount";
                            TotalVATNondeducBase += "Nondeductible Base";
                            TotalVATNondeducBaseAmt += "Nondeductible Base";
                            TotalRemainUnrealBaseAmt += "Remaining Unrealized Base";
                            TotalRemainUnrealAmt += "Remaining Unrealized Amount";

                            if not PrintVATEntries then
                                CurrReport.Skip();
                        end;

                        trigger OnPreDataItem()
                        begin
                            "VAT Entry".SetRange(Closed, ReprintFlag);
                            "VAT Entry".CopyFilters(VATEntry);
                            TotalVATNondeducAmnt := 0;
                            TotalVATNondeducBase := 0;
                            TotalVATNondeducBaseAmt := 0;
                            TotalRemainUnrealBaseAmt := 0;
                            TotalRemainUnrealAmt := 0;
                        end;
                    }
                    dataitem("Close VAT Entries"; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        MaxIteration = 1;
                        column(PostingDate1; Format(PostingDate))
                        {
                        }
                        column(GenJnlLineDocumentNo; GenJnlLine."Document No.")
                        {
                        }
                        column(GenJnlLineVATBaseAmount; GenJnlLine."VAT Base Amount")
                        {
                            AutoFormatExpression = GetCurrency();
                            AutoFormatType = 1;
                        }
                        column(GenJnlLineVATAmount; GenJnlLine."VAT Amount")
                        {
                            AutoFormatExpression = GetCurrency();
                            AutoFormatType = 1;
                        }
                        column(NextVATEntryNo; NextVATEntryNo)
                        {
                        }
                        column(TotalVATNondeducBase; TotalVATNondeducBase)
                        {
                        }
                        column(TotalVATNondeducAmnt; TotalVATNondeducAmnt)
                        {
                        }
                        column(TotalVATNondeducBaseAmt; TotalVATNondeducBaseAmt)
                        {
                        }
                        column(TotalRemainUnrealBaseAmt; TotalRemainUnrealBaseAmt)
                        {
                        }
                        column(TotalRemainUnrealAmt; TotalRemainUnrealAmt)
                        {
                        }
                        column(GenJnlLine2Amount; GenJnlLine2.Amount)
                        {
                            AutoFormatExpression = GetCurrency();
                            AutoFormatType = 1;
                        }
                        column(GenJnlLine2DocumentNo; GenJnlLine2."Document No.")
                        {
                        }
                        column(ReversingEntry; ReversingEntry)
                        {
                        }
                        column(GenJnlLineVATBaseAmountCaption; GenJnlLineVATBaseAmountCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            // Calculate amount and base
                            VATEntry.CalcSums(
                            Base, Amount,
                            "Additional-Currency Base", "Additional-Currency Amount");

                            ReversingEntry := false;
                            // Balancing entries to VAT accounts
                            Clear(GenJnlLine);
                            GenJnlLine."System-Created Entry" := true;
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                            case VATType of
                                VATEntry.Type::Purchase:
                                    GenJnlLine.Description :=
                                     CopyStr(DelChr(
                                        StrSubstNo(
                                        PurchaseVATSettlementTxt,
                                        "VAT Posting Setup"."VAT Bus. Posting Group",
                                        "VAT Posting Setup"."VAT Prod. Posting Group"),
                                        '>'), 1, 100);
                                VATEntry.Type::Sale:
                                    GenJnlLine.Description :=
                                     CopyStr(DelChr(
                                        StrSubstNo(
                                        SalesVATSettlementTxt,
                                        "VAT Posting Setup"."VAT Bus. Posting Group",
                                        "VAT Posting Setup"."VAT Prod. Posting Group"),
                                        '>'), 1, 100);
                            end;
                            SetVatPostingSetupToGenJnlLine(GenJnlLine, "VAT Posting Setup");
                            GenJnlLine."Deductible %" := 100;
                            GenJnlLine."Posting Date" := PostingDate;
                            GenJnlLine."Operation Occurred Date" := PostingDate;
                            if GLSetup."Use Activity Code" then
                                GenJnlLine."Activity Code" := ActivityCode.Code;
                            GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                            GenJnlLine."Document No." := DocNo;
                            GenJnlLine."Source Code" := SourceCodeSetup."VAT Settlement";
                            GenJnlLine."VAT Posting" := GenJnlLine."VAT Posting"::"Manual VAT Entry";
                            case "VAT Posting Setup"."VAT Calculation Type" of
                                "VAT Posting Setup"."VAT Calculation Type"::"Normal VAT",
                                "VAT Posting Setup"."VAT Calculation Type"::"Full VAT":
                                    begin
                                        case VATType of
                                            VATEntry.Type::Purchase:
                                                begin
                                                    "VAT Posting Setup".TestField("Purchase VAT Account");
                                                    GenJnlLine."Account No." := "VAT Posting Setup"."Purchase VAT Account";
                                                    TotalPurchaseAmount := -VATEntry.Amount + TotalPurchaseAmount;
                                                end;
                                            VATEntry.Type::Sale:
                                                begin
                                                    "VAT Posting Setup".TestField("Sales VAT Account");
                                                    GenJnlLine."Account No." := "VAT Posting Setup"."Sales VAT Account";
                                                    TotalSaleAmount := -VATEntry.Amount + TotalSaleAmount;
                                                end;
                                        end;

                                        CopyAmounts(GenJnlLine, VATEntry);
                                        if (PostSettlement) and (GenJnlLine."VAT Amount" <> 0) then
                                            GenJnlPostLine.Run(GenJnlLine);
                                        VATAmount := VATAmount + VATEntry.Amount;
                                        VATAmountAddCurr := VATAmountAddCurr + VATEntry."Additional-Currency Amount";
                                    end;
                                "VAT Posting Setup"."VAT Calculation Type"::"Reverse Charge VAT":

                                    case VATType of
                                        VATEntry.Type::Purchase:
                                            begin
                                                "VAT Posting Setup".TestField("Purchase VAT Account");
                                                TotalPurchaseAmount := -VATEntry.Amount + TotalPurchaseAmount;
                                                GenJnlLine."Account No." := "VAT Posting Setup"."Purchase VAT Account";
                                                CopyAmounts(GenJnlLine, VATEntry);
                                                if (PostSettlement) and (GenJnlLine."VAT Amount" <> 0) then
                                                    GenJnlPostLine.Run(GenJnlLine);
                                                VATAmount := VATAmount + VATEntry.Amount;
                                                VATAmountAddCurr := VATAmountAddCurr + VATEntry."Additional-Currency Amount";
                                            end;
                                        VATEntry.Type::Sale:
                                            begin
                                                "VAT Posting Setup".TestField("Reverse Chrg. VAT Acc.");
                                                TotalSaleAmount := -VATEntry.Amount + TotalSaleAmount;
                                                GenJnlLine."Account No." := "VAT Posting Setup"."Reverse Chrg. VAT Acc.";

                                                CopyAmounts(GenJnlLine, VATEntry);
                                                GenJnlLine."Deductible %" := 100;
                                                GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Settlement;
                                                if (PostSettlement) and (GenJnlLine."VAT Amount" <> 0) then
                                                    GenJnlPostLine.Run(GenJnlLine);
                                                VATAmount := VATAmount + VATEntry.Amount;
                                                VATAmountAddCurr := VATAmountAddCurr + VATEntry."Additional-Currency Amount";
                                            end;
                                    end;
                                "VAT Posting Setup"."VAT Calculation Type"::"Sales Tax":
                                    begin
                                        TaxJurisdiction.Get(VATEntry."Tax Jurisdiction Code");
                                        GenJnlLine."Tax Area Code" := TaxJurisdiction.Code;
                                        GenJnlLine."Use Tax" := VATEntry."Use Tax";
                                        case VATType of
                                            VATEntry.Type::Purchase:
                                                if VATEntry."Use Tax" then begin
                                                    TaxJurisdiction.TestField("Tax Account (Purchases)");
                                                    GenJnlLine."Account No." := TaxJurisdiction."Tax Account (Purchases)";
                                                    CopyAmounts(GenJnlLine, VATEntry);
                                                    if PostSettlement then
                                                        GenJnlPostLine.Run(GenJnlLine);

                                                    TaxJurisdiction.TestField("Reverse Charge (Purchases)");
                                                    CreateGenJnlLine(GenJnlLine2, TaxJurisdiction."Reverse Charge (Purchases)");
                                                    if PostSettlement then
                                                        GenJnlPostLine.Run(GenJnlLine2);
                                                    ReversingEntry := true;
                                                end else begin
                                                    TaxJurisdiction.TestField("Tax Account (Purchases)");
                                                    GenJnlLine."Account No." := TaxJurisdiction."Tax Account (Purchases)";
                                                    GenJnlLine.Validate(Amount, -VATEntry.Amount);
                                                    CopyAmounts(GenJnlLine, VATEntry);
                                                    if PostSettlement then
                                                        GenJnlPostLine.Run(GenJnlLine);
                                                    VATAmount := VATAmount + VATEntry.Amount;
                                                    VATAmountAddCurr := VATAmountAddCurr + VATEntry."Additional-Currency Amount";
                                                end;
                                            VATEntry.Type::Sale:
                                                begin
                                                    TaxJurisdiction.TestField("Tax Account (Sales)");
                                                    GenJnlLine."Account No." := TaxJurisdiction."Tax Account (Sales)";
                                                    GenJnlLine.Validate(Amount, -VATEntry.Amount);
                                                    CopyAmounts(GenJnlLine, VATEntry);
                                                    if PostSettlement then
                                                        GenJnlPostLine.Run(GenJnlLine);
                                                    VATAmount := VATAmount + VATEntry.Amount;
                                                    VATAmountAddCurr := VATAmountAddCurr + VATEntry."Additional-Currency Amount";
                                                end;
                                        end;
                                    end;
                            end;
                            NextVATEntryNo := NextVATEntryNo + 1;

                            if PostSettlement then begin
                                VATEntry2.Reset();
                                VATEntry2.SetLoadFields(VATEntry2."Closed by Entry No.", VATEntry2.Closed, VATEntry2."VAT Period");
                                VATEntry2.CopyFilters(VATEntry);

                                if VATEntry2.FindSet() then
                                    repeat
                                        VATEntry2."Closed by Entry No." := NextVATEntryNo;
                                        VATEntry2.Closed := true;

                                        VATEntry2.Modify();
                                    until VATEntry2.Next() = 0;

                                VATEntry2.SetRange(Closed, true);
                                if VATEntry2.FindSet() then
                                    repeat
                                        VATEntry2."VAT Period" := VATPeriod;
                                        VATEntry2.Modify();
                                    until VATEntry2.Next() = 0;
                                VATEntry.SetRange(Closed, false);
                            end;

                            FinalUndVATAmnt += TotalVATNondeducAmnt;

                            TotalSaleRounded := FiscalRoundAmount(PeriodOutputVATYearOutputVATAdvAmt + TotalSaleAmount);
                            TotalPurchRounded := FiscalRoundAmount(PeriodInputVATYearInputVAT - TotalPurchaseAmount);

                            VATToPay := 0;
                            if (TotalSaleRounded - TotalPurchRounded) > 0 then
                                VATToPay := TotalSaleRounded - (TotalPurchRounded - VatComp);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VATEntry.Reset();
                        if not
                          VATEntry.SetCurrentKey(
                            Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group",
                            "Tax Jurisdiction Code", "Use Tax", "Tax Liable", "VAT Period", "Operation Occurred Date")
                        then
                            VATEntry.SetCurrentKey(
                              Type, Closed, "Tax Jurisdiction Code", "Use Tax", "Posting Date");
                        if GLSetup."Use Activity Code" then
                            VATEntry.SetFilter("Activity Code", '%1', ActivityCode.Code);
                        VATEntry.SetRange(Type, VATType);
                        VATEntry.SetRange(Closed, ReprintFlag);
                        VATEntry.SetFilter("Operation Occurred Date", VATDateFilter);
                        VATEntry.SetRange("VAT Bus. Posting Group", "VAT Posting Setup"."VAT Bus. Posting Group");
                        VATEntry.SetRange("VAT Prod. Posting Group", "VAT Posting Setup"."VAT Prod. Posting Group");
                        VATEntry.SetRange("Tax Liable", false);
                        if ReprintFlag then
                            VATEntry.SetFilter("VAT Period", '<>%1', '')
                        else
                            VATEntry.SetRange("VAT Period", '');

                        case "VAT Posting Setup"."VAT Calculation Type" of
                            "VAT Posting Setup"."VAT Calculation Type"::"Normal VAT",
                            "VAT Posting Setup"."VAT Calculation Type"::"Reverse Charge VAT",
                            "VAT Posting Setup"."VAT Calculation Type"::"Full VAT":
                                begin
                                    if FindFirstEntry then begin
                                        if not VATEntry.Find('-') then
                                            repeat
                                                VATType := "General Posting Type".FromInteger((VATType.AsInteger() + 1));
                                                VATEntry.SetRange(Type, VATType);
                                            until (VATType = VATEntry.Type::Settlement) or VATEntry.Find('-');
                                        FindFirstEntry := false;
                                    end else
                                        if VATEntry.Next() = 0 then
                                            repeat
                                                VATType := "General Posting Type".FromInteger((VATType.AsInteger() + 1));
                                                VATEntry.SetRange(Type, VATType);
                                            until (VATType = VATEntry.Type::Settlement) or VATEntry.Find('-');
                                    if VATType.AsInteger() < VATEntry.Type::Settlement.AsInteger() then
                                        VATEntry.Find('+');
                                end;
                            "VAT Posting Setup"."VAT Calculation Type"::"Sales Tax":
                                begin
                                    if FindFirstEntry then begin
                                        if not VATEntry.Find('-') then
                                            repeat
                                                VATType := "General Posting Type".FromInteger((VATType.AsInteger() + 1));
                                                VATEntry.SetRange(Type, VATType);
                                            until (VATType = VATEntry.Type::Settlement) or VATEntry.Find('-');
                                        FindFirstEntry := false;
                                    end else begin
                                        VATEntry.SetRange("Tax Jurisdiction Code");
                                        VATEntry.SetRange("Use Tax");
                                        if VATEntry.Next() = 0 then
                                            repeat
                                                VATType := "General Posting Type".FromInteger((VATType.AsInteger() + 1));
                                                VATEntry.SetRange(Type, VATType);
                                            until (VATType = VATEntry.Type::Settlement) or VATEntry.Find('-');
                                    end;
                                    if VATType.AsInteger() < VATEntry.Type::Settlement.AsInteger() then begin
                                        VATEntry.SetRange("Tax Jurisdiction Code", VATEntry."Tax Jurisdiction Code");
                                        VATEntry.SetRange("Use Tax", VATEntry."Use Tax");
                                        VATEntry.Find('+');
                                    end;
                                end;
                        end;

                        if VATType = VATEntry.Type::Settlement then
                            CurrReport.Break();
                    end;

                    trigger OnPreDataItem()
                    begin
                        VATType := VATEntry.Type::Purchase;
                        FindFirstEntry := true;
                    end;
                }
                dataitem(Integer; Integer)
                {
                    DataItemTableView = sorting(Number);
                    MaxIteration = 1;
                    trigger OnAfterGetRecord()
                    begin
                        if (VATBusPostingGroup = "VAT Posting Setup"."VAT Bus. Posting Group") and
                           (VATProdPostingGroup = "VAT Posting Setup"."VAT Prod. Posting Group")
                        then begin
                            if (TotalSaleRounded - TotalPurchRounded) < 0 then
                                CreditNextPeriod := -(TotalSaleRounded - (TotalPurchRounded - VatComp));
                            if (TotalSaleRounded - TotalPurchRounded) > 0 then
                                if (TotalSaleRounded - TotalPurchRounded) <= GLSetup."Minimum VAT Payable" then
                                    DebitNextPeriod := TotalSaleRounded - (TotalPurchRounded - VatComp);
                        end;
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    if (Number = 1) and GLSetup."Use Activity Code" then
                        ActivityCode.FindSet();
                    if (Number = 2) and not GLSetup."Use Activity Code" then
                        CurrReport.Break();
                    if (Number >= 2) and GLSetup."Use Activity Code" then
                        if ActivityCode.Next() = 0 then
                            CurrReport.Break();
                end;
            }
            trigger OnAfterGetRecord()
            begin
                VatPostSetupLayoutVisibility := true;
            end;

            trigger OnPostDataItem()
            begin
                // Post to settlement account
                if VATAmount <> 0 then begin
                    GenJnlLine.Init();
                    GenJnlLine."System-Created Entry" := true;
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine.Validate("Account No.", GLAccSettle."No.");
                    GenJnlLine."Posting Date" := PostingDate;
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                    GenJnlLine."Document No." := DocNo;
                    GenJnlLine.Description := VATSettlementTxt;
                    GenJnlLine.Validate(Amount, VATAmount);
                    GenJnlLine."Source Currency Code" := GLSetup."Additional Reporting Currency";
                    GenJnlLine."Source Currency Amount" := VATAmountAddCurr;
                    GenJnlLine."Source Code" := SourceCodeSetup."VAT Settlement";
                    GenJnlLine."VAT Posting" := GenJnlLine."VAT Posting"::"Manual VAT Entry";
                    GenJnlLine."Operation Occurred Date" := PostingDate;
                    if PostSettlement then begin
                        GenJnlPostLine.Run(GenJnlLine);

                        NewVATAmount := TotalPurchRounded - TotalSaleRounded;
                        if NewVATAmount > 0 then
                            CreditNextPeriod := NewVATAmount
                        else
                            // VAT Settlement
                            if -NewVATAmount <= GLSetup."Minimum VAT Payable" then
                                DebitNextPeriod := NewVATAmount;

                        // Post Rounding Amount to Settlement Account
                        RoundAmount := -VATAmount -
                          (FiscalRoundAmount(TotalSaleAmount) + FiscalRoundAmount(TotalPurchaseAmount));

                        if RoundAmount <> 0 then begin
                            GenJnlLine.Init();
                            GenJnlLine."System-Created Entry" := true;
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                            GenJnlLine.Validate("Account No.", GLAccSettle."No.");
                            GenJnlLine."Posting Date" := PostingDate;
                            GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                            GenJnlLine."Document No." := DocNo;
                            GenJnlLine.Description := VATSettlementRoundingTxt;
                            GenJnlLine.Validate(Amount, RoundAmount);
                            GenJnlLine."Source Code" := SourceCodeSetup."VAT Settlement";
                            GenJnlLine."VAT Posting" := GenJnlLine."VAT Posting"::"Manual VAT Entry";
                            GenJnlLine."Operation Occurred Date" := PostingDate;
                            GenJnlPostLine.Run(GenJnlLine);
                            // Post Rounding Amount to Settlement Account
                            GenJnlLine.Init();
                            GenJnlLine."System-Created Entry" := true;
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                            if RoundAmount > 0 then
                                GenJnlLine.Validate("Account No.", GLAccPosRounding."No.")
                            else
                                GenJnlLine.Validate("Account No.", GLAccNegRounding."No.");
                            GenJnlLine."Posting Date" := PostingDate;
                            GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                            GenJnlLine."Document No." := DocNo;
                            GenJnlLine.Description := VATSettlementRoundingTxt;
                            GenJnlLine.Validate(Amount, -RoundAmount);
                            GenJnlLine."Source Code" := SourceCodeSetup."VAT Settlement";
                            GenJnlLine."VAT Posting" := GenJnlLine."VAT Posting"::"Manual VAT Entry";
                            GenJnlLine."Operation Occurred Date" := PostingDate;
                            GenJnlPostLine.Run(GenJnlLine);
                        end;
                        NewVATAmount := NewVATAmount - VatComp;
                        UpdatePeriodicSettlementVATEntry();
                    end;
                end else
                    if PostSettlement then begin
                        NewVATAmount := NewVATAmount - VatComp;
                        UpdatePeriodicSettlementVATEntry();
                    end
            end;

            trigger OnPreDataItem()
            begin
                GLEntry.LockTable(); // Avoid deadlock with function 12
                if GLEntry.FindLast() then;
                VATEntry.LockTable();
                VATEntry.Reset();
                if VATEntry.Find('+') then
                    NextVATEntryNo := VATEntry."Entry No.";

                SourceCodeSetup.Get();
                GLSetup.Get();
                VATAmount := 0;
                VATAmountAddCurr := 0;
                TotalSaleAmount := 0;
                TotalPurchaseAmount := 0;

                if UseAmtsInAddCurr then
                    HeaderText := StrSubstNo(AllAmountsAreInTxt, GLSetup."Additional Reporting Currency")
                else begin
                    GLSetup.TestField("LCY Code");
                    HeaderText := StrSubstNo(AllAmountsAreInTxt, GLSetup."LCY Code");
                end;

                if FindLast() then begin
                    VATBusPostingGroup := "VAT Bus. Posting Group";
                    VATProdPostingGroup := "VAT Prod. Posting Group";
                end;

                SalesHeader.SetFilter("Posting Date", '%1..%2', EntrdStartDate, EndDateReq);
                SalesHeader.SetFilter("Order Date", '%1..%2', EntrdStartDate, EndDateReq);
                SalesHeader.SetFilter("Posting No.", '<>%1', '');
                if SalesHeader.Find('-') then begin
                    // Attenzione esiste un salto nella numerazione protocollo
                    if PostSettlement = true then
                        Error(Text18055070Msg);
                    if PostSettlement = false then
                        Message(Text18055071Msg);
                end;
            end;
        }
        dataitem(Total; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
            column(DebitNextPeriodCaption; DebitNextPeriodCaptionLbl)
            {
            }
            column(CreditNextPeriodCaption; CreditNextPeriodCaptionLbl)
            {
            }
            column(VATAmountAddCurrCaption; VATAmountAddCurrCaptionLbl)
            {
            }
            column(DebitNextPeriod; DebitNextPeriod)
            {
                AutoFormatExpression = GetCurrency();
                AutoFormatType = 1;
            }
            column(CreditNextPeriod; CreditNextPeriod)
            {
                AutoFormatExpression = GetCurrency();
                AutoFormatType = 1;
            }
            column(VATAmountAddCurr; VATAmountAddCurr)
            {
                AutoFormatExpression = GetCurrency();
                AutoFormatType = 1;
            }
        }
        dataitem(VATPlafondPeriod; "VAT Plafond Period")
        {
            DataItemTableView = sorting(Year);
            column(RemainingVATPlafondAmount; PrevPlafondAmount - UsedPlafondAmount)
            {
                AutoFormatExpression = GetCurrency();
                AutoFormatType = 1;
            }
            column(UsedPlafondAmount; UsedPlafondAmount)
            {
                AutoFormatExpression = GetCurrency();
                AutoFormatType = 1;
            }
            column(PrevPlafondAmount; PrevPlafondAmount)
            {
                AutoFormatExpression = GetCurrency();
                AutoFormatType = 1;
            }
            column(VATPlafondPeriodYear; Year)
            {
            }
            column(RemainingVATPlafondAmountCaption; RemainingVATPlafondAmountCaptionLbl)
            {
            }
            column(UsedPlafondAmountCaption; UsedPlafondAmountCaptionLbl)
            {
            }
            column(PrevPlafondAmountCaption; PrevPlafondAmountCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                locCalcAmounts(EntrdStartDate, EndDateReq, UsedPlafondAmount, PrevPlafondAmount, VATPlafondPeriod);
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Year, Date2DMY(EndDateReq, 3));
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartingDate; EntrdStartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the value of the Starting Date field';

                        trigger OnValidate()
                        begin
                            if (GLSetup."ecLast OSS Settlement Date" <> 0D) then
                                CheckStartingDate();
                        end;
                    }
                    field(EndingDate; EndDateReq)
                    {
                        ApplicationArea = All;
                        Caption = 'Ending Date';
                        Editable = false;
                        ToolTip = 'Specifies the value of the Ending Date field';
                    }
                    field(PostingDt; PostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the value of the Posting Date field';
                    }
                    field(DocumentNo; DocNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Document No.';
                        ToolTip = 'Specifies the value of the Document No. field';
                    }
                    field(SettlementAcc; GLAccSettle."No.")
                    {
                        ApplicationArea = All;
                        Caption = 'Settlement Account';
                        TableRelation = "G/L Account";
                        ToolTip = 'Specifies the value of the Settlement Account field';

                        trigger OnValidate()
                        begin
                            if GLAccSettle."No." <> '' then begin
                                GLAccSettle.Find();
                                GLAccSettle.CheckGLAcc();
                            end;
                        end;
                    }
                    field(GLGainsAccount; GLAccPosRounding."No.")
                    {
                        ApplicationArea = All;
                        Caption = 'G/L Gains Account';
                        TableRelation = "G/L Account";
                        ToolTip = 'Specifies the value of the G/L Gains Account field';
                    }
                    field(GLLossesAccount; GLAccNegRounding."No.")
                    {
                        ApplicationArea = All;
                        Caption = 'G/L Losses Account';
                        TableRelation = "G/L Account";
                        ToolTip = 'Specifies the value of the G/L Losses Account field';
                    }
                    field(ShowVATEntries; PrintVATEntries)
                    {
                        ApplicationArea = All;
                        Caption = 'Show VAT Entries';
                        ToolTip = 'Specifies the value of the Show VAT Entries field';
                    }
                    field(Post; PostSettlement)
                    {
                        ApplicationArea = All;
                        Caption = 'Post';
                        Editable = PostEditable;
                        ToolTip = 'Specifies the value of the Post field';
                        trigger OnValidate()
                        begin
                            ReprintFlag := false;
                        end;
                    }
                    field(Reprint; ReprintFlag)
                    {
                        ApplicationArea = All;
                        Caption = 'Reprint';
                        ToolTip = 'Specifies the value of the Reprint field';
                        trigger OnValidate()
                        begin
                            if not ReprintFlag then begin
                                PostEditable := true;
                                GetGLSetup();
                                if GLSetup."ecLast OSS Settlement Date" <> 0D then begin
                                    EntrdStartDate := GLSetup."ecLast OSS Settlement Date" + 1;
                                    CalculateEndDate();
                                    RequestOptionsPage.Update();
                                end else
                                    Clear(EntrdStartDate);
                            end else
                                PostSettlement := false;
                        end;
                    }
                }
            }
        }

        actions
        {
        }
        trigger OnOpenPage()
        begin
            if not ReprintFlag then begin
                PostEditable := true;
                GetGLSetup();
                if GLSetup."ecLast OSS Settlement Date" <> 0D then begin
                    EntrdStartDate := GLSetup."ecLast OSS Settlement Date" + 1;
                    CalculateEndDate();
                end else
                    Clear(EntrdStartDate);
            end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        GetGLSetup();
        if EndDateReq = 0D then
            Error(EnterEndingDateTxt);

        NoSeriesMgt.CheckSalesDocNoGaps(EndDateReq);
        NoSeriesMgt.CheckPurchDocNoGaps(EndDateReq);

        if PostSettlement then begin
            if EntrdStartDate <= GLSetup."ecLast OSS Settlement Date" then
                Error(StartDateGreaterSettlementDateTxt, GLSetup."ecLast OSS Settlement Date");
            if PostingDate = 0D then
                Error(EnterPostingDateTxt);
            if PostingDate < EndDateReq then
                Error(PostingDateLessEndingDateTxt);
            if DocNo = '' then
                Error(EnterDocumentDateTxt);
            if GLAccSettle."No." = '' then
                Error(EnterSettlementAccountTxt);
            GLAccSettle.Find();
            if GLAccPosRounding."No." = '' then
                Error(EnterGainsAccountTxt);
            GLAccPosRounding.Find();
            if GLAccNegRounding."No." = '' then
                Error(EnterLossesAccountTxt);
            GLAccNegRounding.Find();
        end;

        if EntrdStartDate > EndDateReq then
            Error(EndingDateLessStartingDateTxt);

        if PostSettlement and not Initialized then
            if not Confirm(CalculatePostVATSettlementTxt, false) then
                CurrReport.Quit();

        VATPostingSetupFilter := "VAT Posting Setup".GetFilters();
        if EntrdStartDate = 0D then
            VATEntry.SetFilter("Operation Occurred Date", '..%1', EndDateReq)
        else
            VATEntry.SetRange("Operation Occurred Date", EntrdStartDate, EndDateReq);
        VATDateFilter := VATEntry.GetFilter("Operation Occurred Date");
        Clear(GenJnlPostLine);
        VATPeriod := Format(Date2DMY(EndDateReq, 3)) + '/' +
                     ConvertStr(Format(Date2DMY(EndDateReq, 2), 2), ' ', '0');

        PriorPeriodVATEntry.SetRange("VAT Period", Format(Date2DMY(EntrdStartDate, 3)) + '/' +
          ConvertStr(Format(Date2DMY(EntrdStartDate, 2), 2), ' ', '0'),
          Format(Date2DMY(EndDateReq, 3)) + '/' + ConvertStr(Format(Date2DMY(EndDateReq, 2), 2), ' ', '0'));
        if PriorPeriodVATEntry.FindSet() then
            repeat
                PeriodInputVATYearInputVAT +=
                  PriorPeriodVATEntry."Prior Period Input VAT" + PriorPeriodVATEntry."Prior Year Input VAT";

                PeriodOutputVATYearOutputVATAdvAmt +=
                  PriorPeriodVATEntry."Prior Period Output VAT" + PriorPeriodVATEntry."Prior Year Output VAT" +
                  PriorPeriodVATEntry."Advanced Amount";

                VatComp := PriorPeriodVATEntry."Credit VAT Compensation";
            until PriorPeriodVATEntry.Next() = 0;
        TotalSaleRounded := FiscalRoundAmount(PeriodOutputVATYearOutputVATAdvAmt + TotalSaleAmount);
        TotalPurchRounded := FiscalRoundAmount(PeriodInputVATYearInputVAT - TotalPurchaseAmount);
    end;

    var
        ActivityCode: Record "Activity Code";
        Data: Record Date;
        GLAccNegRounding: Record "G/L Account";
        GLAccPosRounding: Record "G/L Account";
        GLAccSettle: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GLSetup: Record "General Ledger Setup";
        PriorPeriodVATEntry: Record "ecPeriodic OSS Sett. VAT Entry";
        PriorPeriodVATEntry2: Record "ecPeriodic OSS Sett. VAT Entry";
        SalesHeader: Record "Sales Header";
        SourceCodeSetup: Record "Source Code Setup";
        TaxJurisdiction: Record "Tax Jurisdiction";
        VATEntry: Record "VAT Entry";
        VATEntry2: Record "VAT Entry";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        FindFirstEntry: Boolean;
        GLSetupGet: Boolean;
        Initialized: Boolean;
        PostEditable: Boolean;
        PostSettlement: Boolean;
        PrintVATEntries: Boolean;
        ReprintFlag: Boolean;
        ReversingEntry: Boolean;
        UseAmtsInAddCurr: Boolean;
        VATPeriod: Code[10];
        DocNo: Code[20];
        VATBusPostingGroup: Code[20];
        VATProdPostingGroup: Code[20];
        VATDateFilter: Text;
        VATPostingSetupFilter: Text;
        HeaderText: Text[30];
        EndDateReq: Date;
        EntrdStartDate: Date;
        PostingDate: Date;
        CreditNextPeriod: Decimal;
        DebitNextPeriod: Decimal;
        FinalUndVATAmnt: Decimal;
        NewVATAmount: Decimal;
        PeriodInputVATYearInputVAT: Decimal;
        PeriodOutputVATYearOutputVATAdvAmt: Decimal;
        PrevPlafondAmount: Decimal;
        RoundAmount: Decimal;
        TotalPurchaseAmount: Decimal;
        TotalPurchRounded: Decimal;
        TotalRemainUnrealAmt: Decimal;
        TotalRemainUnrealBaseAmt: Decimal;
        TotalSaleAmount: Decimal;
        TotalSaleRounded: Decimal;
        TotalVATNondeducAmnt: Decimal;
        TotalVATNondeducBase: Decimal;
        TotalVATNondeducBaseAmt: Decimal;
        UsedPlafondAmount: Decimal;
        VATAmount: Decimal;
        VATAmountAddCurr: Decimal;
        VatComp: Decimal;
        VATToPay: Decimal;
        VATType: Enum "General Posting Type";
        NextVATEntryNo: Integer;
        AllAmountsAreInTxt: Label 'All amounts are in %1.', Comment = '%1 = Currency Code';
        CalcandPostVATSettlementCaptionLbl: Label 'Calc. and Post VAT Settlement';
        CreditNextPeriodCaptionLbl: Label 'Next Period Input VAT';
        CreditVATCompensationCaptionLbl: Label 'Credit VAT Compensation';
        DebitNextPeriodCaptionLbl: Label 'Next Period Output VAT';
        DocNoCaptionLbl: Label 'Document No.';
        FinalUndVATAmntCaptionLbl: Label 'Nondeduc. Amount';
        GenJnlLineVATBaseAmountCaptionLbl: Label 'Settlement';
        GLAccSettleNoCaptionLbl: Label 'Settlement Account';
        PrevPlafondAmountCaptionLbl: Label 'Previous VAT Plafond Amount';
        PriorPeriodVATEntryPriorPeriodInputVATPriorPeriodVATEntryPriorYearInputVATCaptionLbl: Label 'Prior Period Input VAT';
        PriorPeriodVATEntryPriorPeriodOutputVATPriorPeriodVATEntryPriorYearOutputVATPriorPeriodVATEntryAdvancedAmountCaptionLbl: Label 'Prior Period Output VAT';
        RemainingVATPlafondAmountCaptionLbl: Label 'Remaining VAT Plafond Amount';
        ReprintMsg: Label 'The period you inserted is already been posted\Do you want to Reprint the period?';
        TestReportnotpostedCaptionLbl: Label 'Test Report (Not Posted)';
        EnterPostingDateTxt: Label 'Please enter the posting date.';
        EnterDocumentDateTxt: Label 'Please enter the document no.';
        EnterSettlementAccountTxt: Label 'Please enter the settlement account';
        CalculatePostVATSettlementTxt: Label 'Do you want to calculate and post the VAT Settlement?';
        VATSettlementTxt: Label 'OSS VAT Settlement';
        PeriodTxt: Label 'Period: %1';
        PurchaseVATSettlementTxt: Label 'Purchase VAT settlement: #1######## #2########';
        SalesVATSettlementTxt: Label 'Sales VAT settlement  : #1######## #2########';
        EnterEndingDateTxt: Label 'Please enter the ending date.';
        StartDateGreaterSettlementDateTxt: Label 'Start Date must be greater than the Last OSS Settlement Date :%1';
        PostingDateLessEndingDateTxt: Label 'Posting Date cannot be less than the Ending Date';
        EnterGainsAccountTxt: Label 'Please enter the G/L Gains  Account';
        EnterLossesAccountTxt: Label 'Please enter the G/L Losses Account';
        EndingDateLessStartingDateTxt: Label 'Ending Date cannot be less than Starting Date';
        VATSettlementRoundingTxt: Label 'VAT Settlement Rounding +/-';
        LastSettlementDateTxt: Label 'The Last OSS Settlement Date is %1';
        NotBeBlankTxt: Label 'The %1 in %2 must not be Blank';
        Text18055070Msg: Label 'Warning: A Jump in the numeration of the VAT Registers for the selected period exist';
        Text18055071Msg: Label 'Warning: A Jump in the numeration of the protocol exist';
        TotalPurchaseAmountCaptionLbl: Label 'Input VAT';
        TotalPurchRoundedCaptionLbl: Label 'Input VAT (Rounded)';
        TotalSaleAmountCaptionLbl: Label 'Output VAT';
        TotalSaleAmountTotalPurchaseAmountCaptionLbl: Label 'VAT';
        TotalSaleRoundedCaptionLbl: Label 'Output VAT (Rounded)';
        UsedPlafondAmountCaptionLbl: Label 'Used VAT Plafond Amount';
        VATAmountAddCurrCaptionLbl: Label 'Total';
        VATEntryDocumentTypeCaptionLbl: Label 'Doc Type';
        VATEntryNondeductibleAmountCaptionLbl: Label 'Nondeduc. Amt.';
        VATEntryNondeductibleBaseCaptionLbl: Label 'Nondeduc. Base';
        VATEntryPostingDateCaptionLbl: Label 'Posting Date';
        VATEntryRemainingUnrealizedAmountCaptionLbl: Label 'Rem. Unreal. Amt.';
        VATEntryRemainingUnrealizedBaseCaptionLbl: Label 'Rem. Unreal. Base';
        VATToPayCaptionLbl: Label 'Total VAT to pay (if positive)';

    protected var
        VatPostSetupLayoutVisibility: Boolean;

    procedure InitializeRequest(pNewStartDate: Date; pNewEndDate: Date; pNewPostingDate: Date; pNewDocNo: Code[20]; pNewSettlementAcc: Code[20]; pNewPosRoundAcc: Code[20]; pNewNegRoundAcc: Code[20]; pShowVATEntries: Boolean; pPost: Boolean)
    begin
        EntrdStartDate := pNewStartDate;
        EndDateReq := pNewEndDate;
        PostingDate := pNewPostingDate;
        DocNo := pNewDocNo;
        GLAccSettle."No." := pNewSettlementAcc;
        GLAccPosRounding."No." := pNewPosRoundAcc;
        GLAccNegRounding."No." := pNewNegRoundAcc;
        PrintVATEntries := pShowVATEntries;
        PostSettlement := pPost;
        Initialized := true;
    end;

    procedure InitializeRequest2(NewUseAmtsInAddCurr: Boolean)
    begin
        UseAmtsInAddCurr := NewUseAmtsInAddCurr;
    end;

    procedure GetCurrency(): Code[10]
    begin
        exit('');
    end;

    procedure SetInitialized(NewInitialized: Boolean)
    begin
        Initialized := NewInitialized;
    end;

    local procedure CopyAmounts(var pGenJournalLine: Record "Gen. Journal Line"; pVATEntry: Record "VAT Entry")
    begin
        pGenJournalLine.Validate(Amount, -pVATEntry.Amount);
        pGenJournalLine."VAT Amount" := -pVATEntry.Amount;
        pGenJournalLine."VAT Base Amount" := -pVATEntry.Base;
        pGenJournalLine."Source Currency Code" := GLSetup."Additional Reporting Currency";
        pGenJournalLine."Source Currency Amount" := -pVATEntry."Additional-Currency Amount";
        pGenJournalLine."Source Curr. VAT Amount" := -pVATEntry."Additional-Currency Amount";
        pGenJournalLine."Source Curr. VAT Base Amount" := -pVATEntry."Additional-Currency Base";
    end;

    local procedure CreateGenJnlLine(var pGenJnlLine2: Record "Gen. Journal Line"; pAccountNo: Code[20])
    begin
        Clear(pGenJnlLine2);
        pGenJnlLine2."System-Created Entry" := true;
        pGenJnlLine2."Account Type" := pGenJnlLine2."Account Type"::"G/L Account";
        pGenJnlLine2.Description := GenJnlLine.Description;
        pGenJnlLine2."Posting Date" := PostingDate;
        pGenJnlLine2."Document Type" := pGenJnlLine2."Document Type"::" ";
        pGenJnlLine2."Document No." := DocNo;
        pGenJnlLine2."Source Code" := SourceCodeSetup."VAT Settlement";
        pGenJnlLine2."VAT Posting" := pGenJnlLine2."VAT Posting"::"Manual VAT Entry";
        pGenJnlLine2."Account No." := pAccountNo;
        pGenJnlLine2."Tax Area Code" := TaxJurisdiction.Code;
        pGenJnlLine2."Use Tax" := VATEntry."Use Tax";
        pGenJnlLine2.Validate(Amount, VATEntry.Amount);
        pGenJnlLine2."Source Currency Code" := GLSetup."Additional Reporting Currency";
        pGenJnlLine2."Source Currency Amount" := VATEntry."Additional-Currency Amount";
        pGenJnlLine2."System-Created Entry" := true;
    end;

    procedure FiscalRoundAmount(AmountToRound: Decimal) Amount: Decimal
    begin
        if GLSetup."Settlement Round. Factor" <> 0 then
            Amount := Round(AmountToRound, GLSetup."Settlement Round. Factor")
        else
            Error(NotBeBlankTxt, GLSetup.FieldCaption("Settlement Round. Factor"), GLSetup.TableCaption());
    end;

    procedure CalculateEndDate()
    begin
        case GLSetup."VAT Settlement Period" of
            GLSetup."VAT Settlement Period"::Month:
                Data."Period Type" := Data."Period Type"::Month;
            GLSetup."VAT Settlement Period"::Quarter:
                Data."Period Type" := Data."Period Type"::Quarter;
        end;

        if Data.Get(Data."Period Type", EntrdStartDate) then
            if Data.Find('>') then begin
                EndDateReq := Data."Period Start" - 1;
                PostingDate := EndDateReq;
            end;
    end;

    procedure GetGLSetup()
    begin
        if not GLSetupGet then begin
            GLSetup.Get();
            GLSetupGet := true;
        end;
    end;

    local procedure UpdatePeriodicSettlementVATEntry()
    var
        DateFormula: DateFormula;
        IsNewYear: Boolean;
    begin
        if PriorPeriodVATEntry.Get(Format(Date2DMY(EndDateReq, 3)) + '/' +
          ConvertStr(Format(Date2DMY(EndDateReq, 2), 2), ' ', '0'))
        then begin
            PriorPeriodVATEntry."VAT Settlement" := NewVATAmount;
            //F124/A.sn
            if PriorPeriodVATEntry."VAT Settlement" >= 0 then
                CreditNextPeriod := PriorPeriodVATEntry."VAT Settlement"
            else
                DebitNextPeriod := PriorPeriodVATEntry."VAT Settlement";
            //F124/A.en
            PriorPeriodVATEntry."VAT Period Closed" := true;
            PriorPeriodVATEntry.Modify();
        end else begin
            PriorPeriodVATEntry.Init();
            PriorPeriodVATEntry."VAT Period" := Format(Date2DMY(EndDateReq, 3)) + '/' +
              ConvertStr(Format(Date2DMY(EndDateReq, 2), 2), ' ', '0');
            PriorPeriodVATEntry."VAT Settlement" := NewVATAmount;
            //F124/A.sn
            if PriorPeriodVATEntry."VAT Settlement" >= 0 then
                CreditNextPeriod := PriorPeriodVATEntry."VAT Settlement"
            else
                DebitNextPeriod := PriorPeriodVATEntry."VAT Settlement";
            //F124/A.sn
            PriorPeriodVATEntry."VAT Period Closed" := true;
            PriorPeriodVATEntry.Insert(true);
        end;

        // Post Rounding Amount to G/L Gains or Losses Account
        case GLSetup."VAT Settlement Period" of
            GLSetup."VAT Settlement Period"::Month:
                Evaluate(DateFormula, '<1D>');
            GLSetup."VAT Settlement Period"::Quarter:
                Evaluate(DateFormula, '<CQ+1Q>');
        end;

        PriorPeriodVATEntry2.Init();
        PriorPeriodVATEntry2."VAT Period" :=
          Format(Date2DMY(CalcDate(DateFormula, EndDateReq), 3)) + '/' +
          ConvertStr(Format(Date2DMY(CalcDate(DateFormula, EndDateReq), 2), 2), ' ', '0');
        PriorPeriodVATEntry2.Insert();

        IsNewYear := Date2DMY(CalcDate(DateFormula, EndDateReq), 3) <> Date2DMY(EndDateReq, 3);
        if (TotalSaleAmount = 0) and (TotalPurchaseAmount = 0) then
            if (PriorPeriodVATEntry."Prior Period Input VAT" <> 0) or (PriorPeriodVATEntry."Prior Year Input VAT" <> 0) then
                CreditNextPeriod := PriorPeriodVATEntry."Prior Period Input VAT" + PriorPeriodVATEntry."Prior Year Input VAT"
            else
                DebitNextPeriod := PriorPeriodVATEntry."Prior Period Output VAT" + PriorPeriodVATEntry."Prior Year Output VAT";

        if CreditNextPeriod <> 0 then
            if IsNewYear then
                PriorPeriodVATEntry2."Prior Year Input VAT" := CreditNextPeriod - VatComp
            else
                PriorPeriodVATEntry2."Prior Period Input VAT" := CreditNextPeriod - VatComp
        else
            if DebitNextPeriod <> 0 then
                if IsNewYear then
                    PriorPeriodVATEntry2."Prior Year Output VAT" := Abs(DebitNextPeriod)
                else
                    PriorPeriodVATEntry2."Prior Period Output VAT" := Abs(DebitNextPeriod);

        PriorPeriodVATEntry2.Modify(true);
        GLSetup."ecLast OSS Settlement Date" := EndDateReq;
        GLSetup.Modify();
    end;

    local procedure locCalcAmounts(pStartingDate: Date; pEndingDate: Date; var UsedAmount: Decimal; var RemAmount: Decimal; VATPlaf: Record "VAT Plafond Period"): Boolean
    var
        locEnterSettlementAccountTxt: Label 'Dates %1 and %2 must belong to the same year';
    begin
        if not VATPlaf.Get(Date2DMY(pEndingDate, 3)) then
            exit(false);

        if Date2DMY(pStartingDate, 3) <> Date2DMY(pEndingDate, 3) then
            Error(locEnterSettlementAccountTxt, pStartingDate, pEndingDate);

        VATPlaf."Date Filter" := GetDateFilter(pStartingDate, pEndingDate);
        VATPlaf.CalcFields("Calculated Amount");
        UsedAmount := VATPlaf."Calculated Amount";

        VATPlaf."Date Filter" := GetDateFilter(CalcDate('<-CY>', pEndingDate), CalcDate('<-1D>', pStartingDate));
        VATPlaf.CalcFields("Calculated Amount");
        RemAmount := VATPlaf.Amount - VATPlaf."Calculated Amount";

        exit(true);
    end;

    local procedure GetDateFilter(Date1: Date; Date2: Date): Text[30]
    var
        Lbl: Label '%1..%2', Locked = true;
    begin
        exit(Format(StrSubstNo(Lbl, Date1, Date2)));
    end;

    local procedure SetVatPostingSetupToGenJnlLine(var pGenJnlLine: Record "Gen. Journal Line"; VATPostingSetup: Record "VAT Posting Setup")
    begin
        pGenJnlLine."Gen. Posting Type" := pGenJnlLine."Gen. Posting Type"::Settlement;//Nel custom fatto tutto nel trigger
        pGenJnlLine."VAT Bus. Posting Group" := VATPostingSetup."VAT Bus. Posting Group";
        pGenJnlLine."VAT Prod. Posting Group" := VATPostingSetup."VAT Prod. Posting Group";
        pGenJnlLine."VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
    end;

    local procedure CheckStartingDate()
    var
        CalcDate: Integer;
    begin
        CalcDate := EntrdStartDate - GLSetup."ecLast OSS Settlement Date";
        if ((CalcDate) > 1) then
            Error(LastSettlementDateTxt, GLSetup."ecLast OSS Settlement Date");

        if (CalcDate = 1) then
            CalculateEndDate()
        else
            if not Confirm(ReprintMsg, false) then
                Error(LastSettlementDateTxt, GLSetup."ecLast OSS Settlement Date")
            else begin
                PostSettlement := false;
                ReprintFlag := true;
                PostEditable := false;
                RequestOptionsPage.Update(true);
                CalculateEndDate();
            end;
    end;
}
