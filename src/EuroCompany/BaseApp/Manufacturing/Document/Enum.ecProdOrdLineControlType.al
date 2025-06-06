namespace EuroCompany.BaseApp.Manufacturing.Document;

enum 50004 "ecProd. Ord. Line Control Type"
{
    Extensible = true;

    value(10; None)
    {
        Caption = 'None';
    }
    value(20; Warning)
    {
        Caption = 'Warning';
    }
    value(30; Error)
    {
        Caption = 'Error';
    }
}