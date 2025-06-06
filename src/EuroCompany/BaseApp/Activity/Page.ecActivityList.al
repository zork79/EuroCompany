namespace EuroCompany.BaseApp.Activity;

page 50043 "ec Activity List"
{
    ApplicationArea = All;
    Caption = 'Activity List';
    PageType = List;
    SourceTable = ecActivity;
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
                field("Commercial Area Code"; Rec."Commercial Area Code")
                {
                }
            }
        }
    }
}
