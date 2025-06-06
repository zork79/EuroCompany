namespace EuroCompany.BaseApp.Setup;

using Microsoft.Sales.Customer;

table 50005 "ecDelivery Point Setup"
{
    Caption = 'Delivery point setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(2; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Ship-to Code"; Code[20])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."));

            trigger OnValidate()
            begin
                CalcFields("Ship-to Name");
            end;
        }
        field(11; "Ship-to Name"; Text[100])
        {
            CalcFormula = lookup("Ship-to Address".Name where(Code = field("Ship-to Code")));
            Caption = 'Ship-to Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Product Segment No."; Code[20])
        {
            Caption = 'Product Segment No.';
        }
        field(21; "Product Segment Description"; Text[100])
        {
            Caption = 'Product Segment Description';
        }
        field(30; "Data Type"; Text[10])
        {
            Caption = 'Data Type';
            TableRelation = "APsEII Other Mgt. Data Type";
        }
        field(40; "ID Table"; Integer)
        {
            Caption = 'ID Table';
            //TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table), "Object ID" = const(18), "Object ID" = const(222), "Object ID" = const(50019));
        }
        field(41; "Table Name"; Text[30])
        {
            Caption = 'Table Name';
        }
        field(50; "Field Name"; Text[30])
        {
            Caption = 'Field Name';
        }
        field(51; "Field Number"; Integer)
        {
            Caption = 'Field Number';
        }
        field(60; "Text Reference"; Text[60])
        {
            Caption = 'Text Reference';
        }
    }

    keys
    {
        key(PK; "Customer No.", "Ship-to Code", "Product Segment No.")
        {
            Clustered = true;
        }
    }
}