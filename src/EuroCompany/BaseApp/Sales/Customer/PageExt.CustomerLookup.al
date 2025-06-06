namespace EuroCompany.BaseApp.Sales.Customer;

using Microsoft.Sales.Customer;

pageextension 80076 "Customer Lookup" extends "Customer Lookup"
{
    layout
    {
        addlast(Group)
        {
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
            }
        }
    }
}
