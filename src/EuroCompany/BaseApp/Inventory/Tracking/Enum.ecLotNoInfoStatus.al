namespace EuroCompany.BaseApp.Inventory.Tracking;

enum 50003 "ecLot No. Info Status"
{
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(10; Released)
    {
        Caption = 'Released';
    }
    value(20; "Required Attributes")
    {
        Caption = 'Required attributes';
    }
}
