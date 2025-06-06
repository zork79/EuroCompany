namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Inventory;
using EuroCompany.BaseApp.Inventory.Tracking;
using EuroCompany.BaseApp.Manufacturing;
using EuroCompany.BaseApp.Manufacturing.Reports;
using Microsoft.Manufacturing.Document;

pageextension 80047 "Released Prod. Order Lines" extends "Released Prod. Order Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("ecProduction Process Type"; Rec."ecProduction Process Type")
            {
                ApplicationArea = All;
                Editable = false;
                Description = 'CS_QMS_011';
                DrillDown = false;
                Visible = false;
            }
            field("ecProductive Status"; Rec."ecProductive Status")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_039';
            }
            field("ecPrevalent Operation Type"; Rec."ecPrevalent Operation Type")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_039';
                Visible = false;
            }
            field("ecPrevalent Operation No."; Rec."ecPrevalent Operation No.")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_039';
                Visible = false;
            }
            field("ecOutput Lot No."; Rec."ecOutput Lot No.")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_035';

                trigger OnDrillDown()
                var
                    lTrackingFunctions: Codeunit "ecTracking Functions";
                begin
                    if (Rec."ecOutput Lot No." <> '') then begin
                        lTrackingFunctions.ShowLotNoInfoCard(Rec."Item No.", Rec."Variant Code", Rec."ecOutput Lot No.");
                    end;
                end;
            }
            field("ecOutput Lot Due Date"; Rec."ecOutput Lot Exp. Date")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_035';
            }
            field("ecOutput Lot Ref. Date"; Rec."ecOutput Lot Ref. Date")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_035';
                Visible = false;
            }
            field("ecSend-Ahead Quantity"; Rec."ecSend-Ahead Quantity")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_018';
                Editable = false;
                Visible = false;
            }
            field("ecPlanning Notes"; Rec."ecPlanning Notes")
            {
                ApplicationArea = All;
                Description = 'GAP_PRO_013';

                trigger OnAssistEdit()
                begin
                    Rec.EditTextField(Rec, Rec.FieldNo("ecPlanning Notes"));
                end;
            }
            field("ecProduction Notes"; Rec."ecProduction Notes")
            {
                ApplicationArea = All;
                Description = 'GAP_PRO_013';

                trigger OnAssistEdit()
                begin
                    Rec.EditTextField(Rec, Rec.FieldNo("ecPlanning Notes"));
                end;
            }
        }
        modify("Routing No.")
        {
            Editable = false;
        }
        modify("AltAWPRouting No.")
        {
            Editable = false;
        }
    }

    actions
    {
        addafter("&Line")
        {
            group(ecCustomFunctions)
            {
                Caption = 'Custom functions';

                action(ecUpdateProductiveStatus)
                {
                    ApplicationArea = All;
                    Caption = 'Update productive status';
                    Description = 'CS_PRO_039';
                    Image = Status;

                    trigger OnAction()
                    var
                        lProductionFunctions: Codeunit "ecProduction Functions";
                    begin
                        //CS_PRO_039-s            
                        lProductionFunctions.UpdateProdOrderLineProductiveStatus(Rec);
                        //CS_PRO_039-e
                    end;
                }

                action(ecAssignLotNo)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Assign Lot No.';
                    Description = 'CS_PRO_008';
                    Image = NewLotProperties;

                    trigger OnAction()
                    var
                        lTrackingFunctions: Codeunit "ecTracking Functions";
                    begin
                        //CS_PRO_008-s
                        if lTrackingFunctions.CreateAndUpdLotNoForProdOrderLine(Rec, false) then CurrPage.Update(true);
                        //CS_PRO_008-e
                    end;
                }
                action(ecLotNoInfoCard)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Lot No. Information Card';
                    Description = 'CS_PRO_008';
                    Image = LotInfo;

                    trigger OnAction()
                    var
                        lTrackingFunctions: Codeunit "ecTracking Functions";
                    begin
                        //CS_PRO_008-s
                        lTrackingFunctions.ShowAndUpdateProdOrdLineLotNoInfoCard(Rec);
                        CurrPage.Update(true);
                        //CS_PRO_008-e
                    end;
                }
                action(ecPrintProdNoteShort)
                {
                    ApplicationArea = All;
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

                group(ecPrintInventoryLabels)
                {
                    Caption = 'Inventory Labels';
                    Description = 'CS_ACQ_004';
                    Image = Price;

                    action(ecPrintPalletBoxLabel)
                    {
                        ApplicationArea = All;
                        Caption = 'Print Pallet/Box Label';
                        Description = 'CS_ACQ_004';
                        Image = Price;

                        trigger OnAction()
                        var
                            lecLogistcFunctions: Codeunit "ecLogistc Functions";
                        begin
                            //CS_ACQ_004-s
                            lecLogistcFunctions.PrintInventoryLabelsByProductionOrderLine(Rec, true);
                            //CS_ACQ_004-e
                        end;
                    }
                }
            }
        }

        modify(AltAWPPrintInventoryLabels)
        {
            Description = 'CS_ACQ_004';
            Visible = false;
        }
    }
}
