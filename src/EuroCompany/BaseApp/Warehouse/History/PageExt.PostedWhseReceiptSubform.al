namespace EuroCompany.BaseApp.Warehouse.History;

using Microsoft.Warehouse.History;

pageextension 80073 "Posted Whse. Receipt Subform" extends "Posted Whse. Receipt Subform"
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
}
