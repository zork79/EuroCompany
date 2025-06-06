namespace EuroCompany.BaseApp.Sales.Commissions;
using EuroCompany.BaseApp;
using EuroCompany.BaseApp.Sales;
using EuroCompany.BaseApp.Setup;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;

//AFC_CS_005
codeunit 50024 CommissionCalc
{
    procedure CheckCustomerComm(parecAgentContrExceptSetup: Record "ecAgent Contr Except Setup"; parDocHeader: Record "Sales Header"): Boolean
    var
        ecAgentContrExceptSetupSrc: Record "ecAgent Contr Except Setup";

    begin
        //Search for Customer Type
        ecAgentContrExceptSetupSrc.Reset();
        Case parecAgentContrExceptSetup."Customer Type" of
            parecAgentContrExceptSetup."Customer Type"::Customer:
                begin
                    ecAgentContrExceptSetupSrc.SetRange("Customer Type Code", parDocHeader."Sell-to Customer No.");
                    if not ecAgentContrExceptSetupSrc.IsEmpty() then
                        exit(true);
                end;
        end;
    end;

    procedure CheckCustomerInSegment(parSegmentNo: code[20]; parCustomerTypeCode: Code[20]; parCustomerNo: Code[20]): Boolean
    var
        APsTRDBusinessSegment: Record "APsTRD Business Segment";
        APsTRDBusinessSegmentDetail: record "APsTRD Business Segment Detail";

    begin
        //Search for segment
        if APsTRDBusinessSegment.Get(parCustomerTypeCode) then
            if APsTRDBusinessSegment."Special Segment Type" = APsTRDBusinessSegment."Special Segment Type"::"All Subjects" then
                exit(true)
            else
                if APsTRDBusinessSegment."Special Segment Type" = APsTRDBusinessSegment."Special Segment Type"::No then begin
                    APsTRDBusinessSegmentDetail.Reset();
                    APsTRDBusinessSegmentDetail.SetRange("Segment No.", APsTRDBusinessSegment."No.");
                    APsTRDBusinessSegmentDetail.SetRange("Element Type", APsTRDBusinessSegmentDetail."Element Type"::Customer);
                    APsTRDBusinessSegmentDetail.SetRange("Element No.", parCustomerNo);  //Customer No.
                    if not APsTRDBusinessSegmentDetail.IsEmpty() then
                        exit(true);
                end;
    end;

    procedure CheckItemComm(parDocCommSet: Record "APsSCM Document Commission Set"; parecAgentContrExceptSetup: Record "ecAgent Contr Except Setup";
                            parDocHeader: Record "Sales Header"): Boolean
    var
        ecAgentContrExceptSetupSrc: Record "ecAgent Contr Except Setup";
        Salesline: Record "Sales Line";

    begin
        //Search for Item Type
        if Salesline.Get(parDocCommSet."Document Type", parDocCommSet."Document No.", parDocCommSet."Document Line No.") then begin
            ecAgentContrExceptSetupSrc.Reset();
            Case parecAgentContrExceptSetup."Item Type" of
                parecAgentContrExceptSetup."Item Type"::Item:
                    begin
                        ecAgentContrExceptSetupSrc.SetRange("Item Type Code", Salesline."No.");
                        if not ecAgentContrExceptSetupSrc.IsEmpty() then
                            exit(true);
                    end;
            end;
        end;
    end;

    procedure CheckItemInSegment(parDocCommSet: Record "APsSCM Document Commission Set"; parecAgentContrExceptSetup: Record "ecAgent Contr Except Setup"; parItemTypeCode: Code[20]): Boolean
    var
        APsTRDProductSegment: Record "APsTRD Product Segment";
        APsTRDProductSegmentDetail: record "APsTRD Product Segment Detail";
        Salesline: Record "Sales Line";

    begin
        //Search for item in segment
        Case parecAgentContrExceptSetup."Item Type" of
            parecAgentContrExceptSetup."Item Type"::"Product Segment":
                begin
                    if Salesline.Get(parDocCommSet."Document Type", parDocCommSet."Document No.", parDocCommSet."Document Line No.") then
                        if APsTRDProductSegment.Get(parItemTypeCode) then begin
                            APsTRDProductSegmentDetail.Reset();
                            APsTRDProductSegmentDetail.SetRange("Segment No.", APsTRDProductSegment."No.");
                            APsTRDProductSegmentDetail.SetRange("Element Type", APsTRDProductSegmentDetail."Element Type"::Item);
                            APsTRDProductSegmentDetail.SetRange("Element No.", Salesline."No.");  //Item  No.
                            if not APsTRDProductSegmentDetail.IsEmpty() then
                                exit(true);
                        end;
                end;
        end;
    end;
    //AFC_CS_005
}