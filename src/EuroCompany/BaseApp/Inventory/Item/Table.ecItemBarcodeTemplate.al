namespace EuroCompany.BaseApp.Inventory.Item;


using EuroCompany.BaseApp.Inventory.Barcode;
using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Foundation.NoSeries;

table 50001 "ecItem Barcode Template"
{
    Caption = 'Item Barcode Template';
    DataClassification = CustomerContent;
    Description = 'CS_PRO_005';
    DrillDownPageId = "ecItem Barcode Templates";
    LookupPageId = "ecItem Barcode Templates";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(50; "Barcode UoM Consumer"; Boolean)
        {
            Caption = 'Barcode UoM Consumer';

            trigger OnValidate()
            begin
                if not Rec."Barcode UoM Consumer" then begin
                    Rec."UoM Consumer Barcode Nos." := '';
                    Rec."Barcode UoM Consumer Type" := Rec."Barcode UoM Consumer Type"::" ";
                    Rec."Barcode UoM Consumer Prefix" := '';

                    Rec."Barcode UoM Package" := false;
                    Rec."Barcode UoM Package Type" := Rec."Barcode UoM Package Type"::" ";
                    Rec."Barcode UoM Package Prefix" := '';
                end;
            end;
        }
        field(60; "Barcode UoM Consumer Type"; Enum "AltAWPBarcode Symbology")
        {
            Caption = 'Barcode UoM Consumer Type';

            trigger OnValidate()
            begin
                if (Rec."Barcode UoM Consumer Type" <> xRec."Barcode UoM Consumer Type") then begin
                    Rec."UoM Consumer Barcode Nos." := '';
                    "Barcode UoM Consumer Prefix" := '';
                end;

                if (Rec."Barcode UoM Consumer Type" <> Rec."Barcode UoM Consumer Type"::" ") then begin
                    TestField("Barcode UoM Consumer", true);
                    Rec.TestField("Barcode UoM Consumer Type", Rec."Barcode UoM Consumer Type"::"EAN-13");
                end;
            end;
        }
        field(65; "Barcode UoM Consumer Prefix"; Code[20])
        {
            Caption = 'Barcode UoM Consumer Prefix';

            trigger OnValidate()
            var
                lBarcodeFunctions: Codeunit "ecBarcode Functions";
                lBarcodePrefixLength: Integer;

                lError001: Label 'The field "%1" has incorrect length for barcode type "%2"!';
                lError002: Label 'Barcode type not managed!';
            begin
                TestField("Barcode UoM Consumer", true);
                case Rec."Barcode UoM Consumer Type" of
                    Rec."Barcode UoM Consumer Type"::"EAN-13":
                        begin
                            lBarcodePrefixLength := StrLen(Rec."Barcode UoM Consumer Prefix");
                            if (lBarcodePrefixLength <> 7) and (lBarcodePrefixLength <> 9) then begin
                                Error(lError001, Rec.FieldCaption(Rec."Barcode UoM Consumer Prefix"), Format(Rec."Barcode UoM Consumer Type"));
                            end;
                        end;
                    else begin
                        Error(lError002);
                    end;
                end;

                if (Rec."Barcode UoM Consumer Prefix" <> xRec."Barcode UoM Consumer Prefix") and (Rec."Barcode UoM Consumer Prefix" <> '') and
                   (Rec."UoM Consumer Barcode Nos." <> '')
                then begin
                    lBarcodeFunctions.TestBarcodeNos("Barcode UoM Consumer Prefix", "UoM Consumer Barcode Nos.", "Barcode UoM Consumer Type");
                end;
            end;
        }
        field(66; "UoM Consumer Barcode Nos."; Code[20])
        {
            Caption = 'UoM Consumer Barcode Nos.';
            TableRelation = "No. Series".Code;

            trigger OnValidate()
            var
                lBarcodeFunctions: Codeunit "ecBarcode Functions";
            begin
                if (Rec."UoM Consumer Barcode Nos." <> xRec."UoM Consumer Barcode Nos.") and (Rec."UoM Consumer Barcode Nos." <> '') then begin
                    TestField("Barcode UoM Consumer Type");
                    TestField("Barcode UoM Consumer Prefix");

                    lBarcodeFunctions.TestBarcodeNos("Barcode UoM Consumer Prefix", "UoM Consumer Barcode Nos.", "Barcode UoM Consumer Type");
                end;
            end;
        }
        field(100; "Barcode UoM Package"; Boolean)
        {
            Caption = 'Barcode UoM Package';

            trigger OnValidate()
            begin
                if not Rec."Barcode UoM Package" then begin
                    Rec."Barcode UoM Package Type" := Rec."Barcode UoM Package Type"::" ";
                    Rec."Barcode UoM Package Prefix" := '';
                end;
            end;
        }
        field(101; "Barcode UoM Package Type"; Enum "AltAWPBarcode Symbology")
        {
            Caption = 'Barcode UoM Package Type';

            trigger OnValidate()
            begin
                if (Rec."Barcode UoM Package Type" <> xRec."Barcode UoM Package Type") then begin
                    "Barcode UoM Package Prefix" := '';
                end;

                if (Rec."Barcode UoM Package Type" <> Rec."Barcode UoM Package Type"::" ") then begin
                    Rec.TestField("Barcode UoM Package", true);
                    Rec.TestField("Barcode UoM Package Type", Rec."Barcode UoM Package Type"::"ITF-14");
                end;
            end;
        }
        field(102; "Barcode UoM Package Prefix"; Code[20])
        {
            Caption = 'Barcode UoM Package Prefix';

            trigger OnValidate()
            var
                lBarcodePrefixLength: Integer;

                lError001: Label 'The field "%1" has incorrect length for barcode type "%2"!';
                lError002: Label 'Barcode type not managed!';
            begin
                Rec.TestField("Barcode UoM Package", true);
                case Rec."Barcode UoM Package Type" of
                    Rec."Barcode UoM Package Type"::"ITF-14":
                        begin
                            lBarcodePrefixLength := StrLen(Rec."Barcode UoM Package Prefix");
                            if (lBarcodePrefixLength <> 1) then begin
                                Error(lError001, Rec.FieldCaption(Rec."Barcode UoM Package Prefix"), Format(Rec."Barcode UoM Package Type"));
                            end;
                        end;
                    else begin
                        Error(lError002);
                    end;
                end;
            end;
        }
        field(150; "Generate Barcode per Variant"; Boolean)
        {
            Caption = 'Generate barcode per variant';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        CheckRecord();
    end;

    trigger OnModify()
    begin
        CheckRecord();
    end;

    internal procedure CheckRecord()
    var
        lItemBarcodeTemplate: Record "ecItem Barcode Template";

        lError001: Label 'For the prefix "%1" is already defined "%2" = "%3"!';
        lError002: Label 'For the "%1" = "%2" is already defined for prefix = "%3"!';
    begin
        if not "Barcode UoM Package" then begin
            TestField("Barcode UoM Consumer");
        end;
        if "Barcode UoM Consumer" then begin
            TestField("Barcode UoM Consumer Type");
            TestField("Barcode UoM Consumer Prefix");
            TestField("UoM Consumer Barcode Nos.");
        end;
        if "Barcode UoM Package" then begin
            TestField("Barcode UoM Package Type");
            if "Barcode UoM Consumer" then TestField("Barcode UoM Package Prefix");
        end;
        if ((Rec."Barcode UoM Consumer Prefix" <> xRec."Barcode UoM Consumer Prefix") and (Rec."Barcode UoM Consumer Prefix" <> '')) or
           ((Rec."UoM Consumer Barcode Nos." <> xRec."UoM Consumer Barcode Nos.") and (Rec."UoM Consumer Barcode Nos." <> ''))
         then begin
            Clear(lItemBarcodeTemplate);
            lItemBarcodeTemplate.SetFilter(Code, '<>%1', Rec.Code);
            lItemBarcodeTemplate.SetRange("Barcode UoM Consumer Type", Rec."Barcode UoM Consumer Type");
            lItemBarcodeTemplate.SetRange("Barcode UoM Consumer Prefix", Rec."Barcode UoM Consumer Prefix");
            lItemBarcodeTemplate.SetFilter("UoM Consumer Barcode Nos.", '<>%1', Rec."UoM Consumer Barcode Nos.");
            if not lItemBarcodeTemplate.IsEmpty then begin
                lItemBarcodeTemplate.FindFirst();
                Error(lError001, Rec."Barcode UoM Consumer Prefix", Rec.FieldCaption("UoM Consumer Barcode Nos."), lItemBarcodeTemplate."UoM Consumer Barcode Nos.");
            end;
            lItemBarcodeTemplate.SetFilter("Barcode UoM Consumer Prefix", '<>%1', Rec."Barcode UoM Consumer Prefix");
            lItemBarcodeTemplate.SetRange("UoM Consumer Barcode Nos.", Rec."UoM Consumer Barcode Nos.");
            if not lItemBarcodeTemplate.IsEmpty then begin
                lItemBarcodeTemplate.FindFirst();
                Error(lError002, Rec.FieldCaption("UoM Consumer Barcode Nos."), Rec."UoM Consumer Barcode Nos.", lItemBarcodeTemplate."Barcode UoM Consumer Prefix");
            end;
        end;
    end;
}
