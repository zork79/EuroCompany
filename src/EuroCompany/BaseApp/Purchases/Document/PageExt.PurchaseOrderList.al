namespace EuroCompany.BaseApp.Purchases.Document;

using Microsoft.Purchases.Document;
pageextension 80110 "Purchase Order List" extends "Purchase Order List"
{
    layout
    {
        addafter("Document Date")
        {
            field("ecRef. Date For Calc. Due Date"; Rec."ecRef. Date For Calc. Due Date")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
        }
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