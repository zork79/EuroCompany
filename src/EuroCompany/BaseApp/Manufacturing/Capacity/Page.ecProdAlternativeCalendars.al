namespace EuroCompany.BaseApp.Manufacturing.Capacity;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.WorkCenter;

page 50002 "ecProd. Alternative Calendars"
{
    ApplicationArea = All;
    Caption = 'Prod. Alternative Calendars';
    DelayedInsert = true;
    Description = 'CS_PRO_018';
    PageType = List;
    SourceTable = "ecProd. Alternative Calendar";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Work Center No."; Rec."Work Center No.")
                {
                }
                field("Machine Center No."; Rec."Machine Center No.")
                {
                }
                field("Alternative Shop Calendar Code"; Rec."Alternative Shop Calendar Code")
                {
                }
                field("Period Starting Date"; Rec."Period Starting Date")
                {
                }
                field("Period Ending Date"; Rec."Period Ending Date")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CalculateWorkCenterCalendar)
            {
                Caption = 'Calc. Work center calendar';
                Image = WorkCenter;

                trigger OnAction()
                var
                    lWorkCenter: Record "Work Center";
                    lCalculateWorkCenterCalendar: Report "Calculate Work Center Calendar";
                begin
                    Clear(lWorkCenter);
                    lWorkCenter.SetRange("No.", Rec."Work Center No.");
                    Clear(lCalculateWorkCenterCalendar);
                    lCalculateWorkCenterCalendar.InitializeRequest(Rec."Period Starting Date", Rec."Period Ending Date");
                    lCalculateWorkCenterCalendar.SetTableView(lWorkCenter);
                    lCalculateWorkCenterCalendar.RunModal();
                end;
            }
            action(CalculateMachineCenterCalendar)
            {
                Caption = 'Calc. Machine center calendar';
                Image = MachineCenter;

                trigger OnAction()
                var
                    lMachineCenter: Record "Machine Center";
                    lCalcMachineCenterCalendar: Report "Calc. Machine Center Calendar";
                begin
                    Clear(lMachineCenter);
                    if (Rec."Work Center No." <> '') then begin
                        lMachineCenter.SetRange("Work Center No.", Rec."Work Center No.");
                    end;
                    if (Rec."Machine Center No." <> '') then begin
                        lMachineCenter.SetRange("No.", Rec."Machine Center No.");
                    end;
                    Clear(lCalcMachineCenterCalendar);
                    lCalcMachineCenterCalendar.InitializeRequest(Rec."Period Starting Date", Rec."Period Ending Date");
                    lCalcMachineCenterCalendar.SetTableView(lMachineCenter);
                    lCalcMachineCenterCalendar.RunModal();
                end;
            }
        }

        area(Promoted)
        {
            actionref(CalculateWorkCenterCalendar_Promoted; CalculateWorkCenterCalendar) { }
            actionref(CalculateMachineCenterCalendar_Promoted; CalculateMachineCenterCalendar) { }
        }
    }
}
