namespace EuroCompany.BaseApp.Projects.Job;
using Microsoft.Projects.Project.Job;
using EuroCompany.BaseApp.Projects.Project;

tableextension 80087 Job extends Job
{
    fields
    {
        field(50000; "ecProject Type Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Project Type Code';
            TableRelation = "ecList Project Type";

            trigger OnValidate()
            begin
                Rec.CalcFields("ecProject Type Description");
            end;
        }
        field(50001; "ecProject Type Description"; Text[250])
        {
            Caption = 'Project Type Description';
            FieldClass = FlowField;
            CalcFormula = lookup("ecList Project Type".Description where(Code = field("ecProject Type Code")));
            Editable = false;
        }
    }
}