namespace EuroCompany.BaseApp.Foundation.UOM;

using Microsoft.Foundation.UOM;

tableextension 80045 "Unit Of Measure" extends "Unit of Measure"
{
    fields
    {
        field(50000; "ecSelex Exp. Rounding Prec."; Decimal)
        {
            Caption = 'Selex Export Rounding Precision';
            DataClassification = CustomerContent;
        }
    }
}