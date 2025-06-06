namespace EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Inventory.ItemCatalog;
using EuroCompany.BaseApp.Sales;

using EuroCompany.BaseApp.Setup;
using Microsoft.CRM.Team;
using Microsoft.Finance.Dimension;
using Microsoft.Inventory.Item;
using Microsoft.Manufacturing.Document;
using Microsoft.Projects.Project.Job;

tableextension 80000 Item extends Item
{
    fields
    {
        modify("Production BOM No.")
        {
            trigger OnAfterValidate()
            begin
                //CS_PRO_009-s
                if ("Production BOM No." = '') then TestField("ecKit/Product Exhibitor", false);
                //CS_PRO_009-e
            end;
        }
        field(50000; "ecConsumer Unit of Measure"; Code[20])
        {
            Caption = 'Consumer Unit of Measure';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_005';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("No."));

            trigger OnValidate()
            begin
                //CS_PRO_005-s
                if (Rec."ecConsumer Unit of Measure" <> xRec."ecConsumer Unit of Measure") and
                   (Rec."ecConsumer Unit of Measure" <> '') and
                   (Rec."ecPackage Unit Of Measure" <> '')
                then begin
                    Rec."ecNo. Consumer Units per Pkg." := Round(CalcConsumerUnitsPerPackage(Rec), 1, '=');
                end;
                //CS_PRO_005-e
            end;
        }
        field(50010; "ecPackage Unit Of Measure"; Code[20])
        {
            Caption = 'Package Unit Of Measure';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_005';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("No."));

            trigger OnValidate()
            begin
                //CS_PRO_005-s
                if (Rec."ecPackage Unit Of Measure" <> xRec."ecPackage Unit Of Measure") and
                   (Rec."ecPackage Unit Of Measure" <> '') and
                   (Rec."ecConsumer Unit of Measure" <> '')
                then begin
                    Rec."ecNo. Consumer Units per Pkg." := Round(CalcConsumerUnitsPerPackage(Rec), 1, '=');
                end;
                //CS_PRO_005-e
            end;
        }
        field(50015; "ecNo. Consumer Units per Pkg."; Integer)
        {
            Caption = 'Nr. Consumer Units per Package';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_005';
            MinValue = 0;

            trigger OnValidate()
            begin
                //CS_PRO_005-s
                if (Rec."ecNo. Consumer Units per Pkg." <> 0) then begin
                    TestField("ecConsumer Unit of Measure");
                    TestField("ecPackage Unit Of Measure");
                end;

                if (Rec."ecNo. Consumer Units per Pkg." <> xRec."ecNo. Consumer Units per Pkg.") then begin
                    if (Rec."ecNo. Consumer Units per Pkg." <> 0) then begin
                        if (Rec."Base Unit of Measure" in [Rec."ecConsumer Unit of Measure", Rec."ecPackage Unit Of Measure"])
                        then begin
                            UpdateQtyPerUMByPackageAndConsumerUM(Rec);
                        end;
                    end;
                end;
                //CS_PRO_005-e
            end;
        }
        field(50020; "ecShort Description"; Text[30])
        {
            Caption = 'Short description';
            DataClassification = CustomerContent;
            Description = 'GAP_VEN_001';
        }
        field(50030; "ecCommercial Description"; Text[100])
        {
            Caption = 'Commercial description';
            DataClassification = CustomerContent;
            Description = 'GAP_VEN_001';
        }
        field(50050; "ecBarcode Template"; Code[20])
        {
            Caption = 'Barcode template';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_005';
            TableRelation = "ecItem Barcode Template".Code;

            trigger OnValidate()
            begin
                //CS_PRO_005-s
                if (Rec."ecBarcode Template" <> xRec."ecBarcode Template") and (Rec."ecBarcode Template" <> '') then begin
                    TestBarcodeTemplate(Rec."ecBarcode Template");
                end;
                //CS_PRO_005-e
            end;
        }
        field(50100; "ecSend-Ahead Quantity"; Decimal)
        {
            Caption = 'Send-Ahead quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'CS_PRO_044';
            MinValue = 0;
        }
        field(50110; "ecQty.Firm Planned Prod. Order"; Decimal)
        {
            CalcFormula = sum("Prod. Order Line"."Remaining Qty. (Base)" where(Status = const("Firm Planned"),
                                                                                "Item No." = field("No."),
                                                                                "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                "Location Code" = field("Location Filter"),
                                                                                "Variant Code" = field("Variant Filter"),
                                                                                "Due Date" = field("Date Filter"),
                                                                                "Unit of Measure Code" = field("Unit of Measure Filter")));
            Caption = 'Qty. on Prod. Order (Firm Planned)';
            DecimalPlaces = 0 : 5;
            Description = 'CS_PRO_018';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50150; "ecNo. Of Units per Layer"; Decimal)
        {
            Caption = 'No. of units per layer';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'GAP_PRO_001';
            MinValue = 0;

            trigger OnValidate()
            begin
                RecalcUnitsPerParcels();
            end;
        }
        field(50151; "ecNo. of Layers per Pallet"; Decimal)
        {
            Caption = 'No. of layers per pallet';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'GAP_PRO_001';
            MinValue = 0;

            trigger OnValidate()
            begin
                RecalcUnitsPerParcels();
            end;
        }
        field(50152; ecStackable; Boolean)
        {
            Caption = 'Stackable';
            DataClassification = CustomerContent;
            Description = 'GAP_PRO_001';
        }
        field(50153; "ecPallet Type"; Code[20])
        {
            Caption = 'Pallet format';
            DataClassification = CustomerContent;
            Description = 'GAP_PRO_001';
            TableRelation = "AltAWPLogistic Unit Format".Code where("Application Type" = filter("Box Only" | "Box and Pallet"));
        }
        field(50155; "ecItem Type"; Enum "ecItem Type")
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_043';
        }
        field(50156; "ecMandatory Origin Lot No."; Boolean)
        {
            Caption = 'Mandatory Origin on Lot No. Info';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_043';
        }
        field(50158; "ecLot Prod. Info Inherited"; Boolean)
        {
            Caption = 'Lot Production Info Attributes Inherited';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_043';
        }
        field(50165; "ecCalc. for Max Usable Date"; DateFormula)
        {
            Caption = 'Calculation for max usable date';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_008';

            trigger OnValidate()
            var
                lPositiveDateFormulaErr: Label 'The date formula value must be negative: %1';
            begin
                if (Format("ecCalc. for Max Usable Date") <> '') then begin
                    if (CalcDate("ecCalc. for Max Usable Date", Today) > Today) then begin
                        Error(lPositiveDateFormulaErr, "ecCalc. for Max Usable Date");
                    end;
                end;
            end;
        }
        field(50170; "ecPick Mandatory Reserved Qty"; Boolean)
        {
            Caption = 'Picking Mandatory Reserved Quantity';
            DataClassification = CustomerContent;
            Description = 'CS_LOG_001';
        }
        field(50180; "ecBy Product Item"; Boolean)
        {
            Caption = '"By Product" Item';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_041_BIS';

            trigger OnValidate()
            var
                lByProductItemRelation: Record "ecBy Product Item Relation";

                lConfirm001: Label 'There are relations linked to the Item No. = "%1", do you want to delete them?';
                lError001: Label 'Operation canceled';
            begin
                //CS_PRO_041_BIS-s
                if not Rec."ecBy Product Item" and lByProductItemRelation.ExistsRelationsForItem(Rec."No.") then begin
                    if not Confirm(lConfirm001, false) then Error(lError001);
                    lByProductItemRelation.DeleteRelationsForItem(Rec."No.");
                end;
                //CS_PRO_041_BIS-e
            end;
        }
        field(50185; "ecBy Product Relation Type"; Enum "ecBy Product Item Rel. Types")
        {
            Caption = '"By Product" Relation type';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_041_BIS';

            trigger OnValidate()
            var
                lByProductItemRelation: Record "ecBy Product Item Relation";
            begin
                //CS_PRO_041_BIS-s
                lByProductItemRelation.CheckByProductRelations(Rec."No.", Rec."ecBy Product Relation Type", true);
                //CS_PRO_041_BIS-e
            end;
        }
        field(50190; "ecKit/Product Exhibitor"; Boolean)
        {
            Caption = 'Kit/Product Exhibitor Item';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_009';

            trigger OnValidate()
            var
                lSalesFunctions: Codeunit "ecSales Functions";
            begin
                //CS_PRO_009-s
                lSalesFunctions.CheckKitExhibitorItem(Rec);
                //CS_PRO_009-e
            end;
        }
        field(50195; "ecNon-Invent. Linked Item No."; Code[20])
        {
            Caption = 'Non-Invent. Linked Item No.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_009';
            Editable = false;
        }
        field(50300; "ecSpecies Type"; Code[20])
        {
            Caption = 'Species Type';
            DataClassification = CustomerContent;
            Description = 'GAP_VEN_002';
            TableRelation = "ecSpecies Type";
        }
        field(50305; ecSpecies; Code[20])
        {
            Caption = 'Species';
            DataClassification = CustomerContent;
            Description = 'GAP_VEN_002';
            TableRelation = ecSpecies;
        }
        field(50310; ecTreatment; Code[20])
        {
            Caption = 'Treatment';
            DataClassification = CustomerContent;
            Description = 'GAP_VEN_002';
            TableRelation = ecTreatment;
        }
        field(50315; "ecBrand Type"; Code[20])
        {
            Caption = 'Brand Type';
            DataClassification = CustomerContent;
            Description = 'GAP_VEN_002';
            TableRelation = "ecBrand Type";
        }
        field(50320; ecBrand; Code[20])
        {
            Caption = 'Brand';
            DataClassification = CustomerContent;
            Description = 'GAP_VEN_002';
            TableRelation = ecBrand;
        }
        field(50325; "ecCommercial Line"; Code[20])
        {
            Caption = 'Commercial Line';
            DataClassification = CustomerContent;
            Description = 'GAP_VEN_002';
            TableRelation = "ecCommercial Line";
        }
        field(50330; ecVariety; Code[20])
        {
            Caption = 'Variety';
            DataClassification = CustomerContent;
            Description = 'GAP_VEN_002';
            TableRelation = ecVariety;
        }
        field(50335; ecGauge; Code[20])
        {
            Caption = 'Caliber';
            DataClassification = CustomerContent;
            Description = 'GAP_VEN_002';
            TableRelation = ecGauge;
        }
        field(50340; ecBio; Boolean)
        {
            Caption = 'Bio';
            DataClassification = CustomerContent;
            Description = 'GAP_VEN_002';

            trigger OnValidate()
            var
                lGeneralSetup: Record "ecGeneral Setup";
                lDefaultDimension: Record "Default Dimension";
            begin
                //GAP_VEN_002-s
                if (Rec.ecBio <> xRec.ecBio) then begin
                    lGeneralSetup.Get();
                    lGeneralSetup.TestField("Bio Dimension Code");
                    lGeneralSetup.CreateBIODimensionsValue();
                    if not lDefaultDimension.Get(Database::Item, Rec."No.", lGeneralSetup."Bio Dimension Code") then begin
                        lDefaultDimension.Init();
                        lDefaultDimension.Validate("Table ID", Database::Item);
                        lDefaultDimension.Validate("No.", Rec."No.");
                        lDefaultDimension.Validate("Dimension Code", lGeneralSetup."Bio Dimension Code");
                        lDefaultDimension.Validate("Value Posting", lDefaultDimension."Value Posting"::"Same Code");
                        lDefaultDimension.Insert(true);
                    end;
                    if (Rec.ecBio) then begin
                        lDefaultDimension.Validate("Dimension Value Code", Format(Enum::"ecBio Item Attribute"::BIO));
                    end else begin
                        lDefaultDimension.Validate("Dimension Value Code", Format(Enum::"ecBio Item Attribute"::NOBIO));
                    end;
                    lDefaultDimension.Modify(true);
                end;
                //GAP_VEN_002-e
            end;
        }
        field(50341; "ecProduct Line"; Code[20])
        {
            Caption = 'Product Line';
            DataClassification = CustomerContent;
            Description = 'GAP_VEN_002';
            TableRelation = "ecProduct Line";
        }
        field(50345; "ecWeight in Grams"; Decimal)
        {
            Caption = 'Weight in grams';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'GAP_VEN_002';
        }
        field(50350; "ecPackaging Type"; Code[20])
        {
            Caption = 'Packaging Type';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_018';
            TableRelation = "ecPackaging Type";
        }
        field(50352; ecBand; Code[20])
        {
            Caption = 'Band';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_018';
            TableRelation = ecBand;
        }
        field(50360; "ecPurchaser Code"; Code[20])
        {
            Caption = 'Purchaser Code';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_004';
            TableRelation = "Salesperson/Purchaser" where(Blocked = const(false));
        }
        field(50380; "ecItem Trk. Summary Mgt."; Boolean)
        {
            Caption = 'Item Tracking Summary Management';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_046';
        }
        //#376
        field(50385; "ecJob No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
            TableRelation = Job;

            trigger OnValidate()
            begin
                Rec.CalcFields("ecJob No. Description");
                Validate("ecJob Task No.", '');
            end;
        }
        field(50390; "ecJob No. Description"; Text[100])
        {
            CalcFormula = lookup(Job.Description where("No." = field("ecJob No.")));
            Caption = 'Job No. Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50395; "ecJob Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            DataClassification = CustomerContent;
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("ecJob No."), "Job Task No." = field("ecJob Task No."));

            trigger OnValidate()
            begin
                Rec.CalcFields("ecJob Task Description");
            end;
        }
        field(50397; "ecJob Task Description"; Text[100])
        {
            CalcFormula = lookup("Job Task".Description where("Job No." = field("ecJob No."), "Job Task No." = field("ecJob Task No.")));
            Caption = 'Job Task Description';
            Editable = false;
            FieldClass = FlowField;
        }
        //#376
    }

    keys
    {
        key(ecKey1; "ecItem Type") { }
    }

    trigger OnDelete()
    var
        lItemCustomerDetails: Record "ecItem Customer Details";
        lByProductItemRelation: Record "ecBy Product Item Relation";
    begin
        //GAP_PRO_001-s
        if ("No." <> '') then begin
            lItemCustomerDetails.Reset();
            lItemCustomerDetails.SetRange("Item No.", "No.");
            if not lItemCustomerDetails.IsEmpty then begin
                lItemCustomerDetails.DeleteAll(true);
            end;
        end;
        //GAP_PRO_001-e

        //CS_PRO_041_BIS-s
        lByProductItemRelation.DeleteRelationsForItem(Rec."No.");
        //CS_PRO_041_BIS-e        
    end;

    local procedure CalcConsumerUnitsPerPackage(var pItem: Record Item): Decimal
    var
        lItemUnitofMeasurePackage: Record "Item Unit of Measure";
        lItemUnitofMeasureConsumer: Record "Item Unit of Measure";
        lNrConsumerUnitsPerPackage: Decimal;
    begin
        //CS_PRO_005-s
        lNrConsumerUnitsPerPackage := 0;
        lItemUnitofMeasurePackage.Get(pItem."No.", pItem."ecPackage Unit Of Measure");
        lItemUnitofMeasureConsumer.Get(pItem."No.", pItem."ecConsumer Unit of Measure");
        lNrConsumerUnitsPerPackage := lItemUnitofMeasurePackage."Qty. per Unit of Measure" / lItemUnitofMeasureConsumer."Qty. per Unit of Measure";

        exit(lNrConsumerUnitsPerPackage);
        //CS_PRO_005-e
    end;

    local procedure UpdateQtyPerUMByPackageAndConsumerUM(var pItem: Record Item)
    var
        lItemUnitofMeasurePackage: Record "Item Unit of Measure";
        lItemUnitofMeasureConsumer: Record "Item Unit of Measure";
    begin
        //CS_PRO_005-s
        lItemUnitofMeasurePackage.Get(pItem."No.", pItem."ecPackage Unit Of Measure");
        lItemUnitofMeasureConsumer.Get(pItem."No.", pItem."ecConsumer Unit of Measure");

        case pItem."Base Unit of Measure" of
            pItem."ecConsumer Unit of Measure":
                begin
                    lItemUnitofMeasurePackage.Validate("Qty. per Unit of Measure", pItem."ecNo. Consumer Units per Pkg.");
                    lItemUnitofMeasurePackage.Modify(true);
                end;
            pItem."ecPackage Unit Of Measure":
                begin
                    lItemUnitofMeasureConsumer.Validate("Qty. per Unit of Measure", Round(1 / pItem."ecNo. Consumer Units per Pkg.", 0.00001));
                    lItemUnitofMeasureConsumer.Modify(true);
                end;
        end;
        //CS_PRO_005-e
    end;

    internal procedure TestBarcodeTemplate(pItemBarcodeTemplateCode: Code[20])
    var
        lItemBarcodeTemplate: Record "ecItem Barcode Template";
    begin
        //CS_PRO_005-s
        lItemBarcodeTemplate.Get(pItemBarcodeTemplateCode);

        if lItemBarcodeTemplate."Barcode UoM Consumer" then begin
            lItemBarcodeTemplate.TestField("UoM Consumer Barcode Nos.");
            lItemBarcodeTemplate.TestField("Barcode UoM Consumer Type");
            lItemBarcodeTemplate.TestField("Barcode UoM Consumer Prefix");
        end;

        if (lItemBarcodeTemplate."Barcode UoM Package") then begin
            lItemBarcodeTemplate.TestField("Barcode UoM Package Type");
            if lItemBarcodeTemplate."Barcode UoM Consumer" then lItemBarcodeTemplate.TestField("Barcode UoM Package Prefix");
        end;
        //CS_PRO_005-e
    end;

    local procedure RecalcUnitsPerParcels()
    begin
        if ("ecNo. of Layers per Pallet" <> 0) and ("ecNo. Of Units per Layer" <> 0) then begin
            Validate("Units per Parcel", "ecNo. of Layers per Pallet" * "ecNo. Of Units per Layer");
        end;
    end;
}
