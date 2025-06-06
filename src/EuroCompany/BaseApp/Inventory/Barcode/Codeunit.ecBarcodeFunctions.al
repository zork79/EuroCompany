namespace EuroCompany.BaseApp.Inventory.Barcode;
using EuroCompany.BaseApp.Inventory.Item;


using Microsoft.Foundation.NoSeries;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Catalog;

codeunit 50000 "ecBarcode Functions"
{
    #region CS_PRO_005 - Gestione automatica del calcolo EAN

    internal procedure GenerateBarcodeByItemTemplate(pItemNo: Code[20]; pWithConfirm: Boolean)
    var
        lItem: Record Item;
        lItemVariant: Record "Item Variant";
        lItemBarcodeTemplate: Record "ecItem Barcode Template";

        lGenerateTemplConf: Label 'Are you sure to generate barcode by template for Item No: %1?';
        lBarcodeIncompleteErr: Label 'The barcode template "%1" specified for Item: "%2 - %3" required the use of variants which are missing for this item!';
    begin
        //CS_PRO_005-s
        if pWithConfirm then begin
            if not Confirm(StrSubstNo(lGenerateTemplConf, pItemNo), false) then exit;
        end;

        lItem.Get(pItemNo);
        lItem.TestField("ecBarcode Template");
        lItemBarcodeTemplate.Get(lItem."ecBarcode Template");
        lItem.TestBarcodeTemplate(lItemBarcodeTemplate.Code);

        if lItemBarcodeTemplate."Generate Barcode per Variant" then begin
            Clear(lItemVariant);
            lItemVariant.SetRange("Item No.", lItem."No.");
            if lItemVariant.IsEmpty then Error(lBarcodeIncompleteErr, lItemBarcodeTemplate.Code, lItem."No.", lItem.Description);
            lItemVariant.FindSet();
            repeat
                GenerateBarcodeByItemTemplate(lItemVariant."Item No.", lItemVariant.Code);
            until (lItemVariant.Next() = 0);
        end else begin
            GenerateBarcodeByItemTemplate(lItem."No.", '');
        end;
        //CS_PRO_005-e
    end;

    local procedure GenerateBarcodeByItemTemplate(pItemNo: Code[20]; pVariantCode: Code[10])
    var
        lItem: Record Item;
        lItemReference: Record "Item Reference";
        lItemBarcodeTemplate: Record "ecItem Barcode Template";
        lBarcodeFunctions: Codeunit "AltAWPBarcode Functions";
        lNoSeriesManagement: Codeunit NoSeriesManagement;
        lUMConsumerBarcode: Code[50];
        lUMPackageBarcode: Code[50];
        lBarcodeUoMPackagePrefix: Code[20];
        lGenerateOnlyITF14Barcode: Boolean;

        lError002: Label 'The "%1" generation function returned an invalid code!';
        lError003: Label 'Barcode "%1" of type "%2" already exists for item "%3 - %4", check the template setup before proceeding!';
        lError004: Label 'To generate barcode of type "%1", the barcode type "%2" must be present in the item reference!';
    begin
        //CS_PRO_005-s
        lItem.Get(pItemNo);
        lItemBarcodeTemplate.Get(lItem."ecBarcode Template");
        lGenerateOnlyITF14Barcode := not lItemBarcodeTemplate."Barcode UoM Consumer" and lItemBarcodeTemplate."Barcode UoM Package";

        if not lGenerateOnlyITF14Barcode then begin
            Clear(lItemReference);
            lItemReference.SetRange("Item No.", pItemNo);
            lItemReference.SetRange("Variant Code", pVariantCode);
            lItemReference.SetRange("Unit of Measure", lItem."ecConsumer Unit of Measure");
            lItemReference.SetRange("Reference Type", lItemReference."Reference Type"::"Bar Code");
            lItemReference.SetRange("AltAWPBarcode Type", lItemBarcodeTemplate."Barcode UoM Consumer Type");
            if lItemReference.IsEmpty then begin
                lItemReference.Init();
                lItemReference.Validate("Item No.", pItemNo);
                lItemReference.Validate("Variant Code", pVariantCode);
                lItemReference.Validate("Unit of Measure", lItem."ecConsumer Unit of Measure");
                lItemReference.Validate("Reference Type", lItemReference."Reference Type"::"Bar Code");
                lItemReference.Validate("AltAWPBarcode Type", lItemBarcodeTemplate."Barcode UoM Consumer Type");
                lUMConsumerBarcode := lBarcodeFunctions.GenerateBarcodeByType(lItemBarcodeTemplate."Barcode UoM Consumer Type", lItemBarcodeTemplate."Barcode UoM Consumer Prefix",
                                                                              lNoSeriesManagement.GetNextNo(lItemBarcodeTemplate."UoM Consumer Barcode Nos.", Today, true));

                if (lUMConsumerBarcode <> '') then begin
                    if CheckBarcodeAlreadyExists(lUMConsumerBarcode) then begin
                        Clear(lItemReference);
                        lItemReference.SetRange("Reference No.", lUMConsumerBarcode);
                        lItemReference.FindLast();
                        lItem.Get(lItemReference."Item No.");
                        Error(lError003, lUMConsumerBarcode, Format(lItemBarcodeTemplate."Barcode UoM Consumer Type"), lItem."No.", lItem.Description);
                    end;
                    lItemReference.Validate("Reference No.", lUMConsumerBarcode);
                    lItemReference.Insert(true);
                    lItemBarcodeTemplate.Modify(true);
                end else begin
                    Error(lError002, lItemBarcodeTemplate.FieldCaption("Barcode UoM Consumer"));
                end;
            end;
        end;

        if lItemBarcodeTemplate."Barcode UoM Package" then begin
            Clear(lItemReference);
            lItemReference.SetRange("Item No.", pItemNo);
            lItemReference.SetRange("Variant Code", pVariantCode);
            lItemReference.SetRange("Unit of Measure", lItem."ecConsumer Unit of Measure");
            lItemReference.SetRange("Reference Type", lItemReference."Reference Type"::"Bar Code");
            if not lGenerateOnlyITF14Barcode then begin
                lItemReference.SetRange("AltAWPBarcode Type", lItemBarcodeTemplate."Barcode UoM Consumer Type");
            end else begin
                lItemReference.SetRange("AltAWPBarcode Type", lItemBarcodeTemplate."Barcode UoM Consumer Type"::"EAN-13");
            end;
            if lItemReference.IsEmpty and lGenerateOnlyITF14Barcode then begin
                Error(lError004, Format(lItemBarcodeTemplate."Barcode UoM Package Type"), Format(lItemBarcodeTemplate."Barcode UoM Consumer Type"::"EAN-13"));
            end;
            if lItemReference.IsEmpty then exit;
            lItemReference.FindFirst();
            lUMConsumerBarcode := CopyStr(lItemReference."Reference No.", 1, StrLen(lItemReference."Reference No.") - 1);

            Clear(lItemReference);
            lItemReference.SetRange("Item No.", pItemNo);
            lItemReference.SetRange("Variant Code", pVariantCode);
            lItemReference.SetRange("Unit of Measure", lItem."ecPackage Unit Of Measure");
            lItemReference.SetRange("Reference Type", lItemReference."Reference Type"::"Bar Code");
            lItemReference.SetRange("AltAWPBarcode Type", lItemBarcodeTemplate."Barcode UoM Package Type");
            if lItemReference.IsEmpty or (not lItemBarcodeTemplate."Barcode UoM Consumer" and lItemBarcodeTemplate."Barcode UoM Package") then begin
                lItemReference.Init();
                lItemReference.Validate("Item No.", pItemNo);
                lItemReference.Validate("Variant Code", pVariantCode);
                lItemReference.Validate("Unit of Measure", lItem."ecPackage Unit Of Measure");
                lItemReference.Validate("Reference Type", lItemReference."Reference Type"::"Bar Code");
                lItemReference.Validate("AltAWPBarcode Type", lItemBarcodeTemplate."Barcode UoM Package Type");
                lBarcodeUoMPackagePrefix := lItemBarcodeTemplate."Barcode UoM Package Prefix";
                if lGenerateOnlyITF14Barcode then begin
                    lBarcodeUoMPackagePrefix := GetNewBarcodePrefix(pItemNo, pVariantCode, lUMConsumerBarcode, lItemBarcodeTemplate."Barcode UoM Package Type");
                end;
                lUMPackageBarcode := lBarcodeFunctions.GenerateBarcodeByType(lItemBarcodeTemplate."Barcode UoM Package Type",
                                                                             lBarcodeUoMPackagePrefix + lUMConsumerBarcode, '');
                if (lUMPackageBarcode <> '') then begin
                    if CheckBarcodeAlreadyExists(lUMPackageBarcode) then begin
                        Clear(lItemReference);
                        lItemReference.SetRange("Reference No.", lUMPackageBarcode);
                        lItemReference.FindLast();
                        lItem.Get(lItemReference."Item No.");
                        Error(lError003, lUMPackageBarcode, Format(lItemBarcodeTemplate."Barcode UoM Package Type"), lItem."No.", lItem.Description);
                    end;
                    lItemReference.Validate("Reference No.", lUMPackageBarcode);
                    lItemReference.Insert(true);
                end else begin
                    Error(lError002, lItemBarcodeTemplate.FieldCaption("Barcode UoM Package"));
                end;
            end;
        end;
        //CS_PRO_005-e
    end;

    internal procedure CheckBarcodeAlreadyExists(pBarcode: Code[50]): Boolean
    var
        lItemReference: Record "Item Reference";
    begin
        //CS_PRO_005-s
        if (pBarcode = '') then exit;

        Clear(lItemReference);
        lItemReference.SetRange("Reference No.", pBarcode);
        if not lItemReference.IsEmpty then exit(true);

        exit(false);
        //CS_PRO_005-e
    end;

    local procedure GetNewBarcodePrefix(pItemNo: Code[20]; pVariantCode: Code[10]; pUMConsumerBarcode: Code[50]; pUoMPackageBarcodeType: Enum "AltAWPBarcode Symbology"): Code[20]
    var
        lItem: Record Item;
        lItemReference: Record "Item Reference";
        lBarcodePrefix: Integer;

        lError001: Label 'It is not possible to generate a new barcode of type "%1" because all prefixes have already been used!';
    begin
        //CS_PRO_005-s
        lBarcodePrefix := 0;
        lItem.Get(pItemNo);

        Clear(lItemReference);
        lItemReference.SetRange("Item No.", pItemNo);
        lItemReference.SetRange("Variant Code", pVariantCode);
        lItemReference.SetRange("Unit of Measure", lItem."ecPackage Unit Of Measure");
        lItemReference.SetRange("Reference Type", lItemReference."Reference Type"::"Bar Code");
        lItemReference.SetRange("AltAWPBarcode Type", pUoMPackageBarcodeType);
        if lItemReference.IsEmpty then begin
            exit(Format(1));
        end else begin
            repeat
                lBarcodePrefix += 1;
                lItemReference.SetFilter("Reference No.", '%1', Format(lBarcodePrefix) + pUMConsumerBarcode + '*');
            until (lBarcodePrefix = 8) or (lItemReference.IsEmpty);
            if lItemReference.IsEmpty and (lBarcodePrefix <= 8) then begin
                exit(Format(lBarcodePrefix));
            end else begin
                Error(lError001, Format(pUoMPackageBarcodeType));
            end;
        end;
        //CS_PRO_005-e
    end;

    internal procedure TestBarcodeNos(pBarcodePrefix: Code[20]; pBarcodeNos: Code[20]; pBarcodeSymbology: Enum "AltAWPBarcode Symbology")
    var
        lNoSeries: Record "No. Series";
        lNoSeriesManagement: Codeunit NoSeriesManagement;
        lNoSeriesTest: Code[20];
        lProductCodeTest: Integer;
        lBarcodePrefixLength: Integer;

        lError001: Label 'No. Series "%1" is not valid for barcode because it does not contain an integer value!';
        lError002: Label 'No. Series "%1" is not valid for the barcode because its length is not correct for this type of prefix';
    begin
        lNoSeries.Get(pBarcodeNos);
        lNoSeriesTest := lNoSeriesManagement.GetNextNo(pBarcodeNos, Today, false);
        if not Evaluate(lProductCodeTest, lNoSeriesTest) then Error(lError001, pBarcodeNos);
        case pBarcodeSymbology of
            pBarcodeSymbology::"EAN-13":
                begin
                    lBarcodePrefixLength := StrLen(pBarcodePrefix);
                    if (lBarcodePrefixLength = 9) and (StrLen(lNoSeriesTest) <> 3) then Error(lError002, pBarcodeNos);
                    if (lBarcodePrefixLength = 7) and (StrLen(lNoSeriesTest) <> 5) then Error(lError002, pBarcodeNos);
                end;
        end;
    end;

    procedure GetItemBarcodeByType(pItemNo: Code[20]; pVariantCode: Code[10]; pUnitOfMeasureCode: Code[10];
                                            pBarcodeType: Enum "AltAWPBarcode Symbology"): Code[50]
    var
        lItemReference: Record "Item Reference";
    begin
        lItemReference.Reset();
        lItemReference.SetRange("Item No.", pItemNo);
        lItemReference.SetRange("Variant Code", pVariantCode);
        lItemReference.SetRange("Unit of Measure", pUnitOfMeasureCode);
        lItemReference.SetRange("Reference Type", lItemReference."Reference Type"::"Bar Code");
        lItemReference.SetRange("AltAWPBarcode Type", pBarcodeType);
        if not lItemReference.IsEmpty then begin
            lItemReference.FindLast();
            exit(lItemReference."Reference No.");
        end;
    end;

    #endregion CS_PRO_005 - Gestione automatica del calcolo EAN
}
