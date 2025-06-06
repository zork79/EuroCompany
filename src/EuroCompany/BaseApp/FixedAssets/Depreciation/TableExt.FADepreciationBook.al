namespace EuroCompany.BaseApp.FixedAssets.Depreciation;
using Microsoft.FixedAssets.Depreciation;
using Microsoft.FixedAssets.FixedAsset;

tableextension 80084 "FA Depreciation Book" extends "FA Depreciation Book"
{
    fields
    {
        field(50000; "ecUsed Asset"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Used Asset';
        }
        modify("FA Posting Group")
        {
            trigger OnAfterValidate()
            var
                FAPostingGroup: Record "FA Posting Group";
            begin
                if "FA Posting Group" <> '' then begin
                    if FAPostingGroup.Get("FA Posting Group") then begin
                        Rec.Validate("Depreciation Method", Rec."Depreciation Method"::"User-Defined");
                        Rec.Validate("Depreciation Table Code", FAPostingGroup."ecDepreciation Table Code");
                    end;
                end else begin
                    Rec.Validate("Depreciation Method", 0);
                    Rec.Validate("Depreciation Table Code", '');
                end;
            end;
        }
        modify("Depreciation Table Code")
        {
            trigger OnAfterValidate()
            var
                DeprTableHeader: Record "Depreciation Table Header";
                FixedAsset: Record "Fixed Asset";
            begin
                if DeprTableHeader.Get(Rec."Depreciation Table Code") then begin
                    Rec.Validate("ecUsed Asset", DeprTableHeader."ecUsed Asset");

                    if FixedAsset.Get(Rec."FA No.") then begin
                        FixedAsset."ecUsed Asset" := DeprTableHeader."ecUsed Asset";
                        FixedAsset.Modify(true);
                    end;
                end;
            end;
        }
    }
}