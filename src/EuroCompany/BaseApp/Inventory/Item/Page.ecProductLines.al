namespace EuroCompany.BaseApp.Inventory.Item;

using EuroCompany.BaseApp.Inventory.Item;

page 50026 "ecProduct Lines"
{
    ApplicationArea = All;
    Caption = 'Product Lines';
    Description = 'GAP_VEN_002';
    PageType = List;
    SourceTable = "ecProduct Line";
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
