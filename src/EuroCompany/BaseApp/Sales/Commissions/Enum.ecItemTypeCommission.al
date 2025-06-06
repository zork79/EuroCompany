namespace EuroCompany.BaseApp.Sales.Commissions;

//AFC_CS_005
enum 50021 "ecItem Type Commission"
{
    Extensible = true;
    caption = 'Item Type Commission';

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; "Item")
    {
        Caption = 'Item';
    }
    value(2; "Product Segment")
    {
        Caption = 'Product Segment';
    }
}