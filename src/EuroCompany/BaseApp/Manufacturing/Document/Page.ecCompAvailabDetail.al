namespace EuroCompany.BaseApp.Manufacturing.Document;
using Microsoft.Manufacturing.Document;

page 50057 "ecComp. Availab. Detail"
{
    ApplicationArea = All;
    Caption = 'Component availability details';
    DeleteAllowed = false;
    Description = 'CS_PRO_018';
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "ecComponent Availability Buff.";
    SourceTableTemporary = true;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Prod. Order Status"; Rec."Prod. Order Status")
                {
                    Editable = false;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    Editable = false;
                    Style = Strong;
                }
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
                {
                    Editable = false;
                }
                field("Parent Item No."; Rec."Parent Item No.")
                {
                    Editable = false;
                }
                field("Component Line No."; Rec."Component Line No.")
                {
                    Editable = false;
                }
                field(Selected; Rec.Selected)
                {
                    Editable = false;
                    Visible = not OnlyReadMode;
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    Style = Strong;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Unit of Measure code"; Rec."Unit of Measure code")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    Editable = false;
                }
                field("Reserved Cons. Bin"; Rec."Reserved Cons. Bin")
                {
                }
                field("Min Consumption Date"; Rec."Min Consumption Date")
                {
                    Editable = false;
                }
                field("Max Consumption Date"; Rec."Max Consumption Date")
                {
                    Editable = false;
                }
                field(QuantityProdOrdCompDetail; Rec.Quantity)
                {
                    DecimalPlaces = 2 : 5;
                    Editable = false;
                    Style = Strong;
                }
                field("Inventory (Base)"; ProdOrderComponent."AltAWPInventory (Base)")
                {
                    Caption = 'Qty. in inventory (Base)';
                    DecimalPlaces = 2 : 5;
                    Editable = false;
                }
                field("Bin Content (Base)"; ProdOrderComponent."AltAWPBin Content (Base)")
                {
                    Caption = 'Qty. in Bin (Base)';
                    DecimalPlaces = 2 : 5;
                    Editable = false;
                }
                field("Bin Pick Qty. (Base)"; ProdOrderComponent."AltAWPBin Pick Qty. (Base)")
                {
                    Caption = 'Bin Pick Qty. (Base)';
                    DecimalPlaces = 2 : 5;
                    Editable = false;
                }
                field("Restriction Rule Code"; Rec."Restriction Rule Code")
                {
                    Editable = false;
                    Style = Unfavorable;
                }
                field("Single Lot Pickings"; Rec."Single Lot Pickings")
                {
                    Editable = false;
                }
                field("Origin Country/Region Code"; Rec."Origin Country/Region Code")
                {
                    Editable = false;
                }
            }
        }
    }


    actions
    {
        area(Processing)
        {
            group(Line)
            {
                Caption = 'Line';

                action(Order)
                {
                    Caption = 'Order';
                    Image = Order;

                    trigger OnAction()
                    var
                        lProductionOrder: Record "Production Order";
                    begin
                        lProductionOrder.Get(Rec."Prod. Order Status", Rec."Prod. Order No.");
                        if (Rec."Prod. Order Status" = Rec."Prod. Order Status"::"Firm Planned") then begin
                            Page.RunModal(Page::"Firm Planned Prod. Order", lProductionOrder);
                        end;
                        if (Rec."Prod. Order Status" = Rec."Prod. Order Status"::Released) then begin
                            Page.RunModal(Page::"Released Production Order", lProductionOrder);
                        end;
                    end;
                }
                action(SelectMultiLines)
                {
                    Caption = 'Select lines';
                    Image = GetLines;
                    Visible = not OnlyReadMode;

                    trigger OnAction()
                    begin
                        SelectUnselectMultiLines(true);
                        CurrPage.Update(false);
                    end;
                }
                action(UnselectMultiLines)
                {
                    Caption = 'Unselect lines';
                    Image = CancelLine;
                    Visible = not OnlyReadMode;

                    trigger OnAction()
                    begin
                        SelectUnselectMultiLines(false);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
        area(Promoted)
        {
            actionref(OrderPromoted; Order) { }
            actionref(SelectMultiLinesPromoted; SelectMultiLines) { }
            actionref(UnselectMultiLinesPromoted; UnselectMultiLines) { }
        }
    }

    var
        ProdOrderComponent: Record "Prod. Order Component";
        OnlyReadMode: Boolean;

    trigger OnAfterGetRecord()
    begin
        if ProdOrderComponent.Get(Rec."Prod. Order Status", Rec."Prod. Order No.", Rec."Prod. Order Line No.", Rec."Component Line No.") then begin
            ProdOrderComponent.CalcFields("AltAWPBin Pick Qty. (Base)", "AltAWPBin Content (Base)", "AltAWPInventory (Base)");
        end else begin
            Clear(ProdOrderComponent);
        end;
    end;

    internal procedure InitComponentAvailability(var Temp_pComponentAvailabilityBuffer: Record "ecComponent Availability Buff." temporary)
    begin
        Rec.Copy(Temp_pComponentAvailabilityBuffer, true);
    end;

    local procedure SelectUnselectMultiLines(pSelectionType: Boolean)
    var
        lProdOrderLine: Record "Prod. Order Line";
        Temp_lComponentAvailabilityBuff: Record "ecComponent Availability Buff." temporary;

        lConfirm001: Label 'Are you sure you want to perform the operation for the "%1" selected rows?';
    begin
        Temp_lComponentAvailabilityBuff.Copy(Rec, true);
        CurrPage.SetSelectionFilter(Temp_lComponentAvailabilityBuff);
        if Temp_lComponentAvailabilityBuff.FindSet() then begin
            if not Confirm(StrSubstNo(lConfirm001, Format(Temp_lComponentAvailabilityBuff.Count)), false) then exit;

            repeat
                lProdOrderLine.SetRange(Status, Temp_lComponentAvailabilityBuff."Prod. Order Status");
                lProdOrderLine.SetRange("Prod. Order No.", Temp_lComponentAvailabilityBuff."Prod. Order No.");
                if lProdOrderLine.FindSet() then begin
                    repeat
                        lProdOrderLine.Validate(ecSelected, pSelectionType);
                        lProdOrderLine.Modify(true);
                    until (lProdOrderLine.Next() = 0);
                end;
            until (Temp_lComponentAvailabilityBuff.Next() = 0);

            Temp_lComponentAvailabilityBuff.ModifyAll(Selected, pSelectionType, false);
        end;
    end;

    internal procedure SetOnlyReadMode(pOnlyReadMode: Boolean)
    begin
        OnlyReadMode := pOnlyReadMode;
    end;
}