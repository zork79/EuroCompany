namespace EuroCompany.BaseApp.AWPExtension.Warehouse;

pageextension 80172 "awpEdit Whse. Ship Line" extends "AltAWPEdit Whse. Ship Line"
{
    layout
    {
        addlast(General)
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
                Editable = true;
                HideValue = not ecIsItemLine;
            }
        }
    }

    var
        ecIsItemLine: Boolean;

    trigger OnAfterGetRecord()
    begin
        //CS_VEN_014-VI-s
        ecIsItemLine := (Rec."AltAWPElement Type" = Rec."AltAWPElement Type"::Item);
        //CS_VEN_014-VI-e
    end;
}
