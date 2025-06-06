namespace EuroCompany.BaseApp.AWPExtension.RoleCenters;

using EuroCompany.BaseApp.Sales.AdvancedTrade;

pageextension 80078 "awpRC - Accounting" extends "AltAWPRC - Accounting"
{
    actions
    {
        addafter(SalespersonsPurchasers)
        {
            action(ecSalesManager)
            {
                ApplicationArea = All;
                Caption = 'Sales Managers';
                Description = 'CS_VEN_031';
                RunObject = page "ecSales Managers";
            }
        }
    }
}
