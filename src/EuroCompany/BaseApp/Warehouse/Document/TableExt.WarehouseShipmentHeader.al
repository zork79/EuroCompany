namespace EuroCompany.BaseApp.Warehouse.Document;

using EuroCompany.BaseApp.Sales;
using Microsoft.Warehouse.Document;

tableextension 80036 "Warehouse Shipment Header" extends "Warehouse Shipment Header"
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
        modify("Posting Date")
        {
            trigger OnAfterValidate()
            var
                lSalesFunctions: Codeunit "ecSales Functions";
            begin
                //CS_AFC_014-s
                lSalesFunctions.UpdateWhseShptDeferralInvDate(Rec);
                //CS_AFC_014-e
            end;
        }
        modify("Shipping Agent Service Code")
        {
            trigger OnAfterValidate()
            var
                lSalesFunctions: Codeunit "ecSales Functions";
            begin
                //CS_AFC_014-s
                lSalesFunctions.UpdateWhseShptDeferralInvDate(Rec);
                //CS_AFC_014-e                
            end;
        }
        field(50000; "ecNo. Parcels"; Integer)
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
        field(50001; "ecManual Parcels"; Boolean)
        {
            Caption = 'Manual parcels';
            DataClassification = CustomerContent;
            Description = 'CS_LOG_001';
            Editable = false;
        }
        field(50008; "ecNo. Theoretical Pallets"; Decimal)
        {
            Caption = 'No. of theoretical pallets';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 1;
            Description = 'CS_LOG_001';
            Editable = false;
        }
        field(50042; "ecProduct Segment No."; Code[20])
        {
            Caption = 'Product Segment No.';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_032';
            TableRelation = "APsTRD Product Segment"."No.";

            trigger OnValidate()
            var
            begin
                //CS_VEN_032-VI-s
                AltAWP_TestStatusOpen();

                if ("ecProduct Segment No." <> '') then begin
                    TestField("AltAWPSource Document Type", "AltAWPSource Document Type"::"Sales Order");
                    TestField("AltAWPSubject Type", "AltAWPSubject Type"::Customer);
                    TestField("AltAWPSubject No.");
                end;

                if ("ecProduct Segment No." <> xRec."ecProduct Segment No.") then begin
                    AltAWP_ErrorIfLineExist(FieldCaption("ecProduct Segment No."));
                end;

                CalcFields("ecProduct Segment Description");
                //CS_VEN_032-VI-e
            end;

            trigger OnLookup()
            var
                lecSalesFunctions: Codeunit "ecSales Functions";
                lSelectedValue: Text;
            begin
                //CS_VEN_032-VI-s
                lSelectedValue := "ecProduct Segment No.";
                if lecSalesFunctions.WhseShipHeader_LookupProductSegment(Rec, lSelectedValue) then begin
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
    }
}
