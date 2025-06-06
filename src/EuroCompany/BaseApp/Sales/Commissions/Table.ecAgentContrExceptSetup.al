namespace EuroCompany.BaseApp.Sales.Commissions;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Item;

//AFC_CS_005
table 50037 "ecAgent Contr Except Setup"
{
    Caption = 'Agent Contract Exceptions Setup';
    DataClassification = CustomerContent;
    DrillDownPageId = "ecAgent Contr Except Setup";
    Extensible = true;
    Description = 'AFC_CS_005';

    fields
    {
        field(1; "Commission Posting Group"; Code[20])
        {
            Caption = 'Commission Posting Group';
            Description = 'AFC_CS_005';
            DataClassification = CustomerContent;
            tableRelation = "ApsSCM Comm. Posting Group".Code where(Type = const(Salesperson)); //Salesperson            
        }
        field(2; "Name Commission Posting Group"; Text[100])
        {
            Caption = 'Name Commission Posting Group';
            Description = 'AFC_CS_005';
            FieldClass = "FlowField";
            CalcFormula = lookup("ApsSCM Comm. Posting Group"."Description" where("Code" = field("Commission Posting Group")));
            Editable = false;
        }
        field(3; "Customer Type"; Enum "ecCustomer Type")
        {
            Caption = 'Customer Type';
            Description = 'AFC_CS_005';
            DataClassification = CustomerContent;
        }
        field(4; "Customer Type Code"; code[20])
        {
            Caption = 'Customer Type Code';
            Description = 'AFC_CS_005';
            DataClassification = CustomerContent;

            TableRelation = if ("Customer Type" = const(Customer)) "Customer"
            else
            if ("Customer Type" = const("Segment Customer Business")) "APsTRD Business Segment";

            trigger OnValidate()
            var
                Customer: Record "Customer";
                APsTRDBusinessSegment: Record "APsTRD Business Segment";
            begin
                case "Customer Type" of
                    "Customer Type"::Customer:
                        begin
                            Customer.Get("Customer Type Code");
                            "Name Customer Type Code" := Customer.Name;
                        end;
                    "Customer Type"::"Segment Customer Business":
                        begin
                            APsTRDBusinessSegment.Get("Customer Type Code");
                            "Name Customer Type Code" := APsTRDBusinessSegment.Description;
                        end;
                end;
            end;
        }
        field(5; "Name Customer Type Code"; Text[100])
        {
            Caption = 'Name Customer Type Code';
            Description = 'AFC_CS_005';
            DataClassification = CustomerContent;
        }
        field(6; "Role Code"; Code[20])
        {
            Caption = 'Role Code';
            Description = 'AFC_CS_005';
            DataClassification = CustomerContent;
            TableRelation = "ApsSCM Commission Role";
        }
        field(7; "Item Type"; enum "ecItem Type Commission")
        {
            Caption = 'Item Type';
            Description = 'AFC_CS_005';
            DataClassification = CustomerContent;
        }
        field(8; "Item Type Code"; code[20])
        {
            Caption = 'Item Type Code';
            Description = 'AFC_CS_005';
            DataClassification = CustomerContent;

            TableRelation = if ("Item Type" = const(Item)) "Item"
            else
            if ("Item Type" = const("Product Segment")) "APsTRD Product Segment";

            trigger OnValidate()
            var
                Item: Record "Item";
                APsTRDProductSegment: Record "APsTRD Product Segment";
            begin
                case "Item Type" of
                    "Item Type"::Item:
                        begin
                            Item.Get("Item Type Code");
                            "Name Item Type Code" := Item.Description;
                        end;
                    "Item Type"::"Product Segment":
                        begin
                            APsTRDProductSegment.Get("Item Type Code");
                            "Name Item Type Code" := APsTRDProductSegment.Description;
                        end;
                end;
            end;
        }
        field(9; "Name Item Type Code"; Text[100])
        {
            Caption = 'Name Item Type Code';
            Description = 'AFC_CS_005';
            DataClassification = CustomerContent;
        }
        field(10; "Salesperson Commission"; decimal)
        {
            Caption = 'Name Item Type Code';
            Description = 'AFC_CS_005';
            DataClassification = CustomerContent;
        }
        field(11; ID; integer)
        {
            Caption = 'ID';
            Description = 'AFC_CS_005';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(12; Priority; Integer)
        {
            Caption = 'Priority';
            Description = 'AFC_CS_005';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "ID")
        {
            Clustered = true;
        }
        key(Key2; "Commission Posting Group", "Customer Type", "Customer Type Code", "Role Code",
                  "Item Type", "Item Type Code", "Salesperson Commission", Priority)
        {
            Clustered = false;
        }
        key(Key3; Priority)
        {
            Clustered = false;
        }
        key(Key4; Priority, "Commission Posting Group")
        {
            Clustered = false;
        }
        key(Key5; Priority, "Commission Posting Group", "Role Code")
        {
            Clustered = false;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Commission Posting Group", "Customer Type", "Customer Type Code", "Role Code",
                             "Item Type", "Item Type Code", "Salesperson Commission")
        {
        }
    }
}