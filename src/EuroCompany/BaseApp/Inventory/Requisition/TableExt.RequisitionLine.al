namespace EuroCompany.BaseApp.Inventory.Requisition;

using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Requisition;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.Routing;
using Microsoft.Manufacturing.WorkCenter;
using Microsoft.Purchases.Vendor;

tableextension 80099 "Requisition Line" extends "Requisition Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                UpdatePurchaserCode();
            end;
        }
        modify("Vendor No.")
        {
            trigger OnAfterValidate()
            begin
                UpdatePurchaserCode();
            end;
        }
        field(50000; ecBand; Code[20])
        {
            CalcFormula = lookup(Item.ecBand where("No." = field("No.")));
            Caption = 'Band';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = ecBand.Code;
        }
        field(50005; "ecItem Type"; Enum "ecItem Type")
        {
            CalcFormula = lookup(Item."ecItem Type" where("No." = field("No.")));
            Caption = 'Item type';
            Description = 'CS_PRO_043';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "ecWork Center No."; Code[20])
        {
            Caption = 'Work center no.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_039';
            Editable = false;
            TableRelation = "Work Center"."No.";
        }
        field(50015; "ecReordering Policy"; Enum "Reordering Policy")
        {
            Caption = 'Reordering policy';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_039';
            Editable = false;
        }
    }

    local procedure UpdatePurchaserCode()
    var
        lItem: Record Item;
        lVendor: Record Vendor;
    begin
        if (Rec.Type = Rec.Type::Item) then begin
            if ("No." <> '') and lItem.Get("No.") and (lItem."ecPurchaser Code" <> '') then begin
                Rec.Validate("Purchaser Code", lItem."ecPurchaser Code");
            end else begin
                if ("Vendor No." <> '') and lVendor.Get("Vendor No.") and (lVendor."Purchaser Code" <> '') then begin
                    Rec.Validate("Purchaser Code", lVendor."Purchaser Code");
                end;
            end;
        end;
    end;

    internal procedure UpdateWorkCenterNo(): Boolean
    var
        lWorkCenter: Record "Work Center";
        lMachineCenter: Record "Machine Center";
        lPlanningRoutingLine: Record "Planning Routing Line";
    begin
        Clear(lPlanningRoutingLine);
        lPlanningRoutingLine.SetRange("Worksheet Template Name", Rec."Worksheet Template Name");
        lPlanningRoutingLine.SetRange("Worksheet Batch Name", Rec."Journal Batch Name");
        lPlanningRoutingLine.SetRange("Worksheet Line No.", Rec."Line No.");
#pragma warning disable AA0210
        lPlanningRoutingLine.SetFilter("Routing Link Code", '<>%1', '');
#pragma warning restore AA0210
        if lPlanningRoutingLine.IsEmpty then begin
            if (Rec."Work Center No." <> '') then begin
                Rec."ecWork Center No." := '';
                exit(true);
            end;

            exit(false);
        end;

        lPlanningRoutingLine.FindLast();
        if (lPlanningRoutingLine.Type = lPlanningRoutingLine.Type::"Machine Center") then begin
            if lMachineCenter.Get(lPlanningRoutingLine."No.") then begin
                if not lWorkCenter.Get(lMachineCenter."Work Center No.") then Clear(lWorkCenter);
            end;
        end else begin
            if not lWorkCenter.Get(lMachineCenter."Work Center No.") then Clear(lWorkCenter);
        end;

        if (Rec."Work Center No." <> lWorkCenter."No.") then begin
            Rec."ecWork Center No." := lWorkCenter."No.";
            exit(true);
        end;

        exit(false);
    end;

    internal procedure UpdateRequisitionLine()
    var
        lItem: Record Item;
        lStockkeepingUnit: Record "Stockkeeping Unit";
    begin
        UpdateWorkCenterNo();

        if lItem.Get(Rec."No.") then begin
            lStockkeepingUnit := lItem.GetSKU(Rec."Location Code", Rec."Variant Code");
            if (lStockkeepingUnit."Reordering Policy" <> lStockkeepingUnit."Reordering Policy"::" ") then begin
                Rec."ecReordering Policy" := lStockkeepingUnit."Reordering Policy";
            end else begin
                Rec."ecReordering Policy" := lItem."Reordering Policy";
            end;
        end;
    end;
}
