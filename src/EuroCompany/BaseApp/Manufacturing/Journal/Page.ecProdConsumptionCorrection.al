namespace EuroCompany.BaseApp.Manufacturing.Journal;
using EuroCompany.BaseApp.Manufacturing;

page 50023 "ecProd. Consumption Correction"
{
    ApplicationArea = All;
    Caption = 'Production Consumption Correction';
    DelayedInsert = true;
    Description = 'CS_PRO_050';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "ecProd.Cons. Correction Buffer";
    SourceTableTemporary = true;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Item No."; Rec."Item No.")
                {
                    trigger OnValidate()
                    begin
                        if (Rec."Item No." <> xRec."Item No.") then CurrPage.ecProdConsCorrectionSub.Page.DeleteRecords();
                    end;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        if (Rec."Variant Code" <> xRec."Variant Code") then CurrPage.ecProdConsCorrectionSub.Page.DeleteRecords();
                    end;
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    trigger OnValidate()
                    begin
                        if (Rec."Location Code" <> xRec."Location Code") then CurrPage.ecProdConsCorrectionSub.Page.DeleteRecords();
                    end;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    trigger OnValidate()
                    begin
                        if (Rec."Bin Code" <> xRec."Bin Code") then CurrPage.ecProdConsCorrectionSub.Page.DeleteRecords();
                    end;
                }
                field("Pallet No."; Rec."Pallet No.")
                {
                    trigger OnValidate()
                    begin
                        if (Rec."Pallet No." <> xRec."Pallet No.") then CurrPage.ecProdConsCorrectionSub.Page.DeleteRecords();
                    end;
                }
                field("Box No."; Rec."Box No.")
                {
                    trigger OnValidate()
                    begin
                        if (Rec."Box No." <> xRec."Box No.") then CurrPage.ecProdConsCorrectionSub.Page.DeleteRecords();
                    end;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    trigger OnValidate()
                    begin
                        if (Rec."Lot No." <> xRec."Lot No.") then CurrPage.ecProdConsCorrectionSub.Page.DeleteRecords();
                    end;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    trigger OnValidate()
                    begin
                        if (Rec."Serial No." <> xRec."Serial No.") then CurrPage.ecProdConsCorrectionSub.Page.DeleteRecords();
                    end;
                }
                field("Qty. in Inventory"; Rec."Qty. in Inventory")
                {
                }
                field("Qty. Effective"; Rec."Qty. Effective")
                {
                }
                field("Qty. Delta"; Rec."Qty. Delta")
                {
                }
                field("Recalculation Required"; Rec."Recalculation Required")
                {
                }
            }
            part(ecProdConsCorrectionSub; "ecProd. Cons. Correction Sub.")
            {
                Editable = false;
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RecalculateLines)
            {
                Caption = 'Recalculate Lines';
                Image = Calculate;

                trigger OnAction()
                var
                    Temp_lProdConsCorrectionBuffer: Record "ecProd.Cons. Correction Buffer" temporary;
                    lProductionFunctions: Codeunit "ecProduction Functions";
                begin
                    CurrPage.ecProdConsCorrectionSub.Page.GetRecord(Temp_lProdConsCorrectionBuffer);
                    if Temp_lProdConsCorrectionBuffer.IsEmpty then begin
                        lProductionFunctions.CalculateProdConsumptionCorrectionLines(Rec, Temp_lProdConsCorrectionBuffer);
                    end;
                    lProductionFunctions.SplitAdjustedQtyOnConsCorrectionLines(Rec, Temp_lProdConsCorrectionBuffer);
                    CurrPage.ecProdConsCorrectionSub.Page.SetRecord(Temp_lProdConsCorrectionBuffer);
                end;
            }
            action(PostAdjustments)
            {
                Caption = 'Post adjustments';
                Image = PostDocument;

                trigger OnAction()
                var
                    Temp_lProdConsCorrectionBuffer: Record "ecProd.Cons. Correction Buffer" temporary;
                    lProductionFunctions: Codeunit "ecProduction Functions";
                    lBatchName: Code[10];
                    lTemplateName: Code[10];
                begin
                    CurrPage.ecProdConsCorrectionSub.Page.GetRecord(Temp_lProdConsCorrectionBuffer);
                    lTemplateName := '';
                    lBatchName := '';
                    lProductionFunctions.CreateAndPostProdConsCorrItemJournalLine(Rec, Temp_lProdConsCorrectionBuffer, lTemplateName, lBatchName);
                    ResetDataAfterPosting();
                    CurrPage.Update(true);
                end;
            }
            action(Reset)
            {
                Caption = 'Reset';
                Image = Restore;

                trigger OnAction()
                begin
                    ResetData();
                    CurrPage.Update(true);
                end;
            }
        }
        area(Promoted)
        {
            actionref(RecalculateLinesPromoted; RecalculateLines) { }
            actionref(PostAdjustmentsPromoted; PostAdjustments) { }
            actionref(ResetPromoted; Reset) { }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage.ecProdConsCorrectionSub.Page.SetHeaderRecordInformation(Rec);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage.ecProdConsCorrectionSub.Page.SetHeaderRecordInformation(Rec);
    end;

    local procedure ResetData()
    begin
        CurrPage.ecProdConsCorrectionSub.Page.DeleteRecords();
        Rec.Delete();
        Rec.Init();
        Rec.Insert();
    end;

    local procedure ResetDataAfterPosting()
    var
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        if (Rec."Pallet No." <> '') or (Rec."Box No." <> '') then begin
            Rec.Validate("Qty. in Inventory", lProductionFunctions.GetPalletBoxQuantity(Rec."Item No.", Rec."Variant Code", Rec."Location Code", Rec."Bin Code",
                                                                                        Rec."Pallet No.", Rec."Box No.", Rec."Lot No.", Rec."Serial No."));
        end;
        Rec.Validate("Qty. Effective", 0);
        CurrPage.ecProdConsCorrectionSub.Page.DeleteRecords();
    end;
}
