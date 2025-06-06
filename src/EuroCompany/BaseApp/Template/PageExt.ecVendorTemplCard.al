namespace EuroCompany.BaseApp.Template;
using Microsoft.Purchases.Vendor;

pageextension 80221 "ecVendor Templ. Card" extends "Vendor Templ. Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("ecElect. Company Type"; Rec."ecElect. Company Type")
            {
                ApplicationArea = All;
            }
            field("ecVendor Classification"; Rec."ecVendor Classification")
            {
                ApplicationArea = All;
            }
            field("ecDFC Financial Category"; Rec."ecDFC Financial Category")
            {
                ApplicationArea = All;
            }
            field("ecDefault Shipping Profile"; Rec."ecDefault Shipping Profile")
            {
                ApplicationArea = All;
            }
        }
    }
}