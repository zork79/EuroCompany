namespace EuroCompany.BaseApp.Warehouse.Pallets;

table 50045 "ecCPR Extracted TXT"
{
    Caption = 'CPR Extracted TXT';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Progressive No."; Text[10])
        {
            Caption = 'Progressive no.';
        }
        field(2; "TXT File Name"; Text[2048])
        {
            Caption = 'TXT File Name';
        }
    }
    keys
    {
        key(Key1; "Progressive No.")
        {
            Clustered = true;
        }
    }
}