namespace EuroCompany.BaseApp.Manufacturing.Document;

using Microsoft.Manufacturing.Document;
using Microsoft.Manufacturing.Routing;
using EuroCompany.BaseApp.Manufacturing.Routing;

tableextension 80074 "Production Order" extends "Production Order"
{
    fields
    {
        field(50000; "ecIgnore Prod. Restrictions"; Boolean)
        {
            Caption = 'Ignore Productive Restrictions';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_011';
        }
        field(50003; "ecProduction Process Type"; Enum "ecProduction Process Type")
        {
            CalcFormula = lookup("Routing Header"."ecProduction Process Type" where("No." = field("Routing No.")));
            Caption = 'Production Process Type';
            Description = 'CS_QMS_011';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
