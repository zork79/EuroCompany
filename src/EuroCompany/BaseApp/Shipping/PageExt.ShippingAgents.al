namespace EuroCompany.BaseApp.Shipping;

using Microsoft.Foundation.Shipping;

pageextension 80211 "Shipping Agents" extends "Shipping Agents"
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
