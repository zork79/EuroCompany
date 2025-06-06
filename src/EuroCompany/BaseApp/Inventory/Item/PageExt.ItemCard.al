namespace EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Inventory.Barcode;
using EuroCompany.BaseApp.Inventory.ItemCatalog;


using EuroCompany.BaseApp.Manufacturing.Routing;
using Microsoft.Inventory.Item;

pageextension 80000 "Item Card" extends "Item Card"
{
    layout
    {
        addafter("Unit Volume")
        {
            field("Units per Parcel"; Rec."Units per Parcel")
            {
                ApplicationArea = All;
                Description = 'CS_LOG_001';
            }
        }
        addlast(content)
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom Attributes';
                Editable = awpPageEditable;

                group(ecGroup1)
                {
                    ShowCaption = false;

                    group(ecUnitofMeasure)
                    {
                        Caption = 'Unit of Measure';

                        field("ecPackage Unit Of Measure"; Rec."ecPackage Unit Of Measure")
                        {
                            ApplicationArea = All;
                            Description = 'CS_PRO_005';
                        }
                        field("ecConsumer Unit of Measure"; Rec."ecConsumer Unit of Measure")
                        {
                            ApplicationArea = All;
                            Description = 'CS_PRO_005';
                        }
                        field("ecNo. Consumer Units per Pkg."; Rec."ecNo. Consumer Units per Pkg.")
                        {
                            ApplicationArea = All;
                            BlankZero = true;
                            Description = 'CS_PRO_005';
                        }
                    }
                    group(ecBarcode)
                    {
                        Caption = 'Barcode';

                        field("ecBarcode Template"; Rec."ecBarcode Template")
                        {
                            ApplicationArea = All;
                            Description = 'CS_PRO_005';
                        }
                    }
                    group(ecProduction)
                    {
                        Caption = 'Purchase & Production';

                        field("ecPurchaser Code"; Rec."ecPurchaser Code")
                        {
                            ApplicationArea = All;
                        }
                        field("ecItem Type"; Rec."ecItem Type")
                        {
                            ApplicationArea = All;
                            Description = 'CS_PRO_043';
                        }
                        field(ecBand; Rec.ecBand)
                        {
                            ApplicationArea = All;
                            Description = 'CS_ACQ_018';
                        }
                        field("ecSend-Ahead Quantity"; Rec."ecSend-Ahead Quantity")
                        {
                            ApplicationArea = All;
                            Description = 'CS_PRO_044';
                        }
                        field("ecBy Product Item"; Rec."ecBy Product Item")
                        {
                            ApplicationArea = All;
                            Description = 'CS_PRO_041_BIS';
                        }
                        field("ecKit/Product Exhibitor"; Rec."ecKit/Product Exhibitor")
                        {
                            ApplicationArea = All;
                            Description = 'CS_PRO_009';
                        }
                    }
                    group(ecInventory)
                    {
                        Caption = 'Inventory';

                        field("ecShort Description"; Rec."ecShort Description")
                        {
                            ApplicationArea = All;
                            Description = 'GAP_VEN_001';
                        }
                        field("ecCommercial Description"; Rec."ecCommercial Description")
                        {
                            ApplicationArea = All;
                            Description = 'GAP_VEN_001';
                        }
                        field("ececPackaging Type"; Rec."ecPackaging Type")
                        {
                            ApplicationArea = All;
                            Description = 'CS_ACQ_018';
                        }
                        field("Pallet Type"; Rec."ecPallet Type")
                        {
                            ApplicationArea = All;
                            Description = 'CS_PRO_001';
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
                        field(ecStackable; Rec.ecStackable)
                        {
                            ApplicationArea = All;
                            Description = 'GAP_PRO_001';
                        }
                        field("ecPick Mandatory Reserved Qty"; Rec."ecPick Mandatory Reserved Qty")
                        {
                            ApplicationArea = All;
                            Description = 'CS_LOG_001';
                        }
                    }
                    group(ecTracking)
                    {
                        Caption = 'Tracking';

                        field(ecCountryRegionOriginCode; Rec."Country/Region of Origin Code")
                        {
                            ApplicationArea = All;
                            Description = 'CS_PRO_011';
                        }
                        field("ecManufacturer Code"; Rec."Manufacturer Code")
                        {
                            ApplicationArea = All;
                            Description = 'CS_PRO_011';
                        }
                        field("ecCalc. for Max Ship. Date"; Rec."ecCalc. for Max Usable Date")
                        {
                            ApplicationArea = All;
                            Description = 'CS_PRO_008';
                        }
                        field("ecMandatory Origin Lot No."; Rec."ecMandatory Origin Lot No.")
                        {
                            ApplicationArea = All;
                            Description = 'CS_PRO_043';
                        }
                        field("ecLot Prod. Info Inherited"; Rec."ecLot Prod. Info Inherited")
                        {
                            ApplicationArea = All;
                            Description = 'CS_PRO_043';
                        }
                        field("ecItem Trk. Summary Mgt."; Rec."ecItem Trk. Summary Mgt.")
                        {
                            ApplicationArea = All;
                            Description = 'CS_PRO_046';
                        }
                    }
                }
                group(ecGroup2)
                {
                    ShowCaption = false;

                    group(ecCharacteristics)
                    {
                        Caption = 'Characteristics';

                        field(Bio; Rec.ecBio)
                        {
                            ApplicationArea = All;
                            Description = 'GAP_VEN_002';
                        }
                        field("ecProduct Line"; Rec."ecProduct Line")
                        {
                            ApplicationArea = All;
                            Description = 'GAP_VEN_002';
                        }
                        field(ecSpecies; Rec.ecSpecies)
                        {
                            ApplicationArea = All;
                            Description = 'GAP_VEN_002';
                        }
                        field("ecSpecies Type"; Rec."ecSpecies Type")
                        {
                            ApplicationArea = All;
                            Description = 'GAP_VEN_002';
                        }
                        field(ecVariety; Rec.ecVariety)
                        {
                            ApplicationArea = All;
                            Description = 'GAP_VEN_002';
                        }
                        field(ecGauge; Rec.ecGauge)
                        {
                            ApplicationArea = All;
                            Description = 'GAP_VEN_002';
                        }
                        field(ecTreatment; Rec.ecTreatment)
                        {
                            ApplicationArea = All;
                            Description = 'GAP_VEN_002';
                        }
                        field("ecBrand Type"; Rec."ecBrand Type")
                        {
                            ApplicationArea = All;
                            Description = 'GAP_VEN_002';
                        }
                        field(ecBrand; Rec.ecBrand)
                        {
                            ApplicationArea = All;
                            Description = 'GAP_VEN_002';
                        }
                        field("ecCommercial Line"; Rec."ecCommercial Line")
                        {
                            ApplicationArea = All;
                            Description = 'GAP_VEN_002';
                        }
                        field("ecWeight in Grams"; Rec."ecWeight in Grams")
                        {
                            ApplicationArea = All;
                            Description = 'GAP_VEN_002';
                        }
                    }
                }
                group(Job)
                {
                    Caption = 'Job';
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
        }
        modify("Manufacturer Code")
        {
            Description = 'CS_PRO_011';
            Visible = false;
        }
        modify("Country/Region of Origin Code")
        {
            Description = 'CS_PRO_011';
            Visible = false;
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

                    action(ecGenerateBarcodeAct)
                    {
                        ApplicationArea = All;
                        Caption = 'Generate barcode';
                        Description = 'CS_PRO_005';
                        Image = BarCode;

                        trigger OnAction()
                        var
                            lBarcodeFunctions: Codeunit "ecBarcode Functions";
                        begin
                            lBarcodeFunctions.GenerateBarcodeByItemTemplate(Rec."No.", true);
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
        modify("Substituti&ons")
        {
            Description = 'CS_PRO_003';
            Enabled = false;
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

                    actionref(ecGenerateBarcode_Promoted; ecGenerateBarcodeAct) { }
                    actionref(ecCustomerSettings_Promoted; ecCustomerSettingsAct) { }
                }

                group(ecProductionActGrp_Promoted)
                {
                    Caption = 'Production';
                    Image = Production;

                    actionref(ecAlternativeRoutingAct_Promoted; ecAlternativeRoutingAct) { }
                    actionref(ecByProductRelations_Promoted; ecByProductRelations) { }
                }
            }
        }
    }
}
