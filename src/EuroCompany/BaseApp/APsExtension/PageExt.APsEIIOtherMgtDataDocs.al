namespace EuroCompany.BaseApp.APsExtension;
using EuroCompany.BaseApp.Setup;

pageextension 80014 "APsEII Other Mgt. Data Docs." extends "APsEII Other Mgt. Data Docs."
{
    actions
    {
        addlast(Processing)
        {
            action(SuggestDeliveryPoint)
            {
                ApplicationArea = All;
                Caption = 'Suggest Delivery Point';
                Image = Suggest;

                trigger OnAction()
                var
                    DeliveryPointSetupMgt: Codeunit "Delivery Point Setup Mgt";
                begin
                    DeliveryPointSetupMgt.SuggestDeliveryPoint(Rec)
                end;
            }
        }
    }
}