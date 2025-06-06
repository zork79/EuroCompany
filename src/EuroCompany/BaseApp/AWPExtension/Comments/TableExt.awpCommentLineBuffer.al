namespace EuroCompany.BaseApp.AWPExtension.Comments;

tableextension 80090 "awpComment Line Buffer" extends "AltAWPComment Line Buffer"
{
    fields
    {
        field(50000; "ecProduct Segment No."; Code[20])
        {
            Caption = 'Product Segment No.';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_034';
            Editable = false;
        }
    }
}
