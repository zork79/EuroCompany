namespace EuroCompany.BaseApp.Sales.AdvancedTrade;
using Microsoft.Inventory.Item;

codeunit 50028 ecEventSubAdvanceTrade
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"APsTRDImport Lists Line", OnAfterValidateEvent, "New Unit of Measure Code", false, false)]
    local procedure OnAfterValidateEventNewUnitOfMeasureCode(var Rec: Record "APsTRDImport Lists Line"; var xRec: Record "APsTRDImport Lists Line")
    var
        Item: Record Item;
    begin
        if Item.Get(Rec."Item No.") then
            if Item."ecConsumer Unit of Measure" <> '' then
                Rec."New Unit of Measure Code" := Item."ecConsumer Unit of Measure";
    end;
}