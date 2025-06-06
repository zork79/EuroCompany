namespace EuroCompany.BaseApp.Purchases.Document;

using Microsoft.Purchases.Document;

pageextension 80159 "Purchase Quotes" extends "Purchase Quotes"
{
    layout
    {
        addlast(Control1)
        {
            field("ecVendor Classification"; Rec."ecVendor Classification")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_013';
            }
        }
    }
}
