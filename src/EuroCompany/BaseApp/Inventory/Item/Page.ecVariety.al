namespace EuroCompany.BaseApp.Inventory.Item;

using EuroCompany.BaseApp.Inventory.Item;

page 50015 ecVariety
{
    ApplicationArea = All;
    Caption = 'Variety';
    Description = 'GAP_VEN_002';
    PageType = List;
    SourceTable = ecVariety;
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
