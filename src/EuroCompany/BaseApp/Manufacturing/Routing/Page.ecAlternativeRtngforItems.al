namespace EuroCompany.BaseApp.Manufacturing.Routing;

page 50004 "ecAlternative Rtng for Items"
{
    ApplicationArea = All;
    Caption = 'Alternative Routing for Items';
    DelayedInsert = true;
    Description = 'GAP_PRO_003';
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "ecAlternative Routing for Item";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Routing No."; Rec."Routing No.")
                {
                }
                field("Routing Description"; Rec."Routing Description")
                {
                }
                field("Production Process Type"; Rec."Production Process Type")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        lSessionDataStore: Codeunit "AltATSSession Data Store";
    begin
        if lSessionDataStore.GetSessionSettingBooleanValue('PageAlternativeRoutingItemsLookupTemp') then begin
            CurrPage.Editable(false);
        end;
    end;
}
