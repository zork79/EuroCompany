namespace EuroCompany.BaseApp.Purchases.History;

using Microsoft.Purchases.History;
tableextension 80041 "Purch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(50000; "ecRef. Date For Calc. Due Date"; Date)
        {
            Caption = 'Ref. Date For Calc. Due Date';
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin
                if (Rec."ecRef. Date For Calc. Due Date" <> xRec."ecRef. Date For Calc. Due Date") and (xRec."ecRef. Date For Calc. Due Date" <> 0D) then
                    Rec.Validate("Payment Terms Code");
            end;
        }
    }
}