namespace EuroCompany.BaseApp.Warehouse.Pallets;

enum 50023 "ecPallet Source Doc. Type"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; "Transfer Order")
    {
        Caption = 'Transfer Order';
    }
    value(2; "Sales Return Order")
    {
        Caption = 'Sales Return Order';
    }
    value(3; "Sales Order")
    {
        Caption = 'Sales Order';
    }
    value(4; "Purchase Order")
    {
        Caption = 'Purchase Order';
    }
    value(5; "Purchase Return Order")
    {
        Caption = 'Purchase Return Order';
    }
}