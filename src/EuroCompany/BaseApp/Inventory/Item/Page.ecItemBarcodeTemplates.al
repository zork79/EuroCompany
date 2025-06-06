namespace EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Inventory.Item;

page 50001 "ecItem Barcode Templates"
{
    ApplicationArea = All;
    Caption = 'Item Barcode Templates';
    DelayedInsert = true;
    Description = 'CS_PRO_005';
    PageType = List;
    SourceTable = "ecItem Barcode Template";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Barcode UoM Consumer"; Rec."Barcode UoM Consumer")
                {
                    trigger OnValidate()
                    begin
                        BarcodeConsumerEditable := Rec."Barcode UoM Consumer";
                    end;
                }
                field("Barcode UoM Consumer Type"; Rec."Barcode UoM Consumer Type")
                {
                    Editable = BarcodeConsumerEditable;
                }
                field("Barcode UoM Consumer Prefix"; Rec."Barcode UoM Consumer Prefix")
                {
                    Editable = BarcodeConsumerEditable;
                }
                field("UoM Consumer Barcode Nos."; Rec."UoM Consumer Barcode Nos.")
                {
                    Editable = BarcodeConsumerEditable;
                }
                field("Barcode UoM Package"; Rec."Barcode UoM Package")
                {
                    trigger OnValidate()
                    begin
                        BarcodePackageEditable := Rec."Barcode UoM Package";
                    end;
                }
                field("Barcode UoM Package Type"; Rec."Barcode UoM Package Type")
                {
                    Editable = BarcodePackageEditable;
                }
                field("Barcode UoM Package Prefix"; Rec."Barcode UoM Package Prefix")
                {
                    Editable = BarcodePackageEditable and BarcodeConsumerEditable;
                }
                field("Generate Barcode per Variant"; Rec."Generate Barcode per Variant")
                {
                    Editable = BarcodeConsumerEditable;
                }
            }
        }
    }

    var
        BarcodeConsumerEditable: Boolean;
        BarcodePackageEditable: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        BarcodeConsumerEditable := Rec."Barcode UoM Consumer";
        BarcodePackageEditable := Rec."Barcode UoM Package";
    end;
}
