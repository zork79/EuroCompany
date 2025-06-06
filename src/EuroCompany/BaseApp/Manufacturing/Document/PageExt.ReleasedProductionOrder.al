namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Manufacturing.Document;
using EuroCompany.BaseApp.Inventory.Ledger;

pageextension 80043 "Released Production Order" extends "Released Production Order"
{
    layout
    {
        addlast(content)
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom Attributes';

                field("ecProduction Process Type"; Rec."ecProduction Process Type")
                {
                    ApplicationArea = All;
                    Description = 'CS_QMS_011';
                    DrillDown = false;
                    Editable = false;
                }

                group(ecRestrictions)
                {
                    ShowCaption = false;

                    field("ecIgnore Prod. Restrictions"; Rec."ecIgnore Prod. Restrictions")
                    {
                        ApplicationArea = All;
                        Description = 'CS_PRO_011';
                    }
                }
            }
        }
    }


    actions
    {
        addlast(processing)
        {
            group(ecCustomFeaturesActGrp)
            {
                Caption = 'Custom Features';

                action(ecUpdateProdOrderRoutingNo)
                {
                    ApplicationArea = All;
                    Caption = 'Update Routing No.';
                    Description = 'GAP_PRO_003';
                    Image = RoutingVersions;

                    trigger OnAction()
                    var
                        lProductionFunctions: Codeunit "ecProduction Functions";
                    begin
                        //GAP_PRO_003-s
                        lProductionFunctions.UpdateRoutingOnProdOrder(Rec);
                        //GAP_PRO_003-e
                    end;
                }
                action(ecUpdateProdOrderLinesAct)
                {
                    ApplicationArea = All;
                    Caption = 'Update lines';
                    Description = 'CS_PRO_044';
                    Image = CalculatePlan;

                    trigger OnAction()
                    var
                        lProductionFunctions: Codeunit "ecProduction Functions";
                    begin
                        lProductionFunctions.UpdateProductionOrderLines(Rec, true);
                    end;
                }
                action(ecMassBalanceEntry)
                {
                    ApplicationArea = All;
                    Caption = 'Mass balance entry';
                    Image = Entries;

                    trigger OnAction()
                    var
                        MassBalanceEntry: Record "ecMass Balances Entry";
                        MassBalanceEntries: Page "ecMass Balances Entry";
                    begin
                        MassBalanceEntry.Reset();
                        MassBalanceEntry.SetRange("Document No.", Rec."No.");
                        if MassBalanceEntry.FindSet() then begin
                            MassBalanceEntries.SetTableView(MassBalanceEntry);
                            MassBalanceEntries.Run();
                        end;
                    end;
                }
            }
        }
        modify(AltAWPPrintProductionNoteShort)
        {
            Description = 'CS_PRO_038';
            Visible = false;
        }
        modify(AltAWPPrintProductionNote)
        {
            Description = 'CS_PRO_038';
            Visible = false;
        }

        addlast(Promoted)
        {
            group(ecCustomFeatures_Promoted)
            {
                Caption = 'Custom Features';

                actionref(ecUpdateProdOrderRoutingNoPromoted; ecUpdateProdOrderRoutingNo) { }
                actionref(ecUpdateProdOrderLinesAct_Promoted; ecUpdateProdOrderLinesAct) { }
                actionref(ecMassBalanceEntry_Promoted; ecMassBalanceEntry) { }
            }
        }
    }
}
