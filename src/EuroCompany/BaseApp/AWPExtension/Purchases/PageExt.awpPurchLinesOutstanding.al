namespace EuroCompany.BaseApp.AWPExtension.Purchases;
using EuroCompany.BaseApp.Purchases.Document;

pageextension 80071 "awpPurch. Lines Outstanding" extends "AltAWPPurch. Lines Outstanding"
{
    layout
    {
        addbefore("Line Discount %")
        {
            field("APsComposed Discount"; Rec."APsComposed Discount")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_007_bis';
                Editable = false;
            }
        }
        addlast(Control1)
        {
            field("ecItem Type"; Rec."ecItem Type")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_043';
                DrillDown = false;
                Lookup = false;
                Editable = false;
            }
            field("ecPackaging Type"; Rec."ecPackaging Type")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_018';
                Editable = false;
            }
            field("ecContainer Type"; Rec."ecContainer Type")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_007_bis';
                Editable = false;
            }
            field("ecContainer No."; Rec."ecContainer No.")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_007_bis';
                Editable = false;
            }
            field("ecExpected Shipping Date"; Rec."ecExpected Shipping Date")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_007_bis';
                Editable = false;
            }
            field("ecDelay Reason Code"; Rec."ecDelay Reason Code")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_013';
                Editable = false;
            }
            field("ecTransport Status"; Rec."ecTransport Status")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_013';
                Editable = false;
            }
            field("ecShipping Documentation"; Rec."ecShip. Documentation Status")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_013';
                Editable = false;
            }
            field("ecShiping Doc. Notes"; Rec."ecShiping Doc. Notes")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_013';
                Editable = false;
            }
        }
    }
    actions
    {
        addafter("&Line")
        {
            group(CustomFeatures)
            {
                Caption = 'Custom Features';

                action(ecUpdateLogisticInfo)
                {
                    ApplicationArea = All;
                    Caption = 'Upd. logistic info';
                    Description = 'CS_ACQ_007_bis';
                    Image = Info;

                    trigger OnAction()
                    var
                        lPurchaseFunctions: Codeunit "ecPurchase Functions";
                    begin
                        //CS_ACQ_007_bis-s
                        lPurchaseFunctions.UpdateLogInfoOnPurchLine(Rec);
                        CurrPage.Update(true);
                        //CS_ACQ_007_bis-e
                    end;
                }
            }
        }

        addlast(Promoted)
        {
            actionref(ShowDocument_Promoted; "Show Document") { }

            group(CustomFeatures_Promoted)
            {
                Caption = 'Custom Features';

                actionref(ecUpdateLogisticInfo_Promoted; ecUpdateLogisticInfo) { }
            }
        }
    }
}