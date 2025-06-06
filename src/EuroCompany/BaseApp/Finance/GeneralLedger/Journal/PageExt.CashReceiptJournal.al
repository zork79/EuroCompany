namespace EuroCompany.BaseApp.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Journal;

pageextension 80130 "Cash Receipt Journal" extends "Cash Receipt Journal"
{
    layout
    {
        addafter("Document Date")
        {
            field("ecRef. Date For Calc. Due Date"; Rec."ecRef. Date For Calc. Due Date")
            {
                ApplicationArea = All;
            }
            field("Due Date"; Rec."Due Date")
            {
                ApplicationArea = All;
            }
        }
    }
}