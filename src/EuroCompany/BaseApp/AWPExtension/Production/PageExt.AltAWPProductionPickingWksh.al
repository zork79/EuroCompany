namespace EuroCompany.BaseApp.AWPExtension.Production;
using Microsoft.Manufacturing.Document;

pageextension 80195 "AltAWPProduction Picking Wksh." extends "AltAWPProduction Picking Wksh."
{
    layout
    {
        modify(AltAWPQtyOnComponentLines)
        {
            Visible = false;
        }
        addafter(AltAWPQtyOnSalesOrders)
        {
            field(QuantityOnCompLines; Temp_ItemAvailabilityBuffer."ecQty. on Component Lines")
            {
                Caption = 'Qty. on Component Lines';
                ApplicationArea = All;
                Editable = false;

                trigger OnDrillDown()
                begin
                    DrillDownQuantityOnCompLines();
                end;
            }
        }
    }

    internal procedure DrillDownQuantityOnCompLines()
    var
        lProdOrderLine: Record "Prod. Order Line";
        lProdOrderComponent: Record "Prod. Order Component";
        lProdOrderCompLineList: Page "Prod. Order Comp. Line List";
    begin
        Clear(lProdOrderComponent);
        lProdOrderComponent.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Due Date");
        lProdOrderComponent.SetRange(Status, lProdOrderComponent.Status::Released);
        lProdOrderComponent.SetRange("Item No.", Temp_ItemAvailabilityBuffer."No.");
        lProdOrderComponent.SetFilter("Variant Code", Temp_ItemAvailabilityBuffer.GetFilter("Variant Filter"));
        lProdOrderComponent.SetFilter("Location Code", Temp_ItemAvailabilityBuffer.GetFilter("Location Filter"));
        lProdOrderComponent.SetFilter("Due Date", Format(Temp_ItemAvailabilityBuffer.GetFilter("Date Filter")));
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindSet();
            repeat
                lProdOrderLine.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.", lProdOrderComponent."Prod. Order Line No.");
                if (lProdOrderLine."ecProductive Status" in [lProdOrderLine."ecProductive Status"::Activated,
                                                             lProdOrderLine."ecProductive Status"::Scheduled])
                then begin
                    lProdOrderComponent.Mark(true);
                end;
            until (lProdOrderComponent.Next() = 0);
        end;

        lProdOrderComponent.MarkedOnly(true);
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderCompLineList.SetTableView(lProdOrderComponent);
            lProdOrderCompLineList.Run();
        end;
    end;
}
