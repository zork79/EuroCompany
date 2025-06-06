namespace EuroCompany.BaseApp.AWPExtension.Sales;

pageextension 80094 "awpShip Sales Orders" extends "AltAWPShip Sales Orders"
{
    layout
    {
        modify("Shipment Date")
        {
            StyleExpr = ecShipmentDateStyle;
        }
        addafter("AltAWPSuspend Shipment")
        {
            field("ecProduct Segment No."; SalesHeader."ecProduct Segment No.")
            {
                ApplicationArea = All;
                Caption = 'Product Segment No.';
                Description = 'CS_VEN_032';
                Editable = false;
                StyleExpr = LineStyle;
            }
            field("ecProduct Segment Description"; SalesHeader."ecProduct Segment Description")
            {
                ApplicationArea = All;
                Caption = 'Product Segment Description';
                Description = 'CS_VEN_032';
                DrillDown = false;
                Editable = false;
                StyleExpr = LineStyle;
            }
        }

        addlast(General)
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
            field("ecSales Manager Code"; SalesHeader."ecSales Manager Code")
            {
                ApplicationArea = All;
                Caption = 'Sales Manager Code';
                Description = 'CS_VEN_031';
                Editable = false;
            }
            field("ecSales Manager Name"; SalesHeader."ecSales Manager Name")
            {
                ApplicationArea = All;
                Caption = 'Sales Manager Name';
                Description = 'CS_VEN_031';
                DrillDown = false;
                Editable = false;
            }
        }
    }

    var
        ecShipmentDateStyle: Text;
        ecIsItemLine: Boolean;

    trigger OnAfterGetRecord()
    begin
        //CS_VEN_014-VI-s
        ecIsItemLine := (Rec.Type = Rec.Type::Item);
        //CS_VEN_014-VI-e

        ecShipmentDateStyle := 'Standard';
        if (Rec."Shipment Date" < Today) then ecShipmentDateStyle := 'Unfavorable';

        ecUpdateRecordData();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        ecUpdateRecordData();
    end;

    local procedure ecUpdateRecordData()
    begin
        //CS_VEN_031-VI-s
        SalesHeader.CalcFields("ecSales Manager Name");
        //CS_VEN_031-VI-e        

        //CS_VEN_032-VI-s        
        SalesHeader.CalcFields("ecProduct Segment Description");
        //CS_VEN_032-VI-e       
    end;
}
