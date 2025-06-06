namespace EuroCompany.BaseApp.Sales.History;

using Microsoft.Sales.History;

pageextension 80206 "Posted Sales Invoice - Update" extends "Posted Sales Invoice - Update"
{
    layout
    {
        modify("AltAWPParcel Units")
        {
            Caption = 'No. of logistic units';
            Description = 'CS_LOG_001';
        }
    }
}
