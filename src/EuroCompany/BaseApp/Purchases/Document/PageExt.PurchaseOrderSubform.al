namespace EuroCompany.BaseApp.Purchases.Document;

using Microsoft.Purchases.Document;

pageextension 80067 "Purchase Order Subform" extends "Purchase Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("ecPackaging Type"; Rec."ecPackaging Type")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_018';
            }
            field("ecContainer Type"; Rec."ecContainer Type")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_013';
            }
            field("ecContainer No."; Rec."ecContainer No.")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_013';
            }
            field("ecExpected Shipping Date"; Rec."ecExpected Shipping Date")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_013';
            }
            field("ecDelay Reason Code"; Rec."ecDelay Reason Code")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_013';
            }
            field("ecTransport Status"; Rec."ecTransport Status")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_013';
            }
            field("ecShipping Documentation"; Rec."ecShip. Documentation Status")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_013';
            }
            field("ecShiping Doc. Notes"; Rec."ecShiping Doc. Notes")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_013';
            }
        }
    }

    actions
    {
        addafter("O&rder")
        {
            group(ecCustomFeatures)
            {
                Caption = 'Custom Features';
                Description = 'CS_ACQ_013';

                action(ecUpdateLogisticInfo)
                {
                    ApplicationArea = All;
                    Caption = 'Upd. logistic info';
                    Description = 'CS_ACQ_013';
                    Image = Info;

                    trigger OnAction()
                    var
                        lPurchaseFunctions: Codeunit "ecPurchase Functions";
                    begin
                        //CS_ACQ_013-s
                        lPurchaseFunctions.UpdateLogInfoOnPurchLine(Rec);
                        CurrPage.Update(true);
                        //CS_ACQ_013-e
                    end;
                }
            }
        }
    }
}
