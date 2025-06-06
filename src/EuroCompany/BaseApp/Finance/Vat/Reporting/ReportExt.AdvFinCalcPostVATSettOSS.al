namespace EuroCompany.BaseApp.Finance.VAT.Reporting;
reportextension 80005 "Adv.FinCalc PostVAT Sett. OSS" extends "APsAdvFinRpCalc Post VATSettl."
{
    dataset
    {
        modify("VAT Posting Setup")
        {
            trigger OnAfterPreDataItem()
            begin
                "VAT Posting Setup".SetRange("ecInclude in OSS VAT Sett.", false);
            end;
        }
    }
}
