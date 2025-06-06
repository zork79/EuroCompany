namespace EuroCompany.BaseApp.Purchases.Document;

page 50040 "ecIncoterms Place"
{
    ApplicationArea = All;
    Caption = 'Incoterms Place';
    Description = 'CS_ACQ_013';
    PageType = List;
    SourceTable = "ecIncoterms Place";
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
