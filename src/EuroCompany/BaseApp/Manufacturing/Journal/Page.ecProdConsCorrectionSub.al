namespace EuroCompany.BaseApp.Manufacturing.Journal;
using Microsoft.Manufacturing.Document;

page 50024 "ecProd. Cons. Correction Sub."
{
    ApplicationArea = All;
    Caption = 'Prod. Cons. Correction Subpage';
    DelayedInsert = true;
    DeleteAllowed = false;
    Description = 'CS_PRO_050';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "ecProd.Cons. Correction Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    StyleExpr = StyleText;
                }
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
                {
                    StyleExpr = StyleText;
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                    Visible = false;
                }
                field("Qty. Consumed"; Rec."Qty. Consumed")
                {
                }
                field("Qty. Adjusted"; Rec."Qty. Adjusted")
                {
                }
                field("Qty. Delta"; Rec."Qty. Delta")
                {
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SelectLine)
            {
                Caption = 'Select line';
                Enabled = ActionEnabled;
                Image = SelectMore;

                trigger OnAction()
                begin
                    if not Rec.Selected then begin
                        Rec.Validate(Selected, true);
                        Temp_ProdConsCorrectionBufferHeader."Recalculation Required" := true;
                        Temp_ProdConsCorrectionBufferHeader.Modify(true);
                        CurrPage.Update(true);
                    end;
                end;
            }
            action(DeselectLine)
            {
                Caption = 'Deselect line';
                Enabled = ActionEnabled;
                Image = CancelLine;

                trigger OnAction()
                begin
                    if Rec.Selected then begin
                        Rec.Validate(Selected, false);
                        Temp_ProdConsCorrectionBufferHeader."Recalculation Required" := true;
                        Temp_ProdConsCorrectionBufferHeader.Modify(true);
                        CurrPage.Update(true);
                    end;
                end;
            }
            action(OpenProdOrder)
            {
                Caption = 'Prod. Order';
                Enabled = ActionEnabled;
                Image = Order;

                trigger OnAction()
                var
                    lProductionOrder: Record "Production Order";
                    lReleasedProductionOrder: Page "Released Production Order";
                begin
                    lProductionOrder.Get(Rec."Prod. Order Status", Rec."Prod. Order No.");
                    lProductionOrder.SetRecFilter();

                    Clear(lReleasedProductionOrder);
                    lReleasedProductionOrder.SetTableView(lProductionOrder);
                    lReleasedProductionOrder.RunModal();
                end;
            }
        }
    }

    var
        Temp_ProdConsCorrectionBufferHeader: Record "ecProd.Cons. Correction Buffer" temporary;
        StyleText: Text;
        ActionEnabled: Boolean;

    trigger OnAfterGetRecord()
    begin
        StyleText := 'Standard';
        if Rec.Selected then StyleText := 'Favorable';
    end;

    trigger OnAfterGetCurrRecord()
    begin
        ActionEnabled := (Rec."Prod. Order No." <> '');
    end;

    internal procedure SetRecord(var Temp_pProdConsCorrectionBuffer: Record "ecProd.Cons. Correction Buffer" temporary)
    begin
        Clear(Temp_pProdConsCorrectionBuffer);
        if not Temp_pProdConsCorrectionBuffer.IsEmpty then begin
            Clear(Rec);
            Rec.DeleteAll();

            Temp_pProdConsCorrectionBuffer.FindSet();
            repeat
                Rec := Temp_pProdConsCorrectionBuffer;
                Rec.Insert();
            until (Temp_pProdConsCorrectionBuffer.Next() = 0);

            Rec.FindFirst();
        end;
    end;

    internal procedure GetRecord(var Temp_pProdConsCorrectionBuffer: Record "ecProd.Cons. Correction Buffer" temporary)
    var
        lProdConsCorrectionBuffer: Record "ecProd.Cons. Correction Buffer";
    begin
        Clear(Temp_pProdConsCorrectionBuffer);
        if not Temp_pProdConsCorrectionBuffer.IsEmpty then begin
            Temp_pProdConsCorrectionBuffer.DeleteAll();
        end;

        lProdConsCorrectionBuffer := Rec;
        Clear(Rec);
        if not Rec.IsEmpty then begin
            Rec.FindSet();
            repeat
                Temp_pProdConsCorrectionBuffer := Rec;
                Temp_pProdConsCorrectionBuffer.Insert();
            until (Rec.Next() = 0);
        end;

        if Rec.Get(lProdConsCorrectionBuffer."Key", lProdConsCorrectionBuffer."Prod. Order Status",
                   lProdConsCorrectionBuffer."Prod. Order No.", lProdConsCorrectionBuffer."Prod. Order Line No.",
                   lProdConsCorrectionBuffer."Prod. Order Comp. Line No.") then;
    end;

    internal procedure DeleteRecords()
    begin
        Clear(Rec);
        Rec.DeleteAll();
    end;

    internal procedure SetHeaderRecordInformation(var Temp_pProdConsCorrectionBufferHeader: Record "ecProd.Cons. Correction Buffer" temporary)
    begin
        Temp_ProdConsCorrectionBufferHeader.Copy(Temp_pProdConsCorrectionBufferHeader, true);
    end;
}
