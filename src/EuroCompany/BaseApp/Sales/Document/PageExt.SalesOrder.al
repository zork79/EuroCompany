namespace EuroCompany.BaseApp.Sales.Document;

using EuroCompany.BaseApp.Sales;
using EuroCompany.BaseApp.Sales.AdvancedTrade;
using Microsoft.Sales.Document;

pageextension 80079 "Sales Order" extends "Sales Order"
{
    layout
    {
        modify("Work Description")
        {
            Visible = false;
        }
        addlast(General)
        {
            group(ecGeneral_Custom)
            {
                Caption = 'Custom Attributes';

                field("ecProduct Segment No."; Rec."ecProduct Segment No.")
                {
                    ApplicationArea = All;
                    Description = 'CS_VEN_032';
                }
                field("ecProduct Segment Description"; Rec."ecProduct Segment Description")
                {
                    ApplicationArea = All;
                    Description = 'CS_VEN_032';
                    DrillDown = false;
                    Importance = Additional;
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
            }
        }
        addafter("Document Date")
        {
            field("ecRef. Date For Calc. Due Date"; Rec."ecRef. Date For Calc. Due Date")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
        }
        addafter(Status)
        {
            field("No. Of Comments"; Rec."No. Of Comments")
            {
                ApplicationArea = All;
                BlankZero = true;
                Description = 'CS_VEN_034';
            }
        }
    }
    #region 306
    actions
    {
        addlast(processing)
        {
            group(ecCustomFeaturesActGrp)
            {
                Caption = 'Custom Features';

                action(ecSalesOrderPriceCheck)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Order Price Check';
                    Image = CheckList;
                    RunObject = page "ecSales Order Price Check";
                    RunPageLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                }
                action(ecRecalBOMPriceKitKitExhibitor)
                {
                    ApplicationArea = All;
                    Caption = 'Recalc BOM price Kit/Exhibitor';
                    Description = 'CS_PRO_009';
                    Image = SuggestItemPrice;

                    trigger OnAction()
                    var
                        lSalesFunctions: Codeunit "ecSales Functions";
                    begin
                        //CS_PRO_009-s
                        lSalesFunctions.RecalcSalesDocumentKitExhibitorBOMPrice(Rec, true, false);
                        //CS_PRO_009-e
                    end;
                }
            }
        }

        addlast(Promoted)
        {
            group(ecCustomFeatures_Promoted)
            {
                Caption = 'Custom Features';

                actionref(ecSalesOrderPriceCheck_Promoted; ecSalesOrderPriceCheck) { }
                actionref(ecRecalBOMPriceKitKitExhibitor_Promoted; ecRecalBOMPriceKitKitExhibitor) { }
            }
        }
    }
    #endregion 306
}