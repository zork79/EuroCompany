namespace EuroCompany.BaseApp.Manufacturing.ProductionBOM;
using Microsoft.Manufacturing.ProductionBOM;

page 50006 "ecBOM Alternative Components"
{
    ApplicationArea = All;
    Caption = 'BOM Alternative Components';
    DelayedInsert = true;
    Description = 'GAP_PRO_003';
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "ecBOM Alternative Component";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                }
                field("Item Description"; Rec."Item Description")
                {
                }
                field("Variant Code"; Rec."Variant Code")
                {
                }
                field("Quantity per"; Rec."Quantity per")
                {
                }
                field("Scrap %"; Rec."Scrap %")
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        lSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        if lSessionDataStore.GetSessionSettingBooleanValue('PageAlternativeProdBOMCompLookup') then begin
            CurrPage.Editable(false);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        lProductionBOMLine: Record "Production BOM Line";
        lSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        if lSessionDataStore.GetSessionSettingBooleanValue('PageAlternativeProdBOMCompLookup') then begin
            exit;
        end;

        if lProductionBOMLine.Get(Rec."Production BOM No.", Rec."Prod. BOM Version Code", Rec."Prod. BOM Line No.") then begin
            Rec."Scrap %" := lProductionBOMLine."Scrap %";
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        lSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        if lSessionDataStore.GetSessionSettingBooleanValue('PageAlternativeProdBOMCompLookup') then begin
            exit;
        end;
    end;
}
