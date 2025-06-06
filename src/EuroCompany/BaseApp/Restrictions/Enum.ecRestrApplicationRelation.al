namespace EuroCompany.BaseApp.Restrictions;

enum 50013 "ecRestr. Application Relation"
{
    //Description = 'CS_PRO_011';
    Extensible = false;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(10; "All Customers")
    {
        Caption = 'All Customers';
    }
    value(11; Customer)
    {
        Caption = 'Customer';
    }
    value(20; "All Vendors")
    {
        Caption = 'All Vendors';
    }
    value(21; Vendor)
    {
        Caption = 'Vendor';
    }
    value(30; "All BOM Components")
    {
        Caption = 'All BOM Components';
    }
    value(31; "Prod. BOM Component")
    {
        Caption = 'Prod. BOM Component';
    }
}
