namespace EuroCompany.BaseApp.Purchases.History;

using EuroCompany.BaseApp.Setup;
using Microsoft.Purchases.History;
tableextension 80042 "Purch. Rcpt. Header" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50000; "ecRef. Date For Calc. Due Date"; Date)
        {
            Caption = 'Ref. Date For Calc. Due Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}