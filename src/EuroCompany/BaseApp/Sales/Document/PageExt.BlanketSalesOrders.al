namespace EuroCompany.BaseApp.Sales.Document;

using Microsoft.Sales.Document;

pageextension 80084 "Blanket Sales Orders" extends "Blanket Sales Orders"
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
                Importance = Additional;
            }
            field("ecSales Manager Code"; Rec."ecSales Manager Code")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_031';
            }
            field("ecSales Manager Name"; Rec."ecSales Manager Name")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_031';
                DrillDown = false;
                Importance = Additional;
            }
        }
    }
}
