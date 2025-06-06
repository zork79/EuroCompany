namespace EuroCompany.BaseApp.Inventory.Item;

using EuroCompany.BaseApp.Inventory.Item;

page 50027 "ecPackaging Types"
{
    ApplicationArea = All;
    Caption = 'Packaging Types';
    Description = 'CS_ACQ_018';
    PageType = List;
    SourceTable = "ecPackaging Type";
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
