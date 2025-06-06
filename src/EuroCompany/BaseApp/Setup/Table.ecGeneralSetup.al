namespace EuroCompany.BaseApp.Setup;

using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Warehouse.Pallets;
using EuroCompany.BaseApp.Manufacturing.Document;
using Microsoft.Finance.Dimension;
using Microsoft.Foundation.NoSeries;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Inventory.Journal;
using Microsoft.Foundation.UOM;

table 50000 "ecGeneral Setup"
{
    Caption = 'Custom features setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(100; "Enable Shipping Group/Costs"; Boolean)
        {
            Caption = 'Enable shipping group/costs';
            Description = 'EC365';
        }
        field(150; "Cons. Correction Reason Code"; Code[10])
        {
            Caption = 'Cons. Correction Reason Code';
            Description = 'CS_PRO_050';
            TableRelation = "Reason Code".Code;
        }
        field(500; "Min. Time Tolerance %"; Decimal)
        {
            Caption = 'Min. time tolerance %';
            DecimalPlaces = 0 : 5;
            Description = 'CS_PRO_039';
        }
        field(505; "Min. Time Control Type"; Enum "ecProd. Ord. Line Control Type")
        {
            Caption = 'Min. time control type';
            Description = 'CS_PRO_039';
        }
        field(510; "Check Setup Time"; Boolean)
        {
            Caption = 'Check Setup Time';
            Description = 'CS_PRO_039';
        }
        field(520; "Min. Consumption Tolerance %"; Decimal)
        {
            Caption = 'Min. consumption tolerance %';
            DecimalPlaces = 0 : 5;
            Description = 'CS_PRO_039';
        }
        field(525; "Min. Consumption Control Type"; Enum "ecProd. Ord. Line Control Type")
        {
            Caption = 'Min. consumption control type';
            Description = 'CS_PRO_039';
        }
        field(540; "Pick On Reserved Bin"; Option)
        {
            Caption = 'Pick on reserved bin';
            Description = 'CS_PRO_018';
            OptionCaption = 'Manual,,,,,Automatic on activation';
            OptionMembers = Manual,,,,,"Automatic on activation";
        }
        field(600; "Bio Dimension Code"; Code[20])
        {
            Caption = 'Bio dimension code';
            Description = 'GAP_VEN_002';
            TableRelation = Dimension.Code;

            trigger OnValidate()
            begin
                CreateBIODimensionsValue();
            end;
        }
        field(605; "Use Custom Calc. Due Date"; Boolean)
        {
            Caption = 'Use Custom Cal. Due Date';
        }
        field(610; "Use Document Date As Default"; Boolean)
        {
            Caption = 'Use Document Date As Default';
        }
        // field(615; "Vat Registration No."; Text[20])
        // {
        //     Caption = 'Vat Registration No.';
        // }
        field(615; "Business Segment Selex"; Code[20])
        {
            Caption = 'Business Segment Selex';
            TableRelation = "APsTRD Business Segment";
        }
        field(620; "Internal Code"; Code[10])
        {
            Caption = 'Internal Code';
        }
        field(625; "Enable Item Tracing Intrastat"; Boolean)
        {
            Caption = 'Enable Item Tracking Intrastat';
        }
        field(630; "Show Only Run Intrastat Page"; Boolean)
        {
            Caption = 'Show Only Intrastat Page';
        }
        field(635; "Product Segment Selex"; Code[20])
        {
            Caption = 'Product Segment Selex';
            TableRelation = "APsTRD Product Segment";
        }
        field(640; "UoM To Convert"; Code[10])
        {
            Caption = 'UoM To Convert';
            TableRelation = "Unit of Measure".Code;
        }
        field(645; "Allowed UoM KG"; Code[10])
        {
            Caption = 'Allowed UoM KG';
            TableRelation = "Unit of Measure".Code;
        }
        field(650; "Allowed UoM LT"; Code[10])
        {
            Caption = 'Allowed UoM LT';
            TableRelation = "Unit of Measure".Code;
        }
        field(655; "Allowed UoM CONF"; Code[10])
        {
            Caption = 'Item Reference UoM CONF';
            TableRelation = "Unit of Measure".Code;
        }
        //Removed
        // field(660; "No. Series Cust. Declaration"; Code[20])
        // {
        //     Caption = 'No. series customer declaration';
        //     DataClassification = CustomerContent;
        //     TableRelation = "No. Series";
        // }
        // field(665; "Enable Customs Declarations"; Boolean)
        // {
        //     Caption = 'Enable customs declarations';
        //     DataClassification = CustomerContent;
        // }
        field(670; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Item Journal Template".Name where(Type = const(Item));
        }
        field(675; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(680; "CPR Counterparty Code"; Text[100])
        {
            Caption = 'CPR Counterparty Code';
        }
        field(685; "CPR Download CSV Path"; Text[2048])
        {
            Caption = 'CPR Download CSV Path';
        }
        field(690; "CPR Pallets Identif. Code"; Code[20])
        {
            Caption = 'CPR Pallets Identif. Code';
            TableRelation = "ecPallet Grouping Code";
        }
        #region 306
        field(700; "ecPrice Diff. Tolerance %"; Decimal)
        {
            Caption = 'Price Difference Tolerance %';
            MinValue = 0;
        }
        #endregion 306
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    internal procedure CreateBIODimensionsValue()
    var
        lDimensionValue: Record "Dimension Value";
        lBioItemAttribute: Enum "ecBio Item Attribute";
    begin
        //GAP_VEN_002-s
        if (Rec."Bio Dimension Code" <> '') then begin
            Clear(lDimensionValue);
            lDimensionValue.SetRange("Dimension Code", Rec."Bio Dimension Code");
            lDimensionValue.SetRange(Code, Format(lBioItemAttribute::BIO));
            if lDimensionValue.IsEmpty then begin
                lDimensionValue.Init();
                lDimensionValue.Validate("Dimension Code", Rec."Bio Dimension Code");
                lDimensionValue.Validate(Code, Format(lBioItemAttribute::BIO));
                lDimensionValue.Validate(Name, Format(lBioItemAttribute::BIO));
                lDimensionValue.Insert(true);
            end;
            lDimensionValue.SetRange(Code, Format(lBioItemAttribute::NOBIO));
            if lDimensionValue.IsEmpty then begin
                lDimensionValue.Init();
                lDimensionValue.Validate("Dimension Code", Rec."Bio Dimension Code");
                lDimensionValue.Validate(Code, Format(lBioItemAttribute::NOBIO));
                lDimensionValue.Validate(Name, Format(lBioItemAttribute::NOBIO));
                lDimensionValue.Insert(true);
            end;
        end;
        //GAP_VEN_002-e
    end;
}
