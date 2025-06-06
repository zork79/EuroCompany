namespace EuroCompany.BaseApp.Warehouse.Pallets;

enum 50022 "ecPallets Document Type"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; "Warehouse Receipt")
    {
        Caption = 'Warehouse Receipt';
    }
    value(2; "Warehouse Shipment")
    {
        Caption = 'Warehouse Shipment';
    }
    value(3; "Positive Adjmt.")
    {
        Caption = 'Positive Adjmt.';
    }
    value(4; "Negative Adjmt.")
    {
        Caption = 'Negative Adjmt.';
    }
}