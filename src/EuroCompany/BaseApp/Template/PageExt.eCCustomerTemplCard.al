namespace EuroCompany.BaseApp.Template;
using Microsoft.Sales.Customer;

pageextension 80219 "eCCustomer Templ. Card" extends "Customer Templ. Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("eCBilling Periodicity"; Rec."eCBilling Periodicity")
            {
                ApplicationArea = All;
            }
            field("eCDefault Shipping Profile"; Rec."eCDefault Shipping Profile")
            {
                ApplicationArea = All;
            }
            field("eCDFC Financial Category"; Rec."eCDFC Financial Category")
            {
                ApplicationArea = All;
            }
            field(ecActivity; Rec.ecActivity)
            {
                ApplicationArea = All;
            }
            field("eCCustomer E-I Type"; Rec."eCCustomer E-I Type")
            {
                ApplicationArea = All;
            }
            field("eCGroup Inv. by Sell Code"; Rec."eCGroup Inv. by Sell Code")
            {
                ApplicationArea = All;
            }
            field("eCPS. Doc. Default Layout"; Rec."eCPS. Doc. Default Layout")
            {
                ApplicationArea = All;
            }
            field("ecPrint Item Tracking"; Rec."ecPrint Item Tracking")
            {
                ApplicationArea = All;
            }
            field("eCPrint Tariff No."; Rec."eCPrint Tariff No.")
            {
                ApplicationArea = All;
            }
            field("eCPrint Item Reference"; Rec."eCPrint Item Reference")
            {
                ApplicationArea = All;
            }
            field("ecGroup Ship By Prod. Segment"; Rec."ecGroup Ship By Prod. Segment")
            {
                ApplicationArea = All;
            }
            field("ecGroup Inv. By Prod. Segment"; Rec."ecGroup Inv. By Prod. Segment")
            {
                ApplicationArea = All;
            }
        }
    }
}