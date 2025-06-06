namespace EuroCompany.BaseApp.Coan;
using EuroCompany.BaseApp.Manufacturing.Capacity;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.WorkCenter;
using Microsoft.Finance.Dimension;

table 50040 "ecCost All. Sch. for Prd. Area"
{
    Caption = 'Cost Allocation Schema for Production Area';
    DataClassification = CustomerContent;
    Description = 'CS_AFC_004';
    Extensible = true;

    fields
    {
        field(1; "Capacity Type"; Option)
        {
            Caption = 'Capacity Type';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
            OptionMembers = "Work Center";
        }
        field(2; "Work Center No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
            TableRelation = "Work Center"."No.";
        }
        field(3; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
        }
        field(5; "Cost Calculation Method"; Option)
        {
            Caption = 'Cost Calculation Method';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
            optionMembers = Manual,Automatic;
            OptionCaption = 'Manual,Automatic';

            trigger OnValidate()
            begin
                if Rec."Cost Calculation Method" = Rec."Cost Calculation Method"::Automatic then
                    Rec.Rate := 0
                else begin //Manual
                    Rec."Allocation Method" := '';
                    //Added
                    Rec.Rate := 0;
                    Rec."Center Cost Dim value Code" := '';
                    Rec."Worked Time Budget" := 0;
                    Rec."Budget Amount" := 0;
                    Rec."Rate Bdg" := 0;
                    Rec."Amount C/G" := 0;
                    Rec."Amount Simulated" := 0;
                    Rec."Amount C/G +Sim" := 0;
                    Rec."Worked Time Real" := 0;
                    Rec."Rate G/L" := 0;
                    //Added
                end;
            end;
        }
        field(6; Rate; Decimal)
        {
            Caption = 'Rate';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
        }
        field(7; "Center Cost Dim value Code"; Code[20])
        {
            Caption = 'Center Cost Dimension value Code';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
        }
        field(8; "Allocation Method"; Code[20])
        {
            Caption = 'Allocation method';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
            tableRelation = "ecHeader Alloc. Scheme Advanc."."No.";

            trigger OnValidate()
            begin
                if (Rec."Allocation Method" <> '') and (Rec."Cost Calculation Method" = Rec."Cost Calculation Method"::Manual) then
                    Error('Il campo deve essere vuoto');
            end;
        }
        field(9; "Worked Time Budget"; Decimal)
        {
            Caption = 'Worked time budget';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
            Editable = false;
        }
        field(10; "Budget Amount"; Decimal)
        {
            Caption = 'Budget Amount';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
            Editable = false;
        }
        field(11; "Rate Bdg"; Decimal)
        {
            Caption = 'Rate Bdg"';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
            Editable = false;
        }
        field(12; "Amount C/G"; Decimal)
        {
            Caption = 'Amount C/G';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
            Editable = false;
        }
        field(13; "Amount Simulated"; Decimal)
        {
            Caption = 'Amount Simulated';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
            Editable = false;
        }
        field(14; "Amount C/G +Sim"; Decimal)
        {
            Caption = 'Amount C/G +Sim';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
            Editable = false;
        }
        field(15; "Worked Time Real"; Decimal)
        {
            Caption = 'Worked time real';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
            Editable = false;
        }
        field(16; "Rate G/L"; Decimal)
        {
            Caption = 'Rate G/L';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Capacity Type", "Work Center No.", Code)
        {
            Clustered = true;
        }
    }
}