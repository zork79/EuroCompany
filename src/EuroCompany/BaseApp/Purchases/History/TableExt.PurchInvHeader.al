namespace EuroCompany.BaseApp.Purchases.History;
using EuroCompany.BaseApp.Purchases.Vendor;
using Microsoft.Purchases.History;
using EuroCompany.BaseApp;
tableextension 80040 "Purch. Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(50000; "ecRef. Date For Calc. Due Date"; Date)
        {
            Caption = 'Ref. Date For Calc. Due Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50015; "ecVendor Classification"; Code[20])
        {
            Caption = 'Vendor classification';
            DataClassification = CustomerContent;
            Description = 'CS_ACQ_013';
            Editable = false;
            TableRelation = "ecVendor Classification";
        }
        // field(50020; "ecNo. Invoice Cust. Decl."; Code[20])
        // {
        //     Caption = 'No. invoice customer declaration';
        //     DataClassification = CustomerContent;
        //     Editable = false;
        // }
        field(50016; "ecNotes payment suspension"; Text[250])
        {
            Caption = 'Notes payment suspension';
            DataClassification = CustomerContent;
            Description = 'CS_AFC_019';

            // trigger OnValidate()
            // var
            //     EventsSubscription: Codeunit "ecStd Events Subscription";
            // begin
            //     EventsSubscription.Notespaymentsuspension(Rec);
            // end;
        }
    }
}