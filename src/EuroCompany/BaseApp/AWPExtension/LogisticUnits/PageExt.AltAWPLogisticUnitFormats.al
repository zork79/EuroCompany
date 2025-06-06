namespace EuroCompany.BaseApp.AWPExtension.LogisticUnits;

pageextension 80200 "AltAWPLogistic Unit Formats" extends "AltAWPLogistic Unit Formats"
{
    layout
    {
        addafter(Description)
        {
            field("ecPallet Grouping Code"; Rec."ecPallet/Box Grouping Code")
            {
                ApplicationArea = All;
            }
            field("ecCHEP Gtin"; Rec."ecCHEP Gtin")
            {
                ApplicationArea = All;
            }
        }
    }
}