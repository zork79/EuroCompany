namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Manufacturing.Document;

pageextension 80048 "Prod. Order Components" extends "Prod. Order Components"
{
    layout
    {
        modify("Item No.")
        {
            Editable = CompEditable;

            trigger OnDrillDown()
            var
                lProductionFunctions: Codeunit "ecProduction Functions";
            begin
                //GAP_PRO_003-s
                if CompEditable then exit;
                lProductionFunctions.LookupAlternativeProdOrdComp(Rec);
                CurrPage.Update(true);
                //GAP_PRO_003-e
            end;
        }

        modify("Location Code")
        {
            trigger OnAfterValidate()
            begin
                //CS_PRO_039-s
                CurrPage.Update(true);
                //CS_PRO_039-e
            end;
        }
        modify("Bin Code")
        {
            trigger OnAfterValidate()
            begin
                //CS_PRO_039-s
                CurrPage.Update(true);
                //CS_PRO_039-e
            end;
        }

        modify("Unit of Measure Code")
        {
            trigger OnAfterValidate()
            begin
                //CS_PRO_039-s
                CurrPage.Update(true);
                //CS_PRO_039-e   
            end;
        }
        modify("Substitution Available")
        {
            Visible = false;
        }
    }
    actions
    {
        modify(SelectItemSubstitution)
        {
            Description = 'GAP_PRO_003';
            Enabled = false;
        }
    }

    var
        CompEditable: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        //GAP_PRO_003-s
        CompEditable := false;
        if (Rec."Item No." = '') or ((Rec."AltAWPSource Prod. BOM No." = '') and (Rec."AltAWPSource Prod. BOM Line" = 0)) then begin
            CompEditable := true;
        end;
        //GAP_PRO_003-e
    end;
}
