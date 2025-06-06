namespace EuroCompany.BaseApp.Inventory.Journal;

using EuroCompany.BaseApp.Inventory.Tracking;
using Microsoft.Inventory.Journal;

pageextension 80182 "Item Reclass. Journal" extends "Item Reclass. Journal"
{
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
