namespace EuroCompany.BaseApp.Sales.AdvancedTrade;

using EuroCompany.BaseApp.Sales;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.Shipping;

table 50019 "ecCustomer Product Segments"
{
    Caption = 'Customer Product Segments';
    DataClassification = CustomerContent;
    Description = 'CS_VEN_032';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                CalcFields("Customer Name");
            end;
        }
        field(3; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Product Segment No."; Code[20])
        {
            Caption = 'Product Segment No.';
            TableRelation = "APsTRD Product Segment"."No.";

            trigger OnValidate()
            begin
                CalcFields("Product Segment Description");
            end;
        }
        field(6; "Product Segment Description"; Text[100])
        {
            CalcFormula = lookup("APsTRD Product Segment".Description where("No." = field("Product Segment No.")));
            Caption = 'Product Segment Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(11; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(20; "Sales Manager Code"; Code[20])
        {
            Caption = 'Sales Manager Code';
            Description = 'CS_VEN_031';
            TableRelation = "ecSales Manager".Code;

            trigger OnValidate()
            var
                lSalesManager: Record "ecSales Manager";
            begin
                //CS_VEN_031-VI-s
                if ("Sales Manager Code" <> '') then begin
                    lSalesManager.Get("Sales Manager Code");
                    lSalesManager.TestField(Blocked, false);
                end;

                CalcFields("Sales Manager Name");
                //CS_VEN_031-VI-e
            end;
        }
        field(21; "Sales Manager Name"; Text[100])
        {
            CalcFormula = lookup("ecSales Manager".Name where(Code = field("Sales Manager Code")));
            Caption = 'Sales Manager Name';
            Description = 'CS_VEN_031';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
            Description = 'CS_VEN_039';

            trigger OnValidate()
            var
            begin
                if (CurrFieldNo = FieldNo("Shipping Agent Code")) and (Rec."Shipping Agent Code" <> xRec."Shipping Agent Code") then begin
                    "Shipping Agent Service Code" := '';
                end;
            end;
        }
        field(31; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));
            Description = 'CS_VEN_039';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Customer No.", "Product Segment No.", "Starting Date") { }
        key(Key3; "Customer No.", "Starting Date") { }
        key(Key4; "Product Segment No.", "Customer No.", "Starting Date") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Customer No.", "Product Segment No.") { }
        fieldgroup(Brick; "Customer No.", "Product Segment No.") { }
    }

    trigger OnInsert()
    begin
        TestRecord();
    end;

    trigger OnModify()
    begin
        TestRecord();
    end;

    trigger OnDelete()
    var
        lRecordCommentLine: Record "AltAWPRecord Comment Line";
        lSalesFunctions: Codeunit "ecSales Functions";
    begin
        //CS_VEN_034-s
        if (Rec."Entry No." <> 0) then begin
            if lSalesFunctions.FindProductSegmentComments(Rec, lRecordCommentLine, 0) then begin
                lRecordCommentLine.DeleteAll(true);
            end;
        end;
        //CS_VEN_034-e
    end;

    local procedure TestRecord()
    var
        lecCustomerProductSegments2: Record "ecCustomer Product Segments";
        lAlreadyExistingRecErr: Label 'The product segment %1 is already assigned to the customer %2';
    begin
        // Check mandatory fields
        TestField("Customer No.");
        TestField("Product Segment No.");
        TestField("Starting Date");

        // Check duplicates
        lecCustomerProductSegments2.Reset();
        lecCustomerProductSegments2.SetCurrentKey("Customer No.", "Product Segment No.", "Starting Date");
        lecCustomerProductSegments2.SetRange("Customer No.", "Customer No.");
        lecCustomerProductSegments2.SetRange("Product Segment No.", "Product Segment No.");
        lecCustomerProductSegments2.SetRange("Starting Date", "Starting Date");
        lecCustomerProductSegments2.SetFilter("Entry No.", '<>%1', "Entry No.");
        if not lecCustomerProductSegments2.IsEmpty then Error(lAlreadyExistingRecErr, "Product Segment No.", "Customer No.");
    end;

    internal procedure GetCustomerProductSegment(pCustomerNo: Code[20]; pProductSegmentNo: Code[20]): Boolean
    var
        lecCustomerProductSegments: Record "ecCustomer Product Segments";
    begin
        if (pCustomerNo <> '') and (pProductSegmentNo <> '') then begin
            lecCustomerProductSegments.Reset();
            lecCustomerProductSegments.SetCurrentKey("Customer No.", "Product Segment No.", "Starting Date");
            lecCustomerProductSegments.SetRange("Customer No.", pCustomerNo);
            lecCustomerProductSegments.SetRange("Product Segment No.", pProductSegmentNo);
            lecCustomerProductSegments.SetRange("Starting Date", 0D, Today);
            lecCustomerProductSegments.SetFilter("Ending Date", '%1|%2..', 0D, Today);
            if not lecCustomerProductSegments.IsEmpty then begin
                lecCustomerProductSegments.FindLast();
                Rec := lecCustomerProductSegments;
                exit(true);
            end;
        end;

        exit(false);
    end;
}
