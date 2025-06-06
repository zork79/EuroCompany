namespace EuroCompany.BaseApp.Projects.Project;

page 50062 "ecList Project Type"
{
    Caption = 'List Project Type';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ecList Project Type";

    layout
    {
        area(Content)
        {
            repeater(RPTR)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}