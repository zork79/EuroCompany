
namespace EuroCompany.BaseApp.Finance.GeneralLedger.Setup;

using Microsoft.Finance.GeneralLedger.Setup;
tableextension 80027 "General Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(50000; "ecLast OSS Settlement Date"; Date)
        {
            Caption = 'Last OSS Settlement';
            DataClassification = CustomerContent;
        }
    }
}
