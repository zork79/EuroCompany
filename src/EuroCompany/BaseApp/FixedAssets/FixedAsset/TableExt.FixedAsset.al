namespace EuroCompany.BaseApp.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.Depreciation;

tableextension 80093 "Fixed Asset" extends "Fixed Asset"
{
    fields
    {
        field(50000; "ecUsed Asset"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Used Asset';

            trigger OnValidate()
            var
                FADepreBook: Record "FA Depreciation Book";
                DeprTableHeader: Record "Depreciation Table Header";
                DeprTableDoesNotExistErr: Label 'The depreciation table does not correspond to that assigned for used goods!';
            begin
                if (Rec."ecUsed Asset" <> xRec."ecUsed Asset") and (Rec."ecUsed Asset") then begin
                    FADepreBook.Reset();
                    FADepreBook.SetRange("FA No.", Rec."No.");
                    FADepreBook.SetFilter("Depreciation Table Code", '<>%1', '');
                    if FADepreBook.FindFirst() then
                        if DeprTableHeader.Get(FADepreBook."Depreciation Table Code") then
                            if not DeprTableHeader."ecUsed Asset" then
                                Error(DeprTableDoesNotExistErr);
                end;
            end;
        }
        field(50001; "ecComponent Main Description"; Text[100])
        {
            Caption = 'Component Main Description';
            FieldClass = FlowField;
            CalcFormula = lookup("Fixed Asset".Description where("No." = field("Component of Main Asset")));
            Editable = false;
        }
        modify("Component of Main Asset")
        {
            trigger OnAfterValidate()
            begin
                Rec.CalcFields("ecComponent Main Description")
            end;
        }
    }
}