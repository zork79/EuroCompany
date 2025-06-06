namespace EuroCompany.BaseApp.Inventory.Item;

using EuroCompany.BaseApp.Inventory.Item;

page 50012 "ecBrand Types"
{
    ApplicationArea = All;
    Caption = 'Brand Types';
    Description = 'GAP_VEN_002';
    PageType = List;
    SourceTable = "ecBrand Type";
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
