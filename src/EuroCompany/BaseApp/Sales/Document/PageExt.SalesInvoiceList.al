namespace EuroCompany.BaseApp.Sales.Document;

using Microsoft.Sales.Document;

pageextension 80097 "Sales Invoice List" extends "Sales Invoice List"
{
    layout
    {
        addlast(Control1)
        {
            field("ecProduct Segment No."; Rec."ecProduct Segment No.")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_032';
            }
            field("ecProduct Segment Description"; Rec."ecProduct Segment Description")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_032';
                DrillDown = false;
            }
        }
        addafter("Document Date")
        {
            field("ecRef. Date For Calc. Due Date"; Rec."ecRef. Date For Calc. Due Date")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
        }
    }
}
