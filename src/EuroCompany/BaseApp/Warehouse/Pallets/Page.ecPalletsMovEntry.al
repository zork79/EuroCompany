namespace EuroCompany.BaseApp.Warehouse.Pallets;
using Microsoft.Inventory.Ledger;

page 50073 "ecPallets Mov. Entry"
{
    Caption = 'Pallets Mov. Entry';
    ApplicationArea = All;
    DataCaptionFields = "Item No.";
    Editable = false;
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableView = sorting("Entry No.")
                      order(descending);
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(RPTR)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("ecUnit Logistcs Code"; Rec."ecUnit Logistcs Code")
                {
                    ApplicationArea = All;
                }
                field("ecPallet Grouping Code"; Rec."ecPallet Grouping Code")
                {
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                }
                field("ecSource Description"; Rec."ecSource Description")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("ecSource Doc. No."; Rec."ecSource Doc. No.")
                {
                    ApplicationArea = All;
                }
                field("ecCausal Pallet Entry"; Rec."ecCausal Pallet Entry")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("ecMember's CPR Code"; Rec."ecMember's CPR Code")
                {
                    ApplicationArea = All;
                }
                field("ecCHEP Gtin"; Rec."ecCHEP Gtin")
                {
                    ApplicationArea = All;
                }
                field("ecExported For CPR"; Rec."ecExported For CPR")
                {
                    ApplicationArea = All;
                }
                field("ecEnable Inventory Register"; Rec."ecEnable Inventory Register")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(ecDisableExportedToCPR)
            {
                Caption = 'Disable exported to CPR';
                ApplicationArea = All;
                Image = DisableBreakpoint;

                trigger OnAction()
                var
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    ConfirmDisableMsg: Label 'Are you sure you want to disable the "Sent to CPR" field for the selected records?';
                begin
                    if Confirm(ConfirmDisableMsg) then begin
                        CurrPage.SetSelectionFilter(ItemLedgerEntry);
                        if ItemLedgerEntry.FindSet() then
                            repeat
                                ItemLedgerEntry.Validate("ecExported For CPR", false);
                                ItemLedgerEntry.Modify();
                            until ItemLedgerEntry.Next() = 0;
                    end;
                end;
            }
        }
        area(Promoted)
        {
            actionref(ecDisableExportedToCPR_Promoted; ecDisableExportedToCPR) { }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.CalcFields("ecEnable Inventory Register", "ecUnit Logistcs Code", "ecPallet Grouping Code", "ecMember's CPR Code");
        Rec.FilterGroup(2);
        Rec.SetRange("ecEnable Inventory Register", true);
        Rec.FilterGroup(0);
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("ecEnable Inventory Register", "ecUnit Logistcs Code", "ecPallet Grouping Code", "ecMember's CPR Code");
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalcFields("ecEnable Inventory Register", "ecUnit Logistcs Code", "ecPallet Grouping Code", "ecMember's CPR Code");
    end;
}