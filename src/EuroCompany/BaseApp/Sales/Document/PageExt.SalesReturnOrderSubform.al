namespace EuroCompany.BaseApp.Sales.Document;

using Microsoft.Sales.Document;

pageextension 80165 "Sales Return Order Subform" extends "Sales Return Order Subform"
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

    var
        ecIsItemLine: Boolean;

    trigger OnAfterGetRecord()
    begin
        //CS_VEN_014-VI-s
        ecIsItemLine := (Rec.Type = Rec.Type::Item);
        //CS_VEN_014-VI-e
    end;
}
