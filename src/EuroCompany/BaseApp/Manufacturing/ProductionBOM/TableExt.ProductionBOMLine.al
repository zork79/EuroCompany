namespace EuroCompany.BaseApp.Manufacturing.ProductionBOM;

using Microsoft.Manufacturing.ProductionBOM;

tableextension 80005 "Production BOM Line" extends "Production BOM Line"
{
    trigger OnBeforeDelete()
    var
        lBOMAlternativeComponent: Record "ecBOM Alternative Component";

        lDeleteAlternCompConf: Label 'There are alternative components specified for this line. Are you sure you want to delete the line and its alternative components?';
        lOperationCancelErr: Label 'Operation canceled';
    begin
        //GAP_PRO_003-s
        if (Rec.Type = Rec.Type::Item) then begin
            Clear(lBOMAlternativeComponent);
            lBOMAlternativeComponent.SetRange("Production BOM No.", Rec."Production BOM No.");
            lBOMAlternativeComponent.SetRange("Prod. BOM Version Code", Rec."Version Code");
            lBOMAlternativeComponent.SetRange("Prod. BOM Line No.", Rec."Line No.");
            if not lBOMAlternativeComponent.IsEmpty then begin
                if not HideDialog then begin
                    if not Confirm(lDeleteAlternCompConf) then Error(lOperationCancelErr);
                end;

                lBOMAlternativeComponent.DeleteAll(true);
            end;
        end;
        //GAP_PRO_003-e
    end;

    trigger OnBeforeModify()
    var
        lxProductionBOMLine: Record "Production BOM Line";
        lBOMAlternativeComponent: Record "ecBOM Alternative Component";

        lDeleteAlternCompConf: Label 'There are alternative components specified for this line. Are you sure you want to modify the line and delete its alternative components?';
        lOperationCancelErr: Label 'Operation canceled';
    begin
        //GAP_PRO_003-s
        if lxProductionBOMLine.Get(Rec."Production BOM No.", Rec."Version Code", Rec."Line No.") and
           (Rec.Type = Rec.Type::Item) and (lxProductionBOMLine."No." <> Rec."No.")
        then begin
            Clear(lBOMAlternativeComponent);
            lBOMAlternativeComponent.SetRange("Production BOM No.", Rec."Production BOM No.");
            lBOMAlternativeComponent.SetRange("Prod. BOM Version Code", Rec."Version Code");
            lBOMAlternativeComponent.SetRange("Prod. BOM Line No.", Rec."Line No.");
            if not lBOMAlternativeComponent.IsEmpty then begin
                if not HideDialog then begin
                    if not Confirm(lDeleteAlternCompConf) then Error(lOperationCancelErr);
                end;

                lBOMAlternativeComponent.DeleteAll(true);
            end;
        end;
        //GAP_PRO_003-e
    end;

    var
        HideDialog: Boolean;

    internal procedure SetHideDialog(pHideDialog: Boolean)
    begin
        HideDialog := pHideDialog;
    end;
}
