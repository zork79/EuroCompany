namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Manufacturing.Document;
using System.Utilities;

report 50009 "ecCalc. Prod. Ord. Line Seq."
{
    ApplicationArea = All;
    Caption = 'Calc. Prod. Order Line sequence';
    Description = 'CS_PRO_018';
    ProcessingOnly = true;
    UsageCategory = None;

    dataset
    {
        dataitem(ProdOrderLineLoop; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending);

            trigger OnPreDataItem()
            begin
                if ProdOrderLine.IsEmpty then CurrReport.Break();
                ProdOrderLineLoop.SetRange(Number, 1, ProdOrderLine.Count);
            end;

            trigger OnAfterGetRecord()
            begin
                if (ProdOrderLineLoop.Number = 1) then begin
                    ProdOrderLine.FindSet();
                end else begin
                    ProdOrderLine.Next();
                end;

                ProdOrderLine."ecScheduling Sequence" := StartingSequence;
                StartingSequence := ProdOrderLine."ecScheduling Sequence" + Step;
                ProdOrderLine."ecScheduling User" := UserId;
                ProdOrderLine.Modify(false);
                Commit();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Settings)
                {
                    Caption = 'Parameters';

                    field(StartingSequenceField; StartingSequence)
                    {
                        ApplicationArea = All;
                        Caption = 'Starting sequence';
                        MinValue = 0;
                    }
                    field(StepField; Step)
                    {
                        ApplicationArea = All;
                        Caption = 'Step';
                        MinValue = 10;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            StartingSequence := 10;
            Step := 10;
        end;
    }

    var
        ProdOrderLine: Record "Prod. Order Line";
        Step: Integer;
        StartingSequence: Integer;

    internal procedure SetProdOrderLines(var pProdOrderLine: Record "Prod. Order Line")
    begin
        ProdOrderLine.Copy(pProdOrderLine);
    end;
}
