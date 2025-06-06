namespace EuroCompany.BaseApp.Restrictions;
using EuroCompany.BaseApp.Restrictions.Rules;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;

page 50050 "ecCommercial/Productive Restr."
{
    ApplicationArea = All;
    Caption = 'Commercial and Productive Restrictions';
    DelayedInsert = true;
    Description = 'CS_PRO_011';
    PageType = Worksheet;
    PopulateAllFields = true;
    SourceTable = "ecCommercial/Productive Restr.";
    SourceTableView = sorting(Scope, "Application Type", "No.", "Variant Code", "Relation Type", "Relation No.", "Relation Detail No.", "Starting Date") order(ascending);
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(gOptions)
            {
                ShowCaption = false;

                field(fScopeFilter; ScopeFilter)
                {
                    Caption = 'Scope';

                    trigger OnValidate()
                    begin
                        if (Rec."No." <> '') or (Rec."Restriction Rule Code" <> '') then begin
                            CurrPage.SaveRecord();
                        end;

                        if (ScopeFilter = ScopeFilter::" ") then begin
                            ScopeFilter := Rec.Scope;
                        end;

                        ReloadPage();
                    end;
                }
            }

            repeater(General)
            {
                field("Application Type"; Rec."Application Type")
                {
                }
                field("No."; Rec."No.")
                {
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                }
                field(ItemDescription; Rec.GetItemDescription(Rec."No.", Rec."Variant Code"))
                {
                    Caption = 'Item Description';
                    Editable = false;
                }
                field("Relation Type"; Rec."Relation Type")
                {
                }
                field("Relation No."; Rec."Relation No.")
                {
                }
                field("Relation Detail No."; Rec."Relation Detail No.")
                {
                    Visible = false;
                }
                field("Relation Name"; Rec.GetRelationName())
                {
                    Caption = 'Relation Description';
                    Editable = false;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("Restriction Rule Code"; Rec."Restriction Rule Code")
                {
                }
                field("Restriction Rule Description"; Rec."Restriction Rule Description")
                {
                    DrillDown = false;
                }
                field("Single Lot Pickings"; Rec."Single Lot Pickings")
                {
                    Visible = IsProductionScope or IsSalesScope;
                }
                field("Progressive Lot No. Expiration"; Rec."Progressive Lot No. Expiration")
                {
                    Visible = IsSalesScope;
                }
                field("Negative Result Notification"; Rec."Negative Result Notification")
                {
                }
            }
        }

        area(FactBoxes)
        {
            part(RuleMetalanguageFactBox; "ecRestr. Rule Metalanguage")
            {
                SubPageLink = "Rule Code" = field("Restriction Rule Code");
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ShowRestrictionRuleAct)
            {
                Caption = 'Show Rule';
                Enabled = (Rec."Restriction Rule Code" <> '');
                Image = CheckRulesSyntax;
                RunObject = page "ecRestriction Rule";
                RunPageLink = Code = field("Restriction Rule Code");
            }
        }

        area(Promoted)
        {
            actionref(ShowRestrictionRuleActRef; ShowRestrictionRuleAct) { }
        }
    }

    var
        ScopeFilter: Enum "ecRestr. Application Scope";
        IsProductionScope: Boolean;
        IsSalesScope: Boolean;

    trigger OnOpenPage()
    begin
        SetPageFilters();

        IsProductionScope := (ScopeFilter = ScopeFilter::Production);
        IsSalesScope := (ScopeFilter = ScopeFilter::Sales);
    end;

    local procedure SetPageFilters()
    begin
        if (ScopeFilter = ScopeFilter::" ") then begin
            ScopeFilter := ScopeFilter::Production;
        end;

        Rec.FilterGroup(2);
        Rec.SetRange(Scope, ScopeFilter);
        Rec.FilterGroup(0);

        CurrPage.Update(false);
    end;

    internal procedure SetScopeFilter(pScopeFilter: Enum "ecRestr. Application Scope")
    begin
        ScopeFilter := pScopeFilter;
    end;

    local procedure ReloadPage()
    var
        lCommercialProductiveRestrPage: Page "ecCommercial/Productive Restr.";
    begin
        CurrPage.Close();

        Clear(lCommercialProductiveRestrPage);
        lCommercialProductiveRestrPage.SetScopeFilter(ScopeFilter);
        lCommercialProductiveRestrPage.Run();
    end;
}
