namespace EuroCompany.BaseApp.Finance.VAT.Reporting;

using EuroCompany.BaseApp.Finance.VAT.Ledger;
using Microsoft.Finance.VAT.Reporting;
reportextension 80007 "MAdv Fin. Rp. VAT Resume OSS" extends "APsAdvFinRpVAT - Resume"
{
    dataset
    {
        modify(Total)
        {
            trigger OnAfterAfterGetRecord()
            var
                PeriodicVAT: Record "Periodic Settlement VAT Entry";
            begin
                if solooss then begin
                    PeriodicOSSVAT.SetRange("VAT Period", Format(StartDate, 7, '<Year4>/<Month,2>'), Format(EndDate, 7, '<Year4>/<Month,2>'));
                    FirstOSS := true;
                    if PeriodicOSSVAT.FindSet() then
                        repeat
                            CompAmtOSS := CompAmtOSS + PeriodicOSSVAT."Credit VAT Compensation";
                            AdvAmtOSS := AdvAmtOSS + PeriodicOSSVAT."Advanced Amount";
                        until PeriodicOSSVAT.Next() = 0;

                    CompAmt := CompAmtOSS;
                    AdvAmt := AdvAmtOSS;

                    PeriodicOSSVAT.SetRange("VAT Period", Format(StartDate, 7, '<Year4>/<Month,2>'), Format(EndDate, 7, '<Year4>/<Month,2>'));
                    if not PeriodicOSSVAT.FindFirst() then
                        PeriodicOSSVAT.Init();

                    if PurchVATAmt > 0 then
                        UndedVATAmt2 := Round(PurchVATAmt * (100 - DedPercVAT) / 100, 0.01);

                    if DedPercVAT = 0 then
                        UndedVATAmt2 := 0;

                    if PeriodicOSSVAT."Prior Period Input VAT" <> 0 then
                        PriorPeriodVAT := PeriodicOSSVAT."Prior Period Input VAT"
                    else
                        PriorPeriodVAT := -(PeriodicOSSVAT."Prior Period Output VAT");

                end else begin
                    PeriodicVAT.SetRange("VAT Period", Format(StartDate, 7, '<Year4>/<Month,2>'), Format(EndDate, 7, '<Year4>/<Month,2>'));
                    if not PeriodicVAT.FindFirst() then
                        PeriodicVAT.Init();
                    PriorPeriodVAT := PeriodicVAT."Prior Period Input VAT";
                end;

                VatPaymentAmt := ReqPayedAmt;
            end;
        }
        modify(VatId1) //Vendite
        {
            trigger OnBeforeAfterGetRecord()
            begin
                VatId1."ecReport Filter Only OSS" := solooss;
                VatId1.Modify();
            end;

            trigger OnAfterAfterGetRecord()
            begin
                VatId1."ecReport Filter Only OSS" := false;
                VatId1.Modify();
            end;
        }
        modify(VatId2) //Acquisti
        {
            trigger OnBeforeAfterGetRecord()
            begin
                VatId2."ecReport Filter Only OSS" := solooss;
                VatId2.Modify();
            end;

            trigger OnAfterAfterGetRecord()
            begin
                VatId2."ecReport Filter Only OSS" := false;
                VatId2.Modify();
            end;
        }
    }

    requestpage
    {
        layout
        {
            addlast(content)
            {
                field(AltIMsolooss; solooss)
                {
                    ApplicationArea = All;
                    Caption = 'Solo OSS';
                }
                field(AltIMReqPayedAmt; ReqPayedAmt)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Payed VAT Amount';
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if solooss then begin
            TitleTxt := TitleOSSTxt;
            SalesResumeTxt := SalesResumeOSSTxt;
            PurchResumeTxt := PurchResumeOSSTxt;
        end;
    end;

    var
        PeriodicOSSVAT: Record "ecPeriodic OSS Sett. VAT Entry";
        solooss: Boolean;
        FirstOSS: Boolean;
        ReqPayedAmt: Decimal;
        PriorPeriodVAT: Decimal;
        CompAmtOSS: Decimal;
        AdvAmtOSS: Decimal;
        TitleOSSTxt: Label 'VAT OSS RESUME TO';
        SalesResumeOSSTxt: Label 'SALES OSS RESUME';
        PurchResumeOSSTxt: Label 'PURCHASE OSS RESUME';
}
