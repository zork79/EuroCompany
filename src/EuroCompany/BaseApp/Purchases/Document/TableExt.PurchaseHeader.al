namespace EuroCompany.BaseApp.Purchases.Document;

using EuroCompany.BaseApp.Purchases.Vendor;
using Microsoft.Purchases.History;
using EuroCompany.BaseApp.Setup;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;
tableextension 80039 PurchaseHeader extends "Purchase Header"
{
    fields
    {
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                lVendor: Record Vendor;
            begin
                //CS_ACQ_013-s
                "ecVendor Classification" := '';
                if lVendor.Get("Buy-from Vendor No.") then "ecVendor Classification" := lVendor."ecVendor Classification";
                //CS_ACQ_013-e
            end;
        }
        modify("Document Date")
        {
            trigger OnBeforeValidate()
            var
                EcSetup: Record "ecGeneral Setup";
            begin
                EcSetup.Get();
                if EcSetup."Use Custom Calc. Due Date" then
                    if EcSetup."Use Document Date As Default" then
                        Rec.Validate("ecRef. Date For Calc. Due Date", Rec."Document Date");
            end;
        }
        field(50000; "ecRef. Date For Calc. Due Date"; Date)
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
        field(50008; "ecIncoterms Place"; Code[20])
        {
            Caption = 'Incoterms place';
            DataClassification = CustomerContent;
            TableRelation = "ecIncoterms Place";
        }
        field(50015; "ecVendor Classification"; Code[20])
        {
            Caption = 'Vendor classification';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            Editable = false;
            TableRelation = "ecVendor Classification";
        }
        // field(50020; "ecNo. Invoice Cust. Decl."; Code[20])
        // {
        //     Caption = 'No. invoice customer declaration';
        //     DataClassification = CustomerContent;
        // }
        field(50016; "ecNotes payment suspension"; Text[250])
        {
            Caption = 'Notes payment suspension';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_019';
        }

    }
}