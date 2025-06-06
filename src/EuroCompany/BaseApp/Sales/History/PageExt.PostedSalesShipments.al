namespace EuroCompany.BaseApp.Sales.History;

using Microsoft.Sales.History;

pageextension 80122 "Posted Sales Shipments" extends "Posted Sales Shipments"
{
    layout
    {
        modify("Posting Date")
        {
            Visible = true;
        }
        addafter("Document Date")
        {
            field("AltAWPInvoice Deferral Date"; Rec."AltAWPInvoice Deferral Date")
            {
                ApplicationArea = All;
                Description = 'CS_AFC_014';
            }
            field("ecRef. Date For Calc. Due Date"; Rec."ecRef. Date For Calc. Due Date")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
        }
    }
}