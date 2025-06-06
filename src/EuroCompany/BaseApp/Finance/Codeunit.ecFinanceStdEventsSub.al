namespace EuroCompany.BaseApp.Finance;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.VAT.Ledger;
using Microsoft.Finance.VAT.Setup;

codeunit 50009 "ecFinance Std. Events Sub."
{
    #region 368
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertVATEntry', '', true, true)]
    local procedure OnBeforeInsertVATEntry(var VATEntry: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line"; var NextVATEntryNo: Integer; var TempGLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link" temporary; var TempGLEntryBuf: Record "G/L Entry" temporary; GLRegister: Record "G/L Register")
    var
        VATPostSetupLOC: Record "VAT Posting Setup";
    begin
        if VATPostSetupLOC.Get(GenJournalLine."VAT Bus. Posting Group", GenJournalLine."VAT Prod. Posting Group") then
            VATEntry."ecInclude in OSS VAT Sett." := VATPostSetupLOC."ecInclude in OSS VAT Sett.";
    end;
    #endregion 368
}