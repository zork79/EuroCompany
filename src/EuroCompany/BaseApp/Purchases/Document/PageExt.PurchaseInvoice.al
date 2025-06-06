namespace EuroCompany.BaseApp.Purchases.Document;

using Microsoft.Purchases.Document;
using EuroCompany.BaseApp.Setup;
using Microsoft.Purchases.History;

pageextension 80105 "Purchase Invoice" extends "Purchase Invoice"
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

                field("ecVendor Classification"; Rec."ecVendor Classification")
                {
                    ApplicationArea = All;
                    Description = 'CS_ACQ_013';
                }
                // group(CustomDeclaration)
                // {
                //     Caption = 'Custom declaration';
                //     // Visible = EnableCustomDecl;

                //     field("ecNo. Invoice Cust. Decl.";
                //     Rec."ecNo. Invoice Cust. Decl.")
                //     {
                //         ApplicationArea = All;

                //         trigger OnDrillDown()
                //         var
                //             PurchInvHeader: Record "Purch. Inv. Header";
                //             PostedPurchInvoices: Page "Posted Purchase Invoices";
                //         begin
                //             PurchInvHeader.Reset();
                //             // PurchInvHeader.SetRange("Operation Type", ecGeneralSetup."No. Series Cust. Declaration");
                //             if PurchInvHeader.FindSet() then begin
                //                 PostedPurchInvoices.SetTableView(PurchInvHeader);
                //                 PostedPurchInvoices.SetRecord(PurchInvHeader);
                //                 PostedPurchInvoices.LookupMode(true);
                //                 if PostedPurchInvoices.RunModal() = Action::LookupOK then begin
                //                     PostedPurchInvoices.GetRecord(PurchInvHeader);
                //                     Rec.Validate("ecNo. Invoice Cust. Decl.", PurchInvHeader."No.");
                //                     Rec.Modify();
                //                 end;
                //             end;
                //         end;
                //     }
                // }
            }
        }
        addafter("On Hold")
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