namespace EuroCompany.BaseApp.Sales.Comment;

using Microsoft.Sales.Comment;

tableextension 80089 "Sales Comment Line" extends "Sales Comment Line"
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
