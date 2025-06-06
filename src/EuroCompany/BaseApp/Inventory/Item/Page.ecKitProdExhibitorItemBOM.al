namespace EuroCompany.BaseApp.Inventory.Item;

page 50079 "ecKit/Prod. Exhibitor Item BOM"
{
    ApplicationArea = All;
    Caption = 'Kit/Prod. Exhibitor Item BOM';
    DeleteAllowed = false;
    Description = 'CS_PRO_009';
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "ecKit/Prod. Exhibitor Item BOM";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                }
                field("Unit Of Measure"; Rec."Unit Of Measure Code")
                {
                }
                field("Prod. BOM Quantity"; Rec."Prod. BOM Quantity")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                    Visible = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field("Composed Discount"; Rec."Composed Discount")
                {
                }
                field("Quantity (Consumer UM)"; Rec."Quantity (Consumer UM)")
                {
                }
                field("Consumer UM"; Rec."Consumer UM")
                {
                }
                field("Unit Price (Consumer UM)"; Rec."Unit Price (Consumer UM)")
                {
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                }
                field("Line Amount"; Rec."Line Amount")
                {
                }
                field("Error Text"; Rec."Error Text")
                {
                    Style = Unfavorable;
                }
            }
        }
    }
}
