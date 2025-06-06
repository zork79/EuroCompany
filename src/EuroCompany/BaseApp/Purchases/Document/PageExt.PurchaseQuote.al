namespace EuroCompany.BaseApp.Purchases.Document;

using Microsoft.Purchases.Document;

pageextension 80158 "Purchase Quote" extends "Purchase Quote"
{
    layout
    {
        addlast(content)
        {
            group(CustomAttributes)
            {
                Caption = 'Custom attributes';
                Editable = awpPageEditable;

                field("ecVendor Classification"; Rec."ecVendor Classification")
                {
                    ApplicationArea = All;
                    Description = 'CS_ACQ_013';
                }
            }
        }
    }
}
