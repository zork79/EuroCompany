namespace EuroCompany.BaseApp.Inventory.Ledger;

using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Inventory.Ledger;

pageextension 80160 "Item Ledger Entries" extends "Item Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("ecMass Balance Mgt. BIO"; Rec."ecMass Balance Mgt. BIO")
            {
                ApplicationArea = All;
            }
            field("ecPlanning Level Code"; Rec."ecPlanning Level Code")
            {
                ApplicationArea = All;
            }
        }
        modify("Expiration Date")
        {
            StyleExpr = ExpirationDateStyle;
            Visible = true;
        }
        modify("Sales Amount (Actual)")
        {
            Visible = true;
        }
        modify("Sales Amount (Expected)")
        {
            Visible = true;
        }
        modify("Cost Amount (Actual)")
        {
            Visible = true;
        }
        modify("Cost Amount (Expected)")
        {
            Visible = true;
        }
        moveafter("Lot No."; "Expiration Date")
        addafter("Expiration Date")
        {
            field(MaxSMaxUsableDate_Field; MaxUsableDate)
            {
                ApplicationArea = All;
                Caption = 'Usage max date';
                Description = 'CS_PRO_008';
                Editable = false;
                StyleExpr = MaxUsableDateStyle;
            }
        }
    }

    var
        ExpirationDateStyle: Text;
        MaxUsableDateStyle: Text;
        MaxUsableDate: Date;

    trigger OnAfterGetRecord()
    var
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        MaxUsableDate := lProductionFunctions.CalcMaxUsableDateForItem(Rec."Item No.", '', '', Rec."Expiration Date");

        ExpirationDateStyle := 'Favorable';
        if (Rec."Expiration Date" < Today) then ExpirationDateStyle := 'Unfavorable';

        MaxUsableDateStyle := 'Favorable';
        if (MaxUsableDate < Today) then MaxUsableDateStyle := 'Unfavorable';
    end;
}
