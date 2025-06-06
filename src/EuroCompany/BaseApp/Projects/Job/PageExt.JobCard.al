namespace EuroCompany.BaseApp.Projects.Job;
using Microsoft.Projects.Project.Job;
using Microsoft.Inventory.Item;

pageextension 80177 "Job Card" extends "Job Card"
{
    layout
    {
        addafter("WIP and Recognition")
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom attributes';
                field("ecProject Type Code"; Rec."ecProject Type Code")
                {
                    ApplicationArea = All;
                }
                field("ecProject Type Description"; Rec."ecProject Type Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        addlast(navigation)
        {
            group(ecCustomFeaturesActGrp)
            {
                Caption = 'Custom Features';

                action(LinkedItems)
                {
                    Caption = 'Linked items';
                    ApplicationArea = All;
                    Image = Item;
                    RunObject = page "Item List";
                    RunPageLink = "ecJob No." = field("No.");
                }
            }
        }
    }
}