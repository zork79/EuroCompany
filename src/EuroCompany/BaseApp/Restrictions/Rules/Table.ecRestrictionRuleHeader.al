namespace EuroCompany.BaseApp.Restrictions.Rules;

table 50027 "ecRestriction Rule Header"
{
    Caption = 'Restriction Rule Header';
    DataClassification = CustomerContent;
    Description = 'CS_PRO_011';
    DrillDownPageId = "ecRestriction Rules";
    LookupPageId = "ecRestriction Rules";

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(10; Status; Enum "ecRestriction Rule Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(20; "Usage Note"; Text[250])
        {
            Caption = 'Usage Note';
        }
        field(100; "Short Description"; Text[25])
        {
            Caption = 'Short Description';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Description) { }
    }

    trigger OnInsert()
    begin
        TestRecord();
    end;

    trigger OnModify()
    begin
        TestRecord();
    end;

    trigger OnRename()
    begin
        TestRecord();
    end;

    trigger OnDelete()
    var
        lRestrictionRuleLine: Record "ecRestriction Rule Line";
    begin
        TestField(Status, Status::Open);

        lRestrictionRuleLine.Reset();
        lRestrictionRuleLine.SetRange("Rule Code", Code);
        if not lRestrictionRuleLine.IsEmpty then begin
            lRestrictionRuleLine.DeleteAll(true);
        end;
    end;

    local procedure TestRecord();
    begin
        TestField(Code);
    end;
}
