namespace EuroCompany.BaseApp.Warehouse.Activity;

using EuroCompany.BaseApp.Inventory.Tracking;
using Microsoft.Warehouse.Activity;

pageextension 80134 "Whse. Pick Subform" extends "Whse. Pick Subform"
{
    actions
    {
        addafter("&Line")
        {
            group(ecCustomFeatures)
            {
                Caption = 'Custom features';

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
                        lTrackingFunctions.ShowLotNoInfoCard(Rec."Item No.", Rec."Variant Code", Rec."Lot No.");
                        //CS_PRO_008-e
                    end;
                }
            }
        }
    }
}
