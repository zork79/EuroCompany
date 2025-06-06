namespace EuroCompany.BaseApp.Sales.AdvancedTrade;

using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;

page 50034 "ecSelect Items for Sales"
{
    ApplicationArea = All;
    Caption = 'Select Items';
    DeleteAllowed = false;
    Description = 'CS_VEN_032';
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "ecItem Selection Buffer";
    SourceTableTemporary = true;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    StyleExpr = LineStyleTxt;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    StyleExpr = LineStyleTxt;
                }
                field("Description 2"; Rec."Description 2")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Search Description"; Rec."Search Description")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Sales Unit of Measure"; Rec."Sales Unit of Measure")
                {
                    Editable = false;
                    StyleExpr = LineStyleTxt;
                }
                field("Qty. to Handle"; Rec."Qty. to Handle")
                {
                    BlankZero = true;
                    StyleExpr = LineStyleTxt;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Consumer Unit of Measure"; Rec."Consumer Unit of Measure")
                {
                    Editable = false;
                    StyleExpr = LineStyleTxt;
                }
                field("Qty. to Handle (Consumer UM)"; Rec."Qty. to Handle (Consumer UM)")
                {
                    BlankZero = true;
                    Editable = QtyConsumerUMEditable;
                    StyleExpr = LineStyleTxt;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }

                field("Item Category Code"; Rec."Item Category Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Item Category Description"; Rec."Item Category Description")
                {
                    DrillDown = false;
                    Editable = false;
                    Visible = false;
                }
                field("Product Group Code"; Rec."Product Group Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Product Group Description"; Rec."Product Group Description")
                {
                    DrillDown = false;
                    Editable = false;
                    Visible = false;
                }
                field("Item Reference No."; Rec."Item Reference No.")
                {
                    Editable = false;
                }
                field("Weight in Grams"; Rec."Weight in Grams")
                {
                    Editable = false;
                }
                field("No. Of Units per Layer"; Rec."No. Of Units per Layer")
                {
                    Editable = false;
                }
                field("No. of Layers per Pallet"; Rec."No. of Layers per Pallet")
                {
                    Editable = false;
                }
                field("Number Of Units Per Pallet"; Rec."Number Of Units Per Pallet")
                {
                    Editable = false;
                }
                field("Pallet Type"; Rec."Pallet Type")
                {
                    Editable = false;
                }
                field(Stackable; Rec.Stackable)
                {
                    Editable = false;
                }
                field("EAN-13 Barcode"; Rec."EAN-13 Barcode")
                {
                    Editable = false;
                }
                field("ITF-14 Barcode"; Rec."ITF-14 Barcode")
                {
                    Editable = false;
                }
                field(AltAWPInventory; Temp_ItemAvailabilityBuffer.Inventory)
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo(Inventory));
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    HideValue = HideInventoryInfo;
                    StyleExpr = Inventory_Style;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo(Inventory));
                    end;
                }
                field(AltAWPInventoryOnStock; Temp_ItemAvailabilityBuffer."Inventory in Stock Area")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Inventory in Stock Area"));
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    HideValue = HideInventoryInfo;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Inventory in Stock Area"));
                    end;
                }
                field(AltAWPQtyOnSalesOrders; Temp_ItemAvailabilityBuffer."Qty. on Sales Order")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Sales Order"));
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    HideValue = HideInventoryInfo;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Sales Order"));
                    end;
                }
                field(AltAWPQtyOnComponentLines; Temp_ItemAvailabilityBuffer."Qty. on Component Lines")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Component Lines"));
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    HideValue = HideInventoryInfo;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Component Lines"));
                    end;
                }
                field(AltAWPQtyOnTransferShipments; Temp_ItemAvailabilityBuffer."Qty. on Trans. Ord. Shipment")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Trans. Ord. Shipment"));
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    HideValue = HideInventoryInfo;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Trans. Ord. Shipment"));
                    end;
                }
                field(AltAWPCurrentAvailability; Temp_ItemAvailabilityBuffer."Current Availability")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Current Availability"));
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    HideValue = HideInventoryInfo;
                    StyleExpr = CurrentAvail_Style;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Current Availability"));
                    end;
                }
                field(AltAWPQtyOnPurchOrders; Temp_ItemAvailabilityBuffer."Qty. on Purch. Order")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Purch. Order"));
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    HideValue = HideInventoryInfo;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Purch. Order"));
                    end;
                }

                field(AltAWPQtyOnPurchOrdersAll; Temp_ItemAvailabilityBuffer."Qty. on Purch. Order (All)")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Purch. Order (All)"));
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    HideValue = HideInventoryInfo;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Purch. Order (All)"));
                    end;
                }

                field(AltAWPQtyOnProdOrders; Temp_ItemAvailabilityBuffer."Qty. on Prod. Order")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Prod. Order"));
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    HideValue = HideInventoryInfo;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Prod. Order"));
                    end;
                }
                field(AltAWPQtyOnTransferRcpt; Temp_ItemAvailabilityBuffer."Qty. on Trans. Ord. Receipt")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Trans. Ord. Receipt"));
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    HideValue = HideInventoryInfo;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Qty. on Trans. Ord. Receipt"));
                    end;
                }
                field(AltAWPQtyInTransit; Temp_ItemAvailabilityBuffer."Qty. in Transit")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Qty. in Transit"));
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    HideValue = HideInventoryInfo;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Qty. in Transit"));
                    end;
                }
                field(AltAWPFutureAvailability; Temp_ItemAvailabilityBuffer."Future Availability")
                {
                    Caption = ' ', Locked = true;
                    CaptionClass = Temp_ItemAvailabilityBuffer.GetFieldCaption(Temp_ItemAvailabilityBuffer.FieldNo("Future Availability"));
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    HideValue = HideInventoryInfo;
                    StyleExpr = FutureAvail_Style;

                    trigger OnDrillDown()
                    begin
                        ItemAvailabilityMgt.DrillDownValue(Temp_ItemAvailabilityBuffer, Temp_ItemAvailabilityBuffer.FieldNo("Future Availability"));
                    end;
                }
            }

            field(ExtendedDescription; Rec.Description)
            {
                Editable = false;
                ShowCaption = false;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ItemCardAction)
            {
                AccessByPermission = tabledata Item = r;
                Caption = 'Item card';
                Image = Item;
                RunObject = page "Item Card";
                RunPageLink = "No." = field("No.");
            }
        }

        area(Promoted)
        {
            actionref(ItemCardActionRef; ItemCardAction) { }
        }
    }

    var
        SourceSalesHeader: Record "Sales Header";
        Temp_ItemAvailabilityBuffer: Record "AltAWPItem Availability Buffer" temporary;
        ItemAvailabilityMgt: Codeunit "AltAWPItem Availability Mgt.";

        HideInventoryInfo: Boolean;
        QtyConsumerUMEditable: Boolean;
        CurrentAvail_Style: Text;
        FutureAvail_Style: Text;
        Inventory_Style: Text;
        LineStyleTxt: Text;

    trigger OnAfterGetRecord()
    begin
        LineStyleTxt := '';
        if Rec.Selected then begin
            LineStyleTxt := 'Favorable';
        end;

        QtyConsumerUMEditable := (Rec."Consumer Unit of Measure" <> '');

        RecalculateInventoryValues();
    end;

    local procedure RecalculateInventoryValues()
    var
        lItem: Record Item;
    begin
        HideInventoryInfo := Rec.IsNonInventoriableType();
        Clear(Temp_ItemAvailabilityBuffer);

        if not HideInventoryInfo then begin
            if lItem.Get(Rec."No.") then begin
                ItemAvailabilityMgt.CalcItemAvailability(lItem, Temp_ItemAvailabilityBuffer);
            end;
            Inventory_Style := Temp_ItemAvailabilityBuffer."Inventory Style";
            CurrentAvail_Style := Temp_ItemAvailabilityBuffer."Current Availability Style";
            FutureAvail_Style := Temp_ItemAvailabilityBuffer."Future Availability Style";
        end;
    end;

    internal procedure AddItem(pItemNo: Code[20])
    var
        lItem: Record Item;
    begin
        if lItem.Get(pItemNo) then begin
            AddItem(lItem);
        end;
    end;

    internal procedure AddItem(pItem: Record Item)
    begin
        Rec.SetSourceSalesHeader(SourceSalesHeader);
        Rec.CopyFromItem(pItem);
        Rec.Insert(false);
    end;

    internal procedure ClearSelection()
    begin
        Rec.Reset();
        if not Rec.IsEmpty then begin
            Rec.ModifyAll(Selected, false);
            Rec.ModifyAll("Qty. to Handle", 0);
            Rec.ModifyAll("Qty. to Handle (Consumer UM)", 0);

            Rec.FindFirst();
        end;
    end;

    internal procedure GetSelectedItems(var Temp_pSelectedItems: Record "ecItem Selection Buffer" temporary): Boolean
    begin
        Clear(Temp_pSelectedItems);
        Temp_pSelectedItems.DeleteAll(false);

        Rec.Reset();
        Rec.SetRange(Selected, true);
        if Rec.FindSet() then begin
            repeat
                Temp_pSelectedItems := Rec;
                Temp_pSelectedItems.Insert(false);
            until (Rec.Next() = 0);

            exit(true);
        end;

        exit(false);
    end;

    internal procedure SetSourceSalesHeader(var pSalesHeader: Record "Sales Header")
    begin
        SourceSalesHeader := pSalesHeader;
    end;
}
