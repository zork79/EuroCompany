namespace EuroCompany.BaseApp.Purchases.Document;

page 50037 "ecTransport Status"
{
    ApplicationArea = All;
    Caption = 'Transport status';
    Description = 'CS_ACQ_013';
    PageType = List;
    SourceTable = "ecTransport Status";
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
