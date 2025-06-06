namespace EuroCompany.BaseApp.Manufacturing.Routing;

using Microsoft.Inventory.Item;
using Microsoft.Manufacturing.Routing;

table 50003 "ecAlternative Routing for Item"
{
    Caption = 'Alternative Routing for Item';
    DataClassification = CustomerContent;
    Description = 'GAP_PRO_003';

    fields
    {
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";

            trigger OnValidate()
            begin
                CalcFields("Item Description");
            end;
        }
        field(20; "Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            TableRelation = "Routing Header"."No." where(Status = const(Certified));

            trigger OnValidate()
            begin
                CalcFields("Routing Description");
            end;
        }
        field(60; "Routing Description"; Text[100])
        {
            CalcFormula = lookup("Routing Header".Description where("No." = field("Routing No.")));
            Caption = 'Routing Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Production Process Type"; Enum "ecProduction Process Type")
        {
            CalcFormula = lookup("Routing Header"."ecProduction Process Type" where("No." = field("Routing No.")));
            Caption = 'Production Process Type';
            Description = 'CS_QMS_011';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(PK; "Item No.", "Routing No.")
        {
            Clustered = true;
        }
    }
}
