namespace EuroCompany.BaseApp.Warehouse.Document;

using EuroCompany.BaseApp.Purchases.Document;
using Microsoft.Purchases.Document;
using Microsoft.Warehouse.Document;

pageextension 80072 "Whse. Receipt Subform" extends "Whse. Receipt Subform"
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
        addafter("&Line")
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
                        lPurchaseLine: Record "Purchase Line";
                        lPurchaseFunctions: Codeunit "ecPurchase Functions";
                    begin
                        //CS_ACQ_013-s
                        if lPurchaseLine.Get(Rec."Source Subtype", Rec."Source No.", Rec."Source Line No.") then begin
                            lPurchaseFunctions.UpdateLogInfoOnPurchLine(lPurchaseLine);
                            CurrPage.Update(true);
                        end;
                        //CS_ACQ_013-e
                    end;
                }
            }
        }
    }
}
