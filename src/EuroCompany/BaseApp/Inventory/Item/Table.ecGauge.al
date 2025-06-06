namespace EuroCompany.BaseApp.Inventory.Item;

table 50014 ecGauge
{
    Caption = 'Gauge';
    DataClassification = CustomerContent;
    Description = 'GAP_VEN_002';
    DrillDownPageId = ecGauge;
    LookupPageId = ecGauge;

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