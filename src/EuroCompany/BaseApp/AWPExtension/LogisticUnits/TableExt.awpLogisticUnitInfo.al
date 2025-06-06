namespace EuroCompany.BaseApp.AWPExtension.LogisticUnits;

tableextension 80054 "awpLogistic Unit Info" extends "AltAWPLogistic Unit Info"
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
