namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Inventory.Tracking;
using EuroCompany.BaseApp.Manufacturing;
using EuroCompany.BaseApp.Manufacturing.Document;
using EuroCompany.BaseApp.Manufacturing.Routing;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;
using Microsoft.Manufacturing.Document;

using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.Routing;
using Microsoft.Manufacturing.WorkCenter;

tableextension 80001 "Prod. Order Line" extends "Prod. Order Line"
{
    fields
    {
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                lItem: Record Item;
            begin
                //CS_PRO_018-s
                if lItem.Get("Item No.") then begin
                    ecBand := lItem.ecBand;
                end;
                //CS_PRO_018-e
            end;
        }

        modify("Routing No.")
        {
            trigger OnAfterValidate()
            var
                lxProdOrderLine: Record "Prod. Order Line";
                lProductionFunctions: Codeunit "ecProduction Functions";
                lATSSessionDataStore: Codeunit "AltATSSession Data Store";
            begin
                //GAP_PRO_003-s
                if (Rec."Routing No." <> '') then begin
                    lProductionFunctions.CheckRoutingNo(Rec."Item No.", Rec."Routing No.", true);
                    if lxProdOrderLine.Get(Rec.Status, Rec."Prod. Order No.", Rec."Line No.") then begin
                        if (Rec."Routing No." <> lxProdOrderLine."Routing No.") then begin
                            lATSSessionDataStore.AddSessionSetting('AlternativeRouting_RecalculateProdOrder', true);
                        end;
                    end;
                end;
                //GAP_PRO_003-e
            end;
        }
        field(50000; "ecPrevalent Operation Type"; Enum "ecPrevalent Operation Type")
        {
            Caption = 'Prevalent operation type';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_039';
            Editable = false;
        }
        field(50001; "ecPrevalent Operation No."; Code[20])
        {
            Caption = 'Prevalent operation no.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_039';
            Editable = false;
            TableRelation = if ("ecPrevalent Operation Type" = const("Work Center")) "Work Center"
            else
            if ("ecPrevalent Operation Type" = const("Machine Center")) "Machine Center";
        }
        field(50003; "ecProduction Process Type"; Enum "ecProduction Process Type")
        {
            CalcFormula = lookup("Routing Header"."ecProduction Process Type" where("No." = field("Routing No.")));
            Caption = 'Production Process Type';
            Description = 'CS_QMS_011';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "ecParent Line No."; Integer)
        {
            Caption = 'Parent Line No.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_044';
        }
        field(50015; "ecScrolling Time"; Integer)
        {
            Caption = 'Scrolling Time';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_044';
        }
        field(50020; "ecSend-Ahead Quantity"; Decimal)
        {
            Caption = 'Send-Ahead Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'CS_PRO_044';
        }
        field(50025; "ecProductive Status"; Enum "ecProductive Status")
        {
            Caption = 'Productive Status';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_039';
            Editable = false;

            trigger OnValidate()
            var
                lxProdOrderLine: Record "Prod. Order Line";
                lProductionFunctions: Codeunit "ecProduction Functions";
            begin
                //CS_PRO_039-s
                if not lxProdOrderLine.Get(Rec.Status, Rec."Prod. Order No.", Rec."Line No.") then Clear(lxProdOrderLine);
                lProductionFunctions.ManageChangeOfProdStatusOnProdOrdLine(Rec, lxProdOrderLine);
                //CS_PRO_039-e
            end;
        }
        field(50027; ecBand; Code[20])
        {
            Caption = 'Band';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_018';
            Editable = false;
            TableRelation = ecBand.Code;
        }
        field(50030; "ecOutput Lot No."; Code[50])
        {
            Caption = 'Output lot No.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_039';

            trigger OnValidate()
            var
                lProdOrderLine: Record "Prod. Order Line";
                lProductionFunctions: Codeunit "ecProduction Functions";
                lTrackingFunctions: Codeunit "ecTracking Functions";
                lExistItemLedgEntry: Boolean;
                lExistCapacityLedgEntry: Boolean;

                lLotNoChangeError: Label '"%1" cannot be changed if there are production progresses!';
            begin
                //CS_PRO_008-s
                if lProdOrderLine.Get(Rec.Status, Rec."Prod. Order No.", Rec."Line No.") then begin
                    if (lProdOrderLine."ecOutput Lot No." <> '') and (Rec."ecOutput Lot No." <> lProdOrderLine."ecOutput Lot No.") then begin
                        lProductionFunctions.ExistsEntriesForProdOrderLine(lProdOrderLine, lExistItemLedgEntry, lExistCapacityLedgEntry);
                        if lExistItemLedgEntry then begin
                            Error(lLotNoChangeError, lProdOrderLine.FieldCaption("ecOutput Lot No."));
                        end;
                    end;
                end;

                if (CurrFieldNo = Rec.FieldNo("ecOutput Lot No.")) then begin
                    lTrackingFunctions.InheritParentLotNoInfoByReleasedChild(Rec);
                end;
                //CS_PRO_008-e                
            end;
        }
        field(50031; "ecOutput Lot Ref. Date"; Date)
        {
            Caption = 'Output lot reference date';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_039';
        }
        field(50032; "ecOutput Lot Exp. Date"; Date)
        {
            Caption = 'Output lot expiration date';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_039';

            trigger OnValidate()
            var
                lLotNoInformation: Record "Lot No. Information";
            begin
                if lLotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."ecOutput Lot No.") then begin
                    if (lLotNoInformation."ecExpiration Date" <> Rec."ecOutput Lot Exp. Date") then begin
                        lLotNoInformation.Validate("ecExpiration Date", Rec."ecOutput Lot Exp. Date");
                        lLotNoInformation.Modify(true);
                    end;
                end;
            end;
        }
        field(50035; "ecWork Center No."; Code[20])
        {
            Caption = 'Work Center No.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_039';
            Editable = false;
            TableRelation = "Work Center"."No.";
        }
        field(50037; "ecParent Routing No."; Code[20])
        {
            Caption = 'Parent Routing No.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_039';
            Editable = false;
            TableRelation = "Routing Header"."No.";
        }
        field(50038; "ecParent Work Center No."; Code[20])
        {
            Caption = 'Parent Work Center No.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_039';
            Editable = false;
            TableRelation = "Work Center"."No.";
        }
        field(50040; "ecFilm Packaging Code"; Code[20])
        {
            Caption = 'Film';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_039';
            Editable = false;
            TableRelation = Item."No.";
        }
        field(50042; "ecCartons Packaging Code"; Code[20])
        {
            Caption = 'Carton';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_039';
            Editable = false;
            TableRelation = Item."No.";
        }
        field(50050; "ecScheduling Sequence"; Integer)
        {
            Caption = 'Sequence';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_018';
        }
        field(50051; "ecScheduling User"; Code[50])
        {
            Caption = 'Scheduling User';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_018';
        }
        field(50055; ecSelected; Boolean)
        {
            Caption = 'Selected';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_018';

            trigger OnValidate()
            var
                lComponentAvailabilityMgt: Codeunit "ecComponent Availability Mgt.";
            begin
                if ecSelected then begin
                    "ecSelected By" := UserId();
                    lComponentAvailabilityMgt.CheckProdOrderLineToPlan(Rec);
                end else begin
                    "ecSelected By" := '';
                    ecCheck := false;
                end;
            end;
        }
        field(50056; "ecSelected By"; Code[50])
        {
            Caption = 'Selected by';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_018';
            Editable = false;
        }
        field(50060; ecCheck; Boolean)
        {
            Caption = 'Check';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_018';
            Editable = false;
        }
        field(50070; "ecIgnore Prod. Restrictions"; Boolean)
        {
            CalcFormula = lookup("Production Order"."ecIgnore Prod. Restrictions" where(Status = field(Status), "No." = field("Prod. Order No.")));
            Caption = 'Ignore Productive Restrictions';
            Description = 'CS_PRO_011';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50085; "ecPlanning Notes"; Text[250])
        {
            Caption = 'Planning notes';
            DataClassification = CustomerContent;
            Description = 'GAP_PRO_013';
        }
        field(50088; "ecProduction Notes"; Text[250])
        {
            Caption = 'Production notes';
            DataClassification = CustomerContent;
            Description = 'GAP_PRO_013';
        }
    }

    keys
    {
        key(ecKey1; "ecParent Line No.") { }  //CS_PRO_044-n
        key(ecKey2; "ecOutput Lot No.", "ecOutput Lot Exp. Date") { } //CS_PRO_039-n
        key(ecKey3; "ecScheduling Sequence") { } //CS_PRO_018
        key(ecKey4; "ecPrevalent Operation Type", "ecPrevalent Operation No.") { } //CS_PRO_018
        key(ecKey5; ecSelected) { } //CS_PRO_018
    }

    trigger OnAfterInsert()
    begin
        //CS_PRO_039-s
        if (Rec.Status = Rec.Status::Released) and (Rec."ecProductive Status" <> Rec."ecProductive Status"::Released) then begin
            Rec.Validate("ecProductive Status", Rec."ecProductive Status"::Released);
        end;
        //CS_PRO_039-e
    end;


    internal procedure ReleaseSelectedLines()
    var
        lProductionOrder: Record "Production Order";
        lProdOrderLine: Record "Prod. Order Line";
        Temp_lProductionOrder: Record "Production Order" temporary;
        lProdOrderStatusManagement: Codeunit "Prod. Order Status Management";
        lChangeStatusonProdOrder: Page "Change Status on Prod. Order";
        lNewStatus: Enum "Production Order Status";
        lNewPostingDate: Date;
        lNewUpdateUnitCost: Boolean;
    begin
        Clear(Temp_lProductionOrder);
        Temp_lProductionOrder.DeleteAll();

        Clear(lProdOrderLine);
        lProdOrderLine.SetRange(Status, Rec.Status::"Firm Planned");
        lProdOrderLine.SetRange("ecSelected By", UserId());
        lProdOrderLine.SetRange(ecSelected, true);
        if lProdOrderLine.FindSet() then begin
            repeat
                if not Temp_lProductionOrder.Get(lProdOrderLine.Status, lProdOrderLine."Prod. Order No.") then begin
                    lProductionOrder.Get(lProdOrderLine.Status, lProdOrderLine."Prod. Order No.");
                    Temp_lProductionOrder := lProductionOrder;
                    Temp_lProductionOrder.Insert(false);
                end;
            until (lProdOrderLine.Next() = 0);
        end;

        Clear(lProdOrderLine);
        Clear(Temp_lProductionOrder);
        if Temp_lProductionOrder.FindSet() then begin
            lChangeStatusonProdOrder.Set(Temp_lProductionOrder);
            if (lChangeStatusonProdOrder.RunModal() = Action::Yes) then begin
                lChangeStatusonProdOrder.ReturnPostingInfo(lNewStatus, lNewPostingDate, lNewUpdateUnitCost);
                repeat
                    lProdOrderLine.SetRange(Status, Temp_lProductionOrder.Status);
                    lProdOrderLine.SetRange("Prod. Order No.", Temp_lProductionOrder."No.");
                    if not lProdOrderLine.IsEmpty then lProdOrderLine.ModifyAll(ecSelected, false, true);

                    lProductionOrder.Get(Temp_lProductionOrder.Status, Temp_lProductionOrder."No.");
                    lProdOrderStatusManagement.ChangeProdOrderStatus(lProductionOrder, lNewStatus, lNewPostingDate, lNewUpdateUnitCost);
                    Commit();
                until (Temp_lProductionOrder.Next() = 0);
            end;
        end;
    end;

    internal procedure EditTextField(var pProdOrderLine: Record "Prod. Order Line"; pFieldNo: Integer)
    var
        Temp_lProdOrderLine: Record "Prod. Order Line" temporary;
        lATSAdvancedTypeHelper: Codeunit "AltATSAdvanced Type Helper";
        lVariant: Variant;

        lNotManagedField: Label 'Field no.: %1 is not handled by this function!';
    begin
        //GAP_PRO_013-s
        Temp_lProdOrderLine.Init();
        case pFieldNo of
            50085:
                begin
                    Temp_lProdOrderLine."ecPlanning Notes" := pProdOrderLine."ecPlanning Notes";
                end;
            50088:
                begin
                    Temp_lProdOrderLine."ecProduction Notes" := pProdOrderLine."ecProduction Notes";
                end;
            else begin
                Error(lNotManagedField, Format(pFieldNo));
            end;
        end;

        lVariant := Temp_lProdOrderLine;
        lATSAdvancedTypeHelper.EditRecordFieldValue(lVariant, pFieldNo, false, false, false);
        Temp_lProdOrderLine := lVariant;

        case pFieldNo of
            50085:
                begin
                    pProdOrderLine."ecPlanning Notes" := Temp_lProdOrderLine."ecPlanning Notes";
                end;
            50088:
                begin
                    pProdOrderLine."ecProduction Notes" := Temp_lProdOrderLine."ecProduction Notes";
                end;
        end;
        //GAP_PRO_013-e
    end;
}
