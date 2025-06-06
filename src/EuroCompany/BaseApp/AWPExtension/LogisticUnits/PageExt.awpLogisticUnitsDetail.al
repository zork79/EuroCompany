namespace EuroCompany.BaseApp.AWPExtension.LogisticUnits;

using EuroCompany.BaseApp.Inventory.Tracking;
using Microsoft.Manufacturing.WorkCenter;
using Microsoft.Manufacturing.Capacity;
using Microsoft.Manufacturing.Document;
using Microsoft.Warehouse.Document;
using Microsoft.Inventory.Tracking;

pageextension 80091 "awpLogistic Units Detail" extends "AltAWPLogistic Units Detail"
{
    layout
    {
        modify("Lot No.")
        {
            StyleExpr = LotNoStyle;
        }

        addlast(Control1)
        {
            field("ecNo. Of Parcels"; Rec."ecNo. Of Parcels")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_013';
            }
            field("ecTotal Weight"; Rec."ecTotal Weight")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_013';
            }
            field("ecUnit Weight"; Rec."ecUnit Weight")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_013';
                Editable = false;
            }
        }
    }
    actions
    {
        modify(SerialNoInfoCard)
        {
            Visible = false;
        }
        modify(LotNoInfoCard)
        {
            Enabled = false;
            Visible = false;
        }
        modify(AssignLotNoAction)
        {
            Enabled = false;
            Visible = false;
        }
        modify(AssignSerialNoAction)
        {
            Enabled = false;
            Visible = false;
        }
        addfirst(Processing)
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
                    if lTrackingFunctions.CreateAndUpdLotNoForLogisticUnitsDetail(Rec, true) then begin
                        DetailsChanged := true;
                    end;
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
                begin
                    //CS_PRO_008-s
                    CurrPage.SaveRecord();
                    Rec.ShowLotNoInfoCard();
                    CurrPage.Update(false);
                    //CS_PRO_008-e
                end;
            }
        }

        addfirst(Category_Process)
        {
            actionref(ecAssignLotNoPromoted; ecAssignLotNo) { }
            actionref(ecLotNoInfoCardPromoted; ecLotNoInfoCard) { }
        }

        addfirst(Category_Category4)
        {
        }
    }

    var
        LotNoStyle: Text;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        lProdOrderLine: Record "Prod. Order Line";
        lProdOrderRoutingLine: Record "Prod. Order Routing Line";
        lWorkCenter: Record "Work Center";
        lWarehouseReceiptLine: Record "Warehouse Receipt Line";
        lWarehouseReceiptHeader: Record "Warehouse Receipt Header";
    begin
        //CS_PRO_041_BIS-s
        if (Rec."Whse. Document No." <> '') and (Rec."Whse. Document Line No." <> 0) then begin
            lWarehouseReceiptHeader.Get(Rec."Whse. Document No.");
            if lWarehouseReceiptLine.Get(Rec."Whse. Document No.", Rec."Whse. Document Line No.") then begin
                if (lWarehouseReceiptLine."AltAWPProd. Order No." <> '') and (lWarehouseReceiptLine."AltAWPProd. Order Line No." <> 0) and
                   lProdOrderLine.Get(lProdOrderLine.Status::Released, lWarehouseReceiptLine."AltAWPProd. Order No.", lWarehouseReceiptLine."AltAWPProd. Order Line No.")
                then begin
                    lProdOrderRoutingLine.SetRange(Status, lProdOrderLine.Status);
                    lProdOrderRoutingLine.SetRange("Prod. Order No.", lProdOrderLine."Prod. Order No.");
                    lProdOrderRoutingLine.SetRange("Routing Reference No.", lProdOrderLine."Routing Reference No.");
                    lProdOrderRoutingLine.SetRange("Routing No.", lProdOrderLine."Routing No.");
                    lProdOrderRoutingLine.FindLast();
                    if (lProdOrderRoutingLine.Type = lProdOrderRoutingLine.Type::"Work Center") and lWorkCenter.Get(lProdOrderRoutingLine."No.") and
                       (lWorkCenter."Subcontractor No." <> '') and (lWorkCenter."Subcontractor No." = lWarehouseReceiptHeader."AltAWPSubject No.")
                    then begin
                        Rec."Lot No." := lProdOrderLine."ecOutput Lot No.";
                        Rec."Expiration Date" := lProdOrderLine."ecOutput Lot Exp. Date";
                    end;
                end;
            end;
        end;
        //CS_PRO_041_BIS-e

        SetLotStyle();
    end;

    trigger OnAfterGetRecord()
    begin
        SetLotStyle();
    end;

    local procedure SetLotStyle()
    var
        lLotNoInformation: Record "Lot No. Information";
    begin
        LotNoStyle := 'Standard';
        if (Rec."Lot No." <> '') then begin
            if not lLotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") then begin
                LotNoStyle := 'Unfavorable';
            end else begin
                if (lLotNoInformation."ecLot No. Information Status" <> lLotNoInformation."ecLot No. Information Status"::Released) then begin
                    LotNoStyle := 'Unfavorable';
                end else begin
                    LotNoStyle := 'Favorable';
                end;
            end;
        end;
    end;
}
