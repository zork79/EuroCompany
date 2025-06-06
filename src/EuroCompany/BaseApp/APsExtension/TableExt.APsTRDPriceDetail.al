namespace EuroCompany.BaseApp.APsExtension;
using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Catalog;

tableextension 80059 "APsTRD Price Detail" extends "APsTRD Price Detail"
{
    fields
    {
        field(50000; "ecPackaging Type"; Code[20])
        {
            CalcFormula = lookup(Item."ecPackaging Type" where("No." = field("Product No.")));
            Caption = 'Packaging Type';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "ecPackaging Type";
        }
        field(50001; ecBio; Boolean)
        {
            CalcFormula = lookup(Item.ecBio where("No." = field("Product No.")));
            Caption = 'Bio';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "ecProduct Line"; Code[20])
        {
            CalcFormula = lookup(Item."ecProduct Line" where("No." = field("Product No.")));
            Caption = 'Product Line';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "ecProduct Line";
        }
        field(50003; "ecSpecies Type"; Code[20])
        {
            CalcFormula = lookup(Item."ecSpecies Type" where("No." = field("Product No.")));
            Caption = 'Species Type';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "ecSpecies Type";
        }
        field(50004; ecSpecies; Code[20])
        {
            CalcFormula = lookup(Item.ecSpecies where("No." = field("Product No.")));
            Caption = 'Species';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = ecSpecies;
        }
        field(50005; ecVariety; Code[20])
        {
            CalcFormula = lookup(Item.ecVariety where("No." = field("Product No.")));
            Caption = 'Variety';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = ecVariety;
        }
        field(50006; ecGauge; Code[20])
        {
            CalcFormula = lookup(Item.ecGauge where("No." = field("Product No.")));
            Caption = 'Caliber';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = ecGauge;
        }
        field(50007; ecTreatment; Code[20])
        {
            CalcFormula = lookup(Item.ecTreatment where("No." = field("Product No.")));
            Caption = 'Treatment';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = ecTreatment;
        }
        field(50008; "ecBrand Type"; Code[20])
        {
            CalcFormula = lookup(Item."ecBrand Type" where("No." = field("Product No.")));
            Caption = 'Brand Type';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "ecBrand Type";
        }
        field(50009; ecBrand; Code[20])
        {
            CalcFormula = lookup(Item.ecBrand where("No." = field("Product No.")));
            Caption = 'Brand';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = ecBrand;
        }
        field(50010; "ecCommercial Line"; Code[20])
        {
            CalcFormula = lookup(Item."ecCommercial Line" where("No." = field("Product No.")));
            Caption = 'Commercial Line';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "ecCommercial Line";
        }
        field(50011; "ecWeight in Grams"; Decimal)
        {
            CalcFormula = lookup(Item."ecWeight in Grams" where("No." = field("Product No.")));
            Caption = 'Weight in grams';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "ecNo. Of Units per Layer"; Decimal)
        {
            CalcFormula = lookup(Item."ecNo. Of Units per Layer" where("No." = field("Product No.")));
            Caption = 'No. of units per layer';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50013; "ecNo. Of Layers per Pallet"; Decimal)
        {
            CalcFormula = lookup(Item."ecNo. of Layers per Pallet" where("No." = field("Product No.")));
            Caption = 'No. of units per pallet';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50014; "ecReference No. EAN-13"; Code[50])
        {
            Caption = 'Reference No. EAN-13';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50015; "ecPallet Type"; Code[20])
        {
            CalcFormula = lookup(Item."ecPallet Type" where("No." = field("Product No.")));
            Caption = 'Pallet format';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50016; ecStackable; Boolean)
        {
            CalcFormula = lookup(Item.ecStackable where("No." = field("Product No.")));
            Caption = 'Stackable';
            Editable = false;
            FieldClass = FlowField;
        }
    }


}