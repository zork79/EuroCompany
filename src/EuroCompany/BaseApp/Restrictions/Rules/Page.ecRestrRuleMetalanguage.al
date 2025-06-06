namespace EuroCompany.BaseApp.Restrictions.Rules;

using EuroCompany.BaseApp.Restrictions.Rules;

page 50049 "ecRestr. Rule Metalanguage"
{
    ApplicationArea = All;
    Caption = 'Rule Definition';
    Description = 'CS_PRO_011';
    Editable = false;
    PageType = ListPart;
    SourceTable = "ecRestriction Rule Line";
    SourceTableView = sorting("Rule Code", "Line Type", "Line No.") order(ascending) where("Line Type" = const(Metalanguage));

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Rule Metalanguage"; Rec."Rule Metalanguage") { CaptionClass = Rec."Rule Code"; }
            }
        }
    }
}
