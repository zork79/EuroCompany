namespace EuroCompany.BaseApp.Warehouse.Pallets;
page 50066 "ecPallet Grouping Code"
{
    Caption = 'Pallet Grouping Code';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ecPallet Grouping Code";

    layout
    {
        area(Content)
        {
            repeater(RPTR)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}