namespace EuroCompany.BaseApp.Sales.History;

using EuroCompany.BaseApp.Sales.AdvancedTrade;
using EuroCompany.BaseApp.Setup;
using Microsoft.Sales.History;

tableextension 80024 "Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50040; "ecSales Manager Code"; Code[20])
        {
            Caption = 'Sales Manager Code';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_031';
            TableRelation = "ecSales Manager".Code;
        }
        field(50041; "ecSales Manager Name"; Text[100])
        {
            CalcFormula = lookup("ecSales Manager".Name where(Code = field("ecSales Manager Code")));
            Caption = 'Sales Manager Name';
            Description = 'CS_VEN_031';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50042; "ecProduct Segment No."; Code[20])
        {
            Caption = 'Product Segment No.';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_032';
            Editable = false;
            TableRelation = "APsTRD Product Segment"."No.";
        }
        field(50043; "ecProduct Segment Description"; Text[100])
        {
            CalcFormula = lookup("APsTRD Product Segment".Description where("No." = field("ecProduct Segment No.")));
            Caption = 'Product Segment Description';
            Description = 'CS_VEN_032';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50044; "ecRef. Date For Calc. Due Date"; Date)
        {
            Caption = 'Ref. Date For Calc. Due Date';
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin
                if (Rec."ecRef. Date For Calc. Due Date" <> xRec."ecRef. Date For Calc. Due Date") and (xRec."ecRef. Date For Calc. Due Date" <> 0D) then
                    Rec.Validate("Payment Terms Code");
            end;
        }
    }
}
