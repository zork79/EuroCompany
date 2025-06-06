namespace EuroCompany.BaseApp.Warehouse.Document;

using EuroCompany.BaseApp.Setup;
using Microsoft.Warehouse.Document;

pageextension 80008 "Warehouse Shipment List" extends "Warehouse Shipment List"
{
    layout
    {
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
        addlast(Control1)
        {
            field("ecProduct Segment No."; Rec."ecProduct Segment No.")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_032';
            }
            field("ecProduct Segment Description"; Rec."ecProduct Segment Description")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_032';
            }
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
