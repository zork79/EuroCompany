namespace EuroCompany.BaseApp.Purchases.Vendor;

table 50049 "ecVendor Rating Code"
{
    Caption = 'Vendor Rating Code';
    DataClassification = CustomerContent;
    Description = 'CS_QMS_009';
    DrillDownPageId = "ecVendor Rating Codes";
    LookupPageId = "ecVendor Rating Codes";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[100])
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

    trigger OnInsert()
    begin
        TestRecord();
    end;

    trigger OnModify()
    begin
        TestRecord();
    end;

    local procedure TestRecord()
    begin
        TestField(Code);
    end;
}
