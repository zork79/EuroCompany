namespace EuroCompany.BaseApp.Purchases.History;

using Microsoft.Purchases.History;

pageextension 80106 "Posted Purchase Invoices" extends "Posted Purchase Invoices"
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
            field("ecNotes payment suspension"; Rec."ecNotes payment suspension")
            {
                ApplicationArea = All;
                Description = 'CS_AFC_019';
            }
        }
    }
}