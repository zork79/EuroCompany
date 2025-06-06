namespace EuroCompany.BaseApp.Purchases.Document;

using EuroCompany.BaseApp.Purchases.Document;

page 50035 "ecContainer Types"
{
    ApplicationArea = All;
    Caption = 'Container types';
    Description = 'CS_ACQ_013';
    PageType = List;
    SourceTable = "ecContainer Type";
    UsageCategory = None;

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
