namespace EuroCompany.BaseApp.APsExtension;

using Microsoft.Finance.VAT.Ledger;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Catalog;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.History;
using Microsoft.Sales.History;
using System.Utilities;
codeunit 50010 "ecAPs Events Subscription"
{
    #region Electronic Invoicing for Italy
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"APsElect. Invoice Exp. Helper", 'OnAfterInsertTempFatturaLine', '', false, false)]
    local procedure OnAfterInsertTempFatturaLine(TempFatturaHeader: Record "APsFattura Header"; var TempFatturaLine: Record "APsFattura Line"; HeaderRecRef: RecordRef; LineRecRef: RecordRef; DocLineNo: Integer)
    var
        VatPostingSetupLoc: Record "VAT Posting Setup";
        TempSalesIvoiceLine: Record "Sales Invoice Line" temporary;
        locVATBusPostingGroup: Code[20];
        locVATProdPostingGroup: Code[20];
    begin
        //#368
        if (TempFatturaHeader."Entry Type" <> TempFatturaHeader."Entry Type"::Sales) or
           ((TempFatturaHeader."Document Type" <> TempFatturaHeader."Document Type"::Invoice) and
            (TempFatturaHeader."Document Type" <> TempFatturaHeader."Document Type"::"Credit Memo")) then
            exit;

        locVATBusPostingGroup := LineRecRef.Field(TempSalesIvoiceLine.FieldNo("VAT Bus. Posting Group")).Value;
        locVATProdPostingGroup := LineRecRef.Field(TempSalesIvoiceLine.FieldNo("VAT Prod. Posting Group")).Value;
        if (VatPostingSetupLoc.Get(locVATBusPostingGroup, locVATProdPostingGroup)) and
           (VatPostingSetupLoc."ecInclude in OSS VAT Sett.") then begin
            TempFatturaLine."VAT %" := 0; // AliquotaIVA
            TempFatturaLine."VAT Transaction Nature" := VatPostingSetupLoc."VAT Transaction Nature"; // Natura
            TempFatturaLine.Modify();
        end;
        //#368
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"APsElect. Invoice Exp. Helper", 'OnAfterCollectDocLinesInformation', '', false, false)]
    local procedure OnAfterCollectDocLinesInformation(TempFatturaHeader: Record "APsFattura Header"; var TempFatturaLine: Record "APsFattura Line"; var HeaderRecRef: RecordRef; var LineRecRef: RecordRef; var ErrorMessage: Record "Error Message")
    var
        VatPostingSetupLoc: Record "VAT Posting Setup";
        TempSalesIvoiceLine: Record "Sales Invoice Line" temporary;
        locVATBusPostingGroup: Code[20];
        locVATProdPostingGroup: Code[20];
    begin
        //#368
        if (TempFatturaHeader."Entry Type" <> TempFatturaHeader."Entry Type"::Sales) or
           ((TempFatturaHeader."Document Type" <> TempFatturaHeader."Document Type"::Invoice) and
            (TempFatturaHeader."Document Type" <> TempFatturaHeader."Document Type"::"Credit Memo")) then
            exit;

        locVATBusPostingGroup := LineRecRef.Field(TempSalesIvoiceLine.FieldNo("VAT Bus. Posting Group")).Value;
        locVATProdPostingGroup := LineRecRef.Field(TempSalesIvoiceLine.FieldNo("VAT Prod. Posting Group")).Value;
        if (VatPostingSetupLoc.Get(locVATBusPostingGroup, locVATProdPostingGroup)) and
           (VatPostingSetupLoc."ecInclude in OSS VAT Sett.") then begin
            TempFatturaLine.SetRange("Line Type", TempFatturaLine."Line Type"::VAT);
            TempFatturaLine.ModifyAll("VAT %", 0);
            TempFatturaLine.ModifyAll("VAT Amount", 0);
            TempFatturaLine.ModifyAll("VAT Transaction Nature", VatPostingSetupLoc."VAT Transaction Nature");
        end;
        //#368
    end;
    #endregion

    #region Advanced Finance Reporting for Italy
    [EventSubscriber(ObjectType::Report, Report::"APsAdvFinRpVAT - Resume", 'OnAfterVatEntrySalesSetFilter', '', true, true)]
    local procedure OnAfterVatEntrySalesSetFilter(var VatEntry: Record "VAT Entry"; VatIdentifier: Record "VAT Identifier")
    begin
        //#368
        VatEntry.SetRange("ecInclude in OSS VAT Sett.", VatIdentifier."ecReport Filter Only OSS");
        VatEntry.SetCurrentKey(Type, "VAT Identifier", "Posting Date", "ecInclude in OSS VAT Sett.");
        VatEntry.Ascending(true);
        //#368
    end;

    [EventSubscriber(ObjectType::Report, Report::"APsAdvFinRpVAT - Resume", 'OnAfterVatEntryPurchaseSetFilter', '', true, true)]
    local procedure OnAfterVatEntryPurchaseSetFilter(var VatEntry: Record "VAT Entry"; VatIdentifier: Record "VAT Identifier")
    begin
        //#368
        VatEntry.SetRange("ecInclude in OSS VAT Sett.", VatIdentifier."ecReport Filter Only OSS");
        VatEntry.SetCurrentKey(Type, "VAT Identifier", "Posting Date", "ecInclude in OSS VAT Sett.");
        VatEntry.Ascending(true);
        //#368
    end;


    [EventSubscriber(ObjectType::Report, Report::"APsAdvFinRpVAT Reg. - Print", 'OnBeforeUpdateRegisterBuffer', '', true, true)]
    local procedure OnBeforeUpdateRegisterBuffer(VatBookEntry: Record "VAT Book Entry"; IsHandled: Boolean)
    begin
        //#368
        IsHandled := VatBookEntry."ecInclude in OSS VAT Sett.";
        //#368
    end;
    #endregion

    #region Electronic VAT Settlement for Italy
    [EventSubscriber(ObjectType::Table, Database::"APsEII Other Mgt. Data", 'OnInsertDefault', '', false, false)]
    local procedure InsertOtherMgtDataOnInsertDefault(var Rec: Record "APsEII Other Mgt. Data")
    var
        VatPostingSetupLoc: Record "VAT Posting Setup";
        TempSalesIvoiceLine: Record "Sales Invoice Line" temporary;
        LineRecRef: RecordRef;
        locVATBusPostingGroup: Code[20];
        locVATProdPostingGroup: Code[20];
        AmountIncludingVAT: Decimal;
        Amount: Decimal;
        VATAmountLbl: Label 'Importo IVA %1', Locked = true;
    begin
        //#368
        if (Rec."Table Id" <> Database::"Sales Invoice Header") and
           (Rec."Table Id" <> Database::"Sales Cr.Memo Header") then
            exit;

        LineRecRef := Rec.GetLineRecRef();

        locVATBusPostingGroup := LineRecRef.Field(TempSalesIvoiceLine.FieldNo("VAT Bus. Posting Group")).Value;
        locVATProdPostingGroup := LineRecRef.Field(TempSalesIvoiceLine.FieldNo("VAT Prod. Posting Group")).Value;
        AmountIncludingVAT := LineRecRef.Field(TempSalesIvoiceLine.FieldNo("Amount Including VAT")).Value;
        Amount := LineRecRef.Field(TempSalesIvoiceLine.FieldNo(Amount)).Value;
        if (VatPostingSetupLoc.Get(locVATBusPostingGroup, locVATProdPostingGroup)) and
           (VatPostingSetupLoc."ecInclude in OSS VAT Sett.") then
            Rec.AddUniqueLine('IVA OSS', StrSubstNo(VATAmountLbl,
                                                    Format(AmountIncludingVAT - Amount, 0, '<Precision,2:2><Standard Format,9>')),
                                                    0, 0D); // AltriDatiGestionali
        //#368
    end;
    #endregion

    #region Advanced Trade
    local procedure SearchPriceDetailByUM(var pPriceDetail: Record "APsTRD Price Detail";
                                          pItemNo: Code[20];
                                          pDocLineUM: Code[10])
    var
        lTRDSetup: Record "APsTRD Setup";
        lItem: Record Item;
    begin
        //CS_VEN_014-VI-s
        if not lItem.Get(pItemNo) then Clear(lItem);

        pPriceDetail.SetRange("Unit of Measure Code", pDocLineUM);
        if pPriceDetail.IsEmpty then begin
            lTRDSetup.Get();
            if lTRDSetup."Enable Udm Conv. on Price" then begin
                pPriceDetail.SetRange("Unit of Measure Code", lItem."ecConsumer Unit of Measure");

                if pPriceDetail.IsEmpty then begin
                    pPriceDetail.SetRange("Unit of Measure Code", lItem."Base Unit of Measure");
                end;

                if pPriceDetail.IsEmpty then begin
                    pPriceDetail.SetRange("Unit of Measure Code");
                end;
            end;
        end;
        //CS_VEN_014-VI-e
    end;

    local procedure GetDefaultSalesPricingUM(pItemNo: Code[20]): Code[10]
    var
        lItem: Record Item;
    begin
        //CS_VEN_014-VI-s
        if lItem.Get(pItemNo) then begin
            if (lItem."ecConsumer Unit of Measure" <> '') then begin
                exit(lItem."ecConsumer Unit of Measure");
            end;

            exit(lItem."Base Unit of Measure");
        end;
        //CS_VEN_014-VI-e
    end;
    #region Codeunit::"APsTRD General Functions"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"APsTRD General Functions", 'OnAfterCalcUdMConversionFactor', '', false, false)]
    local procedure TRDGeneralFunctions_OnAfterCalcUdMConversionFactor(ItemNo: Code[20]; SourceUdM: Code[10]; TargetUdM: Code[10]; var ConversionFactor: Decimal)
    var
        lItem: Record Item;
    begin
        //CS_VEN_014-VI-s

        // In caso di modifica allineare anche la funzione AWPLogisticsFunctions_OnAfterCalcItemUMConversionFactor 
        // presente nella CU "ecAWPEvents Subscription"

        if lItem.Get(ItemNo) then begin
            if (TargetUdM = lItem."ecConsumer Unit of Measure") and
               (SourceUdM = lItem."ecPackage Unit Of Measure")
            then begin
                if (lItem."ecNo. Consumer Units per Pkg." <> 0) then begin
                    ConversionFactor := lItem."ecNo. Consumer Units per Pkg.";
                end;
            end;
        end;
        //CS_VEN_014-VI-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"APsTRD General Functions", 'OnAfterConvertQtyInUdM', '', false, false)]
    local procedure TRDGeneralFunctions_OnAfterConvertQtyInUdM(ItemNo: Code[20]; SourceQuantity: Decimal; SourceUdM: Code[10]; TargetUdM: Code[10]; var ConvertedQty: Decimal)
    var
        lItem: Record Item;
        lUOMMgt: Codeunit "Unit of Measure Management";
        lConversionFactor: Decimal;
        lQtyRoundingPrecision: Decimal;
    begin
        //CS_VEN_014-VI-s
        // In caso di modifica allineare anche la funzione AWPLogisticsFunctions_OnAfterConvertItemQtyInUM 
        // presente nella CU "ecAWPEvents Subscription"

        if lItem.Get(ItemNo) then begin
            if (SourceUdM = lItem."ecConsumer Unit of Measure") and
               (TargetUdM = lItem."ecPackage Unit Of Measure")
            then begin
                lConversionFactor := lItem."ecNo. Consumer Units per Pkg.";
                if (lConversionFactor <> 0) then begin
                    lQtyRoundingPrecision := lUOMMgt.GetQtyRoundingPrecision(lItem, TargetUdM);
                    ConvertedQty := lUOMMgt.RoundQty(SourceQuantity / lConversionFactor, lQtyRoundingPrecision);
                end;
            end;
        end;
        //CS_VEN_014-VI-e
    end;
    #endregion Codeunit::"APsTRD General Functions"

    #region Codeunit::"APsTRD Line Price PE Mgt."
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"APsTRD Line Price PE Mgt.", 'OnGetPriceDetailsOnAfterSetFiltersOnPriceDetail', '', false, false)]
    local procedure TRDLinePricePEMgt_OnGetPriceDetailsOnAfterSetFiltersOnPriceDetail(var PriceDetail: Record "APsTRD Price Detail";
                                                                                      DocumentLinePricing: Record "APsTRD Doc. Line Pricing";
                                                                                      CommercialCondition: Record "APsTRD Commercial Condition")

    begin
        //CS_VEN_014-VI-s
        SearchPriceDetailByUM(PriceDetail, DocumentLinePricing."Item No.", DocumentLinePricing."Unit of Measure Code");
        //CS_VEN_014-VI-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"APsTRD Line Price PE Mgt.", 'OnGetPriceDetailsOnAfterSetFiltersOnSpecificPriceDetail', '', false, false)]
    local procedure TRDLinePricePEMgt_OnGetPriceDetailsOnAfterSetFiltersOnSpecificPriceDetail(var PriceDetail: Record "APsTRD Price Detail";
                                                                                              DocumentLinePricing: Record "APsTRD Doc. Line Pricing";
                                                                                              CommercialCondition: Record "APsTRD Commercial Condition")
    begin
        //CS_VEN_014-VI-s
        SearchPriceDetailByUM(PriceDetail, DocumentLinePricing."Item No.", DocumentLinePricing."Unit of Measure Code");
        //CS_VEN_014-VI-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"APsTRD Line Price PE Mgt.", 'OnFindBestPriceUoMCodeOnBeforeSearchByItemBaseUM', '', false, false)]
    local procedure TRDLinePricePEMgt_OnFindBestPriceUoMCodeOnBeforeSearchByItemBaseUM(var DocumentLinePricing: Record "APsTRD Doc. Line Pricing"; var DocLineUsablePrice: Record "APsTRD Line Usable Price"; var IsHandled: Boolean)
    var
        lUnitOfMeasureCode: Code[10];
    begin
        //CS_VEN_014-VI-s
        lUnitOfMeasureCode := GetDefaultSalesPricingUM(DocumentLinePricing."Item No.");

        if (lUnitOfMeasureCode <> '') then begin
            DocLineUsablePrice.SetRange("Price UoM Code", lUnitOfMeasureCode);
            if not DocLineUsablePrice.IsEmpty then begin
                DocumentLinePricing."Price List UoM Code" := lUnitOfMeasureCode;
                IsHandled := true;
            end;
        end;
        //CS_VEN_014-VI-e   
    end;
    #endregion Codeunit::"APsTRD Line Price PE Mgt."

    #region Codeunit::"APsTRD Temporary Pricing Mgt."
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"APsTRD Temporary Pricing Mgt.", 'OnGetPriceDetailsOnAfterSetFiltersOnPriceDetail', '', false, false)]
    local procedure TRDTemporaryPricingMgt_OnGetPriceDetailsOnAfterSetFiltersOnPriceDetail(var PriceDetail: Record "APsTRD Price Detail";
                                                                                           var TempDocumentLinePricing: Record "APsTRD Doc. Line Pricing" temporary;
                                                                                           CommercialCondition: Record "APsTRD Commercial Condition")
    begin
        //CS_VEN_014-VI-s
        SearchPriceDetailByUM(PriceDetail, TempDocumentLinePricing."Item No.", TempDocumentLinePricing."Unit of Measure Code");
        //CS_VEN_014-VI-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"APsTRD Temporary Pricing Mgt.", 'OnGetPriceDetailsOnAfterSetFiltersOnSpecificPriceDetail', '', false, false)]
    local procedure TRDTemporaryPricingMgt_OnGetPriceDetailsOnAfterSetFiltersOnSpecificPriceDetail(var PriceDetail: Record "APsTRD Price Detail";
                                                                                                   var TempDocumentLinePricing: Record "APsTRD Doc. Line Pricing" temporary;
                                                                                                   CommercialCondition: Record "APsTRD Commercial Condition")
    begin
        //CS_VEN_014-VI-s
        SearchPriceDetailByUM(PriceDetail, TempDocumentLinePricing."Item No.", TempDocumentLinePricing."Unit of Measure Code");
        //CS_VEN_014-VI-e
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"APsTRD Temporary Pricing Mgt.", 'OnFindBestPriceUoMCodeOnBeforeSearchByItemBaseUM', '', false, false)]
    local procedure TRDTemporaryPricingMgt_OnFindBestPriceUoMCodeOnBeforeSearchByItemBaseUM(var DocumentLinePricing: Record "APsTRD Doc. Line Pricing"; var TempLineUsablePrice: Record "APsTRD Line Usable Price" temporary; var IsHandled: Boolean)
    var
        lUnitOfMeasureCode: Code[10];
    begin
        //CS_VEN_014-VI-s
        lUnitOfMeasureCode := GetDefaultSalesPricingUM(DocumentLinePricing."Item No.");

        if (lUnitOfMeasureCode <> '') then begin
            TempLineUsablePrice.SetRange("Price UoM Code", lUnitOfMeasureCode);
            if not TempLineUsablePrice.IsEmpty then begin
                DocumentLinePricing."Price List UoM Code" := lUnitOfMeasureCode;
                IsHandled := true;
            end;
        end;
        //CS_VEN_014-VI-e   
    end;
    #endregion Codeunit::"APsTRD Temporary Pricing Mgt."

    #endregion Advanced Trade

    #region Intrastat Declaration for Italy
    [EventSubscriber(ObjectType::Report, Report::"APsGet Intrastat Entries", OnBeforeInsertSalesInvJnlLine, '', false, false)]
    local procedure "APsGet Intrastat Entries_OnBeforeInsertSalesInvJnlLine"(var IntrastatJnlLine: Record "APsIntrastat Decl. Jnl. Line"; SalesInvoiceHeader: Record "Sales Invoice Header"; SalesInvoiceLine: Record "Sales Invoice Line")
    var
        Item: Record Item;
        LotNoInformation: Record "Lot No. Information";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        //#219
        if SalesInvoiceLine."AltAWPPosted Whse Shipment No." <> '' then begin
            ItemLedgerEntry.Reset();
            ItemLedgerEntry.SetRange("AltAWPPosted Document Type", ItemLedgerEntry."AltAWPPosted Document Type"::"Warehouse Shipment");
            ItemLedgerEntry.SetRange("AltAWPPosted Document No.", SalesInvoiceLine."AltAWPPosted Whse Shipment No.");
            ItemLedgerEntry.SetRange("AltAWPPosted Doc. Line No.", SalesInvoiceLine."AltAWPPosted Whse Ship. Line");
            if ItemLedgerEntry.FindFirst() then begin
                LotNoInformation.Reset();
                LotNoInformation.SetRange("Item No.", SalesInvoiceLine."No.");
                LotNoInformation.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                if LotNoInformation.FindFirst() then begin
                    IntrastatJnlLine."Country/Region of Origin Code" := LotNoInformation."ecOrigin Country Code";
                    exit;
                end;
            end;
        end;

        Item.SetLoadFields("Country/Region of Origin Code");
        if Item.Get(SalesInvoiceLine."No.") then
            if Item."Country/Region of Origin Code" <> '' then begin
                IntrastatJnlLine."Country/Region of Origin Code" := Item."Country/Region of Origin Code";
                exit;
            end;

        IntrastatJnlLine."Country/Region of Origin Code" := '';
        exit;
        //#219
    end;

    [EventSubscriber(ObjectType::Report, Report::"APsGet Intrastat Entries", OnBeforeInsertSalesCrMemJnlLine, '', false, false)]
    local procedure "APsGet Intrastat Entries_OnBeforeInsertSalesCrMemJnlLine"(var IntrastatJnlLine: Record "APsIntrastat Decl. Jnl. Line"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        Item: Record Item;
        LotNoInformation: Record "Lot No. Information";
    begin
        //#219
        Item.SetLoadFields("Country/Region of Origin Code");
        if Item.Get(SalesCrMemoLine."No.") then
            if Item."Country/Region of Origin Code" <> '' then begin
                IntrastatJnlLine."Country/Region of Origin Code" := Item."Country/Region of Origin Code";
                exit;
            end;

        LotNoInformation.Reset();
        LotNoInformation.SetLoadFields("ecOrigin Country Code");
        LotNoInformation.SetRange("Item No.", SalesCrMemoLine."No.");
        if LotNoInformation.FindFirst() then begin
            IntrastatJnlLine."Country/Region of Origin Code" := LotNoInformation."ecOrigin Country Code";
            exit;
        end;

        IntrastatJnlLine."Country/Region of Origin Code" := '';
        exit;
        //#219
    end;

    [EventSubscriber(ObjectType::Report, Report::"APsGet Intrastat Entries", OnBeforeInsertPurchaseInvJnlLine, '', false, false)]
    local procedure "APsGet Intrastat Entries_OnBeforeInsertPurchaseInvJnlLine"(var IntrastatJnlLine: Record "APsIntrastat Decl. Jnl. Line"; PurchaseInvoiceHeader: Record "Purch. Inv. Header"; PurchaseInvoiceLine: Record "Purch. Inv. Line")
    var
        ItemVendor: Record "Item Vendor";
        Item: Record Item;
        LotNoInformation: Record "Lot No. Information";
    begin
        //#219
        ItemVendor.SetLoadFields("Country/Region of Origin Code");
        if ItemVendor.Get(PurchaseInvoiceLine."No.", PurchaseInvoiceLine."Buy-from Vendor No.") then
            if ItemVendor."Country/Region of Origin Code" <> '' then begin
                IntrastatJnlLine."Country/Region of Origin Code" := ItemVendor."Country/Region of Origin Code";
                exit;
            end;

        Item.SetLoadFields("Country/Region of Origin Code");
        if Item.Get(PurchaseInvoiceLine."No.") then
            if Item."Country/Region of Origin Code" <> '' then begin
                IntrastatJnlLine."Country/Region of Origin Code" := Item."Country/Region of Origin Code";
                exit;
            end;

        LotNoInformation.Reset();
        LotNoInformation.SetLoadFields("ecOrigin Country Code");
        LotNoInformation.SetRange("Item No.", PurchaseInvoiceLine."No.");
        if LotNoInformation.FindFirst() then begin
            IntrastatJnlLine."Country/Region of Origin Code" := LotNoInformation."ecOrigin Country Code";
            exit;
        end;

        IntrastatJnlLine."Country/Region of Origin Code" := '';
        exit;
        //#219
    end;

    [EventSubscriber(ObjectType::Report, Report::"APsGet Intrastat Entries", OnBeforeInsertPurchCrMemoJnlLine, '', false, false)]
    local procedure "APsGet Intrastat Entries_OnBeforeInsertPurchCrMemoJnlLine"(var IntrastatJnlLine: Record "APsIntrastat Decl. Jnl. Line"; PurchaseCrMemoHeader: Record "Purch. Cr. Memo Hdr."; PurchaseCrMemoLine: Record "Purch. Cr. Memo Line")
    var
        ItemVendor: Record "Item Vendor";
        Item: Record Item;
        LotNoInformation: Record "Lot No. Information";
    begin
        //#219
        ItemVendor.SetLoadFields("Country/Region of Origin Code");
        if ItemVendor.Get(PurchaseCrMemoLine."No.", PurchaseCrMemoLine."Buy-from Vendor No.") then
            if ItemVendor."Country/Region of Origin Code" <> '' then begin
                IntrastatJnlLine."Country/Region of Origin Code" := ItemVendor."Country/Region of Origin Code";
                exit;
            end;

        Item.SetLoadFields("Country/Region of Origin Code");
        if Item.Get(PurchaseCrMemoLine."No.") then
            if Item."Country/Region of Origin Code" <> '' then begin
                IntrastatJnlLine."Country/Region of Origin Code" := Item."Country/Region of Origin Code";
                exit;
            end;

        LotNoInformation.Reset();
        LotNoInformation.SetLoadFields("ecOrigin Country Code");
        LotNoInformation.SetRange("Item No.", PurchaseCrMemoLine."No.");
        if LotNoInformation.FindFirst() then begin
            IntrastatJnlLine."Country/Region of Origin Code" := LotNoInformation."ecOrigin Country Code";
            exit;
        end;

        IntrastatJnlLine."Country/Region of Origin Code" := '';
        exit;
        //#219
    end;

    #endregion
}
