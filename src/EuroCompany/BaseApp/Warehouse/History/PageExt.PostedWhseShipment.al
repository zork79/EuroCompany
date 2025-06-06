namespace EuroCompany.BaseApp.Warehouse.History;

using EuroCompany.BaseApp.Setup;
using Microsoft.Foundation.UOM;
using Microsoft.Warehouse.History;
using Microsoft.Inventory.Journal;
using EuroCompany.BaseApp.Warehouse.Pallets;

pageextension 80005 "Posted Whse. Shipment" extends "Posted Whse. Shipment"
{
    layout
    {
        modify("AltAWPParcel Units")
        {
            Caption = 'No. of logistic units';
            Description = 'CS_LOG_001';
        }
        modify("AltAWPManual Parcels")
        {
            Caption = 'Manual logistic units';
            Description = 'CS_LOG_001';
        }
        modify("AltAWPTotal Shipping Costs")
        {
            Description = 'EC365';
            Visible = ShippingGroupCostsEnable;
        }
        modify("AltAWPInvoiced Shipping Costs")
        {
            Description = 'EC365';
            Visible = ShippingGroupCostsEnable;
        }
        modify("AltAWPShipping Group No.")
        {
            Description = 'EC365';
            Visible = ShippingGroupCostsEnable;
        }
        modify("AltAWPInvoice Deferral Date")
        {
            Description = 'CS_AFC_014';
            Visible = true;
        }
        addfirst(AltAWP_Totals)
        {
            field("ecNo. Parcels"; Rec."ecNo. Parcels")
            {
                ApplicationArea = All;
                Description = 'CS_LOG_001';
            }
            field("ecManual Parcels"; Rec."ecManual Parcels")
            {
                ApplicationArea = All;
                Description = 'CS_LOG_001';
            }
            field("ecNo. Pallet Places"; Rec."AltAWPNo. Pallet Places")
            {
                ApplicationArea = All;
                Description = 'CS_LOG_001';
            }
            field("ecNo. Theoretical Pallets"; Rec."ecNo. Theoretical Pallets")
            {
                ApplicationArea = All;
                Description = 'CS_LOG_001';
            }
        }
        moveafter("ecManual Parcels"; "AltAWPParcel Units")
        moveafter("AltAWPParcel Units"; "AltAWPManual Parcels")
        movebefore("AltAWPNet Weight"; "AltAWPGoods Appearance")
        addbefore("Posting Date")
        {
            field(ecShipmentDate; Rec."Shipment Date")
            {
                ApplicationArea = All;
                Editable = false;
                Importance = Promoted;
            }
        }
        addafter(Shipping)
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
                            PalletsMgtEnable := true;
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
        addlast(processing)
        {
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
