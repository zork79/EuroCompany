namespace EuroCompany.BaseApp.Inventory.Item;

using EuroCompany.BaseApp.Inventory.Item;

page 50016 ecGauge
{
    ApplicationArea = All;
    Caption = 'Gauge';
    Description = 'GAP_VEN_002';
    PageType = List;
    SourceTable = ecGauge;
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
