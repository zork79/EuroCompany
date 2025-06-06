#pragma warning disable AA0205
namespace EuroCompany.BaseApp.Coan;
using Microsoft.Finance.Dimension;

report 50032 ecCalculateSchema

{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Analyze';
    UseRequestPage = true;

    dataset
    {
        dataitem(Integer; System.Utilities.Integer)
        {
            DataItemTableView = sorting(Number) where(Number = filter(1));

            trigger OnAfterGetRecord()
            begin
                //Add record
                if AddedRecord then begin

                    OutputQuantityArea := 0;
                    OutputQuantityTot := 0;
                    WorkTimeArea := 0;
                    WorkTimeTot := 0;
                    LineAllocSchemeAdv.SetCurrentKey("Allocation Method", "Line No.", "Work Center No.");
                    LineAllocSchemeAdv.SetRange("Work Center No.", WorkCenter);
                    if LineAllocSchemeAdv.FindSet() then
                        repeat
                            CostAllSchforPrdArea."Capacity Type" := CostAllSchforPrdArea."Capacity Type"::"Work Center";
                            CostAllSchforPrdArea."Allocation Method" := LineAllocSchemeAdv."Allocation Method";
                            CostAllSchforPrdArea."Work Center No." := LineAllocSchemeAdv."Work Center No.";
                            CostAllSchforPrdArea.Code := LineAllocSchemeAdv."Allocation Method";

                            if HeaderAllocSchemeAdvanc.Get(LineAllocSchemeAdv."Allocation Method") then
                                case HeaderAllocSchemeAdvanc."Calculation Type" of
                                    HeaderAllocSchemeAdvanc."Calculation Type"::"% Weight":
                                        begin
                                            // 0 Values
                                            CostAllSchforPrdArea."Budget Amount" := 0;
                                            CostAllSchforPrdArea."Amount C/G" := 0;
                                            CostAllSchforPrdArea."Worked Time Real" := 0;
                                            CostAllSchforPrdArea."Worked Time Budget" := 0;
                                            CostAllSchforPrdArea."Rate Bdg" := 0;
                                            CostAllSchforPrdArea."Rate G/L" := 0;
                                            // 0 Values

                                            CostAllSchforPrdArea."Budget Amount" := ((CoanAdvCalculations.CalcBalanceCDC(DateFilter, LineAllocSchemeAdv."Work center Dim. value Code", CostAllSchforPrdArea."Center Cost Dim value Code")) * LineAllocSchemeAdv."Weight %") / 100;
                                            CostAllSchforPrdArea."Amount C/G" := ((CoanAdvCalculations.CalcForBalanceMovementGL(DateFilter, LineAllocSchemeAdv."Work center Dim. value Code", CostAllSchforPrdArea."Center Cost Dim value Code")) * LineAllocSchemeAdv."Weight %") / 100;
                                            CostAllSchforPrdArea."Worked Time Real" := CoanAdvCalculations.CalcForWorkingMinutes(DateFilter, WorkCenter);

                                            //Added
                                            CostAllSchforPrdArea."Worked Time Budget" := LineAllocSchemeAdv."Worked Time Budget";
                                            //Added

                                            if LineAllocSchemeAdv."Worked Time Budget" > 0 then
                                                CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount" / LineAllocSchemeAdv."Worked Time Budget"
                                            else
                                                CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount";

                                            CostAllSchforPrdArea."Rate G/L" := CostAllSchforPrdArea."Amount C/G" / CostAllSchforPrdArea."Worked Time Real";
                                        end;

                                    HeaderAllocSchemeAdvanc."Calculation Type"::"KG Products":
                                        begin
                                            // 0 Values
                                            CostAllSchforPrdArea."Budget Amount" := 0;
                                            CostAllSchforPrdArea."Amount C/G" := 0;
                                            CostAllSchforPrdArea."Worked Time Real" := 0;
                                            CostAllSchforPrdArea."Worked Time Budget" := 0;
                                            CostAllSchforPrdArea."Rate Bdg" := 0;
                                            CostAllSchforPrdArea."Rate G/L" := 0;
                                            // 0 Values

                                            OutputQuantityArea := CoanAdvCalculations.CalcForKGProducts(DateFilter, WorkCenter);
                                            OutputQuantityTot := CoanAdvCalculations.CalcForKGProducts(DateFilter, '');
                                            LineAllocSchemeAdv."Weight %" := (OutputQuantityArea / OutputQuantityTot) * 100;
                                            LineAllocSchemeAdv.Modify(false);
                                            CostAllSchforPrdArea."Worked Time Real" := CoanAdvCalculations.CalcForWorkingMinutes(DateFilter, WorkCenter);
                                            CostAllSchforPrdArea."Budget Amount" := ((CoanAdvCalculations.CalcBalanceCDC(DateFilter, LineAllocSchemeAdv."Work center Dim. value Code", CostAllSchforPrdArea."Center Cost Dim value Code")) * LineAllocSchemeAdv."Weight %") / 100;
                                            CostAllSchforPrdArea."Amount C/G" := ((CoanAdvCalculations.CalcForBalanceMovementGL(DateFilter, LineAllocSchemeAdv."Work center Dim. value Code", CostAllSchforPrdArea."Center Cost Dim value Code")) * LineAllocSchemeAdv."Weight %") / 100;

                                            //Added
                                            CostAllSchforPrdArea."Worked Time Budget" := LineAllocSchemeAdv."Worked Time Budget";
                                            //Added

                                            if LineAllocSchemeAdv."Worked Time Budget" > 0 then
                                                CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount" / LineAllocSchemeAdv."Worked Time Budget"
                                            else
                                                CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount";
                                            CostAllSchforPrdArea."Rate G/L" := CostAllSchforPrdArea."Amount C/G" / CostAllSchforPrdArea."Worked Time Real";

                                        end;

                                    HeaderAllocSchemeAdvanc."Calculation Type"::Kilovators:
                                        begin
                                            // 0 Values
                                            CostAllSchforPrdArea."Budget Amount" := 0;
                                            CostAllSchforPrdArea."Amount C/G" := 0;
                                            CostAllSchforPrdArea."Worked Time Real" := 0;
                                            CostAllSchforPrdArea."Worked Time Budget" := 0;
                                            CostAllSchforPrdArea."Rate Bdg" := 0;
                                            CostAllSchforPrdArea."Rate G/L" := 0;
                                            // 0 Values

                                            LineAllocSchemeAdv."Weight %" := (LineAllocSchemeAdv.Kilowatt / CoanAdvCalculations.CalckiloWatt()) * 100;
                                            LineAllocSchemeAdv.Modify(false);
                                            CostAllSchforPrdArea."Worked Time Real" := CoanAdvCalculations.CalcForWorkingMinutes(DateFilter, WorkCenter);
                                            CostAllSchforPrdArea."Budget Amount" := ((CoanAdvCalculations.CalcBalanceCDC(DateFilter, LineAllocSchemeAdv."Work center Dim. value Code", CostAllSchforPrdArea."Center Cost Dim value Code")) * LineAllocSchemeAdv."Weight %") / 100;
                                            CostAllSchforPrdArea."Amount C/G" := ((CoanAdvCalculations.CalcForBalanceMovementGL(DateFilter, LineAllocSchemeAdv."Work center Dim. value Code", CostAllSchforPrdArea."Center Cost Dim value Code")) * LineAllocSchemeAdv."Weight %") / 100;

                                            //Added
                                            CostAllSchforPrdArea."Worked Time Budget" := LineAllocSchemeAdv."Worked Time Budget";
                                            //Added

                                            if LineAllocSchemeAdv."Worked Time Budget" > 0 then
                                                CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount" / LineAllocSchemeAdv."Worked Time Budget"
                                            else
                                                CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount";
                                            CostAllSchforPrdArea."Rate G/L" := CostAllSchforPrdArea."Amount C/G" / CostAllSchforPrdArea."Worked Time Real";
                                        end;

                                    HeaderAllocSchemeAdvanc."Calculation Type"::"Minutes of work":
                                        begin
                                            // 0 Values
                                            CostAllSchforPrdArea."Budget Amount" := 0;
                                            CostAllSchforPrdArea."Amount C/G" := 0;
                                            CostAllSchforPrdArea."Worked Time Real" := 0;
                                            CostAllSchforPrdArea."Worked Time Budget" := 0;
                                            CostAllSchforPrdArea."Rate Bdg" := 0;
                                            CostAllSchforPrdArea."Rate G/L" := 0;
                                            // 0 Values

                                            if CoanSetup.Get() then
                                                if DimensionValue.Get(CoanSetup."Dimension 1 code", WorkCenter) then
                                                    WorkTimeArea := CoanAdvCalculations.CalcForWorkingMinutes(DateFilter, WorkCenter);

                                            WorkTimeTot := CoanAdvCalculations.CalcForWorkingMinutes(DateFilter, '');
                                            LineAllocSchemeAdv."Weight %" := (WorkTimeArea / WorkTimeTot) * 100;
                                            LineAllocSchemeAdv.Modify(false);
                                            CostAllSchforPrdArea."Worked Time Real" := CoanAdvCalculations.CalcForWorkingMinutes(DateFilter, WorkCenter);
                                            CostAllSchforPrdArea."Budget Amount" := ((CoanAdvCalculations.CalcBalanceCDC(DateFilter, LineAllocSchemeAdv."Work center Dim. value Code", CostAllSchforPrdArea."Center Cost Dim value Code")) * LineAllocSchemeAdv."Weight %") / 100;
                                            CostAllSchforPrdArea."Amount C/G" := ((CoanAdvCalculations.CalcForBalanceMovementGL(DateFilter, LineAllocSchemeAdv."Work center Dim. value Code", CostAllSchforPrdArea."Center Cost Dim value Code")) * LineAllocSchemeAdv."Weight %") / 100;

                                            //Added
                                            CostAllSchforPrdArea."Worked Time Budget" := LineAllocSchemeAdv."Worked Time Budget";
                                            //Added

                                            if LineAllocSchemeAdv."Worked Time Budget" > 0 then
                                                CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount" / LineAllocSchemeAdv."Worked Time Budget"
                                            else
                                                CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount";
                                            CostAllSchforPrdArea."Rate G/L" := CostAllSchforPrdArea."Amount C/G" / CostAllSchforPrdArea."Worked Time Real";
                                        end;
                                end;

                            CostAllSchforPrdArea.Insert(false);

                        until LineAllocSchemeAdv.Next() = 0;

                end else begin
                    //modify
                    OutputQuantityArea := 0;
                    OutputQuantityTot := 0;
                    WorkTimeArea := 0;
                    WorkTimeTot := 0;
                    CostAllSchforPrdArea.Reset();
                    CostAllSchforPrdArea.SetRange("Work Center No.", WorkCenter);
                    if CostAllSchforPrdArea.FindSet() then
                        repeat
                            //Step1 cerca per schema allocazione
                            if CostAllSchforPrdArea."Cost Calculation Method" = CostAllSchforPrdArea."Cost Calculation Method"::Automatic then begin
                                if HeaderAllocSchemeAdvanc.Get(CostAllSchforPrdArea."Allocation Method") then begin
                                    LineAllocSchemeAdv.SetRange("Allocation Method", CostAllSchforPrdArea."Allocation Method");
                                    LineAllocSchemeAdv.SetRange("Work Center No.", CostAllSchforPrdArea."Work Center No.");
                                    if LineAllocSchemeAdv.FindFirst() then
                                        case HeaderAllocSchemeAdvanc."Calculation Type" of
                                            HeaderAllocSchemeAdvanc."Calculation Type"::"% Weight":
                                                begin
                                                    // 0 Values
                                                    CostAllSchforPrdArea."Budget Amount" := 0;
                                                    CostAllSchforPrdArea."Amount C/G" := 0;
                                                    CostAllSchforPrdArea."Worked Time Real" := 0;
                                                    CostAllSchforPrdArea."Worked Time Budget" := 0;
                                                    CostAllSchforPrdArea."Rate Bdg" := 0;
                                                    CostAllSchforPrdArea."Rate G/L" := 0;
                                                    // 0 Values

                                                    CostAllSchforPrdArea."Budget Amount" := ((CoanAdvCalculations.CalcBalanceCDC(DateFilter, LineAllocSchemeAdv."Work center Dim. value Code", CostAllSchforPrdArea."Center Cost Dim value Code")) * LineAllocSchemeAdv."Weight %") / 100;
                                                    CostAllSchforPrdArea."Amount C/G" := 0;
                                                    CostAllSchforPrdArea."Amount C/G" := ((CoanAdvCalculations.CalcForBalanceMovementGL(DateFilter, LineAllocSchemeAdv."Work center Dim. value Code", CostAllSchforPrdArea."Center Cost Dim value Code")) * LineAllocSchemeAdv."Weight %") / 100;
                                                    CostAllSchforPrdArea."Worked Time Real" := CoanAdvCalculations.CalcForWorkingMinutes(DateFilter, WorkCenter);

                                                    //Added
                                                    CostAllSchforPrdArea."Worked Time Budget" := LineAllocSchemeAdv."Worked Time Budget";
                                                    //Added

                                                    if LineAllocSchemeAdv."Worked Time Budget" > 0 then
                                                        CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount" / LineAllocSchemeAdv."Worked Time Budget"
                                                    else
                                                        CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount";
                                                    CostAllSchforPrdArea."Rate G/L" := CostAllSchforPrdArea."Amount C/G" / CostAllSchforPrdArea."Worked Time Real";
                                                end;

                                            HeaderAllocSchemeAdvanc."Calculation Type"::"KG Products":
                                                begin
                                                    // 0 Values
                                                    CostAllSchforPrdArea."Budget Amount" := 0;
                                                    CostAllSchforPrdArea."Amount C/G" := 0;
                                                    CostAllSchforPrdArea."Worked Time Real" := 0;
                                                    CostAllSchforPrdArea."Worked Time Budget" := 0;
                                                    CostAllSchforPrdArea."Rate Bdg" := 0;
                                                    CostAllSchforPrdArea."Rate G/L" := 0;
                                                    // 0 Values

                                                    OutputQuantityArea := CoanAdvCalculations.CalcForKGProducts(DateFilter, WorkCenter);
                                                    OutputQuantityTot := CoanAdvCalculations.CalcForKGProducts(DateFilter, '');
                                                    LineAllocSchemeAdv."Weight %" := (OutputQuantityArea / OutputQuantityTot) * 100;
                                                    LineAllocSchemeAdv.Modify(false);
                                                    CostAllSchforPrdArea."Worked Time Real" := CoanAdvCalculations.CalcForWorkingMinutes(DateFilter, WorkCenter);
                                                    CostAllSchforPrdArea."Budget Amount" := ((CoanAdvCalculations.CalcBalanceCDC(DateFilter, LineAllocSchemeAdv."Work center Dim. value Code", CostAllSchforPrdArea."Center Cost Dim value Code")) * LineAllocSchemeAdv."Weight %") / 100;
                                                    CostAllSchforPrdArea."Amount C/G" := ((CoanAdvCalculations.CalcForBalanceMovementGL(DateFilter, LineAllocSchemeAdv."Work center Dim. value Code", CostAllSchforPrdArea."Center Cost Dim value Code")) * LineAllocSchemeAdv."Weight %") / 100;

                                                    //Added
                                                    CostAllSchforPrdArea."Worked Time Budget" := LineAllocSchemeAdv."Worked Time Budget";
                                                    //Added

                                                    if LineAllocSchemeAdv."Worked Time Budget" > 0 then
                                                        CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount" / LineAllocSchemeAdv."Worked Time Budget"
                                                    else
                                                        CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount";
                                                    CostAllSchforPrdArea."Rate G/L" := CostAllSchforPrdArea."Amount C/G" / CostAllSchforPrdArea."Worked Time Real";

                                                end;

                                            HeaderAllocSchemeAdvanc."Calculation Type"::Kilovators:
                                                begin
                                                    // 0 Values
                                                    CostAllSchforPrdArea."Budget Amount" := 0;
                                                    CostAllSchforPrdArea."Amount C/G" := 0;
                                                    CostAllSchforPrdArea."Worked Time Real" := 0;
                                                    CostAllSchforPrdArea."Worked Time Budget" := 0;
                                                    CostAllSchforPrdArea."Rate Bdg" := 0;
                                                    CostAllSchforPrdArea."Rate G/L" := 0;
                                                    // 0 Values

                                                    LineAllocSchemeAdv."Weight %" := (LineAllocSchemeAdv.Kilowatt / CoanAdvCalculations.CalckiloWatt()) * 100;
                                                    LineAllocSchemeAdv.Modify(false);
                                                    CostAllSchforPrdArea."Worked Time Real" := CoanAdvCalculations.CalcForWorkingMinutes(DateFilter, WorkCenter);
                                                    CostAllSchforPrdArea."Budget Amount" := ((CoanAdvCalculations.CalcBalanceCDC(DateFilter, LineAllocSchemeAdv."Work center Dim. value Code", CostAllSchforPrdArea."Center Cost Dim value Code")) * LineAllocSchemeAdv."Weight %") / 100;
                                                    CostAllSchforPrdArea."Amount C/G" := ((CoanAdvCalculations.CalcForBalanceMovementGL(DateFilter, LineAllocSchemeAdv."Work center Dim. value Code", CostAllSchforPrdArea."Center Cost Dim value Code")) * LineAllocSchemeAdv."Weight %") / 100;

                                                    //Added
                                                    CostAllSchforPrdArea."Worked Time Budget" := LineAllocSchemeAdv."Worked Time Budget";
                                                    //Added

                                                    if LineAllocSchemeAdv."Worked Time Budget" > 0 then
                                                        CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount" / LineAllocSchemeAdv."Worked Time Budget"
                                                    else
                                                        CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount";
                                                    CostAllSchforPrdArea."Rate G/L" := CostAllSchforPrdArea."Amount C/G" / CostAllSchforPrdArea."Worked Time Real";
                                                end;

                                            HeaderAllocSchemeAdvanc."Calculation Type"::"Minutes of work":
                                                begin
                                                    // 0 Values
                                                    CostAllSchforPrdArea."Budget Amount" := 0;
                                                    CostAllSchforPrdArea."Amount C/G" := 0;
                                                    CostAllSchforPrdArea."Worked Time Real" := 0;
                                                    CostAllSchforPrdArea."Worked Time Budget" := 0;
                                                    CostAllSchforPrdArea."Rate Bdg" := 0;
                                                    CostAllSchforPrdArea."Rate G/L" := 0;
                                                    // 0 Values

                                                    if CoanSetup.Get() then
                                                        if DimensionValue.Get(CoanSetup."Dimension 1 code", WorkCenter) then
                                                            WorkTimeArea := CoanAdvCalculations.CalcForWorkingMinutes(DateFilter, WorkCenter);

                                                    WorkTimeTot := CoanAdvCalculations.CalcForWorkingMinutes(DateFilter, '');

                                                    //LineAllocSchemeAdv."Weight %" := (WorkTimeArea / WorkTimeTot) * 100;
                                                    LineAllocSchemeAdv."Weight %" := (WorkTimeArea / WorkTimeArea) * 100;

                                                    LineAllocSchemeAdv.Modify(false);
                                                    CostAllSchforPrdArea."Worked Time Real" := CoanAdvCalculations.CalcForWorkingMinutes(DateFilter, WorkCenter);
                                                    CostAllSchforPrdArea."Budget Amount" := ((CoanAdvCalculations.CalcBalanceCDC(DateFilter, LineAllocSchemeAdv."Work center Dim. value Code", CostAllSchforPrdArea."Center Cost Dim value Code")) * LineAllocSchemeAdv."Weight %") / 100;
                                                    CostAllSchforPrdArea."Amount C/G" := ((CoanAdvCalculations.CalcForBalanceMovementGL(DateFilter, LineAllocSchemeAdv."Work center Dim. value Code", CostAllSchforPrdArea."Center Cost Dim value Code")) * LineAllocSchemeAdv."Weight %") / 100;

                                                    //Added
                                                    CostAllSchforPrdArea."Worked Time Budget" := LineAllocSchemeAdv."Worked Time Budget";
                                                    //Added

                                                    if LineAllocSchemeAdv."Worked Time Budget" > 0 then
                                                        CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount" / LineAllocSchemeAdv."Worked Time Budget"
                                                    else
                                                        CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount";
                                                    CostAllSchforPrdArea."Rate G/L" := CostAllSchforPrdArea."Amount C/G" / CostAllSchforPrdArea."Worked Time Real";
                                                end;
                                        end;

                                    CostAllSchforPrdArea.Modify(false);

                                end;
                            end else begin
                                //Step 2 Non automatico-Manauale

                                /*CostAllSchforPrdArea."Budget Amount" := (CoanAdvCalculations.CalcBalanceCDC(DateFilter, '', CostAllSchforPrdArea."Center Cost Dim value Code")) * CostAllSchforPrdArea.Rate;
                                CostAllSchforPrdArea."Amount C/G" := (CoanAdvCalculations.CalcForBalanceMovementGL(DateFilter, '', CostAllSchforPrdArea."Center Cost Dim value Code")) * CostAllSchforPrdArea.Rate;
                                CostAllSchforPrdArea."Worked Time Real" := CoanAdvCalculations.CalcForWorkingMinutes(DateFilter, WorkCenter);

                                //Added
                                CostAllSchforPrdArea."Worked Time Budget" := LineAllocSchemeAdv."Worked Time Budget";
                                //Added

                                if LineAllocSchemeAdv."Worked Time Budget" > 0 then
                                    CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount" / LineAllocSchemeAdv."Worked Time Budget"
                                else
                                    CostAllSchforPrdArea."Rate Bdg" := CostAllSchforPrdArea."Budget Amount";
                                CostAllSchforPrdArea."Rate G/L" := CostAllSchforPrdArea."Amount C/G" / CostAllSchforPrdArea."Worked Time Real";
                                */

                                // 0 Values
                                CostAllSchforPrdArea."Budget Amount" := 0;
                                CostAllSchforPrdArea."Amount C/G" := 0;
                                CostAllSchforPrdArea."Worked Time Real" := 0;
                                CostAllSchforPrdArea."Worked Time Budget" := 0;
                                CostAllSchforPrdArea."Rate Bdg" := 0;
                                CostAllSchforPrdArea."Rate G/L" := 0;
                                // 0 Values

                                CostAllSchforPrdArea.Modify(false);
                            end;

                        until CostAllSchforPrdArea.Next() = 0;
                end;
            end;

            trigger OnPreDataItem()
            var
                Errorlbl: Label 'Error, Compile date filter';
            begin
                CostAllSchforPrdArea.Reset();
                CostAllSchforPrdArea.SetRange("Work Center No.", WorkCenter);

                DateFilter := '';
                if ToDateInput <> 0D then
                    DateFilter := Format(FromDateInput) + '..' + format(ToDateInput)
                else
                    DateFilter := Format(FromDateInput);

                if DateFilter = '' then
                    Error(Errorlbl);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    Caption = 'Filter';

                    /*field(DateFilter; DateFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Date Filter';
                    }*/

                    field(FromDate; FromDateInput)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';

                    }
                    field(ToDate; ToDateInput)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';

                    }
                    field(AddRecord; AddedRecord)
                    {
                        ApplicationArea = All;
                        Caption = 'Add record';
                    }
                }
            }
        }
        trigger OnOpenPage()
        begin
            AddedRecord := false;
        end;
    }

    var
        DimensionValue: Record "Dimension Value";
        CoanSetup: Record "ecCoan Custom Setup";
        HeaderAllocSchemeAdvanc: Record "ecHeader Alloc. Scheme Advanc.";
        CostAllSchforPrdArea: Record "ecCost All. Sch. for Prd. Area";
        LineAllocSchemeAdv: Record "ecLine Alloc. Scheme Adv.";
        CoanAdvCalculations: Codeunit CoanAdvCalculations;

        //DateFilter: Text[50];
        //Added
        //DateDateFilter: Date;
        DateFilter: text[50];
        FromDateInput: Date;
        ToDateInput: Date;
        //Added

        AddedRecord: Boolean;
        WorkCenter: Code[20];
        OutputQuantityArea: Decimal;
        OutputQuantityTot: Decimal;
        WorkTimeArea: Decimal;
        WorkTimeTot: Decimal;

    procedure SetWorkCenterNo(parWorkcenterno: Code[20])
    begin
        WorkCenter := parWorkcenterno;
    end;
}