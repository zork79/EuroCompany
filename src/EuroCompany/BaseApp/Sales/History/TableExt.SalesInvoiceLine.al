namespace EuroCompany.BaseApp.Sales.History;

using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Sales.History;

tableextension 80078 "Sales Invoice Line" extends "Sales Invoice Line"
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
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 2;
            Caption = 'Unit Price (Consumer UM)';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_014';
            Editable = false;
        }
        field(50011; "ecKit/Exhibitor Item"; Boolean)
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
        field(50030; "ecAttacch. Kit/Exhib. Line No."; Integer)
        {
            Caption = 'Attacched To Kit/Exhib. Line No.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_009';
            Editable = false;
        }
        field(50050; "ecExclude From Item Ledg.Entry"; Boolean)
        {
            Caption = 'Exclude from Item Ledg. Entry';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_036';
            Editable = false;
        }
    }
}

