namespace EuroCompany.BaseApp.Sales.Customer;

using Microsoft.Sales.Customer;
pageextension 80133 "Ship-to Address List" extends "Ship-to Address List"
{
    layout
    {
        addlast(Control1)
        {
            field("ecVAT Business Posting Group"; Rec."ecVAT Business Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
}