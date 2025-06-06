namespace EuroCompany.BaseApp.Inventory.ItemCatalog;

using Microsoft.Inventory.Item;
using Microsoft.Sales.Customer;

table 50044 "ecItem Customer Details"
{
    Caption = 'Item Customer Details';
    DataClassification = CustomerContent;
    Description = 'GAP_PRO_001';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(2; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                CalcFields("Customer Name");
            end;
        }
        field(5; "Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Pallet Type"; Code[20])
        {
            Caption = 'Pallet format';
            TableRelation = "AltAWPLogistic Unit Format".Code where("Application Type" = filter("Box Only" | "Box and Pallet"));
        }
        field(21; "No. Of Units per Layer"; Decimal)
        {
            Caption = 'No. of units per layer';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(22; "No. of Layers per Pallet"; Decimal)
        {
            Caption = 'No. of layers per pallet';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(50; "Calc. for Max Usable Date"; DateFormula)
        {
            Caption = 'Calculation for max usable date';
            Description = 'CS_PRO_008';

            trigger OnValidate()
            var
                lPositiveDateFormulaErr: Label 'The date formula value must be negative: %1';
            begin
                if (Format("Calc. for Max Usable Date") <> '') then begin
                    if (CalcDate("Calc. for Max Usable Date", Today) > Today) then begin
                        Error(lPositiveDateFormulaErr, "Calc. for Max Usable Date");
                    end;
                end;
            end;
        }
    }
    keys
    {
        key(PK; "Item No.", "Variant Code", "Customer No.")
        {
            Clustered = true;
        }
        key(Key2; "Customer No.") { }
    }

    trigger OnInsert()
    begin
        TestRecord();
    end;

    trigger OnModify()
    begin
        TestRecord();
    end;

    trigger OnRename()
    begin
        TestRecord();
    end;

    local procedure TestRecord()
    begin
        TestField("Customer No.");

        if ("No. of Layers per Pallet" <> 0) or ("No. Of Units per Layer" <> 0) then begin
            Rec.TestField("No. Of Units per Layer");
            Rec.TestField("No. of Layers per Pallet");
        end;
    end;

    procedure GetCustomerSettings(pItemNo: Code[20]; pVariantCode: Code[20]; pCustomerNo: Code[20]): Boolean
    begin
        Rec.Reset();
        Rec.SetCurrentKey("Customer No.");
        Rec.SetRange("Customer No.", pCustomerNo);
        Rec.SetFilter("Item No.", '%1|%2', pItemNo, '');
        Rec.SetFilter("Variant Code", '%1|%2', pVariantCode, '');
        if Rec.FindLast() then begin
            exit(true);
        end;

        exit(false);
    end;
}
