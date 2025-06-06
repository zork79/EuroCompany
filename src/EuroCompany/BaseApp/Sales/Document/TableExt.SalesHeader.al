namespace EuroCompany.BaseApp.Sales.Document;

using EuroCompany.BaseApp.Sales;
using EuroCompany.BaseApp.Sales.AdvancedTrade;
using Microsoft.Sales.Comment;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
tableextension 80021 "Sales Header" extends "Sales Header"
{
    fields
    {
        modify("AltAWPManual Parcels")
        {
            Caption = 'Manual logistic units';
            Description = 'CS_LOG_001';
        }
        modify("AltAWPParcel Units")
        {
            Caption = 'No. of logistic units';
            Description = 'CS_LOG_001';
        }
        modify("APsCredit Bank Account No.")
        {
            trigger OnAfterValidate()
            begin
                //GAP_VEN_001-s
                Rec."Company Bank Account Code" := Rec."APsCredit Bank Account No.";
                //GAP_VEN_001-e
            end;
        }
        modify("Company Bank Account Code")
        {
            trigger OnAfterValidate()
            begin
                //GAP_VEN_001-s
                Rec."APsCredit Bank Account No." := Rec."Company Bank Account Code";
                //GAP_VEN_001-e
            end;
        }
        modify("Ship-to Code")
        {
            //#305
            trigger OnAfterValidate()
            var
                ShipToAddress: Record "Ship-to Address";
            begin
                if Rec."Ship-to Code" <> '' then
                    if Rec."Ship-to Code" <> xRec."Ship-to Code" then
                        if ShipToAddress.Get(Rec."Sell-to Customer No.", Rec."Ship-to Code") then
                            if ShipToAddress."ecVAT Business Posting Group" <> '' then
                                Rec.Validate("VAT Bus. Posting Group", ShipToAddress."ecVAT Business Posting Group")
                            else
                                if Customer.Get(Rec."Sell-to Customer No.") then
                                    Rec.Validate("VAT Bus. Posting Group", Customer."VAT Bus. Posting Group");
            end;
            //#305
        }
        field(50000; "No. Of Comments"; Integer)
        {
            CalcFormula = count("Sales Comment Line" where("Document Type" = field("Document Type"), "No." = field("No."), "Document Line No." = const(0)));
            Caption = 'No. of comments';
            Description = 'CS_VEN_034';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "ecNo. Parcels"; Integer)
        {
            Caption = 'No. parcels';
            DataClassification = CustomerContent;
            Description = 'CS_LOG_001';

            trigger OnValidate()
            begin
                if (CurrFieldNo = FieldNo("ecNo. Parcels")) and (Rec."ecNo. Parcels" <> xRec."ecNo. Parcels") then begin
                    "ecManual Parcels" := true;
                end;
            end;
        }
        field(50010; "ecManual Parcels"; Boolean)
        {
            Caption = 'Manual parcels';
            DataClassification = CustomerContent;
            Description = 'CS_LOG_001';
            Editable = false;
        }
        field(50017; "ecNo. Theoretical Pallets"; Decimal)
        {
            Caption = 'No. of theoretical pallets';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 1;
            Description = 'CS_LOG_001';
            Editable = false;
        }
        field(50025; "ecShipped Lines"; Integer)
        {
            CalcFormula = count("Sales Line" where("Document Type" = field("Document Type"), "Document No." = field("No."),
                                                   "Quantity Shipped" = filter(<> 0)));
            Caption = 'Shipped lines';
            Description = 'CS_LOG_001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50026; "ecLines To Ship"; Integer)
        {
            CalcFormula = count("Sales Line" where("Document Type" = field("Document Type"), "Document No." = field("No."),
                                                   "Outstanding Quantity" = filter(<> 0)));
            Caption = 'Lines to ship';
            Description = 'CS_LOG_001';
            Editable = false;
            FieldClass = FlowField;
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
        field(50042; "ecProduct Segment No."; Code[20])
        {
            Caption = 'Product Segment No.';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_032';
            TableRelation = "APsTRD Product Segment"."No.";

            trigger OnValidate()
            var
                lxSalesHeader: Record "Sales Header";
                lecSalesFunctions: Codeunit "ecSales Functions";
            begin
                //CS_VEN_031-VI-s
                lecSalesFunctions.SalesHeader_SetDefaultSalesManager(Rec, (CurrFieldNo = FieldNo("ecProduct Segment No.")));
                //CS_VEN_031-VI-e

                //CS_VEN_032-VI-s
                lecSalesFunctions.SalesHeader_CheckProductSegment(Rec, false);
                CalcFields("ecProduct Segment Description");
                //CS_VEN_032-VI-e

                //CS_VEN_034-s
                if not lxSalesHeader.Get(Rec."Document Type", Rec."No.") then Clear(lxSalesHeader);
                lecSalesFunctions.AddProductSegmentCommentsOnSalesDoc(Rec, lxSalesHeader);
                //CS_VEN_034-e

                //CS_VEN_039-s
                lecSalesFunctions.GetShippingAgentByProductSegment(Rec);
                //CS_VEN_039-e
            end;

            trigger OnLookup()
            var
                lecSalesFunctions: Codeunit "ecSales Functions";
                lSelectedValue: Text;
            begin
                //CS_VEN_032-VI-s
                lSelectedValue := "ecProduct Segment No.";
                if lecSalesFunctions.SalesHeader_LookupProductSegment(Rec, lSelectedValue) then begin
                    Validate("ecProduct Segment No.", lSelectedValue);
                end;
                //CS_VEN_032-VI-e
            end;
        }
        field(50043; "ecProduct Segment Description"; Text[100])
        {
            CalcFormula = lookup("APsTRD Product Segment".Description where("No." = field("ecProduct Segment No.")));
            Caption = 'Product Segment Description';
            Description = 'CS_VEN_032';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50044; "ecRef. Date For Calc. Due Date"; Date)
        {
            Caption = 'Ref. Date For Calc. Due Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if (Rec."ecRef. Date For Calc. Due Date" <> xRec."ecRef. Date For Calc. Due Date") and (xRec."ecRef. Date For Calc. Due Date" <> 0D) then begin
                    Rec.Validate("Payment Terms Code");
                    Rec.Validate("Prepmt. Payment Terms Code");
                end;
            end;
        }
    }
}
