namespace EuroCompany.BaseApp.Restrictions;

enum 50014 "ecNegative Restr. Notif. Type"
{
    //Description = 'CS_PRO_011';
    Extensible = false;

    value(0; Warning)
    {
        Caption = 'Warning';
    }
    value(1; Error)
    {
        Caption = 'Error';
    }
}
