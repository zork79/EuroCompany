namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Inventory;
using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Inventory.Tracking;
using EuroCompany.BaseApp.Manufacturing;
using EuroCompany.BaseApp.Manufacturing.Reports;
using Microsoft.Inventory.Availability;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;
using Microsoft.Manufacturing.Document;
using Microsoft.Manufacturing.Journal;
using Microsoft.Manufacturing.Routing;
using Microsoft.Manufacturing.WorkCenter;
using System.Security.User;

page 50041 "ecProd. Scheduling Monitor"
{
    ApplicationArea = All;
    Caption = 'Monitor for Production scheduling and progress';
    DeleteAllowed = false;
    Description = 'CS_PRO_018';
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Prod. Order Line";
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

                    field(ProductiveStatusFilter; ProductiveStatusFilterCaption)
                    {
                        Caption = 'Prod. status';

                        trigger OnValidate()
                        begin
                            ProductiveStatusFilter := ProductiveStatusFilterCaption;
                            ApplyFilters();
                            CurrPage.Update(false);
                        end;

                        trigger OnAssistEdit()
                        var
                            Temp_lEnumSelectionBuffer: Record "APsEnum Selection Buffer" temporary;
                        begin
                            Clear(Temp_lEnumSelectionBuffer);
                            Temp_lEnumSelectionBuffer.DeleteAll();
                            Temp_lEnumSelectionBuffer.RunAssistEdit(Database::"Prod. Order Line", Rec.FieldNo("ecProductive Status"), ProductiveStatusFilter);
                            ProductiveStatusFilter := Temp_lEnumSelectionBuffer.GetSelectedAsPipeSeparatedValueNames();
                            ProductiveStatusFilterCaption := Temp_lEnumSelectionBuffer.GetSelectedAsPipeSeparatedCaptions();

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
                            if lItemList.RunModal() = Action::LookupOK then begin
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
                field("Scheduling Sequence"; Rec."ecScheduling Sequence")
                {
                    BlankZero = true;
                    Editable = EnableScheduling;
                    Style = Strong;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    Visible = false;
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
                field("ecOutput Lot No."; Rec."ecOutput Lot No.")
                {
                    Editable = false;
                    StyleExpr = LotNoStyle;

                    trigger OnDrillDown()
                    var
                        lTrackingFunctions: Codeunit "ecTracking Functions";
                    begin
                        if (Rec."ecOutput Lot No." <> '') then begin
                            lTrackingFunctions.ShowLotNoInfoCard(Rec."Item No.", Rec."Variant Code", Rec."ecOutput Lot No.");
                        end;
                    end;
                }
                field("ecOutput Lot Exp. Date"; Rec."ecOutput Lot Exp. Date")
                {
                    Editable = false;
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
                    Description = 'CS_QMS_011';
                    DrillDown = false;
                    Editable = false;
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
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    Editable = false;
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
                    Editable = false;
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
                begin
                    lProductionOrder.Get(lProductionOrder.Status::Released, Rec."Prod. Order No.");
                    lProductionOrder.SetRecFilter();
                    lReleasedProductionOrder.SetTableView(lProductionOrder);
                    lReleasedProductionOrder.RunModal();
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
            action(AssignLotNo)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Assign Lot No.';
                Image = NewLotProperties;

                trigger OnAction()
                var
                    lTrackingFunctions: Codeunit "ecTracking Functions";
                begin
                    if lTrackingFunctions.CreateAndUpdLotNoForProdOrderLine(Rec, false) then begin
                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end;
                end;
            }
            action(LotNoInfoCard)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Lot No. Information Card';
                Image = LotInfo;

                trigger OnAction()
                var
                    lTrackingFunctions: Codeunit "ecTracking Functions";
                begin
                    lTrackingFunctions.ShowAndUpdateProdOrdLineLotNoInfoCard(Rec);
                    CurrPage.Update(true);
                end;
            }
            action(UpdateProductiveStatus)
            {
                Caption = 'Update productive status';
                Image = Status;

                trigger OnAction()
                var
                    lProductionFunctions: Codeunit "ecProduction Functions";
                begin
                    lProductionFunctions.UpdateProdOrderLineProductiveStatus(Rec);
                    Rec.Modify(true);
                    CurrPage.Update(false);
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
            action(PickingWorksheet)
            {
                Caption = 'Suggest Components Picking';
                Image = PickWorksheet;

                trigger OnAction()
                var
                    lawpProductionFunctions: Codeunit "AltAWPProduction Functions";
                begin
                    lawpProductionFunctions.OpenProdOrderLinePickingWorksheet(Rec, Enum::"AltAWPProd. Pick Wksh Activity"::Pick);
                end;
            }
            action(PutAwayWorksheet)
            {
                Caption = 'Suggest Components Put-Away';
                Image = PickWorksheet;

                trigger OnAction()
                var
                    lawpProductionFunctions: Codeunit "AltAWPProduction Functions";
                begin
                    lawpProductionFunctions.OpenProdOrderLinePickingWorksheet(Rec, Enum::"AltAWPProd. Pick Wksh Activity"::"Put-Away");
                end;
            }
            action(ShowPicks)
            {
                Caption = 'Show picking activities';
                Image = PickLines;

                trigger OnAction()
                var
                    lawpProductionFunctions: Codeunit "AltAWPProduction Functions";
                begin
                    lawpProductionFunctions.ShowProdOrderLinePicks(Rec);
                end;

            }
            action(ShowPutAways)
            {
                Caption = 'Show put-away activities';
                Image = PutawayLines;

                trigger OnAction()
                var
                    lawpProductionFunctions: Codeunit "AltAWPProduction Functions";
                begin
                    lawpProductionFunctions.ShowProdOrderLinePutAways(Rec);
                end;
            }
            group(ComponentAvailability)
            {
                action(ShowAvailabilityGroupByComp)
                {
                    Caption = 'Availability components analysis';
                    Image = Components;

                    trigger OnAction()
                    var
                        Temp_lProdOrderLine: Record "Prod. Order Line" temporary;
                        lProdOrderLine: Record "Prod. Order Line";
                        lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
                    begin
                        CurrPage.SetSelectionFilter(lProdOrderLine);
                        if not lProdOrderLine.IsEmpty then begin
                            lComponentAvailabilityMgt.GetMainProdOrdLinesFromSelected(lProdOrderLine, Temp_lProdOrderLine);
                            lComponentAvailabilityMgt.OpenAvailabBuffGroupedByCompCodeReleased(Temp_lProdOrderLine);
                        end;
                        CurrPage.Update(false);
                    end;
                }
            }
            group(Print)
            {
                Caption = 'Print';
                Image = Print;

                action(PrintProdNoteShort)
                {
                    Caption = 'Print production note';
                    Image = Print;

                    trigger OnAction()
                    var
                        lProdOrderLine: Record "Prod. Order Line";
                        lProductionNoteShort: Report "ecProduction Note Short";
                    begin
                        Clear(lProductionNoteShort);
                        Clear(lProdOrderLine);
                        lProdOrderLine.Get(Rec.Status, Rec."Prod. Order No.", Rec."Line No.");
                        lProdOrderLine.SetRecFilter();
                        lProductionNoteShort.SetTableView(lProdOrderLine);
                        lProductionNoteShort.RunModal();
                    end;
                }
                action(PrintPalletBoxLabel)
                {
                    Caption = 'Print Pallet/Box Label';
                    Image = Price;

                    trigger OnAction()
                    var
                        lecLogistcFunctions: Codeunit "ecLogistc Functions";
                    begin
                        lecLogistcFunctions.PrintInventoryLabelsByProductionOrderLine(Rec, true);
                    end;
                }
                action(PrintProdProgram)
                {
                    Caption = 'Prod. program';
                    Image = Workdays;

                    trigger OnAction()
                    var
                        lProdOrderLine: Record "Prod. Order Line";
                        lProductionProgram: Report "ecProduction Program";
                    begin
                        Clear(lProdOrderLine);
                        lProdOrderLine.CopyFilters(Rec);

                        Clear(lProductionProgram);
                        lProductionProgram.SetTableView(lProdOrderLine);
                        lProductionProgram.RunModal();
                    end;
                }
            }
            action(ProductionJournal)
            {
                Caption = 'Production Journal';
                Image = Journal;

                trigger OnAction()
                begin
                    ShowProductionJournal();
                end;
            }
            group(Scheduling)
            {
                Caption = 'Scheduling';
                Visible = UserAllowedToSchedule;

                action(CalculateSequence)
                {
                    Caption = 'Propose sequence';
                    Enabled = UserAllowedToSchedule;
                    Image = CalculatePlan;

                    trigger OnAction()
                    var
                        lProdOrderLine: Record "Prod. Order Line";
                        lProductionFunctions: Codeunit "ecProduction Functions";
                    begin
                        lProdOrderLine.Copy(Rec);
                        if lProductionFunctions.CalculatePlanningSequence(lProdOrderLine) then begin
                            EnableScheduling := true;

                            CurrPage.Update(false);
                        end;
                    end;
                }
                action(ApplySequence)
                {
                    Caption = 'Apply sequence';
                    Enabled = EnableScheduling and UserAllowedToSchedule;
                    Image = ApplyTemplate;

                    trigger OnAction()
                    var
                        lProdOrderLine: Record "Prod. Order Line";
                        lProductionFunctions: Codeunit "ecProduction Functions";
                    begin
                        lProdOrderLine.Copy(Rec);
                        if lProductionFunctions.ApplyProdOrderLineSequence(lProdOrderLine) then begin
                            EnableScheduling := false;

                            Rec.SetCurrentKey(Status, "Starting Date-Time");
                            if Rec.FindFirst() then;
                            CurrPage.Update(false);
                        end;
                    end;
                }
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

                actionref(AssignLotNoPromoted; AssignLotNo) { }
                actionref(LotNoInfoCardPromoted; LotNoInfoCard) { }
                actionref(UpdateProductiveStatusPromoted; UpdateProductiveStatus) { }
                actionref(UpdateRoutingNoPromoted; UpdateRoutingNo) { }
                actionref(ShowAvailabilityGroupByCompPromoted; ShowAvailabilityGroupByComp) { }

                group(PickingActivities)
                {
                    Caption = 'Picking Activities';
                    Image = InventoryPick;

                    actionref(PickingWorksheetPromoted; PickingWorksheet) { }
                    actionref(PutAwayWorksheetPromoted; PutAwayWorksheet) { }
                    actionref(ShowPicksPromoted; ShowPicks) { }
                    actionref(ShowPutAwaysPromoted; ShowPutAways) { }
                }

                actionref(ProductionJournalPromoted; ProductionJournal) { }
            }
            group(SchedulingPromoted)
            {
                Caption = 'Scheduling';

                actionref(CalculateSequencePromoted; CalculateSequence) { }
                actionref(ApplySequencePromoted; ApplySequence) { }
            }
            group(PrintPromoted)
            {
                Caption = 'Print';

                actionref(PrintProdNoteShortPromoted; PrintProdNoteShort) { }
                actionref(PrintPalletBoxLabelPromoted; PrintPalletBoxLabel) { }
                actionref(PrintProdProgramPromoted; PrintProdProgram) { }
            }
        }
    }

    var
        FilmFilter: Text;
        BandFilter: Text;
        ItemFilter: Text;
        LotNoStyle: Text;
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
        ProductiveStatusFilter: Text;
        ProductiveStatusFilterCaption: Text;
        EnableScheduling: Boolean;
        UserAllowedToSchedule: Boolean;

    trigger OnOpenPage()
    begin
        ClearSchedulingSequence(false);

        Clear(Rec);
        Rec.SetCurrentKey(Status, "Starting Date-Time");
        Rec.FilterGroup(2);
        Rec.SetRange(Status, Rec.Status::Released);
        Rec.FilterGroup(0);
        InitPage();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        ClearSchedulingSequence(true);
    end;

    trigger OnAfterGetRecord()
    begin
        QuantityStyle := SetQuantityStyle();
        ProdOrderNoStyle := SetProdOrderNoStyle();
        ProductiveStatusStyle := SetProductiveStatusStyle();
        LotNoStyle := SetLotNoStyle();
    end;

    local procedure InitPage()
    var
        lUserSetup: Record "User Setup";
    begin
        if not lUserSetup.Get(UserId) then Clear(lUserSetup);
        UserAllowedToSchedule := lUserSetup."ecEnable Prod. Order Sched.";

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
        ProductiveStatusFilter := '';
        EnableScheduling := false;

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
        Rec.SetRange("ecProductive Status");
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

        Rec.SetFilter("ecProductive Status", ProductiveStatusFilter);

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

    local procedure ShowProductionJournal()
    var
        lProdOrder: Record "Production Order";
        lProductionJrnlMgt: Codeunit "Production Journal Mgt";
    begin
        CurrPage.SaveRecord();

        lProdOrder.Get(Rec.Status, Rec."Prod. Order No.");

        Clear(lProductionJrnlMgt);
        lProductionJrnlMgt.Handling(lProdOrder, Rec."Line No.");
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

    local procedure SetQuantityStyle(): Text
    begin
        if (Rec."Finished Quantity" = 0) then exit('Strong');
        if (Rec."Finished Quantity" <> 0) and (Rec."Remaining Quantity" <> 0) then exit('StrongAccent');
        if (Rec."Remaining Quantity" = 0) then exit('Favorable');
    end;

    local procedure SetProdOrderNoStyle(): Text
    begin
        if (Rec."Remaining Quantity" <> 0) and (Rec."Starting Date" < Today) then exit('StrongAccent');
        if (Rec."Remaining Quantity" <> 0) and (Rec."Starting Date" < Today) and (Rec."Ending Date" < Today) then exit('Unfavorable');
        if (Rec."Remaining Quantity" = 0) then exit('Favorable');

        exit('Strong');
    end;

    local procedure SetLotNoStyle() rStyle: Text
    var
        lLotNoInformation: Record "Lot No. Information";
    begin
        rStyle := 'Strong';
        if (Rec."ecOutput Lot No." <> '') then begin
            if lLotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."ecOutput Lot No.") then begin
                if (lLotNoInformation."ecLot No. Information Status" <> lLotNoInformation."ecLot No. Information Status"::Released) then begin
                    rStyle := 'Unfavorable';
                end;
            end else begin
                rStyle := 'Ambiguous';
            end;
        end;

        exit(rStyle)
    end;

    local procedure ClearSchedulingSequence(pWithConfirm: Boolean)
    var
        lClearSchedulingErr: Label 'Warning, this operation will clear the "%1" field on all records, do you want to continue?';
        lOperationCanceled: Label 'Operation canceled';
    begin
        Clear(Rec);
        Rec.SetRange(Status, Rec.Status::Released);
        Rec.SetFilter("ecScheduling Sequence", '<>%1', 0);
        Rec.SetFilter("ecScheduling User", UserId);
        if not Rec.IsEmpty then begin
            if pWithConfirm then begin
                if not Confirm(StrSubstNo(lClearSchedulingErr, Rec.FieldCaption("ecScheduling Sequence"))) then Error(lOperationCanceled);
            end;
            Rec.ModifyAll("ecScheduling Sequence", 0, false);
        end;
        Rec.SetRange("ecScheduling Sequence");
        Rec.SetRange("ecScheduling User");
    end;
}
