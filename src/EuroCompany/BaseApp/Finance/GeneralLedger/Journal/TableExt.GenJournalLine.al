namespace EuroCompany.BaseApp.Finance.GeneralLedger.Journal;

using EuroCompany.BaseApp.Finance;
using Microsoft.Finance.GeneralLedger.Journal;

tableextension 80044 "Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        modify("Payment Terms Code")
        {
            trigger OnAfterValidate()
            var
                EcFinanceGenericFunctions: Codeunit "ecFinance Generic Functions";
            begin
                EcFinanceGenericFunctions.CreateSalesPaymentLine(Rec);
            end;
        }
        field(50000; "ecRef. Date For Calc. Due Date"; Date)
        {
            Caption = 'Ref. Date For Calc. Due Date';
            DataClassification = CustomerContent;
        }
    }
}