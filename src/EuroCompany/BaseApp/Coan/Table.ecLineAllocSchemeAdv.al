
namespace EuroCompany.BaseApp.Coan;
using EuroCompany.BaseApp.Manufacturing.Capacity;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.WorkCenter;
using Microsoft.Finance.Dimension;

table 50042 "ecLine Alloc. Scheme Adv."
{
    Caption = 'Line Allocation Schema Advanced';
    DataClassification = CustomerContent;
    Description = 'CS_AFC_004';
    Extensible = true;

    fields
    {
        field(1; "Allocation Method"; Code[20])
        {
            Caption = 'Allocation Method';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
            tableRelation = "ecHeader Alloc. Scheme Advanc."."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
        }
        field(3; "Work Center No."; code[20])
        {
            Caption = 'Work Center No.';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
            tableRelation = "Work Center"."No.";
        }
        field(4; "Weight %"; Decimal)
        {
            Caption = '"Weight %';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
        }
        field(5; Kilowatt; Decimal)
        {
            Caption = 'Kilowatt';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
        }
        field(6; "Worked Time Budget"; Decimal)
        {
            Caption = 'Worked Time Budget';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
        }
        field(7; "Work center Dim. value Code"; Code[20])
        {
            Caption = 'Work center Dimension value Code';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
        }
        field(8; "Calculation Type"; Option)
        {
            Caption = 'Calculation Type';
            Description = 'CS_AFC_004';
            OptionMembers = "% Weight","KG Products","Kilovators","Minutes of work";
            FieldClass = FlowField;
            CalcFormula = lookup("ecHeader Alloc. Scheme Advanc."."Calculation Type" where("No." = field("Allocation Method")));

        }
    }

    keys
    {
        key(PK; "Allocation Method", "Line No.", "Work Center No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Rec."Line No." := GetNextLineNo();
    end;

    procedure GetNextLineNo() newIDLine: Integer
    var
        //Changed
        ecLineAllocSchemeAdv: Record "ecLine Alloc. Scheme Adv.";
    //Changed
    begin
        newIDLine := 0;
        ecLineAllocSchemeAdv.Reset();
        ecLineAllocSchemeAdv.SetRange("Allocation Method", Rec."Allocation Method");
        if ecLineAllocSchemeAdv.FindLast() then
            newIDLine := ecLineAllocSchemeAdv."Line No." + 10000
        else
            newIDLine := 10000;

    end;
}