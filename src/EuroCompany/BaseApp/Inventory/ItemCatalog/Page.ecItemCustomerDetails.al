namespace EuroCompany.BaseApp.Inventory.ItemCatalog;
using Microsoft.Inventory.Item.Catalog;

page 50074 "ecItem Customer Details"
{
    ApplicationArea = All;
    Caption = 'Item Customer Details';
    DelayedInsert = true;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "ecItem Customer Details";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.") { Visible = not HideItemFields; }
                field("Item Description"; Rec."Item Description") { DrillDown = false; Visible = not HideItemFields; }
                field("Variant Code"; Rec."Variant Code") { Visible = false; }
                field("Customer No."; Rec."Customer No.") { Visible = not HideCustomerFields; }
                field("Customer Name"; Rec."Customer Name") { DrillDown = false; Visible = not HideCustomerFields; }
                field("Pallet Type"; Rec."Pallet Type") { }
                field("No. Of Units per Layer"; Rec."No. Of Units per Layer") { BlankZero = true; }
                field("No. of Layers per Pallet"; Rec."No. of Layers per Pallet") { BlankZero = true; }
                field("Calc. for Max Usable Date"; Rec."Calc. for Max Usable Date") { }
            }
        }
    }

    var
        HideItemFields: Boolean;
        HideCustomerFields: Boolean;


    internal procedure SetItemFilters(pItemNo: Code[20]; pVariantCode: Code[10]; pHideItemFields: Boolean)
    begin
        Rec.Reset();
        Rec.SetRange("Item No.", pItemNo);

        Rec.SetRange("Variant Code");
        if (pVariantCode <> '') then begin
            Rec.SetRange("Variant Code", pVariantCode);
        end;

        HideItemFields := pHideItemFields;
    end;

    internal procedure SetCustomerFilters(pCustomerNo: Code[20]; pHideCustomerFields: Boolean)
    begin
        Rec.Reset();
        Rec.SetCurrentKey("Customer No.");
        Rec.SetRange("Customer No.", pCustomerNo);
        HideCustomerFields := pHideCustomerFields;
    end;

}
