namespace EuroCompany.BaseApp.Finance.VAT.Ledger;

using Microsoft.Finance.VAT.Ledger;

tableextension 80032 "Vat Register" extends "VAT Register"
{
    fields
    {
        field(50000; "ecInclude in OSS VAT System"; Boolean)
        {
            Caption = 'Include in OSS VAT System';
            DataClassification = CustomerContent;
        }
    }
}