namespace EuroCompany.BaseApp.Sales.Document;
using EuroCompany.BaseApp.Setup;
using Microsoft.Sales.Document;

pageextension 80006 "Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        modify("AltAWPParcel Units")
        {
            Caption = 'No. of logistic units';
            Description = 'CS_LOG_001';
        }
        modify("AltAWPManual Parcels")
        {
            Caption = 'Manual logistic units';
            Description = 'CS_LOG_001';
        }
        modify("AltAWPPosted Shipping Group")
        {
            Description = 'EC365';
            Editable = ShippingGroupCostsEnable;
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

        addlast(General)
        {
            group(ecGeneral_Custom)
            {
                Caption = 'Custom Attributes';

                field("ecProduct Segment No."; Rec."ecProduct Segment No.")
                {
                    ApplicationArea = All;
                    Description = 'CS_VEN_032';
                }
                field("ecProduct Segment Description"; Rec."ecProduct Segment Description")
                {
                    ApplicationArea = All;
                    Description = 'CS_VEN_032';
                    DrillDown = false;
                    Importance = Additional;
                }
                field("ecSales Manager Code"; Rec."ecSales Manager Code")
                {
                    ApplicationArea = All;
                    Description = 'CS_VEN_031';
                }
                field("ecSales Manager Name"; Rec."ecSales Manager Name")
                {
                    ApplicationArea = All;
                    Description = 'CS_VEN_031';
                    DrillDown = false;
                    Importance = Additional;
                }
            }
        }
        addafter("Document Date")
        {
            field("ecRef. Date For Calc. Due Date"; Rec."ecRef. Date For Calc. Due Date")
            {
                ApplicationArea = All;
                ShowMandatory = true;
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
