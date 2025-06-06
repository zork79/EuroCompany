namespace EuroCompany.BaseApp.Finance.VAT.Ledger;

using Microsoft.Finance.VAT.Ledger;
pageextension 80086 "Vat Book Entries" extends "VAT Book Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("ecInclude in OSS VAT Sett."; Rec."ecInclude in OSS VAT Sett.")
            {
                ApplicationArea = All;
            }
        }
    }
}