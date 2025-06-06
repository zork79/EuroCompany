namespace EuroCompany.BaseApp.Purchases.Document;

table 50022 "ecTransport Status"
{
    Caption = 'Transport status';
    DataClassification = CustomerContent;
    Description = 'CS_ACQ_013';
    DrillDownPageId = "ecTransport Status";
    LookupPageId = "ecTransport Status";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(100; Description; Text[100])
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
