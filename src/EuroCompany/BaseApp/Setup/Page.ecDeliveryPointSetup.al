namespace EuroCompany.BaseApp.Setup;
using EuroCompany.BaseApp.Sales.AdvancedTrade;
using System.Reflection;

page 50005 "ecDelivery Point Setup"
{
    ApplicationArea = All;
    Caption = 'Delivery point setup';
    PageType = List;
    SourceTable = "ecDelivery Point Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Editable = false;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    Editable = false;
                }
                field("Product Segment No."; Rec."Product Segment No.")
                {

                    trigger OnLookup(var myText: Text): Boolean
                    begin
                        PerformProdSegmentsLookup();
                    end;

                    trigger OnValidate()
                    begin
                        if (Rec."Product Segment No." <> xRec."Product Segment No.") and (Rec."Product Segment No." = '') then begin
                            Rec.Validate("Product Segment Description", '');
                        end;
                    end;
                }
                field("Product Segment Description"; Rec."Product Segment Description")
                {
                    Editable = false;
                }
                field("Data Type"; Rec."Data Type")
                {
                }
                field("ID Table"; Rec."ID Table")
                {
                    Editable = Rec."Text Reference" = '';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupIDTable();
                    end;

                    trigger OnValidate()
                    begin
                        if (Rec."ID Table" <> xRec."ID Table") and (Rec."ID Table" = 0) then begin
                            Rec.Validate("Table Name", '');
                            Rec.Validate("Field Name", '');
                            Rec.Validate("Field Number", 0);
                        end;
                    end;
                }
                field("Table Name"; Rec."Table Name")
                {
                    Editable = false;
                }
                field("Field Number"; Rec."Field Number")
                {
                    Editable = Rec."Text Reference" = '';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        PerformFieldNameLookup();
                    end;
                }
                field("Field Name"; Rec."Field Name")
                {
                    Editable = false;
                }
                field("Text Reference"; Rec."Text Reference")
                {
                    Editable = Rec."ID Table" = 0;
                }
            }
        }
    }

    local procedure LookupIDTable()
    var
        AllObjTable: Record AllObjWithCaption;
        AllObjPage: Page "All Objects with Caption";
    begin
        AllObjTable.Reset();
        AllObjTable.SetRange("Object Type", AllObjTable."Object Type"::Table);
        AllObjTable.SetFilter("Object ID", '%1|%2|%3', 18, 222, 50019);

        AllObjPage.SetTableView(AllObjTable);
        AllObjPage.LookupMode(true);

        if AllObjPage.RunModal() = Action::LookupOK then begin
            AllObjPage.GetRecord(AllObjTable);
            Rec.Validate("ID Table", AllObjTable."Object ID");
            Rec."Table Name" := AllObjTable."Object Name";
        end;
    end;

    local procedure PerformFieldNameLookup()
    var
        RecField: Record Field;
        FieldSelecton: Codeunit "Field Selection";
    begin
        if Rec."ID Table" = 0 then exit;

        RecField.Reset();
        RecField.SetRange(TableNo, Rec."ID Table");
        if FieldSelecton.Open(RecField) then begin
            Rec."Field Name" := RecField."Field Caption";
            Rec."Field Number" := RecField."No.";
        end;
    end;

    local procedure PerformProdSegmentsLookup()
    var
        CustProdSegments: Record "ecCustomer Product Segments";
        CustProdSegPage: Page "ecCustomer Product Segments";
    begin
        if Rec."Customer No." <> '' then begin
            CustProdSegments.Reset();
            CustProdSegments.SetRange("Customer No.", Rec."Customer No.");
            CustProdSegments.SetRange("Starting Date", 0D, Today);
            CustProdSegments.SetFilter("Ending Date", '%1|%2..', 0D, Today);

            CustProdSegPage.SetTableView(CustProdSegments);
            CustProdSegPage.LookupMode(true);

            if CustProdSegPage.RunModal() = Action::LookupOK then begin
                CustProdSegPage.GetRecord(CustProdSegments);
                Rec."Product Segment No." := CustProdSegments."Product Segment No.";
                Rec."Product Segment Description" := CustProdSegments."Product Segment Description";
            end;
        end;
    end;
}
