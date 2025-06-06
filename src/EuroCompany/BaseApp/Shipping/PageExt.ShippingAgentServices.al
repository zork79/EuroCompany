namespace EuroCompany.BaseApp.Shipping;

using Microsoft.Foundation.Shipping;

pageextension 80210 "Shipping Agent Services" extends "Shipping Agent Services"
{
    layout
    {
        addlast(Control1)
        {
            field("ecPallet Place Volume"; Rec."ecPallet Place Volume")
            {
                ApplicationArea = All;
                Description = 'CS_LOG_001';
            }
        }
    }
}
