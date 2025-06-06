namespace EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;

table 50046 "ecBy Product Item Relation"
{
    Caption = 'By Product Item Relation';
    DataClassification = CustomerContent;
    Description = 'CS_PRO_041_BIS';

    fields
    {
        field(1; "By Product Item No."; Code[20])
        {
            Caption = 'By Product Item No.';
            TableRelation = Item."No.";

            trigger OnValidate()
            var
                lItem: Record Item;
            begin
                lItem.Get("By Product Item No.");
                "By Product Item Base UM" := lItem."Base Unit of Measure";

                CalcFields("By Product Item Description");
            end;
        }
        field(5; "By Product Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("By Product Item No.")));
            Caption = '"By Product" Item description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Relation Type"; Enum "ecBy Product Item Rel. Types")
        {
            Caption = 'Relation Type';
        }
        field(30; "Component No."; Code[20])
        {
            Caption = 'Component No.';
            TableRelation = Item."No." where("Base Unit of Measure" = field("By Product Item Base UM"));

            trigger OnValidate()
            var
                lByProductItemRelation: Record "ecBy Product Item Relation";

                lByProdCompMyslefErr: Label 'A "By Product" related to itself does not allow other relationships!';
            begin
                CalcFields("Component Decription");

                if ("Component No." = "By Product Item No.") then begin
                    Rec.TestField("Relation Type", Rec."Relation Type"::"One to One");

                    Clear(lByProductItemRelation);
                    lByProductItemRelation.SetRange("By Product Item No.", Rec."By Product Item No.");
                    lByProductItemRelation.SetFilter("Component No.", '<>%1', Rec."By Product Item No.");
                    if not lByProductItemRelation.IsEmpty then Error(lByProdCompMyslefErr);
                end;
            end;
        }
        field(35; "Component Decription"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Component No.")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "By Product Item Base UM"; Code[10])
        {
            Caption = 'By Product Item Base UM';
            TableRelation = "Unit of Measure".Code;
        }
    }
    keys
    {
        key(PK; "By Product Item No.", "Relation Type", "Component No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Rec.TestField("Relation Type");
        Rec.TestField("By Product Item No.");
        Rec.TestField("Relation Type");
        Rec.TestField("Component No.");

        CheckByProductRelations(Rec."By Product Item No.", Rec."Relation Type", true);
    end;

    internal procedure CheckByProductRelations(pByProductItemNo: Code[20]; pRelationType: Enum "ecBy Product Item Rel. Types"; pWithError: Boolean): Boolean
    var
        lByProductItemRelation: Record "ecBy Product Item Relation";

        lError001: Label 'For "%1" = "%2" is already defined a relation type = "%3"!';
    begin
        Clear(lByProductItemRelation);
        lByProductItemRelation.SetRange("By Product Item No.", pByProductItemNo);
        lByProductItemRelation.SetFilter("Relation Type", '<>%1', pRelationType);
        if lByProductItemRelation.FindFirst() then begin
            if pWithError then begin
                Error(lError001, lByProductItemRelation.FieldCaption("By Product Item No."), lByProductItemRelation."By Product Item No.",
                      Format(lByProductItemRelation."Relation Type"));
            end;
            exit(false);
        end;

        exit(true);
    end;

    internal procedure ExistsRelationsForItem(pItemNo: Code[20]): Boolean
    var
        lByProductItemRelation: Record "ecBy Product Item Relation";
    begin
        Clear(lByProductItemRelation);
        lByProductItemRelation.SetRange("By Product Item No.", pItemNo);
        exit(not lByProductItemRelation.IsEmpty);
    end;

    internal procedure DeleteRelationsForItem(pItemNo: Code[20])
    var
        lByProductItemRelation: Record "ecBy Product Item Relation";
    begin
        Clear(lByProductItemRelation);
        lByProductItemRelation.SetRange("By Product Item No.", pItemNo);
        if not lByProductItemRelation.IsEmpty then begin
            lByProductItemRelation.DeleteAll(true);
        end;
    end;
}
