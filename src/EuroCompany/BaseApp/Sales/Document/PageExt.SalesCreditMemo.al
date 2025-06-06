namespace EuroCompany.BaseApp.Sales.Document;

using Microsoft.Sales.Document;
pageextension 80117 "Sales Credit Memo" extends "Sales Credit Memo"
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
        }
    }

    actions
    {
        addafter(Category_Process)
        {
            group(Print_Promoted)
            {
                Caption = 'Print';

                actionref(TestReportPromoted; TestReport) { }
            }
        }
    }
}