namespace EuroCompany.BaseApp.Inventory.Tracking;
using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Manufacturing;
using EuroCompany.BaseApp.Manufacturing.Document;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Journal;

using Microsoft.Inventory.Tracking;
using Microsoft.Manufacturing.Document;
using Microsoft.Purchases.Document;
using Microsoft.Warehouse.Activity;
using Microsoft.Warehouse.Document;
using Microsoft.Warehouse.Ledger;
using Microsoft.Warehouse.Structure;
using System.Utilities;

codeunit 50006 "ecTracking Functions"
{
    #region CS_PRO_008

    internal procedure GetNewItemLotNo(pItemNo: Code[20]; pVariantCode: Code[10]; pCreateLotNoInformation: Boolean; pWithCommit: Boolean): Code[20]
    var
        lItem: Record Item;
        lItemTrackingCode: Record "Item Tracking Code";
        lLotNoInformation: Record "Lot No. Information";
        lNewLotNo: Code[20];
        lStartingNo: Code[10];
        lLetterOfMonth: Char;
    begin
        //CS_PRO_008-s
        if not lItem.Get(pItemNo) then exit;
        if (lItem."Item Tracking Code" = '') or not lItemTrackingCode.Get(lItem."Item Tracking Code") or not lItemTrackingCode."Lot Specific Tracking" then exit;

        lNewLotNo := '';
        case lItem."ecItem Type" of
            lItem."ecItem Type"::"Finished Product":
                begin
                    lLetterOfMonth := 64 + Date2DMY(Today, 2);
                    lNewLotNo := CopyStr(Format(Date2DMY(Today, 3)), 3) + Format(lLetterOfMonth);
                    lStartingNo := '0001';
                end;
            lItem."ecItem Type"::"Semi-finished Product":
                begin
                    lLetterOfMonth := 64 + Date2DMY(Today, 2);
                    lNewLotNo := CopyStr(Format(Date2DMY(Today, 3)), 3) + 'S' + Format(lLetterOfMonth);
                    lStartingNo := '0001';
                end;
            else begin
                lNewLotNo := CopyStr(Format(Date2DMY(Today, 3)), 3) + 'X';
                lStartingNo := '00001';
            end;
        end;

        Clear(lLotNoInformation);
        lLotNoInformation.LockTable();
        lLotNoInformation.SetCurrentKey("Lot No.");
        lLotNoInformation.SetFilter("Lot No.", '%1', lNewLotNo + '*');
        if not lLotNoInformation.IsEmpty then begin
            lLotNoInformation.FindLast();
            lNewLotNo := IncStr(lLotNoInformation."Lot No.");
        end else begin
            lNewLotNo += lStartingNo;
        end;

        if pCreateLotNoInformation then begin
            CreateLotNoInfo(pItemNo, pVariantCode, lNewLotNo);
        end;

        if pWithCommit then Commit();

        exit(lNewLotNo);
        //CS_PRO_008-e
    end;

    internal procedure CheckLotNoInfoForWhseRcptLinePosting(var pWarehouseReceiptLine: Record "Warehouse Receipt Line")
    var
        lItem: Record Item;
        lItemTrackingCode: Record "Item Tracking Code";
        lLotNoInformation: Record "Lot No. Information";
        lAWPLogisticUnitDetail: Record "AltAWPLogistic Unit Detail";

        lMissingLotNoErr: Label 'Missing Lot No. for Whse. Doc. No.: %1, Line No.: %2!';
        lMissingLotNoInfoErr: Label 'Missing "Lot no. information card" for Whse. Doc. No.: %1, Line No.: %2, Lot No.: %3!';
    begin
        //CS_PRO_008-s
        if lItem.Get(pWarehouseReceiptLine."Item No.") then begin
            if (lItem."Item Tracking Code" <> '') and lItemTrackingCode.Get(lItem."Item Tracking Code") and
               lItemTrackingCode."Lot Specific Tracking"
            then begin
                Clear(lAWPLogisticUnitDetail);
                lAWPLogisticUnitDetail.SetRange("Whse. Document Type", lAWPLogisticUnitDetail."Whse. Document Type"::Receipt);
                lAWPLogisticUnitDetail.SetRange("Whse. Document No.", pWarehouseReceiptLine."No.");
                lAWPLogisticUnitDetail.SetRange("Whse. Document Line No.", pWarehouseReceiptLine."Line No.");
                if not lAWPLogisticUnitDetail.IsEmpty then begin
                    lAWPLogisticUnitDetail.FindSet();
                    repeat
                        if (lAWPLogisticUnitDetail."Lot No." = '') then Error(lMissingLotNoErr, pWarehouseReceiptLine."No.", pWarehouseReceiptLine."Line No.");

                        //CS_PRO_041_BIS-s
                        if IsSubcontractWhseReceipt(lAWPLogisticUnitDetail) then begin
                            CheckProdOrdLotForSubcontPurchOrd(lAWPLogisticUnitDetail);
                        end;
                        //CS_PRO_041_BIS-e

                        if not lLotNoInformation.Get(lAWPLogisticUnitDetail."Item No.", lAWPLogisticUnitDetail."Variant Code", lAWPLogisticUnitDetail."Lot No.") then begin
                            Error(lMissingLotNoInfoErr, pWarehouseReceiptLine."No.", pWarehouseReceiptLine."Line No.", lAWPLogisticUnitDetail."Lot No.");
                        end else begin
                            //CS_PRO_041_BIS-s
                            if IsSubcontractWhseReceipt(lAWPLogisticUnitDetail) then begin
                                lLotNoInformation.TestField("ecVendor No.");
                                lLotNoInformation.TestField("ecVendor Lot No.");
                            end;
                            //CS_PRO_041_BIS-e
                            lLotNoInformation.TestField("ecLot No. Information Status", lLotNoInformation."ecLot No. Information Status"::Released);
                        end;
                    until (lAWPLogisticUnitDetail.Next() = 0);
                end;
            end;
        end;
        //CS_PRO_008-e
    end;

    internal procedure IsSubcontractWhseReceipt(var pAWPLogisticUnitDetail: Record "AltAWPLogistic Unit Detail"): Boolean
    var
        lWarehouseReceiptLine: Record "Warehouse Receipt Line";
    begin
        //CS_PRO_041_BIS-s
        if (pAWPLogisticUnitDetail."Whse. Document Type" = pAWPLogisticUnitDetail."Whse. Document Type"::Receipt) and
           (pAWPLogisticUnitDetail."Whse. Document No." <> '') and (pAWPLogisticUnitDetail."Whse. Document Line No." <> 0)
        then begin
            if lWarehouseReceiptLine.Get(pAWPLogisticUnitDetail."Whse. Document No.", pAWPLogisticUnitDetail."Whse. Document Line No.") then begin
                if (lWarehouseReceiptLine."AltAWPProd. Order No." <> '') and (lWarehouseReceiptLine."AltAWPProd. Order Line No." <> 0) then exit(true);
            end;
        end;

        exit(false);
        //CS_PRO_041_BIS-e
    end;

    internal procedure CheckProdOrdLotForSubcontPurchOrd(var pAWPLogisticUnitDetail: Record "AltAWPLogistic Unit Detail")
    var
        lProdOrderLine: Record "Prod. Order Line";
        lWarehouseReceiptLine: Record "Warehouse Receipt Line";

        lErrorLot: Label 'For subcontracting purchase orders, the "Lot No." must correspond to the one specified in the original production order!';
        lErrorExpDate: Label 'For subcontracting purchase orders, the "Expiration Date" must correspond to the one specified in the original production order!';
    begin
        //CS_PRO_041_BIS-s
        if lWarehouseReceiptLine.Get(pAWPLogisticUnitDetail."Whse. Document No.", pAWPLogisticUnitDetail."Whse. Document Line No.") then begin
            if (lWarehouseReceiptLine."AltAWPProd. Order No." <> '') and (lWarehouseReceiptLine."AltAWPProd. Order Line No." <> 0) then begin
                if lProdOrderLine.Get(lProdOrderLine.Status::Released, lWarehouseReceiptLine."AltAWPProd. Order No.",
                                      lWarehouseReceiptLine."AltAWPProd. Order Line No.")
                then begin
                    if (pAWPLogisticUnitDetail."Lot No." <> lProdOrderLine."ecOutput Lot No.") then Error(lErrorLot);
                    if (pAWPLogisticUnitDetail."Expiration Date" <> lProdOrderLine."ecOutput Lot Exp. Date") then Error(lErrorExpDate);
                end;
            end;
        end;
        //CS_PRO_041_BIS-e
    end;

    internal procedure CreateAndUpdLotNoForLogisticUnitsDetail(var pAWPLogisticUnitDetail: Record "AltAWPLogistic Unit Detail"; pConfirmOverwrite: Boolean): Boolean
    var
        lItem: Record Item;
        lItemTrackingCode: Record "Item Tracking Code";
        lPurchaseHeader: Record "Purchase Header";
        lLotNoInformation: Record "Lot No. Information";
        lTrackingFunctions: Codeunit "ecTracking Functions";
        lConfirmManagement: Codeunit "Confirm Management";
        lConf001: Label 'Do you want to replace the existing Lot No.?';
    begin
        //CS_PRO_008-s
        if not lItem.Get(pAWPLogisticUnitDetail."Item No.") or (lItem."Item Tracking Code" = '') or not lItemTrackingCode.Get(lItem."Item Tracking Code") or
           not (lItemTrackingCode."Lot Specific Tracking")
        then begin
            exit(false);
        end;

        if (pAWPLogisticUnitDetail."Lot No." <> '') and pConfirmOverwrite then begin
            if not lConfirmManagement.GetResponseOrDefault(lConf001, false) then begin
                exit;
            end;
        end;

        pAWPLogisticUnitDetail.Validate("Lot No.", lTrackingFunctions.GetNewItemLotNo(pAWPLogisticUnitDetail."Item No.", pAWPLogisticUnitDetail."Variant Code", true, true));
        if (pAWPLogisticUnitDetail."Lot No." <> '') then begin
            lLotNoInformation.Get(pAWPLogisticUnitDetail."Item No.", pAWPLogisticUnitDetail."Variant Code", pAWPLogisticUnitDetail."Lot No.");
            if (pAWPLogisticUnitDetail."Expiration Date" <> 0D) then begin
                lLotNoInformation."ecExpiration Date" := pAWPLogisticUnitDetail."Expiration Date";
            end else begin
                if (lLotNoInformation."ecExpiration Date" <> 0D) then begin
                    pAWPLogisticUnitDetail.Validate("Expiration Date", lLotNoInformation."ecExpiration Date");
                end;
            end;
            if (pAWPLogisticUnitDetail."Whse. Document Type" = pAWPLogisticUnitDetail."Whse. Document Type"::Receipt) and
               (pAWPLogisticUnitDetail."Whse. Document No." <> '') and (pAWPLogisticUnitDetail."Source Type" = Database::"Purchase Line")
            then begin
                lLotNoInformation."ecLot Creation Process" := lLotNoInformation."ecLot Creation Process"::"Purchase Receipt";
                if lPurchaseHeader.Get(lPurchaseHeader."Document Type"::Order, pAWPLogisticUnitDetail."Source ID") then begin
                    lLotNoInformation."ecVendor No." := lPurchaseHeader."Buy-from Vendor No.";
                end;
            end;
            lLotNoInformation.Modify(true);
            exit(true);
        end;

        exit(false);
        //CS_PRO_008-e
    end;

    internal procedure CreateAndUpdLotNoForProdOrderLine(var pProdOrderLine: Record "Prod. Order Line"; pForceUpdate: Boolean): Boolean
    var
        lItem: Record Item;
        lItemTrackingCode: Record "Item Tracking Code";
        lLotNoInformation: Record "Lot No. Information";
        lTrackingFunctions: Codeunit "ecTracking Functions";
    begin
        //CS_PRO_008-s
        if not lItem.Get(pProdOrderLine."Item No.") or (lItem."Item Tracking Code" = '') or not lItemTrackingCode.Get(lItem."Item Tracking Code") or
           not (lItemTrackingCode."Lot Specific Tracking")
        then begin
            exit(false);
        end;
        if (pProdOrderLine."ecOutput Lot No." <> '') and not pForceUpdate then exit(false);

        pProdOrderLine.Validate("ecOutput Lot No.", lTrackingFunctions.GetNewItemLotNo(pProdOrderLine."Item No.", pProdOrderLine."Variant Code", true, true));
        pProdOrderLine.Modify(true);

        if (pProdOrderLine."ecOutput Lot No." <> '') then begin
            lLotNoInformation.Get(pProdOrderLine."Item No.", pProdOrderLine."Variant Code", pProdOrderLine."ecOutput Lot No.");
            if (pProdOrderLine."ecOutput Lot Exp. Date" <> 0D) then begin
                lLotNoInformation."ecExpiration Date" := pProdOrderLine."ecOutput Lot Exp. Date";
            end else begin
                if (lLotNoInformation."ecExpiration Date" <> 0D) then begin
                    pProdOrderLine.Validate("ecOutput Lot Exp. Date", lLotNoInformation."ecExpiration Date");
                end;
            end;
            lLotNoInformation."ecLot Creation Process" := lLotNoInformation."ecLot Creation Process"::"Production Output";
            lLotNoInformation.Modify(true);
        end;

        if lItem."ecMandatory Origin Lot No." or lItem."ecLot Prod. Info Inherited" then begin
            //Eredito info lotto da componenti prelevati, se non riesco prendo le info dalla scheda lotto rilasciata del componente figlio se esiste            
            if not InheritLotInfoFromPickedRawMaterial(lLotNoInformation, pProdOrderLine) then begin
                InheritParentLotNoInfoByReleasedChild(pProdOrderLine);
            end;
        end;

        exit(true);
        //CS_PRO_008-e
    end;

    internal procedure InheritParentLotNoInfoByReleasedChild(var pChildLotNoInformation: Record "Lot No. Information"): Boolean
    var
        lProdOrderLine: Record "Prod. Order Line";
        lParentProdOrderLine: Record "Prod. Order Line";
        lParentLotNoInformation: Record "Lot No. Information";
        lLotInfoInherited: Boolean;
    begin
        //CS_PRO_008-s
        if (pChildLotNoInformation."ecLot No. Information Status" <> pChildLotNoInformation."ecLot No. Information Status"::Released) then exit;
        if not CheckItemToInheritLotInfo(pChildLotNoInformation."Item No.") then exit;

        lLotInfoInherited := false;
        Clear(lProdOrderLine);
        lProdOrderLine.SetCurrentKey("ecOutput Lot No.", "ecOutput Lot Exp. Date");
        lProdOrderLine.SetRange("ecOutput Lot No.", pChildLotNoInformation."Lot No.");
        if not lProdOrderLine.IsEmpty then begin
            lProdOrderLine.FindSet();
            repeat
                if (lProdOrderLine."ecParent Line No." <> 0) then begin
                    lParentProdOrderLine.Get(lProdOrderLine.Status, lProdOrderLine."Prod. Order No.",
                                             lProdOrderLine."ecParent Line No.");
                    if (lParentProdOrderLine."ecOutput Lot No." <> '') and
                        lParentLotNoInformation.Get(lParentProdOrderLine."Item No.", lParentProdOrderLine."Variant Code",
                                                    lParentProdOrderLine."ecOutput Lot No.")
                    then begin
                        if (lParentLotNoInformation."ecLot No. Information Status" <> lParentLotNoInformation."ecLot No. Information Status"::Released) then begin
                            InheritOriginLotInfoToDestLotInfo(pChildLotNoInformation, lParentLotNoInformation);
                            lLotInfoInherited := true;
                        end;
                    end;
                end;
            until (lProdOrderLine.Next() = 0);
        end;

        exit(lLotInfoInherited);
        //CS_PRO_008-e
    end;

    internal procedure InheritParentLotNoInfoByReleasedChild(var pParentProdOrderLine: Record "Prod. Order Line"): Boolean
    var
        lChildProdOrderLine: Record "Prod. Order Line";
        lProdOrderComponent: Record "Prod. Order Component";
        lChildLotNoInformation: Record "Lot No. Information";
        lParentLotNoInformation: Record "Lot No. Information";
        lLotInfoInherited: Boolean;
    begin
        //CS_PRO_008-s
        if (pParentProdOrderLine."ecOutput Lot No." = '') then exit;
        if not lParentLotNoInformation.Get(pParentProdOrderLine."Item No.", pParentProdOrderLine."Variant Code", pParentProdOrderLine."ecOutput Lot No.") then exit;

        lLotInfoInherited := false;
        Clear(lProdOrderComponent);
        lProdOrderComponent.SetRange(Status, pParentProdOrderLine.Status);
        lProdOrderComponent.SetRange("Prod. Order No.", pParentProdOrderLine."Prod. Order No.");
        lProdOrderComponent.SetRange("Prod. Order Line No.", pParentProdOrderLine."Line No.");
        lProdOrderComponent.SetFilter("Supplied-by Line No.", '<>%1', 0);
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindSet();
            repeat
                if CheckItemToInheritLotInfo(lProdOrderComponent."Item No.") then begin

                    if lChildProdOrderLine.Get(lProdOrderComponent.Status, lProdOrderComponent."Prod. Order No.",
                                               lProdOrderComponent."Supplied-by Line No.") and
                       (lChildProdOrderLine."ecOutput Lot No." <> '')
                    then begin
                        if lChildLotNoInformation.Get(lChildProdOrderLine."Item No.", lChildProdOrderLine."Variant Code",
                                                      lChildProdOrderLine."ecOutput Lot No.") and
                           (lChildLotNoInformation."ecLot No. Information Status" = lChildLotNoInformation."ecLot No. Information Status"::Released)
                        then begin
                            InheritOriginLotInfoToDestLotInfo(lChildLotNoInformation, lParentLotNoInformation);
                            lLotInfoInherited := true;
                        end;
                    end;
                end;
            until (lProdOrderComponent.Next() = 0) or lLotInfoInherited;
        end;

        exit(lLotInfoInherited);
        //CS_PRO_008-e
    end;

    internal procedure InheritLotInfoFromPickedRawMaterial(var pDestLotNoInfo: Record "Lot No. Information"; var pProdOrderLine: Record "Prod. Order Line"): Boolean
    var
        lOriginLotNoInfo: Record "Lot No. Information";
        lProdOrderComponent: Record "Prod. Order Component";
        Temp_lAWPItemInventoryBuffer: Record "AltAWPItem Inventory Buffer" temporary;
        lAWPLogisticUnitsMgt: Codeunit "AltAWPLogistic Units Mgt.";
        lLotInfoInherited: Boolean;
    begin
        //CS_PRO_008-s
        lLotInfoInherited := false;
        Clear(lProdOrderComponent);
        lProdOrderComponent.SetRange(Status, pProdOrderLine.Status);
        lProdOrderComponent.SetRange("Prod. Order No.", pProdOrderLine."Prod. Order No.");
        lProdOrderComponent.SetRange("Prod. Order Line No.", pProdOrderLine."Line No.");
        lProdOrderComponent.SetRange("AltAWPUse Reserved Cons. Bin", true);
        if not lProdOrderComponent.IsEmpty then begin
            lProdOrderComponent.FindFirst();

            lAWPLogisticUnitsMgt.FindOpenWhseEntries(lProdOrderComponent."Item No.", lProdOrderComponent."Variant Code", lProdOrderComponent."Location Code",
                                                     lProdOrderComponent."Bin Code", '', '', '', '', false, Temp_lAWPItemInventoryBuffer);
            Clear(Temp_lAWPItemInventoryBuffer);
            Temp_lAWPItemInventoryBuffer.SetFilter("Lot No.", '<>%1', '');
            Temp_lAWPItemInventoryBuffer.SetFilter("ecItem Type", '%1|%2|%3', Temp_lAWPItemInventoryBuffer."ecItem Type"::"Raw Material",
                                                                         Temp_lAWPItemInventoryBuffer."ecItem Type"::"Semi-finished Product",
                                                                         Temp_lAWPItemInventoryBuffer."ecItem Type"::"Finished Product");
            if not Temp_lAWPItemInventoryBuffer.IsEmpty then begin
                Temp_lAWPItemInventoryBuffer.FindFirst();
                if lOriginLotNoInfo.Get(Temp_lAWPItemInventoryBuffer."Item No.", Temp_lAWPItemInventoryBuffer."Variant Code",
                                        Temp_lAWPItemInventoryBuffer."Lot No.")
                then begin
                    InheritOriginLotInfoToDestLotInfo(lOriginLotNoInfo, pDestLotNoInfo);
                    lLotInfoInherited := true;
                end;
            end;
        end;

        exit(lLotInfoInherited);
        //CS_PRO_008-e
    end;

    internal procedure UpdateLotNoInfoFromWhseActivityLine(pItemNo: Code[20]; pVariantCode: Code[10]; pOriginLotNo: Code[50]; pLocationCode: Code[10]; pBinCode: Code[20]): Boolean
    var
        lDestItem: Record Item;
        lSourceItem: Record Item;
        lProdOrderLine: Record "Prod. Order Line";
        lOriginLotNoInfo: Record "Lot No. Information";
        lDestLotNoInfo: Record "Lot No. Information";
        lawpProductionFunctions: Codeunit "AltAWPProduction Functions";
        lLotInfoInherited: Boolean;
    begin
        //CS_PRO_008-s
        lLotInfoInherited := false;
        if lawpProductionFunctions.GetProdOrderLineByConsumptionReservedBin(pLocationCode, pBinCode, lProdOrderLine) then begin
            if (lProdOrderLine.Status = lProdOrderLine.Status::Released) then begin
                if (lProdOrderLine."ecOutput Lot No." <> '') then begin
                    lSourceItem.Get(pItemNo);
                    lDestItem.Get(lProdOrderLine."Item No.");
                    if lOriginLotNoInfo.Get(pItemNo, pVariantCode, pOriginLotNo) and
                       lDestLotNoInfo.Get(lDestItem."No.", lProdOrderLine."Variant Code", lProdOrderLine."ecOutput Lot No.")
                    then begin
                        if CheckItemToInheritLotInfo(lSourceItem."No.") then begin
                            InheritOriginLotInfoToDestLotInfo(lOriginLotNoInfo, lDestLotNoInfo);
                            lLotInfoInherited := true;
                        end;
                    end;
                end;
            end;
        end;

        exit(lLotInfoInherited);
        //CS_PRO_008-e
    end;

    internal procedure InheritOriginLotInfoToDestLotInfo(var pOriginLotNoInfo: Record "Lot No. Information"; var pDestLotNoInfo: Record "Lot No. Information")
    var
        lDestItem: Record Item;
    begin
        //CS_PRO_008-s
        if (pDestLotNoInfo."Item No." = '') or (pDestLotNoInfo."Lot No." = '') or
           (pDestLotNoInfo."ecLot No. Information Status" = pDestLotNoInfo."ecLot No. Information Status"::Released) then begin
            exit;
        end;
        if (pOriginLotNoInfo."Item No." = '') or (pOriginLotNoInfo."Lot No." = '') or
           (pOriginLotNoInfo."ecLot No. Information Status" <> pOriginLotNoInfo."ecLot No. Information Status"::Released) then begin
            exit;
        end;

        lDestItem.Get(pDestLotNoInfo."Item No.");
        if lDestItem."ecMandatory Origin Lot No." or (lDestItem."Country/Region of Origin Code" <> '') or
           lDestItem."ecLot Prod. Info Inherited"
        then begin
            //Errore che non dovrebbe mai verificarsi ma per sicurezza lo controllo
            if (lDestItem."Country/Region of Origin Code" <> '') then begin
                pOriginLotNoInfo.TestField("ecOrigin Country Code", lDestItem."Country/Region of Origin Code");
            end;
            if lDestItem."ecMandatory Origin Lot No." or lDestItem."ecLot Prod. Info Inherited" then begin
                pDestLotNoInfo.Validate("ecOrigin Country Code", pOriginLotNoInfo."ecOrigin Country Code");
            end;
            if lDestItem."ecLot Prod. Info Inherited" then begin
                pDestLotNoInfo.Validate(ecVariety, pOriginLotNoInfo.ecVariety);
                pDestLotNoInfo.Validate(ecGauge, pOriginLotNoInfo.ecGauge);
            end;
            pDestLotNoInfo.Modify(true);
        end;
        //CS_PRO_008-e
    end;

    local procedure CheckItemToInheritLotInfo(pItemNo: Code[20]): Boolean
    var
        lItem: Record Item;
    begin
        //CS_PRO_008-s
        if not lItem.Get(pItemNo) then exit(false);
        if not (lItem."ecItem Type" in [lItem."ecItem Type"::"Raw Material", lItem."ecItem Type"::"Semi-finished Product",
                                        lItem."ecItem Type"::"Finished Product"])
        then begin
            exit(false);
        end;

        exit(true);
        //CS_PRO_008-e
    end;

    internal procedure ShowAndUpdateProdOrdLineLotNoInfoCard(var pProdOrderLine: Record "Prod. Order Line")
    var
        lLotNoInformation: Record "Lot No. Information";

        lLotCreationConf: Label 'Lot no. information card not found for:\Item: %1\Variant: %2\Lot No.: %3\\Do you want to create it now?';
    begin
        //CS_PRO_008-s
        if not lLotNoInformation.Get(pProdOrderLine."Item No.", pProdOrderLine."Variant Code", pProdOrderLine."ecOutput Lot No.") then begin
            if not Confirm(StrSubstNo(lLotCreationConf, pProdOrderLine."Item No.", pProdOrderLine."Variant Code", pProdOrderLine."ecOutput Lot No."), false)
             then begin
                exit;
            end;
            CreateAndUpdLotNoForProdOrderLine(pProdOrderLine, false);
        end;
        ShowLotNoInfoCard(pProdOrderLine."Item No.", pProdOrderLine."Variant Code", pProdOrderLine."ecOutput Lot No.");

        //Refresh Lot No Information
        lLotNoInformation.Get(pProdOrderLine."Item No.", pProdOrderLine."Variant Code", pProdOrderLine."ecOutput Lot No.");
        //Refresh Data on prod order line
        if (lLotNoInformation."ecExpiration Date" <> pProdOrderLine."ecOutput Lot Exp. Date") then begin
            pProdOrderLine.Validate("ecOutput Lot Exp. Date", lLotNoInformation."ecExpiration Date");
        end;
        //CS_PRO_008-e
    end;

    internal procedure ShowLotNoInfoCard(pItemNo: Code[20]; pVariantCode: Code[10]; pLotNo: Code[50])
    var
        lLotNoInfoNew: Record "Lot No. Information";
        lLotNoInfoPage: Page "Lot No. Information Card";
    begin
        //CS_PRO_008-s
        Commit();

        Clear(lLotNoInfoPage);

        lLotNoInfoNew.SetRange("Item No.", pItemNo);
        lLotNoInfoNew.SetRange("Variant Code", pVariantCode);
        lLotNoInfoNew.SetRange("Lot No.", pLotNo);

        lLotNoInfoPage.SetTableView(lLotNoInfoNew);
        lLotNoInfoPage.RunModal();
        //CS_PRO_008-e
    end;

    internal procedure CreateAndOpenGenericLotNoInfoCard(var pTrackingSpecification: Record "Tracking Specification")
    var
        lawpItemTrackingFunctions: Codeunit "AltAWPItem Tracking Functions";
    begin
        //CS_PRO_008-s
        pTrackingSpecification.TestField("Item No.");
        pTrackingSpecification.TestField("Lot No.");
        lawpItemTrackingFunctions.ShowLotNoInfoCard(pTrackingSpecification);
        //CS_PRO_008-e  
    end;

    internal procedure CreateAndUpdLotNoForItemJnlLine(var pItemJournalLine: Record "Item Journal Line"; pForceUpdate: Boolean): Boolean
    var
        lItem: Record Item;
        lItemTrackingCode: Record "Item Tracking Code";
        lTrackingFunctions: Codeunit "ecTracking Functions";
    begin
        //CS_PRO_008-s
        if not lItem.Get(pItemJournalLine."Item No.") or (lItem."Item Tracking Code" = '') or not lItemTrackingCode.Get(lItem."Item Tracking Code") or
           not (lItemTrackingCode."Lot Specific Tracking")
        then begin
            exit(false);
        end;
        if (pItemJournalLine."AltAWPLot No." <> '') and not pForceUpdate then exit(false);

        pItemJournalLine.Validate("AltAWPLot No.", lTrackingFunctions.GetNewItemLotNo(pItemJournalLine."Item No.", pItemJournalLine."Variant Code", true, true));
        pItemJournalLine.Modify(true);

        UpdateItemJnlLineByLotInfo(pItemJournalLine);

        exit(true);
        //CS_PRO_008-e
    end;

    internal procedure ShowAndUpdateItemJnlLineLotNoInfoCard(var pItemJournalLine: Record "Item Journal Line")
    var
        lLotNoInformation: Record "Lot No. Information";

        lLotCreationConf: Label 'Lot no. information card not found for:\Item: %1\Variant: %2\Lot No.: %3\\Do you want to create it now?';
    begin
        //CS_PRO_008-s
        if not lLotNoInformation.Get(pItemJournalLine."Item No.", pItemJournalLine."Variant Code", pItemJournalLine."AltAWPLot No.") then begin
            if not Confirm(StrSubstNo(lLotCreationConf, pItemJournalLine."Item No.", pItemJournalLine."Variant Code", pItemJournalLine."AltAWPLot No."), false)
             then begin
                exit;
            end;
            if not CreateAndUpdLotNoForItemJnlLine(pItemJournalLine, false) then begin
                CreateLotNoInfo(pItemJournalLine."Item No.", pItemJournalLine."Variant Code", pItemJournalLine."AltAWPLot No.");
                UpdateItemJnlLineByLotInfo(pItemJournalLine);
            end;
        end;
        ShowLotNoInfoCard(pItemJournalLine."Item No.", pItemJournalLine."Variant Code", pItemJournalLine."AltAWPLot No.");

        //Refresh Lot No Information
        lLotNoInformation.Get(pItemJournalLine."Item No.", pItemJournalLine."Variant Code", pItemJournalLine."AltAWPLot No.");
        //Refresh Data on Item Journal Line
        if (lLotNoInformation."ecExpiration Date" <> pItemJournalLine."AltAWPExpiration Date") then begin
            pItemJournalLine.Validate("AltAWPExpiration Date", lLotNoInformation."ecExpiration Date");
        end;
        //CS_PRO_008-e
    end;

    local procedure CreateLotNoInfo(pItemNo: Code[20]; pVariantCode: Code[10]; pLotNo: Code[50])
    var
        lLotNoInformation: Record "Lot No. Information";
    begin
        if (pItemNo = '') or (pLotNo = '') then exit;

        lLotNoInformation.Init();
        lLotNoInformation.Validate("Item No.", pItemNo);
        lLotNoInformation.Validate("Variant Code", pVariantCode);
        lLotNoInformation.Validate("Lot No.", pLotNo);
        lLotNoInformation.Insert(true);
    end;

    local procedure UpdateItemJnlLineByLotInfo(var pItemJournalLine: Record "Item Journal Line")
    var
        lLotNoInformation: Record "Lot No. Information";
    begin
        if (pItemJournalLine."AltAWPLot No." <> '') then begin
            lLotNoInformation.Get(pItemJournalLine."Item No.", pItemJournalLine."Variant Code", pItemJournalLine."AltAWPLot No.");
            if (pItemJournalLine."AltAWPExpiration Date" <> 0D) then begin
                lLotNoInformation."ecExpiration Date" := pItemJournalLine."AltAWPExpiration Date";
            end else begin
                if (lLotNoInformation."ecExpiration Date" <> 0D) then begin
                    pItemJournalLine.Validate("AltAWPExpiration Date", lLotNoInformation."ecExpiration Date");
                end;
            end;
            lLotNoInformation."ecLot Creation Process" := lLotNoInformation."ecLot Creation Process"::Manual;
            lLotNoInformation.Modify(true);
        end;
    end;

    internal procedure CheckComponentLotNoInfo(pItemNo: Code[20]; pVariantCode: Code[20]; pLotNo: Code[50]; var pErrorMsg: Text): Boolean
    var
        lItem: Record Item;
        lLotNoInformation: Record "Lot No. Information";
        lItemTrackingCode: Record "Item Tracking Code";

        lItemNotFound: Label 'Item not found';
        lMissingLotInfo: Label 'Missing Lot Information Card';
        lLotInfoNotReleased: Label 'Lot Information Card not released';
    begin
        //CS_PRO_008-s
        pErrorMsg := '';
        if not lItem.Get(pItemNo) then begin
            pErrorMsg := lItemNotFound;
            exit(false);
        end else begin
            if (lItem."Item Tracking Code" <> '') then begin
                lItemTrackingCode.Get(lItem."Item Tracking Code");
                if not lItemTrackingCode."Lot Specific Tracking" then exit(true);
            end else begin
                exit(true);
            end;
        end;

        if not lLotNoInformation.Get(pItemNo, pVariantCode, pLotNo) then begin
            pErrorMsg := lMissingLotInfo;
            exit(false);
        end else begin
            if (lLotNoInformation."ecLot No. Information Status" <> lLotNoInformation."ecLot No. Information Status"::Released) then begin
                pErrorMsg := lLotInfoNotReleased;
                exit(false);
            end;
        end;

        exit(true);
        //CS_PRO_008-e
    end;
    #endregion CS_PRO_008
}
