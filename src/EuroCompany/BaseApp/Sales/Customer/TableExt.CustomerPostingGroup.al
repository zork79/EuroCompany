namespace EuroCompany.BaseApp.Sales.Customer;
using Microsoft.Sales.Customer;

tableextension 80061 "Customer Posting Group" extends "Customer Posting Group"
{
    fields
    {
        field(50000; "ecInclude Mgt. Insured"; Boolean)
        {
            Caption = 'Include Management Insured';
            DataClassification = CustomerContent;
        }
    }
}