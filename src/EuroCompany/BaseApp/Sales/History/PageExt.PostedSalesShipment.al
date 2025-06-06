namespace EuroCompany.BaseApp.Sales.History;

using Microsoft.Sales.History;

pageextension 80121 "Posted Sales Shipment" extends "Posted Sales Shipment"
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
        modify("AltAWPInvoice Deferral Date")
        {
            Description = 'CS_AFC_014';
            Visible = true;
        }
    }
}