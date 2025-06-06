namespace EuroCompany.BaseApp.Manufacturing.Capacity;

using Microsoft.Manufacturing.Capacity;

tableextension 80002 "Calendar Entry" extends "Calendar Entry"
{
    fields
    {
        field(50000; "ecApplied Calendar Code"; Code[10])
        {
            Caption = 'Applied Calendar Code';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_018';
            Editable = false;
        }
    }
}
