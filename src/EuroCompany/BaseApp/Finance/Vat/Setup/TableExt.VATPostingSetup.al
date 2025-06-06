namespace EuroCompany.BaseApp.Finance.VAT.Setup;

using EuroCompany.BaseApp.Finance;
using Microsoft.Finance.VAT.Setup;

tableextension 80031 "VAT Posting Setup" extends "VAT Posting Setup"
{
    fields
    {
        modify("APsInclude in E.VAT Settlement")
        {
            trigger OnAfterValidate()
            begin
                FinanceGenericFunctions.CheckInclInVATSettFlags(Rec);
            end;
        }
        field(50000; "ecInclude in OSS VAT Sett."; Boolean)
        {
            Caption = 'Include in OSS VAT Sett.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                FinanceGenericFunctions.CheckInclInVATSettFlags(Rec);
            end;
        }
    }

    var
        FinanceGenericFunctions: Codeunit "ecFinance Generic Functions";
}