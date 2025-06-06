namespace EuroCompany.BaseApp.Purchases.Vendor;

using EuroCompany.BaseApp.Purchases.Vendor;

page 50055 "ecVendor Classifications"
{
    ApplicationArea = All;
    Caption = 'Vendor Classifications';
    Description = 'CS_ACQ_013';
    PageType = List;
    SourceTable = "ecVendor Classification";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }
}
