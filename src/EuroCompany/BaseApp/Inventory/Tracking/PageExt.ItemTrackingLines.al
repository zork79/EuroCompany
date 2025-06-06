namespace EuroCompany.BaseApp.Inventory.Tracking;

using Microsoft.Inventory.Tracking;

pageextension 80074 "Item Tracking Lines" extends "Item Tracking Lines"
{
    actions
    {
        modify(Line_LotNoInfoCard)
        {
            Description = 'CS_PRO_011';
            Visible = false;
        }
        modify("Assign Lot No.")
        {
            Description = 'CS_PRO_011';
            Visible = false;
        }
        modify(Line_SerialNoInfoCard)
        {
            Description = 'CS_PRO_011';
            Visible = false;
        }
        modify(Reclass_SerialNoInfoCard)
        {
            Description = 'CS_PRO_011';
            Visible = false;
        }
        addafter(Line_SerialNoInfoCard)
        {
            action(Line_CreateLotNoInfoCard)
            {
                ApplicationArea = All;
                Caption = 'Lot No. Information Card';
                Description = 'CS_PRO_011';
                Image = LotInfo;

                trigger OnAction()
                begin
                    //CS_PRO_011-s
                    CreateLotNoInfoCard();
                    //CS_PRO_011-e
                end;
            }
        }

        addbefore("Assign Serial No.")
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
                    if (Rec."Lot No." = '') then begin
                        Rec.Validate("Lot No.", lTrackingFunctions.GetNewItemLotNo(Rec."Item No.", Rec."Variant Code", true, true));
                    end;
                    //CS_PRO_008-e
                end;
            }
        }

        addafter(Line_SerialNoInfoCard_Promoted)
        {
            actionref(Line_CreateLotNoInfoCard_Promoted; Line_CreateLotNoInfoCard) { }
        }
        addbefore("Assign Serial No._Promoted")
        {
            actionref(ecAssignLotNo_Promoted; ecAssignLotNo) { }
        }
    }

    local procedure CreateLotNoInfoCard()
    var
        lTrackingSpecification: Record "Tracking Specification";
        lTrackingFunctions: Codeunit "ecTracking Functions";
    begin
        //CS_PRO_011-s
        Rec.TestField("Item No.");
        Rec.TestField("Lot No.");

        Clear(lTrackingSpecification);
        lTrackingSpecification := Rec;
        lTrackingFunctions.CreateAndOpenGenericLotNoInfoCard(lTrackingSpecification);
        //CS_PRO_011-e  
    end;
}
