namespace EuroCompany.BaseApp.Sales.Document;

using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Sales;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;

pageextension 80092 "Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        modify("Purchasing Code")
        {
            Visible = true;
        }
        modify("Drop Shipment")
        {
            Visible = true;
        }
        moveafter("AltAWPSuspend Shipment"; "Purchasing Code")
        moveafter("Purchasing Code"; "Drop Shipment")

        addlast(Control1)
        {
            field("ecKit/Exhibitor Recalc. Req."; Rec."ecKit/Exhibitor Recalc. Req.")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_009';
            }
            field("ecKit/Exhib. Manual Price"; Rec."ecKit/Exhib. Manual Price")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_009';
            }
            field("ecKit/Exhibitor Item"; Rec."ecKit/Exhibitor Item")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_009';
            }
            field("ecKit/Exhibitor BOM Entry No."; Rec."ecKit/Exhibitor BOM Entry No.")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_009';
                Visible = false;
            }
            field("ecKit/Exhib. BOM Price Lines"; Rec."ecKit/Exhib. BOM Price Lines")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_009';
            }
            field("ecKit/Exhib. BOM Price Errors"; Rec."ecKit/Exhib. BOM Price Errors")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_009';
            }
            field("ecConsumer Unit of Measure"; Rec."ecConsumer Unit of Measure")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_014';
            }
            field("ecQty. per Consumer UM"; Rec."ecQty. per Consumer UM")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_014';
                HideValue = not ecIsItemLine;
                Visible = false;
            }
            field("ecQuantity (Consumer UM)"; Rec."ecQuantity (Consumer UM)")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_014';
                HideValue = not ecIsItemLine;
            }
            field("ecUnit Price (Consumer UM)"; Rec."ecUnit Price (Consumer UM)")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_014';
                HideValue = not ecIsItemLine;
            }
            field("AltAWPTotal Net Weight"; Rec."AltAWPTotal Net Weight")
            {
                ApplicationArea = All;
                Description = 'GAP_VEN_001';
                HideValue = not ecIsItemLine;
            }
            field("AltAWPTotal Gross Weight"; Rec."AltAWPTotal Gross Weight")
            {
                ApplicationArea = All;
                Description = 'GAP_VEN_001';
                HideValue = not ecIsItemLine;
            }
        }
    }

    actions
    {
        modify(SelectMultiItems)
        {
            Description = 'CS_VEN_032';
            Enabled = false;
            Visible = false;
        }

        addafter(SelectMultiItems)
        {
            action(ecSelectItemsBySegment)
            {
                AccessByPermission = tabledata Item = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Select items';
                Description = 'CS_VEN_032';
                Ellipsis = true;
                Image = NewItem;
                ToolTip = 'Add two or more items from the full list of your inventory items.';

                trigger OnAction()
                var
                    lecSalesFunctions: Codeunit "ecSales Functions";
                begin
                    //CS_VEN_032-VI-s
                    lecSalesFunctions.SelectMultipleItemsForSales(Rec);
                    //CS_VEN_032-VI-e
                end;
            }
        }
        addafter("O&rder")
        {
            group(CustomFeatures)
            {
                Caption = 'Custom features';

                action(KitExhibitorBOMPrice)
                {
                    ApplicationArea = All;
                    Caption = 'Kit/Exhibitor BOM Prices';
                    Description = 'CS_PRO_009';
                    Image = SalesPrices;

                    trigger OnAction()
                    var
                        lKitProdExhibitorItemBOM: Record "ecKit/Prod. Exhibitor Item BOM";
                        lKitProdExhibitorItemBOMPage: Page "ecKit/Prod. Exhibitor Item BOM";
                    begin
                        //CS_PRO_009-s
                        Rec.CalcFields("ecKit/Exhibitor Item");
                        if Rec."ecKit/Exhibitor Item" then begin
                            Clear(lKitProdExhibitorItemBOM);
                            lKitProdExhibitorItemBOM.FilterGroup(2);
                            lKitProdExhibitorItemBOM.SetRange("Entry No.", Rec."ecKit/Exhibitor BOM Entry No.");
                            lKitProdExhibitorItemBOM.FilterGroup(0);
                            if not lKitProdExhibitorItemBOM.IsEmpty then begin
                                Clear(lKitProdExhibitorItemBOMPage);
                                lKitProdExhibitorItemBOMPage.SetTableView(lKitProdExhibitorItemBOM);
                                lKitProdExhibitorItemBOMPage.Run();
                            end;
                        end;
                        //CS_PRO_009-e
                    end;
                }
                action(RecalcKitExhibitorBOMPrice)
                {
                    ApplicationArea = All;
                    Caption = 'Recalc. Kit/Exhibitor BOM prices';
                    Description = 'CS_PRO_009';
                    Image = SuggestItemPrice;

                    trigger OnAction()
                    var
                        lSalesFunctions: Codeunit "ecSales Functions";
                    begin
                        //CS_PRO_009-s
                        lSalesFunctions.CalcAndUpdateSalesLineKitExhibitorBOMPrice(Rec, false, true);
                        //CS_PRO_009-e
                    end;
                }
            }
        }
    }

    var
        ecIsItemLine: Boolean;

    trigger OnAfterGetRecord()
    begin
        //CS_VEN_014-VI-s
        ecIsItemLine := (Rec.Type = Rec.Type::Item);
        //CS_VEN_014-VI-e
    end;
}
