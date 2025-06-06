namespace EuroCompany.BaseApp.Template;
using Microsoft.Inventory.Item;

pageextension 80217 "eCItem Templ. List" extends "Item Templ. List"
{
    layout
    {
        addafter(Code)
        {
            field("Indirect Cost %"; Rec."Indirect Cost %")
            {
                ApplicationArea = All;
            }
            field("ecMandatory Origin Lot No."; Rec."ecMandatory Origin Lot No.")
            {
                ApplicationArea = All;
            }
            field("Rounding Precision"; Rec."Rounding Precision")
            {
                ApplicationArea = All;
            }
            field("Expiration Calculation"; Rec."Expiration Calculation")
            {
                ApplicationArea = All;
            }
            field("Special Equipment Code"; Rec."Special Equipment Code")
            {
                ApplicationArea = All;
            }
            field("Over-Receipt Code"; Rec."Over-Receipt Code")
            {
                ApplicationArea = All;
            }
            field("ecBarcode Template"; Rec."ecBarcode Template")
            {
                ApplicationArea = All;
            }
            field("ecItem Type"; Rec."ecItem Type")
            {
                ApplicationArea = All;
            }
            field(ecBand; Rec.ecBand)
            {
                ApplicationArea = All;
            }
            field("ecBy Product Item"; Rec."ecBy Product Item")
            {
                ApplicationArea = All;
            }
            field("ecKit/Product Exhibitor"; Rec."ecKit/Product Exhibitor")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("ecPackaging Type"; Rec."ecPackaging Type")
            {
                ApplicationArea = All;
            }
            field("ecBrand Type"; Rec."ecBrand Type")
            {
                ApplicationArea = All;
            }
            field(ecBrand; Rec.ecBrand)
            {
                ApplicationArea = All;
            }
            field("ecCommercial Line"; Rec."ecCommercial Line")
            {
                ApplicationArea = All;
            }
            field("ecWeight in Grams"; Rec."ecWeight in Grams")
            {
                ApplicationArea = All;
            }
            field("ecLot Prod. Info Inherited"; Rec."ecLot Prod. Info Inherited")
            {
                ApplicationArea = All;
            }
            field("ecItem Trk. Summary Mgt."; Rec."ecItem Trk. Summary Mgt.")
            {
                ApplicationArea = All;
            }
            field(ecBio; Rec.ecBio)
            {
                ApplicationArea = All;
            }
            field("ecProduct Line"; Rec."ecProduct Line")
            {
                ApplicationArea = All;
            }
            field("ecSpecies Type"; Rec."ecSpecies Type")
            {
                ApplicationArea = All;
            }
            field(ecSpecies; Rec.ecSpecies)
            {
                ApplicationArea = All;
            }
            field(ecVariety; Rec.ecVariety)
            {
                ApplicationArea = All;
            }
            field(ecGauge; Rec.ecGauge)
            {
                ApplicationArea = All;
            }
            field(ecTreatment; Rec.ecTreatment)
            {
                ApplicationArea = All;
            }
            field("ecPallet Type"; Rec."ecPallet Type")
            {
                ApplicationArea = All;
            }
            field("ecPick Mandatory Reserved Qty"; Rec."ecPick Mandatory Reserved Qty")
            {
                ApplicationArea = All;
            }
            field("APsSCM Comm. Posting Group"; Rec."APsSCM Comm. Posting Group")
            {
                ApplicationArea = All;
            }
            // field("eCInventory Value Zero"; Rec."eCInventory Value Zero")
            // {
            //     ApplicationArea = All;
            // }
        }
    }
}