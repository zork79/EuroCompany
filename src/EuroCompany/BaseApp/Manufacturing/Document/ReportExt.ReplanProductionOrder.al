namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Manufacturing.Document;

reportextension 80011 "Replan Production Order" extends "Replan Production Order"
{
    dataset
    {
        modify("Production Order")
        {
            trigger OnBeforeAfterGetRecord()
            var
                lProductionFunctions: Codeunit "ecProduction Functions";
            begin
                //CS_PRO_039-s
                lProductionFunctions.BackupProdOrderLine("Production Order", Temp_ProdOrderLineBK);
                //CS_PRO_039-e
            end;

            trigger OnAfterAfterGetRecord()
            var
                lProductionFunctions: Codeunit "ecProduction Functions";
            begin
                //CS_PRO_039-s
                lProductionFunctions.RestoreFieldsFromProdOrderLineBK("Production Order", Temp_ProdOrderLineBK);
                //CS_PRO_039-e
            end;
        }

        modify("Prod. Order Line")
        {
            trigger OnAfterPostDataItem()
            var
                lProductionFunctions: Codeunit "ecProduction Functions";
            begin
                //CS_PRO_044-s
                if ("Production Order".Status = "Production Order".Status::Released) then begin
                    lProductionFunctions.UpdateProductionOrderLines("Production Order", false);
                end;
                //CS_PRO_044-e
            end;
        }
    }

    var
        Temp_ProdOrderLineBK: Record "Prod. Order Line" temporary;
}
