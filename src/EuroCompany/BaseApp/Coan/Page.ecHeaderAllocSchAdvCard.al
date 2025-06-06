#pragma warning disable AW0006, AA0205

namespace EuroCompany.BaseApp.Coan;
using EuroCompany.BaseApp.Manufacturing.Capacity;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.WorkCenter;
using Microsoft.Finance.Dimension;

page 50068 "ecHeader Alloc. Sch. Adv. Card"
{
    PageType = Document;
    UsageCategory = Administration;
    SourceTable = "ecHeader Alloc. Scheme Advanc.";
    Caption = 'Header Allocation Schema Advanced';
    Extensible = true;
    Editable = true;

    layout
    {
        area(Content)
        {
            Group(GroupName)
            {
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Calculation Type"; Rec."Calculation Type")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
            }
            part(ecLineAllocSchemeAdv; ecLineAllocSchemeAdv)
            {
                ApplicationArea = All;
                SubPageLink = "Allocation Method" = field("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewLine)
            {
                ApplicationArea = All;
                Caption = 'Suggest Workcenter Area';
                Image = WorkCenter;

                trigger OnAction()
                begin
                    AddNewLine();
                    CurrPage.Update();
                end;
            }
        }

        area(Promoted)
        {
            actionref(NewLine_Promoted; NewLine)
            {
            }
        }
    }

    procedure AddNewLine()
    var
        WorkCenter: Record "Work Center";
        LineAllocSchemeAdv: Record "ecLine Alloc. Scheme Adv.";
    begin
        WorkCenter.Reset();
        WorkCenter.FindSet();
        repeat
            LineAllocSchemeAdv.Init();
            LineAllocSchemeAdv.Validate("Allocation Method", Rec."No.");
            LineAllocSchemeAdv.Validate("Work Center No.", WorkCenter."No.");
            LineAllocSchemeAdv.Insert(true);
        // LineAllocSchemeAdv.Modify(true);
        until WorkCenter.Next() = 0;
    end;
}


