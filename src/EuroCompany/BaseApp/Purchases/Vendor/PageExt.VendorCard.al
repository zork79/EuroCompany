namespace EuroCompany.BaseApp.Purchases.Vendor;

using Microsoft.Purchases.Vendor;

pageextension 80157 "Vendor Card" extends "Vendor Card"
{
    layout
    {
        addlast(content)
        {
            group(CustomFeatures)
            {
                Caption = 'Custom attributes';

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
        addafter("E-Mail")
        {

            field("eCPEC E-Mail"; Rec."eCPEC E-Mail")
            {
                ApplicationArea = All;
            }
        }
    }
}
