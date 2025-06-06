namespace EuroCompany.BaseApp.Restrictions.Rules;

enum 50008 "ecRestriction Rule Status"
{
    //Description = 'CS_PRO_011';
    Extensible = false;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Certified)
    {
        Caption = 'Certified';
    }
    value(2; Blocked)
    {
        Caption = 'Blocked';
    }
}
