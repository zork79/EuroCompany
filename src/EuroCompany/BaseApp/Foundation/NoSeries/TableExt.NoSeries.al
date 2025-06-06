namespace EuroCompany.BaseApp.Foundation.NoSeries;

using Microsoft.Foundation.NoSeries;

tableextension 80113 "No. Series" extends "No. Series"
{
    fields
    {
        field(50000; "ecNot Create Vat Entry"; Boolean)
        {
            Caption = 'Not create VAT entry';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_018';
        }
    }
}
