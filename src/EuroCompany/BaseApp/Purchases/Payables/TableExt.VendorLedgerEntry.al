namespace EuroCompany.BaseApp.Purchases.Payables;
using Microsoft.Purchases.Payables;
using EuroCompany.BaseApp;

tableextension 80038 "Vendor Ledger Entry" extends "Vendor Ledger Entry"
{
    fields
    {
        field(50000; "ecRef. Date For Calc. Due Date"; Date)
        {
            Caption = 'Ref. Date For Calc. Due Date';
            DataClassification = CustomerContent;
        }
        // field(50005; "ecNo. Invoice Cust. Decl."; Code[20])
        // {
        //     Caption = 'No. invoice customer declaration';
        //     DataClassification = CustomerContent;
        // }
        field(50001; "ecApplies-to ID Customs Agency"; Code[50])
        {
            Caption = 'Applies-to ID Customs Agency';
            DataClassification = CustomerContent;
            Description = 'GAP CS_AFC_013 ';
        }
        field(50016; "ecNotes payment suspension"; Text[250])
        {
            Caption = 'Notes payment suspension';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_019';

            trigger OnValidate()
            var
                eventSub: Codeunit "ecStd Events Subscription";
            begin
                eventSub.Notespaymentsuspension(Rec);
            end;
        }
    }

    procedure UnlinkCustomsEntries(CustomsID: Code[50])
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Count: Integer;
        Message1: Label '%1 movements disconnected from customs code %2';
        Message2: Label 'No movement found for customs code %1';
    begin
        // Applica il filtro ai record con lo stesso "Applicato a ID Dogana"
        VendorLedgerEntry.SetRange("ecApplies-to ID Customs Agency", CustomsID);

        if VendorLedgerEntry.FindSet() then begin
            Count := 0;
            repeat
                VendorLedgerEntry.Validate("ecApplies-to ID Customs Agency", '');
                VendorLedgerEntry.Modify();
                Count += 1;
            until VendorLedgerEntry.Next() = 0;

            Message(Message1, Count, CustomsID);
        end else
            Message(Message2, CustomsID);
    end;
}