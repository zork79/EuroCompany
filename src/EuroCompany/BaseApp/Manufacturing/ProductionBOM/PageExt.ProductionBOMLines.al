namespace EuroCompany.BaseApp.Manufacturing.ProductionBOM;

using EuroCompany.BaseApp.Manufacturing.ProductionBOM;
using Microsoft.Manufacturing.ProductionBOM;

pageextension 80052 "Production BOM Lines" extends "Production BOM Lines"
{
    actions
    {
        addlast(processing)
        {
            group(ecCustomFeaturesActGrp)
            {
                Caption = 'Custom Features';

                action(ecAlternativeComponentsAct)
                {
                    ApplicationArea = All;
                    Caption = 'Alternative components';
                    Description = 'GAP_PRO_003';
                    Image = Components;

                    trigger OnAction()
                    var
                        lBOMAlternativeComponent: Record "ecBOM Alternative Component";
                        lBOMAlternativeComponentsPage: Page "ecBOM Alternative Components";
                    begin
                        //GAP_PRO_003-s
                        if (Rec.Type <> Rec.Type::Item) then exit;

                        Clear(lBOMAlternativeComponent);
                        lBOMAlternativeComponent.FilterGroup(2);
                        lBOMAlternativeComponent.SetRange("Production BOM No.", Rec."Production BOM No.");
                        lBOMAlternativeComponent.SetRange("Prod. BOM Version Code", Rec."Version Code");
                        lBOMAlternativeComponent.SetRange("Prod. BOM Line No.", Rec."Line No.");
                        lBOMAlternativeComponent.FilterGroup(0);

                        Clear(lBOMAlternativeComponentsPage);
                        lBOMAlternativeComponentsPage.SetTableView(lBOMAlternativeComponent);
                        lBOMAlternativeComponentsPage.RunModal();
                        //GAP_PRO_003-e
                    end;
                }
            }
        }
    }
}
