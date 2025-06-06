namespace EuroCompany.BaseApp.Activity;
using Microsoft.Finance.Dimension;

table 50026 "ecCommercial Area"
{
    Caption = 'Commercial Area';
    DataClassification = CustomerContent;
    DrillDownPageId = "ecCommercial Area List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }

        //FOR WIZARD DEFAULT DIMENSION APP USE ONLY
        field(4; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
            Blocked = const(false));
        }

        //FOR WIZARD DEFAULT DIMENSION APP USE ONLY
        field(5; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
            Blocked = const(false));
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
