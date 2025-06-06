namespace EuroCompany.BaseApp.Manufacturing.Document;
using EuroCompany.BaseApp.Restrictions.Rules;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.Manufacturing.Document;
using Microsoft.Warehouse.Structure;

table 90001 "ecComponent Availability Buff."
{
    Caption = 'Availability components';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(10; "Entry Type"; Enum "ecAvailability Buffer Grouping")
        {
            Caption = 'Entry Type';
            Editable = false;
        }
        field(15; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(50; "Prod. Order Status"; Enum "Production Order Status")
        {
            Caption = 'Prod. Order Status';
        }
        field(55; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            TableRelation = "Production Order"."No." where(Status = field("Prod. Order Status"));
        }
        field(58; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
            TableRelation = "Prod. Order Line"."Line No." where(Status = field("Prod. Order Status"), "Prod. Order No." = field("Prod. Order No."));
        }
        field(59; "Component Line No."; Integer)
        {
            Caption = 'Component Line No.';
        }
        field(62; "Parent Item No."; Code[20])
        {
            Caption = 'Parent item no.';
            TableRelation = Item."No.";
        }
        field(80; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(83; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(87; Description; Text[100])
        {
            Caption = 'Description ';
        }
        field(88; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(92; "Starting Date-Time"; DateTime)
        {
            Caption = 'Starting Date-Time';
        }
        field(93; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(94; "Starting Time"; Time)
        {
            Caption = 'Starting Time';
        }
        field(100; "Ending Date-Time"; DateTime)
        {
            Caption = 'Ending Date-Time';
        }
        field(101; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(102; "Ending Time"; Time)
        {
            Caption = 'Ending Time';
        }
        field(110; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(130; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
        }
        field(133; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code where("Location Code" = field("Location Code"));
        }
        field(134; "Reserved Cons. Bin"; Boolean)
        {
            Caption = 'Reserved Consumption Bin';

            trigger OnValidate()
            var
                lProdOrderComponent: Record "Prod. Order Component";
            begin
                lProdOrderComponent.Get(Rec."Prod. Order Status", Rec."Prod. Order No.", Rec."Prod. Order Line No.", Rec."Component Line No.");
                lProdOrderComponent.Validate("AltAWPUse Reserved Cons. Bin", Rec."Reserved Cons. Bin");
                lProdOrderComponent.Modify(true);
                Rec."Bin Code" := lProdOrderComponent."Bin Code";
            end;
        }
        field(140; "Unit of Measure code"; Code[10])
        {
            Caption = 'Unit of Measure code';
            TableRelation = "Unit of Measure";
        }
        field(145; Quantity; Decimal)
        {
            Caption = 'Quantity';
            //DecimalPlaces = 2 : 5;;
        }
        field(200; "Min Consumption Date"; Date)
        {
            Caption = 'Min Consumption Date';
        }
        field(205; "Max Consumption Date"; Date)
        {
            Caption = 'Max Consumption Date';
        }
        field(215; "Reorder Policy"; Enum "Reordering Policy")
        {
            Caption = 'Reorder Policy';
        }
        field(220; "Reorder Point"; Decimal)
        {
            Caption = 'Reorder Point';
            //DecimalPlaces = 2 : 5;;
        }
        field(225; "Safety Stock Quantity"; Decimal)
        {
            Caption = 'Safety Stock Quantity';
            //DecimalPlaces = 2 : 5;;
        }
        field(400; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(540; "Qty. on Component Lines"; Decimal)
        {
            Caption = 'Qty. on Component Lines (Total)';
            //DecimalPlaces = 2 : 5;;
            Editable = false;
        }
        field(570; "Qty.Rel. Component Lines"; Decimal)
        {
            Caption = 'Qty. on Component Lines (Released)';
            //DecimalPlaces = 2 : 5;;
            Editable = false;
        }
        field(590; "Inventory Constraint"; Decimal)
        {
            Caption = 'Inventory Constraint';
            //DecimalPlaces = 2 : 5;;
        }
        field(595; "Inventory Not Constraint"; Decimal)
        {
            Caption = 'Inventory Not Constraint';
            //DecimalPlaces = 2 : 5;;
        }
        field(600; "Inventory Total"; Decimal)
        {
            Caption = 'Inventory (Total)';
            //DecimalPlaces = 2 : 5;;
        }
        field(610; "Usable Quantity"; Decimal)
        {
            Caption = 'Usable quantity';
            //DecimalPlaces = 2 : 5;;
        }
        field(615; "Expired Quantity"; Decimal)
        {
            Caption = 'Inventory expired';
            //DecimalPlaces = 2 : 5;;
        }
        field(5000; "Exists Restrictions"; Boolean)
        {
            Caption = 'Exists restrictions';
        }
        field(5003; "Exists Restrictions 2"; Boolean)
        {
            Caption = 'Exists restrictions';
        }
        field(5010; "Restriction Rule Code"; Code[50])
        {
            Caption = 'Restriction rule code';
            TableRelation = "ecRestriction Rule Header".Code;
            ValidateTableRelation = false;
        }
        field(5015; "Single Lot Pickings"; Boolean)
        {
            Caption = 'Single lot pickings';
        }
        field(5020; "Origin Country/Region Code"; Code[10])
        {
            Caption = 'Origin Country/Region Code';
            Editable = false;
        }
        field(5500; Selected; Boolean)
        {
            Caption = 'Selected';
        }
    }
    keys
    {
        key(PK; "Entry Type", "Entry No.")
        {
            Clustered = true;
        }
        key(Key1; "Prod. Order Status", "Prod. Order No.", "Prod. Order Line No.") { }
        key(Key2; "Prod. Order Status", "Prod. Order No.", "Prod. Order Line No.", "Component Line No.") { }
        key(Key3; "Max Consumption Date") { }
        key(Key4; "Min Consumption Date") { }
        key(Key5; "Item No.", "Variant Code", "Location Code", "Entry Type", "Restriction Rule Code", "Origin Country/Region Code", "Single Lot Pickings") { }
    }
}
