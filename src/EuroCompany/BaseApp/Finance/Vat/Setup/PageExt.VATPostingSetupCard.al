namespace EuroCompany.BaseApp.Finance.VAT.Setup;

using Microsoft.Finance.VAT.Setup;
pageextension 80088 "VAT Posting Setup Card" extends "VAT Posting Setup Card"
{
    layout
    {
        addafter(Usage)
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom attributes';
                field("ecInclude in OSS VAT Sett."; Rec."ecInclude in OSS VAT Sett.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}