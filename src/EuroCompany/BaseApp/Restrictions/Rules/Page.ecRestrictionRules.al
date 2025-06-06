namespace EuroCompany.BaseApp.Restrictions.Rules;

using EuroCompany.BaseApp.Restrictions;

page 50045 "ecRestriction Rules"
{
    ApplicationArea = All;
    Caption = 'Restriction Rules';
    CardPageId = "ecRestriction Rule";
    Description = 'CS_PRO_011';
    Editable = false;
    PageType = List;
    SourceTable = "ecRestriction Rule Header";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Code"; Rec."Code") { }
                field(Description; Rec.Description) { }
                field(Status; Rec.Status) { }
                field("Usage Note"; Rec."Usage Note") { }
                field("Short Description"; Rec."Short Description") { }
            }
        }

        area(FactBoxes)
        {
            part(RuleMetalanguageFactBox; "ecRestr. Rule Metalanguage")
            {
                SubPageLink = "Rule Code" = field(Code);
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(ChangeStatus)
            {
                Caption = 'Change Status';

                action(ReOpenAct)
                {
                    Caption = 'Reopen';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        lecRestrictionsMgt: Codeunit "ecRestrictions Mgt.";
                    begin
                        if (Rec.Code <> '') then begin
                            lecRestrictionsMgt.ReopenRestrictionRule(Rec);
                        end;
                    end;
                }
                action(CertifyAct)
                {
                    Caption = 'Certify';
                    Image = Lock;

                    trigger OnAction()
                    var
                        lecRestrictionsMgt: Codeunit "ecRestrictions Mgt.";
                    begin
                        if (Rec.Code <> '') then begin
                            lecRestrictionsMgt.CertifyRestrictionRule(Rec);
                        end;
                    end;
                }
                action(BlockAct)
                {
                    Caption = 'Block';
                    Image = Lock;

                    trigger OnAction()
                    var
                        lecRestrictionsMgt: Codeunit "ecRestrictions Mgt.";
                    begin
                        if (Rec.Code <> '') then begin
                            lecRestrictionsMgt.BlockRestrictionRule(Rec);
                        end;
                    end;
                }
            }
        }

        area(Promoted)
        {
            actionref(ReOpenRef; ReOpenAct) { }
            actionref(CertifyActRef; CertifyAct) { }
            actionref(BlockActRef; BlockAct) { }
        }
    }

}
