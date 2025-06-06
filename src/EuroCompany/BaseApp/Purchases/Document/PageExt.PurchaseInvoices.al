namespace EuroCompany.BaseApp.Purchases.Document;

using Microsoft.Purchases.Document;
pageextension 80104 "Purchase Invoices" extends "Purchase Invoices"
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