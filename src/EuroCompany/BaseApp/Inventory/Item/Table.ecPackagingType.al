namespace EuroCompany.BaseApp.Inventory.Item;

table 50017 "ecPackaging Type"
{
    Caption = 'Packaging Type';
    DataClassification = CustomerContent;
    Description = 'CS_ACQ_018';
    DrillDownPageId = "ecPackaging Types";
    LookupPageId = "ecPackaging Types";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[100])
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
