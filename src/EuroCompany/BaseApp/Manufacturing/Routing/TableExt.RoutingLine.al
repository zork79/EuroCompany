namespace EuroCompany.BaseApp.Manufacturing.Routing;

using Microsoft.Manufacturing.Routing;

tableextension 80012 "Routing Line" extends "Routing Line"
{
    fields
    {
        field(50000; "ecPrevalent Operation"; Boolean)
        {
            Caption = 'Prevalent operation';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_039';

            trigger OnValidate()
            var
                lRoutingLine: Record "Routing Line";

                lError001: Label '%1 can be assigned only to one operation in routing!';
            begin
                //CS_PRO_039-s
                if "ecPrevalent Operation" then begin
                    Clear(lRoutingLine);
                    lRoutingLine.SetRange("Routing No.", "Routing No.");
                    lRoutingLine.SetRange("Version Code", "Version Code");
                    lRoutingLine.SetFilter("Operation No.", '<>%1', "Operation No.");
                    lRoutingLine.SetRange("ecPrevalent Operation", true);
                    if not lRoutingLine.IsEmpty then begin
                        Error(lError001, FieldCaption("ecPrevalent Operation"));
                    end;
                end;
                //CS_PRO_039-e
            end;
        }
    }
}
