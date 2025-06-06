namespace EuroCompany.BaseApp.Finance.VAT.Ledger;

using Microsoft.Finance.VAT.Ledger;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;

tableextension 80029 "VAT Entry" extends "VAT Entry"
{
    fields
    {
        field(50000; "ecInclude in OSS VAT Sett."; Boolean)
        {
            Caption = 'Include in OSS VAT Sett.';
            DataClassification = CustomerContent;
        }
    }
}