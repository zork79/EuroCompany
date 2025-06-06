namespace EuroCompany.BaseApp.Inventory.Item;

using Microsoft.Foundation.Company;
using Microsoft.Inventory.Item.Catalog;
using System.Text;

page 50003 "ecItem Ref. Barcode Preview"
{
    ApplicationArea = All;
    Caption = 'Barcode Preview';
    DeleteAllowed = false;
    Description = 'CS_PRO_005';
    Editable = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Item Reference";
    SourceTableTemporary = true;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Barcode informations';

                field("AltAWPBarcode Type"; Rec."AltAWPBarcode Type")
                {
                }
                field("Reference No."; Rec."Reference No.")
                {
                }
            }

            group(gPreview)
            {
                ShowCaption = false;

                field(gBarcode; Temp_CompanyInfo.Picture)
                {
                    Editable = false;
                    ShowCaption = false;
                }
            }
        }
    }

    var
        Temp_CompanyInfo: Record "Company Information" temporary;
        BarcodeSymbology: Enum "AltATSBarcode Symbology";

        BarcodeHeight: Integer;
        Rotation: Integer;
        BarcodeScale: Decimal;
        ValueAsText: Text;
        ForegroundColor: Text;
        BackgroundColor: Text;
        ShowText: Boolean;

    trigger OnOpenPage()
    begin
        if (ValueAsText = '') then CurrPage.Close();

        MakeBarcode();
    end;

    local procedure MakeBarcode()
    var
        latsBarcodeManagement: Codeunit "AltATSBarcode Generator";
        lBase64Convert: Codeunit "Base64 Convert";
        lOutStream: OutStream;
        lBarcodeB64: Text;
    begin
        if (ValueAsText <> '') and (BarcodeSymbology.AsInteger() <> 0) then begin
            latsBarcodeManagement.SetBarcodeSymbology(BarcodeSymbology);
            latsBarcodeManagement.SetDimension(BarcodeScale, BarcodeHeight);
            latsBarcodeManagement.SetShowText(ShowText);
            latsBarcodeManagement.SetBarcodeRotation(Rotation);
            latsBarcodeManagement.SetForegroundHexCol(ForegroundColor);
            latsBarcodeManagement.SetBackgroundHexCol(BackgroundColor);

            lBarcodeB64 := latsBarcodeManagement.MakeBarcode(ValueAsText);

            // Su HTML canvas Controllo Canvas disabilitato (Funzioni presente solo a scopo di esempio)        
            //DrawCanvasElement(lBarcodeB64);

            // Su Blob
            Clear(Temp_CompanyInfo);
            Temp_CompanyInfo.Picture.CreateOutStream(lOutStream);
            lBase64Convert.FromBase64(lBarcodeB64, lOutStream);

            CurrPage.Update();
        end;
    end;

    internal procedure SetBarcodeParameters(pBarcodeSymbology: Enum "AltATSBarcode Symbology"; pBarcodeHeight: Integer; pRotation: Integer; pBarcodeScale: Decimal;
                                            pValueAsText: Text; pForegroundColor: Text; pBackgroundColor: Text; pShowText: Boolean)
    begin
        BarcodeSymbology := pBarcodeSymbology;
        BarcodeHeight := pBarcodeHeight;
        Rotation := pRotation;
        BarcodeScale := pBarcodeScale;
        ValueAsText := pValueAsText;
        ForegroundColor := pForegroundColor;
        BackgroundColor := pBackgroundColor;
        ShowText := pShowText;
    end;

    internal procedure SetRecordBarcode(var pItemReference: Record "Item Reference")
    begin
        Rec := pItemReference;
        Rec.Insert(false);
    end;
}
