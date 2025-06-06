namespace EuroCompany.BaseApp.Restrictions;

using EuroCompany.BaseApp.Restrictions.Rules;
using Microsoft.Warehouse.Structure;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Manufacturing.Document;
using Microsoft.Utilities;
using Microsoft.Warehouse.Activity;
using Microsoft.Warehouse.Activity.History;
using Microsoft.Warehouse.Document;
using Microsoft.Warehouse.Ledger;
using EuroCompany.BaseApp.Inventory.Tracking;

codeunit 50016 "ecRestrictions Mgt."
{
    Description = 'CS_PRO_011';

    var
        SingleLotRestrLbl: Label 'Single-Lot Pick';
        ProgressiveExpRestrLbl: Label 'Progressive Expiration';
        ExpiredLotLbl: Label 'Expired Lot';

    #region Restriction Rules Mgt.
    #region Rule Status mgt.

    internal procedure CertifyRestrictionRule(var pRestrictionRuleHeader: Record "ecRestriction Rule Header")
    var
        lRestrictionRuleLine: Record "ecRestriction Rule Line";

        lEmptyConditionsErr: Label 'No conditions defined for the restriction rule %1';
    begin
        if (pRestrictionRuleHeader.Code = '') or
           (pRestrictionRuleHeader.Status = pRestrictionRuleHeader.Status::Certified)
        then begin
            exit;
        end;

        lRestrictionRuleLine.Reset();
        lRestrictionRuleLine.SetRange("Rule Code", pRestrictionRuleHeader.Code);
        lRestrictionRuleLine.SetRange("Line Type", lRestrictionRuleLine."Line Type"::Condition);
        if lRestrictionRuleLine.IsEmpty then begin
            Error(lEmptyConditionsErr, pRestrictionRuleHeader.Code);
        end;

        CheckRuleSintax(pRestrictionRuleHeader);
        CreateRuleMetaLanguage(pRestrictionRuleHeader);

        pRestrictionRuleHeader.Status := pRestrictionRuleHeader.Status::Certified;
        pRestrictionRuleHeader.Modify(true);
    end;

    internal procedure ReopenRestrictionRule(var pRestrictionRuleHeader: Record "ecRestriction Rule Header")
    begin
        if (pRestrictionRuleHeader.Code = '') or
           (pRestrictionRuleHeader.Status = pRestrictionRuleHeader.Status::Open)
        then begin
            exit;
        end;

        pRestrictionRuleHeader.Status := pRestrictionRuleHeader.Status::Open;
        pRestrictionRuleHeader.Modify(true);
    end;

    internal procedure BlockRestrictionRule(var pRestrictionRuleHeader: Record "ecRestriction Rule Header")
    begin
        if (pRestrictionRuleHeader.Code = '') or
           (pRestrictionRuleHeader.Status = pRestrictionRuleHeader.Status::Blocked)
        then begin
            exit;
        end;

        CreateRuleMetaLanguage(pRestrictionRuleHeader);

        pRestrictionRuleHeader.Status := pRestrictionRuleHeader.Status::Blocked;
        pRestrictionRuleHeader.Modify(true);
    end;

    local procedure CheckRuleSintax(pRestrictionRuleHeader: Record "ecRestriction Rule Header")
    var
        lRestrictionRuleLine: Record "ecRestriction Rule Line";

        lTotalLines: Integer;
        lCurrLineNo: Integer;
        lOpenedBrackets: Integer;
        lClosedBrackets: Integer;

        lBracketsCountError: Label 'Invalid bracket usage in rule %1';
    begin
        lRestrictionRuleLine.Reset();
        lRestrictionRuleLine.SetRange("Rule Code", pRestrictionRuleHeader.Code);
        lRestrictionRuleLine.SetRange("Line Type", lRestrictionRuleLine."Line Type"::Condition);
        if lRestrictionRuleLine.FindSet() then begin
            lTotalLines := lRestrictionRuleLine.Count;
            lCurrLineNo := 0;
            lOpenedBrackets := 0;
            lClosedBrackets := 0;
            repeat
                if lRestrictionRuleLine."Open Bracket" then lOpenedBrackets += 1;
                if lRestrictionRuleLine."Close Bracket" then lClosedBrackets += 1;

                lCurrLineNo += 1;
                if (lCurrLineNo < lTotalLines) then begin
                    lRestrictionRuleLine.TestField("Logical Join");
                end;
            until (lRestrictionRuleLine.Next() = 0);

            lRestrictionRuleLine.TestField("Logical Join", lRestrictionRuleLine."Logical Join"::" ");

            if (lOpenedBrackets <> lClosedBrackets) then begin
                Error(lBracketsCountError, pRestrictionRuleHeader.Code);
            end;
        end;

        CreateRuleMetaLanguage(pRestrictionRuleHeader);
    end;

    #endregion Rule Status mgt.

    #region Rule Metalanguage mgt.

    local procedure CreateRuleMetaLanguage(pRestrictionRuleHeader: Record "ecRestriction Rule Header")
    var
        lRestrRuleConditionLine: Record "ecRestriction Rule Line";
        lCurrentLineTxt: Text;
        lLineNo: Integer;
        lIsFirstConditionLine: Boolean;
    begin
        DeleteRuleMetaLanguage(pRestrictionRuleHeader);
        lLineNo := 0;

        lCurrentLineTxt := '// *** ' + pRestrictionRuleHeader.Description + ' ***';
        WriteRuleMetaLanguageLine(pRestrictionRuleHeader.Code, lLineNo, 0, lCurrentLineTxt);

        lRestrRuleConditionLine.Reset();
        lRestrRuleConditionLine.SetRange("Rule Code", pRestrictionRuleHeader.Code);
        lRestrRuleConditionLine.SetRange("Line Type", lRestrRuleConditionLine."Line Type"::Condition);
        if lRestrRuleConditionLine.FindSet() then begin
            lIsFirstConditionLine := true;
            repeat
                lCurrentLineTxt := '(';
                lCurrentLineTxt += Format(lRestrRuleConditionLine."Attribute Type");
                lCurrentLineTxt += ' = ';

                case lRestrRuleConditionLine."Condition Type" of
                    lRestrRuleConditionLine."Condition Type"::Value:
                        lCurrentLineTxt += '''' + lRestrRuleConditionLine."Condition Value" + '''';
                    lRestrRuleConditionLine."Condition Type"::Filter:
                        lCurrentLineTxt += 'FILTER(' + lRestrRuleConditionLine."Condition Value" + ')';
                    lRestrRuleConditionLine."Condition Type"::"Date Formula":
                        lCurrentLineTxt += '''<' + Format(lRestrRuleConditionLine."DateFormula Value", 0, 9) + '>''';
                end;
                lCurrentLineTxt += ')';

                if lRestrRuleConditionLine."Open Bracket" then begin
                    lCurrentLineTxt := '(' + lCurrentLineTxt;
                end;
                if lRestrRuleConditionLine."Close Bracket" then begin
                    lCurrentLineTxt += ')';
                end;

                case lRestrRuleConditionLine."Logical Join" of
                    lRestrRuleConditionLine."Logical Join"::"AND":
                        lCurrentLineTxt += ' AND';
                    lRestrRuleConditionLine."Logical Join"::"OR":
                        lCurrentLineTxt += ' OR';
                end;

                if lIsFirstConditionLine then begin
                    lCurrentLineTxt := 'IF ' + lCurrentLineTxt;
                    WriteRuleMetaLanguageLine(pRestrictionRuleHeader.Code, lLineNo, 0, lCurrentLineTxt);
                    lIsFirstConditionLine := false;
                end else begin
                    WriteRuleMetaLanguageLine(pRestrictionRuleHeader.Code, lLineNo, 1, lCurrentLineTxt);
                end;
            until (lRestrRuleConditionLine.Next() = 0);

            lCurrentLineTxt := 'THEN BEGIN';
            WriteRuleMetaLanguageLine(pRestrictionRuleHeader.Code, lLineNo, 0, lCurrentLineTxt);

            lCurrentLineTxt := 'EXIT(TRUE);';
            WriteRuleMetaLanguageLine(pRestrictionRuleHeader.Code, lLineNo, 1, lCurrentLineTxt);

            lCurrentLineTxt := 'END ELSE BEGIN';
            WriteRuleMetaLanguageLine(pRestrictionRuleHeader.Code, lLineNo, 0, lCurrentLineTxt);

            lCurrentLineTxt := 'EXIT(FALSE);';
            WriteRuleMetaLanguageLine(pRestrictionRuleHeader.Code, lLineNo, 1, lCurrentLineTxt);

            lCurrentLineTxt := 'END;';
            WriteRuleMetaLanguageLine(pRestrictionRuleHeader.Code, lLineNo, 0, lCurrentLineTxt);
        end;

        lCurrentLineTxt := '// *** END - ' + pRestrictionRuleHeader.Description + ' ***';
        WriteRuleMetaLanguageLine(pRestrictionRuleHeader.Code, lLineNo, 0, lCurrentLineTxt);
    end;

    local procedure DeleteRuleMetaLanguage(pRestrictionRuleHeader: Record "ecRestriction Rule Header")
    var
        lRestrictionRuleLine: Record "ecRestriction Rule Line";
    begin
        lRestrictionRuleLine.Reset();
        lRestrictionRuleLine.SetRange("Rule Code", pRestrictionRuleHeader.Code);
        lRestrictionRuleLine.SetRange("Line Type", lRestrictionRuleLine."Line Type"::Metalanguage);
        if not lRestrictionRuleLine.IsEmpty then lRestrictionRuleLine.DeleteAll(true);
    end;

    local procedure WriteRuleMetaLanguageLine(pRuleCode: Code[50]; var pLineNo: Integer; pLevel: Integer; pMetalanguageText: Text)
    var
        lRestrictionRuleLine: Record "ecRestriction Rule Line";
        lLevelIndex: Integer;
    begin
        pLineNo += 1;

        if (pLevel > 0) then begin
            for lLevelIndex := 1 to pLevel do begin
                pMetalanguageText := '    ' + pMetalanguageText;
            end;
        end;

        lRestrictionRuleLine.Init();
        lRestrictionRuleLine."Rule Code" := pRuleCode;
        lRestrictionRuleLine."Line Type" := lRestrictionRuleLine."Line Type"::Metalanguage;
        lRestrictionRuleLine."Line No." := pLineNo;
        lRestrictionRuleLine."Rule Metalanguage Level" := pLevel;
        lRestrictionRuleLine."Rule Metalanguage" := CopyStr(pMetalanguageText, 1, MaxStrLen(lRestrictionRuleLine."Rule Metalanguage"));
        lRestrictionRuleLine.Insert(true);
    end;

    #endregion Rule Metalanguage mgt.

    #region Rule Validation Functions
    internal procedure EvaluateLotNoRestrictionsRule(pLotNoInfo: Record "Lot No. Information"; pRuleCode: Code[50]): Boolean
    var
        lRestrRuleConditionLine: Record "ecRestriction Rule Line";
    begin
        lRestrRuleConditionLine.Reset();
        lRestrRuleConditionLine.SetRange("Rule Code", pRuleCode);
        lRestrRuleConditionLine.SetRange("Line Type", lRestrRuleConditionLine."Line Type"::Condition);
        if not lRestrRuleConditionLine.IsEmpty then begin
            exit(EvaluateLotNoRestrRuleConditions(lRestrRuleConditionLine, pLotNoInfo));
        end;

        exit(true);
    end;

    local procedure EvaluateLotNoRestrRuleConditions(var pRestrRuleConditionLine: Record "ecRestriction Rule Line";
                                                     pLotNoInfo: Record "Lot No. Information"
                                                    ): Boolean
    var
        lRestrRuleConditionLine2: Record "ecRestriction Rule Line";
        lLastRestrRuleConditionLine: Record "ecRestriction Rule Line";
        Temp_lRestrRuleConditionLine: Record "ecRestriction Rule Line" temporary;
        lStopExecution: Boolean;
        lBracketCount: Integer;
        Result: Boolean;
    begin
        if pRestrRuleConditionLine.FindSet() then begin
            lRestrRuleConditionLine2.Reset();
            lRestrRuleConditionLine2.SetRange("Rule Code", pRestrRuleConditionLine."Rule Code");
            lRestrRuleConditionLine2.SetRange("Line Type", lRestrRuleConditionLine2."Line Type"::Condition);

            repeat
                if pRestrRuleConditionLine."Open Bracket" then begin
                    lRestrRuleConditionLine2 := pRestrRuleConditionLine;
                    lStopExecution := false;

                    Clear(Temp_lRestrRuleConditionLine);
                    Temp_lRestrRuleConditionLine.DeleteAll();

                    lRestrRuleConditionLine2."Open Bracket" := false;
                    lBracketCount := 1;

                    repeat
                        Temp_lRestrRuleConditionLine.Init();
                        Temp_lRestrRuleConditionLine := lRestrRuleConditionLine2;
                        Temp_lRestrRuleConditionLine.Insert();

                        if Temp_lRestrRuleConditionLine."Open Bracket" then begin
                            lBracketCount += 1;
                        end;

                        if Temp_lRestrRuleConditionLine."Close Bracket" and
                           (lBracketCount = 1)
                        then begin
                            lStopExecution := true;
                        end;

                        if Temp_lRestrRuleConditionLine."Close Bracket" then begin
                            lBracketCount -= 1;
                        end;
                    until (lRestrRuleConditionLine2.Next() = 0) or lStopExecution;

                    lLastRestrRuleConditionLine := Temp_lRestrRuleConditionLine;
                    lRestrRuleConditionLine2 := pRestrRuleConditionLine;

                    if pRestrRuleConditionLine.Next(-1) = 0 then begin
                        Result := EvaluateLotNoRestrRuleConditions(Temp_lRestrRuleConditionLine, pLotNoInfo);
                    end else begin
                        case pRestrRuleConditionLine."Logical Join" of
                            pRestrRuleConditionLine."Logical Join"::"AND":
                                Result := Result and EvaluateLotNoRestrRuleConditions(Temp_lRestrRuleConditionLine, pLotNoInfo);
                            pRestrRuleConditionLine."Logical Join"::"OR":
                                Result := Result or EvaluateLotNoRestrRuleConditions(Temp_lRestrRuleConditionLine, pLotNoInfo);
                        end;
                    end;
                    pRestrRuleConditionLine := lLastRestrRuleConditionLine;
                end else begin
                    lRestrRuleConditionLine2 := pRestrRuleConditionLine;
                    if pRestrRuleConditionLine.Next(-1) = 0 then
                        Result := EvaluateLotNoRestrictionCondition(lRestrRuleConditionLine2, pLotNoInfo)
                    else
                        case pRestrRuleConditionLine."Logical Join" of
                            pRestrRuleConditionLine."Logical Join"::"AND":
                                Result := Result and EvaluateLotNoRestrictionCondition(lRestrRuleConditionLine2, pLotNoInfo);
                            pRestrRuleConditionLine."Logical Join"::"OR":
                                Result := Result or EvaluateLotNoRestrictionCondition(lRestrRuleConditionLine2, pLotNoInfo);
                        end;
                    pRestrRuleConditionLine := lRestrRuleConditionLine2;
                end;
            until pRestrRuleConditionLine.Next() = 0;
        end;

        exit(Result);
    end;

    local procedure EvaluateLotNoRestrictionCondition(var pRestrRuleConditionLine: Record "ecRestriction Rule Line";
                                                      pLotNoInfo: Record "Lot No. Information"
                                                     ): Boolean
    var
        Temp_lValueBuffer: Record "Name/Value Buffer" temporary;

        lLotNoAttributeValue: Text;
        lCalculatedDate: Date;
    begin
        lLotNoAttributeValue := '';

        case pRestrRuleConditionLine."Attribute Type" of
            pRestrRuleConditionLine."Attribute Type"::Vendor:
                lLotNoAttributeValue := pLotNoInfo."ecVendor No.";

            pRestrRuleConditionLine."Attribute Type"::"Origin Country":
                lLotNoAttributeValue := pLotNoInfo."ecOrigin Country Code";

            pRestrRuleConditionLine."Attribute Type"::Manufacturer:
                lLotNoAttributeValue := pLotNoInfo."ecManufacturer No.";

            pRestrRuleConditionLine."Attribute Type"::Gauge:
                lLotNoAttributeValue := pLotNoInfo.ecGauge;

            pRestrRuleConditionLine."Attribute Type"::Variety:
                lLotNoAttributeValue := pLotNoInfo.ecVariety;
        end;

        case pRestrRuleConditionLine."Condition Type" of
            pRestrRuleConditionLine."Condition Type"::Value:
                begin
                    if (lLotNoAttributeValue = '') then begin
                        exit(true);
                    end else begin
                        exit(lLotNoAttributeValue = pRestrRuleConditionLine."Condition Value");
                    end;
                end;

            pRestrRuleConditionLine."Condition Type"::Filter:
                begin
                    if (lLotNoAttributeValue = '') then begin
                        exit(true);
                    end else begin
                        Clear(Temp_lValueBuffer);
                        Temp_lValueBuffer.DeleteAll();
                        Temp_lValueBuffer.AddNewEntry(Format(pRestrRuleConditionLine."Attribute Type"), lLotNoAttributeValue);

                        Temp_lValueBuffer.SetFilter(Value, pRestrRuleConditionLine."Condition Value");
                        exit(not Temp_lValueBuffer.IsEmpty);
                    end;
                end;

            pRestrRuleConditionLine."Condition Type"::"Date Formula":
                begin
                    case pRestrRuleConditionLine."Attribute Type" of
                        pRestrRuleConditionLine."Attribute Type"::"Crop Period":
                            begin
                                if (pLotNoInfo."ecCrop Vendor Year" <= 0) then begin
                                    exit(true);
                                end else begin
                                    lCalculatedDate := CalcDate(pRestrRuleConditionLine."DateFormula Value", Today);
                                    exit(pLotNoInfo."ecCrop Vendor Year" >= Date2DMY(lCalculatedDate, 3));
                                end;
                            end;

                        else
                            exit(false);
                    end;
                end;
        end;

        exit(false);
    end;

    procedure GetRestrictionRuleDescription(pRuleCode: Code[50]): Text
    var
        lecRestrictionRuleHeader: Record "ecRestriction Rule Header";
    begin
        if lecRestrictionRuleHeader.Get(pRuleCode) then begin
            if (lecRestrictionRuleHeader."Short Description" <> '') then begin
                exit(lecRestrictionRuleHeader."Short Description");
            end;
            if (lecRestrictionRuleHeader.Description <> '') then begin
                exit(lecRestrictionRuleHeader.Description);
            end;
        end;

        exit(pRuleCode);
    end;

    #endregion Rule Validation Functions
    #endregion Restriction Rules Mgt.

    #region Commercial and Productive Restrictions

    procedure RestrictionsAllowedForItem(pItemNo: Code[20]): Boolean
    var
        lItem: Record Item;
    begin
        if lItem.Get(pItemNo) then begin
            case lItem."ecItem Type" of
                lItem."ecItem Type"::"Raw Material":
                    exit(true);
                lItem."ecItem Type"::"Semi-finished Product":
                    exit(true);
                lItem."ecItem Type"::"Finished Product":
                    exit(true);

                else
                    exit(false);
            end;
        end;

        exit(false);
    end;


    #region Fixed Restrictions
    local procedure GetFixedCountryOfOrigin(pItemNo: Code[20]): Code[10]
    var
        lItem: Record Item;
    begin
        if lItem.Get(pItemNo) then begin
            exit(GetFixedCountryOfOrigin(lItem));
        end;

        exit('');
    end;

    local procedure GetFixedCountryOfOrigin(pItem: Record Item): Code[10]
    begin
        if (pItem."No." <> '') then begin
            if pItem."ecMandatory Origin Lot No." and (pItem."Country/Region of Origin Code" <> '') then begin
                exit(pItem."Country/Region of Origin Code");
            end;
        end;

        exit('');
    end;

    local procedure CheckFixedLotNoRestrictions(pLotNoInfo: Record "Lot No. Information";
                                                pFixedCountryOfOrigin: Code[10];
                                                var pRestrDescription: Text;
                                                var pRestrictionsCheckResult: Enum "ecRestrictions Check Result"
                                               ): Boolean
    var
        lOriginRestrLbl: Label 'Origin = %1';
    begin
        pRestrictionsCheckResult := pRestrictionsCheckResult::"No restriction";
        pRestrDescription := '';

        if (pFixedCountryOfOrigin <> '') then begin
            pRestrictionsCheckResult := pRestrictionsCheckResult::Passed;
            pRestrDescription := StrSubstNo(lOriginRestrLbl, pFixedCountryOfOrigin);

            if (pLotNoInfo."Lot No." = '') then begin
                pRestrictionsCheckResult := pRestrictionsCheckResult::Error;
                exit(false);
            end;

            if (pLotNoInfo."ecOrigin Country Code" <> '') then begin
                if (pLotNoInfo."ecOrigin Country Code" <> pFixedCountryOfOrigin) then begin
                    pRestrictionsCheckResult := pRestrictionsCheckResult::Error;
                    exit(false);
                end;
            end;
        end;

        exit(true);
    end;
    #endregion Fixed Restrictions

    #region Purchase
    procedure FindPurchaseRestrictions(pItemNo: Code[20];
                                       pVariantCode: Code[10];
                                       pVendorNo: Code[20];
                                       pReferenceDate: Date;
                                       var pCommercialProductiveRestr: Record "ecCommercial/Productive Restr.";
                                       var pFixedCountryOfOrigin: Code[10]
                                      ): Boolean
    begin
        if RestrictionsAllowedForItem(pItemNo) then begin
            if (pReferenceDate = 0D) then pReferenceDate := WorkDate();

            // Verifica presenza di origine fissata a livello di anagrafica articolo (Articolo da produrre)
            pFixedCountryOfOrigin := GetFixedCountryOfOrigin(pItemNo);

            // Ricerca restrizioni commerciali e produttive
            Clear(pCommercialProductiveRestr);
            pCommercialProductiveRestr.SetCurrentKey(Scope, "Application Type", "No.", "Variant Code",
                                                     "Relation Type", "Relation No.", "Relation Detail No.", "Starting Date");
            pCommercialProductiveRestr.SetRange(Scope, pCommercialProductiveRestr.Scope::Purchase);
            pCommercialProductiveRestr.SetRange("Starting Date", 0D, pReferenceDate);
            pCommercialProductiveRestr.SetFilter("Ending Date", '%1|>=%2', 0D, pReferenceDate);

            // Articolo / Fornitore specifico
            pCommercialProductiveRestr.SetRange("Application Type", pCommercialProductiveRestr."Application Type"::Item);
            pCommercialProductiveRestr.SetRange("No.", pItemNo);
            pCommercialProductiveRestr.SetFilter("Variant Code", '%1|%2', '', pVariantCode);

            if (pVendorNo <> '') then begin
                pCommercialProductiveRestr.SetRange("Relation Type", pCommercialProductiveRestr."Relation Type"::Vendor);
                pCommercialProductiveRestr.SetRange("Relation No.", pVendorNo);
                pCommercialProductiveRestr.SetRange("Relation Detail No.", '');
                if pCommercialProductiveRestr.FindLast() then begin
                    exit(true);
                end;
            end;

            // Articolo / Tutti i fornitori
            pCommercialProductiveRestr.SetRange("Relation Type", pCommercialProductiveRestr."Relation Type"::"All Vendors");
            pCommercialProductiveRestr.SetRange("Relation No.", '');
            pCommercialProductiveRestr.SetRange("Relation Detail No.", '');
            if pCommercialProductiveRestr.FindLast() then begin
                exit(true);
            end;

            // Tutti gli articoli / Fornitore specifico
            pCommercialProductiveRestr.SetRange("Application Type", pCommercialProductiveRestr."Application Type"::"All Items");
            pCommercialProductiveRestr.SetRange("No.", '');
            pCommercialProductiveRestr.SetRange("Variant Code", '');

            if (pVendorNo <> '') then begin
                pCommercialProductiveRestr.SetRange("Relation Type", pCommercialProductiveRestr."Relation Type"::Vendor);
                pCommercialProductiveRestr.SetRange("Relation No.", pVendorNo);
                pCommercialProductiveRestr.SetRange("Relation Detail No.", '');
                if pCommercialProductiveRestr.FindLast() then begin
                    exit(true);
                end;
            end;

            // Tutti gli articoli / Tutti i fornitori
            pCommercialProductiveRestr.SetRange("Relation Type", pCommercialProductiveRestr."Relation Type"::"All Vendors");
            pCommercialProductiveRestr.SetRange("Relation No.", '');
            pCommercialProductiveRestr.SetRange("Relation Detail No.", '');
            if pCommercialProductiveRestr.FindLast() then begin
                exit(true);
            end;

            // Verifica presenza di origine fissata
            if (pFixedCountryOfOrigin <> '') then begin
                exit(true);
            end;
        end;

        // Nessuna restrizione presente
        exit(false);
    end;

    #endregion Purchase

    #region Warehouse Pick
    internal procedure TestWarehousePickRestrictions(pWarehouseActivityLine: Record "Warehouse Activity Line";
                                                     pLotNo: Code[50];
                                                     pFromPosting: Boolean)
    var
        lWhseActivityLine_Place: Record "Warehouse Activity Line";
    begin
        if (pWarehouseActivityLine."Activity Type" = pWarehouseActivityLine."Activity Type"::Pick) then begin
            if (pLotNo <> '') then begin
                if (pWarehouseActivityLine."Whse. Document Type" = pWarehouseActivityLine."Whse. Document Type"::Shipment) then begin
                    if (pWarehouseActivityLine."Whse. Document No." <> '') then begin
                        TestSalesPickingRestrictions(pWarehouseActivityLine."Item No.",
                                                     pWarehouseActivityLine."Variant Code",
                                                     pLotNo,
                                                     pWarehouseActivityLine."Location Code",
                                                     pWarehouseActivityLine."Whse. Document No.",
                                                     pFromPosting);
                    end;
                end else begin
                    if pWarehouseActivityLine.AltAWP_GetLinkedActionLine(lWhseActivityLine_Place) then begin
                        TestProductionPickingRestrictions(pWarehouseActivityLine."Item No.",
                                                          pWarehouseActivityLine."Variant Code",
                                                          pLotNo,
                                                          lWhseActivityLine_Place."Location Code",
                                                          lWhseActivityLine_Place."Bin Code",
                                                          pFromPosting);
                    end;
                end;
            end;
        end;
    end;

    procedure CheckPickRestrictionsOnItemInventoryBuffer(pWarehouseActivityLine: Record "Warehouse Activity Line";
                                                         var Temp_pItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary)
    var
        lWarehouseActivityHeader: Record "Warehouse Activity Header";
        lWhseActivityLine_Place: Record "Warehouse Activity Line";
        Temp_lItemInventoryBuffer2: Record "AltAWPItem Inventory Buffer" temporary;
    begin
        if (pWarehouseActivityLine."Activity Type" = pWarehouseActivityLine."Activity Type"::Pick) then begin
            if lWarehouseActivityHeader.Get(pWarehouseActivityLine."Activity Type", pWarehouseActivityLine."No.") and
               (lWarehouseActivityHeader."AltAWPWhse. Document Type" in [lWarehouseActivityHeader."AltAWPWhse. Document Type"::" ",
                                                                         lWarehouseActivityHeader."AltAWPWhse. Document Type"::Production,
                                                                         lWarehouseActivityHeader."AltAWPWhse. Document Type"::Shipment])
            then begin
                Temp_lItemInventoryBuffer2.Copy(Temp_pItemInventoryBuffer, true);

                Temp_lItemInventoryBuffer2.Reset();
                if Temp_lItemInventoryBuffer2.FindSet() then begin
                    repeat
                        Temp_lItemInventoryBuffer2."ecRestrictions Check Result" := Temp_lItemInventoryBuffer2."ecRestrictions Check Result"::"No restriction";
                        Temp_lItemInventoryBuffer2.ecRestrictions := '';

                        if (lWarehouseActivityHeader."AltAWPWhse. Document Type" = lWarehouseActivityHeader."AltAWPWhse. Document Type"::Shipment) then begin
                            CheckSalesPickingRestrictions(Temp_lItemInventoryBuffer2."Item No.",
                                                          Temp_lItemInventoryBuffer2."Variant Code",
                                                          Temp_lItemInventoryBuffer2."Lot No.",
                                                          Temp_lItemInventoryBuffer2."Location Code",
                                                          lWarehouseActivityHeader."AltAWPWhse. Document No.",
                                                          Temp_lItemInventoryBuffer2.ecRestrictions,
                                                          Temp_lItemInventoryBuffer2."ecRestrictions Check Result");
                        end else begin
                            if pWarehouseActivityLine.AltAWP_GetLinkedActionLine(lWhseActivityLine_Place) then begin
                                CheckProductionPickingRestrictions(Temp_lItemInventoryBuffer2."Item No.",
                                                                   Temp_lItemInventoryBuffer2."Variant Code",
                                                                   Temp_lItemInventoryBuffer2."Lot No.",
                                                                   lWhseActivityLine_Place."Location Code",
                                                                   lWhseActivityLine_Place."Bin Code",
                                                                   Temp_lItemInventoryBuffer2.ecRestrictions,
                                                                   Temp_lItemInventoryBuffer2."ecRestrictions Check Result");
                            end;
                        end;

                        Temp_lItemInventoryBuffer2.Modify(false);
                    until (Temp_lItemInventoryBuffer2.Next() = 0);
                end;
            end;
        end;
    end;
    #endregion Warehouse Pick

    #region Production
    procedure RestrictionsAllowedForProdOrderLine(pProdOrderLine: Record "Prod. Order Line"): Boolean
    begin
        pProdOrderLine.CalcFields("ecIgnore Prod. Restrictions");
        if pProdOrderLine."ecIgnore Prod. Restrictions" then begin
            exit(false);
        end;

        exit(true);
    end;

    local procedure FindProdOrderLineByLotNo(pLotNoInfo: Record "Lot No. Information";
                                             var pProdOrderLine: Record "Prod. Order Line"
                                            ): Boolean
    begin
        pProdOrderLine.Reset();
        pProdOrderLine.SetCurrentKey("ecOutput Lot No.");
        pProdOrderLine.SetRange("ecOutput Lot No.", pLotNoInfo."Lot No.");
        pProdOrderLine.SetRange("Item No.", pLotNoInfo."Item No.");
        pProdOrderLine.SetRange("Variant Code", pLotNoInfo."Variant Code");
        if pProdOrderLine.FindLast() then begin
            exit(true);
        end;

        exit(false);
    end;

    procedure FindProductionRestrictions(pItemNo: Code[20];
                                         pVariantCode: Code[10];
                                         pComponentItemNo: Code[20];
                                         pComponentVariantCode: Code[20];
                                         pReferenceDate: Date;
                                         var pCommercialProductiveRestr: Record "ecCommercial/Productive Restr.";
                                         var pFixedCountryOfOrigin: Code[10]
                                        ): Boolean
    begin
        if RestrictionsAllowedForItem(pItemNo) then begin
            if (pReferenceDate = 0D) then pReferenceDate := WorkDate();

            // Verifica presenza di origine fissata a livello di anagrafica articolo (Articolo da produrre)
            pFixedCountryOfOrigin := GetFixedCountryOfOrigin(pItemNo);

            // Ricerca restrizioni commerciali e produttive
            Clear(pCommercialProductiveRestr);
            pCommercialProductiveRestr.SetCurrentKey(Scope, "Application Type", "No.", "Variant Code",
                                                     "Relation Type", "Relation No.", "Relation Detail No.", "Starting Date");

            pCommercialProductiveRestr.SetRange(Scope, pCommercialProductiveRestr.Scope::Production);
            pCommercialProductiveRestr.SetRange("Starting Date", 0D, pReferenceDate);
            pCommercialProductiveRestr.SetFilter("Ending Date", '%1|>=%2', 0D, pReferenceDate);

            // Articolo specifico / Componente specifico
            pCommercialProductiveRestr.SetRange("Application Type", pCommercialProductiveRestr."Application Type"::Item);
            pCommercialProductiveRestr.SetRange("No.", pItemNo);
            pCommercialProductiveRestr.SetFilter("Variant Code", '%1|%2', '', pVariantCode);

            if (pComponentItemNo <> '') then begin
                pCommercialProductiveRestr.SetRange("Relation Type", pCommercialProductiveRestr."Relation Type"::"Prod. BOM Component");
                pCommercialProductiveRestr.SetRange("Relation No.", pComponentItemNo);
                pCommercialProductiveRestr.SetFilter("Relation Detail No.", '%1|%2', '', pComponentVariantCode);
                if pCommercialProductiveRestr.FindLast() then begin
                    exit(true);
                end;
            end;

            // Articolo specifico / Tutti i componenti
            pCommercialProductiveRestr.SetRange("Relation Type", pCommercialProductiveRestr."Relation Type"::"All BOM Components");
            pCommercialProductiveRestr.SetRange("Relation No.", '');
            pCommercialProductiveRestr.SetRange("Relation Detail No.", '');
            if pCommercialProductiveRestr.FindLast() then begin
                exit(true);
            end;

            // Tutti gli articoli / Componente specifico
            pCommercialProductiveRestr.SetRange("Application Type", pCommercialProductiveRestr."Application Type"::"All Items");
            pCommercialProductiveRestr.SetRange("No.", '');
            pCommercialProductiveRestr.SetRange("Variant Code", '');

            if (pComponentItemNo <> '') then begin
                pCommercialProductiveRestr.SetRange("Relation Type", pCommercialProductiveRestr."Relation Type"::"Prod. BOM Component");
                pCommercialProductiveRestr.SetRange("Relation No.", pComponentItemNo);
                pCommercialProductiveRestr.SetFilter("Relation Detail No.", '%1|%2', '', pComponentVariantCode);
                if pCommercialProductiveRestr.FindLast() then begin
                    exit(true);
                end;
            end;

            // Tutti gli articoli / Tutti i componenti
            pCommercialProductiveRestr.SetRange("Relation Type", pCommercialProductiveRestr."Relation Type"::"All BOM Components");
            pCommercialProductiveRestr.SetRange("Relation No.", '');
            pCommercialProductiveRestr.SetRange("Relation Detail No.", '');
            if pCommercialProductiveRestr.FindLast() then begin
                exit(true);
            end;

            // Verifica presenza di origine fissata
            if (pFixedCountryOfOrigin <> '') then begin
                exit(true);
            end;
        end;

        // Nessuna restrizione presente
        exit(false);
    end;

    procedure FindProdOrderComponentRestrictions(pProdOrderComponent: Record "Prod. Order Component";
                                                 var pCommercialProductiveRestr: Record "ecCommercial/Productive Restr.";
                                                 var pFixedCountryOfOrigin: Code[10]
                                                ): Boolean
    var
        lMasterProdOrderLine: Record "Prod. Order Line";
    begin
        if (pProdOrderComponent."Prod. Order No." <> '') and
           (pProdOrderComponent."Item No." <> '') and
           pProdOrderComponent."AltAWPUse Reserved Cons. Bin"
        then begin
            if FindMasterProdOrderLineForRestrictions(pProdOrderComponent.Status,
                                                      pProdOrderComponent."Prod. Order No.",
                                                      lMasterProdOrderLine)
            then begin
                if not RestrictionsAllowedForProdOrderLine(lMasterProdOrderLine) then begin
                    exit(false);
                end;

                exit(FindProductionRestrictions(lMasterProdOrderLine."Item No.",
                                                lMasterProdOrderLine."Variant Code",
                                                pProdOrderComponent."Item No.",
                                                pProdOrderComponent."Variant Code",
                                                lMasterProdOrderLine."Starting Date",
                                                pCommercialProductiveRestr,
                                                pFixedCountryOfOrigin));
            end;
        end;

        exit(false);
    end;

    procedure FindMasterProdOrderLineByConsumptionBin(pLocationCode: Code[10];
                                                      pBinCode: Code[20];
                                                      var pMasterProdOrderLine: Record "Prod. Order Line"
                                                     ): Boolean
    var
        lProdOrderLine: Record "Prod. Order Line";
        lawpProductionFunctions: Codeunit "AltAWPProduction Functions";
    begin
        if (pBinCode <> '') then begin
            if lawpProductionFunctions.GetProdOrderLineByConsumptionReservedBin(pLocationCode, pBinCode, lProdOrderLine) then begin
                exit(FindMasterProdOrderLineForRestrictions(lProdOrderLine.Status, lProdOrderLine."Prod. Order No.", pMasterProdOrderLine));
            end;
        end;

        exit(false);
    end;

    procedure FindMasterProdOrderLineForRestrictions(pProdOrderStatus: Enum "Production Order Status";
                                                     pProdOrderNo: Code[20];
                                                     var pMasterProdOrderLine: Record "Prod. Order Line"
                                                    ): Boolean
    begin
        // Ricerca prima riga ODP
        Clear(pMasterProdOrderLine);
        pMasterProdOrderLine.SetRange(Status, pProdOrderStatus);
        pMasterProdOrderLine.SetRange("Prod. Order No.", pProdOrderNo);
        exit(pMasterProdOrderLine.FindFirst());
    end;
    #endregion Production

    #region Production Picking
    procedure CheckProductionPickingRestrictions(pItemNo: Code[20];
                                                 pVariantCode: Code[10];
                                                 pLotNo: Code[50];
                                                 pTargetLocationCode: Code[10];
                                                 pTargetBinCode: Code[20];
                                                 var pRestrDescription: Text;
                                                 var pRestrictionsCheckResult: Enum "ecRestrictions Check Result"
                                                ): Boolean
    var
        lCommercialProductiveRestr: Record "ecCommercial/Productive Restr.";
        lLotNoInformation: Record "Lot No. Information";
        lMasterProdOrderLine: Record "Prod. Order Line";
        lawpItemTrackingFunctions: Codeunit "AltAWPItem Tracking Functions";
        lecTrackingFunctions: Codeunit "ecTracking Functions";
        lLastPickedLotNo: Code[50];
        lFixedCountryOfOrigin: Code[10];
    begin
        pRestrictionsCheckResult := pRestrictionsCheckResult::"No restriction";
        pRestrDescription := '';

        if (pItemNo <> '') and (pLotNo <> '') then begin
            if RestrictionsAllowedForItem(pItemNo) then begin
                if not lLotNoInformation.Get(pItemNo, pVariantCode, pLotNo) then begin
                    Clear(lLotNoInformation);
                end;

                //Check presenza della scheda info lotto rilasciata
                if not lecTrackingFunctions.CheckComponentLotNoInfo(pItemNo, pVariantCode, pLotNo, pRestrDescription) then begin
                    pRestrictionsCheckResult := pRestrictionsCheckResult::Error;
                    exit(false);
                end;

                // Ricerca prima riga ODP
                // Solo per componenti da prelevare su collocazioni di produzione riservate
                if FindMasterProdOrderLineByConsumptionBin(pTargetLocationCode, pTargetBinCode, lMasterProdOrderLine) then begin
                    if RestrictionsAllowedForProdOrderLine(lMasterProdOrderLine) then begin
                        // Verifica restrizioni commerciali e produttive
                        if FindProductionRestrictions(lMasterProdOrderLine."Item No.",
                                                      lMasterProdOrderLine."Variant Code",
                                                      pItemNo,
                                                      pVariantCode,
                                                      lMasterProdOrderLine."Starting Date",
                                                      lCommercialProductiveRestr,
                                                      lFixedCountryOfOrigin)
                        then begin
                            // Check restrizioni fisse in funzione dei parametri definiti su scheda articolo
                            if not CheckFixedLotNoRestrictions(lLotNoInformation, lFixedCountryOfOrigin,
                                                               pRestrDescription, pRestrictionsCheckResult)
                            then begin
                                // Se si tratta di errore esco subito altrimenti procedo con le altre verifiche
                                if (pRestrictionsCheckResult = pRestrictionsCheckResult::Error) then begin
                                    exit(false);
                                end;
                            end;

                            // Check regola di restrizione
                            if (lCommercialProductiveRestr."Restriction Rule Code" <> '') then begin
                                if (pRestrictionsCheckResult = pRestrictionsCheckResult::"No restriction") then begin
                                    pRestrictionsCheckResult := pRestrictionsCheckResult::Passed;
                                end;
                                pRestrDescription := GetRestrictionRuleDescription(lCommercialProductiveRestr."Restriction Rule Code");

                                if (lLotNoInformation."Lot No." = '') then begin
                                    pRestrictionsCheckResult := pRestrictionsCheckResult::Error;
                                    exit(false);
                                end else begin
                                    if not EvaluateLotNoRestrictionsRule(lLotNoInformation, lCommercialProductiveRestr."Restriction Rule Code") then begin
                                        pRestrictionsCheckResult := GetRestrictionCheckResult(lCommercialProductiveRestr."Negative Result Notification");

                                        // Se si tratta di errore esco subito altrimenti procedo con le altre verifiche
                                        if (pRestrictionsCheckResult = pRestrictionsCheckResult::Error) then begin
                                            exit(false);
                                        end;
                                    end;
                                end;
                            end;

                            // Check vincolo di prelievo mono-lotto
                            if lCommercialProductiveRestr."Single Lot Pickings" then begin
                                if (lMasterProdOrderLine.Status = lMasterProdOrderLine.Status::Released) then begin
                                    if (pRestrDescription = '') then begin
                                        pRestrDescription := SingleLotRestrLbl;
                                    end;

                                    lLastPickedLotNo := GetLastPickedLotNo4Production(pItemNo, pVariantCode, pTargetLocationCode, pTargetBinCode);
                                    if (lLastPickedLotNo <> '') and (pLotNo <> lLastPickedLotNo) then begin
                                        pRestrDescription := SingleLotRestrLbl;
                                        pRestrictionsCheckResult := pRestrictionsCheckResult::Error;
                                        exit(false);
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;

            //Check lotto scaduto
            if lawpItemTrackingFunctions.IsItemInventoryExpired(pItemNo, pVariantCode, pTargetLocationCode, pLotNo, '', 0D) then begin
                pRestrDescription := ExpiredLotLbl;
                pRestrictionsCheckResult := pRestrictionsCheckResult::Error;
                exit(false);
            end;
        end;

        if (pRestrictionsCheckResult in [pRestrictionsCheckResult::"No restriction",
                                         pRestrictionsCheckResult::Passed])
        then begin
            exit(true);
        end;

        exit(false);
    end;

    local procedure TestProductionPickingRestrictions(pItemNo: Code[20];
                                                      pVariantCode: Code[10];
                                                      pLotNo: Code[50];
                                                      pTargetLocationCode: Code[10];
                                                      pTargetBinCode: Code[20];
                                                      pFromPosting: Boolean)
    var
        lRestrictionsCheckResult: Enum "ecRestrictions Check Result";
        lRestrDescription: Text;
        lNotificationText: Text;
        lNotUsableCompWithLotLbl: Label 'The lot no. %1 of component %2 is not usable in this context due to the following restriction: "%3"';
        lNotUsableCompConf: Label '%1\\Do you want to use it?';
        lOperationCancelledErr: Label 'Operation cancelled';
    begin
        if not CheckProductionPickingRestrictions(pItemNo, pVariantCode, pLotNo,
                                                  pTargetLocationCode, pTargetBinCode,
                                                  lRestrDescription, lRestrictionsCheckResult)
        then begin
            if pFromPosting then begin
                if (lRestrictionsCheckResult = lRestrictionsCheckResult::Warning) then begin
                    lRestrictionsCheckResult := lRestrictionsCheckResult::Passed;
                end;
            end;

            if not GuiAllowed then begin
                lRestrictionsCheckResult := lRestrictionsCheckResult::Error;
            end;

            lNotificationText := StrSubstNo(lNotUsableCompWithLotLbl, pLotNo, pItemNo, lRestrDescription);

            case lRestrictionsCheckResult of
                lRestrictionsCheckResult::Error:
                    Error(lNotificationText);

                lRestrictionsCheckResult::Warning:
                    begin
                        if not Confirm(lNotUsableCompConf, false, lNotificationText) then begin
                            Error(lOperationCancelledErr);
                        end;
                    end;
            end;
        end;
    end;

    local procedure GetLastPickedLotNo4Production(pItemNo: Code[20];
                                                  pVariantCode: Code[10];
                                                  pTargetLocationCode: Code[10];
                                                  pTargetBinCode: Code[20]
                                                 ): Code[50]
    var
        lItemLedgerEntry: Record "Item Ledger Entry";
        lWarehouseEntry: Record "Warehouse Entry";
        lRefProdOrderLine: Record "Prod. Order Line";
        lawpProductionFunctions: Codeunit "AltAWPProduction Functions";
    begin
        if (pTargetBinCode <> '') then begin
            if lawpProductionFunctions.GetProdOrderLineByConsumptionReservedBin(pTargetLocationCode, pTargetBinCode, lRefProdOrderLine) then begin
                lItemLedgerEntry.Reset();
                lItemLedgerEntry.SetCurrentKey("Item No.", "Variant Code", "Order No.", "Order Type", "Entry Type", "Posting Date");
                lItemLedgerEntry.SetRange("Item No.", pItemNo);
                lItemLedgerEntry.SetRange("Variant Code", pVariantCode);
                lItemLedgerEntry.SetRange("Order No.", lRefProdOrderLine."Prod. Order No.");
                lItemLedgerEntry.SetRange("Order Type", lItemLedgerEntry."Order Type"::Production);
                lItemLedgerEntry.SetRange("Entry Type", lItemLedgerEntry."Entry Type"::Consumption);
                lItemLedgerEntry.SetRange(Correction, false);

                lItemLedgerEntry.SetLoadFields("Lot No.");
                if lItemLedgerEntry.FindLast() then begin
                    if (lItemLedgerEntry."Lot No." <> '') then begin
                        exit(lItemLedgerEntry."Lot No.");
                    end;
                end;
            end;

            lWarehouseEntry.Reset();
            lWarehouseEntry.SetCurrentKey("Item No.", "Bin Code", "Location Code", "Variant Code", "Entry Type");
            lWarehouseEntry.SetRange("Item No.", pItemNo);
            lWarehouseEntry.SetRange("Bin Code", pTargetBinCode);
            lWarehouseEntry.SetRange("Location Code", pTargetLocationCode);
            lWarehouseEntry.SetRange("Variant Code", pVariantCode);
            lWarehouseEntry.SetFilter("Entry Type", '%1|%2', lWarehouseEntry."Entry Type"::"Positive Adjmt.",
                                                             lWarehouseEntry."Entry Type"::Movement);
            lWarehouseEntry.SetRange(AltAWPCorrection, false);

            lWarehouseEntry.SetLoadFields("Lot No.");
            if lWarehouseEntry.FindLast() then begin
                if (lWarehouseEntry."Lot No." <> '') then begin
                    exit(lWarehouseEntry."Lot No.");
                end;
            end;
        end;

        exit('');
    end;
    #endregion Production Picking

    #region Sales
    procedure FindSalesRestrictions(pItemNo: Code[20];
                                    pVariantCode: Code[10];
                                    pCustomerNo: Code[20];
                                    pReferenceDate: Date;
                                    var pCommercialProductiveRestr: Record "ecCommercial/Productive Restr."
                                   ): Boolean
    begin
        if RestrictionsAllowedForItem(pItemNo) then begin
            if (pReferenceDate = 0D) then pReferenceDate := WorkDate();

            Clear(pCommercialProductiveRestr);
            pCommercialProductiveRestr.SetCurrentKey(Scope, "Application Type", "No.", "Variant Code",
                                                     "Relation Type", "Relation No.", "Relation Detail No.", "Starting Date");
            pCommercialProductiveRestr.SetRange(Scope, pCommercialProductiveRestr.Scope::Sales);
            pCommercialProductiveRestr.SetRange("Starting Date", 0D, pReferenceDate);
            pCommercialProductiveRestr.SetFilter("Ending Date", '%1|>=%2', 0D, pReferenceDate);

            // Articolo / Cliente specifico
            pCommercialProductiveRestr.SetRange("Application Type", pCommercialProductiveRestr."Application Type"::Item);
            pCommercialProductiveRestr.SetRange("No.", pItemNo);
            pCommercialProductiveRestr.SetFilter("Variant Code", '%1|%2', '', pVariantCode);

            if (pCustomerNo <> '') then begin
                pCommercialProductiveRestr.SetRange("Relation Type", pCommercialProductiveRestr."Relation Type"::Customer);
                pCommercialProductiveRestr.SetRange("Relation No.", pCustomerNo);
                pCommercialProductiveRestr.SetRange("Relation Detail No.", '');
                if pCommercialProductiveRestr.FindLast() then begin
                    exit(true);
                end;
            end;

            // Articolo / Tutti i clienti
            pCommercialProductiveRestr.SetRange("Relation Type", pCommercialProductiveRestr."Relation Type"::"All Customers");
            pCommercialProductiveRestr.SetRange("Relation No.", '');
            pCommercialProductiveRestr.SetRange("Relation Detail No.", '');
            if pCommercialProductiveRestr.FindLast() then begin
                exit(true);
            end;

            // Tutti gli articoli / Cliente specifico
            pCommercialProductiveRestr.SetRange("Application Type", pCommercialProductiveRestr."Application Type"::"All Items");
            pCommercialProductiveRestr.SetRange("No.", '');
            pCommercialProductiveRestr.SetRange("Variant Code", '');

            if (pCustomerNo <> '') then begin
                pCommercialProductiveRestr.SetRange("Relation Type", pCommercialProductiveRestr."Relation Type"::Customer);
                pCommercialProductiveRestr.SetRange("Relation No.", pCustomerNo);
                pCommercialProductiveRestr.SetRange("Relation Detail No.", '');
                if pCommercialProductiveRestr.FindLast() then begin
                    exit(true);
                end;
            end;

            // Tutti gli articoli / Tutti i clienti
            pCommercialProductiveRestr.SetRange("Relation Type", pCommercialProductiveRestr."Relation Type"::"All Customers");
            pCommercialProductiveRestr.SetRange("Relation No.", '');
            pCommercialProductiveRestr.SetRange("Relation Detail No.", '');
            if pCommercialProductiveRestr.FindLast() then begin
                exit(true);
            end;
        end;

        exit(false);
    end;

    #endregion Sales

    #region Sales Picking
    procedure CheckSalesPickingRestrictions(pItemNo: Code[20];
                                            pVariantCode: Code[10];
                                            pLotNo: Code[50];
                                            pLocationCode: Code[10];
                                            pWhseShipmentNo: Code[20];
                                            var pRestrDescription: Text;
                                            var pRestrictionsCheckResult: Enum "ecRestrictions Check Result"
                                           ): Boolean
    var
        lCommercialProductiveRestr: Record "ecCommercial/Productive Restr.";
        lLotNoInformation: Record "Lot No. Information";
        lWarehouseShipmentHeader: Record "Warehouse Shipment Header";
        lecTrackingFunctions: Codeunit "ecTracking Functions";
        lawpItemTrackingFunctions: Codeunit "AltAWPItem Tracking Functions";
        lLastPickedLotNo: Code[50];
        lLastShippedLotNo: Code[50];
        lLastShippedLotExpDate: Date;
    begin
        pRestrictionsCheckResult := pRestrictionsCheckResult::"No restriction";
        pRestrDescription := '';

        if (pItemNo <> '') and (pLotNo <> '') then begin

            Clear(lWarehouseShipmentHeader);
            if (pWhseShipmentNo <> '') then begin
                if not lWarehouseShipmentHeader.Get(pWhseShipmentNo) then begin
                    Clear(lWarehouseShipmentHeader);
                end;

                if (lWarehouseShipmentHeader."AltAWPSource Document Type" <> lWarehouseShipmentHeader."AltAWPSource Document Type"::"Sales Order") then begin
                    exit(true);
                end;
            end;

            if not lLotNoInformation.Get(pItemNo, pVariantCode, pLotNo) then begin
                Clear(lLotNoInformation);
            end;

            //Check presenza della scheda info lotto rilasciata
            if not lecTrackingFunctions.CheckComponentLotNoInfo(pItemNo, pVariantCode, pLotNo, pRestrDescription) then begin
                pRestrictionsCheckResult := pRestrictionsCheckResult::Error;
                exit(false);
            end;

            // Verifica restrizioni commerciali e produttive
            if FindSalesRestrictions(pItemNo, pVariantCode,
                                     lWarehouseShipmentHeader."AltAWPSubject No.", lWarehouseShipmentHeader."Shipment Date",
                                     lCommercialProductiveRestr)
            then begin
                // Check regola di restrizione
                if (lCommercialProductiveRestr."Restriction Rule Code" <> '') then begin
                    if (pRestrictionsCheckResult = pRestrictionsCheckResult::"No restriction") then begin
                        pRestrictionsCheckResult := pRestrictionsCheckResult::Passed;
                    end;
                    pRestrDescription := GetRestrictionRuleDescription(lCommercialProductiveRestr."Restriction Rule Code");

                    if (lLotNoInformation."Lot No." = '') then begin
                        pRestrictionsCheckResult := pRestrictionsCheckResult::Error;
                        exit(false);
                    end else begin
                        if not EvaluateLotNoRestrictionsRule(lLotNoInformation, lCommercialProductiveRestr."Restriction Rule Code") then begin
                            pRestrictionsCheckResult := GetRestrictionCheckResult(lCommercialProductiveRestr."Negative Result Notification");

                            // Se si tratta di errore esco subito altrimenti procedo con le altre verifiche
                            if (pRestrictionsCheckResult = pRestrictionsCheckResult::Error) then begin
                                exit(false);
                            end;
                        end;
                    end;
                end;

                // Check vincolo di prelievo mono-lotto
                if lCommercialProductiveRestr."Single Lot Pickings" then begin
                    if (pRestrDescription = '') then begin
                        pRestrDescription := SingleLotRestrLbl;
                    end;

                    lLastPickedLotNo := GetLastPickedLotNo4Sales(pItemNo, pVariantCode, pWhseShipmentNo);
                    if (lLastPickedLotNo <> '') and (pLotNo <> lLastPickedLotNo) then begin
                        pRestrDescription := SingleLotRestrLbl;
                        pRestrictionsCheckResult := pRestrictionsCheckResult::Error;
                        exit(false);
                    end;
                end;

                if lCommercialProductiveRestr."Progressive Lot No. Expiration" then begin
                    if (pRestrDescription = '') then begin
                        pRestrDescription := ProgressiveExpRestrLbl;
                    end;

                    if GetLastShippedLotExpirationDate(lWarehouseShipmentHeader."AltAWPSubject No.", pItemNo, pVariantCode,
                                                       lLastShippedLotNo, lLastShippedLotExpDate)
                    then begin
                        if (lLotNoInformation."ecExpiration Date" < lLastShippedLotExpDate) then begin
                            pRestrDescription := ProgressiveExpRestrLbl;
                            pRestrictionsCheckResult := pRestrictionsCheckResult::Error;
                            exit(false);
                        end;
                    end;
                end;
            end;

            // Check lotto scaduto
            if lawpItemTrackingFunctions.IsItemInventoryExpired(pItemNo, pVariantCode, pLocationCode, pLotNo, '', 0D) then begin
                pRestrDescription := ExpiredLotLbl;
                pRestrictionsCheckResult := pRestrictionsCheckResult::Error;
                exit(false);
            end;
        end;

        if (pRestrictionsCheckResult in [pRestrictionsCheckResult::"No restriction",
                                         pRestrictionsCheckResult::Passed])
        then begin
            exit(true);
        end;

        exit(false);
    end;

    local procedure GetLastShippedLotExpirationDate(pCustomerNo: Code[20];
                                                    pItemNo: Code[20];
                                                    pVariantCode: Code[10];
                                                    var rLotNo: Code[50];
                                                    var rExpirationDate: Date
                                                   ): Boolean
    var
        lItemLedgerEntry: Record "Item Ledger Entry";
    begin
        rLotNo := '';
        rExpirationDate := 0D;

        lItemLedgerEntry.Reset();
        lItemLedgerEntry.SetCurrentKey("Source Type", "Source No.", "Item No.", "Variant Code", "Posting Date");
        lItemLedgerEntry.SetRange("Source Type", lItemLedgerEntry."Source Type"::Customer);
        lItemLedgerEntry.SetRange("Source No.", pCustomerNo);
        lItemLedgerEntry.SetRange("Item No.", pItemNo);
        lItemLedgerEntry.SetRange("Variant Code", pVariantCode);
        lItemLedgerEntry.SetRange("Entry Type", lItemLedgerEntry."Entry Type"::Sale);
        lItemLedgerEntry.SetRange(Correction, false);

        lItemLedgerEntry.SetLoadFields("Lot No.", "Expiration Date");
        if lItemLedgerEntry.FindLast() then begin
            rLotNo := lItemLedgerEntry."Lot No.";
            rExpirationDate := lItemLedgerEntry."Expiration Date";

            exit(true);
        end;

        exit(false);
    end;

    local procedure GetLastPickedLotNo4Sales(pItemNo: Code[20]; pVariantCode: Code[10]; pWhseShipmentNo: Code[20]): Code[50]
    var
        lRegisteredWhseActivityLine: Record "Registered Whse. Activity Line";
    begin
        lRegisteredWhseActivityLine.Reset();
        lRegisteredWhseActivityLine.SetCurrentKey("Whse. Document No.", "Whse. Document Type", "Activity Type", "Action Type");
        lRegisteredWhseActivityLine.SetRange("Whse. Document No.", pWhseShipmentNo);
        lRegisteredWhseActivityLine.SetRange("Whse. Document Type", lRegisteredWhseActivityLine."Whse. Document Type"::Shipment);
        lRegisteredWhseActivityLine.SetRange("Activity Type", lRegisteredWhseActivityLine."Activity Type"::Pick);
        lRegisteredWhseActivityLine.SetRange("Action Type", lRegisteredWhseActivityLine."Action Type"::Take);
        lRegisteredWhseActivityLine.SetRange(AltAWPCorrection, false);
        lRegisteredWhseActivityLine.SetRange("Item No.", pItemNo);
        lRegisteredWhseActivityLine.SetRange("Variant Code", pVariantCode);

        lRegisteredWhseActivityLine.SetLoadFields("Lot No.");
        if lRegisteredWhseActivityLine.FindLast() then begin
            exit(lRegisteredWhseActivityLine."Lot No.");
        end;

        exit('');
    end;

    local procedure TestSalesPickingRestrictions(pItemNo: Code[20];
                                                 pVariantCode: Code[10];
                                                 pLotNo: Code[50];
                                                 pLocationCode: Code[10];
                                                 pWhseShipmentNo: Code[20];
                                                 pFromPosting: Boolean)
    var
        lRestrictionsCheckResult: Enum "ecRestrictions Check Result";
        lRestrDescription: Text;
        lNotificationText: Text;
        lNotUsableItemWithLotLbl: Label 'The lot no. %1 of item %2 is not usable in this context due to the following restriction: "%3"';
        lNotUsableCompConf: Label '%1\\Do you want to use it?';
        lOperationCancelledErr: Label 'Operation cancelled';
    begin
        if not CheckSalesPickingRestrictions(pItemNo, pVariantCode, pLotNo, pLocationCode, pWhseShipmentNo,
                                             lRestrDescription, lRestrictionsCheckResult)
        then begin
            if pFromPosting then begin
                if (lRestrictionsCheckResult = lRestrictionsCheckResult::Warning) then begin
                    lRestrictionsCheckResult := lRestrictionsCheckResult::Passed;
                end;
            end;

            if not GuiAllowed then begin
                lRestrictionsCheckResult := lRestrictionsCheckResult::Error;
            end;

            lNotificationText := StrSubstNo(lNotUsableItemWithLotLbl, pLotNo, pItemNo, lRestrDescription);

            case lRestrictionsCheckResult of
                lRestrictionsCheckResult::Error:
                    Error(lNotificationText);

                lRestrictionsCheckResult::Warning:
                    begin
                        if not Confirm(lNotUsableCompConf, false, lNotificationText) then begin
                            Error(lOperationCancelledErr);
                        end;
                    end;
            end;
        end;
    end;

    #endregion Sales Picking

    #region Lot No. Release
    internal procedure TestLotNoRestrictionOnRelease(pLotNoInfo: Record "Lot No. Information";
                                                     pShowDialogs: Boolean)
    var
        lCommercialProductiveRestr: Record "ecCommercial/Productive Restr.";
        lFixedCountryOfOrigin: Code[10];
        lRestrApplicationScope: Enum "ecRestr. Application Scope";

        lFixedCountryErr: Label 'Unable to release lot no. %1 for the Item %2 because only %3 origin lots are expected for the item';
        lRuleNotVerifiedErr: Label 'Unable to release lot no. %1 for the Item %2 because it does not match the conditions defined in restriction rule %3';
        lRuleNotVerifiedConf: Label 'Lot %1 for item %2 does not match the conditions defined in restriction rule %3.\Do you want to complete the release process?';
        lOperationCancelledErr: Label 'Operation cancelled';
    begin
        lFixedCountryOfOrigin := '';

        // Determinazione ambito di applicazione delle restrizioni
        lRestrApplicationScope := DetectLotNoRestrictionsApplicationScope(pLotNoInfo);

        // Verifica restrizioni commerciali e produttive
        case lRestrApplicationScope of
            lRestrApplicationScope::Purchase:
                begin
                    if not FindPurchaseRestrictions(pLotNoInfo."Item No.",
                                                    pLotNoInfo."Variant Code",
                                                    pLotNoInfo."ecVendor No.",
                                                    Today,
                                                    lCommercialProductiveRestr,
                                                    lFixedCountryOfOrigin)
                    then begin
                        exit;
                    end;
                end;

            lRestrApplicationScope::Production:
                begin
                    if not FindProductionRestrictions(pLotNoInfo."Item No.",
                                                      pLotNoInfo."Variant Code",
                                                      '', '',
                                                      Today,
                                                      lCommercialProductiveRestr,
                                                      lFixedCountryOfOrigin)
                    then begin
                        exit;
                    end;
                end;
            else
                exit;
        end;

        if not GuiAllowed then pShowDialogs := false;

        if (lFixedCountryOfOrigin <> '') then begin
            if (pLotNoInfo."ecOrigin Country Code" <> '') then begin
                if (pLotNoInfo."ecOrigin Country Code" <> lFixedCountryOfOrigin) then begin
                    Error(lFixedCountryErr, pLotNoInfo."Lot No.",
                                            pLotNoInfo."Item No.",
                                            lFixedCountryOfOrigin);
                end;
            end;
        end;

        if (lCommercialProductiveRestr."Restriction Rule Code" <> '') then begin
            if not EvaluateLotNoRestrictionsRule(pLotNoInfo, lCommercialProductiveRestr."Restriction Rule Code") then begin
                if pShowDialogs and
                   (lCommercialProductiveRestr."Negative Result Notification" = lCommercialProductiveRestr."Negative Result Notification"::Warning)
                then begin
                    if not Confirm(lRuleNotVerifiedConf, false,
                                   pLotNoInfo."Lot No.",
                                   pLotNoInfo."Item No.",
                                   lCommercialProductiveRestr."Restriction Rule Code")
                    then begin
                        Error(lOperationCancelledErr);
                    end;
                end else begin
                    Error(lRuleNotVerifiedErr, pLotNoInfo."Lot No.",
                                               pLotNoInfo."Item No.",
                                               lCommercialProductiveRestr."Restriction Rule Code");
                end;
            end;
        end;
    end;

    local procedure DetectLotNoRestrictionsApplicationScope(pLotNoInfo: Record "Lot No. Information"): Enum "ecRestr. Application Scope"
    var
        lItem: Record Item;
        lProdOrderLine: Record "Prod. Order Line";
        lRestrApplicationScope: Enum "ecRestr. Application Scope";
    begin
        lRestrApplicationScope := lRestrApplicationScope::" ";

        if RestrictionsAllowedForItem(pLotNoInfo."Item No.") then begin
            case pLotNoInfo."ecLot Creation Process" of
                pLotNoInfo."ecLot Creation Process"::"Purchase Receipt":
                    lRestrApplicationScope := lRestrApplicationScope::Purchase;

                pLotNoInfo."ecLot Creation Process"::"Production Output":
                    lRestrApplicationScope := lRestrApplicationScope::Production;

                pLotNoInfo."ecLot Creation Process"::Manual:
                    begin
                        if (pLotNoInfo."ecVendor No." <> '') then begin
                            lRestrApplicationScope := lRestrApplicationScope::Purchase;
                        end else begin
                            if lItem.Get(pLotNoInfo."Item No.") then begin
                                if (lItem."ecItem Type" in [lItem."ecItem Type"::"Finished Product",
                                                            lItem."ecItem Type"::"Semi-finished Product"])
                                then begin
                                    lRestrApplicationScope := lRestrApplicationScope::Production;
                                end;
                            end;
                        end;
                    end;
            end;
        end;

        if (lRestrApplicationScope = lRestrApplicationScope::Production) then begin
            if FindProdOrderLineByLotNo(pLotNoInfo, lProdOrderLine) then begin
                if not RestrictionsAllowedForProdOrderLine(lProdOrderLine) then begin
                    lRestrApplicationScope := lRestrApplicationScope::" ";
                end;
            end;
        end;

        exit(lRestrApplicationScope);
    end;
    #endregion Lot No. Release

    #region Inventory Posting
    internal procedure TestRestrictionsOnInventoryPosting(pItemJournalLine: Record "Item Journal Line";
                                                          pFromPosting: Boolean)
    var
        lRestrictionsCheckResult: Enum "ecRestrictions Check Result";
        lLotNoWithRestr: Code[50];
        lTargetBinCode: Code[20];
        lRestrDescription: Text;
        lNotificationText: Text;
        lNotUsableCompWithLotLbl: Label 'Unable to load quantity of lot %1 of item %2 in bin %3 due to the following restriction not respected: "%4';
        lNotUsableCompConf: Label '%1\\Do you want to use it?';
        lOperationCancelledErr: Label 'Operation cancelled';
    begin
        if not CheckRestrictionsOnInventoryPosting(pItemJournalLine, lRestrDescription, lRestrictionsCheckResult, lLotNoWithRestr) then begin
            if not GuiAllowed then begin
                //TODO da verificare come gestire i warning sia da WMS che da client BC (in questo caso occorrerebbe ridurre il numero di confirm)
                if (lRestrictionsCheckResult = lRestrictionsCheckResult::Warning) then begin
                    lRestrictionsCheckResult := lRestrictionsCheckResult::Passed;
                end;
            end;

            lTargetBinCode := pItemJournalLine."Bin Code";
            if (pItemJournalLine."New Bin Code" <> '') then begin
                lTargetBinCode := pItemJournalLine."New Bin Code";
            end;

            lNotificationText := StrSubstNo(lNotUsableCompWithLotLbl, lLotNoWithRestr, pItemJournalLine."Item No.", lTargetBinCode, lRestrDescription);

            case lRestrictionsCheckResult of
                lRestrictionsCheckResult::Error:
                    Error(lNotificationText);

                lRestrictionsCheckResult::Warning:
                    begin
                        if not Confirm(lNotUsableCompConf, false, lNotificationText) then begin
                            Error(lOperationCancelledErr);
                        end;
                    end;
            end;
        end;
    end;

    internal procedure CheckRestrictionsOnInventoryPosting(pItemJournalLine: Record "Item Journal Line";
                                                           var pRestrDescription: Text;
                                                           var pRestrictionsCheckResult: Enum "ecRestrictions Check Result";
                                                           var pLotNoWithRestr: Code[50]
                                                          ): Boolean
    var
        Temp_lTrackingSpecification: Record "Tracking Specification" temporary;
        lTargetBin: Record Bin;
        latsItemTrackingReader: Codeunit "AltATSItem Tracking Reader";

        lTargetLocationCode: Code[10];
        lTargetBinCode: Code[20];
        lLotNo: Code[50];
    begin
        pRestrictionsCheckResult := pRestrictionsCheckResult::"No restriction";
        pRestrDescription := '';
        pLotNoWithRestr := '';

        if (pItemJournalLine."Item No." <> '') and
           ((pItemJournalLine.Signed(pItemJournalLine.Quantity) > 0) or
            (pItemJournalLine."Entry Type" = pItemJournalLine."Entry Type"::Transfer))
        then begin
            lTargetLocationCode := pItemJournalLine."Location Code";
            lTargetBinCode := pItemJournalLine."Bin Code";

            lLotNo := pItemJournalLine."Lot No.";
            if (lLotNo = '') then begin
                lLotNo := pItemJournalLine."AltAWPLot No.";
            end;

            if (pItemJournalLine."Entry Type" = pItemJournalLine."Entry Type"::Transfer) then begin
                lTargetLocationCode := pItemJournalLine."New Location Code";
                lTargetBinCode := pItemJournalLine."New Bin Code";
            end;

            if (lTargetBinCode <> '') then begin
                lTargetBin.Get(lTargetLocationCode, lTargetBinCode);

                if (lTargetBin."AltAWPBin Type" in [lTargetBin."AltAWPBin Type"::Production,
                                                    lTargetBin."AltAWPBin Type"::Output])
                then begin
                    if (lLotNo <> '') then begin
                        Temp_lTrackingSpecification."Entry No." := 1;
                        Temp_lTrackingSpecification."Lot No." := lLotNo;
                        Temp_lTrackingSpecification.Insert(false);
                    end else begin
                        latsItemTrackingReader.ReadByItemJournalLine(pItemJournalLine, Temp_lTrackingSpecification);
                    end;

                    if Temp_lTrackingSpecification.FindSet() then begin
                        repeat
                            if not CheckProductionPickingRestrictions(pItemJournalLine."Item No.",
                                                                      pItemJournalLine."Variant Code",
                                                                      Temp_lTrackingSpecification."Lot No.",
                                                                      lTargetLocationCode,
                                                                      lTargetBinCode,
                                                                      pRestrDescription,
                                                                      pRestrictionsCheckResult)
                            then begin
                                pLotNoWithRestr := Temp_lTrackingSpecification."Lot No.";
                                exit(false);
                            end;
                        until (Temp_lTrackingSpecification.Next() = 0);
                    end;
                end;
            end;
        end;

        exit(true);
    end;

    #endregion Inventory Posting

    #endregion Commercial and Productive Restrictions

    #region Utilities
    local procedure GetRestrictionCheckResult(pNegativeRestrNotifType: Enum "ecNegative Restr. Notif. Type"): Enum "ecRestrictions Check Result"
    begin
        case pNegativeRestrNotifType of
            pNegativeRestrNotifType::Error:
                exit("ecRestrictions Check Result"::Error);
            pNegativeRestrNotifType::Warning:
                exit("ecRestrictions Check Result"::Warning);
        end;
    end;
    #endregion Utilities
}
