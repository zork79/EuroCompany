namespace EuroCompany.BaseApp.Coan;
using EuroCompany.BaseApp.Manufacturing.Capacity;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.WorkCenter;
using Microsoft.Finance.Dimension;

page 50070 ecCostAllSchforPrdArea
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ecCost All. Sch. for Prd. Area";
    Editable = true;
    Extensible = true;
    Caption = 'Cost Allocation Schema for Production Area';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                //Added
                field("Work Center No."; Rec."Work Center No.")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Visible = VisibleArea;
                }
                //Added
                field("No."; Rec.Code)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Cost Calculation Method"; Rec."Cost Calculation Method")
                {
                    ApplicationArea = All;
                    Editable = true;

                    trigger OnValidate()
                    var
                    begin
                        fnEnableRate();
                    end;
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                    Editable = EnableRate;
                }
                field("Center Cost Dim value Code"; Rec."Center Cost Dim value Code")
                {
                    ApplicationArea = All;
                    Editable = true;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimensionValue: Record "Dimension Value";
                        CoanSetup: Record "ecCoan Custom Setup";
                    begin
                        if CoanSetup.Get() then begin
                            DimensionValue.SetRange("Dimension Code", CoanSetup."Dimension 2 code");
                            if Page.RunModal(Page::"Dimension Value List", DimensionValue) = Action::LookupOK then
                                Rec.Validate(Rec."Center Cost Dim value Code", DimensionValue.Code);
                        end;
                    end;
                }
                field("Allocation Method"; Rec."Allocation Method")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                //Issue 215
                field("Worked Time Budget"; Rec."Worked Time Budget")
                {
                    ApplicationArea = All;
                    //Editable = true;
                    Editable = false;
                }
                field("Budget Amount"; Rec."Budget Amount")
                {
                    ApplicationArea = All;
                    //Editable = true;
                    Editable = false;
                }
                field("Rate Bdg"; Rec."Rate Bdg")
                {
                    ApplicationArea = All;
                    //Editable = true;
                    Editable = false;
                }
                field("Worked Time Real"; Rec."Worked Time Real")
                {
                    ApplicationArea = All;
                    //Editable = true;
                    Editable = false;
                }
                field("Amount C/G"; Rec."Amount C/G")
                {
                    ApplicationArea = All;
                    //Editable = true;
                    Editable = false;
                }
                field("Rate G/L"; Rec."Rate G/L")
                {
                    ApplicationArea = All;
                    //Editable = true;
                    Editable = false;
                }
                //Issue 215
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CosAllocationSchemaProdArea)
            {
                ApplicationArea = All;
                Visible = true;
                Enabled = true;
                Caption = 'Analyze';
                Image = AnalysisView;

                trigger OnAction()
                var
                    CalculateSchema: Report ecCalculateSchema;
                begin
                    CalculateSchema.SetWorkCenterNo(Rec."Work Center No.");
                    CalculateSchema.Run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if WorkCenter <> '' then
            Rec.SetRange("Work Center No.", WorkCenter);

        fnVisibleArea();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        fnEnableRate();
        //    fnVisibleArea();
        //     CurrPage.Update(false);
    end;

    procedure SetWorkCenterNo(parWorkcenterno: Code[20])
    begin
        WorkCenter := parWorkcenterno;
    end;

    procedure fnEnableRate()
    begin
        if Rec."Cost Calculation Method" = Rec."Cost Calculation Method"::Manual then
            EnableRate := true
        else
            EnableRate := false;
    end;

    //Added
    procedure fnVisibleArea()
    begin
        VisibleArea := true;

        if WorkCenter <> '' then
            VisibleArea := false
        else
            VisibleArea := true;
    end;
    //Added

    var
        WorkCenter: Code[20];
        EnableRate: Boolean;
        VisibleArea: Boolean;
}