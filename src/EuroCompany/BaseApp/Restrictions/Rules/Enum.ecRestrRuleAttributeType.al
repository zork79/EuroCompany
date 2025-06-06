namespace EuroCompany.BaseApp.Restrictions.Rules;

enum 50010 "ecRestr. Rule Attribute Type"
{
    //Description = 'CS_PRO_011';
    Extensible = false;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(10; Vendor)
    {
        Caption = 'Vendor';
    }
    value(20; "Origin Country")
    {
        Caption = 'Origin Country';
    }
    value(30; Manufacturer)
    {
        Caption = 'Manufacturer';
    }
    value(40; Gauge)
    {
        Caption = 'Gauge';
    }
    value(50; Variety)
    {
        Caption = 'Variety';
    }
    value(60; "Crop Period")
    {
        Caption = 'Crop Period';
    }
}
