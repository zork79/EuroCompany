namespace EuroCompany.BaseApp.Sales;

using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Sales.AdvancedTrade;
using EuroCompany.BaseApp.Setup;
using Microsoft.Finance.Currency;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Foundation.Calendar;
using Microsoft.Foundation.Company;
using Microsoft.Foundation.Shipping;
using Microsoft.Inventory.Item;
using Microsoft.Manufacturing.ProductionBOM;
using Microsoft.Sales.Comment;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;
using Microsoft.Sales.Receivables;
using Microsoft.Warehouse.Document;

codeunit 50007 "ecSales Functions"
{
    #region Release Sales Documents
    internal procedure SalesDocumentCheck(var pSalesHeader: Record "Sales Header")
    begin
        //CS_VEN_032-VI-s
        SalesHeader_CheckProductSegment(pSalesHeader, false);
        //CS_VEN_032-VI-e

        //CS_PRO_009-s
        CheckSalesLineOnRelease(pSalesHeader);
        //CS_PRO_009-e
    end;

    local procedure CheckSalesLineOnRelease(var pSalesHeader: Record "Sales Header")
    var
        lSalesLine: Record "Sales Line";

        lKitExhibitorRecalcReqErr: Label 'For "%1" = "%2 - %3" is required recalculation of Kit/Exhibitor price BOM!';
    begin
        //CS_PRO_009-s
        if (pSalesHeader."Document Type" = pSalesHeader."Document Type"::Order) then begin
            Clear(lSalesLine);
            lSalesLine.SetRange("Document Type", pSalesHeader."Document Type");
            lSalesLine.SetRange("Document No.", pSalesHeader."No.");
            lSalesLine.SetRange("ecKit/Exhibitor Recalc. Req.", true);
            if lSalesLine.FindFirst() then Error(lKitExhibitorRecalcReqErr, Format(lSalesLine."Document Type"), lSalesLine."Document No.", lSalesLine."Line No.");
        end;
        //CS_PRO_009-e
    end;

    #endregion Release Sales Documents

    #region Sales Manager Mgt.
    internal procedure SalesHeader_SetDefaultSalesManager(var pSalesHeader: Record "Sales Header"; pReplaceExisting: Boolean)
    var
        lCustomer: Record Customer;
        lecCustomerProductSegments: Record "ecCustomer Product Segments";
        lNewSalesManagerCode: Code[20];
    begin
        //CS_VEN_031-VI-s
        if not (pSalesHeader."Document Type" in [pSalesHeader."Document Type"::Invoice,
                                                 pSalesHeader."Document Type"::"Credit Memo"])
        then begin
            if pReplaceExisting or (pSalesHeader."ecSales Manager Code" = '') then begin
                lNewSalesManagerCode := '';

                if (pSalesHeader."Sell-to Customer No." <> '') then begin
                    if lCustomer.Get(pSalesHeader."Bill-to Customer No.") then begin
                        lNewSalesManagerCode := lCustomer."ecSales Manager Code";
                    end;

                    if lCustomer.Get(pSalesHeader."Sell-to Customer No.") then begin
                        if (lCustomer."ecSales Manager Code" <> '') then begin
                            lNewSalesManagerCode := lCustomer."ecSales Manager Code";
                        end;
                    end;

                    //CS_VEN_032-VI-s
                    if (pSalesHeader."ecProduct Segment No." <> '') then begin
                        if lecCustomerProductSegments.GetCustomerProductSegment(pSalesHeader."Sell-to Customer No.",
                                                                                pSalesHeader."ecProduct Segment No.")
                        then begin
                            if (lecCustomerProductSegments."Sales Manager Code" <> '') then begin
                                lNewSalesManagerCode := lecCustomerProductSegments."Sales Manager Code";
                            end;
                        end;
                    end;
                    //CS_VEN_032-VI-e
                end;

                if (lNewSalesManagerCode <> pSalesHeader."ecSales Manager Code") then begin
                    pSalesHeader.Validate("ecSales Manager Code", lNewSalesManagerCode);
                end
            end;
        end;
        //CS_VEN_031-VI-e
    end;
    #endregion Sales Manager Mgt.

    #region  Product Segments on Sales Mgt.
    internal procedure SalesHeader_LookupProductSegment(pSalesHeader: Record "Sales Header"; var pSelectedValue: Text): Boolean
    var
        lapsTRDProductSegment: Record "APsTRD Product Segment";
    begin
        //CS_VEN_032-VI-s
        if ExistsCustomerProductSegments(pSalesHeader."Sell-to Customer No.") then begin
            exit(LookupCustomerProductSegments(pSalesHeader."Sell-to Customer No.", pSelectedValue));
        end else begin
            if lapsTRDProductSegment.Get(pSelectedValue) then;
            if Page.RunModal(Page::"APsTRD Product Segment Lookup", lapsTRDProductSegment) = Action::LookupOK then begin
                pSelectedValue := lapsTRDProductSegment."No.";
                exit(true);
            end;
        end;

        exit(false);
        //CS_VEN_032-VI-e
    end;

    internal procedure WhseShipHeader_LookupProductSegment(pWarehouseShipmentHeader: Record "Warehouse Shipment Header"; var pSelectedValue: Text): Boolean
    var
        lapsTRDProductSegment: Record "APsTRD Product Segment";
    begin
        //CS_VEN_032-VI-s
        if (pWarehouseShipmentHeader."AltAWPSource Document Type" = pWarehouseShipmentHeader."AltAWPSource Document Type"::"Sales Order") then begin
            if (pWarehouseShipmentHeader."AltAWPSubject Type" = pWarehouseShipmentHeader."AltAWPSubject Type"::Customer) and
               (pWarehouseShipmentHeader."AltAWPSubject No." <> '')
            then begin
                if ExistsCustomerProductSegments(pWarehouseShipmentHeader."AltAWPSubject No.") then begin
                    exit(LookupCustomerProductSegments(pWarehouseShipmentHeader."AltAWPSubject No.", pSelectedValue));
                end else begin
                    if lapsTRDProductSegment.Get(pSelectedValue) then;
                    if Page.RunModal(Page::"APsTRD Product Segment Lookup", lapsTRDProductSegment) = Action::LookupOK then begin
                        pSelectedValue := lapsTRDProductSegment."No.";
                        exit(true);
                    end;
                end;
            end;
        end;

        exit(false);
        //CS_VEN_032-VI-e
    end;

    internal procedure ExistsCustomerProductSegments(pCustomerNo: Code[20]): Boolean
    var
        lCustomerProductSegments: Record "ecCustomer Product Segments";
    begin
        //CS_VEN_032-VI-s
        if FindCustomerProductSegments(pCustomerNo, lCustomerProductSegments) then begin
            exit(true);
        end;

        exit(false);
        //CS_VEN_032-VI-e
    end;

    internal procedure FindCustomerProductSegments(pCustomerNo: Code[20]; var pCustomerProductSegments: Record "ecCustomer Product Segments"): Boolean
    begin
        //CS_VEN_032-VI-s
        if (pCustomerNo <> '') then begin
            pCustomerProductSegments.Reset();
            pCustomerProductSegments.FilterGroup(2);
            pCustomerProductSegments.SetCurrentKey("Customer No.", "Starting Date");
            pCustomerProductSegments.SetRange("Customer No.", pCustomerNo);
            pCustomerProductSegments.SetRange("Starting Date", 0D, Today);
            pCustomerProductSegments.SetFilter("Ending Date", '%1|%2..', 0D, Today);
            pCustomerProductSegments.FilterGroup(0);

            exit(not pCustomerProductSegments.IsEmpty);
        end;

        exit(false);
        //CS_VEN_032-VI-e
    end;

    internal procedure LookupCustomerProductSegments(pCustomerNo: Code[20]; var pSelectedValue: Text): Boolean
    var
        lCustomerProductSegments: Record "ecCustomer Product Segments";
    begin
        //CS_VEN_032-VI-s
        if FindCustomerProductSegments(pCustomerNo, lCustomerProductSegments) then begin
            if (pSelectedValue <> '') then begin
                lCustomerProductSegments.SetRange("Product Segment No.", pSelectedValue);
                if lCustomerProductSegments.FindFirst() then;
                lCustomerProductSegments.SetRange("Product Segment No.");
            end;

            if Page.RunModal(Page::"ecCustomer Product Segments", lCustomerProductSegments) = Action::LookupOK then begin
                pSelectedValue := lCustomerProductSegments."Product Segment No.";
                exit(true);
            end;
        end;

        exit(false);
        //CS_VEN_032-VI-e
    end;

    internal procedure SalesHeader_SetDefaultProductSegment(var pSalesHeader: Record "Sales Header")
    var
        lecCustomerProductSegments: Record "ecCustomer Product Segments";
    begin
        //CS_VEN_032-VI-s
        if not (pSalesHeader."Document Type" in [pSalesHeader."Document Type"::Invoice,
                                                 pSalesHeader."Document Type"::"Credit Memo"])
        then begin
            if (pSalesHeader."Sell-to Customer No." <> '') then begin
                if FindCustomerProductSegments(pSalesHeader."Sell-to Customer No.", lecCustomerProductSegments) then begin
                    if (lecCustomerProductSegments.Count = 1) then begin
                        pSalesHeader.Validate("ecProduct Segment No.", lecCustomerProductSegments."Product Segment No.");
                    end;
                end;
            end;
        end;
        //CS_VEN_032-VI-e
    end;

    internal procedure SelectMultipleItemsForSales(var pSalesLine: Record "Sales Line")
    var
        lSalesHeader: Record "Sales Header";
        Temp_lItemSelectionBuffer: Record "ecItem Selection Buffer" temporary;
        lapsTRDProductSegment: Record "APsTRD Product Segment";
        lapsTRDProductSegmentDetail: Record "APsTRD Product Segment Detail";
        lecSelectItemsforSales: Page "ecSelect Items for Sales";
    begin
        //CS_VEN_032-VI-s
        lSalesHeader.Get(pSalesLine."Document Type", pSalesLine."Document No.");
        if (lSalesHeader."ecProduct Segment No." = '') then begin
            pSalesLine.SelectMultipleItems();
        end else begin
            Clear(lecSelectItemsforSales);
            lecSelectItemsforSales.SetSourceSalesHeader(lSalesHeader);

            lapsTRDProductSegment.Get(lSalesHeader."ecProduct Segment No.");
            lapsTRDProductSegment.TestField(Status, lapsTRDProductSegment.Status::Released);

            lapsTRDProductSegmentDetail.Reset();
            lapsTRDProductSegmentDetail.SetCurrentKey("Segment No.", "Element Type", "Element No.");
            lapsTRDProductSegmentDetail.SetRange("Segment No.", lSalesHeader."ecProduct Segment No.");
            lapsTRDProductSegmentDetail.SetRange("Element Type", lapsTRDProductSegmentDetail."Element Type"::Item);
            if lapsTRDProductSegmentDetail.FindSet() then begin
                repeat
                    lecSelectItemsforSales.AddItem(lapsTRDProductSegmentDetail."Element No.");
                until (lapsTRDProductSegmentDetail.Next() = 0);
            end;
            lecSelectItemsforSales.ClearSelection();

            Commit();
            lecSelectItemsforSales.RunModal();
            if lecSelectItemsforSales.GetSelectedItems(Temp_lItemSelectionBuffer) then begin
                pSalesLine.InitNewLine(pSalesLine);

                Temp_lItemSelectionBuffer.FindSet();
                repeat
                    if (Temp_lItemSelectionBuffer."Qty. to Handle" > 0) then begin
                        pSalesLine.Init();
                        pSalesLine."Line No." += 10000;
                        pSalesLine.Validate(Type, pSalesLine.Type::Item);
                        pSalesLine.Validate("No.", Temp_lItemSelectionBuffer."No.");
                        pSalesLine.Insert(true);

                        pSalesLine.Validate(Quantity, Temp_lItemSelectionBuffer."Qty. to Handle");
                        pSalesLine.Modify(true);

                        pSalesLine.ProcessSalesLine(pSalesLine);
                    end;
                until (Temp_lItemSelectionBuffer.Next() = 0);
            end;
        end;
        //CS_VEN_032-VI-e
    end;

    internal procedure SalesHeader_CheckProductSegment(pSalesHeader: Record "Sales Header"; pWithError: Boolean)
    var
        lSalesLine: Record "Sales Line";
        lCustomerProductSegments: Record "ecCustomer Product Segments";
        lapsTRDProductSegment: Record "APsTRD Product Segment";
        lValidSalesLine: Boolean;

        lInvalidSegmentForCustError: Label 'The product segment %1 is not allowed for the customer %2 %3';
        lItemOutOfSegmentError: Label 'Unable to use the product segment %1 in %2 no. %3 because incompatible items were found (e.g. %4)';
        lItemOutOfSegmentMessage: Label 'Incompatible items were detected for product segment %1 on document %2 no. %3 (e.g. %4)';
    begin
        //CS_VEN_032-VI-s
        if not (pSalesHeader."Document Type" in [pSalesHeader."Document Type"::"Credit Memo"]) then begin
            if (pSalesHeader."ecProduct Segment No." <> '') then begin
                pSalesHeader.TestField("Sell-to Customer No.");

                lapsTRDProductSegment.Get(pSalesHeader."ecProduct Segment No.");
                lapsTRDProductSegment.TestField(Status, lapsTRDProductSegment.Status::Released);

                lCustomerProductSegments.Reset();
                lCustomerProductSegments.SetCurrentKey("Customer No.", "Starting Date");
                lCustomerProductSegments.SetRange("Customer No.", pSalesHeader."Sell-to Customer No.");
                lCustomerProductSegments.SetRange("Starting Date", 0D, Today);
                lCustomerProductSegments.SetFilter("Ending Date", '%1|%2..', 0D, Today);
                if not lCustomerProductSegments.IsEmpty then begin
                    if not lCustomerProductSegments.GetCustomerProductSegment(pSalesHeader."Sell-to Customer No.", pSalesHeader."ecProduct Segment No.") then begin
                        Error(lInvalidSegmentForCustError, pSalesHeader."ecProduct Segment No.", pSalesHeader."Sell-to Customer No.", pSalesHeader."Sell-to Customer Name");
                    end
                end;

                lValidSalesLine := true;
                lSalesLine.Reset();
                lSalesLine.SetRange("Document Type", pSalesHeader."Document Type");
                lSalesLine.SetRange("Document No.", pSalesHeader."No.");
                if lSalesLine.FindSet() then begin
                    repeat
                        lValidSalesLine := TestSalesLineItem(lSalesLine, pSalesHeader, false);
                        if not lValidSalesLine then begin
                            if pWithError then begin
                                Error(lItemOutOfSegmentError, pSalesHeader."ecProduct Segment No.", pSalesHeader.GetDocTypeTxt(), pSalesHeader."No.", lSalesLine."No.");
                            end else begin
                                Message(lItemOutOfSegmentMessage, pSalesHeader."ecProduct Segment No.", pSalesHeader.GetDocTypeTxt(), pSalesHeader."No.", lSalesLine."No.");
                            end;
                        end;
                    until (lSalesLine.Next() = 0) or not lValidSalesLine;
                end;
            end;
        end;
        //CS_VEN_032-VI-e
    end;

    internal procedure TestSalesLineItem(pSalesLine: Record "Sales Line")
    var
        lSalesHeader: Record "Sales Header";
    begin
        //CS_VEN_032-VI-s        
        if not (pSalesLine."Document Type" in [pSalesLine."Document Type"::"Credit Memo"]) then begin
            if (pSalesLine.Type = pSalesLine.Type::Item) and (pSalesLine."No." <> '') then begin
                if lSalesHeader.Get(pSalesLine."Document Type", pSalesLine."Document No.") then begin
                    if (lSalesHeader."Sell-to Customer No." <> '') and
                       (lSalesHeader."ecProduct Segment No." <> '')
                    then begin
                        TestSalesLineItem(pSalesLine, lSalesHeader, true);
                    end;
                end;
            end;
            //CS_VEN_032-VI-e
        end;
    end;

    internal procedure TestSalesLineItem(pSalesLine: Record "Sales Line"; pSalesHeader: Record "Sales Header"; pWithError: Boolean): Boolean
    var
        lapsTRDProductSegmentDetail: Record "APsTRD Product Segment Detail";
        lItemOutOfSegmentError: Label 'The Item %1 is not included in product segment %2';
    begin
        //CS_VEN_032-VI-s
        if (pSalesLine.Type = pSalesLine.Type::Item) and (pSalesLine."No." <> '') then begin
            if not lapsTRDProductSegmentDetail.Get(pSalesHeader."ecProduct Segment No.",
                                                   lapsTRDProductSegmentDetail."Element Type"::Item,
                                                   pSalesLine."No.")
            then begin
                if pWithError then begin
                    Error(lItemOutOfSegmentError, pSalesLine."No.", pSalesHeader."ecProduct Segment No.");
                end;

                exit(false);
            end;
        end;

        exit(true);
        //CS_VEN_032-VI-e
    end;

    internal procedure GetSalesHeaderProductSegmentNo(pSalesHeader: Record "Sales Header"; pDestination: Option " ",Shipment,Invoice): Code[20]
    var
        lCustomer: Record Customer;
    begin
        //CS_VEN_033-VI-s
        if (pDestination = pDestination::" ") then begin
            exit(pSalesHeader."ecProduct Segment No.");
        end else begin
            if lCustomer.Get(pSalesHeader."Sell-to Customer No.") then begin
                case pDestination of
                    pDestination::Shipment:
                        if lCustomer."ecGroup Ship By Prod. Segment" then begin
                            exit(pSalesHeader."ecProduct Segment No.");
                        end;

                    pDestination::Invoice:
                        if lCustomer."ecGroup Inv. By Prod. Segment" then begin
                            exit(pSalesHeader."ecProduct Segment No.");
                        end;
                end;
            end;
        end;

        exit('');
        //CS_VEN_033-VI-e 
    end;

    internal procedure GetShippingAgentByProductSegment(var pSalesHeader: Record "Sales Header")
    var
        lCustomer: Record Customer;
        lShiptoAddress: Record "Ship-to Address";
        lCustomerProductSegments: Record "ecCustomer Product Segments";
    begin
        //CS_VEN_039-s
        if (pSalesHeader."ecProduct Segment No." <> '') then begin
            if lCustomerProductSegments.GetCustomerProductSegment(pSalesHeader."Sell-to Customer No.", pSalesHeader."ecProduct Segment No.") then begin
                if (lCustomerProductSegments."Shipping Agent Code" <> '') then begin
                    pSalesHeader.Validate("Shipping Agent Code", lCustomerProductSegments."Shipping Agent Code");
                    if (lCustomerProductSegments."Shipping Agent Service Code" <> '') then begin
                        pSalesHeader.Validate("Shipping Agent Service Code", lCustomerProductSegments."Shipping Agent Service Code");
                    end;
                end;
            end;
        end else begin
            if (pSalesHeader."Ship-to Code" <> '') then begin
                lShiptoAddress.Get(pSalesHeader."Sell-to Customer No.", pSalesHeader."Ship-to Code");
                if (pSalesHeader."Shipping Agent Code" <> lShiptoAddress."Shipping Agent Code") then begin
                    pSalesHeader.Validate("Shipping Agent Code", lShiptoAddress."Shipping Agent Code");
                    pSalesHeader.Validate("Shipping Agent Service Code", lShiptoAddress."Shipping Agent Service Code");
                end;
            end else begin
                lCustomer.Get(pSalesHeader."Sell-to Customer No.");
                if (pSalesHeader."Shipping Agent Code" <> lCustomer."Shipping Agent Code") then begin
                    pSalesHeader.Validate("Shipping Agent Code", lCustomer."Shipping Agent Code");
                    pSalesHeader.Validate("Shipping Agent Service Code", lCustomer."Shipping Agent Service Code");
                end;
            end;
        end;
        //CS_VEN_039-e
    end;

    #endregion  Product Segments on Sales Mgt.

    #region 389
    procedure GetBalanceCreditInsuredAmountLCY(var Customer: Record Customer)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        BalanceCreditInsured: Decimal;
    begin
        BalanceCreditInsured := 0;

        CustLedgEntry.Reset();
        CustLedgEntry.SetLoadFields("Amount (LCY)");
        CustLedgEntry.SetRange("Customer No.", Customer."No.");
        CustLedgEntry.SetRange(Open, true);
        CustLedgEntry.SetRange("ecCredit Insured", true);
        if CustLedgEntry.FindSet() then begin
            repeat
                CustLedgEntry.CalcFields("Amount (LCY)");
                BalanceCreditInsured += CustLedgEntry."Amount (LCY)";
            until CustLedgEntry.Next() = 0;

            Customer.Validate("ecBalance Credit Insured", BalanceCreditInsured);
            Customer.Modify();
        end;
    end;

    procedure DrillDownBalanceCreditInsuredAmountLCY(var Customer: Record Customer)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        CustLedgEntries: Page "Customer Ledger Entries";
    begin
        CustLedgEntry.Reset();
        CustLedgEntry.SetRange("Customer No.", Customer."No.");
        CustLedgEntry.SetRange(Open, true);
        CustLedgEntry.SetRange("ecCredit Insured", true);
        CustLedgEntries.SetTableView(CustLedgEntry);
        CustLedgEntries.Run();
    end;
    #endregion 389

    #region 391
    procedure SetOMRQty(var SalesHeader: Record "Sales Header")
    var
        SalesLine, SalesLineForAssignment : Record "Sales Line";
        APsFOCPostingSetup: Record "APsFOC Posting Setup";
        ItemChargeAssignment: Record "Item Charge Assignment (Sales)";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                APsFOCPostingSetup.Reset();
                APsFOCPostingSetup.SetRange("Type", SalesLine.Type);
                APsFOCPostingSetup.SetRange("No.", SalesLine."No.");
                if not APsFOCPostingSetup.IsEmpty() then
                    if SalesLine.Quantity < 0 then begin
                        SalesLine.Validate(Quantity, Abs(SalesLine.Quantity));
                        SalesLine.Validate("Quantity (Base)", Abs(SalesLine."Quantity (Base)"));
                        SalesLine."Qty. to Invoice" := Abs(SalesLine."Qty. to Invoice");
                        SalesLine."Qty. to Ship" := Abs(SalesLine."Qty. to Ship");
                        SalesLine."Qty. to Invoice (Base)" := Abs(SalesLine."Qty. to Invoice (Base)");
                        SalesLine."Qty. to Ship (Base)" := Abs(SalesLine."Qty. to Ship (Base)");
                        SalesLine."AltAWPOriginal Quantity" := Abs(SalesLine."AltAWPOriginal Quantity");
                        SalesLine.Quantity := Abs((SalesLine.Quantity));
                        SalesLine."Outstanding Quantity" := Abs(SalesLine."Outstanding Quantity");
                        SalesLine."Outstanding Qty. (Base)" := Abs(SalesLine."Outstanding Qty. (Base)");
                        SalesLine.Validate("Unit Price", SalesLine."Unit Price" * -1);
                        SalesLine.Modify();

                        ItemChargeAssignment.Reset();
                        ItemChargeAssignment.SetRange("Document Type", SalesLine."Document Type");
                        ItemChargeAssignment.SetRange("Document No.", SalesLine."Document No.");
                        ItemChargeAssignment.SetRange("Document Line No.", SalesLine."Line No.");
                        ItemChargeAssignment.SetRange("Item Charge No.", SalesLine."No.");

                        SalesLineForAssignment.Reset();
                        SalesLineForAssignment.SetRange("Document Type", SalesHeader."Document Type");
                        SalesLineForAssignment.SetRange("Document No.", SalesHeader."No.");
                        SalesLineForAssignment.SetRange("Line No.", SalesLine."APsFOC Attach. to Line No.");
                        if SalesLineForAssignment.FindFirst() then
                            ItemChargeAssignment.SetRange("Item No.", SalesLineForAssignment."No.");

                        if ItemChargeAssignment.FindFirst() then begin
                            ItemChargeAssignment."Qty. to Handle" := Abs(SalesLine.Quantity);
                            ItemChargeAssignment."Qty. to Assign" := Abs(SalesLine.Quantity);
                            ItemChargeAssignment.Modify();
                        end;
                    end else begin
                        SalesLine.Validate(Quantity, Abs(SalesLine.Quantity));
                        SalesLine.Validate("Quantity (Base)", Abs(SalesLine."Quantity (Base)"));
                        SalesLine."Qty. to Invoice" := Abs(SalesLine."Qty. to Invoice");
                        SalesLine."Qty. to Ship" := Abs(SalesLine."Qty. to Ship");
                        SalesLine."Qty. to Invoice (Base)" := Abs(SalesLine."Qty. to Invoice (Base)");
                        SalesLine."Qty. to Ship (Base)" := Abs(SalesLine."Qty. to Ship (Base)");
                        SalesLine."AltAWPOriginal Quantity" := Abs(SalesLine."AltAWPOriginal Quantity");
                        SalesLine.Quantity := Abs((SalesLine.Quantity));
                        SalesLine."Outstanding Quantity" := Abs(SalesLine."Outstanding Quantity");
                        SalesLine."Outstanding Qty. (Base)" := Abs(SalesLine."Outstanding Qty. (Base)");
                        SalesLine.Validate("Unit Price", SalesLine."Unit Price" * -1);
                        SalesLine.Modify();
                    end;
            until SalesLine.Next() = 0;
    end;
    #endregion 391

    #region Commenti per Clienti-Assortimento

    internal procedure AddProductSegmentCommentsOnSalesDoc(var pSalesHeader: Record "Sales Header"; var pxSalesHeader: Record "Sales Header")
    var
        lSalesCommentLine: Record "Sales Comment Line";
        lCustomerProductSegments: Record "ecCustomer Product Segments";
        lAWPRecordCommentLine: Record "AltAWPRecord Comment Line";
        lAWPCommentsManagement: Codeunit "AltAWPComments Management";
        lLineNo: Integer;
    begin
        //CS_VEN_034-s
        Clear(lSalesCommentLine);
        lSalesCommentLine.SetRange("Document Type", pSalesHeader."Document Type");
        lSalesCommentLine.SetRange("No.", pSalesHeader."No.");

        //Elimino eventuali commenti collegati al vecchio segmento assegnato
        if (pxSalesHeader."ecProduct Segment No." <> pSalesHeader."ecProduct Segment No.") and
           (pxSalesHeader."ecProduct Segment No." <> '')
        then begin
            lSalesCommentLine.SetRange("ecProduct Segment No.", pxSalesHeader."ecProduct Segment No.");
            if not lSalesCommentLine.IsEmpty then begin
                lSalesCommentLine.DeleteAll();
            end;
        end;

        lSalesCommentLine.SetRange("ecProduct Segment No.");
        if not lSalesCommentLine.IsEmpty then begin
            lSalesCommentLine.FindLast();
            lLineNo := lSalesCommentLine."Line No.";
        end else begin
            lLineNo := 0;
        end;

        //Inserisco i nuovi commenti collegati al segmento assegnato
        if (pSalesHeader."ecProduct Segment No." <> '') then begin
            lCustomerProductSegments.GetCustomerProductSegment(pSalesHeader."Sell-to Customer No.", pSalesHeader."ecProduct Segment No.");
            FindProductSegmentComments(lCustomerProductSegments, lAWPRecordCommentLine, 0);
            if not lAWPRecordCommentLine.IsEmpty then begin
                lAWPCommentsManagement.SetDestinationTable(pSalesHeader);
                lAWPRecordCommentLine.FindSet();
                repeat
                    if lAWPCommentsManagement.IsValidCommentReason(lAWPRecordCommentLine."Comment Reason Code") then begin
                        lLineNo += 10000;
                        lSalesCommentLine.Init();
                        lSalesCommentLine."Document Type" := pSalesHeader."Document Type";
                        lSalesCommentLine."No." := pSalesHeader."No.";
                        lSalesCommentLine."Document Line No." := 0;
                        lSalesCommentLine."Line No." := lLineNo;
                        lSalesCommentLine.Insert(true);
                        lSalesCommentLine.Validate(Comment, lAWPRecordCommentLine.Comment);
                        lSalesCommentLine.Validate("AltAWPComment Reason Code", lAWPRecordCommentLine."Comment Reason Code");
                        lSalesCommentLine."AltAWPManual Comment" := true;
                        lSalesCommentLine."ecProduct Segment No." := pSalesHeader."ecProduct Segment No.";
                        lSalesCommentLine.Modify(true);
                    end;
                until (lAWPRecordCommentLine.Next() = 0);
                lAWPCommentsManagement.CleanDestinationObjectRef();
            end;
        end;
        //CS_VEN_034-e
    end;

    internal procedure ShowProductSegmentComment(var pCustomerProductSegments: Record "ecCustomer Product Segments")
    var
        lRecordCommentLine: Record "AltAWPRecord Comment Line";
    begin
        //CS_VEN_034-s
        if (pCustomerProductSegments."Entry No." <> 0) then begin
            FindProductSegmentComments(pCustomerProductSegments, lRecordCommentLine, 2);
            Page.Run(Page::"AltAWPRecord Comments", lRecordCommentLine);
        end;
        //CS_VEN_034-e
    end;

    internal procedure FindProductSegmentComments(var pCustomerProductSegments: Record "ecCustomer Product Segments";
                                                  var pRecordCommentLine: Record "AltAWPRecord Comment Line";
                                                  pFilterGroup: Integer): Boolean
    var
        lxFilterGroup: Integer;
    begin
        //CS_VEN_034-s
        if (pCustomerProductSegments."Entry No." <> 0) then begin
            lxFilterGroup := pRecordCommentLine.FilterGroup();

            pRecordCommentLine.Reset();
            pRecordCommentLine.FilterGroup(pFilterGroup);
            pRecordCommentLine.SetRange("Table ID", Database::"ecCustomer Product Segments");
            pRecordCommentLine.SetRange(Type, pCustomerProductSegments."Entry No.");
            pRecordCommentLine.SetRange("No.", pCustomerProductSegments."Product Segment No.");
            pRecordCommentLine.SetRange("No. 2", pCustomerProductSegments."Customer No.");
            pRecordCommentLine.SetRange("Line No.", 0);
            pRecordCommentLine.FilterGroup(lxFilterGroup);

            exit(not pRecordCommentLine.IsEmpty);
        end;

        exit(false);
        //CS_VEN_034-e
    end;

    #endregion Commenti per Clienti-Assortimento

    #region Sospensione fatturazione per le consegne nei mesi successivi
    internal procedure UpdateWhseShptDeferralInvDate(var pWarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        lCompanyInformation: Record "Company Information";
        lShippingAgentServices: Record "Shipping Agent Services";
        lDeferralInvDate: Date;
    begin
        //CS_AFC_014-s        
        if (pWarehouseShipmentHeader."AltAWPSource Document Type" = pWarehouseShipmentHeader."AltAWPSource Document Type"::"Sales Order") then begin
            lDeferralInvDate := 0D;

            if (pWarehouseShipmentHeader."Posting Date" <> 0D) then begin
                if (pWarehouseShipmentHeader."Shipping Agent Service Code" <> '') and
                   (pWarehouseShipmentHeader."AltAWPBill-to Country/Region" <> lCompanyInformation."Country/Region Code")  //Calcolo solo i documenti diversi da Italia
                then begin
                    if lShippingAgentServices.Get(pWarehouseShipmentHeader."Shipping Agent Code", pWarehouseShipmentHeader."Shipping Agent Service Code") and
                       (Format(lShippingAgentServices."Shipping Time") <> '')
                    then begin
                        lDeferralInvDate := CalcDeferralInvoiceDate(pWarehouseShipmentHeader."Posting Date", lShippingAgentServices."Shipping Time");
                    end else begin
                        lDeferralInvDate := pWarehouseShipmentHeader."Posting Date";
                    end;
                end else begin
                    lDeferralInvDate := pWarehouseShipmentHeader."Posting Date";
                end;
            end;

            pWarehouseShipmentHeader.Validate("AltAWPInvoice Deferral Date", lDeferralInvDate);
        end;
        //CS_AFC_014-e
    end;

    local procedure CalcDeferralInvoiceDate(pTargetDate: Date; pDateFormula: DateFormula): Date
    var
        lCompanyInformation: Record "Company Information";
        lCustomizedCalendarChange: array[2] of Record "Customized Calendar Change";
        lCalendarManagement: Codeunit "Calendar Management";
        lDeferralInvoiceDate: Date;
    begin
        //CS_AFC_014-s
        lCompanyInformation.Get();
        lDeferralInvoiceDate := CalcDate(pDateFormula, pTargetDate);
        lCalendarManagement.SetSource(lCompanyInformation, lCustomizedCalendarChange[1]);
        lDeferralInvoiceDate := lCalendarManagement.CalcDateBOC(Format(pDateFormula), pTargetDate, lCustomizedCalendarChange, false);

        exit(lDeferralInvoiceDate);
        //CS_AFC_014-e
    end;

    #endregion Sospensione fatturazione per le consegne nei mesi successivi

    #region CS_PRO_009 - Gestione del KIT di fatturazione per espositori

    internal procedure RecalcSalesDocumentKitExhibitorBOMPrice(pSalesHeader: Record "Sales Header"; pWithConfirm: Boolean; pForceRecalculation: Boolean)
    var
        lSalesLine: Record "Sales Line";

        lConfirm001: Label 'Are you sure you want to recalculate the "Kit/Exhibitor Item BOM" for items in the document that require it?';
    begin
        //CS_PRO_009-s
        Clear(lSalesLine);
        lSalesLine.SetRange("Document Type", pSalesHeader."Document Type");
        lSalesLine.SetRange("Document No.", pSalesHeader."No.");
        if not pForceRecalculation then begin
            lSalesLine.SetRange("ecKit/Exhibitor Recalc. Req.", true);
        end;
        lSalesLine.SetRange("Quantity Shipped", 0);

        if not lSalesLine.IsEmpty then begin
            if pWithConfirm then begin
                if not Confirm(lConfirm001, false) then exit;
            end;

            lSalesLine.FindSet();
            repeat
                CalcAndUpdateSalesLineKitExhibitorBOMPrice(lSalesLine, pForceRecalculation, false);
            until (lSalesLine.Next() = 0);
        end;
        //CS_PRO_009-e
    end;

    internal procedure CalcAndUpdateSalesLineKitExhibitorBOMPrice(var pSalesLine: Record "Sales Line"; pForceRecalculation: Boolean; pWithConfirm: Boolean)
    var
        lItem: Record Item;
        lSalesDocument: Record "Sales Header";
        lSalesQuote: Record "Sales Header";
        lSalesQuoteLine: Record "Sales Line";
        lProductionBOMLine: Record "Production BOM Line";
        lProductionBOMHeader: Record "Production BOM Header";
        lKitProdExhibitorItemBOM: Record "ecKit/Prod. Exhibitor Item BOM";
        lVersionMgt: Codeunit VersionManagement;
        lVersionCode: Code[20];
        lLineNo: Integer;

        lConfirm001: Label 'Are you sure you want to recalculate "%1" for item "%2 - %3"?';
        lBlockedItemErr: Label 'Item "%1 - %2" is blocked';
    begin
        //CS_PRO_009-s
        if not pSalesLine."ecKit/Exhibitor Recalc. Req." and not pForceRecalculation then exit;
        if not lItem.Get(pSalesLine."No.") or (lItem."Production BOM No." = '') or not lItem."ecKit/Product Exhibitor" then exit;

        lSalesDocument.Get(pSalesLine."Document Type", pSalesLine."Document No.");
        lSalesDocument.TestStatusOpen();

        if pWithConfirm then begin
            if not Confirm(StrSubstNo(lConfirm001, lKitProdExhibitorItemBOM.TableCaption, pSalesLine."No.", pSalesLine.Description), false) then exit;
        end;

        lProductionBOMHeader.Get(lItem."Production BOM No.");
        lProductionBOMHeader.TestField(Status, lProductionBOMHeader.Status::Certified);
        lVersionCode := lVersionMgt.GetBOMVersion(lItem."Production BOM No.", WorkDate(), true);

        if (pSalesLine."Quantity Shipped" = 0) then begin
            Clear(lProductionBOMLine);
            lProductionBOMLine.SetRange("Production BOM No.", lProductionBOMHeader."No.");
            lProductionBOMLine.SetRange("Version Code", lVersionCode);
            lProductionBOMLine.SetRange(Type, lProductionBOMLine.Type::Item);
            lProductionBOMLine.SetFilter("Starting Date", '<= %1 | %2', lSalesDocument."Order Date", 0D);
            lProductionBOMLine.SetFilter("Ending Date", '>=%1 | %2', lSalesDocument."Order Date", 0D);
            if lProductionBOMLine.IsEmpty then exit;

            if (pSalesLine."ecKit/Exhibitor BOM Entry No." = 0) then begin
                InsertKitExhibitorBOMPriceByProdBOMLine(lProductionBOMLine, pSalesLine."ecKit/Exhibitor BOM Entry No.");
            end else begin
                ClearKitExhibitorBOMPrice(lProductionBOMLine, pSalesLine."ecKit/Exhibitor BOM Entry No.");
            end;

            lLineNo := 0;
            Clear(lKitProdExhibitorItemBOM);
            lKitProdExhibitorItemBOM.SetRange("Entry No.", pSalesLine."ecKit/Exhibitor BOM Entry No.");
            if not lKitProdExhibitorItemBOM.IsEmpty then begin
                CopySalesOrderToTempSalesQuote(lSalesDocument, lSalesQuote);

                lKitProdExhibitorItemBOM.FindSet();
                repeat
                    lItem.Get(lKitProdExhibitorItemBOM."Item No.");
                    if not lItem.Blocked then begin
                        lLineNo += 10000;
                        lSalesQuoteLine.Init();
                        lSalesQuoteLine."Document Type" := lSalesQuote."Document Type";
                        lSalesQuoteLine."Document No." := lSalesQuote."No.";
                        lSalesQuoteLine."Line No." := lLineNo;
                        lSalesQuoteLine.Insert(true);
                        lSalesQuoteLine.Validate(Type, lSalesQuoteLine.Type::Item);
                        lSalesQuoteLine.Validate("No.", lKitProdExhibitorItemBOM."Item No.");
                        lSalesQuoteLine.Validate("Variant Code", lKitProdExhibitorItemBOM."Variant Code");
                        lSalesQuoteLine.Validate("Unit of Measure Code", lKitProdExhibitorItemBOM."Unit Of Measure Code");
                        lSalesQuoteLine.Validate(Quantity, lKitProdExhibitorItemBOM."Prod. BOM Quantity" * pSalesLine."Quantity (Base)");

                        lSalesQuoteLine."Blanket Order No." := pSalesLine."Document No.";
                        lSalesQuoteLine."Blanket Order Line No." := pSalesLine."Line No.";
                        lSalesQuoteLine.Modify(true);

                        UpdateKitExhibitorBOMPriceBySalesLine(lKitProdExhibitorItemBOM, lSalesQuoteLine);
                    end else begin
                        lKitProdExhibitorItemBOM."Error Text" := StrSubstNo(lBlockedItemErr, lKitProdExhibitorItemBOM."Item No.",
                                                                                             lKitProdExhibitorItemBOM.Description);
                    end;
                until (lKitProdExhibitorItemBOM.Next() = 0);

                lSalesQuote.Delete(true);
            end;
        end;

        //Aggiorno la riga di vendita con la distinta prezzi calcolata
        UpdateSalesLineByKitExhibitorBOMPrice(pSalesLine);
        //CS_PRO_009-e
    end;

    local procedure InsertKitExhibitorBOMPriceByProdBOMLine(var pProductionBOMLine: Record "Production BOM Line"; var pPriceBOMEntryNo: Integer)
    var
        lItem: Record Item;
        lKitProdExhibitorItemBOM: Record "ecKit/Prod. Exhibitor Item BOM";
    begin
        //CS_PRO_009-s
        if not pProductionBOMLine.IsEmpty then begin
            lKitProdExhibitorItemBOM.LockTable();
            if (pPriceBOMEntryNo = 0) then begin
                Clear(lKitProdExhibitorItemBOM);
                pPriceBOMEntryNo := 1;
                if lKitProdExhibitorItemBOM.FindLast() then begin
                    pPriceBOMEntryNo := lKitProdExhibitorItemBOM."Entry No." + 1;
                end;
            end;

            pProductionBOMLine.FindSet();
            repeat
                lItem.Get(pProductionBOMLine."No.");
                if IsItemAllowedForKit(lItem) then begin
                    lKitProdExhibitorItemBOM.Init();
                    lKitProdExhibitorItemBOM."Entry No." := pPriceBOMEntryNo;
                    lKitProdExhibitorItemBOM."Line No." := 0;
                    lKitProdExhibitorItemBOM.Insert(true);
                    lKitProdExhibitorItemBOM.Validate("Item No.", pProductionBOMLine."No.");
                    lKitProdExhibitorItemBOM.Validate("Variant Code", pProductionBOMLine."Variant Code");
                    lKitProdExhibitorItemBOM.Validate(Description, pProductionBOMLine.Description);
                    lKitProdExhibitorItemBOM.Validate("Unit Of Measure Code", pProductionBOMLine."Unit of Measure Code");
                    lKitProdExhibitorItemBOM.Validate("Prod. BOM Quantity", pProductionBOMLine.Quantity);
                    lKitProdExhibitorItemBOM.Modify(true);
                end;
            until (pProductionBOMLine.Next() = 0);

            Commit();
        end;
        //CS_PRO_009-e
    end;

    local procedure ClearKitExhibitorBOMPrice(var pProductionBOMLine: Record "Production BOM Line"; pPriceBOMEntryNo: Integer)
    var
        lItem: Record Item;
        lKitProdExhibitorItemBOM: Record "ecKit/Prod. Exhibitor Item BOM";
        lKitProdExhibitorItemBOM2: Record "ecKit/Prod. Exhibitor Item BOM";
    begin
        //CS_PRO_009-s
        lKitProdExhibitorItemBOM.SetRange("Entry No.", pPriceBOMEntryNo);

        pProductionBOMLine.SetRange(Type, pProductionBOMLine.Type::Item);
        if not pProductionBOMLine.IsEmpty then begin
            pProductionBOMLine.FindSet();
            repeat
                lItem.Get(pProductionBOMLine."No.");
                if IsItemAllowedForKit(lItem) then begin
                    lKitProdExhibitorItemBOM.SetCurrentKey("Item No.", "Variant Code", "Unit Of Measure Code", "Prod. BOM Quantity");
                    lKitProdExhibitorItemBOM.SetRange("Item No.", pProductionBOMLine."No.");
                    lKitProdExhibitorItemBOM.SetRange("Variant Code", pProductionBOMLine."Variant Code");
                    lKitProdExhibitorItemBOM.SetRange("Unit Of Measure Code", pProductionBOMLine."Unit of Measure Code");
                    lKitProdExhibitorItemBOM.SetRange("Prod. BOM Quantity", pProductionBOMLine.Quantity);
                    if lKitProdExhibitorItemBOM.FindFirst() then begin
                        lKitProdExhibitorItemBOM2 := lKitProdExhibitorItemBOM;

                        Clear(lKitProdExhibitorItemBOM);
                        lKitProdExhibitorItemBOM."Entry No." := lKitProdExhibitorItemBOM2."Entry No.";
                        lKitProdExhibitorItemBOM."Line No." := lKitProdExhibitorItemBOM2."Line No.";
                        lKitProdExhibitorItemBOM."Item No." := lKitProdExhibitorItemBOM2."Item No.";
                        lKitProdExhibitorItemBOM."Variant Code" := lKitProdExhibitorItemBOM2."Variant Code";
                        lKitProdExhibitorItemBOM.Description := lKitProdExhibitorItemBOM2.Description;
                        lKitProdExhibitorItemBOM."Unit Of Measure Code" := lKitProdExhibitorItemBOM2."Unit Of Measure Code";
                        lKitProdExhibitorItemBOM."Prod. BOM Quantity" := lKitProdExhibitorItemBOM2."Prod. BOM Quantity";
                        lKitProdExhibitorItemBOM.Modify(true);
                    end else begin
                        lKitProdExhibitorItemBOM.Init();
                        lKitProdExhibitorItemBOM."Entry No." := pPriceBOMEntryNo;
                        lKitProdExhibitorItemBOM."Line No." := 0;
                        lKitProdExhibitorItemBOM.Insert(true);
                        lKitProdExhibitorItemBOM.Validate("Item No.", pProductionBOMLine."No.");
                        lKitProdExhibitorItemBOM.Validate("Variant Code", pProductionBOMLine."Variant Code");
                        lKitProdExhibitorItemBOM.Validate(Description, pProductionBOMLine.Description);
                        lKitProdExhibitorItemBOM.Validate("Unit Of Measure Code", pProductionBOMLine."Unit of Measure Code");
                        lKitProdExhibitorItemBOM.Validate("Prod. BOM Quantity", pProductionBOMLine.Quantity);
                        lKitProdExhibitorItemBOM.Modify(true);
                    end;
                end;
            until (pProductionBOMLine.Next() = 0);
        end;

        Clear(lKitProdExhibitorItemBOM);
        lKitProdExhibitorItemBOM.SetRange("Entry No.", pPriceBOMEntryNo);
        if not lKitProdExhibitorItemBOM.IsEmpty then begin
            lKitProdExhibitorItemBOM.FindSet();
            repeat
                pProductionBOMLine.SetRange(Type, pProductionBOMLine.Type::Item);
                pProductionBOMLine.SetRange("No.", lKitProdExhibitorItemBOM."Item No.");
                pProductionBOMLine.SetRange("Variant Code", lKitProdExhibitorItemBOM."Variant Code");
                pProductionBOMLine.SetRange("Unit of Measure Code", lKitProdExhibitorItemBOM."Unit Of Measure Code");
                pProductionBOMLine.SetRange(Quantity, lKitProdExhibitorItemBOM."Prod. BOM Quantity");
                if not pProductionBOMLine.FindFirst() then begin
                    lKitProdExhibitorItemBOM2.Get(lKitProdExhibitorItemBOM."Entry No.", lKitProdExhibitorItemBOM."Line No.");
                    lKitProdExhibitorItemBOM2.Delete(true);
                end;
            until (lKitProdExhibitorItemBOM.Next() = 0);
        end;
        //CS_PRO_009-e
    end;

    local procedure CopySalesOrderToTempSalesQuote(var pSalesOrder: Record "Sales Header"; var pSalesQuote: Record "Sales Header")
    begin
        //CS_PRO_009-s
        Clear(pSalesQuote);
        if (pSalesOrder."Document Type" <> pSalesOrder."Document Type"::Order) or (pSalesOrder."No." = '') then exit;

        pSalesQuote := pSalesOrder;
        pSalesQuote."Document Type" := pSalesQuote."Document Type"::Quote;
        pSalesQuote."APsTRD Pricing Entry No." := 0;
        pSalesQuote."APsTRD Order Source Code" := '';
        pSalesQuote."APsTRD Urgency Type Code" := '';
        pSalesQuote."APsTRD Trading Reason Code" := '';
        pSalesQuote.Validate("Shipment Date", CalcDate('<3M>', Today));
        pSalesQuote.Validate("Requested Delivery Date", CalcDate('<3M>', Today));
        pSalesQuote."APsTRD Auto. Pricing Status" := pSalesQuote."APsTRD Auto. Pricing Status"::Open;
        pSalesQuote."No." := 'TMP_' + Format(CurrentDateTime, 0, '<Year,2><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2><Second dec>');
        pSalesQuote.Insert(true);
        //CS_PRO_009-e
    end;

    local procedure UpdateKitExhibitorBOMPriceBySalesLine(var pKitProdExhibitorItemBOM: Record "ecKit/Prod. Exhibitor Item BOM";
                                                          var pSalesLine: Record "Sales Line")
    var
        lCurrency: Record Currency;
        lErrorPrice: Label 'Unit price not found';
    begin
        //CS_PRO_009-s
        if not lCurrency.Get(pSalesLine."Currency Code") then lCurrency.InitRoundingPrecision();
        pKitProdExhibitorItemBOM.Validate(Quantity, pSalesLine.Quantity);
        pKitProdExhibitorItemBOM.Validate("Quantity (Base)", pSalesLine."Quantity (Base)");
        pKitProdExhibitorItemBOM.Validate("Unit Price", Round(pSalesLine."Unit Price", lCurrency."Unit-Amount Rounding Precision"));
        pKitProdExhibitorItemBOM.Validate("Composed Discount", pSalesLine."APsComposed Discount");
        pKitProdExhibitorItemBOM.Validate("Line Discount %", pSalesLine."Line Discount %");
        pKitProdExhibitorItemBOM.Validate("Line Amount", Round((pSalesLine."Line Amount" / pSalesLine."Quantity (Base)") * pKitProdExhibitorItemBOM."Prod. BOM Quantity", lCurrency."Amount Rounding Precision"));
        pKitProdExhibitorItemBOM.Validate("Source Order No.", pSalesLine."Blanket Order No.");
        pKitProdExhibitorItemBOM.Validate("Source Order Line No.", pSalesLine."Blanket Order Line No.");
        pKitProdExhibitorItemBOM.Validate("Consumer UM", pSalesLine."ecConsumer Unit of Measure");
        pKitProdExhibitorItemBOM.Validate("Quantity (Consumer UM)", pSalesLine."ecQuantity (Consumer UM)");
        pKitProdExhibitorItemBOM.Validate("Unit Price (Consumer UM)", pSalesLine."ecUnit Price (Consumer UM)");
        if (pSalesLine."Unit Price" = 0) then begin
            pKitProdExhibitorItemBOM."Error Text" := lErrorPrice;
        end;

        pKitProdExhibitorItemBOM.Modify(true);
        //CS_PRO_009-e
    end;

    local procedure UpdateSalesLineByKitExhibitorBOMPrice(var pSalesLine: Record "Sales Line")
    var
        lKitProdExhibitorItemBOM: Record "ecKit/Prod. Exhibitor Item BOM";
        lComposedDiscount: Text;
        lTotalUnitPrice: Decimal;
        lTotalLineAmount: Decimal;
    begin
        //CS_PRO_009-s
        lTotalUnitPrice := 0;
        lTotalLineAmount := 0;
        lComposedDiscount := '';
        Clear(lKitProdExhibitorItemBOM);
        lKitProdExhibitorItemBOM.SetRange("Entry No.", pSalesLine."ecKit/Exhibitor BOM Entry No.");
        lKitProdExhibitorItemBOM.SetFilter("Error Text", '<>%1', '');
        if not lKitProdExhibitorItemBOM.IsEmpty then begin
            pSalesLine.Validate("Unit Price", 0);
            pSalesLine.Validate("APsComposed Discount", '');
            pSalesLine.Modify(true);
            exit;
        end;

        Clear(lKitProdExhibitorItemBOM);
        lKitProdExhibitorItemBOM.SetRange("Entry No.", pSalesLine."ecKit/Exhibitor BOM Entry No.");
        lKitProdExhibitorItemBOM.SetRange("Error Text");
        if not lKitProdExhibitorItemBOM.IsEmpty then begin
            lKitProdExhibitorItemBOM.FindSet();
            lComposedDiscount := lKitProdExhibitorItemBOM."Composed Discount";
            repeat
                if (lComposedDiscount <> lKitProdExhibitorItemBOM."Composed Discount") then lComposedDiscount := '';
                lTotalUnitPrice += lKitProdExhibitorItemBOM."Unit Price" * lKitProdExhibitorItemBOM."Prod. BOM Quantity";
                lTotalLineAmount += lKitProdExhibitorItemBOM."Line Amount";
            until (lKitProdExhibitorItemBOM.Next() = 0);

            pSalesLine.Validate("Unit Price", lTotalUnitPrice);
            if (lComposedDiscount <> '') then begin
                pSalesLine.Validate("APsComposed Discount", lComposedDiscount);
            end else begin
                if (lComposedDiscount = '') and (lTotalLineAmount <> lTotalUnitPrice) then begin
                    pSalesLine.Validate("Line Amount", lTotalLineAmount * pSalesLine."Quantity (Base)");
                end;
            end;

            pSalesLine."ecKit/Exhib. Manual Price" := false;
            pSalesLine."ecKit/Exhibitor Recalc. Req." := false;
            pSalesLine.Modify(true);
        end;
        //CS_PRO_009-e
    end;

    internal procedure CreateRefreshKitExhibComponentByBOMLine(var pProductionBOMHeader: Record "Production BOM Header"; pSkipItemCheck: Boolean)
    var
        lItem: Record Item;
        lProductionBOMLine: Record "Production BOM Line";
        lVersionMgt: Codeunit VersionManagement;
        lVersionCode: Code[20];
    begin
        //CS_PRO_009-s
        if not pSkipItemCheck then begin
            Clear(lItem);
            lItem.SetCurrentKey("Production BOM No.");
            lItem.SetRange("Production BOM No.", pProductionBOMHeader."No.");
            lItem.SetRange("ecKit/Product Exhibitor", true);
            if lItem.IsEmpty then exit;
        end;

        pProductionBOMHeader.TestField(Status, pProductionBOMHeader.Status::Certified);
        lVersionCode := lVersionMgt.GetBOMVersion(pProductionBOMHeader."No.", WorkDate(), true);

        Clear(lProductionBOMLine);
        lProductionBOMLine.SetRange("Production BOM No.", pProductionBOMHeader."No.");
        lProductionBOMLine.SetRange("Version Code", lVersionCode);
        lProductionBOMLine.SetRange(Type, lProductionBOMLine.Type::Item);
        if not lProductionBOMLine.IsEmpty then begin
            lProductionBOMLine.FindSet();
            repeat
                lItem.Get(lProductionBOMLine."No.");
                if IsItemAllowedForKit(lItem) then begin
                    CloneOrRefreshNonInventItemByInventItem(lProductionBOMLine."No.");
                    Commit();
                end;
            until (lProductionBOMLine.Next() = 0);
        end;
        //CS_PRO_009-e
    end;

    local procedure CloneOrRefreshNonInventItemByInventItem(pInventoriableItemNo: Code[20])
    var
        lItem: Record Item;
        lOriginItemUnitofMeasure: Record "Item Unit of Measure";
        lDestItemUnitofMeasure: Record "Item Unit of Measure";
        lDestinationItem: Record Item;
    begin
        //CS_PRO_009-s
        lItem.Get(pInventoriableItemNo);
        if not lDestinationItem.Get(lItem."ecNon-Invent. Linked Item No.") then begin
            lDestinationItem := lItem;
            lDestinationItem."No." := lDestinationItem."No." + 'E';
            lDestinationItem.Insert(true);
        end else begin
            lDestinationItem.TransferFields(lItem, false);
        end;

        Clear(lDestinationItem."Expiration Calculation");
        Clear(lDestinationItem."ecCalc. for Max Usable Date");
        lDestinationItem."ecKit/Product Exhibitor" := false;
        lDestinationItem."Reordering Policy" := lDestinationItem."Reordering Policy"::" ";
        lDestinationItem."Item Tracking Code" := '';
        lDestinationItem."Replenishment System" := lDestinationItem."Replenishment System"::Purchase;
        lDestinationItem."Production BOM No." := '';
        lDestinationItem."Routing No." := '';
        lDestinationItem.Validate(Type, lDestinationItem.Type::"Non-Inventory");
        lDestinationItem.Modify(true);

        lItem."ecNon-Invent. Linked Item No." := lDestinationItem."No.";
        lItem.Modify(true);

        Clear(lOriginItemUnitofMeasure);
        lOriginItemUnitofMeasure.SetRange("Item No.", pInventoriableItemNo);
        if not lOriginItemUnitofMeasure.IsEmpty then begin
            lOriginItemUnitofMeasure.FindSet();
            repeat
                if not lDestItemUnitofMeasure.Get(lDestinationItem."No.", lOriginItemUnitofMeasure.Code) then begin
                    lDestItemUnitofMeasure := lOriginItemUnitofMeasure;
                    lDestItemUnitofMeasure."Item No." := lDestinationItem."No.";
                    lDestItemUnitofMeasure.Insert(true);
                end else begin
                    lDestItemUnitofMeasure.TransferFields(lOriginItemUnitofMeasure, false);
                    lDestItemUnitofMeasure.Modify(true);
                end;
            until (lOriginItemUnitofMeasure.Next() = 0);
        end;
        //CS_PRO_009-e
    end;

    internal procedure CheckKitExhibitorItem(var pItem: Record Item)
    var
        lProductionBOMHeader: Record "Production BOM Header";
        lConfirmKitExhibItem: Label 'The item has been marked as a Kit/Display!\\You need to generate or update the "Not in Inventory" list to use in invoicing.\\Do you want to confirm the operation?';
        lError001: Label 'Operation canceled';
    begin
        //CS_PRO_009-s
        if pItem."ecKit/Product Exhibitor" then begin
            pItem.TestField("Production BOM No.");
            lProductionBOMHeader.Get(pItem."Production BOM No.");

            if not Confirm(lConfirmKitExhibItem, false) then Error(lError001);
            CreateRefreshKitExhibComponentByBOMLine(lProductionBOMHeader, true);
        end;
        //CS_PRO_009-e
    end;

    internal procedure ManageKitExhibLineOnCreateSalesInv(var pSalesLine: Record "Sales Line"; var pNextLineNo: Integer)
    var
        lItem: Record Item;
    begin
        //CS_PRO_009-s
        if (pSalesLine."ecKit/Exhibitor BOM Entry No." <> 0) and lItem.Get(pSalesLine."No.") and lItem."ecKit/Product Exhibitor" then begin
            CreateReversalKitExhibSalesInvLine(pSalesLine, pNextLineNo);

            CreateSalesInvLinesByKitExhibPriceBOM(pSalesLine, pNextLineNo);
        end;
        //CS_PRO_009-e
    end;

    local procedure CreateReversalKitExhibSalesInvLine(var pSalesLine: Record "Sales Line"; var pNextLineNo: Integer)
    var
        lGeneralPostingSetup: Record "General Posting Setup";
        lReversalSalesLine: Record "Sales Line";

        lLineDescLabel: Label 'BILLING CANCELLATION ITEM NO. %1';
    begin
        //CS_PRO_009-s
        lGeneralPostingSetup.Get(pSalesLine."Gen. Bus. Posting Group", pSalesLine."Gen. Prod. Posting Group");

        pNextLineNo += 10000;

        lReversalSalesLine.Init();
        lReversalSalesLine."Document Type" := pSalesLine."Document Type";
        lReversalSalesLine."Document No." := pSalesLine."Document No.";
        lReversalSalesLine."Line No." := pNextLineNo;
        lReversalSalesLine.Insert(true);
        lReversalSalesLine.Validate(Type, lReversalSalesLine.Type::"G/L Account");
        lReversalSalesLine.Validate("No.", lGeneralPostingSetup."Sales Account");
        lReversalSalesLine.Validate(Description, StrSubstNo(lLineDescLabel, pSalesLine."No."));
        lReversalSalesLine.Validate(Quantity, -pSalesLine.Quantity);
        lReversalSalesLine.Validate("Unit Price", pSalesLine."Unit Price");
        lReversalSalesLine.Validate("APsComposed Discount", pSalesLine."APsComposed Discount");
        lReversalSalesLine.Validate("Gen. Bus. Posting Group", pSalesLine."Gen. Bus. Posting Group");
        lReversalSalesLine.Validate("Gen. Prod. Posting Group", pSalesLine."Gen. Prod. Posting Group");
        lReversalSalesLine.Validate("VAT Bus. Posting Group", pSalesLine."VAT Bus. Posting Group");
        lReversalSalesLine.Validate("VAT Prod. Posting Group", pSalesLine."VAT Prod. Posting Group");
        lReversalSalesLine.Validate("VAT Identifier", pSalesLine."VAT Identifier");
        lReversalSalesLine.Validate("ecAttacch. Kit/Exhib. Line No.", pSalesLine."Line No.");
        lReversalSalesLine.Modify(true);
        //CS_PRO_009-e
    end;

    local procedure CreateSalesInvLinesByKitExhibPriceBOM(var pSalesLine: Record "Sales Line"; var pNextLineNo: Integer)
    var
        lItem: Record Item;
        lLinkedItem: Record Item;
        lNewInvLine: Record "Sales Line";
        lKitProdExhibitorItemBOM: Record "ecKit/Prod. Exhibitor Item BOM";

        lblComposedBy: Label 'Composition detail of item no. %1:';
    begin
        //CS_PRO_009-s
        Clear(lKitProdExhibitorItemBOM);
        lKitProdExhibitorItemBOM.SetRange("Entry No.", pSalesLine."ecKit/Exhibitor BOM Entry No.");
        if not lKitProdExhibitorItemBOM.IsEmpty then begin
            lKitProdExhibitorItemBOM.FindSet();

            //Inserisco riga di commento
            pNextLineNo += 10000;
            lNewInvLine.Init();
            lNewInvLine."Document Type" := pSalesLine."Document Type";
            lNewInvLine."Document No." := pSalesLine."Document No.";
            lNewInvLine."Line No." := pNextLineNo;
            lNewInvLine.Insert(true);
            lNewInvLine.Validate(Type, lNewInvLine.Type::" ");
            lNewInvLine.Validate(Description, StrSubstNo(lblComposedBy, pSalesLine."No."));
            lNewInvLine.Validate("ecAttacch. Kit/Exhib. Line No.", pSalesLine."Line No.");
            lNewInvLine.Modify(true);

            repeat
                pNextLineNo += 10000;
                lItem.Get(lKitProdExhibitorItemBOM."Item No.");
                lItem.TestField("ecNon-Invent. Linked Item No.");
                lLinkedItem.Get(lItem."ecNon-Invent. Linked Item No.");
                lNewInvLine.Init();
                lNewInvLine."Document Type" := pSalesLine."Document Type";
                lNewInvLine."Document No." := pSalesLine."Document No.";
                lNewInvLine."Line No." := pNextLineNo;
                lNewInvLine.Insert(true);
                lNewInvLine.Validate(Type, lNewInvLine.Type::Item);
                lNewInvLine.Validate("No.", lLinkedItem."No.");
                lNewInvLine.Validate("Variant Code", lKitProdExhibitorItemBOM."Variant Code");
                lNewInvLine.Validate("Unit of Measure Code", lKitProdExhibitorItemBOM."Unit Of Measure Code");
                lNewInvLine.Validate(Quantity, lKitProdExhibitorItemBOM."Prod. BOM Quantity" * pSalesLine.Quantity);
                lNewInvLine.Validate("Unit Price", lKitProdExhibitorItemBOM."Unit Price");
                lNewInvLine.Validate("APsComposed Discount", lKitProdExhibitorItemBOM."Composed Discount");
                lNewInvLine.Validate("ecAttacch. Kit/Exhib. Line No.", pSalesLine."Line No.");
                lNewInvLine.Modify(true);
            until (lKitProdExhibitorItemBOM.Next() = 0);
        end;
        //CS_PRO_009-e
    end;

    local procedure IsItemAllowedForKit(pItem: Record Item): Boolean
    begin
        if (pItem."ecItem Type" in [pItem."ecItem Type"::"Finished Product"]) then exit(true);
        exit(false);
    end;

    #endregion CS_PRO_009 - Gestione del KIT di fatturazione per espositori
}
