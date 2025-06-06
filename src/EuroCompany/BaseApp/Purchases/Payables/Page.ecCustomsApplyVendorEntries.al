namespace EuroCompany.BaseApp.Purchases.Payables;

using Microsoft.Purchases.Payables;
using Microsoft.Purchases.Vendor;
using Microsoft.Finance.Currency;
using Microsoft.Purchases.Posting;
using Microsoft.Purchases.Setup;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Purchases.Document;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.CRM.Outlook;
using Microsoft.Finance.Dimension;

page 50076 "ecCustoms Apply Vendor Entries"
{
    Caption = 'Apply Vendor Entries';
    ApplicationArea = All;
    DataCaptionFields = "Vendor No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Worksheet;
    UsageCategory = Documents;
    SourceTable = "Vendor Ledger Entry";


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(PostingDate; TargetPDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posting Date';
                    Editable = false;
                }
                field(DocumentType; TargetDocumentType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Document Type';
                    Editable = false;
                }
                field(DocumentNo; TargetDocumentNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Document No.';
                    Editable = false;
                }
                field(ApplyingVendorName; TargetVendorName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor Name';
                    Editable = false;
                }
                field(CurrencyCode; TargetCurrency)
                {
                    ApplicationArea = Suite;
                    Caption = 'Currency Code';
                    Editable = false;
                }
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field(AppliesToID; Rec."Applies-to ID")
                {
                    ApplicationArea = All;
                    Visible = AppliesToIDVisible;

                    trigger OnValidate()
                    begin
                        if (CalcType = CalcType::"Gen. Jnl. Line") and (ApplnType = ApplnType::"Applies-to Doc. No.") then
                            Error(CannotSetAppliesToIDErr);

                        SetVendApplId(true);
                        if Rec."Applies-to ID" <> '' then
                            UpdateCustomAppliesToIDForGenJournal(Rec."Applies-to ID");

                        CurrPage.Update(false);
                    end;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Application)
            {
                Caption = 'Application';
                Image = Apply;
                action(ActionSetAppliesToID)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = AppliesToIDVisible;
                    Caption = 'Set Applies-to ID';
                    Image = SelectLineToApply;

                    trigger OnAction()
                    var
                        VendorLedgerEntry: Record "Vendor Ledger Entry";
                        SourceUpdate: Boolean;
                    begin
                        Rec."Applies-to ID" := Format(TargetID);
                        Rec.Modify();
                        if not SourceUpdate then begin
                            VendorLedgerEntry.Reset();
                            VendorLedgerEntry.SetRange("Entry No.", TargetID);
                            if VendorLedgerEntry.FindFirst() then begin
                                VendorLedgerEntry."Applies-to ID" := Format(TargetID);
                                VendorLedgerEntry.Modify();
                                SourceUpdate := true;
                            end;
                        end;
                        Rec.SetFilter("Document Type", '%1|%2', Rec."Document Type"::Invoice, Rec."Document Type"::" ");
                        Rec.SetFilter("ecApplies-to ID Customs Agency", '%1', '');
                        Rec.SetFilter("Applies-to ID", '%1|%2', Rec."Applies-to ID", '');
                        Rec.SetFilter("Entry No.", '<>%1', TargetID);
                    end;
                }
                action(ActionPostApplication)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = CalledFromEntry;
                    Caption = 'Post Application';
                    Ellipsis = true;
                    Image = PostApplication;

                    trigger OnAction()
                    var
                        VendorLedgerEntry: Record "Vendor Ledger Entry";
                        SourceUpdate: Boolean;
                        ConfirmLbl: label 'Are you sure you want to link movements ?';
                    begin

                        // Scansiona i record selezionati nella pagina
                        if Confirm(ConfirmLbl) then
                            if Rec.FindSet() then begin
                                repeat
                                    if Rec."Applies-to ID" <> '' then begin
                                        Rec."ecApplies-to ID Customs Agency" := Format(Rec."Applies-to ID");
                                        Rec.Modify();
                                    end;
                                until Rec.Next() = 0;

                                if not SourceUpdate then begin
                                    VendorLedgerEntry.Reset();
                                    VendorLedgerEntry.SetRange("Entry No.", TargetID);
                                    if VendorLedgerEntry.FindFirst() then begin
                                        VendorLedgerEntry."ecApplies-to ID Customs Agency" := Format(TargetID);
                                        VendorLedgerEntry.Modify();
                                        SourceUpdate := true;
                                    end;
                                end;
                            end;
                        Rec.Reset();
                        Rec.SetFilter("Document Type", '%1|%2', Rec."Document Type"::Invoice, Rec."Document Type"::" ");
                        CurrPage.Close();
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(ActionSetAppliesToID_Promoted; ActionSetAppliesToID)
                {
                }
                actionref(ActionPostApplication_Promoted; ActionPostApplication)
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if ApplnType = ApplnType::"Applies-to Doc. No." then
            CalcApplnAmount();
        // HasDocumentAttachment := Rec.HasPostedDocAttachment();
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.SetStyle();
    end;

    trigger OnInit()
    begin
        AppliesToIDVisible := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CODEUNIT.Run(CODEUNIT::"Vend. Entry-Edit", Rec);
        if Rec."Applies-to ID" <> xRec."Applies-to ID" then
            CalcApplnAmount();
        exit(false);
    end;

    local procedure JournalHasDocumentNo(AppliesToIDCode: Code[50]): Boolean
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        GenJournalLine.SetRange("Document No.", CopyStr(AppliesToIDCode, 1, MaxStrLen(GenJournalLine."Document No.")));
        exit(not GenJournalLine.IsEmpty());
    end;

    trigger OnOpenPage()
    var
    // OfficeMgt: Codeunit "Office Management";
    begin
        Rec.SetFilter("Document Type", '%1|%2', Rec."Document Type"::Invoice, Rec."Document Type"::" ");
        Rec.SetFilter("Entry No.", '<>%1', Rec."Entry No.");
        Rec.SetFilter("ecApplies-to ID Customs Agency", '%1', '');
        Rec.SetFilter("Applies-to ID", '%1', '');


        if CalcType = CalcType::Direct then begin
            Vend.Get(Rec."Vendor No.");
            ApplnCurrencyCode := Vend."Currency Code";
            FindApplyingEntry();
        end;

        ActivateFields();
        PurchSetup.Get();

        GLSetup.Get();

        if CalcType = CalcType::"Gen. Jnl. Line" then
            CalcApplnAmount();
        // PostingDone := false;
        // IsOfficeAddin := OfficeMgt.IsAvailable();
    end;


    var
        CurrExchRate: Record "Currency Exchange Rate";
        TempApplyingVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        AppliedVendLedgEntry: Record "Vendor Ledger Entry";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        PurchHeader: Record "Purchase Header";
        Vend: Record Vendor;
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        TotalPurchLine: Record "Purchase Line";
        TotalPurchLineLCY: Record "Purchase Line";
        VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        PurchPost: Codeunit "Purch.-Post";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        TargetDocumentType: Enum "Gen. Journal Document Type";
        ApplnType: Enum "Vendor Apply-to Type";
        CalcType: Enum "Vendor Apply Calculation Type";
        TargetDocumentNo: Code[20];
        TargetCurrency: Code[10];
        TargetID: Integer;
        TargetPDate: Date;
        TargetVendorName: Text[100];
        GenJnlLineApply: Boolean;
        StyleTxt: Text;
        AppliesToID: Code[50];
        CustomAppliesToID: Code[50];
        ValidExchRate: Boolean;
        CannotSetAppliesToIDErr: Label 'You cannot set Applies-to ID while selecting Applies-to Doc. No.';
        TimesSetCustomAppliesToID: Integer;
        CalledFromEntry: Boolean;
        EarlierPostingDateErr: Label 'You cannot apply and post an entry to an entry with an earlier posting date.\\Instead, post the document of type %1 with the number %2 and then apply it to the document of type %3 with the number %4.', Comment = '%1 - document type, %2 - document number,%3 - document type,%4 - document number';
        // PostingDone: Boolean;
        AppliesToIDVisible: Boolean;
        // IsOfficeAddin: Boolean;
        // HasDocumentAttachment: Boolean;
        ApplnDate: Date;
        ApplnRoundingPrecision: Decimal;
        // ApplnRounding: Decimal;
        AmountRoundingPrecision: Decimal;
        VATAmount: Decimal;
        VATAmountText: Text[30];
        AppliedAmount: Decimal;
        ApplyingAmount: Decimal;
        PmtDiscAmount: Decimal;
        VendEntryApplID: Code[50];
        ApplnCurrencyCode: Code[10];
        DifferentCurrenciesInAppln: Boolean;

    procedure AssigneVariables(parVendrEntry: Record "Vendor Ledger Entry")
    begin
        TargetID := parVendrEntry."Entry No.";
        TargetPDate := parVendrEntry."Posting Date";
        TargetVendorName := parVendrEntry."Vendor Name";
        TargetDocumentType := parVendrEntry."Document Type";
        TargetDocumentNo := parVendrEntry."Document No.";
        TargetCurrency := parVendrEntry."Currency Code";
    end;

    procedure SetGenJnlLine(NewGenJnlLine: Record "Gen. Journal Line"; ApplnTypeSelect: Integer)
    begin
        GenJnlLine := NewGenJnlLine;
        GenJnlLineApply := true;

        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor then
            ApplyingAmount := GenJnlLine.Amount;
        if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor then
            ApplyingAmount := -GenJnlLine.Amount;
        ApplnDate := GenJnlLine."Posting Date";
        ApplnCurrencyCode := GenJnlLine."Currency Code";
        CalcType := CalcType::"Gen. Jnl. Line";

        case ApplnTypeSelect of
            GenJnlLine.FieldNo("Applies-to Doc. No."):
                ApplnType := ApplnType::"Applies-to Doc. No.";
            GenJnlLine.FieldNo("Applies-to ID"):
                ApplnType := ApplnType::"Applies-to ID";
        end;

        SetApplyingVendLedgEntry();
    end;

    internal procedure GetCustomAppliesToID(): Code[50]
    begin
        if TimesSetCustomAppliesToID <> 1 then
            exit('');
        exit(CustomAppliesToID);
    end;

    local procedure UpdateCustomAppliesToIDForGenJournal(NewAppliesToID: Code[50])
    begin
        if (not GenJnlLineApply) or (ApplnType <> ApplnType::"Applies-to ID") then
            exit;
        if JournalHasDocumentNo(NewAppliesToID) then
            exit;
        if (CustomAppliesToID = '') or ((CustomAppliesToID <> '') and (CustomAppliesToID <> NewAppliesToID)) then
            TimesSetCustomAppliesToID += 1;

        CustomAppliesToID := NewAppliesToID;
    end;

    procedure SetPurch(NewPurchHeader: Record "Purchase Header"; var NewVendLedgEntry: Record "Vendor Ledger Entry"; ApplnTypeSelect: Integer)
    begin
        PurchHeader := NewPurchHeader;
        Rec.CopyFilters(NewVendLedgEntry);

        PurchPost.SumPurchLines(
          PurchHeader, 0, TotalPurchLine, TotalPurchLineLCY,
          VATAmount, VATAmountText);

        case PurchHeader."Document Type" of
            PurchHeader."Document Type"::"Return Order",
            PurchHeader."Document Type"::"Credit Memo":
                ApplyingAmount := TotalPurchLine."Amount Including VAT"
            else
                ApplyingAmount := -TotalPurchLine."Amount Including VAT";
        end;

        ApplnDate := PurchHeader."Posting Date";
        ApplnCurrencyCode := PurchHeader."Currency Code";
        CalcType := CalcType::"Purchase Header";

        case ApplnTypeSelect of
            PurchHeader.FieldNo("Applies-to Doc. No."):
                ApplnType := ApplnType::"Applies-to Doc. No.";
            PurchHeader.FieldNo("Applies-to ID"):
                ApplnType := ApplnType::"Applies-to ID";
        end;

        SetApplyingVendLedgEntry();
    end;

    procedure SetVendLedgEntry(NewVendLedgEntry: Record "Vendor Ledger Entry")
    begin
        Rec := NewVendLedgEntry;
    end;

    procedure SetApplyingVendLedgEntry()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if not IsHandled then begin
            case CalcType of
                CalcType::"Purchase Header":
                    SetApplyingVendLedgEntryPurchaseHeader();
                CalcType::"Gen. Jnl. Line":
                    SetApplyingVendLedgEntryGenJnlLine();
                CalcType::Direct:
                    SetApplyingVendLedgEntryDirect();
            end;

            CalcApplnAmount();
        end;
    end;

    local procedure SetApplyingVendLedgEntryPurchaseHeader()
    begin
        TempApplyingVendLedgEntry."Posting Date" := PurchHeader."Posting Date";
        if PurchHeader."Document Type" = PurchHeader."Document Type"::"Return Order" then
            TempApplyingVendLedgEntry."Document Type" := TempApplyingVendLedgEntry."Document Type"::"Credit Memo"
        else
            TempApplyingVendLedgEntry."Document Type" := TempApplyingVendLedgEntry."Document Type"::Invoice;
        TempApplyingVendLedgEntry."Document No." := PurchHeader."No.";
        TempApplyingVendLedgEntry."Vendor No." := PurchHeader."Pay-to Vendor No.";
        TempApplyingVendLedgEntry.Description := PurchHeader."Posting Description";
        TempApplyingVendLedgEntry."Currency Code" := PurchHeader."Currency Code";
        if TempApplyingVendLedgEntry."Document Type" = TempApplyingVendLedgEntry."Document Type"::"Credit Memo" then begin
            TempApplyingVendLedgEntry.Amount := TotalPurchLine."Amount Including VAT";
            TempApplyingVendLedgEntry."Remaining Amount" := TotalPurchLine."Amount Including VAT";
        end else begin
            TempApplyingVendLedgEntry.Amount := -TotalPurchLine."Amount Including VAT";
            TempApplyingVendLedgEntry."Remaining Amount" := -TotalPurchLine."Amount Including VAT";
        end;
        TempApplyingVendLedgEntry."Remit-to Code" := PurchHeader."Remit-to Code";

    end;

    local procedure SetApplyingVendLedgEntryGenJnlLine()
    var
        Vendor: Record Vendor;
    begin
        TempApplyingVendLedgEntry."Posting Date" := GenJnlLine."Posting Date";
        TempApplyingVendLedgEntry."Document Type" := GenJnlLine."Document Type";
        TempApplyingVendLedgEntry."Document No." := GenJnlLine."Document No.";
        if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor then begin
            TempApplyingVendLedgEntry."Vendor No." := GenJnlLine."Bal. Account No.";
            Vendor.Get(TempApplyingVendLedgEntry."Vendor No.");
            TempApplyingVendLedgEntry.Description := Vendor.Name;
        end else begin
            TempApplyingVendLedgEntry."Vendor No." := GenJnlLine."Account No.";
            TempApplyingVendLedgEntry.Description := GenJnlLine.Description;
        end;
        TempApplyingVendLedgEntry."Currency Code" := GenJnlLine."Currency Code";
        TempApplyingVendLedgEntry.Amount := GenJnlLine.Amount;
        TempApplyingVendLedgEntry."Remaining Amount" := GenJnlLine.Amount;
        TempApplyingVendLedgEntry."Remit-to Code" := GenJnlLine."Remit-to Code";
    end;

    local procedure SetApplyingVendLedgEntryDirect()
    begin
        if Rec."Applying Entry" then begin
            if TempApplyingVendLedgEntry."Entry No." <> 0 then
                VendLedgEntry := TempApplyingVendLedgEntry;
            CODEUNIT.Run(CODEUNIT::"Vend. Entry-Edit", Rec);
            if Rec."Applies-to ID" = '' then
                SetVendApplId(false);
            Rec.CalcFields(Amount);
            TempApplyingVendLedgEntry := Rec;
            if VendLedgEntry."Entry No." <> 0 then begin
                Rec := VendLedgEntry;
                Rec."Applying Entry" := false;
                SetVendApplId(false);
            end;
            Rec.SetFilter("Entry No.", '<> %1', TempApplyingVendLedgEntry."Entry No.");
            ApplyingAmount := TempApplyingVendLedgEntry."Remaining Amount";
            ApplnDate := TempApplyingVendLedgEntry."Posting Date";
            ApplnCurrencyCode := TempApplyingVendLedgEntry."Currency Code";
            Rec."Remit-to Code" := TempApplyingVendLedgEntry."Remit-to Code";
        end;
    end;

    procedure SetVendApplId(CurrentRec: Boolean)
    begin
        CurrPage.SetSelectionFilter(VendLedgEntry);
        CheckVendLedgEntry(VendLedgEntry);

        VendLedgEntry.Copy(Rec);
        if CurrentRec then
            VendLedgEntry.SetRecFilter()
        else
            CurrPage.SetSelectionFilter(VendLedgEntry);

        CallVendEntrySetApplIDSetApplId();

        CalcApplnAmount();
    end;

    local procedure CallVendEntrySetApplIDSetApplId()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if GenJnlLineApply then
            VendEntrySetApplID.SetApplId(VendLedgEntry, TempApplyingVendLedgEntry, GenJnlLine."Applies-to ID")
        else
            VendEntrySetApplID.SetApplId(VendLedgEntry, TempApplyingVendLedgEntry, PurchHeader."Applies-to ID");
    end;

    procedure CheckVendLedgEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        RaiseError: Boolean;
    begin
        if VendorLedgerEntry.FindSet() then
            repeat
                if CalcType = CalcType::"Gen. Jnl. Line" then begin
                    RaiseError := TempApplyingVendLedgEntry."Posting Date" < VendorLedgerEntry."Posting Date";
                    if RaiseError then
                        Error(
                            EarlierPostingDateErr, TempApplyingVendLedgEntry."Document Type", TempApplyingVendLedgEntry."Document No.",
                            VendorLedgerEntry."Document Type", VendorLedgerEntry."Document No.");

                end;

                if TempApplyingVendLedgEntry."Entry No." <> 0 then begin
                    GenJnlApply.CheckAgainstApplnCurrency(
                        ApplnCurrencyCode, VendorLedgerEntry."Currency Code", GenJnlLine."Account Type"::Vendor, true);
                end;
            until VendorLedgerEntry.Next() = 0;
    end;

    procedure CalcApplnAmount()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if not IsHandled then begin
            AppliedAmount := 0;
            PmtDiscAmount := 0;
            DifferentCurrenciesInAppln := false;

            case CalcType of
                CalcType::Direct:
                    begin
                        FindAmountRounding();
                        VendEntryApplID := UserId;
                        if VendEntryApplID = '' then
                            VendEntryApplID := '***';

                        VendLedgEntry := TempApplyingVendLedgEntry;

                        AppliedVendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                        AppliedVendLedgEntry.SetRange("Vendor No.", Rec."Vendor No.");
                        AppliedVendLedgEntry.SetRange(Open, true);
                        if AppliesToID = '' then
                            AppliedVendLedgEntry.SetRange("Applies-to ID", VendEntryApplID)
                        else
                            AppliedVendLedgEntry.SetRange("Applies-to ID", AppliesToID);

                        if TempApplyingVendLedgEntry."Entry No." <> 0 then begin
                            VendLedgEntry.CalcFields("Remaining Amount");
                            AppliedVendLedgEntry.SetFilter("Entry No.", '<>%1', VendLedgEntry."Entry No.");

                        end;

                        HandleChosenEntries(
                            CalcType::Direct, VendLedgEntry."Remaining Amount", VendLedgEntry."Currency Code", VendLedgEntry."Posting Date");
                    end;
                CalcType::"Gen. Jnl. Line":
                    begin
                        FindAmountRounding();
                        if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor then
                            CODEUNIT.Run(CODEUNIT::"Exchange Acc. G/L Journal Line", GenJnlLine);

                        case ApplnType of
                            ApplnType::"Applies-to Doc. No.":
                                begin
                                    AppliedVendLedgEntry := Rec;
                                    AppliedVendLedgEntry.CalcFields("Remaining Amount");
                                    if AppliedVendLedgEntry."Currency Code" <> ApplnCurrencyCode then begin
                                        AppliedVendLedgEntry."Remaining Amount" :=
                                        CurrExchRate.ExchangeAmtFCYToFCY(
                                            ApplnDate, AppliedVendLedgEntry."Currency Code", ApplnCurrencyCode, AppliedVendLedgEntry."Remaining Amount");
                                        AppliedVendLedgEntry."Remaining Pmt. Disc. Possible" :=
                                        CurrExchRate.ExchangeAmtFCYToFCY(
                                            ApplnDate, AppliedVendLedgEntry."Currency Code", ApplnCurrencyCode, AppliedVendLedgEntry."Remaining Pmt. Disc. Possible");
                                        AppliedVendLedgEntry."Amount to Apply" :=
                                        CurrExchRate.ExchangeAmtFCYToFCY(
                                            ApplnDate, AppliedVendLedgEntry."Currency Code", ApplnCurrencyCode, AppliedVendLedgEntry."Amount to Apply");
                                    end;

                                    if AppliedVendLedgEntry."Amount to Apply" <> 0 then
                                        AppliedAmount := Round(AppliedVendLedgEntry."Amount to Apply", AmountRoundingPrecision)
                                    else
                                        AppliedAmount := Round(AppliedVendLedgEntry."Remaining Amount", AmountRoundingPrecision);

                                    if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(
                                        GenJnlLine, AppliedVendLedgEntry, 0, false) and
                                    ((Abs(GenJnlLine.Amount) + ApplnRoundingPrecision >=
                                        Abs(AppliedAmount - AppliedVendLedgEntry."Remaining Pmt. Disc. Possible")) or
                                        (GenJnlLine.Amount = 0))
                                    then
                                        PmtDiscAmount := AppliedVendLedgEntry."Remaining Pmt. Disc. Possible";

                                    if not DifferentCurrenciesInAppln then
                                        DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedVendLedgEntry."Currency Code";
                                    CheckRounding();
                                end;
                            ApplnType::"Applies-to ID":
                                begin
                                    GenJnlLine2 := GenJnlLine;
                                    AppliedVendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                                    AppliedVendLedgEntry.SetRange("Vendor No.", GenJnlLine."Account No.");
                                    AppliedVendLedgEntry.SetRange(Open, true);
                                    AppliedVendLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");

                                    HandleChosenEntries(
                                        CalcType::"Gen. Jnl. Line", GenJnlLine2.Amount, GenJnlLine2."Currency Code", GenJnlLine2."Posting Date");
                                end;
                        end;
                    end;
                CalcType::"Purchase Header":
                    begin
                        FindAmountRounding();

                        case ApplnType of
                            ApplnType::"Applies-to Doc. No.":
                                begin
                                    AppliedVendLedgEntry := Rec;
                                    AppliedVendLedgEntry.CalcFields("Remaining Amount");

                                    if AppliedVendLedgEntry."Currency Code" <> ApplnCurrencyCode then
                                        AppliedVendLedgEntry."Remaining Amount" :=
                                        CurrExchRate.ExchangeAmtFCYToFCY(
                                            ApplnDate, AppliedVendLedgEntry."Currency Code", ApplnCurrencyCode, AppliedVendLedgEntry."Remaining Amount");

                                    AppliedAmount := AppliedAmount + Round(AppliedVendLedgEntry."Remaining Amount", AmountRoundingPrecision);

                                    if not DifferentCurrenciesInAppln then
                                        DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedVendLedgEntry."Currency Code";
                                    CheckRounding();
                                end;
                            ApplnType::"Applies-to ID":
                                begin
                                    AppliedVendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                                    AppliedVendLedgEntry.SetRange("Vendor No.", PurchHeader."Pay-to Vendor No.");
                                    AppliedVendLedgEntry.SetRange(Open, true);
                                    AppliedVendLedgEntry.SetRange("Applies-to ID", PurchHeader."Applies-to ID");

                                    HandleChosenEntries(CalcType::"Purchase Header", ApplyingAmount, ApplnCurrencyCode, ApplnDate);
                                end;
                        end;
                    end;
            end;
        end;
    end;

    protected procedure CalcApplnRemainingAmount(Amount: Decimal): Decimal
    var
        ApplnRemainingAmount: Decimal;
    begin
        ValidExchRate := true;
        if ApplnCurrencyCode = Rec."Currency Code" then
            exit(Amount);

        if ApplnDate = 0D then
            ApplnDate := Rec."Posting Date";
        ApplnRemainingAmount :=
          CurrExchRate.ApplnExchangeAmtFCYToFCY(
            ApplnDate, Rec."Currency Code", ApplnCurrencyCode, Amount, ValidExchRate);

        exit(ApplnRemainingAmount);
    end;


    protected procedure FindAmountRounding()
    begin
        if ApplnCurrencyCode = '' then begin
            Currency.Init();
            Currency.Code := '';
            Currency.InitRoundingPrecision();
        end else
            if ApplnCurrencyCode <> Currency.Code then
                Currency.Get(ApplnCurrencyCode);

        AmountRoundingPrecision := Currency."Amount Rounding Precision";
    end;

    procedure CheckRounding()
    begin
        // ApplnRounding := 0;

        case CalcType of
            CalcType::"Purchase Header":
                exit;
            CalcType::"Gen. Jnl. Line":
                if (GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Payment) and
                   (GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Refund)
                then
                    exit;
        end;

        if ApplnCurrencyCode = '' then
            ApplnRoundingPrecision := GLSetup."Appln. Rounding Precision"
        else begin
            if ApplnCurrencyCode <> Rec."Currency Code" then
                Currency.Get(ApplnCurrencyCode);
            ApplnRoundingPrecision := Currency."Appln. Rounding Precision";
        end;

        // if (Abs((AppliedAmount - PmtDiscAmount) + ApplyingAmount) <= ApplnRoundingPrecision) and DifferentCurrenciesInAppln then
        //     ApplnRounding := -((AppliedAmount - PmtDiscAmount) + ApplyingAmount);
    end;

    procedure GetVendLedgEntry(var parVendLedgEntry: Record "Vendor Ledger Entry")
    begin
        parVendLedgEntry := Rec;
    end;

    local procedure FindApplyingEntry()
    begin
        if CalcType = CalcType::Direct then begin
            VendEntryApplID := UserId;
            if VendEntryApplID = '' then
                VendEntryApplID := '***';

            VendLedgEntry.SetCurrentKey("Vendor No.", "Applies-to ID", Open);
            VendLedgEntry.SetRange("Vendor No.", Rec."Vendor No.");
            if AppliesToID = '' then
                VendLedgEntry.SetRange("Applies-to ID", VendEntryApplID)
            else
                VendLedgEntry.SetRange("Applies-to ID", AppliesToID);
            VendLedgEntry.SetRange(Open, true);
            VendLedgEntry.SetRange("Applying Entry", true);
            if VendLedgEntry.FindFirst() then begin
                VendLedgEntry.CalcFields(Amount, "Remaining Amount");
                TempApplyingVendLedgEntry := VendLedgEntry;
                Rec.SetFilter("Entry No.", '<>%1', VendLedgEntry."Entry No.");
                Rec.SetFilter("ecApplies-to ID Customs Agency", ' ');
                ApplyingAmount := VendLedgEntry."Remaining Amount";
                ApplnDate := VendLedgEntry."Posting Date";
                ApplnCurrencyCode := VendLedgEntry."Currency Code";
            end;
            CalcApplnAmount();
        end;
    end;

    protected procedure HandleChosenEntries(Type: Enum "Vendor Apply Calculation Type"; CurrentAmount: Decimal; parCurrencyCode: Code[10]; parPostingDate: Date)
    var
        TempAppliedVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        PossiblePmtDisc: Decimal;
        OldPmtDisc: Decimal;
        CorrectionAmount: Decimal;
        RemainingAmountExclDiscounts: Decimal;
        CanUseDisc: Boolean;
        FromZeroGenJnl: Boolean;
        IsHandled: Boolean;
    begin
        OldPmtDisc := 0;
        CorrectionAmount := 0;
        IsHandled := false;
        if IsHandled then
            exit;

        // if not AppliedVendLedgEntry.FindSet(false, false) then
        //     exit;

        repeat
            TempAppliedVendLedgEntry := AppliedVendLedgEntry;
            TempAppliedVendLedgEntry.Insert();
        until AppliedVendLedgEntry.Next() = 0;

        FromZeroGenJnl := (CurrentAmount = 0) and (Type = Type::"Gen. Jnl. Line");

        repeat
            if not FromZeroGenJnl then
                TempAppliedVendLedgEntry.SetRange(Positive, CurrentAmount < 0);
            if TempAppliedVendLedgEntry.FindFirst() then begin
                ExchangeLedgerEntryAmounts(Type, parCurrencyCode, TempAppliedVendLedgEntry, parPostingDate);

                case Type of
                    Type::Direct:
                        CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscVend(VendLedgEntry, TempAppliedVendLedgEntry, 0, false, false);
                    Type::"Gen. Jnl. Line":
                        CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine2, TempAppliedVendLedgEntry, 0, false)
                    else
                        CanUseDisc := false;
                end;

                if CanUseDisc and
                   (Abs(TempAppliedVendLedgEntry."Amount to Apply") >=
                    Abs(TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible"))
                then
                    if Abs(CurrentAmount) >
                       Abs(TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible")
                    then begin
                        PmtDiscAmount += TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
                        CurrentAmount += TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
                    end else
                        if Abs(CurrentAmount) =
                           Abs(TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible")
                        then begin
                            PmtDiscAmount += TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
                            CurrentAmount +=
                              TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
                            AppliedAmount += CorrectionAmount;
                        end else
                            if FromZeroGenJnl then begin
                                PmtDiscAmount += TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
                                CurrentAmount +=
                                  TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
                            end else begin
                                PossiblePmtDisc := TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
                                RemainingAmountExclDiscounts :=
                                  TempAppliedVendLedgEntry."Remaining Amount" - PossiblePmtDisc - TempAppliedVendLedgEntry."Max. Payment Tolerance";
                                if Abs(CurrentAmount) + Abs(CalcOppositeEntriesAmount(TempAppliedVendLedgEntry)) >=
                                   Abs(RemainingAmountExclDiscounts)
                                then begin
                                    PmtDiscAmount += PossiblePmtDisc;
                                    AppliedAmount += CorrectionAmount;
                                end;
                                CurrentAmount +=
                                  TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
                            end
                else begin
                    if ((CurrentAmount + TempAppliedVendLedgEntry."Amount to Apply") * CurrentAmount) >= 0 then
                        AppliedAmount += CorrectionAmount;
                    CurrentAmount += TempAppliedVendLedgEntry."Amount to Apply";
                end;
            end else begin
                TempAppliedVendLedgEntry.SetRange(Positive);
                TempAppliedVendLedgEntry.FindFirst();
                ExchangeLedgerEntryAmounts(Type, parCurrencyCode, TempAppliedVendLedgEntry, parPostingDate);
            end;

            if OldPmtDisc <> PmtDiscAmount then
                AppliedAmount += TempAppliedVendLedgEntry."Remaining Amount"
            else
                AppliedAmount += TempAppliedVendLedgEntry."Amount to Apply";
            OldPmtDisc := PmtDiscAmount;

            if PossiblePmtDisc <> 0 then
                CorrectionAmount := TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Amount to Apply"
            else
                CorrectionAmount := 0;

            if not DifferentCurrenciesInAppln then
                DifferentCurrenciesInAppln := ApplnCurrencyCode <> TempAppliedVendLedgEntry."Currency Code";

            TempAppliedVendLedgEntry.Delete();
            TempAppliedVendLedgEntry.SetRange(Positive);

        until not TempAppliedVendLedgEntry.FindFirst();
        CheckRounding();
    end;

    procedure SetAppliesToID(AppliesToID2: Code[50])
    begin
        AppliesToID := AppliesToID2;
    end;

    protected procedure ExchangeLedgerEntryAmounts(Type: Enum "Vendor Apply Calculation Type"; CurrencyCodes: Code[10]; var CalcVendLedgEntry: Record "Vendor Ledger Entry"; PostingDates: Date)
    var
        CalculateCurrency: Boolean;
    begin
        CalcVendLedgEntry.CalcFields("Remaining Amount");

        if Type = Type::Direct then
            CalculateCurrency := TempApplyingVendLedgEntry."Entry No." <> 0
        else
            CalculateCurrency := true;

        if (CurrencyCodes <> CalcVendLedgEntry."Currency Code") and CalculateCurrency then begin
            CalcVendLedgEntry."Remaining Amount" :=
              CurrExchRate.ExchangeAmount(
                CalcVendLedgEntry."Remaining Amount", CalcVendLedgEntry."Currency Code", CurrencyCodes, PostingDates);
            CalcVendLedgEntry."Remaining Pmt. Disc. Possible" :=
              CurrExchRate.ExchangeAmount(
                CalcVendLedgEntry."Remaining Pmt. Disc. Possible", CalcVendLedgEntry."Currency Code", CurrencyCodes, PostingDates);
            CalcVendLedgEntry."Amount to Apply" :=
              CurrExchRate.ExchangeAmount(
                CalcVendLedgEntry."Amount to Apply", CalcVendLedgEntry."Currency Code", CurrencyCodes, PostingDates);
        end;
    end;

    local procedure ActivateFields()
    begin
        CalledFromEntry := CalcType = CalcType::Direct;
        AppliesToIDVisible := ApplnType <> ApplnType::"Applies-to Doc. No.";
    end;


    procedure CalcOppositeEntriesAmount(var TempAppliedVendorLedgerEntry: Record "Vendor Ledger Entry" temporary) Result: Decimal
    var
        SavedAppliedVendorLedgerEntry: Record "Vendor Ledger Entry";
        CurrPosFilter: Text;
    begin
        CurrPosFilter := TempAppliedVendorLedgerEntry.GetFilter(Positive);
        if CurrPosFilter <> '' then begin
            SavedAppliedVendorLedgerEntry := TempAppliedVendorLedgerEntry;
            TempAppliedVendorLedgerEntry.SetRange(Positive, not TempAppliedVendorLedgerEntry.Positive);
            if TempAppliedVendorLedgerEntry.FindSet() then
                repeat
                    TempAppliedVendorLedgerEntry.CalcFields("Remaining Amount");
                    Result += TempAppliedVendorLedgerEntry."Remaining Amount";
                until TempAppliedVendorLedgerEntry.Next() = 0;
            TempAppliedVendorLedgerEntry.SetFilter(Positive, CurrPosFilter);
            TempAppliedVendorLedgerEntry := SavedAppliedVendorLedgerEntry;
        end;
    end;
}
