namespace EuroCompany.BaseApp.Inventory.Item;

using EuroCompany.BaseApp.Inventory.Item;

page 50014 "ecCommercial Lines"
{
    ApplicationArea = All;
    Caption = 'Commercial Lines';
    Description = 'GAP_VEN_002';
    PageType = List;
    SourceTable = "ecCommercial Line";
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
