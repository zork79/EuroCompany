namespace EuroCompany.BaseApp.Manufacturing.Planning;

using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Inventory.Planning;

tableextension 80010 "Planning Component" extends "Planning Component"
{
    fields
    {
        field(50060; "ecSource Qty. per"; Decimal)
        {
            Caption = 'Source Qty. per';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'GAP_PRO_003';
            Editable = false;
        }
    }
}
