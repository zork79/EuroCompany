namespace EuroCompany.BaseApp.Manufacturing.Routing;

enum 50019 "ecProduction Process Type"
{
    //Description = 'CS_QMS_011';

    value(0; Standard)
    {
        Caption = 'Standard Production';
    }
    value(30; Unpacking)
    {
        Caption = 'Unpacking';
    }
    value(40; Rework)
    {
        Caption = 'Rework';
    }
}
