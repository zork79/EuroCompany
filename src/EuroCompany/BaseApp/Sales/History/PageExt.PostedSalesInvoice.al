namespace EuroCompany.BaseApp.Sales.History;

using Microsoft.Sales.History;

pageextension 80098 "Posted Sales Invoice" extends "Posted Sales Invoice"
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
        addlast(content)
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom Attributes';

                field("ecProduct Segment No."; Rec."ecProduct Segment No.")
                {
                    ApplicationArea = All;
                    Description = 'CS_VEN_032';
                    Editable = false;
                }
                field("ecProduct Segment Description"; Rec."ecProduct Segment Description")
                {
                    ApplicationArea = All;
                    Description = 'CS_VEN_032';
                    DrillDown = false;
                    Editable = false;
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
}
