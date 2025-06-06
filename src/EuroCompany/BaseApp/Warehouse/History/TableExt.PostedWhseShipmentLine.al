namespace EuroCompany.BaseApp.Warehouse.History;

using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Warehouse.History;

tableextension 80083 "Posted Whse. Shipment Line" extends "Posted Whse. Shipment Line"
{
    fields
    {
        modify("AltAWPParcel Units")
        {
            Caption = 'No. of logistic units';
            Description = 'CS_LOG_001';
        }
        field(50000; "ecConsumer Unit of Measure"; Code[10])
        {
            Caption = 'Consumer Unit of Measure';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_014';
            Editable = false;
            TableRelation =
            if ("AltAWPElement Type" = const(Item), "Item No." = filter(<> '')) "Item Unit of Measure".Code where("Item No." = field("Item No."))
            else
            if ("AltAWPElement Type" = const(Resource), "AltAWPElement No." = filter(<> '')) "Resource Unit of Measure".Code where("Resource No." = field("AltAWPElement No."))
            else
            if ("AltAWPElement Type" = filter("Charge (Item)" | "Fixed Asset" | "G/L Account")) "Unit of Measure";
        }
        field(50001; "ecQty. per Consumer UM"; Decimal)
        {
            Caption = 'Qty. per Consumer UM';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'CS_VEN_014';
            Editable = false;
        }
        field(50002; "ecQuantity (Consumer UM)"; Decimal)
        {
            Caption = 'Quantity (Consumer UM)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'CS_VEN_014';
            Editable = false;
        }
        field(50010; "ecKit/Exhibitor Item"; Boolean)
        {
            CalcFormula = lookup(Item."ecKit/Product Exhibitor" where("No." = field("No.")));
            Caption = 'Kit/Exhibitor Item';
            Description = 'CS_PRO_009';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50015; "ecKit/Exhibitor BOM Entry No."; Integer)
        {
            Caption = 'Kit/Exhibitor BOM Entry No.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_009';
            Editable = false;
        }
    }

    internal procedure ecUpdateConsumerUMQuantity()
    var
        lawpLogisticsFunctions: Codeunit "AltAWPLogistics Functions";
    begin
        //CS_VEN_014-VI-s
        "ecQuantity (Consumer UM)" := 0;
        if ("ecConsumer Unit of Measure" <> '') and
           ("AltAWPElement Type" = "AltAWPElement Type"::Item)
        then begin
            "ecQuantity (Consumer UM)" := lawpLogisticsFunctions.ConvertItemQtyInUM("Item No.",
                                                                                    Quantity,
                                                                                    "Unit of Measure Code",
                                                                                    "ecConsumer Unit of Measure");
        end;
        //CS_VEN_014-VI-e
    end;
}
