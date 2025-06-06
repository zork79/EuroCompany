namespace EuroCompany.BaseApp.AWPExtension.Sales;
using EuroCompany.BaseApp.Sales.AdvancedTrade;

pageextension 80095 "awpSales Orders Check" extends "AltAWPSales Orders Check"
{
    layout
    {
        modify("Shipment Date")
        {
            StyleExpr = ecShipmentDateStyle;
        }
        addafter(GrpFilters_Salesperson)
        {
            group(GrpFilters_EC_Custom)
            {
                ShowCaption = false;

                field(fSalesManagerFilter; CustomFiltersArray[1])
                {
                    ApplicationArea = All;
                    Caption = 'Sales Manager';
                    Description = 'CS_VEN_031';
                    TableRelation = "ecSales Manager".Code;

                    trigger OnValidate()
                    begin
                        CustomFiltersArray[1] := UpperCase(CustomFiltersArray[1]);
                        ApplyFilters();
                    end;
                }

                field(fProductSegment; CustomFiltersArray[2])
                {
                    ApplicationArea = All;
                    Caption = 'Product Segment';
                    Description = 'CS_VEN_032';
                    TableRelation = "APsTRD Product Segment"."No.";

                    trigger OnValidate()
                    begin
                        CustomFiltersArray[2] := UpperCase(CustomFiltersArray[2]);
                        ApplyFilters();
                    end;
                }
            }
        }

        addafter("Sell-to Customer Name")
        {
            field("ecProduct Segment No."; Rec."ecProduct Segment No.")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_032';
                Editable = false;
            }
            field("ecProduct Segment Description"; Rec."ecProduct Segment Description")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_032';
                DrillDown = false;
                Editable = false;
                Visible = false;
            }
        }

        addafter("Salesperson Code")
        {
            field("ecSales Manager Code"; Rec."ecSales Manager Code")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_031';
                Editable = false;
            }
            field("ecSales Manager Name"; Rec."ecSales Manager Name")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_031';
                DrillDown = false;
                Editable = false;
                Visible = false;
            }
        }

        addlast(General)
        {
            field("ecConsumer Unit of Measure"; Rec."ecConsumer Unit of Measure")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_014';
                Editable = false;
            }
            field("ecQty. per Consumer UM"; Rec."ecQty. per Consumer UM")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_014';
                Editable = false;
                HideValue = not ecIsItemLine;
                Visible = false;
            }
            field("ecQuantity (Consumer UM)"; Rec."ecQuantity (Consumer UM)")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_014';
                Editable = false;
                HideValue = not ecIsItemLine;
            }
            field("ecUnit Price (Consumer UM)"; Rec."ecUnit Price (Consumer UM)")
            {
                ApplicationArea = All;
                Description = 'CS_VEN_014';
                Editable = false;
                HideValue = not ecIsItemLine;
            }
        }


    }

    var
        ecShipmentDateStyle: Text;
        ecIsItemLine: Boolean;

    trigger OnAfterGetRecord()
    begin
        //CS_VEN_014-VI-s
        ecIsItemLine := (Rec.Type = Rec.Type::Item);
        //CS_VEN_014-VI-e

        ecShipmentDateStyle := 'Standard';
        if (Rec."Shipment Date" < Today) then ecShipmentDateStyle := 'Unfavorable';
    end;
}
