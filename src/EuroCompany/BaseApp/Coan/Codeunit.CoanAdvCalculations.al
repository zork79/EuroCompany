namespace EuroCompany.BaseApp.Coan;
using EuroCompany.BaseApp.Manufacturing.Capacity;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.WorkCenter;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Budget;
using Microsoft.Manufacturing.Capacity;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Inventory.Item;

codeunit 50025 CoanAdvCalculations
{
    trigger OnRun()
    begin

    end;

    var

        BudgetBalanceTot: Decimal;
        GeneralBudgetTot: Decimal;
        OutPutQty: Decimal;

    //*** Functions to implement ***
    //CalcForWeight()
    //CalcForOutputKg()
    //CalcForKWHR();
    //CalcForWorkingMinutes()
    //CalcForWorkingMinutesFilters_CDC_Area()
    //*** Functions to implement ***


    procedure CalcBalanceCDC(Date: Text[50]; AreaDimension: Code[20]; CDCDimension: Code[20]): Decimal
    var
        BudgetEntry: Record "G/L Budget Entry";
    begin
        BudgetBalanceTot := 0;
        BudgetEntry.Reset();
        BudgetEntry.SetFilter(Date, Format(Date));
        if AreaDimension <> '' then
            BudgetEntry.SetRange("Global Dimension 1 Code", AreaDimension);
        if CDCDimension <> '' then
            BudgetEntry.SetRange("Global Dimension 2 Code", CDCDimension);
        if BudgetEntry.FindSet() then
            repeat
                BudgetBalanceTot += BudgetEntry."Amount";
            until BudgetEntry.Next() = 0;

        //Budget Balance CDC
        exit(BudgetBalanceTot);
    end;

    procedure CalcForBalanceMovementGL(Date: Text[50]; AreaDimension: Code[20]; CDCDimension: Code[20]): Decimal
    var
        GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";
        SimulationGLEntry: Record "APsSimulation G/L Entry";
        GlEntryTot: Decimal;
        GlAccountTot: Decimal;
        SimTot: Decimal;
    begin
        GeneralBudgetTot := 0;
        GlEntryTot := 0;
        GlAccountTot := 0;
        SimTot := 0;

        //G/L Entry
        GLEntry.Reset();
        GLEntry.SetFilter("Posting Date", Format(Date));
        if AreaDimension <> '' then
            GLEntry.SetRange("Global Dimension 1 Code", AreaDimension);
        if CDCDimension <> '' then
            GLEntry.SetRange("Global Dimension 2 Code", CDCDimension);
        if GLEntry.FindSet() then
            repeat
                if GLAccount.Get(GLEntry."G/L Account No.") then
                    if GLAccount."Income/Balance" = GlAccount."Income/Balance"::"Income Statement" then
                        GlEntryTot += GLEntry.Amount;
            until GLEntry.Next() = 0;

        //Budget G/L Entry
        GLAccount.Reset();
        GLAccount.SetFilter("Date Filter", Format(Date));
        if AreaDimension <> '' then
            GLAccount.SetRange("Global Dimension 1 Code", AreaDimension);
        if CDCDimension <> '' then
            GLAccount.SetRange("Global Dimension 2 Code", CDCDimension);
        GLAccount.SetRange("Income/Balance", GlAccount."Income/Balance"::"Income Statement");
        if GLAccount.FindSet() then
            repeat
                GLAccount.CalcFields("Budgeted Amount");
                GlAccountTot += GLAccount."Budgeted Amount";
            until GLAccount.Next() = 0;

        //Simulation G/L Entry
        SimulationGLEntry.Reset();
        SimulationGLEntry.SetFilter("Posting Date", Format(Date));
        if AreaDimension <> '' then
            SimulationGLEntry.SetRange("Global Dimension 1 Code", AreaDimension);
        if CDCDimension <> '' then
            SimulationGLEntry.SetRange("Global Dimension 2 Code", CDCDimension);
        if SimulationGLEntry.FindSet() then
            repeat
                if GLAccount.Get(SimulationGLEntry."G/L Account No.") then
                    if GLAccount."Income/Balance" = GlAccount."Income/Balance"::"Income Statement" then
                        SimTot += SimulationGLEntry.Amount;
            until SimulationGLEntry.Next() = 0;

        //General Budget
        GeneralBudgetTot := GlEntryTot + GlAccountTot + SimTot;
        exit(GeneralBudgetTot);
    end;

    procedure CalcForWorkingMinutes(PostigDate: Text[50]; ProdArea: Code[20]): Decimal
    var
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
        CapacityTot: Decimal;
    begin
        CapacityTot := 0;

        if PostigDate <> '' then
            CapacityLedgerEntry.SetFilter("Posting Date", PostigDate);
        if ProdArea <> '' then
            CapacityLedgerEntry.SetRange("Work Center No.", ProdArea);
        if CapacityLedgerEntry.FindSet() then
            repeat
                if CapacityLedgerEntry.Quantity <> 0 then
                    CapacityTot += CapacityLedgerEntry.Quantity;
            until CapacityLedgerEntry.Next() = 0;

        /* old calc
        CapacityLedgerEntry.CalcSums(Quantity);
        CapacityLedgerEntry.CalcSums("Run Time");
        if CapacityLedgerEntry."Run Time" <> 0 then
            exit(CapacityLedgerEntry."Run Time")
        else
            exit(1); old */

        //Added
        if CapacityTot <> 0 then
            exit(CapacityTot)
        else
            exit(1);
        //Added
    end;


    procedure CalcForKGProducts(PostigDate: Text[50]; ProdArea: Code[20]): Decimal
    var
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
        ItemUnitofMeasure: Record "Item Unit of Measure";
    begin
        OutPutQty := 0;
        CapacityLedgerEntry.SetCurrentKey("Item No.", "Order Type", "Order No.", "Posting Date", Subcontracting);
        CapacityLedgerEntry.SetFilter("Posting Date", PostigDate);
        if ProdArea <> '' then
            CapacityLedgerEntry.SetRange("Work Center No.", ProdArea);
        if CapacityLedgerEntry.FindSet() then
            repeat
                if ItemUnitofMeasure.Get(CapacityLedgerEntry."Item No.", 'KG') then //need to setup in table
                    OutPutQty += (CapacityLedgerEntry."Output Quantity" * ItemUnitofMeasure."Qty. per Unit of Measure")
            until CapacityLedgerEntry.Next() = 0;

        if OutPutQty <> 0 then
            exit(OutPutQty)
        else
            exit(1);
    end;

    procedure CalckiloWatt(): Decimal
    var
        LineAllocSchemeAdv: Record "ecLine Alloc. Scheme Adv.";
        HeaderAllocSchAdv: Record "ecHeader Alloc. Scheme Advanc.";
        KWTot: Decimal;

    begin
        KWTot := 0;
        HeaderAllocSchAdv.SetRange("Calculation Type", HeaderAllocSchAdv."Calculation Type"::Kilovators);
        if HeaderAllocSchAdv.FindSet() then
            repeat
                LineAllocSchemeAdv.Reset();
                LineAllocSchemeAdv.SetRange("Allocation Method", HeaderAllocSchAdv."No.");
                if LineAllocSchemeAdv.FindSet() then
                    repeat
                        KWTot += LineAllocSchemeAdv.Kilowatt;
                    until LineAllocSchemeAdv.Next() = 0;
            // LineAllocSchemeAdv.CalcSums(Kilowatt);
            until HeaderAllocSchAdv.Next() = 0;

        if KWTot <> 0 then
            exit(KWTot)
        else
            exit(1);

    end;

    // ** check if this is needed
    /*procedure CalcForWorkingMin(PostigDate: Text[50]; ProdArea: Code[20]): Decimal
    var
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
        WkMinTot: Decimal;

    begin
        WkMinTot := 0;
        if PostigDate <> '' then
            CapacityLedgerEntry.SetFilter("Posting Date", PostigDate);

        if ProdArea <> '' then
            CapacityLedgerEntry.SetRange("Work Center No.", ProdArea);

        if CapacityLedgerEntry.FindSet() then
            repeat
                if CapacityLedgerEntry.Quantity <> 0 then
                    WkMinTot += CapacityLedgerEntry.Quantity;
            //CapacityLedgerEntry.CalcSums("Run Time");
            until CapacityLedgerEntry.Next() = 0;

        exit(WkMinTot)
    end;*/
    // ** check if this is needed
}