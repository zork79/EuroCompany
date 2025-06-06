namespace EuroCompany.BaseApp.Inventory.Item;

enum 50006 "ecBio Item Attribute"
{
    Extensible = false;

    value(0; BIO)
    {
        Caption = 'BIO', Locked = true;
    }
    value(1; NOBIO)
    {
        Caption = 'NO-BIO', Locked = true;
    }
}
