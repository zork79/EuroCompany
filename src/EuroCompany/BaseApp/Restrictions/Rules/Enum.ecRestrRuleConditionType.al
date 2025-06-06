namespace EuroCompany.BaseApp.Restrictions.Rules;

enum 50009 "ecRestr. Rule Condition Type"
{
    //Description = 'CS_PRO_011';
    Extensible = false;

    value(0; "Value")
    {
        Caption = 'Value';
    }
    value(1; "Filter")
    {
        Caption = 'Filter';
    }
    value(5; "Date Formula")
    {
        Caption = 'Date Formula';
    }
}
