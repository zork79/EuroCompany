namespace EuroCompany.BaseApp.Purchases.Vendor;

page 50081 "ecVendor Rating Codes"
{
    ApplicationArea = All;
    Caption = 'Vendor Rating Codes';
    Description = 'CS_QMS_009';
    PageType = List;
    SourceTable = "ecVendor Rating Code";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Code"; Rec."Code") { }
                field(Description; Rec.Description) { }
            }
        }
    }
}
