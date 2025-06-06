namespace EuroCompany.BaseApp.Inventory.Item;

using EuroCompany.BaseApp.Inventory.Barcode;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Catalog;

tableextension 80007 "Item Reference" extends "Item Reference"
{
    fields
    {

        modify("Reference No.")
        {
            trigger OnAfterValidate()
            var
                lItem: Record Item;
                lItemReference: Record "Item Reference";
                lBarcodeFunctions: Codeunit "ecBarcode Functions";

                lError001: Label 'Barcode "%1" of type "%2" is already defined for Item No.: "%3 - %4"!';
            begin
                //CS_PRO_005-s
                if ("Reference Type" = "Reference Type"::"Bar Code") and (Rec."Reference No." <> xRec."Reference No.") and ("Reference No." <> '') then begin
                    case Rec."AltAWPBarcode Type" of
                        Rec."AltAWPBarcode Type"::"ITF-14":
                            begin
                                if lBarcodeFunctions.CheckBarcodeAlreadyExists(Rec."Reference No.") then begin
                                    Clear(lItemReference);
                                    lItemReference.SetRange("Reference No.", Rec."Reference No.");
                                    lItemReference.FindFirst();
                                    lItem.Get(lItemReference."Item No.");
                                    Error(lError001, lItemReference."Reference No.", Format(lItemReference."AltAWPBarcode Type"), lItem."No.", lItem.Description);
                                end;
                            end;
                    end;
                end;
                //CS_PRO_005-e
            end;
        }
    }
}
