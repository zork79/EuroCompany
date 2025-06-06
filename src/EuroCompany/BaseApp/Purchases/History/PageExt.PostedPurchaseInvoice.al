namespace EuroCompany.BaseApp.Purchases.History;

using Microsoft.Purchases.History;
using EuroCompany.BaseApp.Setup;

pageextension 80107 "Posted Purchase Invoice" extends "Posted Purchase Invoice"
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

                field("ecVendor Classification"; Rec."ecVendor Classification")
                {
                    ApplicationArea = All;
                    Description = 'CS_ACQ_013';
                }

                // group(CustomDeclaration)
                // {
                //     Caption = 'Custom declaration';
                //     // Visible = EnableCustomDecl;

                //     field("ecNo. Invoice Cust. Decl."; Rec."ecNo. Invoice Cust. Decl.")
                //     {
                //         ApplicationArea = All;
                //     }
                // }
            }
        }
        addafter("Related Entry No.")
        {
            field("ecNotes payment suspension"; Rec."ecNotes payment suspension")
            {
                ApplicationArea = All;
                Description = 'CS_AFC_019';
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Clear(EnableCustomDecl);
        // ecGeneralSetup.Get();
        // EnableCustomDecl := ecGeneralSetup."Enable Customs Declarations";
    end;

    var
        ecGeneralSetup: Record "ecGeneral Setup";
    // EnableCustomDecl: Boolean;
}