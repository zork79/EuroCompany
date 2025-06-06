namespace EuroCompany.BaseApp.Warehouse.Pallets;
table 50038 "ecPallet Grouping Code"
{
    Caption = 'Pallet Grouping Code';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }
}