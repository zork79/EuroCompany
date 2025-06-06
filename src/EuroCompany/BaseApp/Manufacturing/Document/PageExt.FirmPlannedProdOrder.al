namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Manufacturing.Document;

pageextension 80140 "Firm Planned Prod. Order" extends "Firm Planned Prod. Order"
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
                        //CS_PRO_044-s
                        lProductionFunctions.UpdateProductionOrderLines(Rec, true);
                        //CS_PRO_044-e
                    end;
                }
            }
        }
        addlast(Promoted)
        {
            group(ecCustomFeatures_Promoted)
            {
                Caption = 'Custom Features';
                actionref(ecUpdateProdOrderRoutingNoPromoted; ecUpdateProdOrderRoutingNo) { }
            }
        }
    }
}
