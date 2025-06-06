namespace EuroCompany.BaseApp.AWPExtension.LogisticUnits;
using EuroCompany.BaseApp.Inventory.Tracking;
using Microsoft.Manufacturing.Document;
using Microsoft.Warehouse.Document;
using Microsoft.Inventory.Tracking;

tableextension 80053 "awpLogistic Unit Detail" extends "AltAWPLogistic Unit Detail"
{
    fields
    {
        modify("Expiration Date")
        {
            trigger OnAfterValidate()
            var
                lLotNoInformation: Record "Lot No. Information";
                lTrackingFunctions: Codeunit "ecTracking Functions";
            begin
                //CS_PRO_008-s
                //CS_PRO_041_BIS-s
                if lTrackingFunctions.IsSubcontractWhseReceipt(Rec) then begin
                    if (Rec."Expiration Date" <> xRec."Expiration Date") then lTrackingFunctions.CheckProdOrdLotForSubcontPurchOrd(Rec);
                    //CS_PRO_041_BIS-e
                end else begin
                    if (CurrFieldNo = FieldNo("Expiration Date")) and ("Lot No." <> '') and lLotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") and
                       (lLotNoInformation."ecLot No. Information Status" <> lLotNoInformation."ecLot No. Information Status"::Released)
                    then begin
                        lLotNoInformation."ecExpiration Date" := Rec."Expiration Date";
                        lLotNoInformation.Modify(true);
                    end;
                end;
                //CS_PRO_008-e
            end;
        }
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            var
                lTrackingFunctions: Codeunit "ecTracking Functions";
            begin
                //CS_PRO_041_BIS-s
                if lTrackingFunctions.IsSubcontractWhseReceipt(Rec) then begin
                    if (Rec."Lot No." <> xRec."Lot No.") then lTrackingFunctions.CheckProdOrdLotForSubcontPurchOrd(Rec);
                end;
                //CS_PRO_041_BIS-e
            end;
        }
        field(50000; "ecNo. Of Parcels"; Integer)
        {
            Caption = 'No. Of Parcels';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            InitValue = 1;
            MinValue = 1;

            trigger OnValidate()
            begin
                if ("ecTotal Weight" <> 0) then "ecUnit Weight" := "ecTotal Weight" / "ecNo. Of Parcels";
            end;
        }
        field(50002; "ecUnit Weight"; Decimal)
        {
            Caption = 'Unit Weight';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            MinValue = 0;
        }
        field(50005; "ecTotal Weight"; Decimal)
        {
            Caption = 'Total Weight';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            MinValue = 0;

            trigger OnValidate()
            begin
                if ("ecNo. Of Parcels" <> 0) then "ecUnit Weight" := "ecTotal Weight" / "ecNo. Of Parcels";
            end;
        }
    }
}
