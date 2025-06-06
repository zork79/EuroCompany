namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Manufacturing.Document;

pageextension 80141 "Planned Production Order" extends "Planned Production Order"
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
