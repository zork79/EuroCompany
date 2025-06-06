namespace EuroCompany.BaseApp.System.Security.User;

using System.Security.User;

tableextension 80062 "User Setup" extends "User Setup"
{
    fields
    {
        field(50000; "ecEnable Prod. Order Sched."; Boolean)
        {
            Caption = 'Enabled to schedule prod. orders';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_018';
        }
    }
}
