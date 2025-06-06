
namespace EuroCompany.BaseApp.Coan;
using EuroCompany.BaseApp.Manufacturing.Capacity;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.WorkCenter;
using Microsoft.Finance.Dimension;

table 50041 "ecHeader Alloc. Scheme Advanc."
{
    Caption = 'Header Allocation Scheme Advanced';
    DataClassification = CustomerContent;
    Description = 'CS_AFC_004';
    Extensible = true;
    DrillDownPageId = "ecHeader Alloc. Sch. Advanc.";
    LookupPageId = "ecHeader Alloc. Sch. Advanc.";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
        }
        field(3; "Calculation Type"; Option)
        {
            Caption = 'Calculation Type';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_004';
            OptionMembers = "% Weight","KG Products","Kilovators","Minutes of work";
            OptionCaption = '% Weight,KG Products,Kilovators,Minutes of work';
        }

    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        ecLineAllocSchemeAdv: Record "ecLine Alloc. Scheme Adv.";
    begin
        ecLineAllocSchemeAdv.SetRange("Allocation Method", "No.");
        ecLineAllocSchemeAdv.DeleteAll();
    end;
}