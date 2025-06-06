namespace EuroCompany.BaseApp.Sales.Commissions;

//AFC_CS_005
enum 50020 "ecCustomer Type"
{
    Extensible = true;
    caption = 'Customer Type';

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; "Customer")
    {
        Caption = 'Customer';
    }
    value(2; "Segment Customer Business")
    {
        Caption = 'Segment Customer Business';
    }
}