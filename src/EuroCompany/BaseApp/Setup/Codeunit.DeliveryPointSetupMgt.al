namespace EuroCompany.BaseApp.Setup;

using EuroCompany.BaseApp.Sales.AdvancedTrade;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;

codeunit 50015 "Delivery Point Setup Mgt"
{
    Permissions = tabledata "APsEII Other Mgt. Data" = rimd;

    procedure SuggestDeliveryPoint(var OtherMgtDataDoc: Record "APsEII Other Mgt. Data")
    var
        DeliveryPointSetup: Record "ecDelivery Point Setup";
        SalesHeader: Record "Sales Header";
        SalesHeader2: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        if SalesHeader.Get(OtherMgtDataDoc."Document Type", OtherMgtDataDoc."Document No.") then begin
            if SalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", OtherMgtDataDoc."Document Line No.") then
                if not CheckIfOtherMgtDataExists(SalesLine) then
                    if CheckSalesLineType(SalesLine) then begin
                        if SalesHeader2.Get(SalesHeader2."Document Type"::Order, SalesLine."AltAWPOrder No.") then;

                        if DeliveryPointSetup.Get(SalesLine."Sell-to Customer No.", SalesHeader."Ship-to Code", SalesHeader2."ecProduct Segment No.") then begin
                            OtherMgtDataDoc."Data Type" := DeliveryPointSetup."Data Type";

                            if DeliveryPointSetup."Text Reference" <> '' then
                                OtherMgtDataDoc."Text Reference" := DeliveryPointSetup."Text Reference"
                            else
                                GetTextReferenceFromTableID(DeliveryPointSetup, OtherMgtDataDoc);
                        end else begin
                            if not SearchForShipToCode(SalesHeader, SalesLine, DeliveryPointSetup, OtherMgtDataDoc) then begin
                                if not SearchForSegmentNo(SalesHeader2, SalesLine, DeliveryPointSetup, OtherMgtDataDoc) then
                                    SearchForCustomerNo(SalesLine, DeliveryPointSetup, OtherMgtDataDoc);
                            end;
                        end;
                    end;
        end else
            SuggestSalesInvDeliveryPoint(OtherMgtDataDoc);
    end;

    procedure CheckSalesLineType(SalesLine: Record "Sales Line") IsAllowed: Boolean;
    begin
        IsAllowed := false;
        case SalesLine.Type of
            "Sales Line Type"::Item:
                IsAllowed := true;
            "Sales Line Type"::"G/L Account":
                IsAllowed := true;
            "Sales Line Type"::"Charge (Item)":
                IsAllowed := true;
            "Sales Line Type"::"Fixed Asset":
                IsAllowed := true;
        end;
    end;

    procedure SearchForShipToCode(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; DeliveryPointSetup: Record "ecDelivery Point Setup"; var OtherMgtDataDoc: Record "APsEII Other Mgt. Data"): Boolean;
    begin
        DeliveryPointSetup.Reset();
        DeliveryPointSetup.SetRange("Customer No.", SalesLine."Sell-to Customer No.");
        DeliveryPointSetup.SetRange("Ship-to Code", SalesHeader."Ship-to Code");

        if DeliveryPointSetup.FindFirst() then begin
            if DeliveryPointSetup."Ship-to Code" = '' then exit(false);

            OtherMgtDataDoc."Data Type" := DeliveryPointSetup."Data Type";
            if DeliveryPointSetup."Text Reference" <> '' then begin
                OtherMgtDataDoc."Text Reference" := DeliveryPointSetup."Text Reference";
                exit(true);
            end else
                if GetTextReferenceFromTableID(DeliveryPointSetup, OtherMgtDataDoc) then
                    exit(true);
        end;
        exit(false);
    end;

    procedure SearchForSegmentNo(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; DeliveryPointSetup: Record "ecDelivery Point Setup"; var OtherMgtDataDoc: Record "APsEII Other Mgt. Data"): Boolean;
    begin
        DeliveryPointSetup.Reset();
        DeliveryPointSetup.SetRange("Customer No.", SalesLine."Sell-to Customer No.");
        DeliveryPointSetup.SetRange("Product Segment No.", SalesHeader."ecProduct Segment No.");

        if DeliveryPointSetup.FindFirst() then begin
            if DeliveryPointSetup."Product Segment No." = '' then exit(false);

            OtherMgtDataDoc."Data Type" := DeliveryPointSetup."Data Type";
            if DeliveryPointSetup."Text Reference" <> '' then begin
                OtherMgtDataDoc."Text Reference" := DeliveryPointSetup."Text Reference";
                exit(true);
            end else
                if GetTextReferenceFromTableID(DeliveryPointSetup, OtherMgtDataDoc) then
                    exit(true);
        end;
        exit(false);
    end;

    procedure SearchForCustomerNo(SalesLine: Record "Sales Line"; DeliveryPointSetup: Record "ecDelivery Point Setup"; var OtherMgtDataDoc: Record "APsEII Other Mgt. Data"): Boolean;
    begin
        DeliveryPointSetup.Reset();
        DeliveryPointSetup.SetRange("Customer No.", SalesLine."Sell-to Customer No.");
        if DeliveryPointSetup.FindFirst() then
            OtherMgtDataDoc."Data Type" := DeliveryPointSetup."Data Type";

        if DeliveryPointSetup."Text Reference" <> '' then begin
            OtherMgtDataDoc."Text Reference" := DeliveryPointSetup."Text Reference";
            exit(true);
        end else
            if GetTextReferenceFromTableID(DeliveryPointSetup, OtherMgtDataDoc) then
                exit(true);
        exit(false);
    end;

    procedure GetTextReferenceFromTableID(DeliveryPointSetup: Record "ecDelivery Point Setup"; var OtherMgtDataDoc: Record "APsEII Other Mgt. Data"): Boolean;
    var
        Customer: Record Customer;
        ShipToAddress: Record "Ship-to Address";
        ProductSegments: Record "ecCustomer Product Segments";
        RecordRef: RecordRef;
        FieldValue: FieldRef;
        FieldRef: FieldRef;
        ProdSegNo: Code[20];
        CustomerNo: Code[20];
        ShiptoCode: Code[20];
    begin
        case DeliveryPointSetup."ID Table" of
            18:
                if Customer.Get(DeliveryPointSetup."Customer No.") then begin
                    RecordRef.Open(DeliveryPointSetup."ID Table");
                    RecordRef.SetTable(Customer);
                    if RecordRef.FindSet() then begin
                        repeat
                            FieldRef := RecordRef.Field(1);
                            CustomerNo := FieldRef.Value;

                            if CustomerNo = DeliveryPointSetup."Customer No." then begin
                                FieldValue := RecordRef.Field(DeliveryPointSetup."Field Number");

                                if FieldValue.Class = FieldValue.Class::FlowField then
                                    FieldValue.CalcField();
                                OtherMgtDataDoc."Text Reference" := FieldValue.Value;
                                exit(true);
                            end;
                        until RecordRef.Next() = 0;
                    end;
                end;
            222:
                if ShipToAddress.Get(DeliveryPointSetup."Customer No.", DeliveryPointSetup."Ship-to Code") then begin
                    RecordRef.Open(DeliveryPointSetup."ID Table");
                    RecordRef.SetTable(ShipToAddress);
                    if RecordRef.FindSet() then begin
                        repeat
                            FieldRef := RecordRef.Field(1);
                            CustomerNo := FieldRef.Value;
                            FieldRef := RecordRef.Field(2);
                            ShiptoCode := FieldRef.Value;

                            if (CustomerNo = DeliveryPointSetup."Customer No.") and (ShiptoCode = DeliveryPointSetup."Ship-to Code") then begin
                                FieldValue := RecordRef.Field(DeliveryPointSetup."Field Number");

                                if FieldValue.Class = FieldValue.Class::FlowField then
                                    FieldValue.CalcField();
                                OtherMgtDataDoc."Text Reference" := FieldValue.Value;
                                exit(true);
                            end;
                        until RecordRef.Next() = 0;
                    end;
                end;
            50019:
                begin
                    ProductSegments.Reset();
                    ProductSegments.SetRange("Customer No.", DeliveryPointSetup."Customer No.");
                    ProductSegments.SetRange("Product Segment No.", DeliveryPointSetup."Product Segment No.");

                    RecordRef.Open(DeliveryPointSetup."ID Table");
                    RecordRef.SetTable(ProductSegments);
                    if RecordRef.FindSet() then begin
                        repeat
                            FieldRef := RecordRef.Field(5);
                            ProdSegNo := FieldRef.Value;
                            FieldRef := RecordRef.Field(2);
                            CustomerNo := FieldRef.Value;

                            if (ProdSegNo = DeliveryPointSetup."Product Segment No.") and (CustomerNo = DeliveryPointSetup."Customer No.") then begin
                                FieldValue := RecordRef.Field(DeliveryPointSetup."Field Number");

                                if FieldValue.Class = FieldValue.Class::FlowField then
                                    FieldValue.CalcField();
                                OtherMgtDataDoc."Text Reference" := FieldValue.Value;
                                exit(true);
                            end;
                        until RecordRef.Next() = 0;
                    end;
                end;
        end;
        exit(false);
    end;

    procedure CheckIfOtherMgtDataExists(SalesLine: Record "Sales Line"): Boolean;
    var
        OtherMgtData: Record "APsEII Other Mgt. Data";
    begin
        OtherMgtData.Reset();
        OtherMgtData.SetRange("Document Type", SalesLine."Document Type");
        OtherMgtData.SetRange("Document No.", SalesLine."Document No.");
        OtherMgtData.SetRange("Document Line No.", SalesLine."Line No.");
        if not OtherMgtData.IsEmpty() then
            exit(true)
        else
            exit(false);
    end;

    procedure SuggestSalesInvDeliveryPoint(var OtherMgtDataDoc: Record "APsEII Other Mgt. Data")
    var
        DeliveryPointSetup: Record "ecDelivery Point Setup";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesHeader: Record "Sales Header";
        SalesInvLine: Record "Sales Invoice Line";
    begin
        if SalesInvHeader.Get(OtherMgtDataDoc."Document No.") then
            if SalesInvLine.Get(SalesInvHeader."No.", OtherMgtDataDoc."Document Line No.") then
                if CheckSalesInvLineType(SalesInvLine) then begin
                    if SalesHeader.Get(SalesHeader."Document Type"::Order, SalesInvLine."AltAWPOrder No.") then;

                    if DeliveryPointSetup.Get(SalesInvLine."Sell-to Customer No.", SalesInvHeader."Ship-to Code", SalesHeader."ecProduct Segment No.") then begin
                        OtherMgtDataDoc."Data Type" := DeliveryPointSetup."Data Type";

                        if DeliveryPointSetup."Text Reference" <> '' then
                            OtherMgtDataDoc."Text Reference" := DeliveryPointSetup."Text Reference"
                        else
                            GetTextReferenceFromTableID(DeliveryPointSetup, OtherMgtDataDoc);
                    end else begin
                        if not SearchForSalesInvShipToCode(SalesInvHeader, SalesInvLine, DeliveryPointSetup, OtherMgtDataDoc) then begin
                            if not SearchForSalesInvSegmentNo(SalesHeader, SalesInvLine, DeliveryPointSetup, OtherMgtDataDoc) then
                                SearchForSalesInvCustomerNo(SalesInvLine, DeliveryPointSetup, OtherMgtDataDoc);
                        end;
                    end;
                end;
    end;

    procedure CheckSalesInvLineType(SalesInvLine: Record "Sales Invoice Line") IsAllowed: Boolean;
    begin
        IsAllowed := false;
        case SalesInvLine.Type of
            "Sales Line Type"::Item:
                IsAllowed := true;
            "Sales Line Type"::"G/L Account":
                IsAllowed := true;
            "Sales Line Type"::"Charge (Item)":
                IsAllowed := true;
            "Sales Line Type"::"Fixed Asset":
                IsAllowed := true;
        end;
    end;

    procedure SearchForSalesInvShipToCode(SalesInvHeader: Record "Sales Invoice Header"; SalesInvLine: Record "Sales Invoice Line"; DeliveryPointSetup: Record "ecDelivery Point Setup"; var OtherMgtDataDoc: Record "APsEII Other Mgt. Data"): Boolean;
    begin
        DeliveryPointSetup.Reset();
        DeliveryPointSetup.SetRange("Customer No.", SalesInvLine."Sell-to Customer No.");
        DeliveryPointSetup.SetRange("Ship-to Code", SalesInvHeader."Ship-to Code");

        if DeliveryPointSetup.FindFirst() then begin
            if DeliveryPointSetup."Ship-to Code" = '' then exit(false);

            OtherMgtDataDoc."Data Type" := DeliveryPointSetup."Data Type";
            if DeliveryPointSetup."Text Reference" <> '' then begin
                OtherMgtDataDoc."Text Reference" := DeliveryPointSetup."Text Reference";
                exit(true);
            end else
                if GetTextReferenceFromTableID(DeliveryPointSetup, OtherMgtDataDoc) then
                    exit(true);
        end;
        exit(false);
    end;

    procedure SearchForSalesInvSegmentNo(SalesHeader: Record "Sales Header"; SalesInvLine: Record "Sales Invoice Line"; DeliveryPointSetup: Record "ecDelivery Point Setup"; var OtherMgtDataDoc: Record "APsEII Other Mgt. Data"): Boolean;
    begin
        DeliveryPointSetup.Reset();
        DeliveryPointSetup.SetRange("Customer No.", SalesInvLine."Sell-to Customer No.");
        DeliveryPointSetup.SetRange("Product Segment No.", SalesHeader."ecProduct Segment No.");

        if DeliveryPointSetup.FindFirst() then begin
            if DeliveryPointSetup."Product Segment No." = '' then exit(false);

            OtherMgtDataDoc."Data Type" := DeliveryPointSetup."Data Type";
            if DeliveryPointSetup."Text Reference" <> '' then begin
                OtherMgtDataDoc."Text Reference" := DeliveryPointSetup."Text Reference";
                exit(true);
            end else
                if GetTextReferenceFromTableID(DeliveryPointSetup, OtherMgtDataDoc) then
                    exit(true);
        end;
        exit(false);
    end;

    procedure SearchForSalesInvCustomerNo(SalesInvLine: Record "Sales Invoice Line"; DeliveryPointSetup: Record "ecDelivery Point Setup"; var OtherMgtDataDoc: Record "APsEII Other Mgt. Data"): Boolean;
    begin
        DeliveryPointSetup.Reset();
        DeliveryPointSetup.SetRange("Customer No.", SalesInvLine."Sell-to Customer No.");
        if DeliveryPointSetup.FindFirst() then
            OtherMgtDataDoc."Data Type" := DeliveryPointSetup."Data Type";

        if DeliveryPointSetup."Text Reference" <> '' then begin
            OtherMgtDataDoc."Text Reference" := DeliveryPointSetup."Text Reference";
            exit(true);
        end else
            if GetTextReferenceFromTableID(DeliveryPointSetup, OtherMgtDataDoc) then
                exit(true);
        exit(false);
    end;

    procedure InitOtherMgtDataDoc(SalesLine: Record "Sales Line")
    var
        OtherMgtDataDoc: Record "APsEII Other Mgt. Data";
        OtherMgtData: Record "APsEII Other Mgt. Data";
    begin
        OtherMgtDataDoc.Reset();
        OtherMgtDataDoc.SetRange("Table Id", Database::"Sales Header");
        OtherMgtDataDoc.SetRange("Document No.", SalesLine."Document No.");
        OtherMgtDataDoc.SetRange("Document Line No.", SalesLine."Line No.");
        if not OtherMgtDataDoc.FindLast() then begin
            OtherMgtDataDoc.Init();
            OtherMgtDataDoc."Table Id" := Database::"Sales Header";
            OtherMgtDataDoc."Document Type" := SalesLine."Document Type";
            OtherMgtDataDoc."Document No." := SalesLine."Document No.";
            OtherMgtDataDoc."Document Line No." := SalesLine."Line No.";
            SuggestDeliveryPoint(OtherMgtDataDoc);
            if (OtherMgtDataDoc."Data Type" <> '') and (OtherMgtDataDoc."Text Reference" <> '') then begin
                OtherMgtDataDoc.Insert();
            end;
        end else begin
            OtherMgtData := OtherMgtDataDoc;
            OtherMgtData."Line No." := OtherMgtDataDoc."Line No." + 10000;
            SuggestDeliveryPoint(OtherMgtData);
        end;
    end;
}
