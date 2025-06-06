namespace EuroCompany.BaseApp.Manufacturing.MachineCenter;

using Microsoft.Manufacturing.MachineCenter;

tableextension 80115 "Machine Center" extends "Machine Center"
{
    fields
    {
        field(50000; "ecRemove Log. Units on Pick"; Boolean)
        {
            Caption = 'Remove Logistic Units Ref. on Production Pick';
            DataClassification = CustomerContent;
        }
    }
}
