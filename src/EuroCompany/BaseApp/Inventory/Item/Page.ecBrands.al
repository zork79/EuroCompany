namespace EuroCompany.BaseApp.Inventory.Item;

page 50013 ecBrands
{
    ApplicationArea = All;
    Caption = 'Brands';
    Description = 'GAP_VEN_002';
    PageType = List;
    SourceTable = ecBrand;
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
