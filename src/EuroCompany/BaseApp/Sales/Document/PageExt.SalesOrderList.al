namespace EuroCompany.BaseApp.Sales.Document;

using Microsoft.Sales.Document;

pageextension 80082 "Sales Order List" extends "Sales Order List"
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
        addafter("Completely Shipped")
        {
            field("ecShipped Lines"; Rec."ecShipped Lines")
            {
                ApplicationArea = All;
                Description = 'CS_LOG_001';
            }
            field("ecLines To Ship"; Rec."ecLines To Ship")
            {
                ApplicationArea = All;
                Description = 'CS_LOG_001';
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
