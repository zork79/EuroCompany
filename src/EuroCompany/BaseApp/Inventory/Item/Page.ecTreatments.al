namespace EuroCompany.BaseApp.Inventory.Item;

using EuroCompany.BaseApp.Inventory.Item;

page 50011 ecTreatments
{
    ApplicationArea = All;
    Caption = 'Treatments';
    Description = 'GAP_VEN_002';
    PageType = List;
    SourceTable = ecTreatment;
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
