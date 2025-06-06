namespace EuroCompany.BaseApp.Template;
using Microsoft.Purchases.Vendor;

pageextension 80215 "ecVendor Templ. List" extends "Vendor Templ. List"
{
    layout
    {
        addafter(Code)
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
            field(Subcontractor; Rec.Subcontractor)
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