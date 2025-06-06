namespace EuroCompany.BaseApp.Restrictions;

enum 50018 "ecRestrictions Check Result"
{
    //Description = 'CS_PRO_011';
    Extensible = false;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(10; "No restriction")
    {
        Caption = 'No restriction';
    }
    value(20; Passed)
    {
        Caption = 'Passed';
    }
    value(30; Error)
    {
        Caption = 'Error';
    }
    value(40; Warning)
    {
        Caption = 'Warning';
    }
}
