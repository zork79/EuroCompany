#region 306
namespace EuroCompany.BaseApp.Sales.AdvancedTrade;

using Microsoft.Sales.Document;
using Microsoft.Finance.Currency;

page 50007 "ecSales Order Price Check"
{
    ApplicationArea = All;
    Caption = 'Sales Order Price Check';
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = where("APsTRD Pricing Det. EntryNo." = filter(<> 0));
    Editable = false;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Type; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line type.';
                    StyleExpr = gStyleExprValue;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the record.';
                    StyleExpr = gStyleExprValue;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the item or service on the line.';
                    StyleExpr = gStyleExprValue;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity of the sales order line.';
                    StyleExpr = gStyleExprValue;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                    StyleExpr = gStyleExprValue;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the price for one unit on the sales line.';
                    StyleExpr = gStyleExprValue;

                    trigger OnDrillDown()
                    begin
                        Rec.ecShowLinePricingDetail();
                    end;
                }
                field(gUnitPriceDiff; gUnitPriceDiff)
                {
                    ApplicationArea = All;
                    Caption = 'Unit Price Difference';
                    ToolTip = 'Specifies the value of the Unit Price Difference field.', Comment = '%';
                    StyleExpr = gStyleExprValue;
                    AutoFormatType = 2;
                    AutoFormatExpression = Rec."Currency Code";
                    BlankZero = true;
                }
                field("ecQuantity (Consumer UM)"; Rec."ecQuantity (Consumer UM)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity (Consumer UM) field.', Comment = '%';
                    StyleExpr = gStyleExprValue;
                }
                field("ecConsumer Unit of Measure"; Rec."ecConsumer Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consumer Unit of Measure field.', Comment = '%';
                    StyleExpr = gStyleExprValue;
                }
                field("ecUnit Price (Consumer UM)"; Rec."ecUnit Price (Consumer UM)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price (Consumer UM) field.', Comment = '%';
                    StyleExpr = gStyleExprValue;

                    trigger OnDrillDown()
                    begin
                        Rec.ecShowLinePricingDetail();
                    end;
                }
                field(gUnitPriceList; gUnitPriceList)
                {
                    ApplicationArea = All;
                    Caption = 'Unit Price List';
                    ToolTip = 'Specifies the value of the Unit Price List field.', Comment = '%';
                    StyleExpr = gStyleExprValue;
                    AutoFormatType = 2;
                    AutoFormatExpression = Rec."Currency Code";
                    BlankZero = true;
                }
                field(gUnitPriceListDiff; gUnitPriceListDiff)
                {
                    ApplicationArea = All;
                    Caption = 'Unit Price List Difference';
                    ToolTip = 'Specifies the value of the Unit Price List Difference field.', Comment = '%';
                    StyleExpr = gStyleExprValue;
                    AutoFormatType = 2;
                    AutoFormatExpression = Rec."Currency Code";
                    BlankZero = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(AdvancedTrade)
            {
                Caption = 'Advanced Trade', Locked = true;

                action(PriceDetail)
                {
                    ApplicationArea = All;
                    Caption = 'Price Detail';
                    Image = PriceWorksheet;

                    trigger OnAction()
                    begin
                        Rec.ecShowLinePricingDetail();
                    end;
                }
                action(RestoreUniPriceList)
                {
                    ApplicationArea = All;
                    Caption = 'Restore Unit Price List';
                    Image = Restore;

                    trigger OnAction()
                    var
                        lSalesLine: Record "Sales Line";
                        lConfirmSingleLbl: Label 'Do you want to restore Unit Price List?';
                        lConfirmSelectionLbl: Label 'Do you want to restore Unit Price List on selected lines?';
                    begin
                        CurrPage.SetSelectionFilter(lSalesLine);

                        if lSalesLine.FindSet() then begin
                            if Confirm(lConfirmSelectionLbl, false) then
                                repeat
                                    lSalesLine.ecRestoreUnitPriceList();
                                until lSalesLine.Next() = 0;
                        end else
                            if Confirm(lConfirmSingleLbl, false) then
                                Rec.ecRestoreUnitPriceList();

                        CurrPage.Update(false);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(AdvancedTrade_Promoted)
            {
                Caption = 'Advanced Trade', Locked = true;

                actionref(PriceDetail_Promoted; PriceDetail) { }
                actionref(RestoreUniPriceList_Promoted; RestoreUniPriceList) { }
            }
        }
    }

    trigger OnAfterGetRecord();
    var
        lCurrency: Record Currency;
        lSalesHeader: Record "Sales Header";
        lDocLinePricing: Record "APsTRD Doc. Line Pricing";
        lMaxToleranceUnitPriceList: Decimal;
    begin
        Clear(lMaxToleranceUnitPriceList);
        Clear(gUnitPriceList);
        Clear(gUnitPriceDiff);
        Clear(gUnitPriceListDiff);

        lDocLinePricing.Reset();
        if not lDocLinePricing.Get(Rec."APsTRD Pricing Det. EntryNo.") then
            lDocLinePricing.Init();

        gUnitPriceList := lDocLinePricing."Unit Price List";

        //if lDocLinePricing."Std. Unit Price" <> 0 then begin
        Rec.GetSalesHeader(lSalesHeader, lCurrency);

        lMaxToleranceUnitPriceList := Rec.ecGetMaxUnitPriceListTolerance();

        gUnitPriceDiff := Rec."Unit Price" - lDocLinePricing."Std. Unit Price";
        gUnitPriceListDiff := Round(gUnitPriceDiff * (Rec."ecUnit Price (Consumer UM)" / Rec."Unit Price"), lCurrency."Unit-Amount Rounding Precision");
        //end;

        if ((gUnitPriceList = 0) and (Rec."Unit Price" <> 0)) or (-gUnitPriceListDiff > lMaxToleranceUnitPriceList) then
            gStyleExprValue := 'Unfavorable'
        else
            gStyleExprValue := '';
    end;

    var
        gUnitPriceList: Decimal;
        gUnitPriceDiff: Decimal;
        gUnitPriceListDiff: Decimal;

    var
        gStyleExprValue: Text;
}
#endregion 306