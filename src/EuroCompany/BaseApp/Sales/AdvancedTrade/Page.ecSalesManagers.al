namespace EuroCompany.BaseApp.Sales.AdvancedTrade;

page 50029 "ecSales Managers"
{
    ApplicationArea = All;
    Caption = 'Sales Managers';
    CardPageId = "ecSales Manager";
    Description = 'CS_VEN_031';
    Editable = false;
    PageType = List;
    SourceTable = "ecSales Manager";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code") { }
                field(Name; Rec.Name) { }
                field(Blocked; Rec.Blocked) { }
                field("E-Mail"; Rec."E-Mail") { Visible = false; }
                field("Phone No."; Rec."Phone No.") { Visible = false; }
            }
        }
    }
}
