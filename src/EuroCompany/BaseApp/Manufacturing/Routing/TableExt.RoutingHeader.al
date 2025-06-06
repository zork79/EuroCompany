namespace EuroCompany.BaseApp.Manufacturing.Routing;

using Microsoft.Manufacturing.Routing;

tableextension 80088 "Routing Header" extends "Routing Header"
{
    fields
    {
        field(50000; "ecProduction Process Type"; Enum "ecProduction Process Type")
        {
            Caption = 'Production Process Type';
            DataClassification = CustomerContent;
            Description = 'CS_QMS_011';
        }
    }
}
