namespace EuroCompany.BaseApp.Inventory.Item;

table 50007 "ecSpecies Type"
{
    Caption = 'Species Type';
    DataClassification = CustomerContent;
    Description = 'GAP_VEN_002';
    DrillDownPageId = "ecSpecies Types";
    LookupPageId = "ecSpecies Types";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(50; Description; Text[100])
        {
            Caption = 'Description';
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
