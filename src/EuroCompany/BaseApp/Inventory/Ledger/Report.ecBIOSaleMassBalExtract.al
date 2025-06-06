namespace EuroCompany.BaseApp.Inventory.Ledger;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.Company;
using Microsoft.Warehouse.History;
using Microsoft.Inventory.Tracking;
using System.Text;

report 50033 "ecBIO Sale Mass. Bal. Extract."
{
    Caption = 'BIO Sale Mass. Balance Extraction';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/EuroCompany/BaseApp/Inventory/Ledger/BIOSaleMassBalExtract.Layout.rdl';

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.", "Lot No.") where("Entry Type" = const(Sale));

            column(Posting_Date_Lbl; "Item Ledger Entry".FieldCaption("Posting Date"))
            {
            }
            column(Item_No_Lbl; "Item Ledger Entry".FieldCaption("Item No."))
            {
            }
            column(Description_Lbl; "Item Ledger Entry".FieldCaption(Description))
            {
            }
            column(Lot_No_Lbl; "Item Ledger Entry".FieldCaption("Lot No."))
            {
            }
            column(Qty_Lbl; "Item Ledger Entry".FieldCaption(Quantity))
            {
            }
            column(UMILbl; UMILbl)
            {
            }
            column(UMFLbl; UMFLbl)
            {
            }
            column(Source_No_Lbl; "Item Ledger Entry".FieldCaption("Source No."))
            {
            }
            column(CustomerNameLbl; CustomerNameLbl)
            {
            }
            column(AltAWPPosted_Document_No_Lbl; "Item Ledger Entry".FieldCaption("AltAWPPosted Document No."))
            {
            }
            column(TitleLbl; TitleLbl)
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Item_No_; "Item No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Lot_No_; "Lot No.")
            {
            }
            column(GlobalQty; GlobalQty)
            {
            }
            column(Unit_of_Measure_Code; "Unit of Measure Code")
            {
            }
            column(UMFQuantity; UMFQuantity)
            {
            }
            column(PurchUnitOfMeasure; PurchUnitOfMeasure)
            {
            }
            column(Source_No_; "Source No.")
            {
            }
            column(CustomerName; CustomerName)
            {
            }
            column(AltAWPPosted_Document_No_; "AltAWPPosted Document No.")
            {
            }
            column(CompInfoName; CompInfo.Name)
            {
            }
            column(WorkDate; WorkDate())
            {
            }
            trigger OnAfterGetRecord()
            var
                PostedWhseShipHdr: Record "Posted Whse. Shipment Header";
                Item: Record Item;
                ItemUnitOfMeasure: Record "Item Unit of Measure";
            begin
                Clear(GlobalQty);
                Clear(CustomerName);
                Clear(BaseQtyPerUnitOfMeasure);
                Clear(PurchQtyPerUnitOfMeasure);
                Clear(UMFQuantity);
                Clear(PurchUnitOfMeasure);

                CalcFields("ecMass Balance Mgt. BIO");

                if not "ecMass Balance Mgt. BIO" then
                    CurrReport.Skip();

                GlobalQty := Abs(Quantity);

                if PostedWhseShipHdr.Get("AltAWPPosted Document No.") then
                    CustomerName := PostedWhseShipHdr."AltAWPShip-to Name";

                if Item.Get("Item No.") then begin
                    if ItemUnitOfMeasure.Get("Item No.", Item."Base Unit of Measure") then
                        BaseQtyPerUnitOfMeasure := ItemUnitOfMeasure."Qty. per Unit of Measure";

                    if ItemUnitOfMeasure.Get("Item No.", Item."Purch. Unit of Measure") then
                        PurchQtyPerUnitOfMeasure := ItemUnitOfMeasure."Qty. per Unit of Measure";

                    UMFQuantity := Abs(BaseQtyPerUnitOfMeasure / PurchQtyPerUnitOfMeasure * Quantity);

                    PurchUnitOfMeasure := Item."Purch. Unit of Measure";
                end;
            end;

            trigger OnPreDataItem()
            begin
                if ItemNo <> '' then
                    SetFilter("Item No.", ItemNo);

                if LotNo <> '' then
                    SetFilter("Lot No.", LotNo);

                if PostingDate <> 0D then
                    SetRange("Posting Date", PostingDate);

                CompInfo.Get();
            end;
        }
    }


    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(ItemNoVar; ItemNo)
                    {
                        Caption = 'Item No.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            Item: Record Item;
                            SelectionFilterManagementCU: Codeunit SelectionFilterManagement;
                            ItemList: Page "Item List";
                        begin
                            Item.Reset();
                            Item.SetRange("ecItem Trk. Summary Mgt.", true);
                            ItemList.SetTableView(Item);
                            ItemList.LookupMode(true);
                            if ItemList.RunModal() = Action::LookupOK then begin
                                ItemList.SetSelectionFilter(Item);
                                Text := SelectionFilterManagementCU.GetSelectionFilterForItem(Item);
                                exit(true);
                            end;
                        end;
                    }
                    field(LotNoVar; LotNo)
                    {
                        Caption = 'Lot No.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            LotNoInfo: Record "Lot No. Information";
                            SelectionFilterManagementCU: Codeunit SelectionFilterManagement;
                            LotNoInfoList: Page "Lot No. Information List";
                            ChooseFirstItemErr: Label 'The lot filter is enabled only if there is a reference item, filter by item first!';
                        begin
                            if ItemNo = '' then
                                Error(ChooseFirstItemErr);

                            LotNoInfo.Reset();
                            LotNoInfo.SetFilter("Item No.", ItemNo);
                            LotNoInfoList.SetTableView(LotNoInfo);
                            LotNoInfoList.LookupMode(true);
                            if LotNoInfoList.RunModal() = Action::LookupOK then begin
                                LotNoInfoList.SetSelectionFilter(LotNoInfo);
                                Text := SelectionFilterManagementCU.GetSelectionFilterForLotNoInformation(LotNoInfo);
                                exit(true);
                            end;
                        end;
                    }
                    field(PostingDateVar; PostingDate)
                    {
                        Caption = 'Posting Date';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    var
        CompInfo: Record "Company Information";
        ItemNo: Code[20];
        LotNo: Code[50];
        PostingDate: Date;
        GlobalQty, BaseQtyPerUnitOfMeasure, PurchQtyPerUnitOfMeasure, UMFQuantity : Decimal;
        PurchUnitOfMeasure: Code[10];
        CustomerName: Text;
        UMILbl: Label 'UMI', Locked = true;
        UMFLbl: Label 'UMF', Locked = true;
        CustomerNameLbl: Label 'Customer name';
        TitleLbl: Label 'Sales Balance BIO';
}