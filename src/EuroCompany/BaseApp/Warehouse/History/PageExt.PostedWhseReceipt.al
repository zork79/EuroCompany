namespace EuroCompany.BaseApp.Warehouse.History;

using EuroCompany.BaseApp.Inventory;
using EuroCompany.BaseApp.Setup;
using Microsoft.Warehouse.History;
using EuroCompany.BaseApp.Warehouse.Pallets;

pageextension 80031 "Posted Whse. Receipt" extends "Posted Whse. Receipt"
{
    layout
    {
        modify(AltAWP_ShipCosts)
        {
            Description = 'EC365';
            Visible = ShippingGroupCostsEnable;
        }
        addafter(PostedWhseRcptLines)
        {
            group(PalletMgt)
            {
                Caption = 'Pallet management';

                field("ecAllow Adjmt. In Ship/Receipt"; Rec."ecAllow Adjmt. In Ship/Receipt")
                {
                    ApplicationArea = All;
                    Editable = awpChangesEnabled;

                    trigger OnValidate()
                    begin
                        if Rec."ecAllow Adjmt. In Ship/Receipt" then begin
                            PalletsMgtEnable := true;
                            CurrPage.Update(false);
                        end else begin
                            PalletsMgtEnable := false;
                            CurrPage.Update(false);
                        end;
                    end;
                }
                field("ecPallet Status Mgt."; Rec."ecPallet Status Mgt.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        modify(AltAWPShowShippingCosts)
        {
            Description = 'EC365';
            Visible = ShippingGroupCostsEnable;
        }

        modify(AltAWPPrintInventoryLabels)
        {
            Description = 'CS_ACQ_004';
            Visible = false;
        }

        addlast(processing)
        {
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
                        lecLogistcFunctions.PrintInventoryLabelsByPostedWhseRcpt(Rec."No.");
                        //CS_ACQ_004-e
                    end;
                }
            }

            //#229
            group(ecPallets)
            {
                Caption = 'Pallets management';
                Enabled = PalletsMgtEnable;

                action(ecGenerateItemJournalLines)
                {
                    Caption = 'Generate item journal lines';
                    ApplicationArea = All;
                    Image = PostBatch;
                    Enabled = PalletsMgtEnable;

                    trigger OnAction()
                    var
                        ecPalletsManagement: Codeunit "ecPallets Management";
                        ConfrimGenerationLbl: Label 'Are you sure you want to generate item journal lines for this document?';
                    begin
                        if Confirm(ConfrimGenerationLbl) then
                            ecPalletsManagement.GenerateItemJournalLines(Rec);
                    end;
                }
                action(ecOpenJnlBatch)
                {
                    Caption = 'Open journal batch';
                    ApplicationArea = All;
                    Image = View;
                    Enabled = PalletsMgtEnable;

                    trigger OnAction()
                    var
                        ecPalletsManagement: Codeunit "ecPallets Management";
                    begin
                        ecPalletsManagement.RunItemJournal(Rec."No.");
                    end;
                }
            }
            //#229
        }
        addlast(Promoted)
        {
            group(ecCustomFeatures_Promoted)
            {
                Caption = 'Custom features';
                Description = 'CS_ACQ_004';

                group(ecPrintInventoryLabels_Promoted)
                {
                    Caption = 'Inventory Labels';
                    Description = 'CS_ACQ_004';
                    Image = Price;

                    actionref(ecPrintPalletBoxLabel_Promoted; ecPrintPalletBoxLabel) { }
                }
                //#229
                group(ecPallets_Promoted)
                {
                    Caption = 'Pallets management';
                    Enabled = PalletsMgtEnable;
                    actionref(ecGenerateItemJournalLines_Promoted; ecGenerateItemJournalLines) { }
                    actionref(ecOpenJnlBatch_Promoted; ecOpenJnlBatch) { }
                }
                //#229
            }
        }
    }

    var
        ShippingGroupCostsEnable: Boolean;
        PalletsMgtEnable: Boolean;

    trigger OnOpenPage()
    var
        lECGeneralSetup: Record "ecGeneral Setup";
    begin
        //EC365-s
        lECGeneralSetup.Get();
        ShippingGroupCostsEnable := lECGeneralSetup."Enable Shipping Group/Costs";
        //EC365-e

        //#229
        PalletsMgtEnable := Rec."ecAllow Adjmt. In Ship/Receipt";
        //#229
    end;

    trigger OnAfterGetRecord()
    begin
        //#229
        PalletsMgtEnable := Rec."ecAllow Adjmt. In Ship/Receipt";
        CurrPage.Update(false);
        //#229
    end;
}
