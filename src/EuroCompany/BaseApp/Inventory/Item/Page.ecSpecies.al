namespace EuroCompany.BaseApp.Inventory.Item;

using EuroCompany.BaseApp.Inventory.Item;

page 50010 ecSpecies
{
    ApplicationArea = All;
    Caption = 'Species';
    Description = 'GAP_VEN_002';
    PageType = List;
    SourceTable = ecSpecies;
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
