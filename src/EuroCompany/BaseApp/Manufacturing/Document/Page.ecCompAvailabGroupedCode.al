namespace EuroCompany.BaseApp.Manufacturing.Document;
using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Inventory.Availability;
using Microsoft.Inventory.Item;
using Microsoft.Manufacturing.Document;
using System.Utilities;

page 50054 "ecComp. Availab. Grouped Code"
{
    ApplicationArea = All;
    Caption = 'Availability analysis for component';
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
            group(Options)
            {
                ShowCaption = false;
                grid(OptionLine1)
                {
                    ShowCaption = false;

                    field(AvailabilityCalcMethod; AvailabilityCalcMethod)
                    {
                        Caption = 'Availability Calculation Method';
                        OptionCaption = 'Till to First Usage Date,Till to Last Usage Date,Custom Period Cut-Off Date';

                        trigger OnValidate()
                        var
                            Temp_lComponentAvailabilityBuff: Record "ecComponent Availability Buff." temporary;
                        begin
                            Temp_lComponentAvailabilityBuff.Copy(Rec, true);

                            ClearAvailabilityBuffer();

                            if (AvailabilityCalcMethod = AvailabilityCalcMethod::"Custom Period Cut-Off Date") then begin
                                AvailabilityCalcDate := WorkDate();
                                AvailabilityCalcPeriod := StrSubstNo('..%1', AvailabilityCalcDate);

                                Temp_lComponentAvailabilityBuff.Reset();
                                Temp_lComponentAvailabilityBuff.SetCurrentKey("Max Consumption Date");
                                Temp_lComponentAvailabilityBuff.SetFilter("Max Consumption Date", '<>%1', 0D);
                                if not Temp_lComponentAvailabilityBuff.IsEmpty then begin
                                    Temp_lComponentAvailabilityBuff.FindLast();
                                    AvailabilityCalcDate := Temp_lComponentAvailabilityBuff."Max Consumption Date";
                                    AvailabilityCalcPeriod := StrSubstNo('..%1', AvailabilityCalcDate);
                                end;
                            end else begin
                                AvailabilityCalcDate := 0D;
                                AvailabilityCalcPeriod := '';
                            end;

                            CalcExistsRestriction2();

                            CurrPage.Update(true);
                        end;
                    }
                    field(AvailabilityCalcDate; AvailabilityCalcDate)
                    {
                        Caption = 'Cutoff date';

                        trigger OnValidate()
                        begin
                            ClearAvailabilityBuffer();
                            AvailabilityCalcPeriod := '';
                            if (AvailabilityCalcDate <> 0D) then begin
                                AvailabilityCalcMethod := AvailabilityCalcMethod::"Custom Period Cut-Off Date";
                                AvailabilityCalcPeriod := StrSubstNo('..%1', Format(AvailabilityCalcDate));
                            end else begin
                                if (AvailabilityCalcMethod = AvailabilityCalcMethod::"Custom Period Cut-Off Date") then begin
                                    AvailabilityCalcDate := WorkDate();
                                    AvailabilityCalcPeriod := StrSubstNo('..%1', Format(AvailabilityCalcDate));
                                end;
                            end;

                            CalcExistsRestriction2();

                            CurrPage.Update(true);
                        end;
                    }
                    field(ProdOrder; ProdOrderSelected)
                    {
                        Caption = 'Prod. orders';
                        Editable = false;
                        Style = Strong;
                    }
                }
            }

            repeater(General)
            {
                Editable = false;
                FreezeColumn = "Check Line";

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
                field("Check Line"; CheckLine)
                {
                    Caption = 'Check', Locked = true;
                    Editable = false;
                    Style = Unfavorable;
                }
                field("Min Consumption Date"; Rec."Min Consumption Date")
                {
                    StyleExpr = MinConsumptionDateStyle;
                }
                field("Max Consumption Date"; Rec."Max Consumption Date")
                {
                    StyleExpr = MaxConsumptionDateStyle;
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Unit of Measure code"; Rec."Unit of Measure code")
                {
                }
                field(InventoryTotal; Temp_ItemAvailabilityBuffer.Inventory)
                {
                    Caption = 'Inventory (Total)';
                    //DecimalPlaces = 2 : 5;
                    Editable = false;
                    StyleExpr = Inventory_Style;

                    trigger OnDrillDown()
                    begin
                        DrillDownInventoryTotal();
                    end;
                }
                field(InventoryConstraint; Temp_ItemAvailabilityBuffer."ecInventory Constraint")
                {
                    Caption = 'Inventory constraint';
                    //DecimalPlaces = 2 : 5;
                    Editable = false;
                    StyleExpr = InventoryConstraintStyle;

                    trigger OnDrillDown()
                    begin
                        DrillDownInventoryDetailValue(true);
                    end;
                }
                field(ExpiredQuantity; Temp_ItemAvailabilityBuffer."ecExpired Quantity")
                {
                    Caption = 'Inventory expired';
                    //DecimalPlaces = 2 : 5;
                    Editable = false;
                    StyleExpr = ExpiredQuantityStyle;
                    ToolTip = 'Quantity in stock with max. usage date exceeded according to the calculation formula applied for the analysis';

                    trigger OnDrillDown()
                    begin
                        if (Temp_ItemAvailabilityBuffer."ecExpired Quantity" <> 0) then DrillDownExpiredQty();
                    end;
                }
                field(UsableQuantity; Temp_ItemAvailabilityBuffer."ecUsable Quantity")
                {
                    Caption = 'Inventory usable';
                    //DecimalPlaces = 2 : 5;
                    Editable = false;
                    StyleExpr = UsableQuantityStyle;

                    trigger OnDrillDown()
                    begin
                        DrillDownUsableQuantity();
                    end;
                }
                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Qty. on Component Lines (Firm planned)';
                    DecimalPlaces = 0 : 5;
                    Style = Strong;

                    trigger OnDrillDown()
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
                field("Exists Restrictions"; ExistsRestrictions)
                {
                    Caption = 'Restrictions on components (Firm planned)';
                    Style = Unfavorable;

                    trigger OnDrillDown()
                    begin
                        ShowComponentRestrictionDetails();
                    end;
                }
                field(QtyRelComponentLines; Temp_ItemAvailabilityBuffer."Qty.Rel. Component Lines")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Qty.Rel. Component Lines"));
                    //DecimalPlaces = 2 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        lProdOrderLine: Record "Prod. Order Line";
                        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
                    begin
                        if GetProdOrdLinesForCompToAnalyze(lProdOrderLine, Rec, Enum::"Production Order Status"::Released) then begin
                            lComponentAvailabilityMgt.OpenAvailabilityBuffGroupedByCompDetail(lProdOrderLine, Rec, true);
                        end;
                    end;
                }
                field("Exists Restrictions 2"; ExistsRestrictions2)
                {
                    Caption = 'Restrictions on components (Released)';
                    Style = Unfavorable;

                    trigger OnDrillDown()
                    begin
                        ShowComponentRestrictionDetails();
                    end;
                }
                field(QtyOnComponentLines; Temp_ItemAvailabilityBuffer."Qty. on Component Lines")
                {
                    Caption = 'Qty on components line (Total)';
                    //DecimalPlaces = 2 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDownQtyOnComponentLinesTot();
                    end;
                }
                field(QtyOnSalesOrders; Temp_ItemAvailabilityBuffer."Qty. on Sales Order")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Sales Order"));
                    //DecimalPlaces = 2 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Sales Order"));
                    end;
                }
                field(QtyOnTransferShipments; Temp_ItemAvailabilityBuffer."Qty. on Trans. Ord. Shipment")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Trans. Ord. Shipment"));
                    //DecimalPlaces = 2 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Trans. Ord. Shipment"));
                    end;
                }
                field(CurrentAvailability; Temp_ItemAvailabilityBuffer."Current Availability")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Current Availability"));
                    //DecimalPlaces = 2 : 5;
                    Editable = false;
                    StyleExpr = CurrentAvail_Style;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Current Availability"));
                    end;
                }
                field(QtyOnPurchOrders; Temp_ItemAvailabilityBuffer."Qty. on Purch. Order")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Purch. Order"));
                    //DecimalPlaces = 2 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Purch. Order"));
                    end;
                }

                field(QtyOnPurchOrdersAll; Temp_ItemAvailabilityBuffer."Qty. on Purch. Order (All)")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Purch. Order (All)"));
                    //DecimalPlaces = 2 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Purch. Order (All)"));
                    end;
                }
                field(QtyFirmPlannedProdOrder; Item."ecQty.Firm Planned Prod. Order")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Item.FieldCaption("ecQty.Firm Planned Prod. Order");
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDownQtyOnFirmPlannedProdOrd();
                    end;
                }
                field(QtyRelProdOrder; Temp_ItemAvailabilityBuffer."Qty.Rel. Prod. Order")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Qty.Rel. Prod. Order"));
                    //DecimalPlaces = 2 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Qty.Rel. Prod. Order"));
                    end;
                }
                field(QtyOnTransferRcpt; Temp_ItemAvailabilityBuffer."Qty. on Trans. Ord. Receipt")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Trans. Ord. Receipt"));
                    //DecimalPlaces = 2 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Trans. Ord. Receipt"));
                    end;
                }
                field(QtyInTransit; Temp_ItemAvailabilityBuffer."Qty. in Transit")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Qty. in Transit"));
                    //DecimalPlaces = 2 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Qty. in Transit"));
                    end;
                }
                field(FutureAvailability; Temp_ItemAvailabilityBuffer."Future Availability")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Future Availability"));
                    //DecimalPlaces = 2 : 5;
                    Editable = false;
                    StyleExpr = FutureAvail_Style;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Future Availability"));
                    end;
                }
                field("Reorder Policy"; Rec."Reorder Policy")
                {
                }
                field("Reorder Point"; Rec."Reorder Point")
                {
                }
                field("Safety Stock Quantity"; Rec."Safety Stock Quantity")
                {
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
            group(Analysis)
            {
                Caption = 'Analysis';

                action(Recalculate)
                {
                    Caption = 'Recalculate';
                    Image = Recalculate;
                    Visible = not CalledByCheck;

                    trigger OnAction()
                    var
                        lProdOrderLine: Record "Prod. Order Line";
                        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";

                        lConfirmMsg: Label 'Are you sure you want to recalculate the availability?';
                    begin
                        if not Confirm(lConfirmMsg, false) then exit;

                        ClearAvailabilityBuffer();

                        Clear(lProdOrderLine);
                        lProdOrderLine.SetCurrentKey(ecSelected);
                        lProdOrderLine.SetRange(ecSelected, true);
                        lComponentAvailabilityMgt.CreateGroupedAvailabilityBuff(lProdOrderLine, '', '', Rec,
                                                                                Enum::"ecAvailability Buffer Grouping"::"Prod. Order Comp. Grouped Code", true);
                        Clear(Rec);
                        CurrPage.Update(false);
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
                        if not CalledByCheck then begin
                            Clear(lProdOrderLine);
                            lProdOrderLine.SetCurrentKey(ecSelected);
                            lProdOrderLine.SetRange(ecSelected, true);
                        end else begin
                            lProdOrderLine.Get(ProdOrdLineToCheck.Status, ProdOrdLineToCheck."Prod. Order No.", ProdOrdLineToCheck."Line No.");
                            lProdOrderLine.SetRecFilter();
                        end;
                        if not lProdOrderLine.IsEmpty then begin
                            lComponentAvailabilityMgt.OpenAvailabilityBuffGroupedByCompDetail(lProdOrderLine, Rec, false);
                        end;
                    end;
                }
                action(RestrictionsDetails)
                {
                    Caption = 'Restrictions details';
                    Image = TaxDetail;

                    trigger OnAction()
                    begin
                        ShowComponentRestrictionDetails();
                    end;
                }
            }
        }
        area(Promoted)
        {
            actionref(RecalculatePromoted; Recalculate) { }
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
            actionref(RestrictionsDetailsPromoted; RestrictionsDetails) { }

        }
    }

    var
        Item: Record Item;
        ProdOrdLineToCheck: Record "Prod. Order Line";
        Temp_pTotalAvailabilityBuffer: Record "ecComponent Availability Buff." temporary;
        Temp_ItemAvailabilityBuffer: Record "AltAWPItem Availability Buffer" temporary;
        ItemAvailabilityMgt: Codeunit "AltAWPItem Availability Mgt.";
        AvailabilityCalcMethod: Option "Till to First Usage Date","Till to Last Usage Date","Custom Period Cut-Off Date";
        CheckLine: Text[5];
        Inventory_Style: Text;
        FutureAvail_Style: Text;
        CurrentAvail_Style: Text;
        AvailabilityCalcPeriod: Text;
        AvailabilityDateFilter: Text;
        ProdOrderSelected: Text;
        ExistsRestrictions: Text[5];
        ExistsRestrictions2: Text[5];
        InventoryConstraintStyle: Text;
        ExpiredQuantityStyle: Text;
        UsableQuantityStyle: Text;
        MinConsumptionDateStyle: Text;
        MaxConsumptionDateStyle: Text;
        AvailabilityCalcDate: Date;
        CalledByCheck: Boolean;

    trigger OnOpenPage()
    var
        Temp_lComponentAvailabilityBuff: Record "ecComponent Availability Buff." temporary;
        lProdOrderTxt: Label 'Selected orders';
    begin
        //Tipo di analisi di default "Periodo personalizzato"
        AvailabilityCalcMethod := AvailabilityCalcMethod::"Custom Period Cut-Off Date";
        AvailabilityCalcDate := WorkDate();
        AvailabilityCalcPeriod := StrSubstNo('..%1', AvailabilityCalcDate);
        Temp_lComponentAvailabilityBuff.Copy(Rec, true);
        Temp_lComponentAvailabilityBuff.Reset();
        Temp_lComponentAvailabilityBuff.SetCurrentKey("Max Consumption Date");
        Temp_lComponentAvailabilityBuff.SetFilter("Max Consumption Date", '<>%1', 0D);
        if not Temp_lComponentAvailabilityBuff.IsEmpty then begin
            Temp_lComponentAvailabilityBuff.FindLast();
            AvailabilityCalcDate := Temp_lComponentAvailabilityBuff."Max Consumption Date";
            AvailabilityCalcPeriod := StrSubstNo('..%1', AvailabilityCalcDate);
        end;

        CalcExistsRestriction2();

        ProdOrderSelected := lProdOrderTxt;
        if CalledByCheck then ProdOrderSelected := ProdOrdLineToCheck."Prod. Order No.";
    end;

    trigger OnAfterGetRecord()
    begin
        RecalculateInventoryValues();

        SetFieldStyle();

        ExistsRestrictions := '';
        if Rec."Exists Restrictions" then ExistsRestrictions := Format(Rec."Exists Restrictions");

        ExistsRestrictions2 := '';
        if Rec."Exists Restrictions 2" then ExistsRestrictions2 := Format(Rec."Exists Restrictions 2");

        CheckLine := '';
        if (ExistsRestrictions <> '') or (Temp_ItemAvailabilityBuffer."Current Availability" < 0)
        then begin
            CheckLine := Format(true);
        end;

        MinConsumptionDateStyle := 'Standard';
        if (Rec."Min Consumption Date" < Today) then MinConsumptionDateStyle := 'Unfavorable';

        MaxConsumptionDateStyle := 'Standard';
        if (Rec."Max Consumption Date" < Today) then MaxConsumptionDateStyle := 'Unfavorable';
    end;

    internal procedure InitComponentAvailability(var Temp_pComponentAvailabilityBuffer: Record "ecComponent Availability Buff." temporary)
    begin
        Rec.Copy(Temp_pComponentAvailabilityBuffer, true);
    end;

    local procedure RecalculateInventoryValues()
    begin
        Clear(Temp_ItemAvailabilityBuffer);

        if (Rec."Item No." <> '') then begin
            CalcAvailabilityDateFilter(Rec);

            Clear(Item);
            Item.Get(Rec."Item No.");
            Item.SetRange("Location Filter", Rec."Location Code");
            Item.SetRange("Variant Filter", Rec."Variant Code");
            Item.SetFilter("Date Filter", AvailabilityDateFilter);
            Item.CalcFields("ecQty.Firm Planned Prod. Order");

            ItemAvailabilityMgt.CalcItemAvailability(Item, Temp_ItemAvailabilityBuffer);
            CalcDetailedInventoryValues(Temp_ItemAvailabilityBuffer);
        end;
    end;

    local procedure CalcAvailabilityDateFilter(var Temp_pComponentAvailabilityBuff: Record "ecComponent Availability Buff." temporary)
    begin
        AvailabilityDateFilter := '';
        case AvailabilityCalcMethod of
            AvailabilityCalcMethod::"Custom Period Cut-Off Date":
                begin
                    if (AvailabilityCalcPeriod <> '') then begin
                        AvailabilityDateFilter := AvailabilityCalcPeriod;
                    end;
                end;

            AvailabilityCalcMethod::"Till to First Usage Date":
                begin
                    if (Temp_pComponentAvailabilityBuff."Min Consumption Date" <> 0D) then begin
                        AvailabilityDateFilter := StrSubstNo('..%1', Temp_pComponentAvailabilityBuff."Min Consumption Date");
                    end;
                end;

            AvailabilityCalcMethod::"Till to Last Usage Date":
                begin
                    if (Temp_pComponentAvailabilityBuff."Max Consumption Date" <> 0D) then begin
                        AvailabilityDateFilter := StrSubstNo('..%1', Temp_pComponentAvailabilityBuff."Max Consumption Date");
                    end;
                end;
        end;
    end;

    local procedure CalcDetailedInventoryValues(var Temp_ptemAvailabilityBuffer: Record "AltAWPItem Availability Buffer" temporary)
    var
        Temp_lAWPItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary;
        lAWPLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
        lNotConstraintQty: Decimal;
        lTotalQty: Decimal;
        lTargetDate: Date;
    begin
        lAWPLogisticUnitsMgt.FindOpenWhseEntries(Rec."Item No.", Rec."Variant Code", Rec."Location Code", '', '', '', '', '', false, Temp_lAWPItemInventoryBuffer);

        //Calcolo delle quantità Vincolate
        Clear(Temp_lAWPItemInventoryBuffer);
        Temp_lAWPItemInventoryBuffer.SetRange(Constrained, true);
        if Temp_lAWPItemInventoryBuffer.FindSet() then begin
            Temp_lAWPItemInventoryBuffer.CalcSums("Quantity (Base)");
            Temp_ptemAvailabilityBuffer."ecInventory Constraint" := Temp_lAWPItemInventoryBuffer."Quantity (Base)";
        end;

        case AvailabilityCalcMethod of
            AvailabilityCalcMethod::"Till to First Usage Date":
                begin
                    lTargetDate := Rec."Min Consumption Date";
                end;
            AvailabilityCalcMethod::"Till to Last Usage Date":
                begin
                    lTargetDate := Rec."Max Consumption Date";
                end;
            AvailabilityCalcMethod::"Custom Period Cut-Off Date":
                begin
                    lTargetDate := AvailabilityCalcDate;
                end;
        end;

        Temp_ptemAvailabilityBuffer."ecUsable Quantity" := 0;
        Temp_ItemAvailabilityBuffer."ecExpired Quantity" := 0;
        Temp_ptemAvailabilityBuffer."ecInventory Constraint" := 0;

        //Calcolo della quantità vincolata, utilizzabile e scaduta, le altre le calcolo ma non le utilizzo
        lComponentAvailabilityMgt.CalcAvailabilityFromItemInventoryBuffer(Temp_lAWPItemInventoryBuffer,
                                                                          Temp_ptemAvailabilityBuffer."ecInventory Constraint",
                                                                          lNotConstraintQty,
                                                                          Temp_ItemAvailabilityBuffer."ecUsable Quantity",
                                                                          Temp_ItemAvailabilityBuffer."ecExpired Quantity",
                                                                          lTotalQty,
                                                                          lTargetDate);

        Temp_ItemAvailabilityBuffer."Qty. on Component Lines" := Rec.Quantity + Temp_ItemAvailabilityBuffer."Qty.Rel. Component Lines";

        //Ricalcolo delle disponibilità partendo come base dalla quantità utilizzabile
        Temp_ItemAvailabilityBuffer."Current Availability" := Temp_ItemAvailabilityBuffer."ecUsable Quantity" -
                                                              Temp_ItemAvailabilityBuffer."Qty. on Component Lines" -
                                                              Temp_ItemAvailabilityBuffer."Qty. on Sales Order" -
                                                              Temp_ItemAvailabilityBuffer."Qty. on Trans. Ord. Shipment";

        Temp_ItemAvailabilityBuffer."Future Availability" := Temp_ItemAvailabilityBuffer."Current Availability" +
                                                             Temp_ItemAvailabilityBuffer."Qty. on Purch. Order" +
                                                             Temp_ItemAvailabilityBuffer."Qty. on Prod. Order";
    end;

    local procedure CalcExistsRestriction2()
    var
        Temp_lComponentAvailabilityBuff: Record "ecComponent Availability Buff." temporary;
        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
    begin
        Temp_lComponentAvailabilityBuff.Copy(Rec, true);
        if not Temp_lComponentAvailabilityBuff.IsEmpty then begin
            Temp_lComponentAvailabilityBuff.FindSet();
            repeat
                CalcAvailabilityDateFilter(Temp_lComponentAvailabilityBuff);
                Temp_lComponentAvailabilityBuff."Exists Restrictions 2" := lComponentAvailabilityMgt.ExistsRestrForReleasedProdOrdCompByDate(Temp_lComponentAvailabilityBuff."Item No.",
                                                                                                                                             Temp_lComponentAvailabilityBuff."Variant Code",
                                                                                                                                             AvailabilityDateFilter);
                Temp_lComponentAvailabilityBuff.Modify(false);
            until (Temp_lComponentAvailabilityBuff.Next() = 0);
        end;
    end;

    local procedure SetFieldStyle()
    begin
        Inventory_Style := Temp_ItemAvailabilityBuffer."Inventory Style";
        CurrentAvail_Style := 'Favorable';
        if (Temp_ItemAvailabilityBuffer."Current Availability" < 0) then CurrentAvail_Style := 'Unfavorable';
        FutureAvail_Style := 'Favorable';
        if (Temp_ItemAvailabilityBuffer."Future Availability" < 0) then FutureAvail_Style := 'Unfavorable';
        InventoryConstraintStyle := 'Standard';
        if (Temp_ItemAvailabilityBuffer."ecInventory Constraint" > 0) then InventoryConstraintStyle := 'Unfavorable';
        ExpiredQuantityStyle := 'Standard';
        if (Temp_ItemAvailabilityBuffer."ecExpired Quantity" > 0) then ExpiredQuantityStyle := 'Unfavorable';
        UsableQuantityStyle := 'Unfavorable';
        if (Temp_ItemAvailabilityBuffer."ecUsable Quantity" >= Temp_ItemAvailabilityBuffer."Qty. on Component Lines") then UsableQuantityStyle := 'Favorable';
    end;

    local procedure DrillDownInventoryDetailValue(pConstraintInventory: Boolean)
    var
        Temp_lAWPItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary;
        lAWPLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
    begin
        lAWPLogisticUnitsMgt.FindOpenWhseEntries(Rec."Item No.", Rec."Variant Code", Rec."Location Code", '', '', '', '', '', false, Temp_lAWPItemInventoryBuffer);

        Clear(Temp_lAWPItemInventoryBuffer);
        Temp_lAWPItemInventoryBuffer.SetRange(Constrained, pConstraintInventory);
        if not Temp_lAWPItemInventoryBuffer.IsEmpty then begin
            Page.Run(Page::"AltAWPItem Inventory Analysis", Temp_lAWPItemInventoryBuffer);
        end;
    end;

    local procedure ShowComponentRestrictionDetails()
    var
        lFirmPlanProdOrderLine: Record "Prod. Order Line";
        lReleasedProdOrderLine: Record "Prod. Order Line";
        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
        lComponentsAvailability: Page "ecComp. Avail. Grouped Restr.";
    begin
        Clear(lComponentAvailabilityMgt);
        Clear(Temp_pTotalAvailabilityBuffer);
        if Temp_pTotalAvailabilityBuffer.IsEmpty then begin
            if not CalledByCheck then begin
                Clear(lFirmPlanProdOrderLine);
                if not GetProdOrdLinesForCompToAnalyze(lFirmPlanProdOrderLine, Rec, Enum::"Production Order Status"::"Firm Planned") then exit;
            end else begin
                lFirmPlanProdOrderLine.Get(ProdOrdLineToCheck.Status, ProdOrdLineToCheck."Prod. Order No.", ProdOrdLineToCheck."Line No.");
                lFirmPlanProdOrderLine.SetRecFilter();
            end;
            if not lFirmPlanProdOrderLine.IsEmpty then begin
                Clear(lReleasedProdOrderLine);
                GetProdOrdLinesForCompToAnalyze(lReleasedProdOrderLine, Rec, Enum::"Production Order Status"::Released);
                lComponentAvailabilityMgt.SetAvailabilityCalcMethod(AvailabilityCalcMethod, AvailabilityCalcDate);
                lComponentAvailabilityMgt.CreateAvailabilityBuffGroupedByCompForPlanMonitor(lFirmPlanProdOrderLine, lReleasedProdOrderLine, Temp_pTotalAvailabilityBuffer,
                                                                                            Rec."Item No.", Rec."Variant Code", true);
            end;
        end;
        Clear(Temp_pTotalAvailabilityBuffer);
        Temp_pTotalAvailabilityBuffer.SetRange("Item No.", Rec."Item No.");
        Temp_pTotalAvailabilityBuffer.SetRange("Variant Code", Rec."Variant Code");
        Temp_pTotalAvailabilityBuffer.SetRange("Location Code", Rec."Location Code");
        if not Temp_pTotalAvailabilityBuffer.IsEmpty then begin
            lComponentsAvailability.InitComponentAvailability(Temp_pTotalAvailabilityBuffer);
            lComponentsAvailability.SetAvailabilityCalcDate(AvailabilityDateFilter);
            lComponentsAvailability.RunModal();
        end;

        ClearAvailabilityBuffer();
    end;

    internal procedure SetCalledByCheck(pProdOrdLineToCheck: Record "Prod. Order Line"; pCalledByCheck: Boolean)
    begin
        if not ProdOrdLineToCheck.Get(pProdOrdLineToCheck.Status, pProdOrdLineToCheck."Prod. Order No.", pProdOrdLineToCheck."Line No.") then Clear(ProdOrdLineToCheck);
        CalledByCheck := pCalledByCheck;
    end;

    local procedure DrillDownQtyOnComponentLinesTot()
    var
        lProdOrderLine: Record "Prod. Order Line";
        lProdOrderLineParent: Record "Prod. Order Line";
        Temp_lProdOrderLine: Record "Prod. Order Line" temporary;
        lProdOrderComponent: Record "Prod. Order Component";
        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
    begin
        Clear(Temp_lProdOrderLine);
        Temp_lProdOrderLine.DeleteAll();
        if not CalledByCheck then begin
            Clear(lProdOrderLine);
            lProdOrderLine.SetCurrentKey(ecSelected);
            lProdOrderLine.SetRange(ecSelected, true);
            if not lProdOrderLine.IsEmpty then begin
                lProdOrderLine.FindSet();
                repeat
                    Temp_lProdOrderLine := lProdOrderLine;
                    Temp_lProdOrderLine.Insert(false);
                until (lProdOrderLine.Next() = 0);
            end;
        end else begin
            Temp_lProdOrderLine := ProdOrdLineToCheck;
            Temp_lProdOrderLine.Insert();
        end;

        Clear(lProdOrderComponent);
        lProdOrderComponent.SetFilter(Status, '%1|%2', lProdOrderComponent.Status::"Firm Planned", lProdOrderComponent.Status::Released);
        lProdOrderComponent.SetRange("Item No.", Rec."Item No.");
        lProdOrderComponent.SetRange("Variant Code", Rec."Variant Code");
        lProdOrderComponent.SetRange("Location Code", Rec."Location Code");
        lProdOrderComponent.SetFilter("Due Date", AvailabilityDateFilter);
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindSet();
            repeat
                lProdOrderLine.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.", lProdOrderComponent."Prod. Order Line No.");
                if (lProdOrderLine."ecParent Line No." <> 0) then begin
                    Clear(lProdOrderLineParent);
                    lProdOrderLineParent.SetRange(Status, lProdOrderLine.Status);
                    lProdOrderLineParent.SetRange("Prod. Order No.", lProdOrderLine."Prod. Order No.");
                    lProdOrderLineParent.SetRange("ecParent Line No.", 0);
                    lProdOrderLineParent.FindFirst();
                    lProdOrderLine.Get(lProdOrderLineParent.Status, lProdOrderLineParent."Prod. Order No.", lProdOrderLineParent."Line No.");
                end;
                Temp_lProdOrderLine := lProdOrderLine;
                if Temp_lProdOrderLine.Insert() then;
            until (lProdOrderComponent.Next() = 0);
        end;

        Clear(Temp_lProdOrderLine);
        if not Temp_lProdOrderLine.IsEmpty then begin
            lComponentAvailabilityMgt.OpenAvailabilityBuffGroupedByCompDetail(Temp_lProdOrderLine, Rec, true);
        end;
    end;

    local procedure DrillDownExpiredQty()
    var
        Temp_lAWPItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary;
        lAWPLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
        lTargetDate: Date;
    begin
        lAWPLogisticUnitsMgt.FindOpenWhseEntries(Rec."Item No.", Rec."Variant Code", Rec."Location Code", '', '', '', '', '',
                                                 false, Temp_lAWPItemInventoryBuffer);

        //Calcolo della quantità scaduta
        case AvailabilityCalcMethod of
            AvailabilityCalcMethod::"Till to First Usage Date":
                begin
                    lTargetDate := Rec."Min Consumption Date";
                end;
            AvailabilityCalcMethod::"Till to Last Usage Date":
                begin
                    lTargetDate := Rec."Max Consumption Date";
                end;
            AvailabilityCalcMethod::"Custom Period Cut-Off Date":
                begin
                    lTargetDate := AvailabilityCalcDate;
                end;
        end;

        Clear(Temp_lAWPItemInventoryBuffer);
        Temp_lAWPItemInventoryBuffer.FilterGroup(2);
        Temp_lAWPItemInventoryBuffer.SetFilter("ecMax Usable Date", '<%1 & <>%2', lTargetDate, 0D);
        Temp_lAWPItemInventoryBuffer.FilterGroup(0);
        if not Temp_lAWPItemInventoryBuffer.IsEmpty then begin
            Page.Run(Page::"AltAWPItem Inventory Analysis", Temp_lAWPItemInventoryBuffer);
        end;
    end;

    local procedure DrillDownUsableQuantity()
    var
        Temp_lAWPItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary;
        lAWPLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
        lTargetDate: Date;
    begin
        lAWPLogisticUnitsMgt.FindOpenWhseEntries(Rec."Item No.", Rec."Variant Code", Rec."Location Code", '', '', '', '', '',
                                                 false, Temp_lAWPItemInventoryBuffer);

        //Calcolo della quantità scaduta
        case AvailabilityCalcMethod of
            AvailabilityCalcMethod::"Till to First Usage Date":
                begin
                    lTargetDate := Rec."Min Consumption Date";
                end;
            AvailabilityCalcMethod::"Till to Last Usage Date":
                begin
                    lTargetDate := Rec."Max Consumption Date";
                end;
            AvailabilityCalcMethod::"Custom Period Cut-Off Date":
                begin
                    lTargetDate := AvailabilityCalcDate;
                end;
        end;

        Temp_lAWPItemInventoryBuffer.SetFilter("ecMax Usable Date", '>=%1 | =%2', lTargetDate, 0D);
        if not Temp_lAWPItemInventoryBuffer.IsEmpty then begin
            Temp_lAWPItemInventoryBuffer.FindSet();
            repeat
                if not Temp_lAWPItemInventoryBuffer.Constrained then begin
                    Temp_lAWPItemInventoryBuffer.Mark(true);
                end;
            until (Temp_lAWPItemInventoryBuffer.Next() = 0);
        end;

        Temp_lAWPItemInventoryBuffer.MarkedOnly(true);
        if not Temp_lAWPItemInventoryBuffer.IsEmpty then begin
            Page.Run(Page::"AltAWPItem Inventory Analysis", Temp_lAWPItemInventoryBuffer);
        end;
    end;

    local procedure DrillDownInventoryTotal()
    var
        Temp_lAWPItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary;
        lAWPLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
    begin
        lAWPLogisticUnitsMgt.FindOpenWhseEntries(Rec."Item No.", Rec."Variant Code", Rec."Location Code", '', '', '', '', '',
                                                 false, Temp_lAWPItemInventoryBuffer);
        if not Temp_lAWPItemInventoryBuffer.IsEmpty then begin
            Page.Run(Page::"AltAWPItem Inventory Analysis", Temp_lAWPItemInventoryBuffer);
        end;
    end;

    local procedure ItemAvailability(pItem: Record Item; pAvailabilityType: Option)
    var
        lItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
    begin
        lItemAvailabilityFormsMgt.ShowItemAvailFromItem(pItem, pAvailabilityType);
    end;

    local procedure ClearAvailabilityBuffer()
    begin
        Clear(Temp_pTotalAvailabilityBuffer);
        Temp_pTotalAvailabilityBuffer.DeleteAll();
    end;

    internal procedure GetProdOrdLinesForCompToAnalyze(var pProdOrderLine: Record "Prod. Order Line";
                                                       var Temp_pComponentAvailabilityBuff: Record "ecComponent Availability Buff." temporary;
                                                       pProdOrderStatus: Enum "Production Order Status"): Boolean
    var
        lProdOrderLine2: Record "Prod. Order Line";
        lProdOrderComponent: Record "Prod. Order Component";
    begin
        Clear(pProdOrderLine);
        lProdOrderComponent.SetRange(Status, pProdOrderStatus);
        lProdOrderComponent.SetRange("Item No.", Temp_pComponentAvailabilityBuff."Item No.");
        lProdOrderComponent.SetRange("Variant Code", Temp_pComponentAvailabilityBuff."Variant Code");
        lProdOrderComponent.SetRange("Location Code", Temp_pComponentAvailabilityBuff."Location Code");
        if (pProdOrderStatus = pProdOrderStatus::Released) then lProdOrderComponent.SetFilter("Due Date", AvailabilityDateFilter);
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindSet();
            repeat
                pProdOrderLine.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.", lProdOrderComponent."Prod. Order Line No.");
                if (pProdOrderStatus = pProdOrderStatus::Released) then begin
                    if (pProdOrderLine."ecParent Line No." <> 0) then begin
                        Clear(lProdOrderLine2);
                        lProdOrderLine2.SetRange(Status, pProdOrderLine.Status);
                        lProdOrderLine2.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
                        lProdOrderLine2.SetRange("ecParent Line No.", 0);
                        lProdOrderLine2.FindFirst();
                        pProdOrderLine.Get(lProdOrderLine2.Status, lProdOrderLine2."Prod. Order No.", lProdOrderLine2."Line No.");
                    end;
                    pProdOrderLine.Mark(true);
                end;
                if pProdOrderLine.ecSelected and (pProdOrderStatus = pProdOrderStatus::"Firm Planned") then pProdOrderLine.Mark(true);
            until (lProdOrderComponent.Next() = 0);
        end else begin
            pProdOrderLine.MarkedOnly(true);
            exit(false);
        end;

        pProdOrderLine.MarkedOnly(true);
        exit(true);
    end;

    local procedure DrillDownQtyOnFirmPlannedProdOrd()
    var
        lProdOrderLine: Record "Prod. Order Line";
    begin
        Clear(lProdOrderLine);
        lProdOrderLine.SetCurrentKey(Status, "Item No.", "Variant Code", "Shortcut Dimension 1 Code",
                                     "Shortcut Dimension 2 Code", "Location Code", "Due Date");

        lProdOrderLine.SetRange(Status, lProdOrderLine.Status::"Firm Planned");
        lProdOrderLine.SetRange("Item No.", Rec."Item No.");
        lProdOrderLine.SetFilter("Variant Code", Rec."Variant Code");
        lProdOrderLine.SetFilter("Location Code", Rec."Location Code");
        lProdOrderLine.SetFilter("Due Date", AvailabilityDateFilter);
        Page.Run(Page::"Prod. Order Line List", lProdOrderLine);
    end;
}
