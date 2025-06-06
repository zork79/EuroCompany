namespace EuroCompany.BaseApp.Sales.AdvancedTrade;

page 50030 "ecSales Manager"
{
    ApplicationArea = All;
    Caption = 'Sales Manager';
    Description = 'CS_VEN_031';
    PageType = Card;
    SourceTable = "ecSales Manager";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec."Code") { }
                field(Name; Rec.Name) { }
                field(Blocked; Rec.Blocked) { }

                field("E-Mail"; Rec."E-Mail") { }
                field("Phone No."; Rec."Phone No.") { }
            }

            group(Log)
            {
                Caption = 'Log';

                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Editable = false;
                }
                field(SystemCreatedBy; atsSystemUtilities.GetUserNameBySecurityID(Rec.SystemCreatedBy))
                {
                    Caption = 'Created By', Comment = 'Creato da';
                    Editable = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    Editable = false;
                }
                field(SystemModifiedBy; atsSystemUtilities.GetUserNameBySecurityID(Rec.SystemModifiedBy))
                {
                    Caption = 'Modified By', Comment = 'Modificato da';
                    Editable = false;
                }
            }
        }
    }

    var
        atsSystemUtilities: Codeunit "AltATSSystem Utilities";

}
