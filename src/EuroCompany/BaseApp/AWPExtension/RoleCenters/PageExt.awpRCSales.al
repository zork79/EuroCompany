namespace EuroCompany.BaseApp.AWPExtension.RoleCenters;

using EuroCompany.BaseApp.Sales.AdvancedTrade;

pageextension 80077 "awpRC - Sales" extends "AltAWPRC - Sales"
{
    actions
    {
        addafter(Salespersons)
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
