namespace EuroCompany.BaseApp.Sales.AdvancedTrade;

using Microsoft.Sales.Customer;
using System.Email;

table 50018 "ecSales Manager"
{
    Caption = 'Sales Manager';
    DataClassification = CustomerContent;
    Description = 'CS_VEN_031';
    DrillDownPageId = "ecSales Managers";
    LookupPageId = "ecSales Managers";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;

            trigger OnValidate()
            begin
                TestField(Code);
            end;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(50; "E-Mail"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("E-Mail");
            end;
        }
        field(55; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(56; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Code", Name) { }
        fieldgroup(Brick; "Code", Name) { }
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

    trigger OnDelete()
    var
        lCustomer: Record Customer;
        lecCustomerProductSegments: Record "ecCustomer Product Segments";
        lLinkedCustomerExistErr: Label 'You cannot delete %1 because there is at least one customer associated to this sales manager.';
    begin
        if (Code <> '') then begin
            lCustomer.Reset();
            lCustomer.SetRange("ecSales Manager Code", Code);
            if not lCustomer.IsEmpty then Error(lLinkedCustomerExistErr);

            //CS_VEN_032-VI-s
            lecCustomerProductSegments.Reset();
            lecCustomerProductSegments.SetRange("Sales Manager Code", Code);
            if not lecCustomerProductSegments.IsEmpty then begin
                lecCustomerProductSegments.ModifyAll("Sales Manager Code", '');
            end;
            //CS_VEN_032-VI-e
        end;
    end;

    local procedure TestRecord()
    begin
        TestField(Code);
    end;
}
