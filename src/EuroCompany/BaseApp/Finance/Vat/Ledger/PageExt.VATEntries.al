namespace EuroCompany.BaseApp.Finance.VAT.Ledger;

using Microsoft.Finance.VAT.Ledger;
pageextension 80087 "VAT Entries" extends "VAT Entries"
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