namespace EuroCompany.BaseApp.Purchases.Document;

using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;

page 50036 "ecPurch.Order Edit Log. Info "
{
    ApplicationArea = All;
    Caption = 'Purch. Order - Edit logistic info';
    DelayedInsert = true;
    DeleteAllowed = false;
    Description = 'CS_ACQ_013';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Purchase Line";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(PurchLineInformation)
            {
                Caption = 'Line information';
                Editable = false;

                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                }
                field(VendorName; Vendor.Name)
                {
                    Caption = 'Buy-from Vendor Name';
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("No."; Rec."No.")
                {
                }
                field("Variant Code"; Rec."Variant Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Planned Receipt Date"; Rec."Planned Receipt Date")
                {
                }
            }
            group(LogisticInfo)
            {
                Caption = 'Logistic Informations';

                field("ecPackaging Type"; Rec."ecPackaging Type")
                {
                }
                field("ecContainer Type"; Rec."ecContainer Type")
                {
                }
                field("ecContainer No."; Rec."ecContainer No.")
                {
                }
                field("ecExpected Shipping Date"; Rec."ecExpected Shipping Date")
                {
                }
                field("ecDelay Reason Code"; Rec."ecDelay Reason Code")
                {
                }
                field("ecTransport Status"; Rec."ecTransport Status")
                {
                }
                field("ecShipping Documentation"; Rec."ecShip. Documentation Status")
                {
                }
                field("ecShiping Doc. Notes"; Rec."ecShiping Doc. Notes")
                {
                }
            }
        }
    }

    var
        Vendor: Record Vendor;

    trigger OnAfterGetCurrRecord()
    begin
        if not Vendor.Get(Rec."Buy-from Vendor No.") then Clear(Vendor);
    end;
}
