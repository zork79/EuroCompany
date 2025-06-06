namespace EuroCompany.BaseApp.Warehouse.Pallets;

enum 50025 "ecPallet Status Mgt."
{
    Extensible = true;

    value(0; "Not required")
    {
        Caption = 'Not required';
    }
    value(1; Required)
    {
        Caption = 'Required';
    }
    value(2; "In progress")
    {
        Caption = 'In progress';
    }
    value(3; Completed)
    {
        Caption = 'Completed';
    }
}