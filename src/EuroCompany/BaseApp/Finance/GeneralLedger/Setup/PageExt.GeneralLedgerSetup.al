namespace EuroCompany.BaseApp.Finance.GeneralLedger.Setup;

using Microsoft.Finance.GeneralLedger.Setup;

pageextension 80085 "General Ledger Setup" extends "General Ledger Setup"
{
    layout
    {
        addafter("Payroll Transaction Import")
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom attributes';
                field("ecLast OSS Settlement Date"; Rec."ecLast OSS Settlement Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}