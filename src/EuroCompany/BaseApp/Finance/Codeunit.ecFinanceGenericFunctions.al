namespace EuroCompany.BaseApp.Finance;

using EuroCompany.BaseApp.Setup;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Foundation.PaymentTerms;

codeunit 50008 "ecFinance Generic Functions"
{
    #region 368
    procedure CheckInclInVATSettFlags(VatPostingSetup: Record "VAT Posting Setup")
    var
        IncludeInVATSettErr: Label 'Setup already included in another VAT settlement.';
    begin
        if (VatPostingSetup."APsInclude in E.VAT Settlement") and (VatPostingSetup."ecInclude in OSS VAT Sett.") then
            Error(IncludeInVATSettErr);
    end;
    #endregion 368

    #region 222
    procedure CreateSalesPaymentLine(GenJnlLine: Record "Gen. Journal Line")
    var
        PaymentSales, PaymentSales1 : Record "Payment Lines";
        PaymentTermsLine: Record "Payment Lines";
        DefDueDates: Record "Deferring Due Dates";
        FixedDueDate: Record "Fixed Due Dates";
        PaymentTerms: Record "Payment Terms";
        EcSetup: Record "ecGeneral Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        PaymentCounter: Integer;
        Month: Integer;
        Day: Integer;
        Year: Integer;
        MaximumDay: Integer;
    begin
        EcSetup.Get();
        if (EcSetup."Use Custom Calc. Due Date") and (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer) and (GenJnlLine."ecRef. Date For Calc. Due Date" <> 0D) then begin
            if GenJnlTemplate.Get(GenJnlLine."Journal Template Name") then begin
                PaymentTermsLine.Reset();
                PaymentTermsLine.SetRange("Sales/Purchase", PaymentTermsLine."Sales/Purchase"::" ");
                PaymentTermsLine.SetRange(Type, PaymentTermsLine.Type::"Payment Terms");
                PaymentTermsLine.SetRange(Code, GenJnlLine."Payment Terms Code");
                if PaymentTermsLine.Find('-') then
                    repeat
                        PaymentSales1.Reset();
                        PaymentSales1.SetRange(Type, PaymentSales1.Type::"General Journal");
                        PaymentSales1.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                        PaymentSales1.SetRange("Journal Line No.", GenJnlLine."Line No.");
                        if PaymentSales1.FindFirst() then begin
                            PaymentSales1.Delete();

                            PaymentSales.Init();
                            PaymentSales."Sales/Purchase" := PaymentSales."Sales/Purchase"::" ";
                            PaymentSales.Type := PaymentSales.Type::"General Journal";
                            PaymentSales."Journal Template Name" := GenJnlLine."Journal Template Name";

                            if GenJnlLine."Line No." = 0 then
                                PaymentSales."Journal Line No." := 10000
                            else
                                PaymentSales."Journal Line No." := GenJnlLine."Line No.";

                            PaymentSales.Code := GenJnlLine."Journal Batch Name";
                            PaymentCounter := PaymentCounter + 10000;
                            PaymentSales."Line No." := PaymentCounter;
                            PaymentSales."Payment %" := PaymentTermsLine."Payment %";
                            PaymentSales."Due Date Calculation" := PaymentTermsLine."Due Date Calculation";
                            PaymentSales."Discount Date Calculation" := PaymentTermsLine."Discount Date Calculation";
                            PaymentSales."Discount %" := PaymentTermsLine."Discount %";
                            PaymentSales."Due Date" := CalcDate(PaymentTermsLine."Due Date Calculation", GenJnlLine."ecRef. Date For Calc. Due Date");

                            if PaymentSales."Due Date" < GenJnlLine."Document Date" then
                                PaymentSales."Due Date" := GenJnlLine."Document Date";

                            DefDueDates.SetCurrentKey("No.", "To-Date");
                            DefDueDates.SetRange("No.", GenJnlLine."Account No.");
                            DefDueDates.SetFilter("To-Date", '%1..', PaymentSales."Due Date");

                            if DefDueDates.FindFirst() and
                               (DefDueDates."From-Date" <= PaymentSales."Due Date")
                            then begin
                                if GenJnlLine."Document Type" <> GenJnlLine."Document Type"::"Credit Memo" then
                                    PaymentSales."Due Date Calculation" := DefDueDates."Due Date Calculation";
                                PaymentSales."Due Date" := CalcDate(DefDueDates."Due Date Calculation", DefDueDates."To-Date");
                                if PaymentSales."Due Date" < GenJnlLine."Document Date" then
                                    PaymentSales."Due Date" := GenJnlLine."Document Date";
                            end;

                            FixedDueDate.Reset();
                            FixedDueDate.SetRange(Type, FixedDueDate.Type::Customer);
                            FixedDueDate.SetRange(Code, GenJnlLine."Account No.");
                            if FixedDueDate.Count > 0 then begin
                                FixedDueDate.SetRange("Payment Days", Date2DMY(PaymentSales."Due Date", 1), 99);
                                if FixedDueDate.FindFirst() then begin
                                    Day := FixedDueDate."Payment Days";
                                    MaximumDay := Date2DMY(CalcDate('<CM>', PaymentSales."Due Date"), 1);
                                    if Day > MaximumDay then
                                        Day := MaximumDay;
                                    Month := Date2DMY(PaymentSales."Due Date", 2);
                                    Year := Date2DMY(PaymentSales."Due Date", 3);
                                    PaymentSales."Due Date" := DMY2Date(Day, Month, Year);
                                end else begin
                                    FixedDueDate.SetRange("Payment Days");
                                    FixedDueDate.FindFirst();
                                    Day := FixedDueDate."Payment Days";
                                    MaximumDay := Date2DMY(CalcDate('<CM + 1M>', PaymentSales."Due Date"), 1);
                                    if Day > MaximumDay then
                                        Day := MaximumDay;
                                    Month := Date2DMY(PaymentSales."Due Date", 2) + 1;
                                    Year := Date2DMY(PaymentSales."Due Date", 3);
                                    if Month = 13 then begin
                                        Month := 1;
                                        Year := Year + 1;
                                    end;
                                    PaymentSales."Due Date" := DMY2Date(Day, Month, Year);
                                end;
                            end;

                            if PaymentTerms.Get(GenJnlLine."Payment Terms Code") then;
                            if not PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" and (GenJnlLine."Document Type" = GenJnlLine."Document Type"::"Credit Memo") then begin
                                PaymentSales."Discount %" := 0;
                                Evaluate(PaymentSales."Discount Date Calculation", '<0D>');
                                PaymentSales."Due Date" := GenJnlLine."Posting Date"
                            end else begin
                                PaymentSales."Pmt. Discount Date" := CalcDate(PaymentTermsLine."Discount Date Calculation", GenJnlLine."Document Date");
                                if PaymentSales."Pmt. Discount Date" < GenJnlLine."Document Date" then
                                    PaymentSales."Pmt. Discount Date" := GenJnlLine."Document Date";
                            end;

                            PaymentSales.Insert();

                        end;
                    until PaymentTermsLine.Next() = 0;
            end;
        end;
    end;
    #endregion 222
}