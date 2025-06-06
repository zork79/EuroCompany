namespace EuroCompany.BaseApp.Purchases.Document;
using Microsoft.Foundation.NoSeries;
using Microsoft.Purchases.Document;

codeunit 50011 "ecPurchase Functions"
{
    #region CS_ACQ_013 - Gestione Informazioni Logistiche in Acquisto

    internal procedure UpdateLogInfoOnPurchLine(var pPurchaseLine: Record "Purchase Line")
    var
        lPurchaseLine2: Record "Purchase Line";
        lPurchOrderEditLogInfo: Page "ecPurch.Order Edit Log. Info ";
    begin
        //CS_ACQ_013-s
        if (pPurchaseLine."Document Type" <> pPurchaseLine."Document Type"::Order) or (pPurchaseLine."Document No." = '') or (pPurchaseLine."Line No." = 0) then exit;

        lPurchaseLine2.FilterGroup(2);
        lPurchaseLine2.SetRange("Document Type", pPurchaseLine."Document Type");
        lPurchaseLine2.SetRange("Document No.", pPurchaseLine."Document No.");
        lPurchaseLine2.SetRange("Line No.", pPurchaseLine."Line No.");
        lPurchaseLine2.FilterGroup(0);
        if not lPurchaseLine2.IsEmpty then begin
            Clear(lPurchOrderEditLogInfo);
            lPurchOrderEditLogInfo.SetTableView(lPurchaseLine2);
            lPurchOrderEditLogInfo.RunModal();
        end;
        //CS_ACQ_013-e
    end;

    #endregion CS_ACQ_013 - Gestione Informazioni Logistiche in Acquisto

    #region CS_AFC_018 - Fatture di acquisto - NO IVA

    internal procedure CkeckPurchReceipt(var pPurchaseHeader: Record "Purchase Header")
    var
        lPurchaseLine: Record "Purchase Line";
        lError001: Label 'It is Impossible to Use Series No. %1 if VAT Rate is %2 in line %3';
        lError002: Label 'VAT Type must be normal in line %1';
    begin
        lPurchaseLine.SetRange("Document Type", pPurchaseHeader."Document Type");
        lPurchaseLine.SetRange("Document No.", pPurchaseHeader."No.");
        if lPurchaseLine.Find('-') then
            repeat
                if (lPurchaseLine."VAT Calculation Type" <> lPurchaseLine."VAT Calculation Type"::"Normal VAT") then Error(lError002, lPurchaseLine."Line No.");
                if (lPurchaseLine."VAT %" <> 0) then Error(lError001, pPurchaseHeader."Operation Type", lPurchaseLine."VAT %", lPurchaseLine."Line No.");
            until (lPurchaseLine.Next() = 0);
    end;

    internal procedure PurchaseDocumentCheck(pPurchaseHeader: Record "Purchase Header")
    var
        lNoSeries: Record "No. Series";
        lPurchaseLine: Record "Purchase Line";

        lError001: Label 'Cannot use operation type "%1" when there are lines of type "%2"!';
    begin
        //CS_AFC_018-s
        if lNoSeries.Get(pPurchaseHeader."Operation Type") and lNoSeries."ecNot Create Vat Entry" then begin
            Clear(lPurchaseLine);
            lPurchaseLine.SetRange("Document Type", pPurchaseHeader."Document Type");
            lPurchaseLine.SetRange("Document No.", pPurchaseHeader."No.");
            lPurchaseLine.SetRange(Type, lPurchaseLine.Type::"Fixed Asset");
            if not lPurchaseLine.IsEmpty then Error(lError001, lNoSeries.FieldCaption("ecNot Create Vat Entry"), Format(lPurchaseLine.Type));
        end;
        //CS_AFC_018-e
    end;

    #endregion CS_AFC_018 - Fatture di acquisto - NO IVA
}
