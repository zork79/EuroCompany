namespace EuroCompany.BaseApp.Inventory.Item;

table 50016 ecBand
{
    Caption = 'Band';
    DataClassification = CustomerContent;
    Description = 'CS_ACQ_018';
    DrillDownPageId = ecBands;
    LookupPageId = ecBands;

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
