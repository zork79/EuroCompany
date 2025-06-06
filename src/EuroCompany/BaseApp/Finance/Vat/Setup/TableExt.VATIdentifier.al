namespace EuroCompany.BaseApp.Finance.VAT.Setup;

using Microsoft.Finance.VAT.Setup;

tableextension 80030 "VAT Identifier" extends "VAT Identifier"
{
    fields
    {
        field(50000; "ecReport Filter Only OSS"; Boolean)
        {
            Caption = 'Report Filter Only OSS';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}