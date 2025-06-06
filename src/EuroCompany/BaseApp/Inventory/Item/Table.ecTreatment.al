namespace EuroCompany.BaseApp.Inventory.Item;

table 50009 ecTreatment
{
    Caption = 'Treatment';
    DataClassification = CustomerContent;
    Description = 'GAP_VEN_002';
    DrillDownPageId = ecTreatments;
    LookupPageId = ecTreatments;

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
