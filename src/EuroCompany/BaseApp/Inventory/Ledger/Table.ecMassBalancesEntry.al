namespace EuroCompany.BaseApp.Inventory.Ledger;
using Microsoft.Foundation.Enums;
using Microsoft.Manufacturing.Document;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using EuroCompany.BaseApp.Inventory.Item;

table 50030 "ecMass Balances Entry"
{
    Caption = 'Mass Balances Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Entry Type"; Enum "Item Ledger Entry Type")
        {
            Caption = 'Entry Type';
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Origin Item No."; Code[20])
        {
            Caption = 'Origin Item No.';
            TableRelation = Item."No." where("No." = field("Origin Item No."));

            trigger OnValidate()
            begin
                Rec.CalcFields("Origin Item Description");
            end;
        }
        field(5; "Origin Lot No."; Code[50])
        {
            Caption = 'Origin Lot No.';
            TableRelation = "Lot No. Information"."Lot No." where("Lot No." = field("Origin Lot No."));
        }
        field(6; "Tracking Entry Type"; Enum "Item Ledger Entry Type")
        {
            Caption = 'Tracking Entry Type';
        }
        field(7; "Tracked Quantity"; Decimal)
        {
            Caption = 'Tracked Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(8; "Origin UoM"; Code[10])
        {
            Caption = 'Origin UoM';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Origin Item No."));
        }
        field(9; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No." where("No." = field("Item No."));

            trigger OnValidate()
            begin
                Rec.CalcFields("Item Description");
            end;
        }
        field(10; "Item Quantity"; Decimal)
        {
            Caption = 'Item Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(11; "Item UoM"; Code[10])
        {
            Caption = 'Item UoM';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(12; "Item Lot No."; Code[50])
        {
            Caption = 'Item Lot No.';
            TableRelation = "Lot No. Information"."Lot No." where("Lot No." = field("Item Lot No."));
        }
        field(13; "Source Type"; Enum "Analysis Source Type")
        {
            Caption = 'Source Type';
        }
        field(14; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = if ("Source Type" = const(Customer)) Customer."No." where("No." = field("Source No."))
            else
            if ("Source Type" = const(Vendor)) Vendor."No." where("No." = field("Source No."))
            else
            if ("Source Type" = const(Item)) Item."No." where("No." = field("Source No."));
        }
        field(15; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(16; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = CustomerContent;
        }
        field(17; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(18; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
        }
        field(19; "Srap %"; Decimal)
        {
            Caption = 'Scrap %';
            DataClassification = CustomerContent;
        }
        field(20; "Prod. Order Component Line No."; Integer)
        {
            Caption = 'Prod. Order Component Line No.';
            DataClassification = CustomerContent;
        }
        field(21; "Item ledger Entry Qty."; Decimal)
        {
            Caption = 'Item Ledger Entry Qty.';
            DataClassification = CustomerContent;
        }
        field(22; "Origin Prod. Order Line No."; Integer)
        {
            Caption = 'Origin Prod. Order Line No.';
            DataClassification = CustomerContent;
        }
        field(23; "Orig. Prod. Order Comp.LineNo."; Integer)
        {
            Caption = 'Origin Prod. Order Component Line No.';
            DataClassification = CustomerContent;
        }
        field(24; "Has Split"; Boolean)
        {
            Caption = 'Has Split';
            DataClassification = CustomerContent;
        }
        field(25; "Parent Entry No."; Integer)
        {
            Caption = 'Parent Entry No.';
            DataClassification = CustomerContent;
        }
        field(26; "Origin Item Description"; Text[100])
        {
            Caption = 'Origin Item Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Origin Item No.")));
            Editable = false;
        }
        field(27; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Editable = false;
        }
        field(28; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry"."Remaining Quantity" where("Entry No." = field("Item Ledger Entry No.")));
            Editable = false;
        }
        field(29; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry"."External Document No." where("Entry No." = field("Item Ledger Entry No.")));
            Editable = false;
        }
        // field(30; "Source Doc. No"; Code[20])
        // {
        //     Caption = 'Source Doc. No';
        //     FieldClass = FlowField;
        //     CalcFormula = lookup("Item Ledger Entry"."ecSource Doc. No." where("Entry No." = field("Item Ledger Entry No.")));
        //     Editable = false;
        // }//TODO
        field(31; "Posted Document No."; Code[20])
        {
            Caption = 'Posted Document No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry"."AltAWPSource Posted Doc. No." where("Entry No." = field("Item Ledger Entry No.")));
            Editable = false;
        }
        field(32; "Planning Level Code"; Integer)
        {
            Caption = 'Planning Level Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Line"."Planning Level Code" where(Status = const(Released), "Prod. Order No." = field("Document No."), "Line No." = field("Document Line No.")));
            Editable = false;
        }
        field(33; PurchQtyGlobal; Decimal)
        {
            Caption = 'PurchQty', Locked = true;
        }
        field(34; QtyInDirectSaleGlobal; Decimal)
        {
            Caption = 'QtyInDirectSaleGlobal', Locked = true;
        }
        field(35; QtyInSaleGlobal; Decimal)
        {
            Caption = 'QtyInSaleGlobal,', Locked = true;
        }
        field(36; NetConsumedQtyGlobal; Decimal)
        {
            Caption = 'NetConsumedQtyGlobal', Locked = true;
        }
        field(37; EffectiveConsumedQtyGlobal; Decimal)
        {
            Caption = 'EffectiveConsumedQtyGlobal', Locked = true;
        }
        field(38; RemainingQtyGlobal; Decimal)
        {
            Caption = 'RemainingQtyGlobal', Locked = true;
        }
        field(39; DDTNo; Text[100])
        {
            Caption = 'DDTNo', Locked = true;
        }
        field(40; VendorDDTNo; Text[100])
        {
            Caption = 'VendorDDTNo', Locked = true;
        }
        field(41; SourceDescr; Text[100])
        {
            Caption = 'SourceDescr', Locked = true;
        }
        field(42; ItemDescription; Text[250])
        {
            Caption = 'ItemDescription', Locked = true;
        }
        field(43; IsBold; Boolean)
        {
            Caption = 'IsBold', Locked = true;
        }
        field(44; IsBoldDirectSale; Boolean)
        {
            Caption = 'IsBoldDirectSale', Locked = true;
        }
        field(45; IsBoldOutput; Boolean)
        {
            Caption = 'IsBoldOutput', Locked = true;
        }
        field(46; "Origin Item Type"; Enum "ecItem Type")
        {
            Caption = 'Origin Item Type';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."ecItem Type" where("No." = field("Origin Item No.")));
            Editable = false;
        }
        field(47; "Item Type"; Enum "ecItem Type")
        {
            Caption = 'Item Type';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."ecItem Type" where("No." = field("Item No.")));
            Editable = false;
        }
        field(48; "Origin prod. order no."; Code[20])
        {
            Caption = 'Origin prod. order no.';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(ke2; "Posting Date")
        {
        }
    }
}
