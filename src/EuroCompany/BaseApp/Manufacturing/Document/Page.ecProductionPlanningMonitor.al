namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Inventory.Availability;
using Microsoft.Inventory.Item;
using Microsoft.Manufacturing.Document;
using Microsoft.Manufacturing.Routing;
using Microsoft.Manufacturing.WorkCenter;

page 50052 "ecProduction Planning Monitor"
{
    ApplicationArea = All;
    Caption = 'Production Planning Monitor';
    DeleteAllowed = false;
    Description = 'CS_PRO_018';
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Prod. Order Line";
    SourceTableView = where(Status = filter("Firm Planned" | Released), "ecParent Line No." = const(0));
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(Filters1)
            {
                ShowCaption = false;

                grid(FiltersArea1)
                {
                    ShowCaption = false;

                    field(RoutingFilter; RoutingFilter)
                    {
                        Caption = 'Routing no.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            lRoutingHeader: Record "Routing Header";
                            lRoutingList: Page "Routing List";
                        begin
                            Clear(lRoutingHeader);
                            lRoutingList.LookupMode(true);
                            lRoutingList.SetTableView(lRoutingHeader);
                            if lRoutingList.RunModal() = Action::LookupOK then begin
                                lRoutingList.GetRecord(lRoutingHeader);
                                RoutingFilter := lRoutingHeader."No.";
                                ApplyFilters();
                                CurrPage.Update(false);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            RoutingFilter := UpperCase(RoutingFilter);
                            ApplyFilters();
                            CurrPage.Update(false);
                        end;
                    }
                    field(WorkCenterFilter; WorkCenterFilter)
                    {
                        Caption = 'Work center no.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            lWorkCenter: Record "Work Center";
                            lWorkCenterList: Page "Work Center List";
                        begin
                            Clear(lWorkCenter);
                            lWorkCenterList.LookupMode(true);
                            lWorkCenterList.SetTableView(lWorkCenter);
                            if lWorkCenterList.RunModal() = Action::LookupOK then begin
                                lWorkCenterList.GetRecord(lWorkCenter);
                                WorkCenterFilter := lWorkCenter."No.";
                                ApplyFilters();
                                CurrPage.Update(false);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            WorkCenterFilter := UpperCase(WorkCenterFilter);
                            ApplyFilters();
                            CurrPage.Update(false);
                        end;
                    }
                    field(ParentRoutingFilter; ParentRoutingFilter)
                    {
                        Caption = 'Parent routing';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            lRoutingHeader: Record "Routing Header";
                            lRoutingList: Page "Routing List";
                        begin
                            Clear(lRoutingHeader);
                            lRoutingList.LookupMode(true);
                            lRoutingList.SetTableView(lRoutingHeader);
                            if lRoutingList.RunModal() = Action::LookupOK then begin
                                lRoutingList.GetRecord(lRoutingHeader);
                                ParentRoutingFilter := lRoutingHeader."No.";
                                ApplyFilters();
                                CurrPage.Update(false);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ParentRoutingFilter := UpperCase(ParentRoutingFilter);
                            ApplyFilters();
                            CurrPage.Update(false);
                        end;
                    }
                    field(ParentWorkCenterFilter; ParentWorkCenterFilter)
                    {
                        Caption = 'Parent work center';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            lWorkCenter: Record "Work Center";
                            lWorkCenterList: Page "Work Center List";
                        begin
                            Clear(lWorkCenter);
                            lWorkCenterList.LookupMode(true);
                            lWorkCenterList.SetTableView(lWorkCenter);
                            if lWorkCenterList.RunModal() = Action::LookupOK then begin
                                lWorkCenterList.GetRecord(lWorkCenter);
                                ParentWorkCenterFilter := lWorkCenter."No.";
                                ApplyFilters();
                                CurrPage.Update(false);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ParentWorkCenterFilter := UpperCase(ParentWorkCenterFilter);
                            ApplyFilters();
                            CurrPage.Update(false);
                        end;
                    }
                }
            }
            group(Filters2)
            {
                ShowCaption = false;

                grid(FiltersArea2)
                {
                    ShowCaption = false;

                    field(StatusFilter; StatusFilterCaption)
                    {
                        Caption = 'Status';

                        trigger OnValidate()
                        begin
                            StatusFilter := StatusFilterCaption;
                            ApplyFilters();
                            CurrPage.Update(false);
                        end;

                        trigger OnAssistEdit()
                        var
                            Temp_lEnumSelectionBuffer: Record "APsEnum Selection Buffer" temporary;
                        begin
                            Clear(Temp_lEnumSelectionBuffer);
                            Temp_lEnumSelectionBuffer.DeleteAll();
                            Temp_lEnumSelectionBuffer.RunAssistEdit(Database::"Prod. Order Line", Rec.FieldNo(Status), StatusFilter);
                            StatusFilter := Temp_lEnumSelectionBuffer.GetSelectedAsPipeSeparatedValueNames();
                            StatusFilterCaption := Temp_lEnumSelectionBuffer.GetSelectedAsPipeSeparatedCaptions();

                            ApplyFilters();
                            CurrPage.Update(false);
                        end;
                    }
                    field(StartingDateTimeFilter; StartingDateTimeFilter)
                    {
                        Caption = 'Starting date/time';

                        trigger OnValidate()
                        begin
                            if (StartingDateTimeFilter <> '') then begin
                                StartingDateTimeFilter := MakeDateTimeFilter(StartingDateTimeFilter);
                            end;

                            ApplyFilters();
                            CurrPage.Update(false);
                        end;
                    }
                    field(EndingDateTimeFilter; EndingDateTimeFilter)
                    {
                        Caption = 'Ending date/time';

                        trigger OnValidate()
                        var
                        begin
                            if (EndingDateTimeFilter <> '') then begin
                                EndingDateTimeFilter := MakeDateTimeFilter(EndingDateTimeFilter);
                            end;

                            ApplyFilters();
                            CurrPage.Update(false);
                        end;
                    }
                    field(ProdOrderNoFilter; ProdOrderNoFilter)
                    {
                        Caption = 'Prod. Order No.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            lProductionOrder: Record "Production Order";
                            lReleasedProductionOrders: Page "Released Production Orders";
                        begin
                            Clear(lProductionOrder);
                            lReleasedProductionOrders.LookupMode(true);
                            lReleasedProductionOrders.SetTableView(lProductionOrder);
                            if lReleasedProductionOrders.RunModal() = Action::LookupOK then begin
                                lReleasedProductionOrders.GetRecord(lProductionOrder);
                                ProdOrderNoFilter := lProductionOrder."No.";
                                ApplyFilters();
                                CurrPage.Update(false);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ProdOrderNoFilter := UpperCase(ProdOrderNoFilter);
                            ApplyFilters();
                            CurrPage.Update(false);
                        end;
                    }
                }
            }
            group(Filters3)
            {
                ShowCaption = false;

                grid(FiltersArea3)
                {
                    ShowCaption = false;

                    field(BandFilter; BandFilter)
                    {
                        Caption = 'Band';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            lBand: Record ecBand;
                            lBandsPage: Page ecBands;
                        begin
                            Clear(lBand);
                            lBandsPage.LookupMode(true);
                            lBandsPage.SetTableView(lBand);
                            if lBandsPage.RunModal() = Action::LookupOK then begin
                                lBandsPage.GetRecord(lBand);
                                BandFilter := lBand.Code;
                                ApplyFilters();
                                CurrPage.Update(false);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            BandFilter := UpperCase(BandFilter);
                            ApplyFilters();
                            CurrPage.Update(false);
                        end;
                    }
                    field(FilmFilter; FilmFilter)
                    {
                        Caption = 'Film';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            lItem: Record Item;
                            lItemList: Page "Item List";
                        begin
                            Clear(lItem);
                            lItem.SetCurrentKey("ecItem Type");
                            lItem.SetRange("ecItem Type", lItem."ecItem Type"::"Film Packaging");
                            lItemList.LookupMode(true);
                            lItemList.SetTableView(lItem);
                            if lItemList.RunModal() = Action::LookupOK then begin
                                lItemList.GetRecord(lItem);
                                FilmFilter := lItem."No.";
                                ApplyFilters();
                                CurrPage.Update(false);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            FilmFilter := UpperCase(FilmFilter);
                            ApplyFilters();
                            CurrPage.Update(false);
                        end;
                    }
                    field(CartonsFilter; CartonsFilter)
                    {
                        Caption = 'Carton';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            lItem: Record Item;
                            lItemList: Page "Item List";
                        begin
                            Clear(lItem);
                            lItem.SetCurrentKey("ecItem Type");
                            lItem.SetRange("ecItem Type", lItem."ecItem Type"::"Carton Packaging");
                            lItemList.LookupMode(true);
                            lItemList.SetTableView(lItem);
                            if (lItemList.RunModal() = Action::LookupOK) then begin
                                lItemList.GetRecord(lItem);
                                CartonsFilter := lItem."No.";
                                ApplyFilters();
                                CurrPage.Update(false);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            CartonsFilter := UpperCase(CartonsFilter);
                            ApplyFilters();
                            CurrPage.Update(false);
                        end;
                    }
                    field(ItemFilter; ItemFilter)
                    {
                        Caption = 'Item';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            lItem: Record Item;
                            lItemList: Page "Item List";
                        begin
                            Clear(lItem);
                            lItemList.LookupMode(true);
                            lItemList.SetTableView(lItem);
                            if lItemList.RunModal() = Action::LookupOK then begin
                                lItemList.GetRecord(lItem);
                                ItemFilter := lItem."No.";
                                ApplyFilters();
                                CurrPage.Update(false);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ItemFilter := UpperCase(ItemFilter);
                            ApplyFilters();
                            CurrPage.Update(false);
                        end;
                    }
                }
            }

            repeater(General)
            {
                field(ecSelected; Rec.ecSelected)
                {
                    Enabled = (Rec.Status = Rec.Status::"Firm Planned") and LineSelectable;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field(ecCheck; CheckValueFormat)
                {
                    Caption = 'Check';
                    Editable = false;
                    StyleExpr = CheckStatusStyle;

                    trigger OnDrillDown()
                    var
                        lProdOrderLine: Record "Prod. Order Line";
                        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
                    begin
                        Clear(lProdOrderLine);
                        lProdOrderLine.Get(Rec.Status, Rec."Prod. Order No.", Rec."Line No.");
                        lProdOrderLine.SetRecFilter();
                        lComponentAvailabilityMgt.OpenAvailabBuffGroupedByCompCode(lProdOrderLine, true);
                    end;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    StyleExpr = ProdOrderStatusStyle;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    Editable = false;
                    StyleExpr = ProdOrderNoStyle;
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("ecProductive Status"; Rec."ecProductive Status")
                {
                    Editable = false;
                    StyleExpr = ProductiveStatusStyle;
                }
                field(StartingDateTime2; Rec."Starting Date-Time")
                {
                    Editable = false;
                }
                field("Routing No."; Rec."Routing No.")
                {
                    Editable = false;
                }
                field("ecProduction Process Type"; Rec."ecProduction Process Type")
                {
                    Editable = false;
                    Description = 'CS_QMS_011';
                    DrillDown = false;
                }
                field("ecWork Center No."; Rec."ecWork Center No.")
                {
                    Editable = false;
                }
                field("ecParent Routing No."; Rec."ecParent Routing No.")
                {
                    Editable = false;
                }
                field("ecParent Work Center No."; Rec."ecParent Work Center No.")
                {
                    Editable = false;
                }
                field(ecBand; Rec.ecBand)
                {
                    Editable = false;
                }
                field("ecFilm Packaging Code"; Rec."ecFilm Packaging Code")
                {
                    Editable = false;
                }
                field("ecCartons Packaging Code"; Rec."ecCartons Packaging Code")
                {
                    Editable = false;
                }
                field(LinkedLineNo; GetNoOfLinkedLine(Rec))
                {
                    BlankZero = true;
                    Caption = 'Linked lines';
                    Editable = false;
                    Style = Strong;

                    trigger OnDrillDown()
                    begin
                        ShowLinkedProdOrdLines(Rec);
                    end;
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
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    Editable = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                    StyleExpr = QuantityStyle;
                }
                field("Finished Quantity"; Rec."Finished Quantity")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Starting Date-Time"; Rec."Starting Date-Time")
                {
                    Editable = false;
                }
                field("Ending Date-Time"; Rec."Ending Date-Time")
                {
                    Editable = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    Editable = false;
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("ecPlanning Notes"; Rec."ecPlanning Notes")
                {
                    Description = 'GAP_PRO_013';

                    trigger OnAssistEdit()
                    begin
                        Rec.EditTextField(Rec, Rec.FieldNo("ecPlanning Notes"));
                    end;
                }
                field("ecProduction Notes"; Rec."ecProduction Notes")
                {
                    Description = 'GAP_PRO_013';

                    trigger OnAssistEdit()
                    begin
                        Rec.EditTextField(Rec, Rec.FieldNo("ecPlanning Notes"));
                    end;
                }
                field("ecSend-Ahead Quantity"; Rec."ecSend-Ahead Quantity")
                {
                    Description = 'CS_PRO_018';
                    Editable = false;
                    Visible = false;
                }
                field("ecSelected By"; Rec."ecSelected By")
                {
                    Editable = false;
                    Style = Strong;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Order)
            {
                Caption = 'Order';
                Image = Order;

                trigger OnAction()
                var
                    lProductionOrder: Record "Production Order";
                    lReleasedProductionOrder: Page "Released Production Order";
                    lFirmPlannedProdOrder: Page "Firm Planned Prod. Order";
                begin
                    lProductionOrder.Get(Rec.Status, Rec."Prod. Order No.");
                    lProductionOrder.SetRecFilter();
                    if (Rec.Status = Rec.Status::Released) then begin
                        lReleasedProductionOrder.SetTableView(lProductionOrder);
                        lReleasedProductionOrder.RunModal();
                    end;
                    if (Rec.Status = Rec.Status::"Firm Planned") then begin
                        lFirmPlannedProdOrder.SetTableView(lProductionOrder);
                        lFirmPlannedProdOrder.RunModal();
                    end;
                end;
            }
            action(LinkedLineAct)
            {
                Caption = 'Linked lines';
                Image = Link;

                trigger OnAction()
                begin
                    ShowLinkedProdOrdLines(Rec);
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
                        lItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
                    begin
                        ItemAvailability(lItemAvailabilityFormsMgt.ByEvent());
                    end;
                }
                action(ItemAvailabilityByPeriod)
                {
                    Caption = 'Period';
                    Image = Period;

                    trigger OnAction()
                    var
                        lItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
                    begin
                        ItemAvailability(lItemAvailabilityFormsMgt.ByPeriod());
                    end;
                }
                action(ItemAvailabilityByVariant)
                {
                    Caption = 'Variant';
                    Image = ItemVariant;

                    trigger OnAction()
                    var
                        lItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
                    begin
                        ItemAvailability(lItemAvailabilityFormsMgt.ByVariant());
                    end;
                }
                action(ItemAvailabilityByLocation)
                {
                    Caption = 'Location';
                    Image = Warehouse;

                    trigger OnAction()
                    var
                        lItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
                    begin
                        ItemAvailability(lItemAvailabilityFormsMgt.ByLocation());
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
                        lItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
                    begin
                        ItemAvailability(lItemAvailabilityFormsMgt.ByBOM());
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
            group(ComponentAvailability)
            {
                action(ShowAvailabilityGroupByComp)
                {
                    Caption = 'Availability components analysis';
                    Image = Components;

                    trigger OnAction()
                    var
                        lProdOrderLine: Record "Prod. Order Line";
                        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
                    begin
                        Clear(lProdOrderLine);
                        lProdOrderLine.SetCurrentKey(ecSelected);
                        lProdOrderLine.SetRange(ecSelected, true);
                        lProdOrderLine.SetRange(Status, lProdOrderLine.Status::"Firm Planned");
                        if not lProdOrderLine.IsEmpty then begin
                            lComponentAvailabilityMgt.OpenAvailabBuffGroupedByCompCode(lProdOrderLine, false);
                        end;
                        CurrPage.Update(false);
                    end;
                }
            }
            action(Reserve)
            {
                ApplicationArea = Reservation;
                Caption = 'Reserve';
                Image = Reserve;

                trigger OnAction()
                begin
                    PageShowReservation();
                end;
            }
            action(Routing)
            {
                Caption = 'Routing';
                Image = Route;

                trigger OnAction()
                begin
                    Rec.ShowRouting();
                end;
            }
            action(Components)
            {
                Caption = 'Components';
                Image = Components;

                trigger OnAction()
                begin
                    ShowComponents();
                end;
            }
            action(UpdateRoutingNo)
            {
                Caption = 'Update routing no.';
                Enabled = Rec."Planning Level Code" = 0;
                Image = RoutingVersions;

                trigger OnAction()
                var
                    lProductionOrder: Record "Production Order";
                    lProductionFunctions: Codeunit "ecProduction Functions";
                begin
                    lProductionOrder.Get(Rec.Status, Rec."Prod. Order No.");
                    lProductionFunctions.UpdateRoutingOnProdOrder(lProductionOrder);
                    CurrPage.Update(false);
                end;
            }
            action(SelectMultiLines)
            {
                Caption = 'Select lines';
                Image = GetLines;

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

                trigger OnAction()
                begin
                    SelectUnselectMultiLines(false);
                    CurrPage.Update(false);
                end;
            }
            action(ReleaseSelectedProdOrders)
            {
                Caption = 'Release selected prod. orders';
                Image = ChangeStatus;

                trigger OnAction()
                begin
                    Rec.ReleaseSelectedLines();
                    CurrPage.Update(false);
                end;
            }
        }

        area(Promoted)
        {
            group(Line)
            {
                Caption = 'Line';

                actionref(OrderPromoted; Order) { }
                actionref(LinkedLinePromoted; LinkedLineAct) { }

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

                actionref(ReservePromoted; Reserve) { }
                actionref(RoutingPromoted; Routing) { }
                actionref(ComponentsPromoted; Components) { }
            }
            group(FunctionsPromoted)
            {
                Caption = 'Functions';

                actionref(ShowAvailabilityGroupByCompPromoted; ShowAvailabilityGroupByComp) { }
                actionref(UpdateRoutingNoPromoted; UpdateRoutingNo) { }
            }
            group(Release)
            {
                Caption = 'Release';

                actionref(SelectMultiLinesPromoted; SelectMultiLines) { }
                actionref(UnselectMultiLinesPromoted; UnselectMultiLines) { }
                actionref(ReleaseSelectedProdOrders_Promoted; ReleaseSelectedProdOrders) { }
            }
        }
    }

    var
        FilmFilter: Text;
        BandFilter: Text;
        ItemFilter: Text;
        CartonsFilter: Text;
        RoutingFilter: Text;
        QuantityStyle: Text;
        ProdOrderNoStyle: Text;
        WorkCenterFilter: Text;
        ProdOrderNoFilter: Text;
        ParentRoutingFilter: Text;
        EndingDateTimeFilter: Text;
        ProductiveStatusStyle: Text;
        StartingDateTimeFilter: Text;
        ParentWorkCenterFilter: Text;
        StatusFilter: Text;
        StatusFilterCaption: Text;
        ProdOrderStatusStyle: Text;
        CheckStatusStyle: Text;
        CheckValueFormat: Text[10];
        LineSelectable: Boolean;

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey(Status, "Starting Date-Time");
        InitPage();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        ClearSelectedRecords(true);
    end;

    trigger OnAfterGetRecord()
    begin
        SetProdOrderStatusStyle();
        ProductiveStatusStyle := SetProductiveStatusStyle();
        LineSelectable := IsSelectableLine(Rec);

        CheckValueFormat := '';
        CheckStatusStyle := 'Standard';
        if Rec.ecCheck then begin
            CheckValueFormat := Format(Rec.ecCheck);
            CheckStatusStyle := 'Unfavorable';
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        LineSelectable := IsSelectableLine(Rec);
    end;

    local procedure InitPage()
    var
        lProductionOrderStatus: Enum "Production Order Status";
        lIndex: Integer;
    begin
        FilmFilter := '';
        ItemFilter := '';
        RoutingFilter := '';
        CartonsFilter := '';
        WorkCenterFilter := '';
        ProdOrderNoFilter := '';
        ParentRoutingFilter := '';
        EndingDateTimeFilter := '';
        StartingDateTimeFilter := '';
        ParentWorkCenterFilter := '';
        lIndex := lProductionOrderStatus.Ordinals().IndexOf(lProductionOrderStatus::"Firm Planned".AsInteger());
        lProductionOrderStatus.Names().Get(lIndex, StatusFilter);
        StatusFilterCaption := Format(Rec.Status::"Firm Planned");

        ClearSelectedRecords(false);
        ApplyFilters();
        CurrPage.Update(false);
    end;

    local procedure ApplyFilters()
    begin
        if Rec.FindFirst() then;

        Rec.FilterGroup(2);
        Rec.SetRange("Item No.");
        Rec.SetRange("Starting Date-Time");
        Rec.SetRange("Ending Date-Time");
        Rec.SetRange("Due Date");
        Rec.SetRange(ecBand);
        Rec.SetRange(Status);
        Rec.SetRange("Routing No.");
        Rec.SetRange("ecWork Center No.");
        Rec.SetRange("ecParent Routing No.");
        Rec.SetRange("ecParent Work Center No.");
        Rec.SetRange("ecFilm Packaging Code");
        Rec.SetRange("ecCartons Packaging Code");
        Rec.SetRange("Prod. Order No.");

        if (ItemFilter <> '') then begin
            Rec.SetFilter("Item No.", ItemFilter);
        end;

        if (StartingDateTimeFilter <> '') then begin
            Rec.SetFilter("Starting Date-Time", StartingDateTimeFilter);
        end;

        if (EndingDateTimeFilter <> '') then begin
            Rec.SetFilter("Ending Date-Time", EndingDateTimeFilter);
        end;

        if (ProdOrderNoFilter <> '') then begin
            Rec.SetFilter("Prod. Order No.", ProdOrderNoFilter);
        end;

        if (BandFilter <> '') then begin
            Rec.SetFilter(ecBand, BandFilter);
        end;

        Rec.SetFilter(Status, StatusFilter);

        if (RoutingFilter <> '') then begin
            Rec.SetFilter("Routing No.", RoutingFilter);
        end;

        if (WorkCenterFilter <> '') then begin
            Rec.SetFilter("ecWork Center No.", WorkCenterFilter);
        end;

        if (ParentRoutingFilter <> '') then begin
            Rec.SetFilter("ecParent Routing No.", ParentRoutingFilter);
        end;

        if (ParentWorkCenterFilter <> '') then begin
            Rec.SetFilter("ecParent Work Center No.", ParentWorkCenterFilter);
        end;

        if (FilmFilter <> '') then begin
            Rec.SetFilter("ecFilm Packaging Code", FilmFilter);
        end;

        if (CartonsFilter <> '') then begin
            Rec.SetFilter("ecCartons Packaging Code", CartonsFilter);
        end;

        if Rec.FindFirst() then;
        CurrPage.Update(false);

    end;

    local procedure MakeDateTimeFilter(pDateTimeFilter: Text): Text
    var
        lProdOrderLine: Record "Prod. Order Line";
    begin
        lProdOrderLine.SetFilter("Starting Date-Time", pDateTimeFilter);
        exit(lProdOrderLine.GetFilter("Starting Date-Time"));
    end;

    local procedure ShowComponents()
    var
        ProdOrderComp: Record "Prod. Order Component";
    begin
        ProdOrderComp.SetRange(Status, Rec.Status);
        ProdOrderComp.SetRange("Prod. Order No.", Rec."Prod. Order No.");
        ProdOrderComp.SetRange("Prod. Order Line No.", Rec."Line No.");

        Page.Run(Page::"Prod. Order Components", ProdOrderComp);
    end;

    local procedure ItemAvailability(AvailabilityType: Option)
    var
        lItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
    begin
        lItemAvailabilityFormsMgt.ShowItemAvailFromProdOrderLine(Rec, AvailabilityType);
    end;

    local procedure PageShowReservation()
    begin
        CurrPage.SaveRecord();
        Rec.ShowReservation();
    end;

    internal procedure GetNoOfLinkedLine(pProdOrderLine: Record "Prod. Order Line"): Integer
    var
        lProdOrderComponent: Record "Prod. Order Component";
        lLinkedLine: Integer;
    begin
        lLinkedLine := 0;
        Clear(lProdOrderComponent);
        lProdOrderComponent.SetRange(Status, Rec.Status);
        lProdOrderComponent.SetRange("Prod. Order No.", Rec."Prod. Order No.");
        lProdOrderComponent.SetRange("Prod. Order Line No.", Rec."Line No.");
        lProdOrderComponent.SetFilter("Supplied-by Line No.", '<>%1', 0);
        if not lProdOrderComponent.IsEmpty then begin
            lLinkedLine += lProdOrderComponent.Count;
        end;

        lProdOrderComponent.SetRange("Prod. Order Line No.");
        lProdOrderComponent.SetRange("Supplied-by Line No.", Rec."Line No.");
        if not lProdOrderComponent.IsEmpty then begin
            lLinkedLine += lProdOrderComponent.Count;
        end;

        exit(lLinkedLine);
    end;

    internal procedure ShowLinkedProdOrdLines(pProdOrderLine: Record "Prod. Order Line")
    var
        lProdOrderLine: Record "Prod. Order Line";
        lProdOrderComponent: Record "Prod. Order Component";
        lLinkedProdOrdLineLookup: Page "ecLinked Prod.Ord. Line Lookup";
    begin
        Clear(lProdOrderComponent);
        lProdOrderComponent.SetRange(Status, Rec.Status);
        lProdOrderComponent.SetRange("Prod. Order No.", Rec."Prod. Order No.");
        lProdOrderComponent.SetRange("Prod. Order Line No.", Rec."Line No.");
        lProdOrderComponent.SetFilter("Supplied-by Line No.", '<>%1', 0);
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindSet();
            repeat
                lProdOrderLine.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.", lProdOrderComponent."Supplied-by Line No.");
                lProdOrderLine.Mark(true);
            until (lProdOrderComponent.Next() = 0);
        end;

        lProdOrderComponent.SetRange("Prod. Order Line No.");
        lProdOrderComponent.SetRange("Supplied-by Line No.", Rec."Line No.");
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindSet();
            repeat
                lProdOrderLine.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.", lProdOrderComponent."Prod. Order Line No.");
                lProdOrderLine.Mark(true);
            until (lProdOrderComponent.Next() = 0);
        end;

        lProdOrderLine.SetRange(Status, pProdOrderLine.Status);
        lProdOrderLine.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        lProdOrderLine.MarkedOnly(true);
        if not lProdOrderLine.IsEmpty then begin
            lLinkedProdOrdLineLookup.SetTableView(lProdOrderLine);
            lLinkedProdOrdLineLookup.RunModal();
        end;
    end;

    local procedure SetProdOrderStatusStyle()
    begin
        case Rec.Status of
            Rec.Status::Released:
                begin
                    ProdOrderStatusStyle := 'Favorable';
                end;
            Rec.Status::"Firm Planned":
                begin
                    ProdOrderStatusStyle := 'StrongAccent';
                end;
        end;
    end;

    local procedure SetProductiveStatusStyle(): Text
    begin
        case Rec."ecProductive Status" of
            Rec."ecProductive Status"::Activated:
                exit('Favorable');
            Rec."ecProductive Status"::Released:
                exit('Strong');
            Rec."ecProductive Status"::Scheduled:
                exit('StrongAccent');
            Rec."ecProductive Status"::Suspended:
                exit('Unfavorable');
            Rec."ecProductive Status"::Completed:
                exit('Ambiguous');
        end;
    end;

    local procedure SelectUnselectMultiLines(pSelectionType: Boolean)
    var
        lProdOrderLine: Record "Prod. Order Line";
        latsProgressDialogMgr: Codeunit "AltATSProgress Dialog Mgr.";

        lDialogTxt: Label 'Line selection...\@1@@@@@@@@@@@@@';
    begin
        CurrPage.SetSelectionFilter(lProdOrderLine);
        if lProdOrderLine.FindSet() then begin
            latsProgressDialogMgr.OpenProgressDialog(lDialogTxt, 1, lProdOrderLine.Count);
            repeat
                latsProgressDialogMgr.UpdateProgress(1);
                if (lProdOrderLine.Status = lProdOrderLine.Status::"Firm Planned") and IsSelectableLine(lProdOrderLine) then begin
                    lProdOrderLine.Validate(ecSelected, pSelectionType);
                    lProdOrderLine.Modify(false);
                end;
            until (lProdOrderLine.Next() = 0);
            latsProgressDialogMgr.CloseProgressDialog();
        end;
    end;

    local procedure ClearSelectedRecords(pWithConfirm: Boolean)
    var
        lProdOrderLine: Record "Prod. Order Line";
        lClearSelectedErr: Label 'Warning, this operation will clear the "%1" field on all records, do you want to continue?';
        lOperationCanceled: Label 'Operation canceled';
    begin
        Clear(lProdOrderLine);
        lProdOrderLine.SetRange(Status, lProdOrderLine.Status::"Firm Planned");
        lProdOrderLine.SetRange("ecSelected By", UserId());
        if not lProdOrderLine.IsEmpty then begin
            if pWithConfirm then begin
                if not Confirm(StrSubstNo(lClearSelectedErr, Rec.FieldCaption(ecSelected))) then Error(lOperationCanceled);
            end;
            lProdOrderLine.FindSet();
            repeat
                if lProdOrderLine.ecSelected or lProdOrderLine.ecCheck then begin
                    lProdOrderLine.Validate(ecSelected, false);
                    lProdOrderLine.Modify(false);
                end;
            until (lProdOrderLine.Next() = 0);
        end;
    end;

    internal procedure IsSelectableLine(var pProdOrderLine: Record "Prod. Order Line"): Boolean
    begin
        exit((pProdOrderLine."ecSelected By" = UserId()) or (pProdOrderLine."ecSelected By" = ''));
    end;
}
