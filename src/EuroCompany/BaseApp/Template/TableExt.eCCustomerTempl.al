namespace EuroCompany.BaseApp.Template;
using Microsoft.Sales.Customer;
using EuroCompany.BaseApp.Activity;

tableextension 80111 "eCCustomer Templ." extends "Customer Templ."
{
    fields
    {
        field(50101; "eCBilling Periodicity"; Option)
        {
            Caption = 'Billing Periodicity';
            OptionMembers = Daily,"Every 7 days","Every 15 days",Monthly;
            OptionCaption = 'Daily,Every 7 days,Every 15 days,monthly';
        }
        field(50102; "eCDefault Shipping Profile"; Code[20])
        {
            Caption = 'Default Shipping Profile';
            TableRelation = "AltAWPShipping Profile".Code;
        }
        field(50103; "eCDFC Financial Category"; Code[6])
        {
            Caption = 'DFC Financial Category';
            TableRelation = "APsDFC Financial Category".Code;
        }
        field(50104; ecActivity; Text[100])
        {
            Caption = 'Activity';
            TableRelation = ecActivity.Code;
        }
        field(50105; "eCCustomer E-I Type"; Option)
        {
            Caption = 'Customer E-I Type';
            OptionMembers = "",PR,PA;
            OptionCaption = ',PR,PA', Locked = true;
        }
        field(50106; "eCGroup Inv. by Sell Code"; Boolean)
        {
            Caption = 'Group Inv. by Sell Code';
        }
        field(50107; "eCPS. Doc. Default Layout"; Option)
        {
            Caption = 'PS. Doc. Default Layout';
            OptionMembers = Completed,"Net prices";
            OptionCaption = 'Completed,Net prices';
        }
        field(50108; "ecPrint Item Tracking"; Option)
        {
            Caption = 'Print Item Tracking';
            OptionMembers = None,Standard,External;
            OptionCaption = 'None,Standard,External';
        }
        field(50109; "eCPrint Tariff No."; Boolean)
        {
            Caption = 'eCPrint Tariff No.';
        }
        field(50110; "eCPrint Item Reference"; Boolean)
        {
            Caption = 'Print Item Reference';
        }
        field(50042; "ecGroup Ship By Prod. Segment"; Boolean)
        {
            Caption = 'ecGroup Ship By Prod. Segment';
        }
        field(50043; "ecGroup Inv. By Prod. Segment"; Boolean)
        {
            Caption = 'Group Invoice by Product Segment';
        }
    }
}