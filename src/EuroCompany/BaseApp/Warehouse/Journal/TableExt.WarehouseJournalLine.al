namespace EuroCompany.BaseApp.Warehouse.Journal;

using Microsoft.Warehouse.Journal;

tableextension 80052 "Warehouse Journal Line" extends "Warehouse Journal Line"
{
    fields
    {
        field(50000; "ecNo. Of Parcels"; Integer)
        {
            Caption = 'No. Of Parcels';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            MinValue = 1;
        }
        field(50002; "ecUnit Weight"; Decimal)
        {
            Caption = 'Unit Weight';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            MinValue = 0;
        }
        field(50005; "ecTotal Weight"; Decimal)
        {
            Caption = 'Total Weight';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            MinValue = 0;
        }
    }
}
