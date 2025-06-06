namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Inventory.Tracking;
using Microsoft.Inventory.Tracking;
using Microsoft.Manufacturing.Document;

page 50061 "ecLinked Prod.Ord. Line Lookup"
{
    ApplicationArea = All;
    Caption = 'Linked prod. order lines';
    DeleteAllowed = false;
    Description = 'CS_PRO_018';
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Prod. Order Line";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Status; Rec.Status)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    Editable = false;
                    StyleExpr = ProdOrderNoStyle;
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("ecProductive Status"; Rec."ecProductive Status")
                {
                    Editable = false;
                    StyleExpr = ProductiveStatusStyle;
                }
                field("ecOutput Lot No."; Rec."ecOutput Lot No.")
                {
                    Editable = false;
                    StyleExpr = LotNoStyle;

                    trigger OnDrillDown()
                    var
                        lTrackingFunctions: Codeunit "ecTracking Functions";
                    begin
                        if (Rec."ecOutput Lot No." <> '') then begin
                            lTrackingFunctions.ShowLotNoInfoCard(Rec."Item No.", Rec."Variant Code", Rec."ecOutput Lot No.");
                        end;
                    end;
                }
                field("ecOutput Lot Exp. Date"; Rec."ecOutput Lot Exp. Date")
                {
                }
                field(StartingDateTime2; Rec."Starting Date-Time")
                {
                }
                field("Routing No."; Rec."Routing No.")
                {
                }
                field("ecWork Center No."; Rec."ecWork Center No.")
                {
                }
                field("ecParent Routing No."; Rec."ecParent Routing No.")
                {
                }
                field("ecParent Work Center No."; Rec."ecParent Work Center No.")
                {
                }
                field(ecBand; Rec.ecBand)
                {
                }
                field("ecFilm Packaging Code"; Rec."ecFilm Packaging Code")
                {
                }
                field("ecCartons Packaging Code"; Rec."ecCartons Packaging Code")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                    Style = Strong;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Bin Code"; Rec."Bin Code")
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                    StyleExpr = QuantityStyle;
                }
                field("Finished Quantity"; Rec."Finished Quantity")
                {
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                }
                field("Starting Date-Time"; Rec."Starting Date-Time")
                {
                }
                field("Ending Date-Time"; Rec."Ending Date-Time")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    Visible = false;
                }
                field("ecPlanning Notes"; Rec."ecPlanning Notes")
                {
                }
                field("ecProduction Notes"; Rec."ecProduction Notes")
                {
                }
                field("ecSend-Ahead Quantity"; Rec."ecSend-Ahead Quantity")
                {
                }
            }
        }
    }

    var
        LotNoStyle: Text;
        QuantityStyle: Text;
        ProdOrderNoStyle: Text;
        ProductiveStatusStyle: Text;


    trigger OnAfterGetRecord()
    begin
        QuantityStyle := SetQuantityStyle();
        ProdOrderNoStyle := SetProdOrderNoStyle();
        ProductiveStatusStyle := SetProductiveStatusStyle();
        LotNoStyle := SetLotNoStyle();
    end;

    local procedure SetProductiveStatusStyle(): Text
    begin
        case Rec."ecProductive Status" of
            Rec."ecProductive Status"::Activated:
                exit('Favorable');
            Rec."ecProductive Status"::Released:
                exit('Strong');
            Rec."ecProductive Status"::Scheduled:
                exit('StrongAccent');
            Rec."ecProductive Status"::Suspended:
                exit('Unfavorable');
            Rec."ecProductive Status"::Completed:
                exit('Ambiguous');
        end;
    end;

    local procedure SetQuantityStyle(): Text
    begin
        if (Rec."Finished Quantity" = 0) then exit('Strong');
        if (Rec."Finished Quantity" <> 0) and (Rec."Remaining Quantity" <> 0) then exit('StrongAccent');
        if (Rec."Remaining Quantity" = 0) then exit('Favorable');
    end;

    local procedure SetProdOrderNoStyle(): Text
    begin
        if (Rec."Remaining Quantity" <> 0) and (Rec."Starting Date" < Today) then exit('StrongAccent');
        if (Rec."Remaining Quantity" <> 0) and (Rec."Starting Date" < Today) and (Rec."Ending Date" < Today) then exit('Unfavorable');
        if (Rec."Remaining Quantity" = 0) then exit('Favorable');

        exit('Strong');
    end;

    local procedure SetLotNoStyle() rStyle: Text
    var
        lLotNoInformation: Record "Lot No. Information";
    begin
        rStyle := 'Strong';
        if (Rec."ecOutput Lot No." <> '') then begin
            if lLotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."ecOutput Lot No.") then begin
                if (lLotNoInformation."ecLot No. Information Status" <> lLotNoInformation."ecLot No. Information Status"::Released) then begin
                    rStyle := 'Unfavorable';
                end;
            end else begin
                rStyle := 'Ambiguous';
            end;
        end;

        exit(rStyle)
    end;
}
