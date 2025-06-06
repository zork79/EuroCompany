namespace EuroCompany.BaseApp.Template;
using Microsoft.Purchases.Vendor;
using Microsoft.Foundation.Company;
using EuroCompany.BaseApp.Purchases.Vendor;

tableextension 80110 "ecVendor Templ." extends "Vendor Templ."
{
    fields
    {
        field(50100; "ecElect. Company Type"; Code[2])
        {
            Caption = 'Elect. Company Type';
            TableRelation = "Company Types".Code;
        }
        field(50101; "ecVendor Classification"; Code[20])
        {
            Caption = 'Classificazione Fornitore';
            TableRelation = "ecVendor Classification".Code;
        }
        field(50102; "ecDFC Financial Category"; Code[6])
        {
            Caption = 'Categoria Finanziaria DocFinance';
            TableRelation = "APsDFC Financial Category".Code;
        }
        field(50103; "ecDefault Shipping Profile"; Code[20])
        {
            Caption = 'Default Shipping Profile';
            TableRelation = "AltAWPShipping Profile".Code;
        }
    }
}