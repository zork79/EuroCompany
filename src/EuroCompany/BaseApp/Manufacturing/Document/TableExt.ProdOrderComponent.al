namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Manufacturing.Document;


tableextension 80003 "Prod. Order Component" extends "Prod. Order Component"
{
    fields
    {
        modify("Item No.")
        {
            trigger OnBeforeValidate()
            var
                lxProdOrderComponent: Record "Prod. Order Component";
                lProductionFunctions: Codeunit "ecProduction Functions";
            begin
                //GAP_PRO_003-s
                if (Rec."Item No." <> '') then begin
                    if lxProdOrderComponent.Get(Rec.Status, Rec."Prod. Order No.", Rec."Prod. Order Line No.", Rec."Line No.") and
                       (lxProdOrderComponent."Item No." <> Rec."Item No.") and (lxProdOrderComponent."Item No." <> '')
                    then begin
                        lProductionFunctions.CheckComponentNo(Rec."Item No.",
                                                              Rec."Variant Code",
                                                              Rec."AltAWPSource Prod. BOM No.",
                                                              Rec."AltAWPSource Prod. BOM Version",
                                                              Rec."AltAWPSource Prod. BOM Line",
                                                              true);
                    end;
                end;
                //GAP_PRO_003-e
            end;
        }
        modify("Variant Code")
        {
            trigger OnBeforeValidate()
            var
                lProductionFunctions: Codeunit "ecProduction Functions";
            begin
                //GAP_PRO_003-s
                if (Rec."Item No." <> '') then begin
                    lProductionFunctions.CheckComponentNo("Item No.",
                                                          "Variant Code",
                                                          "AltAWPSource Prod. BOM No.",
                                                          "AltAWPSource Prod. BOM Version",
                                                          "AltAWPSource Prod. BOM Line",
                                                          true);
                end;
                //GAP_PRO_003-e
            end;
        }
        field(50000; "ecParent Item No."; Code[20])
        {
            CalcFormula = lookup("Production Order"."Source No." where(Status = field(Status), "No." = field("Prod. Order No.")));
            Caption = 'Parent item no.';
            Description = 'CS_PRO_018';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50025; "ecProductive Status"; Enum "ecProductive Status")
        {
            CalcFormula = lookup("Prod. Order Line"."ecProductive Status" where(Status = field(Status), "Prod. Order No." = field("Prod. Order No."), "Line No." = field("Prod. Order Line No.")));
            Caption = 'Productive Status (PO Line)';
            Description = 'CS_PRO_039';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50060; "ecSource Qty. per"; Decimal)
        {
            Caption = 'Source Qty. per';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'GAP_PRO_003';
            Editable = false;
        }
    }

    internal procedure ecIsComponentReadyForPick(): Boolean
    begin
        //CS_PRO_039-VI-s
        if (Status = Status::Released) and
           ("Item No." <> '') and
           ("Location Code" <> '') and
           ("Bin Code" <> '') and
           ("Remaining Quantity" > 0)
        then begin
            CalcFields("ecProductive Status");
            if ("ecProductive Status" in ["ecProductive Status"::Scheduled,
                                          "ecProductive Status"::Activated])
            then begin
                exit(true);
            end;
        end;

        exit(false);
        //CS_PRO_039-VI-e
    end;
}
