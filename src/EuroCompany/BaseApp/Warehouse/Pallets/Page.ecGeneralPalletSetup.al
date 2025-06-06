namespace EuroCompany.BaseApp.Warehouse.Pallets;

page 50071 "ecGeneral Pallet Setup"
{
    Caption = 'General Pallet Setup';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ecGeneral Pallet Setup";

    layout
    {
        area(Content)
        {
            repeater(RPTR)
            {
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Document; Rec.Document)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        PalletsMgt.SetAllowAdjmtInShipReceiptEditability(Rec, AllowAdjmtInShipReceiptEditability);
                    end;
                }
                field("Source Document Type"; Rec."Source Document Type")
                {
                    ApplicationArea = All;
                }
                field("BC Reason Code"; Rec."BC Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Pallet Grouping Code"; Rec."Pallet Grouping Code")
                {
                    ApplicationArea = All;
                }
                field("Pallet Movement Reason"; Rec."Pallet Movement Reason")
                {
                    ApplicationArea = All;
                }
                field("Allow Adjmt. In Ship/Receipt"; Rec."Allow Adjmt. In Ship/Receipt")
                {
                    ApplicationArea = All;
                    Editable = AllowAdjmtInShipReceiptEditability;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        PalletsMgt.SetAllowAdjmtInShipReceiptEditability(Rec, AllowAdjmtInShipReceiptEditability);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        PalletsMgt.SetAllowAdjmtInShipReceiptEditability(Rec, AllowAdjmtInShipReceiptEditability);
    end;

    var
        PalletsMgt: Codeunit "ecPallets Management";
        AllowAdjmtInShipReceiptEditability: Boolean;
}