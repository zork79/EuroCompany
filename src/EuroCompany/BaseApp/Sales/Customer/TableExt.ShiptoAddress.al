namespace EuroCompany.BaseApp.Sales.Customer;

using Microsoft.Finance.VAT.Setup;
using Microsoft.Sales.Customer;

tableextension 80049 "Ship-to Address" extends "Ship-to Address"
{
    fields
    {
        field(50000; "ecVAT Business Posting Group"; Code[20])
        {
            Caption = 'VAT Business Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
        }

    }
}