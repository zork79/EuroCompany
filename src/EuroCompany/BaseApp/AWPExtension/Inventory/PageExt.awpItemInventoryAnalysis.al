namespace EuroCompany.BaseApp.AWPExtension.Inventory;
using EuroCompany.BaseApp.Manufacturing;

pageextension 80155 "awpItem Inventory Analysis" extends "AltAWPItem Inventory Analysis"
{
    layout
    {
        addafter("Expiration Date")
        {
            field(MaxUsableDate_Field; MaxUsableDate)
            {
                ApplicationArea = All;
                Caption = 'Usage max date';
                Description = 'CS_PRO_018';
                Editable = false;
                StyleExpr = MaxUsableDateStyle;
            }
        }
    }

    var
        MaxUsableDate: Date;
        MaxUsableDateStyle: Text;
        ExpirationDateStyle: Text;

    trigger OnAfterGetRecord()
    var
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_018-s
        MaxUsableDate := lProductionFunctions.CalcMaxUsableDateForItem(Rec."Item No.", '', '', Rec."Expiration Date");

        ExpirationDateStyle := 'Favorable';
        if (Rec."Expiration Date" < Today) then ExpirationDateStyle := 'Unfavorable';

        MaxUsableDateStyle := 'Favorable';
        if (MaxUsableDate < Today) then MaxUsableDateStyle := 'Unfavorable';
        //CS_PRO_018-e
    end;
}
