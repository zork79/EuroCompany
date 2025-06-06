namespace EuroCompany.BaseApp.Sales.History;

using Microsoft.Sales.History;

pageextension 80100 "Posted Sales Credit Memo" extends "Posted Sales Credit Memo"
{
    layout
    {
        addlast(content)
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom Attributes';

                field("ecProduct Segment No."; Rec."ecProduct Segment No.")
                {
                    ApplicationArea = All;
                    Description = 'CS_VEN_032';
                    Editable = false;
                }
                field("ecProduct Segment Description"; Rec."ecProduct Segment Description")
                {
                    ApplicationArea = All;
                    Description = 'CS_VEN_032';
                    DrillDown = false;
                    Editable = false;
                    Importance = Additional;
                }
            }
        }
        addafter("Document Date")
        {
            field("ecRef. Date For Calc. Due Date"; Rec."ecRef. Date For Calc. Due Date")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
        }
    }
}
