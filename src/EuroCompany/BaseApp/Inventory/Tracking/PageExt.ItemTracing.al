namespace EuroCompany.BaseApp.Inventory.Tracking;
using EuroCompany.BaseApp.Setup;
using Microsoft.Inventory.Tracking;
using Microsoft.Sales.History;
using System.Text;

pageextension 80128 "Item Tracing" extends "Item Tracing"
{
    layout
    {
        modify(SerialNoFilter)
        {
            Visible = SerialNoBln;
        }
        modify(LotNoFilter)
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                LotNoInfo: Record "Lot No. Information";
                SelectionFilterManagementCU: Codeunit SelectionFilterManagement;
                LotNoInfoList: Page "Lot No. Information List";
            begin
                LotNoInfoList.SetTableView(LotNoInfo);
                LotNoInfoList.LookupMode(true);
                if LotNoInfoList.RunModal() = Action::LookupOK then begin
                    LotNoInfoList.SetSelectionFilter(LotNoInfo);
                    Text := SelectionFilterManagementCU.GetSelectionFilterForLotNoInformation(LotNoInfo);
                    exit(true);
                end
            end;
        }
        addafter(SerialNoFilter)
        {
            field(ShipmentNo; ShipmentNo)
            {
                ApplicationArea = All;
                Caption = 'Shipment No.';
                Visible = ShipmentNoBln;

                trigger OnValidate()
                begin
                    SerialNoFilter := ShipmentNo;
                end;

                trigger OnLookup(var Text: Text): Boolean
                var
                    SalesShipHeader: Record "Sales Shipment Header";
                    SelectionFilterManagementCU: Codeunit SelectionFilterManagement;
                    PostedSalesShipments: Page "Posted Sales Shipments";
                    RecRef: RecordRef;
                begin
                    PostedSalesShipments.SetTableView(SalesShipHeader);
                    PostedSalesShipments.LookupMode(true);
                    if PostedSalesShipments.RunModal() = Action::LookupOK then begin
                        PostedSalesShipments.SetSelectionFilter(SalesShipHeader);
                        RecRef.GetTable(SalesShipHeader);
                        Text := SelectionFilterManagementCU.GetSelectionFilter(RecRef, SalesShipHeader.FieldNo("No."));
                        exit(true);
                    end;
                end;
            }
        }
        addafter("Item Description")
        {
            field("ecItem Type"; Rec."ecItem Type")
            {
                ApplicationArea = All;
                Visible = ItemTypeBln;
            }
            field("ecItem Species"; Rec."ecItem Species")
            {
                ApplicationArea = All;
                Visible = ItemSpecBln;
            }
            field("ecItem Commercial Line"; Rec."ecItem Commercial Line")
            {
                ApplicationArea = All;
                Visible = ItemCommLineBln;
            }
            field("ecItem Brand"; Rec."ecItem Brand")
            {
                ApplicationArea = All;
                Visible = ItemBrandBln;
            }
            field("ecItem Brand Type"; Rec."ecItem Brand Type")
            {
                ApplicationArea = All;
                Visible = ItemBrandTypeBln;
            }
            field("ecLot Origin Country Code"; Rec."ecLot Origin Country Code")
            {
                ApplicationArea = All;
                Visible = LotOriginCountryCodeBln;
            }
            field("ecItem Unit Of Measure"; Rec."ecItem Unit Of Measure")
            {
                ApplicationArea = All;
                Visible = ItemUnitOfMeasBln;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SerialNoBln := true;

        EcSetup.Get();
        if (EcSetup."Enable Item Tracing Intrastat") and (EcSetup."Show Only Run Intrastat Page") then begin
            SetEditability();

            FindLocalRecords();
        end;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if (EcSetup."Enable Item Tracing Intrastat") and (EcSetup."Show Only Run Intrastat Page") then begin
            EcSetup."Show Only Run Intrastat Page" := false;
            EcSetup.Modify();
        end;
    end;

    local procedure FindLocalRecords()
    begin
        if (LotNoFilter <> '') or (ShipmentNo <> '') then
            FindRecords();
    end;

    local procedure SetEditability()
    begin
        ShipmentNoBln := true;
        SerialNoBln := false;
        ItemTypeBln := true;
        ItemSpecBln := true;
        ItemCommLineBln := true;
        ItemBrandBln := true;
        ItemBrandTypeBln := true;
        LotOriginCountryCodeBln := true;
        ItemUnitOfMeasBln := true;
    end;

    procedure SetShipmentNo(ShipmentNoParam: Text)
    begin
        ShipmentNo := ShipmentNoParam;
    end;

    var
        EcSetup: Record "ecGeneral Setup";
        ShipmentNo: Text;
        SerialNoBln: Boolean;
        ShipmentNoBln: Boolean;
        ItemTypeBln: Boolean;
        ItemSpecBln: Boolean;
        ItemCommLineBln: Boolean;
        ItemBrandBln: Boolean;
        ItemBrandTypeBln: Boolean;
        LotOriginCountryCodeBln: Boolean;
        ItemUnitOfMeasBln: Boolean;
}