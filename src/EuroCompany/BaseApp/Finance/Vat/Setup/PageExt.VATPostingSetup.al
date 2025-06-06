namespace EuroCompany.BaseApp.Finance.VAT.Setup;

using Microsoft.Finance.VAT.Setup;

pageextension 80089 "VAT Posting Setup" extends "VAT Posting Setup"
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