namespace EuroCompany.BaseApp.Sales.Commissions;

//AFC_CS_005
page 50065 "ecAgent Contr Except Setup"
{
    PageType = list;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ecAgent Contr Except Setup";
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;
    Caption = 'Agent Contract Exceptions Setup';
    Description = 'AFC_CS_005';
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(rptr)
            {
                //ShowCaption = false;                      

                field("Commission Posting Group"; Rec."Commission Posting Group")
                {
                    ApplicationArea = All;
                    Caption = 'Commission Posting Group';
                    Description = 'AFC_CS_005';
                }
                field("Name Commission Posting Group"; Rec."Name Commission Posting Group")
                {
                    ApplicationArea = All;
                    Caption = 'Name Commission Posting Group';
                    Description = 'AFC_CS_005';
                    Editable = false;
                }
                field("Customer Type"; Rec."Customer Type")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Type';
                    Description = 'AFC_CS_005';
                }
                field("Customer Type Code"; Rec."Customer Type Code")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Type Code';
                    Description = 'AFC_CS_005';
                }
                field("Name Customer Type Code"; Rec."Name Customer Type Code")
                {
                    ApplicationArea = All;
                    Caption = 'Name Customer Type Code';
                    Description = 'AFC_CS_005';
                    Editable = false;
                }

                field("Role Code"; Rec."Role Code")
                {
                    ApplicationArea = All;
                    Caption = 'Role Code';
                    Description = 'AFC_CS_005';
                }

                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Item Type';
                    Description = 'AFC_CS_005';
                }
                field("Item Type Code"; Rec."Item Type Code")
                {
                    ApplicationArea = All;
                    Caption = 'Item Type Code';
                    Description = 'AFC_CS_005';
                }
                field("Name Item Type Code"; Rec."Name Item Type Code")
                {
                    ApplicationArea = All;
                    Caption = 'Name Item Type Code';
                    Description = 'AFC_CS_005';
                    Editable = false;
                }
                field("Salesperson Commission"; Rec."Salesperson Commission")
                {
                    ApplicationArea = All;
                    Caption = 'Salesperson Commission';
                    Description = 'AFC_CS_005';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    Description = 'AFC_CS_005';
                }
            }
        }
    }
}