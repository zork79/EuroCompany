namespace EuroCompany.BaseApp.Warehouse.Document;

using EuroCompany.BaseApp.Setup;
using Microsoft.Foundation.UOM;
using Microsoft.Warehouse.Document;

pageextension 80007 "Warehouse Shipment" extends "Warehouse Shipment"
{
    layout
    {
        modify("AltAWPShipping Group No.")
        {
            Description = 'EC365';
            Visible = ShippingGroupCostsEnable;
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
        modify("AltAWPParcel Units")
        {
            Caption = 'Number of Pallet';
        }
        modify("AltAWPManual Parcels")
        {
            Caption = 'Manual Pallet';
        }
        modify("AltAWPInvoice Deferral Date")
        {
            Description = 'CS_AFC_014';
            Visible = true;
        }
        addlast(content)
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom Attributes';
                Editable = awpPageEditable;

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
                Importance = Promoted;
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
