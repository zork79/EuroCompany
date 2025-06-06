namespace EuroCompany.BaseApp.Restrictions.Rules;

page 50047 "ecRestriction Rule Conditions"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    Caption = 'Conditions';
    DelayedInsert = true;
    Description = 'CS_PRO_011';
    PageType = ListPart;
    SourceTable = "ecRestriction Rule Line";
    SourceTableView = sorting("Rule Code", "Line Type", "Line No.") order(ascending) where("Line Type" = const(Condition));

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Line No."; Rec."Line No.") { Visible = false; }
                field("Open Bracket"; Rec."Open Bracket") { }
                field("Attribute Type"; Rec."Attribute Type") { }
                field("Condition Type"; Rec."Condition Type") { }
                field("Condition Value"; Rec."Condition Value") { }
                field("Close Bracket"; Rec."Close Bracket") { }
                field("Logical Join"; Rec."Logical Join") { }
            }
        }
    }
}
