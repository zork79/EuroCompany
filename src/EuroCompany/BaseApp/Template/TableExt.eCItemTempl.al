namespace EuroCompany.BaseApp.Template;
using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Inventory.ItemCatalog;
using EuroCompany.BaseApp.Setup;
using Microsoft.CRM.Team;
using Microsoft.Finance.Dimension;
using Microsoft.Inventory.Item;
using Microsoft.Manufacturing.Document;
using Microsoft.Projects.Project.Job;

tableextension 80112 "eCItem Templ." extends "Item Templ."
{
    fields
    {
        field(50050; "ecBarcode Template"; Code[20])
        {
            Caption = 'Barcode template';
            TableRelation = "ecItem Barcode Template".Code;
        }
        field(50155; "ecItem Type"; Enum "ecItem Type")
        {
            Caption = 'Item Type';
        }
        field(50352; ecBand; Code[20])
        {
            Caption = 'Band';
            TableRelation = ecBand.Code;
        }
        field(50180; "ecBy Product Item"; Boolean)
        {
            Caption = '"By Product" Item';
        }
        field(50190; "ecKit/Product Exhibitor"; Boolean)
        {
            Caption = 'Kit/Product Exhibitor Item';
        }
        field(50350; "ecPackaging Type"; Code[20])
        {
            Caption = 'Packaging Type';
            TableRelation = "ecPackaging Type".Code;
        }
        field(50315; "ecBrand Type"; Code[20])
        {
            Caption = 'Brand Type';
            TableRelation = "ecBrand Type".Code;
        }
        field(50320; ecBrand; Code[20])
        {
            Caption = 'Brand';
            TableRelation = ecBrand.Code;
        }
        field(50325; "ecCommercial Line"; Code[20])
        {
            Caption = 'Commercial Line';
            TableRelation = "ecCommercial Line".Code;
        }
        field(50345; "ecWeight in Grams"; Decimal)
        {
            Caption = 'Weight in grams';
            DecimalPlaces = 0 : 5;
        }
        field(50156; "ecMandatory Origin Lot No."; Boolean)
        {
            Caption = 'Mandatory Origin on Lot No. Info';
        }
        field(50158; "ecLot Prod. Info Inherited"; Boolean)
        {
            Caption = 'Lot Production Info Attributes Inherited';
        }
        field(50380; "ecItem Trk. Summary Mgt."; Boolean)
        {
            Caption = 'Item Tracking Summary Management';
        }
        field(50153; "ecPallet Type"; Code[20])
        {
            Caption = 'Pallet format';
            TableRelation = "AltAWPLogistic Unit Format".Code;
        }
        field(50170; "ecPick Mandatory Reserved Qty"; Boolean)
        {
            Caption = 'Picking Mandatory Reserved Quantity';
        }
        field(50340; ecBio; Boolean)
        {
            Caption = 'Bio';
        }
        field(50341; "ecProduct Line"; Code[20])
        {
            Caption = 'Product Line';
            TableRelation = "ecProduct Line";
        }
        field(50300; "ecSpecies Type"; Code[20])
        {
            Caption = 'Species Type';
            TableRelation = "ecSpecies Type";
        }
        field(50305; ecSpecies; Code[20])
        {
            Caption = 'Species';
            TableRelation = ecSpecies;
        }
        field(50330; ecVariety; Code[20])
        {
            Caption = 'Variety';
            TableRelation = ecVariety;
        }
        field(50335; ecGauge; Code[20])
        {
            Caption = 'Caliber';
            TableRelation = ecGauge;
        }
        field(50310; ecTreatment; Code[20])
        {
            Caption = 'Treatment';
            TableRelation = ecTreatment;
        }
        // field(50114; "eCInventory Value Zero"; Boolean)
        // {
        //     Caption = 'Inventory Value Zero';
        // }
    }
}