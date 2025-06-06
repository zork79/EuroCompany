namespace EuroCompany.BaseApp.Inventory.Tracking;

using EuroCompany.BaseApp.Setup;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
codeunit 50012 "ecTracking Standard Events"
{
    #region 219
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracing Mgt.", OnFirstLevelOnAfterSetLedgerEntryFilters, '', false, false)]
    local procedure "Item Tracing Mgt._OnFirstLevelOnAfterSetLedgerEntryFilters"(var ItemLedgerEntry: Record "Item Ledger Entry"; var SerialNoFilter: Text; var LotNoFilter: Text; var ItemNoFilter: Text)
    var
        EcSetup: Record "ecGeneral Setup";
    begin
        EcSetup.Get();
        if (EcSetup."Enable Item Tracing Intrastat") and (EcSetup."Show Only Run Intrastat Page") then begin
            ItemLedgerEntry.SetRange("Serial No.");
            ItemLedgerEntry.SetFilter("Document No.", SerialNoFilter);
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracing", OnAfterUpdateTraceText, '', false, false)]
    local procedure "Item Tracing_OnAfterUpdateTraceText"(var TraceText: Text; SerialNoFilter: Text; LotNoFilter: Text; ItemNoFilter: Text; VariantFilter: Text; TraceMethod: Option; ShowComponents: Option)
    var
        EcSetup: Record "ecGeneral Setup";
    begin
        EcSetup.Get();
        if (EcSetup."Enable Item Tracing Intrastat") and (EcSetup."Show Only Run Intrastat Page") then
            TraceText := '';
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracing Mgt.", OnAfterTransferData, '', false, false)]
    local procedure "Item Tracing Mgt._OnAfterTransferData"(var ItemLedgerEntry: Record "Item Ledger Entry"; var TempItemTracingBuffer: Record "Item Tracing Buffer" temporary; ValueEntry: Record "Value Entry")
    var
        EcSetup: Record "ecGeneral Setup";
        LotNoInfo: Record "Lot No. Information";
        Item: Record Item;
    begin
        EcSetup.Get();
        if (EcSetup."Enable Item Tracing Intrastat") and (EcSetup."Show Only Run Intrastat Page") then begin
            if Item.Get(TempItemTracingBuffer."Item No.") then begin
                TempItemTracingBuffer.Validate("ecItem Type", Item."ecItem Type");
                TempItemTracingBuffer.Validate("ecItem Species", Item.ecSpecies);
                TempItemTracingBuffer.Validate("ecItem Species Type", Item."ecSpecies Type");
                TempItemTracingBuffer.Validate("ecItem Commercial Line", Item."ecCommercial Line");
                TempItemTracingBuffer.Validate("ecItem Brand", Item.ecBrand);
                TempItemTracingBuffer.Validate("ecItem Brand Type", Item."ecBrand Type");

                LotNoInfo.Reset();
                LotNoInfo.SetLoadFields("ecOrigin Country Code");
                LotNoInfo.SetRange("Lot No.", TempItemTracingBuffer."Lot No.");
                LotNoInfo.SetRange("Item No.", Item."No.");
                if LotNoInfo.FindFirst() then
                    TempItemTracingBuffer.Validate("ecLot Origin Country Code", LotNoInfo."ecOrigin Country Code");

                TempItemTracingBuffer.Validate("ecItem Unit Of Measure", Item."Base Unit of Measure");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracing Mgt.", OnInsertRecordOnBeforeSetDescription, '', false, false)]
    local procedure "Item Tracing Mgt._OnInsertRecordOnBeforeSetDescription"(var TempTrackEntry: Record "Item Tracing Buffer"; var RecRef: RecordRef; var Description2: Text[100])
    var
        EcSetup: Record "ecGeneral Setup";
    begin
        EcSetup.Get();
        if (EcSetup."Enable Item Tracing Intrastat") and (EcSetup."Show Only Run Intrastat Page") then
            TempTrackEntry."Already Traced" := false;
    end;

    #endregion 219
}