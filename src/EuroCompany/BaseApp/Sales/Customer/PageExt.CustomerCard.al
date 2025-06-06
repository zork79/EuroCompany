namespace EuroCompany.BaseApp.Sales.Customer;

using EuroCompany.BaseApp.Sales;
using EuroCompany.BaseApp.Sales.AdvancedTrade;
using Microsoft.Sales.Customer;
using EuroCompany.BaseApp.Inventory.ItemCatalog;

pageextension 80058 "Customer Card" extends "Customer Card"
{
    layout
    {
        addbefore(AltAWP_Main)
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom attributes';
                Editable = awpPageEditable;

                field("ecShort Name"; Rec."ecShort Name")
                {
                    ApplicationArea = All;
                    Description = 'GAP_VEN_001';
                }
                field(ecInsurance; Rec.ecInsurance)
                {
                    ApplicationArea = All;
                    Description = 'CS_LOG_001';
                }
                field("ecPeriod Exc.Max Ship.Date"; Rec."ecPeriod Exc.Max Ship.Date")
                {
                    ApplicationArea = All;
                    Description = 'CS_LOG_001';
                }
                field("ecDefault Priority Code"; Rec."ecDefault Priority Code")
                {
                    ApplicationArea = All;
                    Description = 'CS_LOG_001';
                }
                field("ecAllow Partial Picking/Ship."; Rec."ecAllow Partial Picking/Ship.")
                {
                    ApplicationArea = All;
                    Description = 'CS_LOG_001';
                }
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
                    Importance = Additional;
                }
                field("ecGroup Ship By Prod. Segment"; Rec."ecGroup Ship By Prod. Segment")
                {
                    ApplicationArea = All;
                    Description = 'CS_VEN_033';
                }
                field("ecGroup Inv. By Prod. Segment"; Rec."ecGroup Inv. By Prod. Segment")
                {
                    ApplicationArea = All;
                    Description = 'CS_VEN_033';
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
                //#229
                field("ecMember's CPR Code"; Rec."ecMember's CPR Code")
                {
                    ApplicationArea = All;
                }
                //#229
                field("Office Manager"; Rec."Office Manager")
                {
                    ApplicationArea = All;
                    Description = 'GAP_Issue_445';
                }
                field("Name Office Manager"; Rec."Name office manager")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = true;
                    Description = 'GAP_Issue_445';
                }
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
