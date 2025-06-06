namespace EuroCompany.BaseApp.Finance.VAT.Ledger;

page 50031 "ecPeriodic OSS VAT Sett. Card"
{
    ApplicationArea = All;
    Caption = 'Periodic OSS VAT Sett. Card';
    PageType = Card;
    SourceTable = "ecPeriodic OSS Sett. VAT Entry";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("VAT Period"; Rec."VAT Period")
                {
                }
                field("VAT Settlement"; Rec."VAT Settlement")
                {
                }
                field("Add-Curr. VAT Settlement"; Rec."Add-Curr. VAT Settlement")
                {
                }
                field("Prior Period Input VAT"; Rec."Prior Period Input VAT")
                {
                }
                field("Prior Period Output VAT"; Rec."Prior Period Output VAT")
                {
                }
                field("Add Curr. Prior Per. Inp. VAT"; Rec."Add Curr. Prior Per. Inp. VAT")
                {
                }
                field("Add Curr. Prior Per. Out VAT"; Rec."Add Curr. Prior Per. Out VAT")
                {
                }
                field("Paid Amount"; Rec."Paid Amount")
                {
                }
                field("Advanced Amount"; Rec."Advanced Amount")
                {
                }
                field("Add-Curr. Paid. Amount"; Rec."Add-Curr. Paid. Amount")
                {
                }
                field("Add-Curr. Advanced Amount"; Rec."Add-Curr. Advanced Amount")
                {
                }
                field("Bank Code"; Rec."Bank Code")
                {
                }
                field("Paid Date"; Rec."Paid Date")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("VAT Period Closed"; Rec."VAT Period Closed")
                {
                }
                field("Prior Year Input VAT"; Rec."Prior Year Input VAT")
                {
                }
                field("Prior Year Output VAT"; Rec."Prior Year Output VAT")
                {
                }
                field("Add Curr.Prior Year Inp. VAT"; Rec."Add Curr.Prior Year Inp. VAT")
                {
                }
                field("Add Curr.Prior Year Out. VAT"; Rec."Add Curr.Prior Year Out. VAT")
                {
                }
                field("Payable VAT Variation"; Rec."Payable VAT Variation")
                {
                }
                field("Deductible VAT Variation"; Rec."Deductible VAT Variation")
                {
                }
                field("Tax Debit Variation"; Rec."Tax Debit Variation")
                {
                }
                field("Tax Credit Variation"; Rec."Tax Credit Variation")
                {
                }
                field("Unpaid VAT Previous Periods"; Rec."Unpaid VAT Previous Periods")
                {
                }
                field("Tax Debit Variation Interest"; Rec."Tax Debit Variation Interest")
                {
                }
                field("Omit VAT Payable Interest"; Rec."Omit VAT Payable Interest")
                {
                }
                field("Credit VAT Compensation"; Rec."Credit VAT Compensation")
                {
                }
                field("Special Credit"; Rec."Special Credit")
                {
                }
            }
        }
    }
}
