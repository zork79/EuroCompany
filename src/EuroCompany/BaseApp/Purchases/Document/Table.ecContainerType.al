namespace EuroCompany.BaseApp.Purchases.Document;

table 50021 "ecContainer Type"
{
    Caption = 'Container Type';
    DataClassification = CustomerContent;
    Description = 'CS_ACQ_013';
    DrillDownPageId = "ecContainer Types";
    LookupPageId = "ecContainer Types";

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
