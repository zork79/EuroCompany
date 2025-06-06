
namespace EuroCompany.BaseApp.Finance.VAT.Ledger;

using Microsoft.Finance.VAT.Ledger;
tableextension 80028 "VAT Book Entry" extends "VAT Book Entry"
{
    fields
    {
        field(50000; "ecInclude in OSS VAT Sett."; Boolean)
        {
            CalcFormula = lookup("VAT Entry"."ecInclude in OSS VAT Sett." where("Document No." = field("Document No."),
                                                                               "Type" = field("Type"),
                                                                               "VAT Bus. Posting Group" = field("VAT Bus. Posting Group"),
                                                                               "VAT Prod. Posting Group" = field("VAT Prod. Posting Group"),
                                                                               "VAT %" = field("VAT %"),
                                                                               "Deductible %" = field("Deductible %"),
                                                                               "VAT Identifier" = field("VAT Identifier"),
                                                                               "Transaction No." = field("Transaction No."),
                                                                               "Unrealized VAT Entry No." = field("Unrealized VAT Entry No.")));
            Caption = 'Include in OSS VAT Sett.';
            Description = 'F124';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}