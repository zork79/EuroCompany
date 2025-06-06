namespace EuroCompany.BaseApp.Restrictions.Rules;

using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Foundation.Address;
using Microsoft.Inventory.Item.Catalog;
using Microsoft.Purchases.Vendor;

table 50028 "ecRestriction Rule Line"
{
    Caption = 'Restriction Rule Line';
    DataClassification = CustomerContent;
    Description = 'CS_PRO_011';

    fields
    {
        field(1; "Rule Code"; Code[50])
        {
            Caption = 'Rule Code';
            TableRelation = "ecRestriction Rule Header".Code;
        }
        field(2; "Line Type"; Enum "ecRestriction Rule Line Type")
        {
            Caption = 'Line Type';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Attribute Type"; Enum "ecRestr. Rule Attribute Type")
        {
            Caption = 'Attribute Type';

            trigger OnValidate()
            begin
                if ("Attribute Type" = "Attribute Type"::"Crop Period") then begin
                    Validate("Condition Type", "Condition Type"::"Date Formula");
                end else begin
                    Validate("Condition Type", "Condition Type"::Value);
                end;
            end;
        }
        field(11; "Condition Type"; Enum "ecRestr. Rule Condition Type")
        {
            Caption = 'Condition Type';

            trigger OnValidate()
            begin
                Validate("Condition Value", '');
            end;
        }
        field(12; "Condition Value"; Text[250])
        {
            Caption = 'Condition Value';

            trigger OnValidate()
            begin
                ValidateConditionValue();
            end;

            trigger OnLookup()
            begin
                LookupConditionValue();
            end;
        }
        field(13; "Open Bracket"; Boolean)
        {
            Caption = '(', Locked = true;
        }
        field(14; "Close Bracket"; Boolean)
        {
            Caption = ')', Locked = true;
        }
        field(15; "Logical Join"; Option)
        {
            Caption = 'AND / OR', Locked = true;
            OptionMembers = " ",AND,OR;
        }
        field(30; "DateFormula Value"; DateFormula)
        {
            Caption = 'DateFormula Value';
        }
        field(100; "Rule Metalanguage"; Text[250])
        {
            Caption = 'Metalanguage';
            Editable = false;
        }
        field(101; "Rule Metalanguage Level"; Integer)
        {
            Caption = 'Level';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Rule Code", "Line Type", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        TestRecord();
    end;

    trigger OnModify()
    begin
        TestRecord();
    end;

    trigger OnRename()
    begin
        TestRecord();
    end;


    local procedure TestRecord()
    var
    begin
        TestField("Rule Code");

        if ("Line Type" = "Line Type"::Condition) then begin
            TestField("Attribute Type");
        end;
    end;

    local procedure ValidateConditionValue()
    var
        lVendor: Record Vendor;
        lCountryRegion: Record "Country/Region";
        lManufacturer: Record Manufacturer;
        lecGauge: Record ecGauge;
        lecVariety: Record ecVariety;

        lDateFormulaNotValidErr: Label 'Invalid date formula value: %1';
        lDateFormulaMandatoryErr: Label '%1 must be %2 when %3 is %4';
        lDateFormulaNotAllowedErr: Label '%1 cannot be %2 when %3 is %4';
        lNegativeDateFormulaErr: Label 'The date formula value must be negative: %1';
        lEmptyTableErr: Label 'The applied filter does not produce any results in the table "%1"';
    begin
        if ("Condition Value" <> '') then begin
            TestField("Attribute Type");

            case "Attribute Type" of
                "Attribute Type"::Vendor:
                    begin
                        if ("Condition Type" = "Condition Type"::Value) then begin
                            lVendor.Get("Condition Value");
                        end;

                        if ("Condition Type" = "Condition Type"::Filter) then begin
                            lVendor.SetFilter("No.", "Condition Value");
                            if lVendor.IsEmpty then begin
                                Error(lEmptyTableErr, lVendor.TableCaption);
                            end;
                        end;
                    end;

                "Attribute Type"::"Origin Country":
                    begin
                        if ("Condition Type" = "Condition Type"::Value) then begin
                            lCountryRegion.Get("Condition Value");
                        end;

                        if ("Condition Type" = "Condition Type"::Filter) then begin
                            lCountryRegion.SetFilter(Code, "Condition Value");
                            if lCountryRegion.IsEmpty then begin
                                Error(lEmptyTableErr, lCountryRegion.TableCaption);
                            end;
                        end;
                    end;

                "Attribute Type"::Manufacturer:
                    begin
                        if ("Condition Type" = "Condition Type"::Value) then begin
                            lManufacturer.Get("Condition Value");
                        end;

                        if ("Condition Type" = "Condition Type"::Filter) then begin
                            lManufacturer.SetFilter(Code, "Condition Value");
                            if lManufacturer.IsEmpty then begin
                                Error(lEmptyTableErr, lManufacturer.TableCaption);
                            end;
                        end;
                    end;

                "Attribute Type"::Gauge:
                    begin
                        if ("Condition Type" = "Condition Type"::Value) then begin
                            lecGauge.Get("Condition Value");
                        end;

                        if ("Condition Type" = "Condition Type"::Filter) then begin
                            lecGauge.SetFilter(Code, "Condition Value");
                            if lecGauge.IsEmpty then begin
                                Error(lEmptyTableErr, lecGauge.TableCaption);
                            end;
                        end;
                    end;

                "Attribute Type"::Variety:
                    begin
                        if ("Condition Type" = "Condition Type"::Value) then begin
                            lecVariety.Get("Condition Value");
                        end;

                        if ("Condition Type" = "Condition Type"::Filter) then begin
                            lecVariety.SetFilter(Code, "Condition Value");
                            if lecVariety.IsEmpty then begin
                                Error(lEmptyTableErr, lecVariety.TableCaption);
                            end;
                        end;
                    end;

                "Attribute Type"::"Crop Period":
                    begin
                        if ("Condition Type" <> "Condition Type"::"Date Formula") then begin
                            Error(lDateFormulaMandatoryErr, FieldCaption("Condition Type"),
                                                            Format("Condition Type"::"Date Formula"),
                                                            FieldCaption("Attribute Type"),
                                                            Format("Attribute Type"));
                        end;
                    end;
            end;
        end;

        Clear("DateFormula Value");
        if ("Condition Value" <> '') then begin
            if ("Condition Type" = "Condition Type"::"Date Formula") then begin
                if ("Attribute Type" = "Attribute Type"::"Crop Period") then begin
                    if not Evaluate("DateFormula Value", "Condition Value") then begin
                        Error(lDateFormulaNotValidErr, "Condition Value");
                    end;

                    if (CalcDate("DateFormula Value", Today) > Today) then begin
                        Error(lNegativeDateFormulaErr, "DateFormula Value");
                    end;

                    "Condition Value" := Format("DateFormula Value", 0, 9);
                end else begin
                    Error(lDateFormulaNotAllowedErr, FieldCaption("Condition Type"),
                                                     Format("Condition Type"::"Date Formula"),
                                                     FieldCaption("Attribute Type"),
                                                     Format("Attribute Type"));
                end;
            end;
        end;

        "Condition Value" := UpperCase("Condition Value");
    end;

    local procedure LookupConditionValue()
    var
        lVendor: Record Vendor;
        lCountryRegion: Record "Country/Region";
        lManufacturer: Record Manufacturer;
        lecGauge: Record ecGauge;
        lecVariety: Record ecVariety;
        lSelectedValue: Text;
    begin
        lSelectedValue := '';

        if ("Condition Type" in ["Condition Type"::Value, "Condition Type"::Filter]) then begin
            case "Attribute Type" of
                "Attribute Type"::Vendor:
                    begin
                        if Page.RunModal(Page::"Vendor Lookup", lVendor) = Action::LookupOK then begin
                            lSelectedValue := lVendor."No.";
                        end;
                    end;

                "Attribute Type"::"Origin Country":
                    begin
                        if Page.RunModal(Page::"Countries/Regions", lCountryRegion) = Action::LookupOK then begin
                            lSelectedValue := lCountryRegion.Code;
                        end;
                    end;

                "Attribute Type"::Manufacturer:
                    begin
                        if Page.RunModal(Page::Manufacturers, lManufacturer) = Action::LookupOK then begin
                            lSelectedValue := lManufacturer.Code;
                        end;
                    end;

                "Attribute Type"::Gauge:
                    begin
                        if Page.RunModal(Page::ecGauge, lecGauge) = Action::LookupOK then begin
                            lSelectedValue := lecGauge.Code;
                        end;
                    end;

                "Attribute Type"::Variety:
                    begin
                        if Page.RunModal(Page::ecVariety, lecVariety) = Action::LookupOK then begin
                            lSelectedValue := lecVariety.Code;
                        end;
                    end;
            end;

            if (lSelectedValue <> '') then begin
                if ("Condition Type" = "Condition Type"::Filter) and ("Condition Value" <> '') then begin
                    if ("Condition Value".EndsWith('|')) then begin
                        Validate("Condition Value", "Condition Value" + lSelectedValue);
                    end else begin
                        Validate("Condition Value", "Condition Value" + '|' + lSelectedValue);
                    end;
                end else begin
                    Validate("Condition Value", lSelectedValue);
                end;
            end;
        end;
    end;
}
