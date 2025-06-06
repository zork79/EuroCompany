namespace EuroCompany.BaseApp.Activity;

page 50044 "ecCommercial Area List"
{
    ApplicationArea = All;
    Caption = 'Commcial Area List';
    PageType = List;
    SourceTable = "ecCommercial Area";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }
}
