namespace EuroCompany.BaseApp.Inventory.Ledger;
using Microsoft.Inventory.Ledger;
using Microsoft.Manufacturing.Document;
using Microsoft.Sales.History;
using Microsoft.Purchases.History;

page 50053 "ecMass Balances Entry"
{
    ApplicationArea = All;
    Caption = 'Mass Balances Entry';
    Editable = false;
    PageType = List;
    SourceTable = "ecMass Balances Entry";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(RPTR)
            {
                ShowCaption = false;
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Origin Item No."; Rec."Origin Item No.")
                {
                    ApplicationArea = All;
                }
                field("Origin Item Type"; Rec."Origin Item Type")
                {
                    ApplicationArea = All;
                }
                field("Origin Item Description"; Rec."Origin Item Description")
                {
                }
                field("Origin Lot No."; Rec."Origin Lot No.")
                {
                    ApplicationArea = All;
                }
                field("Tracking Entry Type"; Rec."Tracking Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Tracked Quantity"; Rec."Tracked Quantity")
                {
                    ApplicationArea = All;
                }
                field("Srap %"; Rec."Srap %")
                {
                    ApplicationArea = All;
                }
                field("Origin UoM"; Rec."Origin UoM")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                }
                field("Item Quantity"; Rec."Item Quantity")
                {
                    ApplicationArea = All;
                }
                field("Item UoM"; Rec."Item UoM")
                {
                    ApplicationArea = All;
                }
                field("Item Lot No."; Rec."Item Lot No.")
                {
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        ProdOrder: Record "Production Order";
                        SalesShipHdr: Record "Sales Shipment Header";
                        PurchRcptHdr: Record "Purch. Rcpt. Header";
                        RelProdOrder: Page "Released Production Order";
                        PostedSalesShip: Page "Posted Sales Shipment";
                        PostedPurchRec: Page "Posted Purchase Receipt";
                    begin
                        ProdOrder.Reset();
                        ProdOrder.SetRange("No.", Rec."Document No.");
                        if ProdOrder.FindFirst() then begin
                            RelProdOrder.SetTableView(ProdOrder);
                            RelProdOrder.Run();
                        end else begin
                            SalesShipHdr.Reset();
                            SalesShipHdr.SetRange("No.", Rec."Document No.");
                            if SalesShipHdr.FindFirst() then begin
                                PostedSalesShip.SetTableView(SalesShipHdr);
                                PostedSalesShip.Run();
                            end else begin
                                PurchRcptHdr.Reset();
                                PurchRcptHdr.SetRange("No.", Rec."Document No.");
                                if PurchRcptHdr.FindFirst() then begin
                                    PostedPurchRec.SetTableView(PurchRcptHdr);
                                    PostedPurchRec.Run();
                                end;
                            end;
                        end;
                    end;
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        ProdOrderLine: Record "Prod. Order Line";
                        SalesShipLine: Record "Sales Shipment Line";
                        PurchRcptLine: Record "Purch. Rcpt. Line";
                        RelProdOrderLines: Page "Released Prod. Order Lines";
                        PostedSalesShipLines: Page "Posted Sales Shipment Lines";
                        PostedPurchRcptLines: Page "Posted Purchase Receipt Lines";
                    begin
                        ProdOrderLine.Reset();
                        ProdOrderLine.SetRange("Prod. Order No.", Rec."Document No.");
                        ProdOrderLine.SetRange("Line No.", Rec."Document Line No.");
                        if ProdOrderLine.FindFirst() then begin
                            RelProdOrderLines.SetTableView(ProdOrderLine);
                            RelProdOrderLines.Run();
                        end else begin
                            SalesShipLine.Reset();
                            SalesShipLine.SetRange("Document No.", Rec."Document No.");
                            SalesShipLine.SetRange("Line No.", Rec."Document Line No.");
                            if SalesShipLine.FindFirst() then begin
                                PostedSalesShipLines.SetTableView(SalesShipLine);
                                PostedSalesShipLines.Run();
                            end else begin
                                PurchRcptLine.Reset();
                                PurchRcptLine.SetRange("Document No.", Rec."Document No.");
                                PurchRcptLine.SetRange("Line No.", Rec."Document Line No.");
                                if PurchRcptLine.FindFirst() then begin
                                    PostedPurchRcptLines.SetTableView(PurchRcptLine);
                                    PostedPurchRcptLines.Run();
                                end;
                            end;
                        end;
                    end;
                }
                field("Prod. Order Component Line No."; Rec."Prod. Order Component Line No.")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        ProdOrderComp: Record "Prod. Order Component";
                        ProdOrderComponents: Page "Prod. Order Components";
                    begin
                        ProdOrderComp.Reset();
                        ProdOrderComp.SetRange("Prod. Order No.", Rec."Document No.");
                        ProdOrderComp.SetRange("Prod. Order Line No.", Rec."Document Line No.");
                        ProdOrderComp.SetRange("Line No.", Rec."Prod. Order Component Line No.");
                        if ProdOrderComp.FindFirst() then begin
                            ProdOrderComponents.SetTableView(ProdOrderComp);
                            ProdOrderComponents.Run();
                        end;
                    end;
                }
                field("Origin Prod. order no."; Rec."Origin prod. order no.")
                {
                    ApplicationArea = All;
                }
                field("Origin Prod. Order Line No."; Rec."Origin Prod. Order Line No.")
                {
                    ApplicationArea = All;
                }
                field("Orig. Prod. Order Comp.LineNo."; Rec."Orig. Prod. Order Comp.LineNo.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Item ledger Entry Qty."; Rec."Item ledger Entry Qty.")
                {
                    ApplicationArea = All;
                }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        ItemLedgerEntry: Record "Item Ledger Entry";
                        ItemLedgEntry: Page "Item Ledger Entries";
                    begin
                        ItemLedgerEntry.Reset();
                        ItemLedgerEntry.SetRange("Entry No.", Rec."Item Ledger Entry No.");
                        if ItemLedgerEntry.FindFirst() then begin
                            ItemLedgEntry.SetTableView(ItemLedgerEntry);
                            ItemLedgEntry.Run();
                        end;
                    end;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                // field("Source Doc. No"; Rec."Source Doc. No")
                // {
                // }//TODO
                field("Posted Document No."; Rec."Posted Document No.")
                {
                }
                field("Planning Level Code"; Rec."Planning Level Code")
                {
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(DeleteSingleRecord)
            {
                Caption = 'Delete single record';
                ApplicationArea = All;
                Image = Delete;
                Visible = false;

                trigger OnAction()
                var
                    MassBalanceEntry: Record "ecMass Balances Entry";
                    ConfirmDelete: Label 'Are you sure you want to delete the selected records?';
                begin
                    if Confirm(ConfirmDelete) then begin
                        CurrPage.SetSelectionFilter(MassBalanceEntry);
                        if MassBalanceEntry.FindSet() then
                            repeat
                                MassBalanceEntry.Delete();
                            until MassBalanceEntry.Next() = 0;
                    end;
                end;
            }
            action(DeleteAllRecords)
            {
                Caption = 'Delete all recors';
                ApplicationArea = All;
                Image = Delete;
                Visible = false;

                trigger OnAction()
                var
                    ConfirmDelete: Label 'Are you sure you want to delete all records?';
                begin
                    if Confirm(ConfirmDelete) then
                        Rec.DeleteAll();
                end;
            }
            action(AdjustOutputQuantities)
            {
                Caption = 'Adjust Output Qty.';
                ApplicationArea = All;
                Image = AdjustEntries;
                Visible = false;

                trigger OnAction()
                var
                    AdjustMassBalanceEntry: Report "ecAdjust Mass. Balance Entry";
                begin
                    AdjustMassBalanceEntry.Run();
                end;
            }
        }
        area(Promoted)
        {
            actionref(ecDelete_Promoted; "DeleteSingleRecord") { }
            actionref(ecAdjustQty_Promoted; AdjustOutputQuantities) { }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Has Split", false);
        Rec.FilterGroup(0);
    end;
}
