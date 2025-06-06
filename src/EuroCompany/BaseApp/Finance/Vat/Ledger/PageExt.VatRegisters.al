namespace EuroCompany.BaseApp.Finance.VAT.Ledger;

using Microsoft.Finance.VAT.Ledger;

pageextension 80090 "Vat Registers" extends "VAT Registers"
{
    layout
    {
        addlast(Control1)
        {
            field("ecInclude in OSS VAT System"; Rec."ecInclude in OSS VAT System")
            {
                ApplicationArea = All;
            }
        }
    }
}