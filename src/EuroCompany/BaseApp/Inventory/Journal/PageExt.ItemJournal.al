namespace EuroCompany.BaseApp.Inventory.Journal;

using EuroCompany.BaseApp.Inventory.Tracking;
using Microsoft.Inventory.Journal;
pageextension 80102 "Item Journal" extends "Item Journal"
{
    layout
    {
        addlast(Control1)
        {
            //#229
            field("ecCausal Pallet Entry"; Rec."ecCausal Pallet Entry")
            {
                ApplicationArea = All;
            }
            field("ecCHEP Gtin"; Rec."ecCHEP Gtin")
            {
                ApplicationArea = All;
            }
            field("ecMember's CPR Code"; Rec."ecMember's CPR Code")
            {
                ApplicationArea = All;
            }
            field("ecSource Doc. No."; Rec."ecSource Doc. No.")
            {
                ApplicationArea = All;
            }
            field("ecSource Description"; Rec."ecSource Description")
            {
                ApplicationArea = All;
            }
            //#229
        }
    }
    actions
    {
        addbefore(AltAWPAssignPalletNo)
        {
            action(ecAssignLotNo)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Assign Lot No.';
                Description = 'CS_PRO_008';
                Image = NewLotProperties;

                trigger OnAction()
                var
                    lTrackingFunctions: Codeunit "ecTracking Functions";
                begin
                    //CS_PRO_008-s
                    if lTrackingFunctions.CreateAndUpdLotNoForItemJnlLine(Rec, false) then CurrPage.Update(true);
                    //CS_PRO_008-e
                end;
            }

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
                    lTrackingFunctions.ShowAndUpdateItemJnlLineLotNoInfoCard(Rec);
                    CurrPage.Update(true);
                    //CS_PRO_008-e
                end;
            }
        }

        addbefore(AltAWPAssignPalletNoRef)
        {
            actionref(ecAssignLotNo_Promoted; ecAssignLotNo) { }
            actionref(ecLotNoInfoCard_Promoted; ecLotNoInfoCard) { }
        }
    }
}
