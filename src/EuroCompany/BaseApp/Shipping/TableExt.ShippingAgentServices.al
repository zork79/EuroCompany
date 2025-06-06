namespace EuroCompany.BaseApp.Shipping;

using Microsoft.Foundation.Shipping;

tableextension 80105 "Shipping Agent Services" extends "Shipping Agent Services"
{
    fields
    {
        field(50000; "ecPallet Place Volume"; Decimal)
        {
            Caption = 'Volume per pallet place (m3)';
            DataClassification = CustomerContent;
            Description = 'CS_LOG_001';
        }
    }
}
