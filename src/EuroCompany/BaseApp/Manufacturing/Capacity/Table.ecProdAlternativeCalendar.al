namespace EuroCompany.BaseApp.Manufacturing.Capacity;

using Microsoft.Manufacturing.Capacity;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.WorkCenter;

table 50002 "ecProd. Alternative Calendar"
{
    Caption = 'Prod. Alternative Calendar';
    DataClassification = CustomerContent;
    Description = 'CS_PRO_018';

    fields
    {
        field(10; "Work Center No."; Code[20])
        {
            Caption = 'Work Center No.';
            TableRelation = "Work Center"."No.";

            trigger OnValidate()
            begin
                if (Rec."Work Center No." <> xRec."Work Center No.") then begin
                    "Machine Center No." := '';
                end;
            end;
        }
        field(20; "Machine Center No."; Code[20])
        {
            Caption = 'Machine Center No.';
            TableRelation = "Machine Center"."No." where("Work Center No." = field("Work Center No."));
        }
        field(50; "Alternative Shop Calendar Code"; Code[10])
        {
            Caption = 'Alternative Shop Calendar Code';
            TableRelation = "Shop Calendar".Code;
        }
        field(70; "Period Starting Date"; Date)
        {
            Caption = 'Period Starting Date';
            trigger OnValidate()
            begin
                if ("Period Starting Date" > "Period Ending Date") then begin
                    "Period Ending Date" := 0D;
                end;
            end;
        }
        field(75; "Period Ending Date"; Date)
        {
            Caption = 'Period Ending Date';

            trigger OnValidate()
            var
                lError001: Label '"%1" must be greater than "%2"!';
            begin
                if ("Period Ending Date" < "Period Starting Date") and ("Period Ending Date" <> 0D) then begin
                    Error(lError001, FieldCaption("Period Ending Date"), FieldCaption("Period Starting Date"));
                end;
            end;
        }
    }
    keys
    {
        key(PK; "Work Center No.", "Machine Center No.", "Alternative Shop Calendar Code", "Period Starting Date", "Period Ending Date")
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

    internal procedure TestRecord(): Boolean
    var
        lProdAlternativeCalendar: Record "ecProd. Alternative Calendar";

        lError001: Label 'A date conflict was detected for "%1" = "%2" | "%3" = "%4"!';
    begin
        Clear(lProdAlternativeCalendar);
        lProdAlternativeCalendar.SetRange("Work Center No.", "Work Center No.");
        lProdAlternativeCalendar.SetRange("Machine Center No.", "Machine Center No.");
        if not lProdAlternativeCalendar.IsEmpty then begin
            lProdAlternativeCalendar.FindSet();
            repeat
                if (("Period Starting Date" <= lProdAlternativeCalendar."Period Starting Date") and ("Period Ending Date" >= lProdAlternativeCalendar."Period Starting Date")) or
                   (("Period Starting Date" >= lProdAlternativeCalendar."Period Starting Date") and ("Period Ending Date" <= lProdAlternativeCalendar."Period Ending Date")) or
                   (("Period Starting Date" >= lProdAlternativeCalendar."Period Starting Date") and ("Period Starting Date" <= lProdAlternativeCalendar."Period Ending Date")) or
                   (("Period Starting Date" <= lProdAlternativeCalendar."Period Starting Date") and ("Period Ending Date" >= lProdAlternativeCalendar."Period Ending Date"))
                then begin
                    Error(lError001, FieldCaption("Work Center No."), "Work Center No.",
                                     FieldCaption("Machine Center No."), "Machine Center No.");
                end;
            until (lProdAlternativeCalendar.Next() = 0);
        end;
    end;
}
