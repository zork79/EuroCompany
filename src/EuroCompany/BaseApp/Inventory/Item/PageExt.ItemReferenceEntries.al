namespace EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Inventory.Barcode;


using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Catalog;

pageextension 80046 "Item Reference Entries" extends "Item Reference Entries"
{
    actions
    {

        addlast(Processing)
        {
            group(ecCustomFeaturesActGrp)
            {
                Caption = 'Custom Features';

                action(ecGenerateBarcodeAct)
                {
                    ApplicationArea = All;
                    Caption = 'Generate barcode';
                    Description = 'CS_PRO_005';
                    Image = BarCode;

                    trigger OnAction()
                    var
                        lItem: Record Item;
                        lBarcodeFunctions: Codeunit "ecBarcode Functions";
                    begin
                        if lItem.Get(Rec.GetFilter("Item No.")) then begin
                            lBarcodeFunctions.GenerateBarcodeByItemTemplate(Rec.GetFilter("Item No."), true);
                            CurrPage.Update(false);
                        end;
                    end;
                }
                action(ecBarcodePreviewAct)
                {
                    ApplicationArea = All;
                    Caption = 'Barcode preview';
                    Description = 'CS_PRO_005';
                    Image = BarCode;

                    trigger OnAction()
                    var
                        lItemRefBarcodePreview: Page "ecItem Ref. Barcode Preview";
                        lATSBarcodeSymbology: Enum "AltATSBarcode Symbology";
                        lBarcodeRef: Text;

                        lError001: Label 'Barcode format %1 not supported!';
                    begin
                        //CS_PRO_005-s
                        if (Rec."Reference Type" = Rec."Reference Type"::"Bar Code") and (Rec."Reference No." <> '') then begin
                            case Rec."AltAWPBarcode Type" of
                                Rec."AltAWPBarcode Type"::"EAN-13":
                                    begin
                                        lATSBarcodeSymbology := lATSBarcodeSymbology::EAN;
                                        lBarcodeRef := Rec."Reference No.";
                                    end;
                                Rec."AltAWPBarcode Type"::"ITF-14":
                                    begin
                                        lATSBarcodeSymbology := lATSBarcodeSymbology::"ITF-14";
                                        lBarcodeRef := CopyStr(Rec."Reference No.", 1, 13);
                                    end;
                                else
                                    Error(lError001, Format(Rec."AltAWPBarcode Type"));
                            end;
                            Clear(lItemRefBarcodePreview);
                            lItemRefBarcodePreview.SetRecordBarcode(Rec);
                            lItemRefBarcodePreview.SetBarcodeParameters(lATSBarcodeSymbology, 0, 0, 0, lBarcodeRef, '', '', true);
                            lItemRefBarcodePreview.RunModal();
                        end;
                        //CS_PRO_005-e
                    end;
                }
            }
        }

        addlast(Category_Process)
        {
            group(ecCustomFeaturesActGrp_Promoted)
            {
                Caption = 'Custom Features';

                actionref(ecBarcodePreviewActPromoted; ecBarcodePreviewAct) { }
                actionref(ecGenerateBarcodeActPromoted; ecGenerateBarcodeAct) { }
            }
        }
    }
}
