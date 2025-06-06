namespace EuroCompany.BaseApp.Warehouse.History;

using EuroCompany.BaseApp.Setup;
using Microsoft.Warehouse.History;

pageextension 80004 "Posted Whse. Shipment List" extends "Posted Whse. Shipment List"
{
    layout
    {
        modify("AltAWPTotal Shipping Costs")
        {
            Description = 'EC365';
            Visible = ShippingGroupCostsEnable;
        }
        modify("AltAWPShipping Group No.")
        {
            Description = 'EC365';
            Visible = ShippingGroupCostsEnable;
        }
        modify("AltAWPParcel Units")
        {
            Caption = 'No. of logistic units';
            Description = 'CS_LOG_001';
        }
        addbefore("AltAWPTotal Volume")
        {
            field("ecNo. Parcels"; Rec."ecNo. Parcels")
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
        moveafter("ecNo. Parcels"; "AltAWPParcel Units")
        movebefore("AltAWPTotal Volume"; "AltAWPNet Weight")
        moveafter("AltAWPNet Weight"; "AltAWPGross Weight")
    }

    actions
    {
        modify(AltAWPShowShippingCosts)
        {
            Description = 'EC365';
            Visible = ShippingGroupCostsEnable;
        }
    }

    var
        ShippingGroupCostsEnable: Boolean;

    trigger OnOpenPage()
    var
        lECGeneralSetup: Record "ecGeneral Setup";
    begin
        //EC365-s
        lECGeneralSetup.Get();
        ShippingGroupCostsEnable := lECGeneralSetup."Enable Shipping Group/Costs";
        //EC365-e
    end;
}
