namespace EuroCompany.BaseApp.Warehouse.Pallets;

page 50075 "ecCPR Extracted TXT"
{
    Caption = 'CPR Extracted TXT';
    PageType = List;
    Editable = false;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ecCPR Extracted TXT";

    layout
    {
        area(Content)
        {
            repeater(RPTR)
            {
                field("Progressive No."; Rec."Progressive No.")
                {
                    ApplicationArea = All;
                }
                field("TXT File Name"; Rec."TXT File Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}