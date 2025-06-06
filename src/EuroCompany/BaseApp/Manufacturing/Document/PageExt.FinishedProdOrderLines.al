namespace EuroCompany.BaseApp.Manufacturing.Document;

using Microsoft.Manufacturing.Document;

pageextension 80224 "Finished Prod. Order Lines" extends "Finished Prod. Order Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("ecPrevalent Operation Type"; Rec."ecPrevalent Operation Type")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_039';
                Visible = false;
            }
            field("ecPrevalent Operation No."; Rec."ecPrevalent Operation No.")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_039';
                Visible = false;
            }
            field("ecOutput Lot No."; Rec."ecOutput Lot No.")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_035';
                Editable = false;
            }
            field("ecOutput Lot Due Date"; Rec."ecOutput Lot Exp. Date")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_035';
                Editable = false;
            }
            field("ecOutput Lot Ref. Date"; Rec."ecOutput Lot Ref. Date")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_035';
                Visible = false;
                Editable = false;
            }
            field("ecSend-Ahead Quantity"; Rec."ecSend-Ahead Quantity")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_018';
                Editable = false;
                Visible = false;
            }
            field("ecPlanning Notes"; Rec."ecPlanning Notes")
            {
                ApplicationArea = All;
                Description = 'GAP_PRO_013';
                Editable = false;
            }
            field("ecProduction Notes"; Rec."ecProduction Notes")
            {
                ApplicationArea = All;
                Description = 'GAP_PRO_013';
                Editable = false;
            }
        }
    }
}
