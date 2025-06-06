namespace EuroCompany.BaseApp.Purchases.Document;
using Microsoft.Finance.GeneralLedger.Ledger;
pageextension 80226 "ecG/L Entries Preview" extends "G/L Entries Preview"
{
    layout
    {
        addafter(Amount)
        {
            field("APsCompetence Starting Date"; Rec."APsCompetence Starting Date")
            {
                ApplicationArea = All;
            }
            field("APsCompetence Ending Date"; Rec."APsCompetence Ending Date")
            {
                ApplicationArea = All;
            }
        }
    }
}