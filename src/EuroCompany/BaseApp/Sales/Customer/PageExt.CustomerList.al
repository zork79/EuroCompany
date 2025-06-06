namespace EuroCompany.BaseApp.Sales.Customer;

using EuroCompany.BaseApp.Sales;
using EuroCompany.BaseApp.Sales.AdvancedTrade;
using Microsoft.Sales.Customer;
using EuroCompany.BaseApp.Inventory.ItemCatalog;

pageextension 80075 "Customer List" extends "Customer List"
{
    layout
    {
        addlast(Control1)
        {
            field("ecSales Manager Code"; Rec."ecSales Manager Code")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_031';
            }
            field("ecSales Manager Name"; Rec."ecSales Manager Name")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_031';
                DrillDown = false;
            }
            field(ecActivity; Rec.ecActivity)
            {
                ApplicationArea = All;
            }
            field("ecDescription Activity"; Rec."ecDescription Activity")
            {
                ApplicationArea = All;
            }
            field("ecCommercial Area"; Rec."ecCommercial Area")
            {
                ApplicationArea = All;
            }
            field("ecDescription Commercial Area"; Rec."ecDescription Commercial Area")
            {
                ApplicationArea = All;
            }
            field("ecBalance Credit Insured"; Rec."ecBalance Credit Insured")
            {
                ApplicationArea = All;

                trigger OnDrillDown()
                var
                    SalesFunctions: Codeunit "ecSales Functions";
                begin
                    SalesFunctions.DrillDownBalanceCreditInsuredAmountLCY(Rec);
                end;
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            group(ecCustomFeaturesActGrp)
            {
                Caption = 'Custom Features';

                action(ecItemSettingsAct)
                {
                    ApplicationArea = All;
                    Caption = 'Item Customer Details';
                    Description = 'GAP_PRO_001';
                    Image = UserSetup;

                    trigger OnAction()
                    var
                        lItemCustomerDetails: Page "ecItem Customer Details";
                    begin
                        if (Rec."No." <> '') then begin
                            Clear(lItemCustomerDetails);
                            lItemCustomerDetails.SetCustomerFilters(Rec."No.", true);
                            lItemCustomerDetails.Run();
                        end;
                    end;
                }

                action(ecProductSegments)
                {
                    ApplicationArea = All;
                    Caption = 'Product Segments';
                    Description = 'CS_VEN_032';
                    Image = ItemLines;
                    RunObject = page "ecCustomer Product Segments";
                    RunPageLink = "Customer No." = field("No.");
                }
            }
        }

        addlast(Category_Process)
        {
            group(ecCustomFeaturesActGrp_Promoted)
            {
                Caption = 'Custom Features';

                actionref(ecItemSettingsActPromoted; ecItemSettingsAct) { } //GAP_PRO_001';
                actionref(ecProductSegmentsPromoted; ecProductSegments) { } //CS_VEN_032';
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        SalesFunctions: Codeunit "ecSales Functions";
    begin
        SalesFunctions.GetBalanceCreditInsuredAmountLCY(Rec);
    end;
}
