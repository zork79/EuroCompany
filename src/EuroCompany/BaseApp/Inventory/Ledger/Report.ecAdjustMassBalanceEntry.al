namespace EuroCompany.BaseApp.Inventory.Ledger;
using Microsoft.Manufacturing.Document;

report 50021 "ecAdjust Mass. Balance Entry"
{
    Caption = 'Adjust Mass. Balance Entry';
    UsageCategory = None;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            RequestFilterFields = Status, "Prod. Order No.", "Line No.";

            trigger OnAfterGetRecord()
            var
                MassBalanceGenFunctions: Codeunit "ecMass Balance Gen. Functions";
            begin
                MassBalanceGenFunctions.ClearLinkedConsOutputRecord("Prod. Order Line");
                MassBalanceGenFunctions.AdjustOutputQuantitesFromConsumptionsEntry("Prod. Order Line");
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
    }
}