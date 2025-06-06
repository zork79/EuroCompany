namespace EuroCompany.BaseApp.Inventory.Item;

using EuroCompany.BaseApp.Inventory.ItemCatalog;
using EuroCompany.BaseApp.Manufacturing.Routing;
using Microsoft.Inventory.Item;

pageextension 80044 "Item List" extends "Item List"
{
    layout
    {
        addlast(Control1)
        {
            field("ecSend-Ahead Quantity"; Rec."ecSend-Ahead Quantity")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_044';
            }
            field(ecBio; Rec.ecBio)
            {
                ApplicationArea = All;
                Description = 'GAP_VEN_002';
                Visible = false;
            }
            field("ecProduct Line"; Rec."ecProduct Line")
            {
                ApplicationArea = All;
                Description = 'GAP_VEN_002';
                Visible = false;
            }
            field("ecSpecies Type"; Rec."ecSpecies Type")
            {
                ApplicationArea = All;
                Description = 'GAP_VEN_002';
                Visible = false;
            }
            field(ecSpecies; Rec.ecSpecies)
            {
                ApplicationArea = All;
                Description = 'GAP_VEN_002';
                Visible = false;
            }
            field(ecTreatment; Rec.ecTreatment)
            {
                ApplicationArea = All;
                Description = 'GAP_VEN_002';
                Visible = false;
            }
            field("ecBrand Type"; Rec."ecBrand Type")
            {
                ApplicationArea = All;
                Description = 'GAP_VEN_002';
                Visible = false;
            }
            field(ecBrand; Rec.ecBrand)
            {
                ApplicationArea = All;
                Description = 'GAP_VEN_002';
                Visible = false;
            }
            field("ecCommercial Line"; Rec."ecCommercial Line")
            {
                ApplicationArea = All;
                Description = 'GAP_VEN_002';
                Visible = false;
            }
            field(ecVariety; Rec.ecVariety)
            {
                ApplicationArea = All;
                Description = 'GAP_VEN_002';
                Visible = false;
            }
            field(ecGauge; Rec.ecGauge)
            {
                ApplicationArea = All;
                Description = 'GAP_VEN_002';
                Visible = false;
            }
            field("ecWeight in Grams"; Rec."ecWeight in Grams")
            {
                ApplicationArea = All;
                Description = 'GAP_VEN_002';
                Visible = false;
            }
            field(ecBand; Rec.ecBand)
            {
                ApplicationArea = All;
                Description = 'CS_ACQ_018';
            }
            field(UnitsPerPallet; (Rec."ecNo. Of Units per Layer" * Rec."ecNo. of Layers per Pallet"))
            {
                ApplicationArea = All;
                Caption = 'Units per pallet';
                Description = 'GAP_PRO_001';
                Editable = false;
            }
            field("ecNo. Of Units per Layer"; Rec."ecNo. Of Units per Layer")
            {
                ApplicationArea = All;
                Description = 'GAP_PRO_001';
            }
            field("ecNo. of Layers per Pallet"; Rec."ecNo. of Layers per Pallet")
            {
                ApplicationArea = All;
                Description = 'GAP_PRO_001';
            }
            field("Expiration Calculation"; Rec."Expiration Calculation")
            {
                ApplicationArea = All;
                Description = 'GAP_PRO_001';
            }
            field("ecCalc. for Max Ship. Date"; Rec."ecCalc. for Max Usable Date")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_008';
            }
            //#376
            field("ecJob No."; Rec."ecJob No.")
            {
                ApplicationArea = All;
            }
            field("ecJob No. Description"; Rec."ecJob No. Description")
            {
                ApplicationArea = All;
            }
            field("ecJob Task No."; Rec."ecJob Task No.")
            {
                ApplicationArea = All;
            }
            field("ecJob Task Description"; Rec."ecJob Task Description")
            {
                ApplicationArea = All;
            }
            //#376
        }
    }
    actions
    {

        addlast(processing)
        {
            group(ecCustomFeaturesActGrp)
            {
                Caption = 'Custom Features';

                group(ecItemActGrp)
                {
                    Caption = 'Item';
                    Image = Item;

                    action(ecCustomerSettingsAct)
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
                                lItemCustomerDetails.SetItemFilters(Rec."No.", '', true);
                                lItemCustomerDetails.Run();
                            end;
                        end;
                    }
                }

                group(ecProductionActGrp)
                {
                    Caption = 'Production';
                    Image = Production;

                    action(ecAlternativeRoutingAct)
                    {
                        ApplicationArea = All;
                        Caption = 'Alternative routing';
                        Description = 'GAP_PRO_003';
                        Image = RoutingVersions;

                        trigger OnAction()
                        var
                            lAlternativeRoutingforItem: Record "ecAlternative Routing for Item";
                            lAlternativeRoutingforItemsPage: Page "ecAlternative Rtng for Items";
                        begin
                            //GAP_PRO_003-s
                            Clear(lAlternativeRoutingforItem);
                            lAlternativeRoutingforItem.FilterGroup(2);
                            lAlternativeRoutingforItem.SetRange("Item No.", Rec."No.");
                            lAlternativeRoutingforItem.FilterGroup(0);

                            Clear(lAlternativeRoutingforItemsPage);
                            lAlternativeRoutingforItemsPage.SetTableView(lAlternativeRoutingforItem);
                            lAlternativeRoutingforItemsPage.RunModal();
                            //GAP_PRO_003-e
                        end;
                    }
                    action(ecByProductRelations)
                    {
                        ApplicationArea = All;
                        Caption = 'By Product relations';
                        Description = 'CS_PRO_041_BIS';
                        Enabled = Rec."ecBy Product Item";
                        Image = Relationship;

                        trigger OnAction()
                        var
                            lByProductItemRelations_Page: Page "ecBy Product Item Relations";
                        begin
                            //CS_PRO_041_BIS-s
                            lByProductItemRelations_Page.SetPageDataView(Rec);
                            lByProductItemRelations_Page.RunModal();
                            //CS_PRO_041_BIS-e
                        end;
                    }
                }
            }
        }

        addlast(Promoted)
        {
            group(ecCustomFeaturesPromotedActGrp)
            {
                Caption = 'Custom Features';

                group(ecItemActGrp_Promoted)
                {
                    Caption = 'Item';
                    Image = Item;

                    actionref(ecCustomerSettings_Promoted; ecCustomerSettingsAct) { }
                }

                group(ecProductionActGrp_Promoted)
                {
                    Caption = 'Production';
                    Image = Production;

                    actionref(ecAlternativeRoutingActecAlternativeRoutingAct; ecAlternativeRoutingAct) { }
                    actionref(ecByProductRelationsPromoted; ecByProductRelations) { }
                }
            }
        }
    }
}
