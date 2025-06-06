namespace EuroCompany.BaseApp.Manufacturing.Document;

enum 50000 "ecProductive Status"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(10; Released)
    {
        Caption = 'Released';
    }
    value(20; Scheduled)
    {
        Caption = 'Scheduled';
    }
    value(30; Activated)
    {
        Caption = 'Activated';
    }
    value(40; Suspended)
    {
        Caption = 'Suspended';
    }
    value(50; Completed)
    {
        Caption = 'Completed';
    }
}
