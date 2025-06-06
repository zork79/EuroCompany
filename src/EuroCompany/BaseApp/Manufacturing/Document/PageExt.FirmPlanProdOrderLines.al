namespace EuroCompany.BaseApp.Manufacturing.Document;

using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Manufacturing.Document;

pageextension 80051 "Firm Plan. Prod. Order Lines" extends "Firm Planned Prod. Order Lines"
{
    layout
    {
        modify("Routing No.")
        {
            Editable = false;
        }

        addlast(Control1)
        {
            field("ecProduction Process Type"; Rec."ecProduction Process Type")
            {
                ApplicationArea = All;
                Editable = false;
                Description = 'CS_QMS_011';
                DrillDown = false;
                Visible = false;
            }
            field("ecPlanning Notes"; Rec."ecPlanning Notes")
            {
                ApplicationArea = All;
                Description = 'GAP_PRO_013';

                trigger OnAssistEdit()
                begin
                    Rec.EditTextField(Rec, Rec.FieldNo("ecPlanning Notes"));
                end;
            }
            field("ecProduction Notes"; Rec."ecProduction Notes")
            {
                ApplicationArea = All;
                Description = 'GAP_PRO_013';

                trigger OnAssistEdit()
                begin
                    Rec.EditTextField(Rec, Rec.FieldNo("ecPlanning Notes"));
                end;
            }
            field("ecSend-Ahead Quantity"; Rec."ecSend-Ahead Quantity")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_018';
                Editable = false;
                Visible = false;
            }
        }
    }
}
