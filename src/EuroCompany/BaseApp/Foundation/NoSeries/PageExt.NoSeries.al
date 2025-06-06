namespace EuroCompany.BaseApp.Foundation.NoSeries;

using Microsoft.Foundation.NoSeries;

pageextension 80218 "No. Series" extends "No. Series"
{
    layout
    {
        addlast(Control1)
        {
            field("ecNot Create Vat Entry"; Rec."ecNot Create Vat Entry")
            {
                ApplicationArea = All;
                Description = 'CS_AFC_018';
            }
        }
    }
}
