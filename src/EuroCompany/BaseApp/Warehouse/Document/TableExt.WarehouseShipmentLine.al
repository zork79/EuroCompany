namespace EuroCompany.BaseApp.Warehouse.Document;

using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Warehouse.Document;

tableextension 80082 "Warehouse Shipment Line" extends "Warehouse Shipment Line"
{
    fields
    {
        modify("AltAWPParcel Units")
        {
            Caption = 'No. of logistic units';
            Description = 'CS_LOG_001';
        }
        field(50000; "ecConsumer Unit of Measure"; Code[10])
        {
            Caption = 'Consumer Unit of Measure';
            DataClassification = CustomerContent;
            Description = 'CS_VEN_014';
            Editable = false;
            TableRelation =
            if ("AltAWPElement Type" = const(Item), "Item No." = filter(<> '')) "Item Unit of Measure".Code where("Item No." = field("Item No."))
            else
            if ("AltAWPElement Type" = const(Resource), "AltAWPElement No." = filter(<> '')) "Resource Unit of Measure".Code where("Resource No." = field("AltAWPElement No."))
            else
            if ("AltAWPElement Type" = filter("Charge (Item)" | "Fixed Asset" | "G/L Account")) "Unit of Measure";

            trigger OnValidate()
            var
                lawpLogisticsFunctions: Codeunit "AltAWPLogistics Functions";
            begin
                //CS_VEN_014-VI-s
                if ("ecConsumer Unit of Measure" <> '') then begin
                    TestField("AltAWPElement Type", "AltAWPElement Type"::Item);
                end;

                "ecQty. per Consumer UM" := 1;
                if ("ecConsumer Unit of Measure" <> "Unit of Measure Code") and
                   ("ecConsumer Unit of Measure" <> '')
                then begin
                    "ecQty. per Consumer UM" := lawpLogisticsFunctions.CalcItemUMConversionFactor("Item No.",
                                                                                                  "Unit of Measure Code",
                                                                                                  "ecConsumer Unit of Measure");
                end;
                Validate("ecQty. per Consumer UM");
                //CS_VEN_014-VI-e
            end;

        }
        field(50001; "ecQty. per Consumer UM"; Decimal)
        {
            Caption = 'Qty. per Consumer UM';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'CS_VEN_014';
            Editable = false;

            trigger OnValidate()
            begin
                ecUpdateConsumerUMQuantity();
            end;
        }
        field(50002; "ecQuantity (Consumer UM)"; Decimal)
        {
            Caption = 'Quantity (Consumer UM)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'CS_VEN_014';
            Editable = false;

            trigger OnValidate()
            begin
                //CS_VEN_014-VI-s
                if ("ecQuantity (Consumer UM)" <> 0) then begin
                    TestField("AltAWPElement Type", "AltAWPElement Type"::Item);
                    TestField("ecConsumer Unit of Measure");
                end;

                ecCheckQuantity(FieldNo("ecQuantity (Consumer UM)"));
                ecUpdateQuantityByConsumerUM();
                //CS_VEN_014-VI-e
            end;
        }
        field(50010; "ecKit/Exhibitor Item"; Boolean)
        {
            CalcFormula = lookup(Item."ecKit/Product Exhibitor" where("No." = field("No.")));
            Caption = 'Kit/Exhibitor Item';
            Description = 'CS_PRO_009';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50015; "ecKit/Exhibitor BOM Entry No."; Integer)
        {
            Caption = 'Kit/Exhibitor BOM Entry No.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_009';
            Editable = false;
        }
    }

    internal procedure ecUpdateConsumerUMQuantity()
    var
        lawpLogisticsFunctions: Codeunit "AltAWPLogistics Functions";
    begin
        //CS_VEN_014-VI-s
        "ecQuantity (Consumer UM)" := 0;
        if ("ecConsumer Unit of Measure" <> '') and
           ("AltAWPElement Type" = "AltAWPElement Type"::Item)
        then begin
            ecCheckQuantity(FieldNo(Quantity));

            "ecQuantity (Consumer UM)" := lawpLogisticsFunctions.ConvertItemQtyInUM("Item No.",
                                                                                    Quantity,
                                                                                    "Unit of Measure Code",
                                                                                    "ecConsumer Unit of Measure");

            ecCheckQuantity(FieldNo("ecQuantity (Consumer UM)"));
        end;
        //CS_VEN_014-VI-e
    end;

    internal procedure ecUpdateQuantityByConsumerUM()
    var
        lawpLogisticsFunctions: Codeunit "AltAWPLogistics Functions";
    begin
        //CS_VEN_014-VI-s
        if ("AltAWPElement Type" = "AltAWPElement Type"::Item) then begin
            Validate(Quantity, lawpLogisticsFunctions.ConvertItemQtyInUM("Item No.",
                                                                         "ecQuantity (Consumer UM)",
                                                                         "ecConsumer Unit of Measure",
                                                                         "Unit of Measure Code"));
        end;
        //CS_VEN_014-VI-e
    end;

    local procedure ecCheckQuantity(pCalledByFieldNo: Integer)
    var
        lItem: Record Item;
        lQuantityValue: Decimal;
        lUMCode: Code[10];
        lUMCode2: Code[10];
        lFieldName: Text;

        lInvalidConsumerUnitQtyErr: Label 'The value of field "%1" must be a multiple of %2 when the unit of measure is "%3"';
        lInvalidPackageUnitQtyErr: Label 'The value of field "%1" must be an integer when the unit of measure is "%2"';
    begin
        //CS_VEN_014-VI-s
        if ("AltAWPElement Type" = "AltAWPElement Type"::Item) then begin
            lFieldName := FieldCaption(Quantity);
            lQuantityValue := Quantity;
            lUMCode := "Unit of Measure Code";
            lUMCode2 := "ecConsumer Unit of Measure";

            if (pCalledByFieldNo = FieldNo("ecQuantity (Consumer UM)")) then begin
                lFieldName := FieldCaption("ecQuantity (Consumer UM)");
                lQuantityValue := "ecQuantity (Consumer UM)";
                lUMCode := "ecConsumer Unit of Measure";
                lUMCode2 := "Unit of Measure Code";
            end;

            if (lQuantityValue <> 0) then begin
                lItem.Get("Item No.");
                if (lItem."ecPackage Unit Of Measure" <> '') and
                   (lUMCode = lItem."ecPackage Unit Of Measure")
                then begin
                    if (Round(lQuantityValue, 1) <> lQuantityValue) then begin
                        Error(lInvalidPackageUnitQtyErr, lFieldName, lUMCode);
                    end;
                end;

                if (lItem."ecConsumer Unit of Measure" <> '') and
                   (lUMCode = lItem."ecConsumer Unit of Measure") and
                   (lUMCode2 = lItem."ecPackage Unit Of Measure")
                then begin
                    if (lItem."ecNo. Consumer Units per Pkg." <> 0) then begin
                        if (lQuantityValue mod lItem."ecNo. Consumer Units per Pkg." <> 0) then begin
                            Error(lInvalidConsumerUnitQtyErr, lFieldName, lItem."ecNo. Consumer Units per Pkg.", lUMCode);
                        end;
                    end;
                end;
            end;
        end;
        //CS_VEN_014-VI-e
    end;
}
