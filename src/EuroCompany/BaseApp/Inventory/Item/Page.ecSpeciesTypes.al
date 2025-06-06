namespace EuroCompany.BaseApp.Inventory.Item;

using EuroCompany.BaseApp.Inventory.Item;

page 50009 "ecSpecies Types"
{
    ApplicationArea = All;
    Caption = 'Species Types';
    Description = 'GAP_VEN_002';
    PageType = List;
    SourceTable = "ecSpecies Type";
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
