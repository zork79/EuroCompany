namespace EuroCompany.BaseApp.Inventory.Item;

enum 50002 "ecItem Type"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(10; "Raw Material")
    {
        Caption = 'Raw Material';
    }
    value(20; "Semi-finished Product")
    {
        Caption = 'Semi-finished Product';
    }
    value(30; "Finished Product")
    {
        Caption = 'Finished Product';
    }
    value(40; "Generic Packaging")
    {
        Caption = 'Generic packaging';
    }
    value(42; "Film Packaging")
    {
        Caption = 'Film packaging';
    }
    value(44; "Carton Packaging")
    {
        Caption = 'Carton packaging';
    }
    value(50; Indifferent)
    {
        Caption = 'Indifferent';
    }
}
