namespace EuroCompany.BaseApp.Warehouse.Ledger;

using Microsoft.Warehouse.Ledger;

page 50060 "ecWarehouse Entries to Print"
{
    ApplicationArea = All;
    Caption = 'Warehouse Entries to Print';
    Description = 'CS_ACQ_004';
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Entry";
    SourceTableTemporary = true;
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ecSelected; Rec.ecSelected)
                {
                }
                field("ecTransaction ID"; Rec."ecTransaction ID")
                {
                }
                field("Registering Date"; Rec."Registering Date")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Bin Code"; Rec."Bin Code")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field("Serial No."; Rec."Serial No.")
                {
                }
                field("Lot No."; Rec."Lot No.")
                {
                }
                field("AltAWPPallet No."; Rec."AltAWPPallet No.")
                {
                }
                field("AltAWPBox No."; Rec."AltAWPBox No.")
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
                Image = SelectMore;

                trigger OnAction()
                begin
                    SelectDeselectLines(true);
                    CurrPage.Update(true);
                end;
            }
            action(DeselectLine)
            {
                Caption = 'Deselect line';
                Image = CancelLine;

                trigger OnAction()
                begin
                    SelectDeselectLines(false);
                    CurrPage.Update(true);
                end;
            }
            action(ConfrmLines)
            {
                Caption = 'Print selected lines';
                Image = Print;

                trigger OnAction()
                var
                    lConfirmLines: Label 'Are you sure to print selected lines?';
                begin
                    if not Confirm(lConfirmLines, false) then exit;
                    LinesConfirmed := true;
                    CurrPage.Close();
                end;
            }
        }

        area(Promoted)
        {
            actionref(SelectLinePromoted; SelectLine) { }
            actionref(DeselectLinePromoted; DeselectLine) { }
            actionref(ConfrmLinesPromoted; ConfrmLines) { }
        }
    }

    var
        LinesConfirmed: Boolean;


    trigger OnOpenPage()
    var
        lEmptyErr: Label 'Nothing to manage';
    begin
        if Rec.IsEmpty then Error(lEmptyErr);
        LinesConfirmed := false;
    end;

    internal procedure SetWhseEntriesRecords(var Temp_pWarehouseEntry: Record "Warehouse Entry" temporary)
    begin
        Rec.Copy(Temp_pWarehouseEntry, true);
    end;

    internal procedure LineConfirmed(): Boolean
    begin
        exit(LinesConfirmed);
    end;

    internal procedure SelectDeselectLines(pSelectionType: Boolean)
    var
        Temp_lWarehouseEntry: Record "Warehouse Entry" temporary;
    begin
        Temp_lWarehouseEntry.Copy(Rec, true);
        CurrPage.SetSelectionFilter(Temp_lWarehouseEntry);
        if not Temp_lWarehouseEntry.IsEmpty then begin
            Temp_lWarehouseEntry.ModifyAll(ecSelected, pSelectionType, false);
        end;
    end;
}
