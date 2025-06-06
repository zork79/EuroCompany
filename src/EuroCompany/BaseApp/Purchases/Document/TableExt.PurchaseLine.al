namespace EuroCompany.BaseApp.Purchases.Document;

using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Catalog;
using Microsoft.Purchases.Document;
using Microsoft.Warehouse.Document;

tableextension 80017 "Purchase Line" extends "Purchase Line"
{
    fields
    {

        modify("No.")
        {
            trigger OnAfterValidate()
            var
                lItem: Record Item;
                lItemVendor: Record "Item Vendor";
            begin
                //CS_ACQ_018-s
                if (Rec."Document Type" in ["Document Type"::Order, "Document Type"::"Blanket Order"]) and (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
                    if lItem.Get(Rec."No.") then begin
                        if (lItem."ecPackaging Type" <> '') then Rec.Validate("ecPackaging Type", lItem."ecPackaging Type");
                    end;
                    if (Rec."Buy-from Vendor No." <> '') then begin
                        if lItemVendor.Get(Rec."Buy-from Vendor No.", Rec."No.", Rec."Variant Code") then begin
                            if (lItemVendor."ecPackaging Type" <> '') and (lItemVendor."ecPackaging Type" <> Rec."ecPackaging Type") then begin
                                Rec.Validate("ecPackaging Type", lItemVendor."ecPackaging Type");
                            end;
                        end;
                    end;
                end;
                //CS_ACQ_018-e
            end;
        }
        field(50000; "ecPackaging Type"; Code[20])
        {
            Caption = 'Packaging Type';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_018';
            TableRelation = "ecPackaging Type";
        }
        field(50010; "ecContainer No."; Code[100])
        {
            Caption = 'Container no.';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
        }
        field(50012; "ecContainer Type"; Code[20])
        {
            Caption = 'Container type';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            TableRelation = "ecContainer Type";
        }
        field(50015; "ecExpected Shipping Date"; Date)
        {
            Caption = 'Expected shipping date';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
        }
        field(50017; "ecDelay Reason Code"; Code[20])
        {
            Caption = 'Delay reason code';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            TableRelation = "ecDelay Reason";
        }
        field(50020; "ecTransport Status"; Code[20])
        {
            Caption = 'Transport status';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            TableRelation = "ecTransport Status";
        }
        field(50022; "ecShip. Documentation Status"; Option)
        {
            Caption = 'Documentation status';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            OptionCaption = 'None,,,,,Partial,,,,,Complete';
            OptionMembers = None,,,,,Partial,,,,,Complete;
        }
        field(50024; "ecShiping Doc. Notes"; Text[100])
        {
            Caption = 'Documentation notes';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
        }
        field(50030; "ecItem Type"; Enum "ecItem Type")
        {
            CalcFormula = lookup(Item."ecItem Type" where("No." = field("No.")));
            Caption = 'Item Type';
            Description = 'CS_PRO_043';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50031; "ecVAT Purchase Account"; Code[20])
        {
            CalcFormula = lookup("VAT Posting Setup"."Purchase VAT Account" where("VAT Bus. Posting Group" = field("VAT Bus. Posting Group"), "VAT Prod. Posting Group" = field("VAT Prod. Posting Group")));
            Caption = 'VAT Purchase Account';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50032; "ecAccount Name"; Text[100])
        {
            CalcFormula = lookup("G/L Account".Name where("No." = field("ecVAT Purchase Account")));
            Caption = 'Account Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50033; "ecPurchase Account"; Code[20])
        {
            CalcFormula = lookup("General Posting Setup"."Purch. Account" where("Gen. Bus. Posting Group" = field("Gen. Bus. Posting Group"), "Gen. Prod. Posting Group" = field("Gen. Prod. Posting Group")));
            Caption = 'Purchase Account';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50040; "ecPurch. Quote No."; Code[20])
        {
            CalcFormula = lookup("Purchase Header"."Quote No." where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Caption = 'Quote No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    trigger OnAfterModify()
    begin
        UpdateLinkedDocuments();  //CS_ACQ_013-n
    end;

    local procedure UpdateLinkedDocuments()
    var
        lWarehouseReceiptLine: Record "Warehouse Receipt Line";
        lModifyRecord: Boolean;
    begin
        //CS_ACQ_013-s
        lModifyRecord := false;
        Clear(lWarehouseReceiptLine);
        lWarehouseReceiptLine.SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.");
        lWarehouseReceiptLine.SetRange("Source Type", Database::"Purchase Line");
        lWarehouseReceiptLine.SetRange("Source Subtype", Rec."Document Type");
        lWarehouseReceiptLine.SetRange("Source No.", Rec."Document No.");
        lWarehouseReceiptLine.SetRange("Source Line No.", Rec."Line No.");
        if not lWarehouseReceiptLine.IsEmpty then begin
            lWarehouseReceiptLine.FindSet();
            repeat
                if (lWarehouseReceiptLine."ecPackaging Type" <> Rec."ecPackaging Type") then begin
                    lWarehouseReceiptLine.Validate("ecPackaging Type", Rec."ecPackaging Type");
                    lModifyRecord := true;
                end;
                if (lWarehouseReceiptLine."ecContainer No." <> Rec."ecContainer No.") then begin
                    lWarehouseReceiptLine.Validate("ecContainer No.", Rec."ecContainer No.");
                    lModifyRecord := true;
                end;
                if (lWarehouseReceiptLine."ecContainer Type" <> Rec."ecContainer Type") then begin
                    lWarehouseReceiptLine.Validate("ecContainer Type", Rec."ecContainer Type");
                    lModifyRecord := true;
                end;
                if (lWarehouseReceiptLine."ecExpected Shipping Date" <> Rec."ecExpected Shipping Date") then begin
                    lWarehouseReceiptLine.Validate("ecExpected Shipping Date", Rec."ecExpected Shipping Date");
                    lModifyRecord := true;
                end;
                if (lWarehouseReceiptLine."ecDelay Reason Code" <> Rec."ecDelay Reason Code") then begin
                    lWarehouseReceiptLine.Validate("ecDelay Reason Code", Rec."ecDelay Reason Code");
                    lModifyRecord := true;
                end;
                if (lWarehouseReceiptLine."ecTransport Status" <> Rec."ecTransport Status") then begin
                    lWarehouseReceiptLine.Validate("ecTransport Status", Rec."ecTransport Status");
                    lModifyRecord := true;
                end;
                if (lWarehouseReceiptLine."ecShip. Documentation Status" <> Rec."ecShip. Documentation Status") then begin
                    lWarehouseReceiptLine.Validate("ecShip. Documentation Status", Rec."ecShip. Documentation Status");
                    lModifyRecord := true;
                end;
                if (lWarehouseReceiptLine."ecShiping Doc. Notes" <> Rec."ecShiping Doc. Notes") then begin
                    lWarehouseReceiptLine.Validate("ecShiping Doc. Notes", Rec."ecShiping Doc. Notes");
                    lModifyRecord := true;
                end;
                if lModifyRecord then lWarehouseReceiptLine.Modify(true);
            until (lWarehouseReceiptLine.Next() = 0);
        end;
        //CS_ACQ_013-e
    end;
}
