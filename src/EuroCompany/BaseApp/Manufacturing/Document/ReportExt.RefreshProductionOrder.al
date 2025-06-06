namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Manufacturing.Document;

reportextension 80010 "Refresh Production Order" extends "Refresh Production Order"
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
    }

    var
        Temp_ProdOrderLineBK: Record "Prod. Order Line" temporary;
}
