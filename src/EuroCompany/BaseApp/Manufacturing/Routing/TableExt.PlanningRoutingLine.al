namespace EuroCompany.BaseApp.Manufacturing.Routing;

using Microsoft.Manufacturing.Routing;

tableextension 80014 "Planning Routing Line" extends "Planning Routing Line"
{
    fields
    {
        field(50000; "ecPrevalent Operation"; Boolean)
        {
            Caption = 'Prevalent operation';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_039';
            Editable = false;

            trigger OnValidate()
            var
                lPlanningRoutingLine: Record "Planning Routing Line";

                lError001: Label '%1 can be assigned only to one operation in routing!';
            begin
                //CS_PRO_039-s
                if "ecPrevalent Operation" then begin
                    Clear(lPlanningRoutingLine);
                    lPlanningRoutingLine.SetRange("Worksheet Template Name", "Worksheet Template Name");
                    lPlanningRoutingLine.SetRange("Worksheet Batch Name", "Worksheet Batch Name");
                    lPlanningRoutingLine.SetRange("Worksheet Line No.", "Worksheet Line No.");
                    lPlanningRoutingLine.SetFilter("Operation No.", '<>%1', "Operation No.");
                    lPlanningRoutingLine.SetRange("ecPrevalent Operation", true);
                    if not lPlanningRoutingLine.IsEmpty then begin
                        Error(lError001, FieldCaption("ecPrevalent Operation"));
                    end;
                end;
                //CS_PRO_039-e
            end;
        }
    }
}
