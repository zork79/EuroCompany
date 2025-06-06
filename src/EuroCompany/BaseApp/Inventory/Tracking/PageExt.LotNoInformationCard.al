namespace EuroCompany.BaseApp.Inventory.Tracking;

using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;

pageextension 80055 "Lot No. Information Card" extends "Lot No. Information Card"
{
    layout
    {
        addlast(Inventory)
        {
            field(QtyForMaxUsableExceeded; QtyForMaxUsableExceeded)
            {
                ApplicationArea = All;
                Caption = 'Inventory for max usable date exceeded';
                Description = 'CS_PRO_018';
                Editable = false;
                StyleExpr = MaxUsableDateQtyStyle;

                trigger OnDrillDown()
                begin
                    if (QtyForMaxUsableExceeded <> 0) then DrillDownQtyForMaxUsableExceeded();
                end;
            }
        }
        addlast(content)
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom Attributes';
                Editable = PageEditable;

                group(ecCharacteristics)
                {
                    Caption = 'Characteristics';

                    field("ecItem Type"; Rec."ecItem Type")
                    {
                        ApplicationArea = All;
                        Description = 'CS_PRO_018';
                    }
                    field("Inventory Posting Group"; Rec."ecInventory Posting Group")
                    {
                        ApplicationArea = All;
                        Description = 'CS_PRO_018';
                    }
                    field("ecLot Creation Process"; Rec."ecLot Creation Process")
                    {
                        ApplicationArea = All;
                        Description = 'CS_PRO_011';
                    }
                    field("ecVendor No."; Rec."ecVendor No.")
                    {
                        ApplicationArea = All;
                        Description = 'CS_PRO_008';
                    }
                    field("ecVendor Lot No."; Rec."ecVendor Lot No.")
                    {
                        ApplicationArea = All;
                        Description = 'CS_PRO_008';
                    }
                    field("ecManufacturer No."; Rec."ecManufacturer No.")
                    {
                        ApplicationArea = All;
                        Description = 'CS_PRO_008';
                    }
                    field("ecOrigin Country Code"; Rec."ecOrigin Country Code")
                    {
                        ApplicationArea = All;
                        Description = 'CS_PRO_008';
                        Editable = OriginCountryCodeEditable;
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
                    field("ecCrop Vendor Year"; Rec."ecCrop Vendor Year")
                    {
                        ApplicationArea = All;
                        BlankZero = true;
                        Description = 'CS_PRO_043';
                    }

                    field("ecExpiration Date"; Rec."ecExpiration Date")
                    {
                        ApplicationArea = All;
                        Description = 'CS_PRO_008';
                        Editable = ExpDateEditable;

                        trigger OnValidate()
                        begin
                            MaxUsableDate := ProductionFunctions.CalcMaxUsableDateForItem(Rec."Item No.", '', '', Rec."ecExpiration Date");
                        end;
                    }
                    field(MaxUsableDate_Field; MaxUsableDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Usage max date';
                        Description = 'CS_PRO_008';
                        Editable = false;
                    }
                    field("ecLot No. Information Status"; Rec."ecLot No. Information Status")
                    {
                        ApplicationArea = All;
                        Description = 'CS_PRO_008';
                        StyleExpr = LotNoStatusStyle;
                    }
                }
            }
        }

        modify(General)
        {
            Description = 'CS_PRO_008';
            Editable = PageEditable;
        }
    }
    actions
    {
        addbefore(Navigate)
        {
            action(ecRelease)
            {
                ApplicationArea = All;
                Caption = 'Release';
                Description = 'CS_PRO_008';
                Enabled = (Rec."ecLot No. Information Status" <> Rec."ecLot No. Information Status"::Released);
                Image = ReleaseDoc;

                trigger OnAction()
                begin
                    //CS_PRO_008-s
                    ProductionFunctions.ReleaseLotNoInformation(Rec, true);
                    //CS_PRO_008-e
                end;
            }
            action(ecReopen)
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                Description = 'CS_PRO_008';
                Enabled = (Rec."ecLot No. Information Status" = Rec."ecLot No. Information Status"::Released);
                Image = ReOpen;

                trigger OnAction()
                begin
                    //CS_PRO_008-s
                    ProductionFunctions.ReopenLotNoInformation(Rec);
                    //CS_PRO_008-e
                end;
            }
            action(AssignNewLotNo)
            {
                ApplicationArea = All;
                Caption = 'Assign new lot no.';
                Description = 'CS_PRO_008';
                Enabled = (Rec."Lot No." = '');
                Image = NewLotProperties;

                trigger OnAction()
                begin
                    //CS_PRO_008-s
                    ProductionFunctions.AssignNewLotNoToLotNoInfo(Rec);
                    //CS_PRO_008-e
                end;
            }
        }
        addbefore(Navigate_Promoted)
        {
            actionref(ecRelease_Promoted; ecRelease) { }
            actionref(ecReopen_Promoted; ecReopen) { }
            actionref(AssignNewLotNo_Promoted; AssignNewLotNo) { }
        }

        modify(PrintLabel)
        {
            Description = 'GAP_VEN_002';
            Visible = false;
        }
    }

    var
        ProductionFunctions: Codeunit "ecProduction Functions";
        LotNoStatusStyle: Text;
        MaxUsableDateQtyStyle: Text;
        QtyForMaxUsableExceeded: Decimal;
        MaxUsableDate: Date;
        PageEditable: Boolean;
        ExpDateEditable: Boolean;
        OriginCountryCodeEditable: Boolean;

    trigger OnAfterGetCurrRecord()
    var
        lItem: Record Item;

    begin
        //CS_PRO_008-s
        MaxUsableDate := 0D;
        ExpDateEditable := true;
        OriginCountryCodeEditable := true;
        PageEditable := (Rec."ecLot No. Information Status" <> Rec."ecLot No. Information Status"::Released);

        if not lItem.Get(Rec."Item No.") then Clear(lItem);

        MaxUsableDate := ProductionFunctions.CalcMaxUsableDateForItem(Rec."Item No.", '', '', Rec."ecExpiration Date");

        //CS_PRO_018-s
        Rec.CalcFields(Inventory);
        QtyForMaxUsableExceeded := 0;
        MaxUsableDateQtyStyle := 'Standard';
        if (MaxUsableDate < Today) then begin
            QtyForMaxUsableExceeded := Rec.Inventory;
            MaxUsableDateQtyStyle := 'Unfavorable';
        end;
        //CS_PRO_018-e

        if (lItem."Country/Region of Origin Code" <> '') then OriginCountryCodeEditable := false;
        Rec.CalcFields("ecNo. Of Item Ledg. Entries");
        if (Rec."ecNo. Of Item Ledg. Entries" <> 0) then ExpDateEditable := false;

        case Rec."ecLot No. Information Status" of
            Rec."ecLot No. Information Status"::Open:
                LotNoStatusStyle := 'Strong';
            Rec."ecLot No. Information Status"::Released:
                LotNoStatusStyle := 'Favorable';
            Rec."ecLot No. Information Status"::"Required Attributes":
                LotNoStatusStyle := 'Unfavorable';
        end;
        //CS_PRO_008-e
    end;

    local procedure DrillDownQtyForMaxUsableExceeded()
    var
        Temp_lAWPItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary;
        lAWPLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
    begin
        //CS_PRO_018-s
        lAWPLogisticUnitsMgt.FindOpenWhseEntries(Rec."Item No.", Rec."Variant Code", '', '', '', '', Rec."Lot No.", '',
                                                 false, Temp_lAWPItemInventoryBuffer);
        if not Temp_lAWPItemInventoryBuffer.IsEmpty then begin
            Page.Run(Page::"AltAWPItem Inventory Analysis", Temp_lAWPItemInventoryBuffer);
        end;
        //CS_PRO_018-e
    end;
}
