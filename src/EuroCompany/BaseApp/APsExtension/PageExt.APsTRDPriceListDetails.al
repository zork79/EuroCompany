namespace EuroCompany.BaseApp.APsExtension;
using EuroCompany.BaseApp.Inventory;
using EuroCompany.BaseApp.Inventory.Barcode;
using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Inventory.Item;

pageextension 80144 "APsTRD Price List Details" extends "APsTRD Price List Details"
{
    layout
    {
        addlast(Control1)
        {
            field("ecPackaging Type"; Rec."ecPackaging Type")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(ecBio; Rec.ecBio)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("ecProduct Line"; Rec."ecProduct Line")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("ecSpecies Type"; Rec."ecSpecies Type")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(ecSpecies; Rec.ecSpecies)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(ecVariety; Rec.ecVariety)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(ecGauge; Rec.ecGauge)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(ecTreatment; Rec.ecTreatment)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("ecBrand Type"; Rec."ecBrand Type")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(ecBrand; Rec.ecBrand)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("ecCommercial Line"; Rec."ecCommercial Line")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("ecWeight in Grams"; Rec."ecWeight in Grams")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(ecStackable; Rec.ecStackable)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("ecNo. Of Units per Layer"; Rec."ecNo. Of Units per Layer")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("ecNo. Of Layers per Pallet"; Rec."ecNo. Of Layers per Pallet")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("ecNumber Of Units Per Pallet"; NumberOfUnitsPerPallet)
            {
                ApplicationArea = All;
                Caption = 'Number of units per pallet';
                DecimalPlaces = 0 : 5;
                Editable = false;
            }
            field("ecPallet Type"; Rec."ecPallet Type")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("ecReference No. EAN-13"; Rec."ecReference No. EAN-13")
            {
                ApplicationArea = All;
                Editable = false;

                trigger OnDrillDown()
                var
                    ApsGenericFunctions: Codeunit "ecApsGeneric Functions";
                begin
                    ApsGenericFunctions.DrillDownItemReference(Rec);
                end;
            }
            field("ecITF-14 Barcode"; ITF14Barcode)
            {
                ApplicationArea = All;
                Caption = 'Reference No. ITF-14';
                Editable = false;
            }
        }
    }

    var
        ITF14Barcode: Code[50];
        NumberOfUnitsPerPallet: Decimal;

    trigger OnAfterGetRecord()
    var
        lItem: Record Item;
        lBarcodeFunctions: Codeunit "ecBarcode Functions";
        ApsGenericFunctions: Codeunit "ecApsGeneric Functions";
    begin
        ApsGenericFunctions.GetReferenceNoEAN13(Rec);

        Rec.CalcFields("ecNo. Of Layers per Pallet", "ecNo. Of Units per Layer");
        NumberOfUnitsPerPallet := Rec."ecNo. Of Units per Layer" * Rec."ecNo. Of Layers per Pallet";

        ITF14Barcode := '';
        if (Rec."Product Type" = Rec."Product Type"::Item) and lItem.Get(Rec."Product No.") then begin
            ITF14Barcode := lBarcodeFunctions.GetItemBarcodeByType(Rec."Product No.", '', lItem."ecPackage Unit Of Measure",
                                                                   Enum::"AltAWPBarcode Symbology"::"ITF-14");
        end;
    end;
}