namespace EuroCompany.BaseApp.Coan;
using EuroCompany.BaseApp.Manufacturing.Capacity;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.WorkCenter;
using Microsoft.Finance.Dimension;

page 50067 "ecHeader Alloc. Sch. Advanc."
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ecHeader Alloc. Scheme Advanc.";
    Caption = 'Header Allocation Schema Advanced list';
    CardPageId = "ecHeader Alloc. Sch. Adv. Card";
    Extensible = true;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                Caption = '', Locked = true;

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
                }
            }
        }
    }
}