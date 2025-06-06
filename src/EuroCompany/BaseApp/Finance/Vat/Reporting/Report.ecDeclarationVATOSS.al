namespace EuroCompany.BaseApp.Finance.VAT.Reporting;
using Microsoft.Finance.VAT.Ledger;
using Microsoft.Foundation.Address;
using Microsoft.Foundation.Company;

report 50008 "ecDeclaration VAT OSS"
{
    ApplicationArea = All;
    Caption = 'Declaration VAT OSS';
    DefaultLayout = RDLC;
    RDLCLayout = 'src/EuroCompany/BaseApp/Finance/Vat/Reporting/Report.ecDeclarationVATOSS.rdl';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("VAT Entry"; "VAT Entry")
        {
            DataItemTableView = sorting("VAT Bus. Posting Group", "VAT Prod. Posting Group")
                                where("ecInclude in OSS VAT Sett." = const(true));

            column(Country_Region_Name; CountryRegionName)
            {
            }
            column(VAT_Prod__Posting_Group; "VAT Prod. Posting Group")
            {
            }
            column(VAT__; "VAT %")
            {
            }
            column(Base; TotalBase)
            {
            }
            column(Amount; TotalAmount)
            {
            }
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }
            column(StartingDate; StartingDateVar)
            {
            }
            column(EndingDate; EndingDateVar)
            {
            }
            column(WorkDate; WorkDate())
            {
            }
            column(Declaration_VAT_OSS; Declaration_VAT_OSS)
            {
            }
            column(Document_Type; "Document Type")
            {
            }
            column(Period_Lbl; Period_Lbl)
            {
            }
            column(Document_Type_Lbl; Document_Type_Lbl)
            {
            }
            column(Amount_Lbl; Amount_Lbl)
            {
            }
            column(Base_Lbl; Base_Lbl)
            {
            }
            column(VAT__Lbl; VAT__Lbl)
            {
            }
            column(VAT_Prod__Posting_GroupLbl; VAT_Prod__Posting_GroupLbl)
            {
            }
            column(Country_Region_Name_Lbl; Country_Region_Name_Lbl)
            {
            }
            trigger OnPreDataItem()
            begin
                SetCurrentKey("Country/Region Code", "VAT Prod. Posting Group");
                SetFilter("Posting Date", '%1..%2', StartingDateVar, EndingDateVar);
                if ExcludeZeroVATVar then
                    SetFilter(Amount, '<>%1', 0);
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(CountryRegionName);

                if CountryRegion.Get("Country/Region Code") then
                    CountryRegionName := CountryRegion.Name;

                if ProdPostGroupVar <> "VAT Entry"."VAT Prod. Posting Group" then
                    SumSameProdPostGroup()
                else
                    CurrReport.Skip();
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
                group(GroupName)
                {
                    Caption = 'Options';
                    field(StartingDate; StartingDateVar)
                    {
                        ApplicationArea = All;
                        Caption = 'Starting Date';
                    }
                    field(EndingDate; EndingDateVar)
                    {
                        ApplicationArea = All;
                        Caption = 'Ending Date';
                    }
                    field(ExcludeZeroVAT; ExcludeZeroVATVar)
                    {
                        ApplicationArea = All;
                        Caption = 'Exclude Zero VAT';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
    end;

    local procedure SumSameProdPostGroup()
    var
        VatEntry: Record "VAT Entry";
    begin
        Clear(TotalAmount);
        Clear(TotalBase);

        VatEntry.Reset();
        VatEntry.SetLoadFields(Base, Amount, "VAT Prod. Posting Group");
        VatEntry.SetCurrentKey("Country/Region Code", "VAT Prod. Posting Group");
        VatEntry.SetRange("VAT Prod. Posting Group", "VAT Entry"."VAT Prod. Posting Group");
        VatEntry.SetFilter("Posting Date", '%1..%2', StartingDateVar, EndingDateVar);
        if ExcludeZeroVATVar then
            VatEntry.SetFilter(Amount, '<>%1', 0);

        if VatEntry.FindSet() then begin
            repeat
                TotalBase += VatEntry.Base;
                TotalAmount += VatEntry.Amount;
            until VatEntry.Next() = 0;

            ProdPostGroupVar := VatEntry."VAT Prod. Posting Group";
        end;
    end;

    var
        CompanyInfo: Record "Company Information";
        CountryRegion: Record "Country/Region";
        ProdPostGroupVar: Code[20];
        StartingDateVar: Date;
        EndingDateVar: Date;
        ExcludeZeroVATVar: Boolean;
        CountryRegionName: Text;
        TotalBase: Decimal;
        TotalAmount: Decimal;
        Country_Region_Name_Lbl: Label 'Country';
        VAT_Prod__Posting_GroupLbl: Label 'Vat Code';
        VAT__Lbl: Label 'Rate';
        Base_Lbl: Label 'Base';
        Amount_Lbl: Label 'Amount';
        Document_Type_Lbl: Label 'Document Type';
        Period_Lbl: Label 'Period';
        Declaration_VAT_OSS: Label 'Declaration VAT OSS';
}