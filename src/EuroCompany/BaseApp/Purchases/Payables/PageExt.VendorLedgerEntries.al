namespace EuroCompany.BaseApp.Purchases.Payables;

using Microsoft.Purchases.Payables;
using EuroCompany.BaseApp.Setup;
using Microsoft.Purchases.History;

pageextension 80103 "Vendor Ledger Entries" extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("Document Date")
        {
            field("ecRef. Date For Calc. Due Date"; Rec."ecRef. Date For Calc. Due Date")
            {
                ApplicationArea = All;
            }
            field("ecApplies-to ID Customs Agency"; Rec."ecApplies-to ID Customs Agency")
            {
                ApplicationArea = All;
                Description = 'CS_AFC_013';
            }
            field("ecNotes payment suspension"; Rec."ecNotes payment suspension")
            {
                ApplicationArea = All;
                Description = 'CS_AFC_019';
            }
        }
        // addlast(Control1)
        // {
        //     field("ecNo. Invoice Cust. Decl."; Rec."ecNo. Invoice Cust. Decl.")
        //     {
        //         ApplicationArea = All;
        //         // Visible = EnableCustomDecl;

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

    actions
    {
        addafter("Detailed &Ledger Entries")
        {
            action("Colleague Mov. (Customs Doc.)")
            {
                Caption = 'Colleague Mov. (Customs Doc.)';
                Description = 'CS_AFC_013';
                ApplicationArea = All;
                Image = ApplyEntries;

                trigger OnAction()
                var
                    CustomsApplyVendorEntries: Page "ecCustoms Apply Vendor Entries";
                begin
                    Clear(CustomsApplyVendorEntries);
                    CustomsApplyVendorEntries.AssigneVariables(Rec);
                    CustomsApplyVendorEntries.SetVendLedgEntry(Rec);
                    CustomsApplyVendorEntries.Run();
                end;
            }
            action("UnApply Mov. (Customs Doc.)")
            {
                Caption = 'UnApply Mov. (Customs Doc.)';
                Description = 'CS_AFC_013';
                ApplicationArea = All;
                Image = UnApply;

                trigger OnAction()
                var
                    VendorLedgerEntry: Record "Vendor Ledger Entry";
                begin
                    if Rec."ecApplies-to ID Customs Agency" <> '' then begin
                        VendorLedgerEntry.SetRange("ecApplies-to ID Customs Agency", Rec."ecApplies-to ID Customs Agency");
                        if VendorLedgerEntry.FindSet() then
                            repeat
                                VendorLedgerEntry."ecApplies-to ID Customs Agency" := '';
                                VendorLedgerEntry."Applies-to ID" := '';
                                VendorLedgerEntry.Modify(false);
                            until VendorLedgerEntry.Next() = 0;
                    end;
                    // CurrPage.SetSelectionFilter(Rec);
                    // if Rec.FindSet() then begin
                    //     repeat
                    //         Rec."ecApplies-to ID Customs Agency" := '';
                    //         Rec."Applies-to ID" := '';
                    //         Rec.Modify();
                    //     until Rec.Next() = 0;
                    // end;
                    Rec.SetRange("Entry No.");
                end;
            }
            action("Connected Movements (Customs Doc.)")
            {
                Caption = 'Connected Movements (Customs Doc.)';
                Description = 'CS_AFC_013';
                ApplicationArea = All;
                Image = Approval;
                // RunObject = Page "eCCustomAgencyVendorEntrCustAg";

                trigger OnAction()
                var
                    eCCustomAgencyVendorEntrCustAg: Page eCCustomAgencyVendorEntrCustAg;
                begin
                    eCCustomAgencyVendorEntrCustAg.AssigneVariables(Rec);
                    eCCustomAgencyVendorEntrCustAg.Run();
                end;
            }
        }
        // addafter("Ent&ry")
        // {
        //     group(CustomFeatures)
        //     {
        //         Caption = 'Custom Features';

        //         action(ecInvoiceCustDecl)
        //         {
        //             ApplicationArea = All;
        //             Caption = 'Invoice cust. declarations';
        //             Image = ShowChart;

        //             trigger OnAction()
        //             var
        //                 PurchInvHeader: Record "Purch. Inv. Header";
        //                 PostedPurchInvoice: Page "Posted Purchase Invoice";
        //             begin
        //                 PurchInvHeader.Reset();
        //                 PurchInvHeader.SetRange("No.", Rec."ecNo. Invoice Cust. Decl.");
        //                 if PurchInvHeader.FindFirst() then begin
        //                     PostedPurchInvoice.SetTableView(PurchInvHeader);
        //                     PostedPurchInvoice.Run();
        //                 end;
        //             end;
        //         }
        //     }
        // }
        // addlast(Promoted)
        // {
        //     group(CustomFeatures_Promoted)
        //     {
        //         Caption = 'Custom Features';

        //         actionref(ecUpdateLogisticInfo_Promoted; ecInvoiceCustDecl) { }
        //     }
        // }
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