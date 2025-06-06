namespace EuroCompany.BaseApp.Sales.History;

using EuroCompany.BaseApp.Sales.AdvancedTrade;
using Microsoft.Sales.History;
tableextension 80023 "Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        modify("AltAWPManual Parcels")
        {
            Caption = 'Manual logistic units';
            Description = 'CS_LOG_001';
        }
        modify("AltAWPParcel Units")
        {
            Caption = 'No. of logistic units';
            Description = 'CS_LOG_001';
        }

        field(50005; "ecNo. Parcels"; Integer)
        {
            Caption = 'No. parcels';
            DataClassification = CustomerContent;
            Description = 'CS_LOG_001';

            trigger OnValidate()
            begin
                if (CurrFieldNo = FieldNo("ecNo. Parcels")) and (Rec."ecNo. Parcels" <> xRec."ecNo. Parcels") then begin
                    "ecManual Parcels" := true;
                end;
            end;
        }
        field(50010; "ecManual Parcels"; Boolean)
        {
            Caption = 'Manual parcels';
            DataClassification = CustomerContent;
            Description = 'CS_LOG_001';
            Editable = false;
        }
        field(50017; "ecNo. Theoretical Pallets"; Decimal)
        {
            Caption = 'No. of theoretical pallets';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 1;
            Description = 'CS_LOG_001';
            Editable = false;
        }
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
        }
    }
}
