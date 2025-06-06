namespace EuroCompany.BaseApp.Purchases.Vendor;

using Microsoft.Purchases.Vendor;

pageextension 80223 "Vendor Lookup" extends "Vendor Lookup"
{
    layout
    {
        addlast(Group)
        {
            field("ecVendor Classification"; Rec."ecVendor Classification")
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_013';
            }
            field("ecVendor Rating Code"; Rec."ecVendor Rating Code")
            {
                ApplicationArea = All;
                Description = 'CS_QMS_009';
            }
        }
    }
}
