namespace EuroCompany.BaseApp.Warehouse.History;

using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Purchases.Document;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Warehouse.History;

tableextension 80019 "Posted Whse. Receipt Line" extends "Posted Whse. Receipt Line"
{
    fields
    {
        field(50000; "ecPackaging Type"; Code[20])
        {
            Caption = 'Packaging Type';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_018';
            Editable = false;
            TableRelation = "ecPackaging Type";
        }
        field(50010; "ecContainer No."; Code[100])
        {
            Caption = 'Container no.';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            Editable = false;
        }
        field(50012; "ecContainer Type"; Code[20])
        {
            Caption = 'Container type';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            Editable = false;
            TableRelation = "ecContainer Type";
        }
        field(50015; "ecExpected Shipping Date"; Date)
        {
            Caption = 'Expected shipping date';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            Editable = false;
        }
        field(50017; "ecDelay Reason Code"; Code[20])
        {
            Caption = 'Delay reason code';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            TableRelation = "ecDelay Reason";
        }
        field(50020; "ecTransport Status"; Code[20])
        {
            Caption = 'Transport status';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            Editable = false;
            TableRelation = "ecTransport Status";
        }
        field(50022; "ecShip. Documentation Status"; Option)
        {
            Caption = 'Documentation status';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            Editable = false;
            OptionCaption = 'None,,,,,Partial,,,,,Complete';
            OptionMembers = None,,,,,Partial,,,,,Complete;
        }
        field(50024; "ecShiping Doc. Notes"; Text[100])
        {
            Caption = 'Documentation notes';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            Editable = false;
        }
        field(50030; "ecConsumer Unit of Measure"; Code[10])
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
        field(50031; "ecQty. per Consumer UM"; Decimal)
        {
            Caption = 'Qty. per Consumer UM';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'CS_VEN_014';
            Editable = false;
        }
        field(50032; "ecQuantity (Consumer UM)"; Decimal)
        {
            Caption = 'Quantity (Consumer UM)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'CS_VEN_014';
            Editable = false;
        }
    }
}
