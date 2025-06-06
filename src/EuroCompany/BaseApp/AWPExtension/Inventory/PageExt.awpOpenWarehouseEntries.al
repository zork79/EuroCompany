namespace EuroCompany.BaseApp.AWPExtension.Inventory;
using EuroCompany.BaseApp.Manufacturing;
using EuroCompany.BaseApp.Restrictions;

pageextension 80156 "awpOpen Warehouse Entries" extends "AltAWPOpen Warehouse Entries"
{
    layout
    {
        addafter("Search Description")
        {
            field("ecItem Type"; Rec."ecItem Type")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_043';
                DrillDown = false;
            }
        }
        addafter("Log. Constraint Reason Code")
        {
            field("ecRestrictions Check Result"; Rec."ecRestrictions Check Result")
            {
                ApplicationArea = All;
                Description = 'CS_PRO_011';
                StyleExpr = ecRestrCheckResultStyle;
                Visible = ecShowRestrictionsInfo;
            }
            field(ecRestrictions; Rec.ecRestrictions)
            {
                ApplicationArea = All;
                Description = 'CS_PRO_011';
                Visible = ecShowRestrictionsInfo;
            }
        }
        addafter("Expiration Date")
        {
            field(MaxUsableDate; MaxUsableDate)
            {
                ApplicationArea = All;
                Caption = 'Usage max date';
                Description = 'CS_PRO_018';
                Editable = false;
                StyleExpr = MaxUsableDateStyle;
            }
        }
    }

    var
        MaxUsableDateStyle: Text;
        ecRestrCheckResultStyle: Text;
        MaxUsableDate: Date;
        ecShowRestrictionsInfo: Boolean;

    trigger OnOpenPage()
    var
        latsSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        //CS_PRO_011-VI-s
        ecShowRestrictionsInfo := latsSessionDataStore.GetSessionSettingBooleanValue('EC_SHOW_RESTRICTION_DETAILS');
        latsSessionDataStore.RemoveSessionSetting('EC_SHOW_RESTRICTION_DETAILS');
        //CS_PRO_011-VI-e
    end;

    trigger OnAfterGetRecord()
    var
        lProductionFunctions: Codeunit "ecProduction Functions";
    begin
        //CS_PRO_011-VI-s
        ecRestrCheckResultStyle := '';
        case Rec."ecRestrictions Check Result" of
            Rec."ecRestrictions Check Result"::"No restriction":
                ecRestrCheckResultStyle := 'Subordinate';

            Rec."ecRestrictions Check Result"::Passed:
                ecRestrCheckResultStyle := 'Favorable';

            Rec."ecRestrictions Check Result"::Error:
                ecRestrCheckResultStyle := 'Unfavorable';

            Rec."ecRestrictions Check Result"::Warning:
                ecRestrCheckResultStyle := 'Attention';
        end;
        //CS_PRO_011-VI-e

        //CS_PRO_013-s
        MaxUsableDate := lProductionFunctions.CalcMaxUsableDateForItem(Rec."Item No.", '', '', Rec."Expiration Date");
        MaxUsableDateStyle := 'Favorable';
        if (MaxUsableDate < Today) then MaxUsableDateStyle := 'Unfavorable';
        //CS_PRO_013-e
    end;
}
