namespace EuroCompany.BaseApp.Coan;

page 50080 "Coan Custom Setup"
{
    ApplicationArea = All;
    Caption = 'Coan Custom Setup';
    PageType = Card;
    UsageCategory = Documents;
    SourceTable = "ecCoan Custom Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Dimension 1 code"; Rec."Dimension 1 code")
                {
                    ApplicationArea = All;
                }
                field("Dimension 2 code"; Rec."Dimension 2 code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
