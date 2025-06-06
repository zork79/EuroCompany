namespace EuroCompany.BaseApp.Purchases.Vendor;

table 50032 "ecVendor Classification"
{
    Caption = 'Vendor Classification';
    DataClassification = CustomerContent;
    Description = 'CS_ACQ_013';
    DrillDownPageId = "ecVendor Classifications";
    LookupPageId = "ecVendor Classifications";

    fields
    {
        field(10; "Code"; Code[20])
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
