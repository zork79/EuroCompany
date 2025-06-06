namespace EuroCompany.BaseApp.APsExtension;
using EuroCompany.BaseApp.Inventory.Item;
using Microsoft.Inventory.Item;
using EuroCompany.BaseApp.Sales.AdvancedTrade;
using Microsoft.Inventory.Item.Catalog;

tableextension 80107 "APsTRD Contract Header" extends "APsTRD Contract Header"
{
    fields
    {
        field(50040; "ecSales Manager Code"; Code[20])
        {
            Caption = 'Sales Manager Code';
            DataClassification = CustomerContent;
            Description = 'GAP_443_TRADE';
            TableRelation = "ecSales Manager".Code;

            trigger OnValidate()
            var
                lSalesManager: Record "ecSales Manager";
            begin
                if ("ecSales Manager Code" <> '') then begin
                    lSalesManager.Get("ecSales Manager Code");
                    lSalesManager.TestField(Blocked, false);
                end;

                CalcFields("ecSales Manager Name");
            end;

        }
        field(50041; "ecSales Manager Name"; Text[100])
        {
            CalcFormula = lookup("ecSales Manager".Name where(Code = field("ecSales Manager Code")));
            Caption = 'Sales Manager Name';
            Description = 'GAP_443_TRADE';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}