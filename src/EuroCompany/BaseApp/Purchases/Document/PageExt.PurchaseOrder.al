namespace EuroCompany.BaseApp.Purchases.Document;

using Microsoft.Purchases.Document;

pageextension 80111 "Purchase Order" extends "Purchase Order"
{
    layout
    {
        addafter("Document Date")
        {
            field("ecRef. Date For Calc. Due Date"; Rec."ecRef. Date For Calc. Due Date")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
        }
        addlast(content)
        {
            group(CustomAttributes)
            {
                Caption = 'Custom attributes';
                Editable = awpPageEditable;

                field("ecIncoterms Place"; Rec."ecIncoterms Place")
                {
                    ApplicationArea = All;
                    Description = 'CS_ACQ_013';
                }
                field("ecVendor Classification"; Rec."ecVendor Classification")
                {
                    ApplicationArea = All;
                    Description = 'CS_ACQ_013';
                }
            }
        }
    }
}