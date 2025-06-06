namespace EuroCompany.BaseApp.Sales.Document;

using EuroCompany.BaseApp.Sales;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;

pageextension 80093 "Sales Quote Subform" extends "Sales Quote Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("ecConsumer Unit of Measure"; Rec."ecConsumer Unit of Measure")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_014';
            }
            field("ecQty. per Consumer UM"; Rec."ecQty. per Consumer UM")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_014';
                HideValue = not ecIsItemLine;
                Visible = false;
            }
            field("ecQuantity (Consumer UM)"; Rec."ecQuantity (Consumer UM)")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_014';
                HideValue = not ecIsItemLine;
            }
            field("ecUnit Price (Consumer UM)"; Rec."ecUnit Price (Consumer UM)")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_014';
                HideValue = not ecIsItemLine;
            }
        }
    }

    actions
    {
        modify(SelectMultiItems)
        {
            Description = 'CS_VEN_032';
            Enabled = false;
            Visible = false;
        }

        addafter(SelectMultiItems)
        {
            action(ecSelectItemsBySegment)
            {
                AccessByPermission = tabledata Item = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Select items';
                Description = 'CS_VEN_032';
                Ellipsis = true;
                Image = NewItem;
                ToolTip = 'Add two or more items from the full list of your inventory items.';

                trigger OnAction()
                var
                    lecSalesFunctions: Codeunit "ecSales Functions";
                begin
                    //CS_VEN_032-VI-s
                    lecSalesFunctions.SelectMultipleItemsForSales(Rec);
                    //CS_VEN_032-VI-e
                end;
            }
        }
    }

    var
        ecIsItemLine: Boolean;

    trigger OnAfterGetRecord()
    begin
        //CS_VEN_014-VI-s
        ecIsItemLine := (Rec.Type = Rec.Type::Item);
        //CS_VEN_014-VI-e
    end;
}
