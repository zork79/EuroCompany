namespace EuroCompany.BaseApp.Finance.VAT.Reporting;

using Microsoft.Finance.VAT.Reporting;
reportextension 80006 "Calc And Post VAT Sett. OSS" extends "Calc. and Post VAT Settlement"
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
