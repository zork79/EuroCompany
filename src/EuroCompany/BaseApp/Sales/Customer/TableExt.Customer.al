namespace EuroCompany.BaseApp.Sales.Customer;

using EuroCompany.BaseApp.Activity;
using EuroCompany.BaseApp.Sales.AdvancedTrade;
using Microsoft.Sales.Customer;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Sales.Receivables;
using EuroCompany.BaseApp.Inventory.ItemCatalog;

tableextension 80008 Customer extends Customer
{
    fields
    {
        field(50000; ecInsurance; Boolean)
        {
            Caption = 'Insurance';
            DataClassification = CustomerContent;
            Description = 'CS_LOG_001';
        }
        field(50010; "ecPeriod Exc.Max Ship.Date"; DateFormula)
        {
            Caption = 'Period exceeding max shipping date allowed';
            DataClassification = CustomerContent;
            Description = 'CS_LOG_001';
        }
        field(50020; "ecDefault Priority Code"; Code[20])
        {
            Caption = 'Default Priority Code';
            DataClassification = CustomerContent;
            Description = 'CS_LOG_001';
        }
        field(50030; "ecAllow Partial Picking/Ship."; Boolean)
        {
            Caption = 'Allow Partial Picking/Shipping';
            DataClassification = CustomerContent;
            Description = 'CS_LOG_001';
        }
        field(50040; "ecSales Manager Code"; Code[20])
        {
            Caption = 'Sales Manager Code';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_031';
            TableRelation = "ecSales Manager".Code;

            trigger OnValidate()
            var
                lSalesManager: Record "ecSales Manager";
            begin
                //CS_VEN_031-VI-s
                if ("ecSales Manager Code" <> '') then begin
                    lSalesManager.Get("ecSales Manager Code");
                    lSalesManager.TestField(Blocked, false);
                end;

                CalcFields("ecSales Manager Name");
                //CS_VEN_031-VI-e
            end;
        }
        field(50041; "ecSales Manager Name"; Text[100])
        {
            CalcFormula = lookup("ecSales Manager".Name where(Code = field("ecSales Manager Code")));
            Caption = 'Sales Manager Name';
            Description = 'CS_VEN_031';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50042; "ecGroup Ship By Prod. Segment"; Boolean)
        {
            Caption = 'Group Shipments by Product Segment';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_033';

            trigger OnValidate()
            begin
                //CS_VEN_033-VI-s
                if (CurrFieldNo = FieldNo("ecGroup Ship By Prod. Segment")) then begin
                    if "ecGroup Ship By Prod. Segment" then begin
                        "ecGroup Inv. By Prod. Segment" := true;
                    end;
                end;
                //CS_VEN_033-VI-e
            end;
        }
        field(50043; "ecGroup Inv. By Prod. Segment"; Boolean)
        {
            Caption = 'Group Invoice by Product Segment';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_033';

            trigger OnValidate()
            begin
                //CS_VEN_033-VI-s
                if (CurrFieldNo = FieldNo("ecGroup Inv. By Prod. Segment")) then begin
                    if "ecGroup Inv. By Prod. Segment" then begin
                        "ecGroup Ship By Prod. Segment" := true;
                    end;
                end;
                //CS_VEN_033-VI-e
            end;
        }
        field(50045; ecActivity; Code[20])
        {
            Caption = 'Activity';
            DataClassification = CustomerContent;
            TableRelation = ecActivity.Code;

            trigger OnValidate()
            var
                Activity: Record ecActivity;
            begin
                if (Rec.ecActivity <> xRec.ecActivity) then
                    if (Rec.ecActivity <> '') then begin
                        if Activity.Get(Rec.ecActivity) then
                            if Activity."Commercial Area Code" <> '' then
                                Validate("ecCommercial Area", Activity."Commercial Area Code")
                            else
                                Validate("ecCommercial Area", '');
                    end else
                        Validate("ecCommercial Area", '');

                Rec.CalcFields("ecDescription Activity");
            end;
        }

        field(50046; "ecDescription Activity"; Text[50])
        {
            CalcFormula = lookup(ecActivity.Description where(Code = field(ecActivity)));
            Caption = 'Description Activity';
            Editable = false;
            FieldClass = FlowField;

        }
        field(50047; "ecCommercial Area"; Code[20])
        {
            Caption = 'Commercial Area';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "ecCommercial Area".Code;

            trigger OnValidate()
            begin
                Rec.CalcFields("ecDescription Commercial Area");
            end;
        }

        field(50048; "ecDescription Commercial Area"; Text[50])
        {
            CalcFormula = lookup("ecCommercial Area".Description where(Code = field("ecCommercial Area")));
            Caption = 'Description Commercial Area';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50049; "ecBalance Credit Insured"; Decimal)
        {
            Caption = 'Balance Credit Insured';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50055; "ecShort Name"; Text[20])
        {
            Caption = 'Short name';
            DataClassification = CustomerContent;
            Description = 'GAP_VEN_001';
        }
        //#229
        field(50060; "ecMember's CPR Code"; Code[10])
        {
            Caption = 'Member s CPR Code';
            DataClassification = CustomerContent;
        }
        //#229
        field(50070; "Office Manager"; Code[20])
        {
            Caption = 'Office manager';
            DataClassification = CustomerContent;
            Description = 'GAP_Issue_445';
            TableRelation = Resource."No.";

            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                if ("Office Manager" <> '') then begin
                    if Resource.Get("Office Manager") then
                        Validate("Name office manager", Resource.Name);
                end;
            end;
        }
        field(50071; "Name office manager"; Text[100])
        {
            Caption = 'Name office manager';
            DataClassification = CustomerContent;
            Description = 'GAP_Issue_445';
        }
    }

    trigger OnDelete()
    var
        lecCustomerProductSegments: Record "ecCustomer Product Segments";
        lItemCustomerDetails: Record "ecItem Customer Details";
    begin
        //CS_VEN_032-VI-s
        lecCustomerProductSegments.Reset();
        lecCustomerProductSegments.SetCurrentKey("Customer No.", "Product Segment No.", "Starting Date");
        lecCustomerProductSegments.SetRange("Customer No.", "No.");
        if not lecCustomerProductSegments.IsEmpty then lecCustomerProductSegments.DeleteAll(true);
        //CS_VEN_032-VI-e

        //GAP_PRO_001-s
        lItemCustomerDetails.Reset();
        lItemCustomerDetails.SetCurrentKey("Customer No.");
        lItemCustomerDetails.SetRange("Customer No.", "No.");
        if not lItemCustomerDetails.IsEmpty then begin
            lItemCustomerDetails.DeleteAll(true);
        end;
        //GAP_PRO_001-e
    end;
}
