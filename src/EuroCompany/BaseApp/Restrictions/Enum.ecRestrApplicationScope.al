namespace EuroCompany.BaseApp.Restrictions;

enum 50012 "ecRestr. Application Scope"
{
    //Description = 'CS_PRO_011';
    Extensible = false;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(10; Purchase)
    {
        Caption = 'Purchase';
    }
    value(20; Production)
    {
        Caption = 'Production';
    }
    value(30; Sales)
    {
        Caption = 'Sales';
    }
}
