namespace EuroCompany.BaseApp.Inventory.Tracking;

using EuroCompany.BaseApp.Manufacturing;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;

pageextension 80054 "Lot No. Information List" extends "Lot No. Information List"
{
    layout
    {
        modify("Item No.")
        {
            Visible = true;
        }
        modify(Inventory)
        {
            Visible = true;
        }
        modify("Test Quality")
        {
            Visible = false;
        }
        modify("Certificate Number")
        {
            Visible = false;
        }
        modify("APsMFG Product Release ID")
        {
            Visible = false;
        }
        addafter(Inventory)
        {
            field("ecDue Date"; Rec."ecExpiration Date")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_008';
                StyleExpr = ExpirationDateStyle;
            }
            field(MaxUsableDate_Field; MaxUsableDate)
            {
                ApplicationArea = All;
                Caption = 'Usage max date';
                Description = 'CS_PRO_008';
                Editable = false;
                StyleExpr = MaxUsableDateStyle;
            }
            field("ecLot No. Information Status"; Rec."ecLot No. Information Status")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_008';
            }
        }
        addlast(Control1)
        {
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
        }
    }

    var
        ExpirationDateStyle: Text;
        MaxUsableDateStyle: Text;
        MaxUsableDate: Date;

    trigger OnAfterGetRecord()
    var
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        MaxUsableDate := lProductionFunctions.CalcMaxUsableDateForItem(Rec."Item No.", '', '', Rec."ecExpiration Date");

        ExpirationDateStyle := 'Favorable';
        if (Rec."ecExpiration Date" < Today) then ExpirationDateStyle := 'Unfavorable';

        MaxUsableDateStyle := 'Favorable';
        if (MaxUsableDate < Today) then MaxUsableDateStyle := 'Unfavorable';
    end;
}
