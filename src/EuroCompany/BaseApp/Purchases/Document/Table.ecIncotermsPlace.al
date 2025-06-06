namespace EuroCompany.BaseApp.Purchases.Document;

table 50024 "ecIncoterms Place"
{
    Caption = 'Incoterms Place';
    DataClassification = CustomerContent;
    Description = 'CS_ACQ_013';
    DrillDownPageId = "ecIncoterms Place";
    LookupPageId = "ecIncoterms Place";

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
