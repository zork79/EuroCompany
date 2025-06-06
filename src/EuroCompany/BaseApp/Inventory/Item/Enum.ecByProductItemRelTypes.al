namespace EuroCompany.BaseApp.Inventory.Item;

enum 50026 "ecBy Product Item Rel. Types"
{

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(10; "One to One")
    {
        Caption = 'One to one';
    }
    value(20; "One to Many")
    {
        Caption = 'One to many';
    }
}
