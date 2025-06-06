namespace EuroCompany.BaseApp.Coan;
using EuroCompany.BaseApp.Manufacturing.Capacity;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.WorkCenter;
using Microsoft.Finance.Dimension;

pageextension 80196 ecExtWkCenterCard extends "Work Center Card"
{
    layout
    {
    }

    actions
    {
        addlast(processing)
        {
            group(ecCustomFeaturesActGrp)
            {
                Caption = 'Custom Features';
                Image = AddToHome;
                ShowAs = Standard;
                Visible = true;

                action(CosAllocationSchemaProdArea)
                {
                    ApplicationArea = All;
                    Visible = true;
                    Enabled = true;
                    Caption = 'Cost Allocation Schema for Production Area';
                    Image = CostAccountingSetup;
                    //old
                    // RunObject = Page ecCostAllSchforPrdArea;
                    // RunPageLink = "Work Center No." = field("No.");
                    //old

                    trigger OnAction()
                    var
                        CostAllSchforPrdArea: Page ecCostAllSchforPrdArea;
                    begin
                        Clear(CostAllSchforPrdArea);
                        CostAllSchforPrdArea.SetWorkCenterNo(Rec."No.");
                        CostAllSchforPrdArea.Run();
                    end;
                }
            }
        }

        //Actions Promoted
        addlast(Category_Process)
        {
            actionref(ImplementPCosAllocationSchemaProdArea_Promoted; CosAllocationSchemaProdArea)
            {
            }
        }
    }
}