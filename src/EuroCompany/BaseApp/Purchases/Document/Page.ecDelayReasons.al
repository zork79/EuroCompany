namespace EuroCompany.BaseApp.Purchases.Document;

using EuroCompany.BaseApp.Purchases.Document;

page 50039 "ecDelay Reasons"
{
    ApplicationArea = All;
    Caption = 'Delay Reasons';
    Description = 'CS_ACQ_013';
    PageType = List;
    SourceTable = "ecDelay Reason";
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
