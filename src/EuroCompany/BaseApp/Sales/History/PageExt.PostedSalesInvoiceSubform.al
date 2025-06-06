namespace EuroCompany.BaseApp.Sales.History;

using Microsoft.Sales.History;

pageextension 80166 "Posted Sales Invoice Subform" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("ecConsumer Unit of Measure"; Rec."ecConsumer Unit of Measure")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_014';
                Editable = false;
            }
            field("ecQty. per Consumer UM"; Rec."ecQty. per Consumer UM")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_014';
                Editable = false;
                HideValue = not ecIsItemLine;
                Visible = false;
            }
            field("ecQuantity (Consumer UM)"; Rec."ecQuantity (Consumer UM)")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_014';
                Editable = false;
                HideValue = not ecIsItemLine;
            }
            field("ecUnit Price (Consumer UM)"; Rec."ecUnit Price (Consumer UM)")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_014';
                Editable = false;
                HideValue = not ecIsItemLine;
            }
            field("ecExclude From Item Ledg.Entry"; Rec."ecExclude From Item Ledg.Entry")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_036';
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
