namespace EuroCompany.BaseApp.Purchases.Document;

table 50023 "ecDelay Reason"
{
    Caption = 'Delay Reason';
    DataClassification = CustomerContent;
    Description = 'CS_ACQ_013';
    DrillDownPageId = "ecDelay Reasons";
    LookupPageId = "ecDelay Reasons";

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
