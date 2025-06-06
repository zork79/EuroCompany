namespace EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Inventory.Item;

page 50078 "ecBy Product Item Relations"
{
    ApplicationArea = All;
    Caption = 'By Product Item Relations';
    DelayedInsert = true;
    Description = 'CS_PRO_041_BIS';
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "ecBy Product Item Relation";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(RelationType)
            {
                ShowCaption = false;
                field(ByProductItemNo; Item."No.")
                {
                    Caption = 'Item no.';
                    Editable = false;
                }
                field(ByProductItemDescription; Item.Description)
                {
                    Caption = 'Description';
                    Editable = false;
                }
                field(ByProductRelationType; ByProductRelationType)
                {
                    Caption = 'Relation type';

                    trigger OnValidate()
                    begin
                        if (Item."ecBy Product Relation Type" <> ByProductRelationType) then begin
                            Item.Validate("ecBy Product Relation Type", ByProductRelationType);
                            Item.Modify(true);
                        end;
                    end;
                }
            }
            repeater(General)
            {
                field("Component No."; Rec."Component No.")
                {
                }
                field("Component Decription"; Rec."Component Decription")
                {
                }
            }
        }
    }

    var
        Item: Record Item;
        ByProductRelationType: Enum "ecBy Product Item Rel. Types";

    procedure SetPageDataView(pItem: Record Item)
    begin
        Item.Get(pItem."No.");
    end;

    trigger OnOpenPage()
    begin
        Item.TestField("No.");

        Rec.FilterGroup(2);
        Rec.SetRange("By Product Item No.", Item."No.");
        Rec.FilterGroup(0);

        ByProductRelationType := Item."ecBy Product Relation Type";
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Relation Type" := ByProductRelationType;
    end;
}
