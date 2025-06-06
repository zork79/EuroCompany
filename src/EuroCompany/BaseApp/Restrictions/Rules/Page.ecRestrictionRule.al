namespace EuroCompany.BaseApp.Restrictions.Rules;

using EuroCompany.BaseApp.Restrictions;

page 50046 "ecRestriction Rule"
{
    ApplicationArea = All;
    Caption = 'Restriction Rule';
    Description = 'CS_PRO_011';
    PageType = Document;
    SourceTable = "ecRestriction Rule Header";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = PageEditable;

                group(General_Left)
                {
                    ShowCaption = false;

                    field("Code"; Rec."Code") { }
                    field(Description; Rec.Description) { MultiLine = true; }
                }

                group(General_Right)
                {
                    ShowCaption = false;

                    field(Status; Rec.Status) { }
                    field("Short Description"; Rec."Short Description") { }
                    field("Usage Note"; Rec."Usage Note") { MultiLine = true; }
                }
            }

            part(RuleConditions; "ecRestriction Rule Conditions")
            {
                Editable = PageEditable;
                SubPageLink = "Rule Code" = field(Code);
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
                            CurrPage.SaveRecord();
                            lecRestrictionsMgt.ReopenRestrictionRule(Rec);
                            CurrPage.Update(true);
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
                            CurrPage.SaveRecord();
                            lecRestrictionsMgt.CertifyRestrictionRule(Rec);
                            CurrPage.Update(true);
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
                            CurrPage.SaveRecord();
                            lecRestrictionsMgt.BlockRestrictionRule(Rec);
                            CurrPage.Update(true);
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

    var
        PageEditable: Boolean;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        PageEditable := true;
    end;

    trigger OnAfterGetRecord()
    begin
        PageEditable := (Rec.Status = Rec.Status::Open);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        PageEditable := (Rec.Status = Rec.Status::Open);
    end;
}
