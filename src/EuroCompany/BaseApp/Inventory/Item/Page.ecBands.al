namespace EuroCompany.BaseApp.Inventory.Item;

using EuroCompany.BaseApp.Inventory.Item;

page 50028 ecBands
{
    ApplicationArea = All;
    Caption = 'Bands';
    Description = 'CS_ACQ_018';
    PageType = List;
    SourceTable = ecBand;
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
