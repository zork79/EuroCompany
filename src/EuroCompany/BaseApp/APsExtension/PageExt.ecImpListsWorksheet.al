/*
// Spostato in App Trade
namespace EuroCompany.BaseApp.APsExtension;
using EuroCompany.BaseApp.Sales.AdvancedTrade;
using EuroCompany.BaseApp.APsExtension;
using EuroCompany.BaseApp.Sales;
using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Inventory.Item;

pageextension 80192 "ec Imp Lists Worksheet" extends "APsTRD Import Lists Worksheet"
{

    actions
    {
        addlast(processing)
        {
            group(ecCustomFeaturesActGrp)
            {
                Caption = 'Custom Features';
                Image = AddToHome;
                ShowAs = Standard;

                action(ImplementPriceChanges)
                {
                    ApplicationArea = All;
                    Caption = 'Implement Price Changes';
                    Image = ImplementPriceChange;
                    Visible = true;
                    Enabled = true;

                    trigger OnAction()
                    var
                        cduImportTRDPriceListExcelManual: Codeunit "ecImp-Exp Excel File";

                    begin
                        if Confirm(lblImplementPriceChanges) then
                            cduImportTRDPriceListExcelManual.ImplementTRDPriceListExcelManual(rec."Prospect No.", rec."Price List No.", rec."Specific Price Entry No.");
                    end;
                }
                action(SuggestLines)
                {
                    ApplicationArea = All;
                    Caption = 'Suggest Lines';
                    Image = SuggestLines;
                    Visible = true;
                    Enabled = true;

                    trigger OnAction()
                    var
                    begin
                        Clear(SuggPriceWhs);
                        SuggPriceWhs.SetCurrentPriceWhs(rec."Prospect No.", rec."Price List No.",
                                                        rec."Prices Type", rec."Specific Price Entity No.", rec."Specific Price Entry No.");
                        SuggPriceWhs.RunModal();
                    end;
                }
                action(CopyLines)
                {
                    ApplicationArea = All;
                    Caption = 'Copy Lines';
                    Image = CopyDocument;
                    Visible = true;
                    Enabled = true;

                    trigger OnAction()
                    var
                    begin
                        Clear(SuggPriceWhs);
                        SuggPriceWhs.SetCurrentPriceWhs(rec."Prospect No.", rec."Price List No.",
                                                        rec."Prices Type", rec."Specific Price Entity No.", rec."Specific Price Entry No.");
                        SuggPriceWhs.SetCopyLines();
                        SuggPriceWhs.RunModal();
                    end;
                }
                action(OpenPriceList)
                {
                    ApplicationArea = All;
                    Caption = 'Open Price List';
                    Image = Document;
                    Visible = true;
                    Enabled = true;
                    RunObject = Page "APsTRD Price List Card";
                    RunPageLink = "No." = field("Price List No.");
                }
                action(ExportToExcel)
                {
                    ApplicationArea = All;
                    Caption = 'Export to Excel';
                    Image = ExportToExcel;
                    Visible = true;
                    Enabled = true;

                    trigger OnAction()
                    var
                        cduImportTRDPriceListExcelManual: Codeunit "ecImp-Exp Excel File";

                    begin
                        if Confirm(lblExcelExport) then
                            cduImportTRDPriceListExcelManual.ExportTRDPriceListExcelManual(rec."Prospect No.");
                    end;
                }
                action(ImportFromExcel)
                {
                    ApplicationArea = All;
                    Caption = 'Import from Excel';
                    Image = ImportExcel;
                    Visible = true;
                    Enabled = true;

                    trigger OnAction()
                    var
                        cduImportTRDPriceListExcelManual: Codeunit "ecImp-Exp Excel File";

                    begin
                        if Confirm(lblExcelImport) then
                            cduImportTRDPriceListExcelManual.ImportTRDPriceListExcelManual(rec."Prospect No.");
                    end;
                }
            }
        }

        //Actions Promoted
        addlast(Category_Process)
        {
            actionref(ImplementPriceChanges_Promoted; ImplementPriceChanges)
            {
            }
            actionref(SuggestLines_Promoted; SuggestLines)
            {
            }
            actionref(CopyLines_Promoted; CopyLines)
            {
            }
            actionref(OpenPriceList_Promoted; OpenPriceList)
            {
            }
            actionref(ExportToExcel_Promoted; ExportToExcel)
            {
            }
            actionref(ImportFromExcel_Promoted; ImportFromExcel)
            {
            }
        }
    }

    var
        SuggPriceWhs: Page "ecSugg Price Lines";
        lblExcelExport: Label 'Do you want to export the TRD price list to Excel?';
        lblExcelImport: Label 'Do you want to import the TRD price list from Excel?';
        lblImplementPriceChanges: Label 'Do you want to implement Price Changes?';
}
// Spostato in App Trade
*/
