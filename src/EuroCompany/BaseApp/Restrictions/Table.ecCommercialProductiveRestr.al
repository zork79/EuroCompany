namespace EuroCompany.BaseApp.Restrictions;

using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Restrictions.Rules;
using Microsoft.Inventory.BOM;
using Microsoft.Inventory.BOM.Tree;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;

table 50029 "ecCommercial/Productive Restr."
{
    Caption = 'Commercial and Productive Restrictions';
    DataClassification = CustomerContent;
    Description = 'CS_PRO_011';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; Scope; Enum "ecRestr. Application Scope")
        {
            Caption = 'Scope';

            trigger OnValidate()
            var
                lRec: Record "ecCommercial/Productive Restr.";
            begin
                lRec := Rec;

                Rec.Init();
                Rec.Scope := lRec.Scope;
                Rec.Validate("Application Type", "Application Type"::Item);

                case Scope of
                    Scope::Purchase:
                        Validate("Relation Type", "Relation Type"::"All Vendors");
                    Scope::Production:
                        Validate("Relation Type", "Relation Type"::"All BOM Components");
                    Scope::Sales:
                        Validate("Relation Type", "Relation Type"::"All Customers");
                end;
            end;
        }
        field(10; "Application Type"; Enum "ecRestriction Application Type")
        {
            Caption = 'Application Type';

            trigger OnValidate()
            begin
                Validate("No.", '');
            end;
        }
        field(11; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if ("Application Type" = const(Item)) Item."No.";

            trigger OnValidate()
            var
                lItem: Record Item;
                lNotProdItemErr: Label 'Production restrictions can only be activated on production items';
            begin
                if ("No." <> '') then begin
                    TestField("Application Type", "Application Type"::Item);
                    lItem.Get("No.");

                    if (Scope = Scope::Production) then begin
                        if not (lItem."ecItem Type" in [lItem."ecItem Type"::"Finished Product",
                                                        lItem."ecItem Type"::"Semi-finished Product"])
                        then begin
                            Error(lNotProdItemErr);
                        end;
                    end;
                end;

                "Variant Code" := '';
            end;
        }
        field(12; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("No."));

            trigger OnValidate()
            begin
                if ("Variant Code" <> '') then begin
                    TestField("Application Type", "Application Type"::Item);
                end;
            end;
        }
        field(20; "Relation Type"; Enum "ecRestr. Application Relation")
        {
            Caption = 'Relation Type';

            trigger OnValidate()
            var
                lInvalidScopeErr: Label 'The relation type "%1" is not usable for restrictions in scope %2';
            begin
                case "Relation Type" of
                    "Relation Type"::"All Customers",
                    "Relation Type"::Customer:
                        begin
                            if (Scope <> Scope::Sales) then begin
                                Error(lInvalidScopeErr, "Relation Type", Scope);
                            end
                        end;

                    "Relation Type"::"All Vendors",
                    "Relation Type"::Vendor:
                        begin
                            if (Scope <> Scope::Purchase) then begin
                                Error(lInvalidScopeErr, "Relation Type", Scope);
                            end
                        end;

                    "Relation Type"::"All BOM Components",
                    "Relation Type"::"Prod. BOM Component":
                        begin
                            if (Scope <> Scope::Production) then begin
                                Error(lInvalidScopeErr, "Relation Type", Scope);
                            end
                        end;
                end;

                Validate("Relation No.", '');
            end;
        }
        field(21; "Relation No."; Code[20])
        {
            Caption = 'Relation No.';
            TableRelation =
            if ("Relation Type" = const(Customer)) Customer."No."
            else
            if ("Relation Type" = const(Vendor)) Vendor."No."
            else
            if ("Relation Type" = const("Prod. BOM Component")) Item."No.";

            trigger OnValidate()
            var
                lErr001: Label '%1 must be empty when %2 is %3';
            begin
                if ("Relation No." <> '') then begin
                    if not ("Relation Type" in ["Relation Type"::Customer,
                                                "Relation Type"::Vendor,
                                                "Relation Type"::"Prod. BOM Component"])
                    then begin
                        Error(lErr001, FieldCaption("Relation No."), FieldCaption("Relation Type"), "Relation Type");
                    end;
                end;

                Validate("Relation Detail No.", '');
            end;

            trigger OnLookup()
            begin
                case "Relation Type" of
                    "Relation Type"::Vendor:
                        begin
                            LookupVendorRelation();
                        end;
                    "Relation Type"::Customer:
                        begin
                            LookupCustomerRelation();
                        end;
                    "Relation Type"::"Prod. BOM Component":
                        begin
                            LookupProdBOMComponentRelation();
                        end;
                end;
            end;
        }

        field(22; "Relation Detail No."; Code[20])
        {
            Caption = 'Relation Detail No.';
            TableRelation = if ("Relation Type" = const("Prod. BOM Component")) "Item Variant".Code where("Item No." = field("Relation No."));

            trigger OnValidate()
            begin
                if ("Relation Detail No." <> '') then begin
                    TestField("Relation Type", "Relation Type"::"Prod. BOM Component");
                    TestField("Relation No.");
                end;
            end;
        }
        field(30; "Restriction Rule Code"; Code[50])
        {
            Caption = 'Restriction Rule Code';
            TableRelation = "ecRestriction Rule Header".Code;

            trigger OnValidate()
            begin
                CalcFields("Restriction Rule Description");
            end;
        }
        field(31; "Restriction Rule Description"; Text[100])
        {
            CalcFormula = lookup("ecRestriction Rule Header".Description where(Code = field("Restriction Rule Code")));
            Caption = 'Restriction Rule Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Negative Result Notification"; Enum "ecNegative Restr. Notif. Type")
        {
            Caption = 'Negative Result Notification Type';
        }
        field(50; "Single Lot Pickings"; Boolean)
        {
            Caption = 'Single Lot Pickings';

            trigger OnValidate()
            begin
                if not (Scope in [Scope::Production, Scope::Sales]) then begin
                    Error(InvalidParamScopeErr, FieldCaption("Single Lot Pickings"), Scope);
                end;
            end;
        }
        field(51; "Progressive Lot No. Expiration"; Boolean)
        {
            Caption = 'Progressive Lot No. Expiration';

            trigger OnValidate()
            begin
                if (Scope <> Scope::Sales) then begin
                    Error(InvalidParamScopeErr, FieldCaption("Progressive Lot No. Expiration"), Scope);
                end;
            end;
        }
        field(80; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if ("Starting Date" > "Ending Date") then begin
                    "Ending Date" := 0D;
                end;
            end;
        }
        field(81; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                TestEndingDate();
            end;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Scope, "Application Type", "No.", "Variant Code", "Relation Type", "Relation No.", "Relation Detail No.", "Starting Date") { }
        key(Key3; Scope, "Application Type", "No.", "Variant Code", "Relation No.", "Relation Detail No.", "Starting Date") { }
    }

    var
        InvalidParamScopeErr: Label 'The parameter "%1" is not usable for restrictions in scope %2';

    trigger OnInsert()
    begin
        TestRecord();
    end;

    trigger OnModify()
    begin
        TestRecord();
    end;

    local procedure TestRecord()
    begin
        Rec.TestField("Starting Date");
        TestEndingDate();

        if ("Application Type" = "Application Type"::Item) then begin
            TestField("No.");
        end else begin
            TestField("No.", '');
        end;

        case Scope of
            Scope::Purchase:
                begin
                    if not ("Relation Type" in ["Relation Type"::"All Vendors",
                                                "Relation Type"::Vendor])
                    then begin
                        FieldError("Relation Type");
                    end;
                end;

            Scope::Production:
                begin
                    if not ("Relation Type" in ["Relation Type"::"All BOM Components",
                                                "Relation Type"::"Prod. BOM Component"])
                    then begin
                        FieldError("Relation Type");
                    end;
                end;

            Scope::Sales:
                begin
                    if not ("Relation Type" in ["Relation Type"::"All Customers",
                                                "Relation Type"::Customer])
                    then begin
                        FieldError("Relation Type");
                    end;
                end;
        end;

        if ("Relation Type" in ["Relation Type"::Vendor,
                                "Relation Type"::"Prod. BOM Component",
                                "Relation Type"::Customer])
        then begin
            TestField("Relation No.");
        end;

        CheckForDuplicates();
    end;

    local procedure TestEndingDate()
    var
        lWrongEndingDate: Label 'The end date must be greater than the start date';
    begin
        if (Rec."Ending Date" <> 0D) then begin
            if (Rec."Ending Date" < Rec."Starting Date") then begin
                Error(lWrongEndingDate);
            end;
        end;
    end;

    local procedure CheckForDuplicates()
    var
        lecCommercialProductiveRestr: Record "ecCommercial/Productive Restr.";
        lAlreadyDefinedRestrErr: Label 'Already defined restrinction on line %1';
        lNewRuleEndingDate: Date;
        lOldRuleEndingDate: Date;
    begin
        lecCommercialProductiveRestr.Reset();
        lecCommercialProductiveRestr.SetCurrentKey(Scope, "Application Type", "No.", "Variant Code", "Relation Type", "Relation No.", "Relation Detail No.", "Starting Date");
        lecCommercialProductiveRestr.SetRange(Scope, Scope);
        lecCommercialProductiveRestr.SetRange("Application Type", "Application Type");
        lecCommercialProductiveRestr.SetRange("No.", "No.");
        lecCommercialProductiveRestr.SetRange("Variant Code", "Variant Code");
        lecCommercialProductiveRestr.SetRange("Relation Type", "Relation Type");
        lecCommercialProductiveRestr.SetRange("Relation No.", "Relation No.");
        lecCommercialProductiveRestr.SetRange("Relation Detail No.", "Relation Detail No.");
        lecCommercialProductiveRestr.SetFilter("Entry No.", '<>%1', "Entry No.");
        if lecCommercialProductiveRestr.FindSet() then begin
            lNewRuleEndingDate := Rec."Ending Date";
            if (lNewRuleEndingDate = 0D) then lNewRuleEndingDate := 99991231D;

            repeat
                lOldRuleEndingDate := lecCommercialProductiveRestr."Ending Date";
                if (lOldRuleEndingDate = 0D) then lOldRuleEndingDate := 99991231D;

                /*
                Regola esistente:    <----------------------->
                Nuova regola:               <------------>
                */
                if (Rec."Starting Date" >= lecCommercialProductiveRestr."Starting Date") and
                   (lNewRuleEndingDate <= lecCommercialProductiveRestr."Ending Date")
                then begin
                    Error(lAlreadyDefinedRestrErr, lecCommercialProductiveRestr."Entry No.");
                end;

                /*
                Regola esistente:    <----------------------->
                Nuova regola:    <------------>
                */
                if (Rec."Starting Date" <= lecCommercialProductiveRestr."Starting Date") and
                   (lNewRuleEndingDate >= lecCommercialProductiveRestr."Starting Date")
                then begin
                    Error(lAlreadyDefinedRestrErr, lecCommercialProductiveRestr."Entry No.");
                end;

                /*
                Regola esistente:    <----------------------->
                Nuova regola:                           <------------>
                */
                if (Rec."Starting Date" <= lOldRuleEndingDate) and
                   (lNewRuleEndingDate >= lecCommercialProductiveRestr."Starting Date")
                then begin
                    Error(lAlreadyDefinedRestrErr, lecCommercialProductiveRestr."Entry No.");
                end;
            until (lecCommercialProductiveRestr.Next() = 0);
        end;
    end;

    internal procedure GetItemDescription(pItemNo: Code[20]; pVariantCode: Code[10]): Text
    var
        lItem: Record Item;
        lItemVariant: Record "Item Variant";
    begin
        if (pVariantCode <> '') then begin
            if lItemVariant.Get(pItemNo, pVariantCode) then begin
                if (lItemVariant.Description <> '') then begin
                    exit(lItemVariant.Description);
                end;
            end;
        end else begin
            if lItem.Get(pItemNo) then begin
                exit(lItem.Description);
            end;
        end;

        exit('');
    end;

    internal procedure GetRelationName(): Text
    var
        lCustomer: Record Customer;
        lVendor: Record Vendor;
    begin
        case "Relation Type" of
            "Relation Type"::Customer:
                begin
                    if lCustomer.Get("Relation No.") then begin
                        exit(lCustomer.Name);
                    end;
                end;

            "Relation Type"::Vendor:
                begin
                    if lVendor.Get("Relation No.") then begin
                        exit(lVendor.Name);
                    end;
                end;

            "Relation Type"::"Prod. BOM Component":
                begin
                    exit(GetItemDescription("Relation No.", "Relation Detail No."));
                end;
        end;

        exit('');
    end;

    local procedure LookupCustomerRelation()
    var
        lCustomer: Record Customer;
        lCustomerList: Page "Customer List";
    begin
        Clear(lCustomer);
        Clear(lCustomerList);
        lCustomerList.LookupMode(true);
        lCustomerList.SetTableView(lCustomer);
        if lCustomerList.RunModal() = Action::LookupOK then begin
            lCustomerList.GetRecord(lCustomer);
            Validate("Relation No.", lCustomer."No.");
        end;
    end;

    local procedure LookupVendorRelation()
    var
        lVendor: Record Vendor;
        lVendorList: Page "Vendor List";
    begin
        Clear(lVendor);
        Clear(lVendorList);
        lVendorList.LookupMode(true);
        lVendorList.SetTableView(lVendor);
        if lVendorList.RunModal() = Action::LookupOK then begin
            lVendorList.GetRecord(lVendor);
            Validate("Relation No.", lVendor."No.");
        end;
    end;

    local procedure LookupProdBOMComponentRelation()
    var
        lItem: Record Item;
        Temp_lBOMBuffer: Record "BOM Buffer" temporary;
        lCalcBOMTree: Codeunit "Calculate BOM Tree";
        lItemList: Page "Item List";
    begin
        Clear(Temp_lBOMBuffer);
        Temp_lBOMBuffer.DeleteAll();

        lItem.SetRange("No.", Rec."No.");
        lCalcBOMTree.GenerateTreeForItems(lItem, Temp_lBOMBuffer, 0);
        if not Temp_lBOMBuffer.IsEmpty then begin
            Temp_lBOMBuffer.FindSet();
            repeat
                if (Temp_lBOMBuffer.Type = Temp_lBOMBuffer.Type::Item) then begin
                    lItem.Get(Temp_lBOMBuffer."No.");
                    lItem.Mark(true);
                end;
            until (Temp_lBOMBuffer.Next() = 0);
        end;

        lItem.SetRange("No.");
        lItem.MarkedOnly(true);
        if not lItem.IsEmpty then begin
            Clear(lItemList);
            lItemList.LookupMode(true);
            lItemList.SetTableView(lItem);
            if lItemList.RunModal() = Action::LookupOK then begin
                lItemList.GetRecord(lItem);
                Validate("Relation No.", lItem."No.");
            end;
        end;
    end;
}