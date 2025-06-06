namespace EuroCompany.BaseApp.Coan;
using EuroCompany.BaseApp.Manufacturing.Capacity;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.WorkCenter;
using Microsoft.Finance.Dimension;

page 50069 ecLineAllocSchemeAdv
{
    PageType = ListPart;
    // ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ecLine Alloc. Scheme Adv.";
    Caption = 'Line Allocation Schema Advanced';
    Extensible = true;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."Allocation Method")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Work Center No."; Rec."Work Center No.")
                {
                    ApplicationArea = All;
                }
                field("Work center Dim. value Code"; Rec."Work center Dim. value Code")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimensionValue: Record "Dimension Value";
                        CoanSetup: Record "ecCoan Custom Setup";
                    begin
                        if CoanSetup.Get() then begin
                            DimensionValue.SetRange("Dimension Code", CoanSetup."Dimension 1 code");
                            if Page.RunModal(Page::"Dimension Value List", DimensionValue) = Action::LookupOK then
                                Rec.Validate(Rec."Work center Dim. value Code", DimensionValue.Code);
                        end;
                    end;
                }
                field("Weight %"; Rec."Weight %")
                {
                    ApplicationArea = All;
                    Editable = isWeight;
                }
                field(Kilowatt; Rec.Kilowatt)
                {
                    ApplicationArea = All;
                    Editable = isKilowatt;
                }
                field("Worked Time Budget"; Rec."Worked Time Budget")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        isKilowatt: Boolean;
        isWeight: Boolean;

    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // var
    //     HeaderAllocSchemeAdvanc: Record "ecHeader Alloc. Scheme Advanc.";
    // begin
    //     if HeaderAllocSchemeAdvanc.Get(Rec."Allocation Method") then
    //         isKilowatt := HeaderAllocSchemeAdvanc."Calculation Type" = HeaderAllocSchemeAdvanc."Calculation Type"::Kilovators;
    //     isWeight := HeaderAllocSchemeAdvanc."Calculation Type" = HeaderAllocSchemeAdvanc."Calculation Type"::"% Weight";
    //     CurrPage.Update();
    // end;

    // trigger OnModifyRecord(): Boolean
    // var
    //     HeaderAllocSchemeAdvanc: Record "ecHeader Alloc. Scheme Advanc.";
    // begin
    //     if HeaderAllocSchemeAdvanc.Get(Rec."Allocation Method") then
    //         isKilowatt := HeaderAllocSchemeAdvanc."Calculation Type" = HeaderAllocSchemeAdvanc."Calculation Type"::Kilovators;
    //     isWeight := HeaderAllocSchemeAdvanc."Calculation Type" = HeaderAllocSchemeAdvanc."Calculation Type"::"% Weight";
    //     CurrPage.Update();
    // end;

    trigger OnAfterGetCurrRecord()
    var
        HeaderAllocSchemeAdvanc: Record "ecHeader Alloc. Scheme Advanc.";
    begin
        if HeaderAllocSchemeAdvanc.Get(Rec."Allocation Method") then
            isKilowatt := HeaderAllocSchemeAdvanc."Calculation Type" = HeaderAllocSchemeAdvanc."Calculation Type"::Kilovators;
        isWeight := HeaderAllocSchemeAdvanc."Calculation Type" = HeaderAllocSchemeAdvanc."Calculation Type"::"% Weight";
        // CurrPage.Update();
    end;
}