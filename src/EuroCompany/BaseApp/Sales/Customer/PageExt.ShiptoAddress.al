namespace EuroCompany.BaseApp.Sales.Customer;

using Microsoft.Sales.Customer;
pageextension 80132 "Ship-to Address" extends "Ship-to Address"
{
    layout
    {
        addafter(General)
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom attributes';
                field("ecVAT Business Posting Group"; Rec."ecVAT Business Posting Group")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}