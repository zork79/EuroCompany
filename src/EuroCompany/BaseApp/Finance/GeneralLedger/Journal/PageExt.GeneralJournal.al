namespace EuroCompany.BaseApp.Finance.GeneralLedger.Journal;

using Microsoft.Finance.GeneralLedger.Journal;

pageextension 80123 "General Journal" extends "General Journal"
{
    layout
    {
        addafter("Document Date")
        {
            field("ecRef. Date For Calc. Due Date"; Rec."ecRef. Date For Calc. Due Date")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
            field("Due Date"; Rec."Due Date")
            {
                ApplicationArea = All;
            }
        }
    }
}