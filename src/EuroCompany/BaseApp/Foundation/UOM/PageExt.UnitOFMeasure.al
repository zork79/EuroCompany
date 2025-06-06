namespace EuroCompany.BaseApp.Foundation.UOM;

using Microsoft.Foundation.UOM;

pageextension 80125 "Unit Of Measure" extends "Units of Measure"
{
    layout
    {
        addlast(Control1)
        {
            field("ecSelex Exp. Rounding Prec."; Rec."ecSelex Exp. Rounding Prec.")
            {
                ApplicationArea = All;
            }
        }
    }
}