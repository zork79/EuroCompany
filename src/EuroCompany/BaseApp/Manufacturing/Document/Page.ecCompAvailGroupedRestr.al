namespace EuroCompany.BaseApp.Manufacturing.Document;
using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Inventory.Availability;
using Microsoft.Inventory.Item;
using Microsoft.Manufacturing.Document;
using System.Utilities;


page 50059 "ecComp. Avail. Grouped Restr."
{
    ApplicationArea = All;
    Caption = 'Availability analysis for restrictions';
    DeleteAllowed = false;
    Description = 'CS_PRO_018';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = "ecComponent Availability Buff.";
    SourceTableTemporary = true;
    SourceTableView = sorting("Item No.", "Variant Code", "Location Code", "Entry Type", "Restriction Rule Code", "Origin Country/Region Code", "Single Lot Pickings");
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Editable = false;

                field("Item No."; Rec."Item No.")
                {
                    Style = Strong;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                    Visible = false;
                }
                field("Unit of Measure code"; Rec."Unit of Measure code")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Min Consumption Date"; Rec."Min Consumption Date")
                {
                }
                field("Max Consumption Date"; Rec."Max Consumption Date")
                {
                }
                field("Restriction Rule Code"; Rec."Restriction Rule Code")
                {
                    Style = Unfavorable;
                }
                field("Single Lot Pickings"; Rec."Single Lot Pickings")
                {
                }
                field("Origin Country/Region Code"; Rec."Origin Country/Region Code")
                {
                }

                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Qty. on Component Lines (Firm planned)';
                    DecimalPlaces = 2 : 5;
                    StyleExpr = QuantityFirmPlannStyle;

                    trigger OnDrillDown()
                    var
                        lProdOrderLine: Record "Prod. Order Line";
                        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
                    begin
                        if (Rec.Quantity <> 0) then begin
                            Clear(lProdOrderLine);
                            lProdOrderLine.SetCurrentKey(ecSelected);
                            lProdOrderLine.SetRange(ecSelected, true);
                            if not lProdOrderLine.IsEmpty then begin
                                lComponentAvailabilityMgt.OpenAvailabilityBuffGroupedByCompDetail(lProdOrderLine, Rec, false);
                            end;
                        end;
                    end;
                }
                field("Qty.Rel. Component Lines"; Rec."Qty.Rel. Component Lines")
                {
                    DecimalPlaces = 2 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        Temp_lProdOrderComponent: Record "Prod. Order Component" temporary;
                        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
                    begin
                        if (Rec."Qty.Rel. Component Lines" > 0) then begin
                            lComponentAvailabilityMgt.GetProdOrdCompLinesByRestriction(Temp_lProdOrderComponent, Enum::"Production Order Status"::Released,
                                                                                       Rec."Item No.", Rec."Variant Code", Rec."Location Code", '',
                                                                                       Rec."Restriction Rule Code", Rec."Single Lot Pickings",
                                                                                       Rec."Origin Country/Region Code");
                            Clear(Temp_lProdOrderComponent);
                            Page.RunModal(Page::"Prod. Order Comp. Line List", Temp_lProdOrderComponent);
                        end;
                    end;
                }
                field("Qty. on Component Lines"; Rec."Qty. on Component Lines")
                {
                    DecimalPlaces = 2 : 5;
                    Editable = false;
                }
                field("Inventory Total"; Rec."Inventory Total")
                {
                    DecimalPlaces = 2 : 5;
                    Editable = false;
                    StyleExpr = InventoryTotStyle;

                    trigger OnDrillDown()
                    var
                        Temp_lItemInventoryAvailabBuffer: Record "AltAWPItem Inventory Buffer" temporary;
                        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
                    begin
                        if (Rec."Inventory Total" > 0) then begin
                            lComponentAvailabilityMgt.GetTotalInventoryAvailabFromComponentBuff(Rec, Temp_lItemInventoryAvailabBuffer);

                            Clear(Temp_lItemInventoryAvailabBuffer);
                            if not Temp_lItemInventoryAvailabBuffer.IsEmpty then begin
                                Page.Run(Page::"AltAWPItem Inventory Analysis", Temp_lItemInventoryAvailabBuffer);
                            end;
                        end;
                    end;
                }
                field("Inventory Constraint"; Rec."Inventory Constraint")
                {
                    DecimalPlaces = 2 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        Temp_lItemInventoryAvailabBuffer: Record "AltAWPItem Inventory Buffer" temporary;
                        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
                    begin
                        if (Rec."Inventory Constraint" > 0) then begin
                            lComponentAvailabilityMgt.GetTotalInventoryAvailabFromComponentBuff(Rec, Temp_lItemInventoryAvailabBuffer);

                            Clear(Temp_lItemInventoryAvailabBuffer);
                            Temp_lItemInventoryAvailabBuffer.SetRange(Constrained, true);

                            if not Temp_lItemInventoryAvailabBuffer.IsEmpty then begin
                                Page.Run(Page::"AltAWPItem Inventory Analysis", Temp_lItemInventoryAvailabBuffer);
                            end;
                        end;
                    end;
                }
                field("Inventory Not Constraint"; Rec."Inventory Not Constraint")
                {
                    DecimalPlaces = 2 : 5;
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        Temp_lItemInventoryAvailabBuffer: Record "AltAWPItem Inventory Buffer" temporary;
                        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
                    begin
                        if (Rec."Inventory Not Constraint" > 0) then begin
                            lComponentAvailabilityMgt.GetTotalInventoryAvailabFromComponentBuff(Rec, Temp_lItemInventoryAvailabBuffer);

                            Clear(Temp_lItemInventoryAvailabBuffer);
                            Temp_lItemInventoryAvailabBuffer.SetRange(Constrained, false);

                            if not Temp_lItemInventoryAvailabBuffer.IsEmpty then begin
                                Page.Run(Page::"AltAWPItem Inventory Analysis", Temp_lItemInventoryAvailabBuffer);
                            end;
                        end;
                    end;
                }
                field("Expired Quantity"; Rec."Expired Quantity")
                {
                    DecimalPlaces = 2 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        Temp_lItemInventoryAvailabBuffer: Record "AltAWPItem Inventory Buffer" temporary;
                        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
                    begin
                        if (Rec."Expired Quantity" > 0) then begin
                            lComponentAvailabilityMgt.GetTotalInventoryAvailabFromComponentBuff(Rec, Temp_lItemInventoryAvailabBuffer);

                            Clear(Temp_lItemInventoryAvailabBuffer);
                            Temp_lItemInventoryAvailabBuffer.SetFilter("ecMax Usable Date", '<%1', TargetDate);
                            if not Temp_lItemInventoryAvailabBuffer.IsEmpty then begin
                                Page.Run(Page::"AltAWPItem Inventory Analysis", Temp_lItemInventoryAvailabBuffer);
                            end;
                        end;
                    end;
                }
                field("Usable Quantity"; Rec."Usable Quantity")
                {
                    DecimalPlaces = 2 : 5;
                    Editable = false;
                    StyleExpr = UsableQuantityStyle;

                    trigger OnDrillDown()
                    var
                        Temp_lItemInventoryAvailabBuffer: Record "AltAWPItem Inventory Buffer" temporary;
                        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
                    begin
                        if (Rec."Usable Quantity" > 0) then begin
                            lComponentAvailabilityMgt.GetTotalInventoryAvailabFromComponentBuff(Rec, Temp_lItemInventoryAvailabBuffer);

                            Clear(Temp_lItemInventoryAvailabBuffer);
                            Temp_lItemInventoryAvailabBuffer.SetFilter("ecMax Usable Date", '>=%1', TargetDate);
                            Temp_lItemInventoryAvailabBuffer.SetRange(Constrained, false);
                            if not Temp_lItemInventoryAvailabBuffer.IsEmpty then begin
                                Page.Run(Page::"AltAWPItem Inventory Analysis", Temp_lItemInventoryAvailabBuffer);
                            end;
                        end;
                    end;
                }
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(ItemCard)
            {
                Caption = 'Item';
                Image = Card;

                trigger OnAction()
                var
                    lItem: Record Item;
                begin
                    lItem.Get(Rec."Item No.");
                    Page.RunModal(Page::"Item Card", lItem);
                end;
            }
            group("Item Availability by")
            {
                Caption = 'Item Availability by';
                Image = ItemAvailability;
                action(ItemAvailabilityByEvent)
                {
                    Caption = 'Event';
                    Image = "Event";

                    trigger OnAction()
                    var
                        lItem: Record Item;
                        lItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
                    begin
                        lItem.Get(Rec."Item No.");
                        ItemAvailability(lItem, lItemAvailabilityFormsMgt.ByEvent());
                    end;
                }
                action(ItemAvailabilityByPeriod)
                {
                    Caption = 'Period';
                    Image = Period;

                    trigger OnAction()
                    var
                        lItem: Record Item;
                        lItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
                    begin
                        lItem.Get(Rec."Item No.");
                        ItemAvailability(lItem, lItemAvailabilityFormsMgt.ByPeriod());
                    end;
                }
                action(ItemAvailabilityByVariant)
                {
                    Caption = 'Variant';
                    Image = ItemVariant;

                    trigger OnAction()
                    var
                        lItem: Record Item;
                        lItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
                    begin
                        lItem.Get(Rec."Item No.");
                        ItemAvailability(lItem, lItemAvailabilityFormsMgt.ByVariant());
                    end;
                }
                action(ItemAvailabilityByLocation)
                {
                    Caption = 'Location';
                    Image = Warehouse;

                    trigger OnAction()
                    var
                        lItem: Record Item;
                        lItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
                    begin
                        lItem.Get(Rec."Item No.");
                        ItemAvailability(lItem, lItemAvailabilityFormsMgt.ByLocation());
                    end;
                }
                action(Lot)
                {
                    Caption = 'Lot';
                    Image = LotInfo;
                    RunObject = page "Item Availability by Lot No.";
                    RunPageLink = "No." = field("Item No."),
                                  "Location Filter" = field("Location Code"),
                                  "Variant Filter" = field("Variant Code");
                }
                action(ItemAvailabilityByBOMLevel)
                {
                    Caption = 'BOM Level';
                    Image = BOMLevel;

                    trigger OnAction()
                    var
                        lItem: Record Item;
                        lItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
                    begin
                        lItem.Get(Rec."Item No.");
                        ItemAvailability(lItem, lItemAvailabilityFormsMgt.ByBOM());
                    end;
                }
                action(ItemInventoryByLot)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Item Inventory by Lot No';
                    Description = 'AWP033';
                    Image = LotInfo;

                    trigger OnAction()
                    var
                        lItem: Record Item;
                        lAWPItemInventorybyLotNo: Page "AltAWPItem Inventory by Lot No";
                    begin
                        lItem.Get(Rec."Item No.");
                        Clear(lAWPItemInventorybyLotNo);
                        lAWPItemInventorybyLotNo.SetParameters(lItem."No.", '', '', '', false, true, true);
                        lAWPItemInventorybyLotNo.RunModal();
                        Clear(lAWPItemInventorybyLotNo);
                    end;
                }
                action(DetailedBinContent)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Detailed Bin Content';
                    Image = CalculateInventory;

                    trigger OnAction()
                    var
                        lItem: Record Item;
                        lAWPItemInventoryAnalysis: Page "AltAWPItem Inventory Analysis";
                    begin
                        lItem.Get(Rec."Item No.");
                        Clear(lAWPItemInventoryAnalysis);
                        lAWPItemInventoryAnalysis.InitFromItem(lItem);
                        lAWPItemInventoryAnalysis.Run();
                    end;
                }
            }
            group(Component)
            {
                Caption = 'Component';

                action(ComponentUsageDetail)
                {
                    Caption = 'Where-Used';
                    Image = "Where-Used";
                    trigger OnAction()
                    var
                        lProdOrderLine: Record "Prod. Order Line";
                        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
                    begin
                        Clear(lProdOrderLine);
                        lProdOrderLine.SetCurrentKey(ecSelected);
                        lProdOrderLine.SetRange(ecSelected, true);
                        if not lProdOrderLine.IsEmpty then begin
                            lComponentAvailabilityMgt.OpenAvailabilityBuffGroupedByCompDetail(lProdOrderLine, Rec, false);
                        end;
                    end;
                }
            }
        }
        area(Promoted)
        {
            actionref(ItemCardPromoted; ItemCard) { }

            group(ItemAvailabilityByPromoted)
            {
                Caption = 'Item Availability by';
                Image = ItemAvailability;

                actionref(ItemAvailabilityByEventPromoted; ItemAvailabilityByEvent) { }
                actionref(ItemAvailabilityByPeriodPromoted; ItemAvailabilityByPeriod) { }
                actionref(ItemAvailabilityByVariantPromoted; ItemAvailabilityByVariant) { }
                actionref(ItemAvailabilityByLocationPromoted; ItemAvailabilityByLocation) { }
                actionref(LotPromoted; Lot) { }
                actionref(ItemAvailabilityByBOMLevelPromoted; ItemAvailabilityByBOMLevel) { }
                actionref(ItemInventoryByLotPromoted; ItemInventoryByLot) { }
                actionref(DetailedBinContentPromoted; DetailedBinContent) { }
            }

            actionref(ComponentUsageDetailPromoted; ComponentUsageDetail) { }
        }
    }

    var
        UsableQuantityStyle: Text;
        QuantityFirmPlannStyle: Text;
        InventoryTotStyle: Text;
        AvailabilityDateFilter: Text;
        TargetDate: Date;

    trigger OnOpenPage()
    var
        lDate: Record Date;
    begin
        Clear(lDate);
        lDate.SetRange("Period Type", lDate."Period Type"::Date);
        lDate.SetFilter("Period Start", AvailabilityDateFilter);
        if not lDate.IsEmpty then lDate.FindLast();
        TargetDate := lDate."Period Start";
    end;

    trigger OnAfterGetRecord()
    begin
        QuantityFirmPlannStyle := 'Standard';
        if (Rec.Quantity <> 0) then QuantityFirmPlannStyle := 'Strong';

        if (Rec."Inventory Total" < Rec."Qty. on Component Lines") then begin
            InventoryTotStyle := 'Unfavorable';
        end else begin
            InventoryTotStyle := 'Favorable';
        end;

        UsableQuantityStyle := 'Unfavorable';
        if (Rec."Usable Quantity" >= Rec."Qty. on Component Lines") then UsableQuantityStyle := 'Favorable';
    end;

    internal procedure InitComponentAvailability(var Temp_pComponentAvailabilityBuffer: Record "ecComponent Availability Buff." temporary)
    begin
        Rec.Copy(Temp_pComponentAvailabilityBuffer, true);
    end;

    local procedure ItemAvailability(pItem: Record Item; pAvailabilityType: Option)
    var
        lItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
    begin
        lItemAvailabilityFormsMgt.ShowItemAvailFromItem(pItem, pAvailabilityType);
    end;

    internal procedure SetAvailabilityCalcDate(pDateFilter: Text)
    begin
        AvailabilityDateFilter := pDateFilter;
    end;
}