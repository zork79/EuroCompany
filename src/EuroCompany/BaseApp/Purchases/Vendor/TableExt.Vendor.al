namespace EuroCompany.BaseApp.Purchases.Vendor;

using Microsoft.Purchases.Vendor;
using System.EMail;

tableextension 80072 Vendor extends Vendor
{
    fields
    {
        field(50000; "ecVendor Classification"; Code[20])
        {
            Caption = 'Vendor Classification';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            TableRelation = "ecVendor Classification".Code;
        }

        field(50001; "eCPEC E-Mail"; Text[80])
        {
            Caption = 'PEC Email';
            ExtendedDatatype = EMail;
            Description = 'CS_AFC_019';

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "E-Mail" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("eCPEC E-Mail");
            end;
        }

        field(50002; "ecVendor Rating Code"; Code[20])
        {
            Caption = 'Vendor Rating Code';
            DataClassification = CustomerContent;
            Description = 'CS_QMS_009';
            TableRelation = "ecVendor Rating Code".Code;
        }
    }
}
