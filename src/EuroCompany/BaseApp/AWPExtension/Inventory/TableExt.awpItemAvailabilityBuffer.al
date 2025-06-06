namespace EuroCompany.BaseApp.AWPExtension.Inventory;

tableextension 80073 "awpItem Availability Buffer" extends "AltAWPItem Availability Buffer"
{
    fields
    {
        field(50000; "ecInventory Constraint"; Decimal)
        {
            Caption = 'Inventory Constraint';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'CS_PRO_018';
        }
        field(50010; "ecUsable Quantity"; Decimal)
        {
            Caption = 'Usable quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'CS_PRO_018';
        }
        field(50015; "ecExpired Quantity"; Decimal)
        {
            Caption = 'Expired quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'CS_PRO_018';
        }
        field(50020; "ecQty. on Component Lines"; Decimal)
        {
            Caption = 'Qty. on Component Lines';
            DataClassification = CustomerContent;
        }
    }
}
