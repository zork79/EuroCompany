namespace EuroCompany.BaseApp.Inventory.Item;

table 50011 ecBrand
{
    Caption = 'Brand';
    DataClassification = CustomerContent;
    Description = 'GAP_VEN_002';
    DrillDownPageId = ecBrands;
    LookupPageId = ecBrands;

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
