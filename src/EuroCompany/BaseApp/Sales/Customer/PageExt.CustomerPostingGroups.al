namespace EuroCompany.BaseApp.Sales.Customer;
using Microsoft.Sales.Customer;

pageextension 80145 "Customer Posting Groups" extends "Customer Posting Groups"
{
    layout
    {
        addlast(Control1)
        {
            field("ecInclude Mgt. Insured"; Rec."ecInclude Mgt. Insured")
            {
                ApplicationArea = All;
            }
        }
    }
}