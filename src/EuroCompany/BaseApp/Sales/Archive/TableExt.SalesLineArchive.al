namespace EuroCompany.BaseApp.Sales.Archive;

using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Sales.Archive;

tableextension 80081 "Sales Line Archive" extends "Sales Line Archive"
{
    fields
    {
        field(50000; "ecConsumer Unit of Measure"; Code[10])
        {
            Caption = 'Consumer Unit of Measure';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_014';
            Editable = false;
            TableRelation =
            if (Type = const(Item), "No." = filter(<> '')) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            if (Type = const(Resource), "No." = filter(<> '')) "Resource Unit of Measure".Code where("Resource No." = field("No."))
            else
            if (Type = filter("Charge (Item)" | "Fixed Asset" | "G/L Account")) "Unit of Measure";
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
        field(50003; "ecUnit Price (Consumer UM)"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price (Consumer UM)';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_014';
            Editable = false;
        }
    }
}

