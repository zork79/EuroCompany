namespace EuroCompany.BaseApp.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.Depreciation;

pageextension 80187 "Fixed Asset Card" extends "Fixed Asset Card"
{
    layout
    {
        addlast(content)
        {
            group(ecCustomAttributes)
            {
                Caption = 'Custom Attributes';

                field("ecUsed Asset"; Rec."ecUsed Asset")
                {
                    ApplicationArea = All;
                }
            }
        }
        addafter("Component of Main Asset")
        {
            field("ecComponent Main Description"; Rec."ecComponent Main Description")
            {
                ApplicationArea = All;
            }
        }
        modify("FA Subclass Code")
        {
            trigger OnAfterValidate()
            var
                FADepreBook: Record "FA Depreciation Book";
                DeprTableHeader: Record "Depreciation Table Header";
            begin
                if Rec."ecUsed Asset" then begin
                    FADepreBook.Reset();
                    FADepreBook.SetRange("FA No.", Rec."No.");
                    FADepreBook.SetFilter("Depreciation Table Code", '<>%1', '');
                    if FADepreBook.FindFirst() then
                        if DeprTableHeader.Get(FADepreBook."Depreciation Table Code") then
                            if not DeprTableHeader."ecUsed Asset" then
                                FADepreBook.Delete();
                end;
            end;
        }
    }
}